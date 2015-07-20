//
//  PXTrackerCore.h
//  PXSDK
//

#import <Foundation/Foundation.h>

@class PXNetwork;
@class PXEventBuffer;
@class PXUser;

@interface PXTrackerCore : NSObject

@property (nonatomic, strong) NSString *gameKey;
@property (nonatomic, strong) NSString *currentSession;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) PXNetwork *network;
@property (nonatomic, strong) PXEventBuffer *eventBuffer;
@property (nonatomic, strong) NSTimer *realtimeTimer, *cacheTimer;
@property (nonatomic, strong) PXUser *user;
@property NSTimeInterval currentSessionTimeStart;

- (id)init;

- (BOOL)userHasIAPOffer;

- (void)sendGeneralEventWithName:(NSString *)eventName andParams:(NSDictionary *)params;

- (void)recordTransactionEventWithName:(NSString *)eventName buyVirtualCurrency:(NSString *)buyVirtualCurrency receivingAmount:(NSNumber *)receivingAmount usingRealCurrency:(NSString *)usingRealCurrency spendingAmount:(NSNumber *)spendingAmount;

- (void)recordLevelChangeEventFromLevel:(NSNumber *)fromLevel toLevel:(NSNumber *)toLevel;

- (void)recordTutorialChangeEventFromStep:(NSNumber *)fromStep toStep:(NSNumber *)toStep;

- (void)recordСurrencyChangeEventWithLevel:(NSNumber *)level andCurrency:(NSNumber *)virtualCurrency;

@end
