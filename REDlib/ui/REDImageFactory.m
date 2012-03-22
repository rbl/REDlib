//
//  ParmyImageFactory.m
//  NoNameLib
//
//  Created by Tom Seago on 7/17/11.
//  Copyright 2011 Reality Box Labs LLC. All rights reserved.
//

#import "REDImageFactory.h"

@implementation REDImageFactory

static REDImageFactory* _gSharedParmyImageFactory;
+(REDImageFactory*)sharedInstance
{
    @synchronized(self)
    {
        if (!_gSharedParmyImageFactory)
        {
            _gSharedParmyImageFactory = [[REDImageFactory alloc] init];
        }
        return _gSharedParmyImageFactory;
    }
}

-(UIImage*) leftCapsuleAtWidth:(double)width forState:(PImageState)state
{
	switch (state) {
		case PImageStateBase:
		case PImageStateBaseSelected:
			return [[UIImage imageNamed:@"Parmy-capsuleLeftBase.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];

		case PImageStatePressed:
		case PImageStatePressedSelected:
			return [[UIImage imageNamed:@"Parmy-capsuleLeftPressed.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
	}
	
	return nil;			
}

-(UIImage*) middleCapsuleAtWidth:(double)width forState:(PImageState)state
{
	switch (state) {
		case PImageStateBase:
		case PImageStateBaseSelected:
			return [UIImage imageNamed:@"Parmy-capsuleMiddleBase.png"];
			
		case PImageStatePressed:
		case PImageStatePressedSelected:
			return [UIImage imageNamed:@"Parmy-capsuleMiddlePressed.png"];
	}
	
	return nil;			
}

-(UIImage*) rightCapsuleAtWidth:(double)width forState:(PImageState)state
{
	switch (state) {
		case PImageStateBase:
		case PImageStateBaseSelected:
			return [[UIImage imageNamed:@"Parmy-capsuleRightBase.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
			
		case PImageStatePressed:
		case PImageStatePressedSelected:
			return [[UIImage imageNamed:@"Parmy-capsuleRightPressed.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
	}
	
	return nil;	
}

-(UIImage*) popoverFrame
{
	return [[UIImage imageNamed:@"Parmy-popoverFrame.png"] stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
}

-(UIImage*) popoverFrameNibPointedUp:(BOOL)pointedUp
{
	
	return pointedUp ? [UIImage imageNamed:@"Parmy-nibUp.png"] :  [UIImage imageNamed:@"Parmy-nibDown.png"];
}

-(UIImage*) closeButton
{
    if (_closeButton) return _closeButton;
    
    // Have to create it
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
    CGContextFillEllipseInRect(ctx, CGRectMake(0, 0, 30, 30));

    CGContextSetRGBFillColor(ctx, 0.0, 0.0, 0.0, 1.0);
    CGContextFillEllipseInRect(ctx, CGRectMake(2, 2, 26, 26));
    
    CGContextSetRGBStrokeColor(ctx, 1.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(ctx, 3);
    CGContextStrokeLineSegments(ctx, (CGPoint[]){
        CGPointMake(5, 5), CGPointMake(25, 25),
        CGPointMake(5, 25), CGPointMake(25, 5)
    }, 2);

    _closeButton = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return _closeButton;
}

-(UIImage*) closeX
{
    if (_closeButton) return _closeButton;
    
    // Have to create it
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(10, 10), NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(ctx, 1.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(ctx, 3);
    CGContextStrokeLineSegments(ctx, (CGPoint[]){
        CGPointMake(0, 0), CGPointMake(10, 10),
        CGPointMake(0, 10), CGPointMake(10, 0)
    }, 4);
    
    _closeButton = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return _closeButton;
}

@end
