//
//  GITracker.m
//  PXSDKExample
//
//  Created by Ankudinov Alexander on 7/8/15.
//  Copyright (c) 2015 Agilie. All rights reserved.
//

#import "GITracker.h"
#import "GITrackerCore.h"

@implementation GITracker

static GITrackerCore *giTrackerCore;

+ (GITrackerCore *)giTrackerCore {

    static dispatch_once_t pred;

    dispatch_once(&pred, ^{
        giTrackerCore = [[GITrackerCore alloc] init];
    });

    return giTrackerCore;
}

+ (void)setGameKey:(NSString *)gameKey {
    GITracker.giTrackerCore.gameKey = gameKey;
}

+ (BOOL)userHasIAPOffer {
    return [GITracker.giTrackerCore userHasIAPOffer];
}

+ (void)sendEvent:(NSString *)eventName {
    [GITracker.giTrackerCore sendEvent:eventName];
};

+ (void)recordTransactionEventWithName:(NSString *)withName buyVirtualCurrency:(NSString *)buyVirtualCurrency receivingAmount:(NSNumber *)receivingAmount usingRealCurrency:(NSString *)usingRealCurrency spendingAmount:(NSNumber *)spendingAmount {

    [GITracker.giTrackerCore recordTransactionEventWithName:withName buyVirtualCurrency:buyVirtualCurrency receivingAmount:receivingAmount usingRealCurrency:usingRealCurrency spendingAmount:spendingAmount];

};

+ (void)recordLevelChangeEventFromLevel:(NSNumber *)fromLevel toLevel:(NSNumber *)toLevel {
    [GITracker.giTrackerCore recordLevelChangeEventFromLevel:fromLevel toLevel:toLevel];
};

+ (void)recordTutorialChangeEventFromStep:(NSNumber *)fromStep toStep:(NSNumber *)toStep {
    [GITracker.giTrackerCore recordTutorialChangeEventFromStep:fromStep toStep:toStep];
};

+ (void)recordСurrencyChangeEventWithLevel:(NSNumber *)level andCurrency:(NSNumber *)virtualCurrency {
    #warning TODO fix mock values
    [GITracker.giTrackerCore recordСurrencyChangeEventWithLevel:@1 andCurrency:@300];
};

@end
