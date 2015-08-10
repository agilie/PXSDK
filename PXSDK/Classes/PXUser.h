//
//  PXUser.h
//  PXSDK
//

#import <Foundation/Foundation.h>

@interface PXUser : NSObject

- (id)initWithDictonary:(NSDictionary *)userDict;

@property (nonatomic, strong) NSNumber *timeForIAPOffer;
@property (nonatomic, strong) NSNumber *levelForIAPOffer;
@property (nonatomic, strong) NSNumber *dateForIAPOffer;
@property (nonatomic, strong) NSNumber *timeForReward;
@property (nonatomic, strong) NSNumber *levelForReward;
@property (nonatomic, strong) NSNumber *dateForReward;

@end

