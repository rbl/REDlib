//
//  REDlibExampleViewController.h
//  REDlibExample
//
//  Created by Tom Seago on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface REDlibExampleViewController : UIViewController
{
    IBOutlet UILabel* _textLabel;
}

-(IBAction) launchREDlib:(id)sender;

-(IBAction) logDebug:(id)sender;
-(IBAction) logError:(id)sender;

@end
