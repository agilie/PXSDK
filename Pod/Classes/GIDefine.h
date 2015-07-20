//
//  GIDefine.h
//  PXSDKExample
//
//  Created by Ankudinov Alexander on 7/9/15.
//  Copyright (c) 2015 Agilie. All rights reserved.
//

#ifndef PXDefines
#define PXDefines

static NSString * const kApiEndPoint = @"http://playerxtracker.herokuapp.com/v1.1/";
static NSString * const kUrlGetUserPredictions = @"http://gistats.herokuapp.com/getUserPredictions/Testgame01";

static NSInteger kDinamicUpdateInterval = 1.0f * 60;
static NSInteger kCacheUpdateInterval = 1.0f * 65 * 2;
static NSInteger kRequestUserPredictionsInterval = 1 * 65 * 2;
static NSString * const kLockboxUUDIDKey = @"uudid";
static char * const kFileQueueLocker = "GIEventBufferQueue";
static NSString * const kCacheFileName = @"GITrackerCache.data";

#endif