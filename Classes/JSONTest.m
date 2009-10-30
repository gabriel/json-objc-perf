//
//  JSONTest.m
//  JSONPerfTest
//
//  Created by Gabriel Handford on 10/8/09.
//  Copyright 2009. All rights reserved.
//

#import "JSONTest.h"

#import "NSObject+YAJL.h"
#import "NSString+SBJSON.h"
#import "CJSONDeserializer.h"

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

- (void)runWithResourceName:(NSString *)resourceName count:(NSInteger)count {
		
	NSString *JSONString = [[self loadStringDataFromResource:resourceName] retain];
	RunWithCount(count, ([NSString stringWithFormat:@"SBJSON-%@", resourceName]), { [JSONString JSONValue]; });
	[JSONString release];
	
	NSData *JSONData = [[self loadDataFromResource:resourceName] retain];
	RunWithCount(count, ([NSString stringWithFormat:@"YAJL-%@", resourceName]), { [JSONData yajl_JSON]; });
  [JSONData release];

  // Touch JSON
  NSData *JSONData2 = [[self loadDataFromResource:resourceName] retain];
  NSError *error = nil;
	RunWithCount(count, ([NSString stringWithFormat:@"TouchJSON-%@", resourceName]), { [[CJSONDeserializer deserializer] deserialize:JSONData2 error:&error]; });
  NSAssert1(error == nil, @"Errored: %@", error);
  [JSONData2 release];
}

@end
