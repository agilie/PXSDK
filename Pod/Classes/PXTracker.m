//
//  PXTracker.m
//  PXSDK
//

#import "PXTracker.h"
#import "PXTrackerCore.h"

@implementation PXTracker

static PXTrackerCore *giTrackerCore;

+ (PXTrackerCore *)giTrackerCore {
    
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        giTrackerCore = [[PXTrackerCore alloc] init];
    });
    
    return giTrackerCore;
}

+ (void)setGameKey:(NSString *)gameKey {
    giTrackerCore.gameKey = gameKey;
}

+ (BOOL)userHasIAPOffer {
    return [giTrackerCore userHasIAPOffer];
}

+ (void)sendEvent:(NSString *)eventName withParams:(NSDictionary *)params{
    
    [giTrackerCore sendGeneralEventWithName:eventName andParams:params];
    
};

+ (void)recordTransactionEventWithName:(NSString *)withName buyVirtualCurrency:(NSString *)buyVirtualCurrency receivingAmount:(NSNumber *)receivingAmount usingRealCurrency:(NSString *)usingRealCurrency spendingAmount:(NSNumber *)spendingAmount {
    
    [giTrackerCore recordTransactionEventWithName:withName buyVirtualCurrency:buyVirtualCurrency receivingAmount:receivingAmount usingRealCurrency:usingRealCurrency spendingAmount:spendingAmount];
    
};

+ (void)recordLevelChangeEventFromLevel:(NSNumber *)fromLevel toLevel:(NSNumber *)toLevel {
    [giTrackerCore recordLevelChangeEventFromLevel:fromLevel toLevel:toLevel];
};

+ (void)recordTutorialChangeEventFromStep:(NSNumber *)fromStep toStep:(NSNumber *)toStep {
    [giTrackerCore recordTutorialChangeEventFromStep:fromStep toStep:toStep];
};

+ (void)recordСurrencyChangeEventWithLevel:(NSNumber *)level andCurrency:(NSNumber *)virtualCurrency {
    [giTrackerCore recordСurrencyChangeEventWithLevel:level andCurrency:virtualCurrency];
};

@end
