#import "REDLib.h"

void DefineREDParms()
{
	[[NSDictionary dictionaryWithObjectsAndKeys: 

	  [NSNumber numberWithFloat:26], @"stamp scale",
      [NSNumber numberWithFloat:160], @"stamp center x",
	  [NSNumber numberWithFloat:120], @"stamp center y",
	  [NSNumber numberWithFloat:0.2], @"stamp duration",
	  [NSNumber numberWithFloat:0.5], @"stamp delay",
	  [NSNumber numberWithInt:3], @"stamp curve",
      
      [NSNumber numberWithInt:0], @"stb enabled",
      [NSNumber numberWithFloat:1.2], @"stb scale",
      
      [NSNumber numberWithFloat:0.1], @"stb out dur",
	  [NSNumber numberWithInt:2], @"stb out curve",
      
      [NSNumber numberWithFloat:0.1], @"stb in dur",
	  [NSNumber numberWithInt:1], @"stb in curve",

      [NSNumber numberWithFloat:0.5], @"xpa duration",
      [NSNumber numberWithFloat:0.3], @"xpb duration",
	  [NSNumber numberWithFloat:-16], @"xp overshoot",
	  [NSNumber numberWithFloat:-16], @"xpg overshoot",
	  [NSNumber numberWithFloat:320], @"xp start",
	  [NSNumber numberWithFloat:320], @"xpg start",

		nil

	  ] setREDlibSet:0];
}

