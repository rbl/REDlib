//
//  ParmyPhoneRoot.h
//  Bumpy
//
//  Created by Tom Seago on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface REDPhoneRoot : NSObject
{
    UIView* _view;
    UITabBarController* _tabBarController;    
}

@property (nonatomic, readonly) UIView* view;

-(id) initWithFrame:(CGRect)frame;


@end
