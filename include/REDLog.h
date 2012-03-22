//
//  REDLog.h
//  REDlib
//
//  Created by Tom Seago on 1/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "REDCLog.h"

/************************************************************
 Logging Macros
 ************************************************************/
#ifdef __cplusplus
extern "C" {
#endif
    
extern const int RLEVEL_TRACE;
extern const int RLEVEL_DEBUG;
extern const int RLEVEL_INFO;
extern const int RLEVEL_WARNING;
extern const int RLEVEL_WARN;
extern const int RLEVEL_ERROR;
extern const int RLEVEL_ERR;
extern const int RLEVEL_CRITICAL;
extern const int RLEVEL_CRIT;

extern const int RLEVEL_DEFAULT;

extern void RLog(NSString *format, ...);
extern void RLogLineNo(const char* file, int lineno, int level, NSString* facility, NSString* format, ...);
extern void RLogv(int level, NSString* facility, NSString* format, va_list args);
extern void RLogLineNov(const char* file, int lineno, int level, NSString* facility, NSString* format, va_list args);

extern void RLogEnable(NSString* sinkName);
    
#ifdef __cplusplus
}
#endif

// Undefine everything first just in case both this file and REDCLog.h get included
#undef RLOG
#undef RLOG_TRACE
#undef RLOG_DEBUG
#undef RLOG_INFO
#undef RLOG_WARNING
#undef RLOG_WARN
#undef RLOG_ERROR
#undef RLOG_ERR
#undef RLOG_CRITICAL
#undef RLOG_CRIT

#define RLOG(facility, ...) RLogLineNo(__FILE__,__LINE__, RLEVEL_DEFAULT, facility, __VA_ARGS__)

#define RLOG_TRACE(facility, ...) RLogLineNo(__FILE__,__LINE__, RLEVEL_TRACE, facility, __VA_ARGS__)
#define RLOG_DEBUG(facility, ...) RLogLineNo(__FILE__,__LINE__, RLEVEL_DEBUG, facility, __VA_ARGS__)
#define RLOG_INFO(facility, ...) RLogLineNo(__FILE__,__LINE__, RLEVEL_INFO, facility, __VA_ARGS__)
#define RLOG_WARNING(facility, ...) RLogLineNo(__FILE__,__LINE__, RLEVEL_WARNING, facility, __VA_ARGS__)
#define RLOG_WARN(facility, ...) RLogLineNo(__FILE__,__LINE__, RLEVEL_WARN, facility, __VA_ARGS__)
#define RLOG_ERROR(facility, ...) RLogLineNo(__FILE__,__LINE__, RLEVEL_ERROR, facility, __VA_ARGS__)
#define RLOG_ERR(facility, ...) RLogLineNo(__FILE__,__LINE__, RLEVEL_ERR, facility, __VA_ARGS__)
#define RLOG_CRITICAL(facility, ...) RLogLineNo(__FILE__,__LINE__, RLEVEL_CRITICAL, facility, __VA_ARGS__)
#define RLOG_CRIT(facility, ...) RLogLineNo(__FILE__,__LINE__, RLEVEL_CRIT, facility, __VA_ARGS__)

/************************************************************
    REDLog Class
 ************************************************************/

@protocol REDLogSink;

@interface REDLog : NSObject
{
    NSString* _adid;
    NSMutableArray* _registrations;
    
    BOOL _toNSLog;
    NSDateFormatter* _nslogDateFormatter;
}

@property (nonatomic, retain) NSString* adid;

+(REDLog*) sharedInstance;

+(NSString*) macaddress;
+(NSString*) stringFromMD5:(NSString*)src;
+(NSString*) makeADID;
+(NSString*) makeGDID;

+(NSString*) stringForLevel:(int)level;
+(NSString*) stringForLevelFixedWidth:(int)level;


-(void) registerSink:(id<REDLogSink>)sink forEverything:(BOOL)forAll;
-(void) unregisterSink:(id<REDLogSink>)sink;

-(NSArray*) allSinks;

-(void) setLevel:(int)level forSink:(id<REDLogSink>)sink;
-(void) addFacility:(NSString*)facility forSink:(id<REDLogSink>)sink;
-(void) removeFacility:(NSString*)facility forSink:(id<REDLogSink>)sink;

-(void) log:(NSString*)msg level:(int)level facility:(NSString*)facility data:(NSDictionary*)data;

-(void) addNSLog;
-(void) removeNSLog;

-(id<REDLogSink>) addNetworkKey:(NSString*)key;
-(id<REDLogSink>) addNetworkKey:(NSString*)key forURL:(NSString*)url;


@end
