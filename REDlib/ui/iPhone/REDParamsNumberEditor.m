//
//  ParmyParamsNumberEditor.m
//  Bumpy
//
//  Created by Tom Seago on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "REDParamsNumberEditor.h"
#import "REDRegistry.h"
#import "REDlibInternal.h"

@interface REDParamsNumberEditor()

-(void) updateIntLabel;
-(void) updateFloatLabel;

@end



@implementation REDParamsNumberEditor

-(id) initForKey:(NSString*)key withNumber:(NSNumber*)num
{
    self = [super init];
    if (self) 
    {
        _key = key;
        _num = num;
        
        _isInteger = (*_num.objCType != 'f') && (*_num.objCType != 'd');
        _isInteger = YES;
        
        self.title = _key;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone)];

        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
        self.view.autoresizesSubviews = YES;
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, 300, 30)];
        _numLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _numLabel.backgroundColor = [UIColor clearColor];
        _numLabel.opaque = NO;
        _numLabel.textColor = [UIColor whiteColor];
        _numLabel.textAlignment = UITextAlignmentCenter;
        _numLabel.text = @"Uh, hello???";
        [self.view addSubview:_numLabel];
        
        _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 236, 300, 100)];
        _picker.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _picker.delegate = self;
        _picker.dataSource = self;
        _picker.showsSelectionIndicator = YES;

        [self.view addSubview:_picker];
    }
    return self;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Set the value back to the registry
    [[REDRegistry sharedInstance] setNumber:_num forKey:_key];    
}

-(void) actionDone
{
    // Set the value back to the registry
    [[REDRegistry sharedInstance] setNumber:_num forKey:_key];
    
    [[REDlibInternal sharedInstance] hideControlWindow];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 6;
}

// returns the # of rows in each component..
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) return 2;

    if (_isInteger)
    {
        return 10;
    }
    else
    {
        // Floating pointness
        if (component < 5)
        {
            return 10;
        }
        else
        {
            return 19;
        }
    }
}


-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{    
    if (component==0) return row ? @"+" : @"-";
    
    if (_isInteger)
    {
        if (component < 5)
        {
            return [NSString stringWithFormat:@"%d", row];
        }
        else
        {
            return [NSString stringWithFormat:@"^%d",row];
        }
    }
    else
    {
        // Floating point selection
        if (component == 1)
        {
            return [NSString stringWithFormat:@".%d", row];
        }
        if (component < 5)
        {
            return [NSString stringWithFormat:@"%d", row];
        }
        else
        {
            if (row < 9)
            {
                return [NSString stringWithFormat:@"e+%d", 9-row];            
            }
            else if (row == 9)
            {
                return @"";
            }
            else
            {
                return [NSString stringWithFormat:@"e-%d", row-9];                        
            }
        }
    }

}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // Set the value from the wheel.

    if (_isInteger)
    {
        long long val = 0;
        
        for (int i=1; i<5; i++)
        {
            val = (10 * val) + [pickerView selectedRowInComponent:i];
        }
        
        int power = [pickerView selectedRowInComponent:5];
        val = val * pow(10, power);
        
        _longLongVal = [pickerView selectedRowInComponent:0] ? val : -val;
        [self updateIntLabel];        
    }
    else
    {
    }
}

-(void) updateIntLabel
{
    NSString* s = [NSString stringWithFormat:@"%qi", _longLongVal];;
    _numLabel.text = s;
}

-(void) updateFloatLabel
{
    
}

@end
