//
//  ParmyRegistry.h
//  NoNameLib
//
//  Created by Tom Seago on 7/16/11.
//  Copyright 2011 Reality Box Labs LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface REDRegistry : NSObject 
{
	NSMutableDictionary* _paramSets[10];
	NSMutableDictionary* _unsetKeys;
	
	NSMutableDictionary* _bindings;
	
	int _currentSet;
}

+(REDRegistry*) sharedInstance;

@property (nonatomic, assign) int currentSet;

-(double) doubleForKey:(NSString*)key withDefault:(double)def;
-(void) setDouble:(double)val forKey:(NSString*)key;

-(int) intForKey:(NSString*)key withDefault:(int)def;
-(void) setInt:(int)val forKey:(NSString*)key;

-(NSString*) stringForKey:(NSString*)key withDefault:(NSString*)def;
-(void) setString:(NSString*)val forKey:(NSString*)key;

-(void) replaceParamSet:(int)set with:(NSDictionary*)dict;

-(NSArray*) allKeys;
-(id) objectInSet:(int)set forKey:(NSString*)key;

-(id) currentObjectForKey:(NSString*)key;
-(void) setNumber:(NSNumber*)number forKey:(NSString*)key;

-(void) bindName:(NSString*)key onto:(NSString*)pName ofObject:(NSObject*)obj;

@end
