//
//  ParmyLib.m
//  NoNameLib
//
//  Created by Tom Seago on 7/16/11.
//  Copyright 2011 Reality Box Labs LLC. All rights reserved.
//

#import "REDlib.h"
#import "REDlibInternal.h"

#import "REDRegistry.h"
#import "REDWindow.h"

#import <UIKit/UIKit.h>

// The C library
void red_showControlWindow(void)
{
    [REDlib showControlWindow];
}

void red_hideControlWindow(void)
{
    [REDlib hideControlWindow];
}

const int red_int(const char* name)
{
    return [[NSString stringWithCString:name encoding:NSUTF8StringEncoding] piv];
}

const int red_intd(const char* name, int def)
{
    return [[NSString stringWithCString:name encoding:NSUTF8StringEncoding] pivd:def];
}

const double red_double(const char* name)
{
    return [[NSString stringWithCString:name encoding:NSUTF8StringEncoding] pfv];    
}

const double red_doubled(const char* name, double def)
{
    return [[NSString stringWithCString:name encoding:NSUTF8StringEncoding] pfvd:def];    
}


// Implementation of REDlib categories
@implementation NSString(REDLib)

-(double) pfv
{
	return [[REDRegistry sharedInstance] doubleForKey:self withDefault:0.0];
}

-(void) setPfv:(double)val
{
	[[REDRegistry sharedInstance] setDouble:val forKey:self];
}

-(double) pfvd:(double)defaultValue
{
	return [[REDRegistry sharedInstance] doubleForKey:self withDefault:defaultValue];
}




-(int) piv
{
	return [[REDRegistry sharedInstance] intForKey:self withDefault:0];
}

-(void) setPiv:(int)val
{
	[[REDRegistry sharedInstance] setInt:val forKey:self];
}

-(int) pivd:(int)defaultValue
{
	return [[REDRegistry sharedInstance] intForKey:self withDefault:defaultValue];
}

-(NSString*) psv
{
	return [[REDRegistry sharedInstance] stringForKey:self withDefault:@""];
}

-(void) setPsv:(NSString *)val
{
	[[REDRegistry sharedInstance] setString:val forKey:self];
}

-(NSString*) psvd:(NSString*)defaultValue
{
	return [[REDRegistry sharedInstance] stringForKey:self withDefault:defaultValue];
}


-(void) bindToProperty:(NSString*)pName onObject:(NSObject*)obj;
{
	[[REDRegistry sharedInstance] bindName:self onto:pName ofObject:obj];
}
@end


@implementation NSDictionary(REDlib)

-(void) setREDlibSet:(int)set
{
	[[REDRegistry sharedInstance] replaceParamSet:set with:self];
}

@end



@implementation REDlib


+(void) attachGestureRecognizerToWindow:(UIWindow*)window
{
	[[REDlibInternal sharedInstance] attachGestureRecognizerToWindow:window];
}

+(void) toggleControlWindow
{
	[[REDlibInternal sharedInstance] toggleControlWindow];
}

+(void) showControlWindow
{
	[[REDlibInternal sharedInstance] showControlWindow];
}

+(void) hideControlWindow
{
	[[REDlibInternal sharedInstance] hideControlWindow];
}



@end



@implementation REDlibInternal

-(void) attachGestureRecognizerToWindow:(UIWindow*)window
{
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] init];
	[tap addTarget:self action:@selector(toggleControlWindow)];
	tap.numberOfTapsRequired = 3;
	tap.numberOfTouchesRequired = 2;
	[window addGestureRecognizer:tap];
}

-(void) toggleControlWindow;
{
    if (_isShowingUI)
    {
        [self hideControlWindow];
    }
    else
    {
        [self showControlWindow];
    }
}

-(void) showControlWindow
{
    if (_isShowingUI) return;

    _userKeyWindow = [UIApplication sharedApplication].keyWindow;
    
    REDWindow* red = [REDWindow sharedInstance];
    [red makeKeyAndVisible];
    [red becomeFirstResponder];
    red.hidden = NO;
    
    // Why not fade it in eh???
    red.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{ red.alpha = 1.0; }];
    
    _isShowingUI = YES;
}

-(void) hideControlWindow
{
    if (!_isShowingUI) return;
    
    REDWindow* red = [REDWindow sharedInstance];

    [UIView animateWithDuration:0.5 animations:^{
        red.alpha = 0.0;
    } completion:^(BOOL finished){
        [REDWindow sharedInstance].hidden = YES;
        [_userKeyWindow makeKeyWindow];        
    }];

    _isShowingUI = NO;
}

static REDlibInternal* _gShared_REDlibInternal;
+(REDlibInternal*) sharedInstance
{
    @synchronized(self)
    {
        if (!_gShared_REDlibInternal)
        {
            _gShared_REDlibInternal = [[REDlibInternal alloc] init];
        }
        return _gShared_REDlibInternal;
    }
}
@end
