//
//  REDLog.h
//  REDlib
//
//  Created by Tom Seago on 1/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol REDLogSink;

@interface REDLog : NSObject
{
    NSString* _adid;
    NSMutableArray* _registrations;
    
    BOOL _toNSLog;
    NSDateFormatter* _nslogDateFormatter;
}

@property (nonatomic, retain) NSString* adid;

+(REDLog*) sharedInstance;

+(NSString*) macaddress;
+(NSString*) stringFromMD5:(NSString*)src;
+(NSString*) makeADID;
+(NSString*) makeGDID;

+(NSString*) stringForLevel:(int)level;
+(NSString*) stringForLevelFixedWidth:(int)level;


-(void) registerSink:(id<REDLogSink>)sink forEverything:(BOOL)forAll;
-(void) unregisterSink:(id<REDLogSink>)sink;

-(NSArray*) allSinks;

-(void) setLevel:(int)level forSink:(id<REDLogSink>)sink;
-(void) addFacility:(NSString*)facility forSink:(id<REDLogSink>)sink;
-(void) removeFacility:(NSString*)facility forSink:(id<REDLogSink>)sink;

-(void) log:(NSString*)msg level:(int)level facility:(NSString*)facility data:(NSDictionary*)data;

-(void) addNSLog;
-(void) removeNSLog;

-(id<REDLogSink>) addNetworkKey:(NSString*)key;
-(id<REDLogSink>) addNetworkKey:(NSString*)key forURL:(NSString*)url;

@end
