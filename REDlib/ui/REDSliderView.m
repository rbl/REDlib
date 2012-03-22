//
//  REDSliderView.m
//  REDlib
//
//  Created by Tom Seago on 12/30/11.
//  Copyright 2011 Reality Box Labs LLC. All rights reserved.
//

#import "REDSliderView.h"

#import <QuartzCore/QuartzCore.h>

#import "REDRegistry.h"

@interface REDSliderView()

-(void) toggleSelection;
-(void) updateLabels;
-(void) updateKeyLabel;
-(void) checkUnits;

@end


@implementation REDSliderView

#define X_SIZE      20
#define X_OFFSET    5

-(id) initForKey:(NSString*)fullKey withNumber:(NSNumber*)num
{
    CGRect frame = CGRectMake(250, 50, 60, 300);
    self = [super initWithFrame:frame];
    if (self) 
    {
        _key = fullKey;
        _num = num;
        
        const char *c = _num.objCType;
        _isInteger = (*c != 'f') && (*c != 'd');
        
        if (_isInteger)
        {
            _llVal = [num longLongValue];
        }
        else
        {
            _dVal = [num doubleValue];
        }
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        _numLabel.textAlignment = UITextAlignmentCenter;
        _numLabel.backgroundColor = [UIColor blackColor];
        _numLabel.adjustsFontSizeToFitWidth = YES;

        [self addSubview:_numLabel];
        
        _unitsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-20, 60, 20)];
        _unitsLabel.textAlignment = UITextAlignmentCenter;        
        _unitsLabel.backgroundColor = [UIColor blackColor];
        _unitsLabel.adjustsFontSizeToFitWidth = YES;

        [self addSubview:_unitsLabel];
        
        
        UILabel* lbl;
        
        _keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 60, 20)];
        _keyLabel.backgroundColor = [UIColor clearColor];
        _keyLabel.text = @"Value";
        _keyLabel.adjustsFontSizeToFitWidth = YES;
        _keyLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_keyLabel];

        lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-40, 60, 20)];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.text = @"Multiplier";
        lbl.adjustsFontSizeToFitWidth = YES;
        lbl.textAlignment = UITextAlignmentCenter;        
        [self addSubview:lbl];

        lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 125, 60, 50)];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.text = @"Drag Here";
        lbl.numberOfLines = 5;
        lbl.textAlignment = UITextAlignmentCenter;        
        [self addSubview:lbl];
        
        
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleSelection)];
        [self addGestureRecognizer:tap];
        
        UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
        [self addGestureRecognizer:pan];
        
        // Get the labels setup right
        _isNumSelected = NO;
        [self toggleSelection];
        
        [self checkUnits];
        [self updateLabels];
        
        [self updateKeyLabel];
        self.opaque = NO;
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //CGFloat w = self.bounds.size.width;
    //CGFloat h = self.bounds.size.height;
        
    // Assume the clip region is already set and we can just paint the whole thing
    
    CGContextSetRGBFillColor(ctx, 0.0, 0.0, 0.0, 0.2);
    CGContextFillRect(ctx, self.bounds);
    
    CGContextSetRGBStrokeColor(ctx, 1.0, 1.0, 1.0, 1.0);
    CGContextStrokeRectWithWidth(ctx, self.bounds, 1); 
}

-(void) toggleSelection
{
    UILabel* selected = _isNumSelected ? _unitsLabel : _numLabel;
    UILabel* unselected = _isNumSelected ? _numLabel : _unitsLabel;
    
    selected.textColor = [UIColor redColor];
    unselected.textColor = [UIColor whiteColor];

    _isNumSelected = !_isNumSelected;
}

-(void) updateLabels
{
    if (_isInteger)
    {
        _numLabel.text = [NSString stringWithFormat:@"%qi", _llVal];
        _unitsLabel.text = [NSString stringWithFormat:@"%qi", _llUnits];
    }
    else
    {
        _numLabel.text = [NSString stringWithFormat:@"%.3f", _dVal];
        _unitsLabel.text = [NSString stringWithFormat:@"%.3f", _dUnits];
    }
}

-(void) adjustValue:(CGFloat)distance
{
    NSLog(@"distance = %f", distance);
    if (_isNumSelected)
    {
        if (_isInteger)
        {
            long long delta = (long long)((distance/10.0) * (double)_llUnits);
            _llVal = _llStart + delta;            
            [[REDRegistry sharedInstance] setInt:_llVal forKey:_key];
        }
        else
        {
            double delta = distance/10.0 * _dUnits;
            _dVal = _dStart + delta;
            [[REDRegistry sharedInstance] setDouble:_dVal forKey:_key];
        }
    }
    else
    {
        // "Units"
        if (_isInteger)
        {
            long long delta = (long long)((distance/10.0) * (0.1 * (double)_llStart));
            _llUnits = _llStart + delta;

            // Cap it though ...
            _llUnits = MIN(_llUnits, 100000);
            _llUnits = MAX(_llUnits, -100000);
        }
        else
        {
            double delta = (distance/10.0) * (0.1 * _dStart);
            _dUnits = _dStart + delta;
            _dUnits = MIN(_dUnits, 100000);
            _dUnits = MAX(_dUnits, -100000);            
        }
    }
    
    
    [self updateLabels];
}

-(void) checkUnits
{
    if (_isInteger)
    {
        if (_llUnits == 0)
        {
            _llUnits = 1;
            [self updateLabels];
        }
    }
    else
    {
        // Admittedly unlikely to happen but hey
        if (_dUnits == 0.0)
        {
            _dUnits = 1.0;
            [self updateLabels];
        }
        
        if (_dUnits < 0.001 && _dUnits > 0.0)
        {
            _dUnits = 0.001;
            [self updateLabels];
        }
        if (_dUnits > -0.001 && _dUnits < 0.0)
        {
            _dUnits = -0.001;
            [self updateLabels];
        }
    }
}

-(void) panRecognized:(UIPanGestureRecognizer*)recog
{
    switch (recog.state) {
        case UIGestureRecognizerStateBegan:
            _panStart = [recog locationInView:self];
            _llStart = _isNumSelected ? _llVal : _llUnits;
            _dStart = _isNumSelected ? _dVal : _dUnits;
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        case UIGestureRecognizerStateChanged:
            ;
            CGPoint trans = [recog locationInView:self];
            NSLog(@"panstart.y=%f, trans.y=%f", _panStart.y, trans.y);
            [self adjustValue:(_panStart.y-trans.y)];
            break;
        case UIGestureRecognizerStateEnded:
            // Fix up the units so we don't get needlessly stuck
            [self checkUnits];
            break;
            
        default:
            break;
    }
}

-(void) updateKeyLabel
{
    NSArray* comps = [_key componentsSeparatedByString:@" "];
    
    if (comps.count == 1)
    {
        _keyLabel.text = _key;
    }
    else
    {
        NSString* prefix = [comps objectAtIndex:0];
        _keyLabel.text = [_key substringFromIndex:prefix.length+1];
    }
}

@end
