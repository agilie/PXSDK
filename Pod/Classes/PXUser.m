//
//  PXUser.m
//  PXSDK
//

#import "PXUser.h"

@implementation PXUser

- (id)initWithDictonary:(NSDictionary *)userDict {
    self = [super init];
    if (self) {
        self.params1 = [userDict objectForKey:@"params1"];
        self.params2 = [userDict objectForKey:@"params2"];
        self.params3 = [userDict objectForKey:@"params3"];
        self.params4 = [userDict objectForKey:@"params4"];
        self.params5 = [userDict objectForKey:@"params5"];
    }
    return self;
}

@end
