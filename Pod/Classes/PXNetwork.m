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

- (void)sendToServiceRawData:(NSData *)data andCompletion:(void (^)(BOOL succes))completionHandler {
    
    NSString *mainRequestUrl = kApiEndPoint;
    
    NSURL *url = [NSURL URLWithString:mainRequestUrl];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    self.available = NO;
    
    //TODO: remove this after test
    NSLog(@"Try Send that %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                               fromData:data
                                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                          
                                                          NSDictionary *responseDictonary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                          
                                                          BOOL succes = error == nil && [responseDictonary[@"result"] isEqualToString:@"success"];
                                                          
                                                          completionHandler(succes);
                                                          self.available = YES;
                                                          
                                                          //TODO: remove this after test
                                                          NSLog(@"Recivie %@ %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], error);
                                                          
                                                      }];
    
    [uploadTask resume];
    
};

- (void)getRequestWithUrl:(NSString *)mainRequestUrl andCompletion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    
    NSURL *url = [NSURL URLWithString:mainRequestUrl];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    
    NSURLSessionDataTask *getTesk = [session dataTaskWithURL:url
                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                               
                                               completionHandler(data, response, error);
                                               //TODO: remove this after test
                                               NSLog(@"Recivie %@ %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], error);
                                               
                                           }];
    
    [getTesk resume];
    
};

@end
