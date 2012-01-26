//
//  ParmyParamPicker.h
//  NoNameLib
//
//  Created by Tom Seago on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


//@interface ParmyParamPicker : UIView <UITableViewDelegate, UITableViewDataSource> 
@interface REDParamPicker : UIView 
{
	UITableView* _tableView;
}

@property (nonatomic, retain) UITableView *tableView;

@end
