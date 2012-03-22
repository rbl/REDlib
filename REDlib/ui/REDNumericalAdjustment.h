//
//  ParmyNumericalAdjustment.h
//  NoNameLib
//
//  Created by Tom Seago on 7/17/11.
//  Copyright 2011 Reality Box Labs LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ParmyValueChangedDelegate <NSObject>

-(void)valueChanged:(double)value;

@end

@interface REDNumericalAdjustment : UIView 
{
	BOOL _useFloats;
	
	UISlider* _slider;
	UILabel* _minLabel;
	UILabel* _currentLabel;
	UILabel* _maxLabel;
	
	UIButton* _moveMin;
	UIButton* _moveMax;
	
	UIButton* _decreaseSingle;
	UIButton* _increaseSingle;
	
	__weak id<ParmyValueChangedDelegate> _delegate;
}

@property (nonatomic, retain) UISlider *slider;
@property (nonatomic, retain) UILabel *minLabel;
@property (nonatomic, retain) UILabel *currentLabel;
@property (nonatomic, retain) UILabel *maxLabel;

@property (nonatomic, retain) UIButton *moveMin;
@property (nonatomic, retain) UIButton *moveMax;

@property (nonatomic, retain) UIButton *decreaseSingle;
@property (nonatomic, retain) UIButton *increaseSingle;


-(id) initForValue:(NSNumber*)num withDelegate:(id<ParmyValueChangedDelegate>)delegate;

-(void) updateLabelsWithAnim:(BOOL)doAnim;

@end
