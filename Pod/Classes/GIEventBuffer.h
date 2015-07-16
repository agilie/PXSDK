//
//  GIEventBuffer.h
//  PXSDKExample
//
//  Created by Dmitry Salnikov on 7/8/15.
//  Copyright (c) 2015 Agilie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GIEventBuffer : NSObject

@property(nonatomic, strong) NSMutableData *eventBuffer;
@property(nonatomic) dispatch_queue_t isolationQueue;
@property(nonatomic, strong) NSFileHandle *cacheFileHandle;

- (void)addRecordToBuffer:(NSDictionary *)record;

- (NSData *)dataFromBuffer;

- (NSData *)dataFromCacheBuffer;

- (void)flushToCacheBuffer;

- (void)destroyBuffer;

- (void)destroyCacheBuffer;

@end
