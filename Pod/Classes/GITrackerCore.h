//
//  GITrackerCore.h
//  PXSDKExample
//
//  Created by Ankudinov Alexander on 7/8/15.
//  Copyright (c) 2015 Agilie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GINetwork;
@class GIEventBuffer;
@class GIUser;

@interface GITrackerCore : NSObject

@property (nonatomic, strong) NSString *gameKey;
@property (nonatomic, strong) NSString *currentSession;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) GINetwork *giNetwork;
@property (nonatomic, strong) GIEventBuffer *giEventBuffer;
@property (nonatomic, strong) NSTimer *realtimeTimer, *cacheTimer;
@property (nonatomic, strong) GIUser *giUser;
@property NSTimeInterval currentSessionTimeStart;

- (id)init;

- (BOOL)userHasIAPOffer;

- (void)sendEvent:(NSString *)eventName;

- (void)recordTransactionEventWithName:(NSString *)eventName buyVirtualCurrency:(NSString *)buyVirtualCurrency receivingAmount:(NSNumber *)receivingAmount usingRealCurrency:(NSString *)usingRealCurrency spendingAmount:(NSNumber *)spendingAmount;

- (void)recordLevelChangeEventFromLevel:(NSNumber *)fromLevel toLevel:(NSNumber *)toLevel;

- (void)recordTutorialChangeEventFromStep:(NSNumber *)fromStep toStep:(NSNumber *)toStep;

- (void)recordСurrencyChangeEventWithLevel:(NSNumber *)level andCurrency:(NSNumber *)virtualCurrency;

@end
