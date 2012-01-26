//
//  REDInsetViewController.h
//  REDlib
//
//  Created by Tom Seago on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface REDInsetViewController : UIViewController
{
    UIViewController* _root;
    
    CGRect _goodFrame;
}

-(id) initWithFrame:(CGRect)frame andRootViewController:(UIViewController*)root;

@end
