//
//  PXTracker.m
//  PXSDK
//

#import "PXTracker.h"
#import "PXTrackerCore.h"

@implementation PXTracker

static PXTrackerCore *sTrackerCore;

+ (PXTrackerCore *)trackerCore {
    
    return sTrackerCore;
}

+ (void)initializeWithGameKey:(NSString *)gameKey {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sTrackerCore = [[PXTrackerCore alloc] init];
    });
    sTrackerCore.gameKey = gameKey;
}

+ (BOOL)userHasIAPOffer {
    return [sTrackerCore userHasIAPOffer];
}

+ (void)sendEvent:(NSString *)eventName {
    [sTrackerCore sendEvent:eventName];
};

+ (void)recordTransactionEventWithName:(NSString *)withName buyVirtualCurrency:(NSString *)buyVirtualCurrency receivingAmount:(NSNumber *)receivingAmount usingRealCurrency:(NSString *)usingRealCurrency spendingAmount:(NSNumber *)spendingAmount {
    
    [sTrackerCore recordTransactionEventWithName:withName buyVirtualCurrency:buyVirtualCurrency receivingAmount:receivingAmount usingRealCurrency:usingRealCurrency spendingAmount:spendingAmount];
    
};

+ (void)recordLevelChangeEventFromLevel:(NSNumber *)fromLevel toLevel:(NSNumber *)toLevel {
    [sTrackerCore recordLevelChangeEventFromLevel:fromLevel toLevel:toLevel];
};

+ (void)recordTutorialChangeEventFromStep:(NSNumber *)fromStep toStep:(NSNumber *)toStep {
    [sTrackerCore recordTutorialChangeEventFromStep:fromStep toStep:toStep];
};

+ (void)recordСurrencyChangeEventWithLevel:(NSNumber *)level andCurrency:(NSNumber *)virtualCurrency {
    [sTrackerCore recordСurrencyChangeEventWithLevel:level andCurrency:virtualCurrency];
};

@end
