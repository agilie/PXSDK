//
//  PXUser.m
//  PXSDK
//

#import "PXUser.h"

@implementation PXUser

- (id)initWithDictonary:(NSDictionary *)userDict {
    self = [super init];
    if (self) {
        self.params1 = userDict[@"params1"];
        self.params2 = userDict[@"params2"];
        self.params3 = userDict[@"params3"];
        self.params4 = userDict[@"params4"];
        self.params5 = userDict[@"params5"];
    }
    return self;
}

@end
