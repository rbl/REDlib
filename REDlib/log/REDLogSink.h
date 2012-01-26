//
//  REDLogSink.h
//  REDlib
//
//  Created by Tom Seago on 1/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol REDLogSink <NSObject>

-(void) log:(NSString*)msg level:(int)level facility:(NSString*)facility data:(NSDictionary*)data;

@end
