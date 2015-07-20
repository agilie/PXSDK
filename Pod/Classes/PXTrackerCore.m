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

@implementation PXTrackerCore

- (id)init {
    if (self = [super init]) {
        self.uuid = [self getUniqueDeviceIdentifierAsString];
        self.network = [[PXNetwork alloc] init];
        self.eventBuffer = [[PXEventBuffer alloc] init];
        
        [self setupCoreTimers];
        [self setupUserPredictions];
        [self setupNSNotificationCenter];
        
    }
    return self;
}

- (void)setupNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self resetSession];
        [self sendStateEvent:@"launch"];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self resetSession];
        [self sendStateEvent:@"resumed"];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self sendStateEvent:@"background"];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self sendStateEvent:@"killed"];
    }];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupUserPredictions {
    [self.network getRequestWithUrl:kPXGetUserPredictionsUrl completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.user = [[PXUser alloc] initWithDictonary:dictionary];
        } else {
            
            //TODO: remove this after test
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kPXRequestUserPredictionsInterval * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self setupUserPredictions];
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

- (BOOL)userHasIAPOffer {
    if (self.user) {
        NSTimeInterval spentTime = [NSDate date].timeIntervalSince1970 - self.currentSessionTimeStart;
        return [self.user.params1 doubleValue] < spentTime && [self.user.params2 isEqualToNumber:self.curentUserLevel];
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *result = [userDefaults objectForKey:@"userLevel"];
    if (result) {
        return [userDefaults objectForKey:@"userLevel"];
    } else {
        [userDefaults setObject:@0 forKey:@"userLevel"];
        [userDefaults synchronize];
        return @0;
    }
}

- (void)setCurentUserLevel:(NSNumber *)level {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:level forKey:@"userLevel"];
    [userDefaults synchronize];
}

- (NSData *)makeRequestData:(NSData *)input {
    
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    
    NSString *initialJsonData = [NSString stringWithFormat:@" { \"uuid\" : \"%@\" , \"gikey\" : \"%@\" , \"countryCode\" : \"%@\" , \"events\" : [", self.uuid, self.gameKey, countryCode];
    NSString *endJsonData = @"]}";
    
    NSMutableData *initialData = [NSMutableData dataWithData:[initialJsonData dataUsingEncoding:NSUTF8StringEncoding]];
    [initialData appendData:input];
    
    [initialData setLength:initialData.length - [[@"," dataUsingEncoding:NSUTF8StringEncoding] length]];
    
    [initialData appendData:[endJsonData dataUsingEncoding:NSUTF8StringEncoding]];
    
    return initialData;
}

- (NSDictionary *)makeRecordDict:(NSDictionary *)input {
    
    NSMutableDictionary *tempDictionary = [NSMutableDictionary dictionaryWithDictionary:@{ @"sessionID" : self.currentSession,
                                                                                           @"timeStamp" : @([[NSDate date] timeIntervalSince1970]) }];
    [tempDictionary addEntriesFromDictionary:input];
    
    return tempDictionary;
}

- (void)sendEvent:(NSString *)eventName {
    
    [self.eventBuffer addRecordToBuffer:[self makeRecordDict:@{ @"eventName" : eventName }]];
    
}

- (void)sendStateEvent:(NSString *)eventName {
    
    [self.eventBuffer addRecordToBuffer:[self makeRecordDict:@{ @"eventName" : eventName }]];
    
}

- (void)recordTransactionEventWithName:(NSString *)eventName buyVirtualCurrency:(NSString *)buyVirtualCurrency receivingAmount:(NSNumber *)receivingAmount usingRealCurrency:(NSString *)usingRealCurrency spendingAmount:(NSNumber *)spendingAmount {
    [self.eventBuffer addRecordToBuffer:[self makeRecordDict:
                                           @{ @"eventName" : @"transactionEvent",
                                              @"transactionName" : eventName,
                                              @"buyVirtualCurrency" : buyVirtualCurrency,
                                              @"receivingAmount" : receivingAmount,
                                              @"usingRealCurrency" : usingRealCurrency,
                                              @"spendingAmount" : spendingAmount }]];
    
};

- (void)recordLevelChangeEventFromLevel:(NSNumber *)fromLevel toLevel:(NSNumber *)toLevel {
    
    [self setCurentUserLevel:toLevel];
    
    [self.eventBuffer addRecordToBuffer:[self makeRecordDict:
                                           @{ @"eventName" : @"levelChange",
                                              @"fromLevel" : fromLevel,
                                              @"toLevel" : toLevel }]];
    
    
};

- (void)recordTutorialChangeEventFromStep:(NSNumber *)fromStep toStep:(NSNumber *)toStep {
    [self.eventBuffer addRecordToBuffer:[self makeRecordDict:
                                           @{ @"eventName" : @"tutorialChange",
                                              @"fromStep" : fromStep,
                                              @"toStep" : toStep }]];
};

- (void)recordСurrencyChangeEventWithLevel:(NSNumber *)level andCurrency:(NSNumber *)virtualCurrency {
    
    [self.eventBuffer addRecordToBuffer:[self makeRecordDict:
                                           @{ @"eventName" : @"currencyChange",
                                              @"level" : level,
                                              @"virtualCurrency" : virtualCurrency }]];
};


@end
