//
//  ParmyTabParams.h
//  Bumpy
//
//  Created by Tom Seago on 12/30/11.
//  Copyright 2011 Reality Box Labs LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface REDTabParamsRoot : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView* _tableView;
    
    NSArray* _sections;
}
@end
