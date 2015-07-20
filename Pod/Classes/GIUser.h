//
//  GIUser.h
//  PXSDKExample
//
//  Created by Ankudinov Alexander on 7/9/15.
//  Copyright (c) 2015 Agilie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GIUser : NSObject

- (id)initWithDictonary:(NSDictionary *)userDict;

//@property (nonatomic, strong) NSString *game_key;
// @property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSNumber *params1;
@property (nonatomic, strong) NSNumber *params2;
@property (nonatomic, strong) NSNumber *params3;
@property (nonatomic, strong) NSNumber *params4;
@property (nonatomic, strong) NSNumber *params5;

@end

