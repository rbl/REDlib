//
//  ParmyPhoneRoot.m
//  Bumpy
//
//  Created by Tom Seago on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "REDPhoneRoot.h"

#import "REDTabParamsRoot.h"
#import "REDTabSetsRoot.h"

@interface REDPhoneRoot()

-(UIImage*) makeBGImage:(CGRect)frame;

@end


@implementation REDPhoneRoot

@synthesize view = _view;

#define INSET   24      // Should equal the status bar size

-(UIViewController*) getTabParams
{
    REDTabParamsRoot* root = [[REDTabParamsRoot alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:root];
    
    nav.title = root.title;
    // TODO: Implement custom tab bar icons for this tab
    
    return nav;
}

-(UIViewController*) getTabSets
{
    REDTabSetsRoot* root = [[REDTabSetsRoot alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:root];
    
    nav.title = root.title;
    // TODO: Implement custom tab bar icons for this tab
    
    return nav;
}

-(id) initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) 
    {
        // Create a nice image background
        // We could do this with 5 views to probably save memory, but don't bother
        // right now
        UIImage* bgImage = [self makeBGImage:frame];
        _view = [[UIImageView alloc] initWithImage:bgImage];
        _view.frame = frame;
        _view.userInteractionEnabled = YES;
        
        _tabBarController = [[UITabBarController alloc] init];
        _tabBarController.view.frame = CGRectMake(INSET, INSET, frame.size.width - (2*INSET), frame.size.height - (2*INSET));
        [_view addSubview:_tabBarController.view];
        
        // Add some tabs
        [_tabBarController addChildViewController:[self getTabParams]];
        [_tabBarController addChildViewController:[self getTabSets]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFloatingView:) name:@"REDlib show floating view" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideFloatingView:) name:@"REDlib hide floating view" object:nil];
    }
    return self;
}

-(UIImage*) makeBGImage:(CGRect)frame
{
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, [UIScreen mainScreen].scale);    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Top line
    CGContextMoveToPoint(ctx, INSET, 0);
    CGContextAddLineToPoint(ctx, w - INSET, 0);
    
    // Upper Right curve
    CGContextAddQuadCurveToPoint(ctx, w, 0, w, INSET);
    
    // Right side
    CGContextAddLineToPoint(ctx, w, h-INSET);
    
    // Bottom right curve
    CGContextAddQuadCurveToPoint(ctx, w, h, w-INSET, h);
    
    // Bottom
    CGContextAddLineToPoint(ctx, INSET, h);
    
    // Bottom left curve
    CGContextAddQuadCurveToPoint(ctx, 0, h, 0, h-INSET);
    
    // Left
    CGContextAddLineToPoint(ctx, 0, INSET);
    
    // Top left curve
    CGContextAddQuadCurveToPoint(ctx, 0, 0, INSET, 0);
    
    CGContextClosePath(ctx);
    
    // Fill it up
    CGContextSetRGBFillColor(ctx, 0.0, 0.0, 0.0, 0.8);
    CGContextFillPath(ctx);
    
    UIImage* ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return ret;
}
@end
