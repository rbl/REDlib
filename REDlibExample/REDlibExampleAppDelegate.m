//
//  REDlibExampleAppDelegate.m
//  REDlibExample
//
//  Created by Tom Seago on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "REDlibExampleAppDelegate.h"

#import "REDlibExampleParms.h"

#import "REDLog.h"

@implementation REDlibExampleAppDelegate

@synthesize window = _window;

-(void) applicationDidFinishLaunching:(UIApplication *)application
{
    // Recommended to setup the parameters before any other part of the app loads
    DefineREDParms();
    RLogEnable(@"nslog");
    

    [[REDLog sharedInstance] addNetworkKey:@"m6VjjaJW0xB32RMfKKCGzb7PXxwZeBns"];
    [[REDLog sharedInstance] addNetworkKey:@"rpPdKOJpTBU5kBzLZZauruR2dJJJicCO" forURL:@"http://localhost:3000/log"];
    
    RLog(@"App start %d", 1234);
    
    RLOG_WARN(@"simple things", @"Something just for testing", @"foo");
    
    // Attach the REDlib gesture recognizer directly to the window
    [REDlib attachGestureRecognizerToWindow:_window];
}

@end
