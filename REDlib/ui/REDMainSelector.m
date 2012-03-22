//
//  ParmyMainSelector.m
//  NoNameLib
//
//  Created by Tom Seago on 7/16/11.
//  Copyright 2011 Reality Box Labs LLC. All rights reserved.
//

#import "REDMainSelector.h"

#import "REDImageFactory.h"

#import "REDParamSelectPopover.h"
#import "REDAdjustmentPopover.h"
#import "REDRegistry.h"

@implementation REDMainSelector

@synthesize btnParam = _btnParam;
@synthesize btnA = _btnA;
@synthesize btnB = _btnB;
@synthesize btnGear = _btnGear;

@synthesize selectionIndicator = _selectionIndicator;
@synthesize popover = _popover;

NSString* gKey;
CGRect gFrame;
CGFloat gWidth;


-(id) initWithFrame:(CGRect)frame 
{
    
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code.
		if (!gWidth) gWidth = 80;

        // TODO: Something like the following ....
//        switch ([UIDevice currentDevice].orientation) {
//            case UIDeviceOrientationPortraitUpsideDown:
//                self.transform = CGAffineTransformMakeRotation(M_PI);
//                break;
//                
//            case UIDeviceOrientationLandscapeLeft:
//                self.transform = CGAffineTransformMakeRotation(M_PI_2);
//                break;
//                
//            case UIDeviceOrientationLandscapeRight:
//                self.transform = CGAffineTransformMakeRotation(-M_PI_2);
//                break;
//                
//            default:
//                break;
//        }
//        
        
		CGRect frame = CGRectMake(0,0,gWidth,32);
		
		self.btnParam = [UIButton buttonWithType:UIButtonTypeCustom];
		_btnParam.frame = frame;
		[_btnParam setBackgroundImage:[[REDImageFactory sharedInstance] leftCapsuleAtWidth:64.0 forState:PImageStateBase]
				   forState:UIControlStateNormal];
		[_btnParam setBackgroundImage:[[REDImageFactory sharedInstance] leftCapsuleAtWidth:64.0 forState:PImageStatePressed]
				   forState:UIControlStateSelected];
		[_btnParam setTitle:@"Choose Parameter" forState:UIControlStateNormal];
		[self addSubview:_btnParam];
		[_btnParam addTarget:self action:@selector(actionParam:) forControlEvents:UIControlEventTouchUpInside];

		
		frame.origin.x += frame.size.width;
		frame.size.width = 32;
		
//		self.btnA = [UIButton buttonWithType:UIButtonTypeCustom];
//		_btnA.frame = frame;
//		[_btnA setBackgroundImage:[[ParmyImageFactory sharedInstance] middleCapsuleAtWidth:frame.size.width forState:PImageStateBase]
//				   forState:UIControlStateNormal];
//		[_btnA setBackgroundImage:[[ParmyImageFactory sharedInstance] middleCapsuleAtWidth:frame.size.width forState:PImageStatePressed]
//			   forState:UIControlStateSelected];
//		[_btnA setTitle:@"A" forState:UIControlStateNormal];
//		[self addSubview:_btnA];
//		[_btnA addTarget:self action:@selector(actionSetA:) forControlEvents:UIControlEventTouchUpInside];
//
//		// Sidebar to get this indicator on the page behind the button
//		CGRect selFrame = frame;
//		selFrame.origin.y -= 10.0;
//		selFrame.size.height += 20;
//		self.selectionIndicator = [[[UIView alloc] initWithFrame:selFrame] autorelease];
//		_selectionIndicator.backgroundColor = [UIColor yellowColor];
//		_selectionIndicator.alpha = 0.3;
//		_selectionIndicator.userInteractionEnabled = NO;
//
//		
//		frame.origin.x += frame.size.width;
//		frame.size.width = 32;
//		self.btnB = [UIButton buttonWithType:UIButtonTypeCustom];
//		_btnB.frame = frame;
//		[_btnB setBackgroundImage:[[ParmyImageFactory sharedInstance] middleCapsuleAtWidth:frame.size.width forState:PImageStateBase]
//			   forState:UIControlStateNormal];
//		[_btnB setBackgroundImage:[[ParmyImageFactory sharedInstance] middleCapsuleAtWidth:frame.size.width forState:PImageStatePressed]
//			   forState:UIControlStateSelected];
//		[_btnB setTitle:@"B" forState:UIControlStateNormal];
//		[self addSubview:_btnB];
//		[_btnB addTarget:self action:@selector(actionSetB:) forControlEvents:UIControlEventTouchUpInside];
//
//
//		
//		[self addSubview:_selectionIndicator];
		
		
		
		
		
		frame.origin.x += frame.size.width;
		frame.size.width = 32;
		self.btnGear = [UIButton buttonWithType:UIButtonTypeInfoLight];
		_btnGear.frame = frame;
		[_btnGear setBackgroundImage:[[REDImageFactory sharedInstance] rightCapsuleAtWidth:frame.size.width forState:PImageStateBase]
			   forState:UIControlStateNormal];
		[_btnGear setBackgroundImage:[[REDImageFactory sharedInstance] rightCapsuleAtWidth:frame.size.width forState:PImageStatePressed]
			   forState:UIControlStateSelected];
		[_btnGear setTitle:@"G" forState:UIControlStateNormal];
		[self addSubview:_btnGear];
		[_btnGear addTarget:self action:@selector(actionGear:) forControlEvents:UIControlEventTouchUpInside];		

		frame.origin.x = 0;
		frame.size.width = _btnParam.bounds.size.width +
//							_btnA.bounds.size.width +
//							_btnB.bounds.size.width +
							_btnGear.bounds.size.width;

		self.frame = frame;
		
		// Select the first "key"
		if (gFrame.size.height > 0) 
		{
			// Used the stored value
			self.frame = gFrame;
			[self selectedParamKey:gKey];
		}
		else
		{
			// Get a proper sizing
			[self selectedParamKey:@"Choose Parameter"];
			
			// Now might as well center it on the screen
			frame = [[UIApplication sharedApplication] keyWindow].bounds;
			self.center = CGPointMake(frame.size.width/2, frame.size.height/2);
			gFrame = self.frame;
		}
		
		// Want to be able to drag around
		UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
		pan.cancelsTouchesInView = NO;
		pan.delegate = self;
		[self addGestureRecognizer:pan];
		
		UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
		longPress.cancelsTouchesInView = NO;
		[self addGestureRecognizer:longPress];
	}
    return self;
}

-(void)dealloc 
{
	self.btnParam = nil;
	self.btnA = nil;
	self.btnB = nil;
	self.btnGear = nil;
	
	self.popover = nil;
	
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

-(void) actionParam:(UIButton*) sender
{
	_pressed.selected = NO;
	sender.selected = YES;
	
	REDParamSelectPopover* select = [[REDParamSelectPopover alloc] initOnView:sender];
	select.delegate = self;
	select.selectDelegate = self;
	[select present];
	self.popover = select;
	
	_pressed = sender;
}

-(void) actionSetA:(UIButton*) sender
{
	_pressed.selected = NO;
	_pressed = nil;
	if ([_btnParam.titleLabel.text isEqual:@"Choose Parameter"]) return;
	
	sender.selected = YES;

	_selectionIndicator.center = sender.center;
	[[REDRegistry sharedInstance] setCurrentSet:0];
	
	_pressed = sender;

	// Launch a thingie
	REDAdjustmentPopover* adj = [[REDAdjustmentPopover alloc] initOnView:sender 
																	  withKey:_btnParam.titleLabel.text 
																	   andSet:0];
	self.popover = adj;
	[adj present];
}

-(void) actionSetB:(UIButton*) sender
{
	_pressed.selected = NO;
	sender.selected = YES;

	_selectionIndicator.center = sender.center;
	[[REDRegistry sharedInstance] setCurrentSet:1];

	_pressed = sender;
}

-(void) actionGear:(UIButton*) sender
{
	[self actionSetA:sender];
//	_pressed.selected = NO;
//	sender.selected = YES;
//	[self removeFromSuperview];
//
//	_pressed = sender;
}


-(void) didHidePopover:(REDPopover*)pop
{
	_pressed.selected = NO;
	self.popover = nil;
}


-(void) selectedParamKey:(NSString*)key
{
	gKey = key;
	
	//CGRect frameBefore = _btnParam.frame;
	//CGRect frameAfter = _btnParam.frame;
	
	CGSize size = [key sizeWithFont:_btnParam.titleLabel.font];
	
	CGRect frame = _btnParam.frame;
	CGFloat newWidth = size.width + 32.0;	
	CGFloat delta = newWidth - frame.size.width;
	frame.size.width = newWidth;
	
	// This is a little insane what I'm doing here, but I kind of don't care
	// because I'm tired.
	
	// Now re-lay out everything from position 0
	_btnParam.frame = frame;
	
//	frame.origin.x += frame.size.width;
//	frame.size.width = _btnA.frame.size.width;
//	_btnA.frame = frame;
//	
//	frame.origin.x += frame.size.width;
//	frame.size.width = _btnB.frame.size.width;
//	_btnB.frame = frame;

	frame.origin.x += frame.size.width;
	frame.size.width = _btnGear.frame.size.width;
	_btnGear.frame = frame;
	
	// Okay, but now move the OUTER frame by the delta amount and also resize it
	frame = self.frame;
	frame.size.width += delta;
	frame.origin.x -= delta;
	self.frame = frame;

	gFrame = self.frame;
	gWidth = _btnParam.frame.size.width;
	
//	frame = _selectionIndicator.frame;
//	frame.origin.x += delta;
//	_selectionIndicator.frame = frame;

	[_btnParam setTitle:key forState:UIControlStateNormal];		
}

#pragma mark -
#pragma mark Gesture recog delegate

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	// Always do simultaneous recog
	return YES;
}

-(void) longPress:(UILongPressGestureRecognizer*)recog
{
	
	if (UIGestureRecognizerStateBegan)
	{
		NSLog(@"Long press ---- state begain");
		_gotLongPress = YES;
	}
	else if (UIGestureRecognizerStateEnded)
	{
		_gotLongPress = NO;
		NSLog(@"Long press ---- all done now");
	}
	// else don't mess with it		
}

-(void) panned:(UIPanGestureRecognizer*)recog
{
	NSLog(@"Panned");
	
	switch (recog.state) {
		case UIGestureRecognizerStateBegan:
			_startCenter = self.center;
			// Intentional fallthrough
		case UIGestureRecognizerStateChanged:
			NSLog(@"Pan begin or changed");
			
			if (!_gotLongPress) return;
			
			///////
			{
				CGPoint trans = [recog translationInView:self];
				NSLog(@"%f, %f", trans.x, trans.y);
				CGPoint center = self.center;
				center.x = _startCenter.x + trans.x;
				center.y = _startCenter.y + trans.y;
				self.center = center;
				gFrame = self.frame;
			}
			break;
			
		case UIGestureRecognizerStateEnded:
			NSLog(@"Pan ended");
			break;	
			
		default:
			break;
	}
}



-(void) close
{
	[_popover hidePopover];
	[self removeFromSuperview];
}

@end
