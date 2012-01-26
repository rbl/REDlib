//
//  ParmyParamsNumberEditor.h
//  Bumpy
//
//  Created by Tom Seago on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface REDParamsNumberEditor : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSString* _key;
    NSNumber* _num;
    BOOL _isInteger;
    
    long long _longLongVal;
    double _doubleVal;
    
    UILabel* _numLabel;
    UIPickerView* _picker;
}

-(id) initForKey:(NSString*)key withNumber:(NSNumber*)num;

@end
