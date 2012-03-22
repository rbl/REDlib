//
//  ParmyOverlay.m
//  NoNameLib
//
//  Created by Tom Seago on 7/16/11.
//  Copyright 2011 Reality Box Labs LLC. All rights reserved.
//

#import "REDOverlay.h"

#import "REDMainSelector.h"

@implementation REDOverlay

@synthesize window = _window;
@synthesize mainSelector = _mainSelector;

-(id) initWithFrame:(CGRect)frame 
{    
    self = [super initWithFrame:frame];
    if (self) 
	{
		self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
		self.opaque = NO;
		
		self.mainSelector = [[REDMainSelector alloc] initWithFrame:CGRectMake(20,20,250,40)];
		[self addSubview:_mainSelector];
    }
    return self;
}


@end
