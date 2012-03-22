//
//  REDLog.m
//  REDlib
//
//  Created by Tom Seago on 1/24/12.
//  Copyright 2012 Reality Box Labs LLC. All rights reserved.
//

#import "REDlib.h"

#import "REDLog.h"
#import "REDLogSink.h"

#import "REDSinglePostSink.h"

#import <sys/socket.h> // Per msqr
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <CommonCrypto/CommonDigest.h>

////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark RLog

const int RLEVEL_TRACE     =   0;
const int RLEVEL_DEBUG     =  10;
const int RLEVEL_INFO      =  20;
const int RLEVEL_WARNING   =  30;
const int RLEVEL_WARN      =  30;
const int RLEVEL_ERROR     =  40;
const int RLEVEL_ERR       =  40;
const int RLEVEL_CRITICAL  =  50;
const int RLEVEL_CRIT      =  50;

const int RLEVEL_DEFAULT   =  RLEVEL_INFO;

void RLog(NSString *format, ...)
{
    va_list args;
    va_start(args, format);
    
    RLogv(RLEVEL_DEFAULT, @"general", format, args);
    //NSLogv(format, args);
    
    va_end(args);
}

void RLogLineNo(const char* file, int lineno, int level, NSString* facility, NSString* format, ...)
{
    va_list args;
    va_start(args, format);
    
    RLogLineNov(file, lineno, level, facility, format, args);
    
    va_end(args);
}

void RLogv(int level, NSString* facility, NSString* format, va_list args)
{    
    NSString* msg = [[NSString alloc] initWithFormat:format arguments:args];
    [[REDLog sharedInstance] log:msg level:level facility:facility data:nil];
}

void RLogLineNov(const char* file, int lineno, int level, NSString* facility, NSString* format, va_list args)
{
    char* rpos = strrchr(file, '/');
    if (rpos) file = rpos + 1;
    
    NSMutableString* full = [NSMutableString stringWithFormat:@"%s:%d ", file, lineno];
    NSString* msg = [[NSString alloc] initWithFormat:format arguments:args];
    [full appendString:msg];

    [[REDLog sharedInstance] log:full level:level facility:facility data:nil];
}

void RLogEnable(NSString* sinkName)
{
    if (!sinkName) return;
    
    if ([[sinkName lowercaseString] isEqualToString:@"nslog"]) 
    {
        [[REDLog sharedInstance] addNSLog];
        return;
    }
    
    
}


void RCLog(const char *format, ...)
{
    va_list args;
    va_start(args, format);
    
    RLogv(RLEVEL_DEFAULT, @"general", [NSString stringWithCString:format encoding:NSUTF8StringEncoding], args);
    
    va_end(args);
}

void RCLogLineNo(const char* file, int lineno, int level, const char* facility, const char* format, ...)
{
    va_list args;
    va_start(args, format);
    
    RLogLineNov(file, lineno, level, [NSString stringWithCString:facility encoding:NSUTF8StringEncoding], [NSString stringWithCString:format encoding:NSUTF8StringEncoding], args);
    
    va_end(args);
}


void RCLogv(int level, const char* facility, const char* format, va_list args)
{
    RLogv(level, [NSString stringWithCString:facility encoding:NSUTF8StringEncoding], [NSString stringWithCString:format encoding:NSUTF8StringEncoding], args);
}

void RCLogLineNov(const char* file, int lineno, int level, const char* facility, const char* format, va_list args)
{
    RLogLineNov(file, lineno, level, [NSString stringWithCString:facility encoding:NSUTF8StringEncoding], [NSString stringWithCString:facility encoding:NSUTF8StringEncoding], args);
}

void RCLogEnable(const char* sinkName)
{
    if (!sinkName) return;
    RLogEnable([NSString stringWithCString:sinkName encoding:NSUTF8StringEncoding]);
}

////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark REDLogRegistration

@interface REDLogRegistration : NSObject
{
    int _level;
    NSMutableSet* _facilities;
    
    id<REDLogSink> _sink;
}

@property (nonatomic, assign) int level;
@property (nonatomic, retain) id<REDLogSink> sink;

-(id) initWithSink:(id<REDLogSink>)sink forAll:(BOOL)forAll;

-(void) addFacility:(NSString*)facility;
-(void) removeFacility:(NSString*)facility;

-(void) log:(NSString*)msg level:(int)level facility:(NSString*)facility data:(NSDictionary*)data;

@end


@implementation REDLogRegistration

@synthesize level = _level;
@synthesize sink = _sink;

-(id) initWithSink:(id<REDLogSink>)sink forAll:(BOOL)forAll
{
    self = [super init];
    if (self)
    {
        _sink = sink;
        
        _level = 0;
        _facilities = [NSMutableSet set];

        if (forAll)
        {
            [_facilities addObject:@"__ALL__"];
        }
    }
    return self;
}

-(void) addFacility:(NSString*)facility
{
    [_facilities addObject:facility];
}

-(void) removeFacility:(NSString*)facility
{
    [_facilities removeObject:facility];
}

-(void) log:(NSString*)msg level:(int)level facility:(NSString*)facility data:(NSDictionary*)data
{
    if (level < _level) return;
    
    if (![_facilities containsObject:@"__ALL__"] && ![_facilities containsObject:facility]) return;
    
    // It passes both level and facility, so log it
    [_sink log:msg level:level facility:facility data:data];
}

@end



////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark REDLog



@implementation REDLog

@synthesize adid = _adid;

static REDLog *_sharedREDLog = nil;

+(REDLog *)sharedInstance 
{ 
    @synchronized(self) 
    { 
        if (_sharedREDLog == nil) 
        {
            _sharedREDLog = [[self alloc] init];
        }    
    }
    
    return _sharedREDLog;
}

+(NSString*) stringForLevel:(int)level
{
    if (level >= RLEVEL_CRITICAL)
    {
        return @"critical";
    }
    else if (level >= RLEVEL_ERROR)
    {
        return @"error";
    }
    else if (level >= RLEVEL_WARNING)
    {
        return @"warning";
    }
    else if (level >= RLEVEL_INFO)
    {
        return @"info";
    }
    else if (level >= RLEVEL_DEBUG)
    {
        return @"debug";
    }
    
    return @"trace";
}

+(NSString*) stringForLevelFixedWidth:(int)level
{
    if (level >= RLEVEL_CRITICAL)
    {
        return @"CRITICAL ";
    }
    else if (level >= RLEVEL_ERROR)
    {
        return @"ERROR    ";
    }
    else if (level >= RLEVEL_WARNING)
    {
        return @"WARNING  ";
    }
    else if (level >= RLEVEL_INFO)
    {
        return @"INFO     ";
    }
    else if (level >= RLEVEL_DEBUG)
    {
        return @"DEBUG    ";
    }
    
    return @"TRACE    ";
}

////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Device ID

+(NSString*) macaddress
{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

+(NSString*) stringFromMD5:(NSString*)src
{
    if (!src || !src.length) return nil;
    
    const char *value = src.UTF8String;
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

+(NSString*) makeADID
{
    NSString *macaddress = [REDLog macaddress];
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];  
    NSString *stringToHash = [NSString stringWithFormat:@"%@%@",macaddress,bundleIdentifier];
    NSString *uniqueIdentifier = [REDLog stringFromMD5:stringToHash];
    return uniqueIdentifier;
}

+(NSString*) makeGDID
{
    NSString *macaddress = [REDLog macaddress];
    NSString *uniqueIdentifier = [REDLog stringFromMD5:macaddress];    
    return uniqueIdentifier;
}


//////////// Class Methods


-(id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        _registrations = [NSMutableArray array];
        
        _nslogDateFormatter = [[NSDateFormatter alloc] init];
        _nslogDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS ZZ";
        
        // Generate the application specific device id when started
        self.adid = [REDLog makeADID];
    }
    
    return self;
}


-(REDLogRegistration*) findRegistrationFor:(id<REDLogSink>)sink
{
    for (REDLogRegistration* reg in _registrations)
    {
        if (reg.sink == sink) return reg;
    }
    
    return nil;
}

-(void) registerSink:(id<REDLogSink>)sink forEverything:(BOOL)forAll
{
    REDLogRegistration* reg = [self findRegistrationFor:sink];
    
    if (reg) 
    {
        if (forAll)
        {
            [reg addFacility:@"__ALL__"];
        }
        else
        {
            [reg removeFacility:@"__ALL__"];
        }
    }
    else
    {
        // It is a new registration
        reg = [[REDLogRegistration alloc] initWithSink:sink forAll:forAll];
        [_registrations addObject:reg];
    }
}

-(void) unregisterSink:(id<REDLogSink>)sink
{
    REDLogRegistration* reg = [self findRegistrationFor:sink];
    if (!reg) return;
    
    [_registrations removeObject:reg];
}

-(NSArray*) allSinks
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:_registrations.count];
    
    for (REDLogRegistration* reg in _registrations) 
    {
        [array addObject:reg.sink];
    }
    
    return array;
}


-(void) setLevel:(int)level forSink:(id<REDLogSink>)sink
{
    [[self findRegistrationFor:sink] setLevel:level];    
}

-(void) addFacility:(NSString*)facility forSink:(id<REDLogSink>)sink
{
    [[self findRegistrationFor:sink] addFacility:facility];
}

-(void) removeFacility:(NSString*)facility forSink:(id<REDLogSink>)sink
{
    [[self findRegistrationFor:sink] removeFacility:facility];
}


-(void) addNSLog
{
    _toNSLog = YES;
}

-(void) removeNSLog
{
    _toNSLog = NO;
}


-(id<REDLogSink>) addNetworkKey:(NSString*)key
{
    id<REDLogSink> sink = [[REDSinglePostSink alloc] initWithKey:key];
    [self registerSink:sink forEverything:YES];
    return sink;
}

-(id<REDLogSink>) addNetworkKey:(NSString*)key forURL:(NSString*)url
{
    REDSinglePostSink* sink = [[REDSinglePostSink alloc] initWithKey:key];
    sink.baseURL = [NSURL URLWithString:url];
    
    [self registerSink:sink forEverything:YES];
    return sink;    
}


-(void) log:(NSString*)msg level:(int)level facility:(NSString*)facility data:(NSDictionary*)data
{
    for(REDLogRegistration* reg in _registrations)
    {
        [reg log:msg level:level facility:facility data:data];
    }
    
    if (_toNSLog)
    {
        //NSString* time = [_nslogDateFormatter stringFromDate:[NSDate date]];
        
        //NSMutableString* line = [NSMutableString stringWithFormat:@"%@ ", time];
        NSMutableString* line = [NSMutableString string];
        [line appendString:[REDLog stringForLevel:level]];
        [line appendFormat:@" %@ %@", facility, msg];
        NSLog(@"%@", line);
    }
}

@end
