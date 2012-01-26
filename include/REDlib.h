/*
 *  ParmyLib.h
 *  ParmyLib
 *
 *  Created by Tom Seago on 7/16/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
@class UIWindow;

@interface NSString(REDlib)

@property (nonatomic, assign) double pfv;
@property (nonatomic, assign) int piv;
@property (nonatomic, assign) NSString* psv;

-(double) pfvd:(double)defaultValue;
-(int) pivd:(int)defaultValue;
-(NSString*) psvd:(NSString*)defaultValue;

-(void) bindToProperty:(NSString*)pName onObject:(NSObject*)obj;

-(void) rLog;
@end


@interface NSDictionary(REDlib)

-(void) setREDlibSet:(int)set;

@end


@interface REDlib : NSObject

+(void) attachGestureRecognizerToWindow:(UIWindow*)window;
+(void) toggleControlWindow;

+(void) showControlWindow;
+(void) hideControlWindow;


@end

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
extern void RLogLineNo(char* file, int lineno, int level, NSString* facility, NSString* format, ...);
extern void RLogv(int level, NSString* facility, NSString* format, va_list args);
extern void RLogLineNov(char* file, int lineno, int level, NSString* facility, NSString* format, va_list args);

extern void RLogEnable(NSString* sinkName);

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


#define REDLIB_PARAM_CHANGED			@"REDLIB_PARAM_CHANGED"
#define REDLIB_CLIENT_SET_PARAMS		@"REDLIB_CLIENT_SET_PARAMS"