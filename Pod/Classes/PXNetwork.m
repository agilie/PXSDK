//
//  PXNetwork.m
//  PXSDK
//

#import "PXNetwork.h"
#import "PXDefines.h"

@implementation PXNetwork

- (id)init {
    if (self = [super init]) {
        self.available = YES;
    }
    return self;
}

- (void)sendToServiceRawData:(NSData *)data completion:(void (^)(BOOL success))completionHandler {

    NSString *mainRequestUrl = kPXApiEndPointIUrl;

    NSURL *url = [NSURL URLWithString:mainRequestUrl];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";

    self.available = NO;

    PXLog(@"send raw data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

    __weak typeof(self) weakSelf = self;
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *responseDictonary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        BOOL success = (error == nil) && [responseDictonary[@"result"] isEqualToString:@"success"];
        if (completionHandler) completionHandler(success);
        weakSelf.available = YES;
        PXLog(@"upload completed with response: %@\n error: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], error);
    }];
    [uploadTask resume];

};

- (void)getRequestWithUrl:(NSString *)mainRequestUrl completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    NSURL *url = [NSURL URLWithString:mainRequestUrl];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];

    NSURLSessionDataTask *getTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (completionHandler) completionHandler(data, response, error);
        PXLog(@"got data: %@\n error: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], error);

    }];

    [getTask resume];

};

@end
