//
//  PXTrackerCore.h
//  PXSDK
//

#import <Foundation/Foundation.h>

@class PXNetwork;
@class PXEventBuffer;
@class PXUser;

@protocol PXTrackerProtocol <NSObject>

- (void)addVirtualCurrency:(NSNumber *)virtualCurrency;

@end

@interface PXTrackerCore : NSObject

@property (weak, nonatomic) id <PXTrackerProtocol> delegate;
@property (nonatomic, assign) BOOL enableToken;
@property (nonatomic, copy) NSString *deviceToken;
@property (nonatomic, copy) NSString *gameKey;
@property (nonatomic, copy) NSString *currentSession;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, strong) PXNetwork *network;
@property (nonatomic, strong) PXEventBuffer *eventBuffer;
@property (nonatomic, strong) NSTimer *realtimeTimer, *cacheTimer;
@property (nonatomic, strong) PXUser *user;
@property NSTimeInterval currentSessionTimeStart;

- (id)init;

- (void)setupUserPredictionsForToken:(NSString *)token;

- (BOOL)userHasIAPOffer;

- (void)sendGeneralEventWithName:(NSString *)eventName andParams:(NSDictionary *)params;

- (void)recordTransactionEventWithName:(NSString *)eventName buyVirtualCurrency:(NSString *)buyVirtualCurrency receivingAmount:(NSNumber *)receivingAmount usingRealCurrency:(NSString *)usingRealCurrency spendingAmount:(NSNumber *)spendingAmount;

- (void)recordLevelChangeEventFromLevel:(NSNumber *)fromLevel toLevel:(NSNumber *)toLevel andCurrency:(NSNumber *)currency;

- (void)recordTutorialChangeEventFromStep:(NSNumber *)fromStep toStep:(NSNumber *)toStep;

- (void)recordСurrencyChangeEventWithLevel:(NSNumber *)level andCurrency:(NSNumber *)virtualCurrency;

- (void)processLaunchOptions:(NSDictionary *)launchOptions;

- (void)processPushNotification:(NSDictionary *)pushNotification;

@end
