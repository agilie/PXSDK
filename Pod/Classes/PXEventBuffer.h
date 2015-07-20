//
//  PXEventBuffer.h
//  PXSDK
//

#import <Foundation/Foundation.h>

@interface PXEventBuffer : NSObject

@property (nonatomic, strong) NSMutableData *eventBuffer;
@property (nonatomic) dispatch_queue_t isolationQueue;
@property (nonatomic, strong) NSFileHandle *cacheFileHandle;

- (void)addRecordToBuffer:(NSDictionary *)record;

- (NSData *)dataFromBuffer;

- (NSData *)dataFromCacheBuffer;

- (void)flushToCacheBuffer;

- (void)destroyBuffer;

- (void)destroyCacheBuffer;

@end
