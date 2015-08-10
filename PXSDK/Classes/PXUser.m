//
//  PXUser.m
//  PXSDK
//

#import "PXUser.h"

@implementation PXUser

- (id)initWithDictonary:(NSDictionary *)userDict {
    self = [super init];
    if (self) {
        self.timeForIAPOffer = userDict[@"params1"];
        self.levelForIAPOffer = userDict[@"params2"];
        self.dateForIAPOffer = userDict[@"params3"];
        self.timeForReward = userDict[@"params4"];
        self.levelForReward = userDict[@"params5"];
        self.dateForReward = userDict[@"params6"];
        self.alertTitle = userDict[@"params7"];
        self.alertBody = userDict[@"params8"];
    }
    return self;
}

@end
