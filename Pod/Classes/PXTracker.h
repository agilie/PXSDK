//
//  PXTracker.h
//  PXSDK
//

#import <Foundation/Foundation.h>

@interface PXTracker : NSObject

+ (void)initializeWithGameKey:(NSString *)gameKey;

+ (BOOL)userHasIAPOffer;

+ (void)sendEvent:(NSString *)eventName withParams:(NSDictionary *)params;

+ (void)recordTransactionEventWithName:(NSString *)withName buyVirtualCurrency:(NSString *)buyVirtualCurrency receivingAmount:(NSNumber *)receivingAmount usingRealCurrency:(NSString *)usingRealCurrency spendingAmount:(NSNumber *)spendingAmount;

+ (void)recordLevelChangeEventFromLevel:(NSNumber *)fromLevel toLevel:(NSNumber *)toLevel;

+ (void)recordTutorialChangeEventFromStep:(NSNumber *)fromStep toStep:(NSNumber *)toStep;

+ (void)recordСurrencyChangeEventWithLevel:(NSNumber *)level andCurrency:(NSNumber *)virtualCurrency;

@end
