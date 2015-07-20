//
//  GINetwork.m
//  PXSDKExample
//
//  Created by Ankudinov Alexander on 7/8/15.
//  Copyright (c) 2015 Agilie. All rights reserved.
//

#import "GINetwork.h"
#import "GIDefine.h"

@implementation GINetwork

- (id)init {
    // Call the init method implemented by the superclass
    self = [super init];
    if (self) {
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

                                                          BOOL succes = error == nil && [[responseDictonary objectForKey:@"result"] isEqualToString:@"success"];

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
