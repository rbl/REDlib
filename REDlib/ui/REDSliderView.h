//
//  REDSliderView.h
//  REDlib
//
//  Created by Tom Seago on 12/30/11.
//  Copyright 2011 Reality Box Labs LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface REDSliderView : UIView
{
    NSString* _key;
    NSNumber* _num;
    BOOL _isInteger;
    
    long long _llVal;
    long long _llUnits;
    long long _llStart;
    double _dVal;
    double _dUnits;
    double _dStart;
    
    UILabel* _keyLabel;
    UILabel* _numLabel;
    UILabel* _unitsLabel;
    BOOL _isNumSelected;
    
    CGPoint _panStart;
}

-(id) initForKey:(NSString*)fullKey withNumber:(NSNumber*)num;
@end
