//
//  REDlibExampleViewController.m
//  REDlibExample
//
//  Created by Tom Seago on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "REDlibExampleViewController.h"

#import "REDlib.h"

@implementation REDlibExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Bind parameter names to values on the label
    [@"label center x" bindToProperty:@"center.x" onObject:_textLabel];
    [@"label center y" bindToProperty:@"center.y" onObject:_textLabel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

// This method shows how REDlib can be launched programmatically if so desired.
-(IBAction) launchREDlib:(id)sender
{
    [REDlib showControlWindow];
}

static int count = 1;
-(IBAction) logDebug:(id)sender
{
    RLOG_DEBUG(@"testing", @"This message was logged at the debug level. It is message #%d for this run of the app", count++);
}

-(IBAction) logError:(id)sender;
{
    RLOG_ERR(@"testing", @"OMG AN ERROROZ!. message #%d", count++);
}

@end
