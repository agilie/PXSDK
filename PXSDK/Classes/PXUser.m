//
//  PXUser.m
//  PXSDK
//

#import "PXUser.h"

@implementation PXUser

- (id)initWithDictonary:(NSDictionary *)userDict {
    self = [super init];
    if (self) {
        NSDictionary *mapping = @{@"timeForIAPOffer":@"params1", @"levelForIAPOffer":@"params2", @"dateForIAPOffer":@"params3", @"timeForReward":@"params4", @"levelForReward":@"params5", @"dateForReward":@"params6", @"alertTitle":@"params7", @"alertBody":@"params8"};
        [mapping enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self setValue:userDict[obj] forKey:key];
        }];
    }
    return self;
}

@end
