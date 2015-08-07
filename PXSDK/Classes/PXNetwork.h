//
//  PXNetwork.h
//  PXSDK
//

#import <Foundation/Foundation.h>

@interface PXNetwork : NSObject

- (void)sendToServiceRawData:(NSData *)data completion:(void (^)(BOOL succes))completionHandler;

- (void)getRequestWithUrl:(NSString *)mainRequestUrl completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

@property BOOL available;

@end
