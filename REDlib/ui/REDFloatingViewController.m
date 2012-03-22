//
//  REDFloatingViewController.m
//  REDlib
//
//  Created by Tom Seago on 12/30/11.
//  Copyright 2011 Reality Box Labs LLC. All rights reserved.
//

#import "REDFloatingViewController.h"

#import "REDImageFactory.h"
#import "REDWindow.h"

#import <QuartzCore/QuartzCore.h>

@implementation REDFloatingViewController

@synthesize floatingView = _floatingView;

#define FRAME_HEIGHT    20
#define CORNER_RADIUS   8

-(id) init 
{
    self = [super init];
    if (self) 
    {
        // Create our floating header bar
        _frameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, FRAME_HEIGHT + (2*CORNER_RADIUS))];
        _frameView.backgroundColor = RED_TINT_COLOR;
        _frameView.userInteractionEnabled = YES;
        _frameView.layer.cornerRadius = CORNER_RADIUS;
        
        UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
        [_frameView addGestureRecognizer:pan];
        
        UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:[[REDImageFactory sharedInstance] closeX] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        closeButton.contentMode = UIViewContentModeCenter;
        
        closeButton.frame = CGRectMake(78, 2, 20, 20);
        closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [_frameView addSubview:closeButton];
        
        [self.view addSubview:_frameView];
        
        self.wantsFullScreenLayout = YES;
    }
    return self;
}

-(void) setFloatingView:(UIView *)floater
{
    if (_floatingView)
    {
        // Get rid of any old one
        [_floatingView removeFromSuperview];
    }
    _floatingView = floater;
    
    // Match our frame to just above the view
    CGRect vFrame = _floatingView.frame;
    if (vFrame.origin.y < FRAME_HEIGHT) {
        vFrame.origin.y = FRAME_HEIGHT;
    }
    
    CGRect frame = _frameView.frame;
    frame.origin = vFrame.origin;
    frame.origin.y -= FRAME_HEIGHT;
    frame.size.width = vFrame.size.width;
    _frameView.frame = frame;
    
    
    [self.view addSubview:_floatingView];
}

-(void) moveFrames:(CGPoint)translation
{
    CGRect frame = _frameView.frame;
    CGRect fFrame = _floatingView.frame;
    
    frame.origin.x = _panStart.x + translation.x;
    fFrame.origin.x = _panStart.x + translation.x;
    
    frame.origin.y = _panStart.y + translation.y;
    fFrame.origin.y = _panStart.y + FRAME_HEIGHT + translation.y;
    
    // Bounds check everybody
    if (frame.origin.x < 0)
    {
        frame.origin.x = 0;
        fFrame.origin.x = 0;
    }
    if (frame.origin.y < 0)
    {
        frame.origin.y = 0;
        fFrame.origin.y = FRAME_HEIGHT;
    }
    _frameView.frame = frame;
    _floatingView.frame = fFrame;
}

-(void) panRecognized:(UIPanGestureRecognizer*)recog
{
    CGPoint translation = [recog translationInView:self.view];

    
    switch (recog.state) {
        case UIGestureRecognizerStateBegan:
            _panStart = _frameView.frame.origin;
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        case UIGestureRecognizerStateChanged:
            [self moveFrames:translation];
            break;
        case UIGestureRecognizerStateEnded:
            [self moveFrames:translation];
            break;
            
        default:
            break;
    }
}

-(void) close:(id)sender
{
    [[REDWindow sharedInstance] hideFloatingView];
}

-(void) viewDidAppear:(BOOL)animated
{
}

@end
