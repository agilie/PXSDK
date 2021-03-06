//
//  PXTrackerCore.m
//  PXSDK
//

#import "PXTrackerCore.h"
#import "Lockbox.h"
#import "PXNetwork.h"
#import "NSString+MD5.h"
#import "PXEventBuffer.h"
#import "PXDefines.h"
#import "PXUser.h"

@interface PXTrackerCore ()

@property (strong, nonatomic) NSCalendar *calendar;
@property (strong, nonatomic) NSUserDefaults *userDefaults;

@end

@implementation PXTrackerCore

- (id)init {
    if (self = [super init]) {
        [self resetSession];
        self.uuid = [self getUniqueDeviceIdentifierAsString];
        self.network = [[PXNetwork alloc] init];
        self.eventBuffer = [[PXEventBuffer alloc] init];
        [self setupCoreTimers];
        [self setupNSNotificationCenter];
    }
    return self;
}

#pragma mark - Getters

- (NSUserDefaults *)userDefaults {
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}

- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}

- (NSDateComponents *)dateComponents {
    return [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
}

- (void)setupNSNotificationCenter {

    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self resetSession];
        [self sendGeneralEventWithName:@"launch" andParams:nil];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self resetSession];
        [self sendGeneralEventWithName:@"resumed" andParams:nil];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self sendGeneralEventWithName:@"background" andParams:nil];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self sendGeneralEventWithName:@"killed" andParams:nil];
    }];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.realtimeTimer invalidate];
    self.realtimeTimer = nil;
    [self.cacheTimer invalidate];
    self.cacheTimer = nil;
}

- (void)setupUserPredictionsForToken:(NSString *)token {
    NSCharacterSet *angleBrackets = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
    NSString *clearToken = [[token description] stringByTrimmingCharactersInSet:angleBrackets];
    self.deviceToken = [clearToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *requestUrl = [NSString stringWithFormat:kPXGetUserPredictionsUrl, self.gameKey, self.uuid];
    __weak typeof(self) weakSelf = self;
    [self.network getRequestWithUrl:requestUrl completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            weakSelf.user = [[PXUser alloc] initWithDictonary:dictionary];
            [weakSelf setCurrentUserDateIAPOffer:weakSelf.user.dateForIAPOffer];
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kPXRequestUserPredictionsInterval * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [weakSelf setupUserPredictionsForToken:token];
            });
        }
    }];
}

- (void)setupCoreTimers {
    self.realtimeTimer = [NSTimer scheduledTimerWithTimeInterval:kPXDynamicUpdateInterval target:self selector:@selector(dynamicTimerFire:) userInfo:nil repeats:YES];
    self.cacheTimer = [NSTimer scheduledTimerWithTimeInterval:kPXCacheUpdateInterval target:self selector:@selector(cacheTimerFire:) userInfo:nil repeats:YES];
}

- (void)dynamicTimerFire:(id)sender {
    if ([self.eventBuffer dataFromBuffer].length > 0 && self.network.available) {
        NSData *data2send = [self makeRequestData:[self.eventBuffer dataFromBuffer]];
        [self.network sendToServiceRawData:data2send completion:^(BOOL succes) {
            if (succes) {
                [self.eventBuffer destroyBuffer];
            } else {
                [self.eventBuffer flushToCacheBuffer];
            }
        }];
    }
}

- (void)cacheTimerFire:(id)sender {
    if ([[self.eventBuffer dataFromCacheBuffer] length] > 0 && self.network.available) {
        NSData *data2send = [self makeRequestData:[self.eventBuffer dataFromCacheBuffer]];
        [self.network sendToServiceRawData:data2send completion:^(BOOL succes) {
            if (succes) {
                [self.eventBuffer destroyCacheBuffer];
            }
        }];
    }
}

- (BOOL)shouldSendData {
    return (self.enableToken && self.deviceToken) || (!self.enableToken);
}

- (BOOL)userHasIAPOffer {
    [self checkIfAlreadyNewDate];
    if (self.user) {
        NSTimeInterval spentTime = [NSDate date].timeIntervalSince1970 - self.currentSessionTimeStart;
        return [self.user.timeForIAPOffer doubleValue] < spentTime && [self.user.levelForIAPOffer isEqualToNumber:self.curentUserLevel] &&
        [self.currentUserDateIAPOffer compare:[NSDate date]] == NSOrderedSame;
    }
    return NO;
}

- (NSString *)getUniqueDeviceIdentifierAsString {
    NSString *strApplicationUUID = [Lockbox stringForKey:kPXLockboxUUDIDKey];
    if (strApplicationUUID == nil) {
        strApplicationUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [Lockbox setString:strApplicationUUID forKey:kPXLockboxUUDIDKey];
    }
    return strApplicationUUID;
}

+ (NSString *)generateRandomString:(NSUInteger)num {
    NSMutableString *string = [NSMutableString stringWithCapacity:num];
    for (int i = 0; i < num; i++) {
        [string appendFormat:@"%C", (unichar)('a' + arc4random_uniform(25))];
    }
    return string;
}

- (NSString *)generateUniqueSessionString {
    return [[NSString stringWithFormat:@"%.0f%@%@",
                                       [[NSDate date] timeIntervalSince1970],
                                       self.uuid,
                                       [PXTrackerCore generateRandomString:10]] MD5];
}

- (void)resetSession {
    self.currentSession = [self generateUniqueSessionString];
    self.currentSessionTimeStart = [NSDate date].timeIntervalSince1970;
}

- (NSNumber *)curentUserLevel {
    NSString *result = [self.userDefaults objectForKey:kPXLevelKeyStore];
    if (result) {
        return [self.userDefaults objectForKey:kPXLevelKeyStore];
    } else {
        [self.userDefaults setObject:@0 forKey:kPXLevelKeyStore];
        [self.userDefaults synchronize];
        return @0;
    }
}

- (void)setCurentUserLevel:(NSNumber *)level {
    [self.userDefaults setObject:level forKey:kPXLevelKeyStore];
    [self.userDefaults synchronize];
}

- (NSDate *)currentUserDateIAPOffer {
    NSNumber *result = [self.userDefaults objectForKey:kPXTriggerDateKeyStore];
    NSDate *dateResult = nil;
    if (result) {
        dateResult = [NSDate dateWithTimeIntervalSince1970:[result doubleValue]];
    } else {
        [self.userDefaults setObject:self.user.dateForIAPOffer forKey:kPXTriggerDateKeyStore];
        [self.userDefaults synchronize];
        dateResult = [NSDate dateWithTimeIntervalSince1970:[self.user.dateForIAPOffer doubleValue]];
    }
    return dateResult;
}

- (void)setCurrentUserDateIAPOffer:(NSNumber *)date {
    [self.userDefaults setObject:date forKey:kPXTriggerDateKeyStore];
    [self.userDefaults synchronize];
}

- (NSData *)makeRequestData:(NSData *)input {

    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];

    NSString *initialJsonData = [NSString stringWithFormat:@" { \"uuid\" : \"%@\" , \"gikey\" : \"%@\" , \"deviceToken\" : \"%@\" , \"countryCode\" : \"%@\" , \"events\" : [", self.uuid, self.gameKey, self.deviceToken, countryCode];
    NSString *endJsonData = @"]}";

    NSMutableData *initialData = [NSMutableData dataWithData:[initialJsonData dataUsingEncoding:NSUTF8StringEncoding]];
    [initialData appendData:input];

    [initialData setLength:initialData.length - [[@"," dataUsingEncoding:NSUTF8StringEncoding] length]];

    [initialData appendData:[endJsonData dataUsingEncoding:NSUTF8StringEncoding]];

    return initialData;
}

- (NSDictionary *)makeRecordDict:(NSDictionary *)input {

    NSString *timeStampSting = [NSString stringWithFormat:@"%1.f", [[NSDate date] timeIntervalSince1970]];

    NSMutableDictionary *tempDictionary = [NSMutableDictionary dictionaryWithDictionary:@{ @"sessionID" : self.currentSession,
            @"timeStamp" : @([timeStampSting intValue]) }];
    [tempDictionary addEntriesFromDictionary:input];

    return tempDictionary;
}


- (void)sendGeneralEventWithName:(NSString *)eventName andParams:(NSDictionary *)params {

    NSMutableDictionary *record = [NSMutableDictionary dictionaryWithDictionary:params];
    [record setObject:eventName forKey:@"eventName"];

    [self.eventBuffer addRecordToBuffer:[self makeRecordDict:record]];

}


- (void)recordTransactionEventWithName:(NSString *)eventName buyVirtualCurrency:(NSString *)buyVirtualCurrency receivingAmount:(NSNumber *)receivingAmount usingRealCurrency:(NSString *)usingRealCurrency spendingAmount:(NSNumber *)spendingAmount {

    [self sendGeneralEventWithName:@"transactionEvent" andParams:@{ @"transactionName" : eventName,
            @"buyVirtualCurrency" : buyVirtualCurrency,
            @"receivingAmount" : receivingAmount,
            @"usingRealCurrency" : usingRealCurrency,
            @"spendingAmount" : spendingAmount }];

};

- (void)recordLevelChangeEventFromLevel:(NSNumber *)fromLevel toLevel:(NSNumber *)toLevel andCurrency:(NSNumber *)currency {

    [self setCurentUserLevel:toLevel];

    [self sendGeneralEventWithName:@"levelChange" andParams:@{ @"fromLevel" : fromLevel,
                                                               @"toLevel"   : toLevel ,
                                                               @"currency" : currency}];
    if ([self userHasIAPOffer] && ![self.userDefaults boolForKey:kPXRewardAlreadyShownToday]) {
        [self showAlertWithTitle:self.user.alertTitle body:self.user.alertBody];
        [self.userDefaults setBool:YES forKey:kPXRewardAlreadyShownToday];
    }
};

- (void)recordTutorialChangeEventFromStep:(NSNumber *)fromStep toStep:(NSNumber *)toStep {

    [self sendGeneralEventWithName:@"tutorialChange" andParams:@{ @"fromStep" : fromStep,
            @"toStep" : toStep }];

};

- (void)recordСurrencyChangeEventWithLevel:(NSNumber *)level andCurrency:(NSNumber *)virtualCurrency {

    [self sendGeneralEventWithName:@"currencyChange" andParams:@{ @"level" : level,
            @"virtualCurrency" : virtualCurrency }];
};

#pragma mark - Alert

- (void)showAlertWithTitle:(NSString *)title body:(NSString *)body {
    [[[UIAlertView alloc] initWithTitle:title? :@"" message:body? : @"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self setupUserPredictionsForToken:self.deviceToken];
        [self resetSession];
    }
}

#pragma mark - Handling of push notification

- (void)processLaunchOptions:(NSDictionary *)launchOptions {
    [self processPushNotification:launchOptions];
}

- (void)processPushNotification:(NSDictionary *)pushNotification {
    PXLog(@"%@",pushNotification);
    [self sendGeneralEventWithName:@"pushReceived" andParams:@{@"pushContent": [pushNotification description]}];
    NSDictionary *payload = [pushNotification objectForKey:@"aps"];
    if ([payload objectForKey:@"alert"]) {
        NSDictionary *alertPayloadDict = [payload objectForKey:@"alert"];
        [self showAlertWithTitle:[alertPayloadDict objectForKey:@"title"] body:[alertPayloadDict objectForKey:@"body"]];
        if ([self.delegate respondsToSelector:@selector(addVirtualCurrency:)]) {
            if ([alertPayloadDict objectForKey:@"custom"]) {
                NSDictionary *customDict = [alertPayloadDict objectForKey:@"custom"];
                [self.delegate addVirtualCurrency:[customDict objectForKey:@"value"]];
            }
        }
    }
}

#pragma mark - Helper

- (void)checkIfAlreadyNewDate {
    NSDate *lastSyncDate = [self.userDefaults objectForKey:kPXRewardLastSyncDate];
    NSDate *beginingOfToday = [self.calendar dateFromComponents:[self dateComponents]];
    if (lastSyncDate) {
        if ([lastSyncDate compare:beginingOfToday] == NSOrderedDescending) {
            [self.userDefaults setBool:NO forKey:kPXRewardAlreadyShownToday];
            [self.userDefaults synchronize];
        }
    }
    [self.userDefaults setObject:[NSDate date] forKey:kPXRewardLastSyncDate];
    [self.userDefaults synchronize];
}

@end
