//
//  ParmyPopover.m
//  NoNameLib
//
//  Created by Tom Seago on 7/17/11.
//  Copyright 2011 Reality Box Labs LLC. All rights reserved.
//

#import "REDPopover.h"

#import "REDImageFactory.h"

@implementation REDPopover

@synthesize parent = _parent;
@synthesize windowFrame = _windowFrame;
@synthesize windowNib = _windowNib;

@synthesize view = _view;
@synthesize delegate = _delegate;

-(id) initOnView:(UIView*)parent
{    
	self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].bounds];
    if (self) 
	{
		self.parent = parent;
		self.windowFrame = [[UIImageView alloc] initWithImage:[[REDImageFactory sharedInstance] popoverFrame]];
		_windowFrame.userInteractionEnabled = YES;
		
		UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(externalTap:)];
		tap.delegate = self;
		[self addGestureRecognizer:tap];
		
		_width = 200;
		_height = 200;
    }
    return self;
}

-(void) present
{
	if ([_delegate respondsToSelector:@selector(willPresentPopover:)])
	{
		[_delegate willPresentPopover:self];
	}
	
	// For now always put our window frame at a fixed position from the 
	// parent view.
	UIWindow* win = [[UIApplication sharedApplication] keyWindow];
	CGRect pf = [win convertRect:_parent.bounds fromView:_parent];
	
	self.windowNib = [[UIImageView alloc] initWithImage:[[REDImageFactory sharedInstance] popoverFrameNibPointedUp:YES]];
	
	CGPoint anchor = CGPointMake(pf.origin.x + (pf.size.width/2), pf.origin.y + pf.size.height);
	
	float wfWidth = _width;
	float wfHeight = _height;

	CGRect wfFrame = CGRectMake(anchor.x - (wfWidth/2), anchor.y + _windowNib.bounds.size.height - 4,
								wfWidth, wfHeight);
	
	_windowFrame.frame = wfFrame;
	[self addSubview:_windowFrame];
	
	CGRect nibFrame = CGRectMake(anchor.x - (_windowNib.bounds.size.width/2),
								 anchor.y,
								 _windowNib.bounds.size.width,
								 _windowNib.bounds.size.height);
	_windowNib.frame = nibFrame;
	[self addSubview:_windowNib];
	
	CGRect childFrame = CGRectMake(10,10,wfWidth-20,wfHeight-20);
	_view.frame = childFrame;
	[_windowFrame addSubview:_view];

	if ([_delegate respondsToSelector:@selector(didPresentPopover:)])
	{
		[_delegate didPresentPopover:self];
	}
	
	// Don't forget to add ourself to the window or no one can see us!
	[win addSubview:self];
}

-(void) dealloc 
{
	self.parent = nil;
	self.windowFrame = nil;
	self.view = nil;	
}

-(void) hidePopover
{
	if ([_delegate respondsToSelector:@selector(willHidePopover:)])
	{
		[_delegate willHidePopover:self];
	}
	
	[self removeFromSuperview];
	
	if ([_delegate respondsToSelector:@selector(didHidePopover:)])
	{
		[_delegate didHidePopover:self];
	}	
}


-(void) externalTap:(id)recognizer
{
	[self hidePopover];
}


-(BOOL) gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
	CGPoint loc = [touch locationInView:self];
	
	CGRect wf = _windowFrame.frame;
	
	BOOL result = !CGRectContainsPoint(wf, loc);
	return result;
}

@end
