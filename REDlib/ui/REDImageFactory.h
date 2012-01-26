//
//  ParmyImageFactory.h
//  NoNameLib
//
//  Created by Tom Seago on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	PImageStateBase = 0,
	PImageStateBaseSelected,
	PImageStatePressed,
	PImageStatePressedSelected
} PImageState;

@interface REDImageFactory : NSObject {

    UIImage* _closeButton;
}

+(REDImageFactory*) sharedInstance;

-(UIImage*) leftCapsuleAtWidth:(double)width forState:(PImageState)state;
-(UIImage*) middleCapsuleAtWidth:(double)width forState:(PImageState)state;
-(UIImage*) rightCapsuleAtWidth:(double)width forState:(PImageState)state;

-(UIImage*) popoverFrame;
-(UIImage*) popoverFrameNibPointedUp:(BOOL)pointedUp;

-(UIImage*) closeButton;
-(UIImage*) closeX;


@end
