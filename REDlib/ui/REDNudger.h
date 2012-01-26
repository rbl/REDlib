//
//  ParmyNudger.h
//  ParmyLib
//
//  Created by Tom Seago on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface REDNudger : UIView {

	UIButton* _btnLeft;
	UIButton* _btnRight;
	id _delegate;
	
	SEL _selLeft;
	SEL _selRight;
}

@property (nonatomic, retain) UIButton *btnLeft;
@property (nonatomic, retain) UIButton *btnRight;

-(id) initWithFrame:(CGRect)frame andDelegate:(id)delegate selLeft:(SEL)left selRight:(SEL)right;

@end
