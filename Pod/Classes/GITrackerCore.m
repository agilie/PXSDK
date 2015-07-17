//
//  GITrackerCore.m
//  PXSDKExample
//
//  Created by Ankudinov Alexander on 7/8/15.
//  Copyright (c) 2015 Agilie. All rights reserved.
//

#import "GITrackerCore.h"
#import "Lockbox.h"
#import "GINetwork.h"
#import "NSString+MD5.h"
#import "GIEventBuffer.h"
#import "GIDefine.h"

@implementation GITrackerCore


- (id)init {
    // Call the init method implemented by the superclass
    self = [super init];
    if (self) {

        self.uuid = [self getUniqueDeviceIdentifierAsString];
        self.giNetwork = [[GINetwork alloc] init];
        self.giEventBuffer = [[GIEventBuffer alloc] init];

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

- (void)setupUserPredictions {
    [self.giNetwork getRequestWithUrl:kUrlGetUserPredictions andCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            self.giUser = [[GIUser alloc] initWithDictonary:dictionary];
        } else {

            //TODO: remove this after test
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kRequestUserPredictionsInterval * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self setupUserPredictions];
            });
        }
    }];
}

- (void)setupCoreTimers {
    self.realtimeTimer = [NSTimer scheduledTimerWithTimeInterval:kDinamicUpdateInterval target:self selector:@selector(dinamicTimerFire:) userInfo:nil repeats:YES];
    self.cacheTimer = [NSTimer scheduledTimerWithTimeInterval:kCacheUpdateInterval target:self selector:@selector(cacheTimerFire:) userInfo:nil repeats:YES];
}

- (void)dinamicTimerFire:(id)sender {

    if ([self.giEventBuffer dataFromBuffer].length > 0 && self.giNetwork.available) {
        NSData *data2send = [self makeRequestData: [self.giEventBuffer dataFromBuffer] ];
        [self.giNetwork sendToServiceRawData: data2send andCompletion:^(BOOL succes) {
            if (succes) {
                [self.giEventBuffer destroyBuffer];
            } else {
                [self.giEventBuffer flushToCacheBuffer];
            }
        }];
    }

}

- (void)cacheTimerFire:(id)sender {

    if ([[self.giEventBuffer dataFromCacheBuffer] length] > 0 && self.giNetwork.available) {
         NSData *data2send = [self makeRequestData: [self.giEventBuffer dataFromCacheBuffer] ];
        [self.giNetwork sendToServiceRawData: data2send andCompletion:^(BOOL succes) {
            if (succes) {
                [self.giEventBuffer destroyCacheBuffer];
            }
        }];
    }
}

- (BOOL)userHasIAPOffer {
    
    if(!self.giUser) {
        return NO;
    } else {
    
        int spentTime = [NSDate date].timeIntervalSince1970 - self.currentSessionTimeStart;
        
        return self.giUser.params2 == [self curentUserLevel] && self.giUser.params1 < [NSNumber numberWithInt:spentTime] ;
    }

}

- (NSString *)getUniqueDeviceIdentifierAsString {

    NSString *strApplicationUUID = [Lockbox stringForKey:kLockboxUUDIDKey];
    if (strApplicationUUID == nil) {
        strApplicationUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [Lockbox setString:strApplicationUUID forKey:kLockboxUUDIDKey];
    }

    return strApplicationUUID;
}

+ (NSString *)generateRandomString:(int)num {
    NSMutableString *string = [NSMutableString stringWithCapacity:num];
    for (int i = 0; i < num; i++) {
        [string appendFormat:@"%C", (unichar) ('a' + arc4random_uniform(25))];
    }
    return string;
}

- (NSString *)generateUniqueSessionString {
    return [[NSString stringWithFormat:@"%.0f%@%@",
                                       [[NSDate date] timeIntervalSince1970],
                                       self.uuid,
                                       [GITrackerCore generateRandomString:10]] MD5];
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
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    
    NSString *initialJsonData = [NSString stringWithFormat:@" { \"uuid\" : \"%@\" , \"gikey\" : \"%@\" , \"countryCode\" : \"%@\" , \"events\" : [" , self.uuid, self.gameKey , countryCode];
    NSString *endJsonData = @"]}";
    
    NSMutableData *initialData =  [NSMutableData dataWithData: [initialJsonData dataUsingEncoding:NSUTF8StringEncoding] ] ;
    [initialData appendData: input];
    
    [initialData setLength: initialData.length - [[@"," dataUsingEncoding:NSUTF8StringEncoding] length] ];
    
    [initialData appendData:[endJsonData dataUsingEncoding:NSUTF8StringEncoding]];
    
    return initialData;
}

- (NSDictionary *)makeRecordDict:(NSDictionary *)input {
    
    NSMutableDictionary  *tempDictionary = [NSMutableDictionary dictionaryWithDictionary: @{ @"sessionID" : self.currentSession ,
                                                                                             @"timeStamp" : [NSNumber numberWithInt: [[NSDate date] timeIntervalSince1970] ] }];
    [tempDictionary addEntriesFromDictionary: input];
    
    return tempDictionary;
}

- (void)sendEvent:(NSString *)eventName {

    [self.giEventBuffer addRecordToBuffer: [self makeRecordDict: @{ @"eventName" : eventName } ] ];
    
}

- (void)sendStateEvent:(NSString *)eventName {

    [self.giEventBuffer addRecordToBuffer:  [self makeRecordDict: @{ @"eventName" : eventName }]];
    
}

- (void)recordTransactionEventWithName:(NSString *)eventName buyVirtualCurrency:(NSString *)buyVirtualCurrency receivingAmount:(NSNumber *)receivingAmount usingRealCurrency:(NSString *)usingRealCurrency spendingAmount:(NSNumber *)spendingAmount {

    [self.giEventBuffer addRecordToBuffer:  [self makeRecordDict:
                                             @{ @"eventName": @"transactionEvent",
                                              @"buyVirtualCurrency" : buyVirtualCurrency,
                                              @"receivingAmount" : receivingAmount,
                                              @"usingRealCurrency" : usingRealCurrency,
                                              @"spendingAmount" : spendingAmount }] ];

};

- (void)recordLevelChangeEventFromLevel:(NSNumber *)fromLevel toLevel:(NSNumber *)toLevel {

    [self setCurentUserLevel:toLevel];
    
    [self.giEventBuffer addRecordToBuffer:  [self makeRecordDict:
                                             @{ @"eventName": @"levelChange",
                                              @"fromLevel" : fromLevel,
                                              @"toLevel" : toLevel }] ];

    
};

- (void)recordTutorialChangeEventFromStep:(NSNumber *)fromStep toStep:(NSNumber *)toStep {
   
    [self.giEventBuffer addRecordToBuffer:  [self makeRecordDict:
                                             @{ @"eventName": @"tutorialChange",
                                              @"fromStep" : fromStep,
                                              @"toStep" : toStep }] ];
};

- (void)recordСurrencyChangeEventWithLevel:(NSNumber *)level andCurrency:(NSNumber *)virtualCurrency {
    
    [self.giEventBuffer addRecordToBuffer:  [self makeRecordDict:
                                             @{ @"eventName": @"currencyChange",
                                                @"level" : level,
                                                @"virtualCurrency" : virtualCurrency }] ];
};


@end
