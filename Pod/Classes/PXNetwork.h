//
//  PXNetwork.h
//  PXSDK
//

#import <Foundation/Foundation.h>

@interface PXNetwork : NSObject

- (void)sendToServiceRawData:(NSData *)data andCompletion:(void (^)(BOOL succes))completionHandler;

- (void)getRequestWithUrl:(NSString *)mainRequestUrl andCompletion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

@property BOOL available;

@end
