//
//  REDSinglePostSink.m
//  REDlib
//
//  Created by Tom Seago on 1/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "REDSinglePostSink.h"
#import "REDLog.h"

@interface REDSinglePostSink()

+(NSString*) encode:(NSString*)clear;

@end;



@implementation REDSinglePostSink

@synthesize key = _key;
@synthesize baseURL = _baseURL;

-(id) initWithKey:(NSString*)key;
{
    self = [super init];
    if (self) 
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
        _dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        
        _key = key;
        self.baseURL = [NSURL URLWithString:@"http://redlib.realityboxlabs.com/log"];
    }
    
    return self;
}

+(NSString*) encode:(NSString*)clear
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)clear, NULL, (CFStringRef)@";/?:@&=$+{}<>,", kCFStringEncodingUTF8);
}

-(void) log:(NSString*)msg level:(int)level facility:(NSString*)facility data:(NSDictionary*)data
{
    if (!msg) msg = @"";
    
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:_url];
    req.HTTPMethod = @"POST";
    [req addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableString* clear = [NSMutableString stringWithCapacity:msg.length + 100];
    
    [clear appendFormat:@"m=%@", [REDSinglePostSink encode:msg]];
    NSString* str = [_dateFormatter stringFromDate:[NSDate date]];
    [clear appendFormat:@"&t=%@", str];
    [clear appendFormat:@"&l=%@", [REDLog stringForLevel:level]];
    if (facility)
    {
        [clear appendFormat:@"&f=%@", [REDSinglePostSink encode:facility]];
    }
    if (data)
    {
        // TODO: JSON encode the data ...
    }
    [clear appendFormat:@"&did=%@", [REDLog sharedInstance].adid];
    

    req.HTTPBody = [clear dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    //[req addValue:[NSString stringWithFormat:@"%d", req.HTTPBody.length] forHTTPHeaderField:@"Content-Length"];
    
    [NSURLConnection connectionWithRequest:req delegate:self];
    
}

-(void) setKey:(NSString *)key
{
    _key = key;
    _url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", _baseURL, _key]];
}

-(void) setBaseURL:(NSURL *)baseURL
{
    _baseURL = baseURL;
    _url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", _baseURL, _key]];
}

#pragma mark -
#pragma mark NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

@end
