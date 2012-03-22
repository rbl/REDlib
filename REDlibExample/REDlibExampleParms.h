//
//  REDlibExampleParms.h
//  REDlib
//
//  Created by Tom Seago on 12/30/11.
//  Copyright 2011 Reality Box Labs LLC. All rights reserved.
//

#import "REDLib.h"

static void DefineREDParms()
{
	[[NSDictionary dictionaryWithObjectsAndKeys: 
      
	  [NSNumber numberWithFloat:10], @"label center x",
      [NSNumber numberWithFloat:200], @"label center y",

	  @"Some sample text", @"label text",
	  
      [NSNumber numberWithInt:3], @"count value",
      
      nil
      
	  ] setREDlibSet:0];
}


