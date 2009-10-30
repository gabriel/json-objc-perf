//
//  JSONPerfTestAppDelegate.m
//  JSONPerfTest
//
//  Created by Gabriel Handford on 10/8/09.
//  Copyright 2009. All rights reserved.
//

#import "JSONPerfTestAppDelegate.h"

#import "JSONTest.h"
#import "YAJLDocument.h"

@implementation JSONPerfTestAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	JSONTest *test = [[JSONTest alloc] init];
	
	NSInteger count = 300;
  
  YAJLDocumentStackCapacity = 20;
  
	[test runWithResourceName:@"twitter_public.json" count:count];		
	[test runWithResourceName:@"lastfm.json" count:count];	
	[test runWithResourceName:@"delicious_popular.json" count:count];	
	[test runWithResourceName:@"yelp.json" count:count];	

}

- (void)dealloc {
	[window release];
	[super dealloc];
}

@end
