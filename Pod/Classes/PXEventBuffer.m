//
//  PXEventBuffer.m
//  PXSDK
//

#import "PXEventBuffer.h"
#import "PXDefines.h"

@implementation PXEventBuffer

- (id)init {
    self = [super init];
    if (self) {
        self.eventBuffer = [[NSMutableData alloc] init];
        self.isolationQueue = dispatch_queue_create(kPXFileQueueLockerName, DISPATCH_QUEUE_CONCURRENT);
        self.cacheFileHandle = [self makeCacheFileHandle];
    }
    return self;
}

- (NSFileHandle *)makeCacheFileHandle {
    
    NSString *cacheFileName = [NSTemporaryDirectory() stringByAppendingPathComponent:kPXCacheFileName];
    
    NSFileManager *fileMan = [NSFileManager defaultManager];
    if (![fileMan fileExistsAtPath:cacheFileName]) {
        [fileMan createFileAtPath:cacheFileName contents:nil attributes:nil];
    }
    
    return [NSFileHandle fileHandleForUpdatingAtPath:cacheFileName];
    
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
