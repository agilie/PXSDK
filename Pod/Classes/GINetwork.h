//
//  GINetwork.h
//  PXSDKExample
//
//  Created by Ankudinov Alexander on 7/8/15.
//  Copyright (c) 2015 Agilie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GINetwork : NSObject

- (void)sendToServiceRawData:(NSData *)data andCompletion:(void (^)(BOOL succes))completionHandler;

- (void)getRequestWithUrl:(NSString *)mainRequestUrl andCompletion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

@property BOOL available;

@end
