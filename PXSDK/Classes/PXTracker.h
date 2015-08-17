//
//  PXTracker.h
//  PXSDK
//

#import <Foundation/Foundation.h>

@interface PXTracker : NSObject

+ (void)initializeWithGameKey:(NSString *)gameKey __attribute__((deprecated));

+ (void)initializeWithGameKey:(NSString *)gameKey enableDeviceToken:(BOOL)enableDeviceToken;

+ (void)setupUserPredictionsForToken:(NSString *)token;

+ (void)processLaunchOptions:(NSDictionary *)launchOptions;

+ (void)processPushNotification:(NSDictionary *)pushNotification;

+ (BOOL)userHasIAPOffer;

+ (void)sendEvent:(NSString *)eventName withParams:(NSDictionary *)params;

+ (void)recordTransactionEventWithName:(NSString *)withName buyVirtualCurrency:(NSString *)buyVirtualCurrency receivingAmount:(NSNumber *)receivingAmount usingRealCurrency:(NSString *)usingRealCurrency spendingAmount:(NSNumber *)spendingAmount;

+ (void)recordLevelChangeEventFromLevel:(NSNumber *)fromLevel toLevel:(NSNumber *)toLevel andCurrency:(NSNumber *)currency;

+ (void)recordTutorialChangeEventFromStep:(NSNumber *)fromStep toStep:(NSNumber *)toStep;

+ (void)recordСurrencyChangeEventWithLevel:(NSNumber *)level andCurrency:(NSNumber *)virtualCurrency;

@end
