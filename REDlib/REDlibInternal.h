//
//  ParmyLib.h
//  NoNameLib
//
//  Created by Tom Seago on 7/16/11.
//  Copyright 2011 Reality Box Labs LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIWindow;
@class REDMainSelector;

@interface REDlibInternal : NSObject 
{
    BOOL _isShowingUI;
    
    UIWindow* _userKeyWindow;
}

+(REDlibInternal*) sharedInstance;

-(void) attachGestureRecognizerToWindow:(UIWindow*)window;
-(void) toggleControlWindow;

-(void) showControlWindow;
-(void) hideControlWindow;


@end
