//
//  PXTracker.m
//  PXSDK
//

#import "PXTracker.h"

@implementation PXTracker

static PXTrackerCore *sTrackerCore;

+ (void)initializeWithGameKey:(NSString *)gameKey {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sTrackerCore = [[PXTrackerCore alloc] init];
    });
    sTrackerCore.gameKey = gameKey;
}

+ (void)initializeWithGameKey:(NSString *)gameKey enableDeviceToken:(BOOL)enableDeviceToken {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sTrackerCore = [[PXTrackerCore alloc] init];
        sTrackerCore.enableToken = enableDeviceToken;
        sTrackerCore.gameKey = gameKey;
        if (!enableDeviceToken) {
            [sTrackerCore setupUserPredictionsForToken:nil];
        }
    });
}

+ (void)setUpdateCurrencyDelegate:(id)delegate {
    if ([delegate conformsToProtocol:@protocol(PXTrackerProtocol)]) {
        sTrackerCore.delegate = delegate;
    }
}

+ (void)setupUserPredictionsForToken:(NSString *)token {
    [sTrackerCore setupUserPredictionsForToken:token];
}

+ (void)processLaunchOptions:(NSDictionary *)launchOptions {
    [sTrackerCore processLaunchOptions:launchOptions];
}

+ (void)processPushNotification:(NSDictionary *)pushNotification {
    [sTrackerCore processPushNotification:pushNotification];
}

+ (BOOL)userHasIAPOffer {
    return [sTrackerCore userHasIAPOffer];
}

+ (void)sendEvent:(NSString *)eventName withParams:(NSDictionary *)params {
    [sTrackerCore sendGeneralEventWithName:eventName andParams:params];
};

+ (void)recordTransactionEventWithName:(NSString *)withName buyVirtualCurrency:(NSString *)buyVirtualCurrency receivingAmount:(NSNumber *)receivingAmount usingRealCurrency:(NSString *)usingRealCurrency spendingAmount:(NSNumber *)spendingAmount {

    [sTrackerCore recordTransactionEventWithName:withName buyVirtualCurrency:buyVirtualCurrency receivingAmount:receivingAmount usingRealCurrency:usingRealCurrency spendingAmount:spendingAmount];

};

+ (void)recordLevelChangeEventFromLevel:(NSNumber *)fromLevel toLevel:(NSNumber *)toLevel andCurrency:(NSNumber *)currency {
    [sTrackerCore recordLevelChangeEventFromLevel:fromLevel toLevel:toLevel andCurrency:currency];
};

+ (void)recordTutorialChangeEventFromStep:(NSNumber *)fromStep toStep:(NSNumber *)toStep {
    [sTrackerCore recordTutorialChangeEventFromStep:fromStep toStep:toStep];
};

+ (void)recordСurrencyChangeEventWithLevel:(NSNumber *)level andCurrency:(NSNumber *)virtualCurrency {
    [sTrackerCore recordСurrencyChangeEventWithLevel:level andCurrency:virtualCurrency];
};

@end
