//
//  REDWindow.m
//  REDlib
//
//  Created by Tom Seago on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "REDWindow.h"

#import "REDPhoneWindow.h"
#import "REDPadWindow.h"
#import "REDTabParamsRoot.h"
#import "REDTabSetsRoot.h"
#import "REDFloatingViewController.h"
#import "REDInsetViewController.h"

@interface REDWindow()

-(UIViewController*) getTabParams;
-(UIViewController*) getTabSets;

@end

@implementation REDWindow


-(id) init
{
    self = [super init];
    if (self)
    {
        // Make sure we're on top of everyone else, 'cause that's how we are
        //self.windowLevel = UIWindowLevelStatusBar;
        
        UIScreen* screen = [UIScreen mainScreen];
        CGRect frame = screen.bounds;
                
        // Start with our phone root view
        _tabBarController = [[UITabBarController alloc] init];
        _tabBarController.view.frame = frame;
        _tabBarController.tabBar.tintColor = RED_TINT_COLOR;
        
        // Add some tabs
        [_tabBarController addChildViewController:[self getTabParams]];
        [_tabBarController addChildViewController:[self getTabSets]];
        
        //self.rootViewController = _tabBarController;        
        _insetViewController = [[REDInsetViewController alloc] initWithFrame:frame andRootViewController:_tabBarController];
        self.rootViewController = _insetViewController;
        
        // For floating views we use a floating view control to layer them into
        _floatingViewController = [[REDFloatingViewController alloc] init];
        
        self.userInteractionEnabled = YES;
        
        self.windowLevel = UIWindowLevelStatusBar;
    }
    
    return self;
}


-(UIViewController*) getTabParams
{
    REDTabParamsRoot* root = [[REDTabParamsRoot alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:root];
    
    nav.navigationBar.tintColor = RED_TINT_COLOR;
    nav.title = root.title;
    // TODO: Implement custom tab bar icons for this tab
    
    return nav;
}

-(UIViewController*) getTabSets
{
    REDTabSetsRoot* root = [[REDTabSetsRoot alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:root];
    
    nav.navigationBar.tintColor = [UIColor redColor];
    nav.title = root.title;
    // TODO: Implement custom tab bar icons for this tab
    
    return nav;
}

-(void) showFloatingView:(UIView*)view
{
    _floatingViewController.floatingView = view;
    self.rootViewController = _floatingViewController;
}

-(void) hideFloatingView
{
    self.rootViewController = _insetViewController;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{    
    // I'm unclear why the super method is ignoring the events, but
    // let's not.
    UIView* view = self.rootViewController.view;
//    CGRect a = self.bounds;
//    CGRect f = self.frame;
//    CGRect ba  = view.bounds;
//    CGRect bf = view.bounds;
    
    CGPoint test = [view convertPoint:point fromView:self];
    UIView* foo = [view hitTest:test withEvent:event];
    
    return foo;
}
#pragma mark -
#pragma mark Singleton

static REDWindow* _gShared_REDWindow;
+(REDWindow*) sharedInstance
{
    @synchronized(self)
    {
        if (!_gShared_REDWindow)
        {
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
            {
                _gShared_REDWindow = [[REDPhoneWindow alloc] init];
            }
            else
            {
                // Same for now ...
                _gShared_REDWindow = [[REDPadWindow alloc] init];
            }
        }
        return _gShared_REDWindow;
    }
}
@end
