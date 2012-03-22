/*
 *  ParmyLib.h
 *  ParmyLib
 *
 *  Created by Tom Seago on 7/16/11.
 *  Copyright 2011 Reality Box Labs LLC. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "REDClib.h"
#import "REDLog.h"
#import "REDLogSink.h"

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



#define REDLIB_PARAM_CHANGED			@"REDLIB_PARAM_CHANGED"
#define REDLIB_CLIENT_SET_PARAMS		@"REDLIB_CLIENT_SET_PARAMS"