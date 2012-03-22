//
//  REDFloatingViewController.h
//  REDlib
//
//  Created by Tom Seago on 12/30/11.
//  Copyright 2011 Reality Box Labs LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface REDFloatingViewController : UIViewController
{
    UIView* _floatingView;
    UIView* _frameView;
    
    CGPoint _panStart;
}

@property (nonatomic, strong) UIView* floatingView;

@end
