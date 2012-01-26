//
//  ParmyAdjustmentPopover.h
//  NoNameLib
//
//  Created by Tom Seago on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "REDPopover.h"
#import "REDNumericalAdjustment.h"

@interface REDAdjustmentPopover : REDPopover <ParmyValueChangedDelegate>
{

	int _set;
	NSString* _key;
	
	UIView* _adjView;
}

@property (nonatomic, retain) NSString *key;

@property (nonatomic, retain) UIView *adjView;

-(id) initOnView:(UIView*)parent withKey:(NSString*)key andSet:(int)set;

@end
