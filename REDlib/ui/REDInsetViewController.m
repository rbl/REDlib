//
//  REDInsetViewController.m
//  REDlib
//
//  Created by Tom Seago on 12/30/11.
//  Copyright 2011 Reality Box Labs LLC. All rights reserved.
//

#import "REDInsetViewController.h"

#import <QuartzCore/QuartzCore.h>

#define INSET   20

@interface REDInsetViewController()

-(UIImage*) makeBGImage:(CGRect)frame;

@end


@implementation REDInsetViewController


-(id) initWithFrame:(CGRect)frame andRootViewController:(UIViewController*)root
{
    self = [super init];
    if (self) 
    {
        // Create a nice image background
        // We could do this with 5 views to probably save memory, but don't bother
        // right now
//        UIImage* bgImage = [self makeBGImage:frame];
//        UIView* view = [[UIImageView alloc] initWithImage:bgImage];
        UIView* view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        
        _goodFrame = frame;
        view.frame = frame;
        view.userInteractionEnabled = YES;
        self.view = view;
        
        [view addObserver:self forKeyPath:@"frame" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];

        _root = root;        
        CGRect frameIn = CGRectMake(INSET, INSET, frame.size.width - (2*INSET), frame.size.height - (2*INSET));
        _root.view.frame = frameIn;
        _root.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _root.view.layer.cornerRadius = INSET/2;
        _root.view.clipsToBounds = YES;
        
        view.autoresizesSubviews = YES;
        
        [view addSubview:_root.view];
        self.wantsFullScreenLayout = YES;
    }
    return self;
}

-(UIImage*) makeBGImage:(CGRect)frame
{
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, [UIScreen mainScreen].scale);    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Fill it up
    CGContextSetRGBFillColor(ctx, 0.8, 0.0, 0.0, 0.8);
    CGContextFillRect(ctx, frame);
    
    CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
    CGFloat fontSize = [UIFont smallSystemFontSize];
    UIFont* font = [UIFont systemFontOfSize:fontSize];
    CGFloat fontInset = (INSET - fontSize) / 2;
    
    NSString* str = @"REDlib REDlib REDlib REDlib REDlib REDlib REDlib REDlib REDlib REDlib REDlib REDlib REDlib";
    [str drawInRect:CGRectMake(0, fontInset, w, INSET) withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
    [str drawInRect:CGRectMake(0, h - fontInset - fontSize, w, INSET) withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
    
    UIImage* ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return ret;
}

-(UIImage*) makeBGImageCurved:(CGRect)frame
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
    CGContextSetRGBFillColor(ctx, 0.8, 0.0, 0.0, 0.8);
    CGContextFillPath(ctx);
    
    UIImage* ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return ret;
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [_root shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

-(void) viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
    [_root viewWillAppear:animated];    
}

-(void) viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewWillDisappear");
    [_root viewWillDisappear:animated];
}

-(void) viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");
    [_root viewDidAppear:animated];
//    // Make sure the proper frame is still set dammit!
//    self.view.frame = _goodFrame;
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSLog(@"viewDidDisappear");
    [_root viewDidDisappear:animated];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"Frame changed");
    for(NSObject* key in change)
    {
        NSObject* value = [change objectForKey:key];
        NSLog(@"    %@ = %@", key, value);
    }
}
@end
