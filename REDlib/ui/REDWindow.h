//
//  REDWindow.h
//  REDlib
//
//  Created by Tom Seago on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RED_TINT_COLOR  [UIColor colorWithRed:0.4 green:0.0 blue:0.0 alpha:0.8]

@class REDInsetViewController;
@class REDFloatingViewController;
@interface REDWindow : UIWindow
{
    UITabBarController* _tabBarController;
    REDInsetViewController* _insetViewController;
    REDFloatingViewController* _floatingViewController;
    
    UIViewController* _myRoot;
}

-(void) showFloatingView:(UIView*)view;
-(void) hideFloatingView;

+(REDWindow*) sharedInstance;
@end
