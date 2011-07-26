//
//  JSONTest.m
//  JSONPerfTest
//
//  Created by Gabriel Handford on 10/8/09.
//  Copyright 2009. All rights reserved.
//

#import "JSONTest.h"

#import <YAJLiOS/YAJL.h>
#import "SBJson.h"
#import "CJSONDeserializer.h"
#import "JSONKit.h"
#import "NXJsonParser.h"


@implementation JSONTest

- (NSData *)loadDataFromResource:(NSString *)resource {
	NSParameterAssert(resource);
	NSString *resourcePath = [[NSBundle mainBundle] pathForResource:[resource stringByDeletingPathExtension] ofType:[resource pathExtension]];	
	if (!resourcePath) [NSException raise:NSInvalidArgumentException format:@"Resource not found: %@", resource];
	NSError *error = nil;
	NSData *data = [NSData dataWithContentsOfFile:resourcePath options:0 error:&error];
	if (error) [NSException raise:NSInvalidArgumentException format:@"Error loading resource at path (%@): %@", resourcePath, error];
	return data;
}

- (NSString *)loadStringDataFromResource:(NSString *)resource {
	return [[[NSString alloc] initWithData:[self loadDataFromResource:resource] encoding:NSUTF8StringEncoding] autorelease];
}

- (void)SBJSONTest:(NSString *)resourceName count:(NSInteger)count {
  NSString *JSONString = [[self loadStringDataFromResource:resourceName] retain];
	RunWithCount(count, ([NSString stringWithFormat:@"SBJSON-%@", resourceName]), { [JSONString JSONValue]; });
	[JSONString release];  
}

- (void)YAJLTest:(NSString *)resourceName count:(NSInteger)count {
  NSData *JSONData = [[self loadDataFromResource:resourceName] retain];
	RunWithCount(count, ([NSString stringWithFormat:@"YAJL-%@", resourceName]), { [JSONData yajl_JSON]; });
  [JSONData release];  
}

- (void)touchJSONTest:(NSString *)resourceName count:(NSInteger)count {
  NSData *JSONData = [[self loadDataFromResource:resourceName] retain];
  NSError *error = nil;
	RunWithCount(count, ([NSString stringWithFormat:@"TouchJSON-%@", resourceName]), { [[CJSONDeserializer deserializer] deserialize:JSONData error:&error]; });
  NSAssert1(error == nil, @"Errored: %@", error);
  [JSONData release];  
}

- (void)JSONKitTest:(NSString *)resourceName count:(NSInteger)count {
  NSData *JSONData = [[self loadDataFromResource:resourceName] retain];
	RunWithCount(count, ([NSString stringWithFormat:@"JSONKit-%@", resourceName]), { 
    [JSONData objectFromJSONData];
  });
  [JSONData release];
}

- (void)nextiveJsonTest:(NSString *)resourceName count:(NSInteger)count {
  NSData *JSONData = [[self loadDataFromResource:resourceName] retain];
	RunWithCount(count, ([NSString stringWithFormat:@"NextiveJson-%@", resourceName]), { 
    NXJsonParser *parser = [[NXJsonParser alloc] initWithData:JSONData];
    id value = [parser parse:nil ignoreNulls:NO]; value;
    [parser release];
  });
  [JSONData release];
}

- (void)runWithResourceName:(NSString *)resourceName count:(NSInteger)count {
  [self SBJSONTest:resourceName count:count];
  [self YAJLTest:resourceName count:count];
  [self touchJSONTest:resourceName count:count];
  [self JSONKitTest:resourceName count:count];
  [self nextiveJsonTest:resourceName count:count];
}

@end
