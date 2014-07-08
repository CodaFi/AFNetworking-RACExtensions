//
//  RAFNAppDelegate.m
//  Reactive AFNetworking Example
//
//  Created by Robert Widmann on 3/28/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "RAFNAppDelegate.h"

@implementation RAFNAppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	// Override point for customization after application launch.
	self.window.backgroundColor = [UIColor whiteColor];
	self.viewController = [[RAFNMainViewController alloc] init];
	self.window.rootViewController = self.viewController;
	
	[self.window makeKeyAndVisible];
	return YES;
}

@end