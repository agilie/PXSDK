//
//  PXDefines.h
//  PXSDK
//

#ifndef PXDefines
#define PXDefines

static NSString *const kPXApiEndPointUrl = @"http://playerxtracker.herokuapp.com/v1.1/";
static NSString *const kPXGetUserPredictionsUrl = @"http://gistats.herokuapp.com/getUserPredictions/%@/%@";

static NSInteger kPXDynamicUpdateInterval = 1.0f * 60;
static NSInteger kPXCacheUpdateInterval = 1.0f * 65 * 5;
static NSInteger kPXRequestUserPredictionsInterval = 60;
static NSString *const kPXLockboxUUDIDKey = @"uudid";
static NSString *const kPXLevelKeyStore = @"userLevel";
static NSString *const kPXTriggerDateKeyStore = @"triggerDate";
static char *const kPXFileQueueLockerName = "PXEventBufferQueue";
static NSString *const kPXCacheFileName = @"PXTrackerCache.data";

static const BOOL kPXLogsEnabled = YES;
static NSString *const kPXLogsTag = @"[PXSDK] ";

static inline void PXLog(NSString *format, ...) {
    if (kPXLogsEnabled) {
        va_list argList;
        va_start(argList, format);
        NSString *string = [kPXLogsTag stringByAppendingString:format];
        NSLogv(string, argList);
        va_end(argList);
    }
}

#endif
