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
@property (nonatomic, strong) PXNetwork *giNetwork;
@property (nonatomic, strong) PXEventBuffer *giEventBuffer;
@property (nonatomic, strong) NSTimer *realtimeTimer, *cacheTimer;
@property (nonatomic, strong) PXUser *giUser;
@property NSTimeInterval currentSessionTimeStart;

- (id)init;

- (BOOL)userHasIAPOffer;

- (void)sendEvent:(NSString *)eventName;

- (void)recordTransactionEventWithName:(NSString *)eventName buyVirtualCurrency:(NSString *)buyVirtualCurrency receivingAmount:(NSNumber *)receivingAmount usingRealCurrency:(NSString *)usingRealCurrency spendingAmount:(NSNumber *)spendingAmount;

- (void)recordLevelChangeEventFromLevel:(NSNumber *)fromLevel toLevel:(NSNumber *)toLevel;

- (void)recordTutorialChangeEventFromStep:(NSNumber *)fromStep toStep:(NSNumber *)toStep;

- (void)recordСurrencyChangeEventWithLevel:(NSNumber *)level andCurrency:(NSNumber *)virtualCurrency;

@end
