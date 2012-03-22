//
//  ParmyPopover.h
//  NoNameLib
//
//  Created by Tom Seago on 7/17/11.
//  Copyright 2011 Reality Box Labs LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class REDPopover;

@protocol ParmyPopoverDelegate <NSObject>
@optional
-(void) willPresentPopover:(REDPopover*)popover;
-(void) didPresentPopover:(REDPopover*)popover;

-(void) willHidePopover:(REDPopover*)popover;
-(void) didHidePopover:(REDPopover*)popover;

@end



@interface REDPopover : UIView <UIGestureRecognizerDelegate>
{
	__weak UIView* _parent;
	UIImageView* _windowFrame;
	UIImageView* _windowNib;
	
	UIView* _view;
	
	__weak id<ParmyPopoverDelegate> _delegate;
	
	float _width;
	float _height;
}

@property (nonatomic, weak) UIView *parent;
@property (nonatomic, retain) UIImageView *windowFrame;
@property (nonatomic, retain) UIImageView *windowNib;

@property (nonatomic, retain) UIView *view;

@property (nonatomic, weak) id<ParmyPopoverDelegate> delegate;

-(id) initOnView:(UIView*)parent;
-(void) present;
-(void) hidePopover;


@end
