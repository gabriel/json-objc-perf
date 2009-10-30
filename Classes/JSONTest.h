//
//  JSONTest.h
//  JSONPerfTest
//
//  Created by Gabriel Handford on 10/8/09.
//  Copyright 2009. All rights reserved.
//

// To use microseconds timer with Carbon framework
/*!
#import <Carbon/Carbon.h>
 UInt64 M0, M1; 
 Microseconds((UnsignedWide *)&M0);
 ...
 Microseconds((UnsignedWide *)&M1);
 NSLog(@"Microseconds: %g\n", ((double)(M1 - M0) / (double)theCount) / 1000000.0); \
*/
  

#define RunWithCount(count, description, expr) \
do { \
CFAbsoluteTime start = CFAbsoluteTimeGetCurrent(); \
for(NSInteger i = 0; i < count; i++) { \
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; \
	id value = (expr); value; \
	[pool release]; \
} \
\
CFTimeInterval took = CFAbsoluteTimeGetCurrent() - start; \
NSLog(@"%@ %0.3f", description, took); \
\
} while (0)


@interface JSONTest : NSObject

- (NSData *)loadDataFromResource:(NSString *)resource;

- (NSString *)loadStringDataFromResource:(NSString *)resource;

- (void)runWithResourceName:(NSString *)resourceName count:(NSInteger)count;

@end
