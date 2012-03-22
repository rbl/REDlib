//
//  REDSinglePostSink.h
//  REDlib
//
//  Created by Tom Seago on 1/24/12.
//  Copyright 2012 Reality Box Labs LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "REDLogSink.h"

@interface REDSinglePostSink : NSObject <REDLogSink, NSURLConnectionDataDelegate>
{
    NSString* _key;
    NSURL* _url;
    NSURL* _baseURL;
    
    NSDateFormatter* _dateFormatter;
}

@property (nonatomic, retain) NSString* key;
@property (nonatomic, retain) NSURL* baseURL;

-(id) initWithKey:(NSString*)key;

@end
