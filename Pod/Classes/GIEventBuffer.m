//
//  GIEventBuffer.m
//  PXSDKExample
//
//  Created by Dmitry Salnikov on 7/8/15.
//  Copyright (c) 2015 Agilie. All rights reserved.
//

#import "GIEventBuffer.h"
#import "GIDefine.h"

@implementation GIEventBuffer

- (id)init {
    self = [super init];
    if (self) {
        self.eventBuffer = [[NSMutableData alloc] init];
        self.isolationQueue = dispatch_queue_create(kFileQueueLocker, DISPATCH_QUEUE_CONCURRENT);
        self.cacheFileHandle = [self makeCacheFileHandle];
    }
    return self;
}

- (NSFileHandle *)makeCacheFileHandle {

    NSString *cacheFileName = [NSTemporaryDirectory() stringByAppendingPathComponent:kCacheFileName];

    NSFileManager *fileMan = [NSFileManager defaultManager];
    if (![fileMan fileExistsAtPath:cacheFileName]) {
        [fileMan createFileAtPath:cacheFileName contents:nil attributes:nil];
    }

    return [NSFileHandle fileHandleForUpdatingAtPath:cacheFileName];

}

- (NSString *)separatedStringFromArray:(NSArray *)array {

    NSMutableString *separatedString = [[NSMutableString alloc] init];

    NSString *format = @"||%@";
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [separatedString appendFormat:format, [obj description]];
    }];

    [separatedString appendString:@"\n"];

    return separatedString;
}

- (void)addRecordToBuffer:(NSDictionary *)record {

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:record options:0 error:nil];

    [self.eventBuffer appendData:jsonData];
    [self.eventBuffer appendData:[@"," dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSData *)dataFromBuffer {
    return self.eventBuffer;
}

- (NSData *)dataFromCacheBuffer {
    [self.cacheFileHandle seekToFileOffset:0];
    return [self.cacheFileHandle availableData];
}

- (void)flushToCacheBuffer {
    NSData *temp = [NSData dataWithData:self.eventBuffer];
    [self destroyBuffer];

    void(^block_write)() = ^{
        [self.cacheFileHandle seekToEndOfFile];
        [self.cacheFileHandle writeData:temp];
    };
    dispatch_async(self.isolationQueue, block_write);
}

- (void)destroyBuffer {
    [self.eventBuffer setLength:0];
}

- (void)destroyCacheBuffer {
    void(^block_destroy)() = ^{
        [self.cacheFileHandle truncateFileAtOffset:0];
    };
    dispatch_async(self.isolationQueue, block_destroy);
}

@end
