//
//  ParmyAdjustmentPopover.m
//  NoNameLib
//
//  Created by Tom Seago on 7/17/11.
//  Copyright 2011 Reality Box Labs LLC. All rights reserved.
//

#import "REDAdjustmentPopover.h"

#import "REDRegistry.h"

@interface REDAdjustmentPopover()

-(void) loadNumericalAdjustment:(NSNumber*)num;

@end

@implementation REDAdjustmentPopover

@synthesize key = _key;
@synthesize adjView = _adjView;

-(id) initOnView:(UIView*)parent withKey:(NSString*)key andSet:(int)set
{    
    self = [super initOnView:parent];
    if (self) 
	{
		_set = set;
		self.key = key;
		
		_width = 300;
		_height = 160;
		
		self.view = [[UIView alloc] initWithFrame:CGRectMake(0,0,_width,_height)];
		self.view.backgroundColor = [UIColor clearColor];
		
		// Find the right type of adjustment sub-view to load
		NSObject* obj = [[REDRegistry sharedInstance] objectInSet:_set forKey:_key];
		
		if ([obj isKindOfClass:[NSNumber class]])
		{
			[self loadNumericalAdjustment:(NSNumber*)obj];
		}
		// else something else ...
    }
    return self;
}


-(void)dealloc 
{
	self.key = nil;
	self.adjView = nil;
}


-(void) loadNumericalAdjustment:(NSNumber*)num
{
	self.adjView = [[REDNumericalAdjustment alloc] initForValue:num withDelegate:self];
	
	_adjView.frame = CGRectMake(0,0,_width,_height);
	_adjView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	[_view addSubview:_adjView];
}


-(void) valueChanged:(double)val
{
	[[REDRegistry sharedInstance] setDouble:val forKey:_key];
}


@end
