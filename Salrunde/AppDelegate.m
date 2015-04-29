//
//  AppDelegate.m
//  Salrunde
//
//  Created by Jan Matias Ørstavik on 19/01/15.
//  Copyright (c) 2015 Jan Matias Ørstavik. All rights reserved.
//

#import "AppDelegate.h"

#import "NetworkHandler.h"
#import "MyNavController.h"
#import "PrinterViewController.h"
#import "Constants.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if (![defaults floatForKey:kVersionKey] || [defaults floatForKey:kVersionKey] < VERSION){
		BOOL colors = [[defaults objectForKey:kColorsKey] boolValue];
		NSString *defRec = ((NSString *)[defaults objectForKey:kDefaultRecipientKey]);
		
		[defaults removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
		[defaults synchronize];
		
		[defaults setFloat:VERSION forKey:kVersionKey];
		[defaults setObject:@0 forKey: kDebugKey];
		[defaults setObject:[NSNumber numberWithBool:colors] forKey:kColorsKey];
		[defaults setObject:defRec forKey:kDefaultRecipientKey];
		[defaults synchronize];
	}
	
	((MyNavController *)self.window.rootViewController).nh = [[NetworkHandler alloc] init];

	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	if ( [((UINavigationController*)self.window.rootViewController).visibleViewController isKindOfClass:[PrinterViewController class]]){
		[((PrinterViewController *)((UINavigationController*)self.window.rootViewController).visibleViewController) save];
	}
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	if ( [((UINavigationController*)self.window.rootViewController).visibleViewController isKindOfClass:[PrinterViewController class]]){
		[((PrinterViewController *)((UINavigationController*)self.window.rootViewController).visibleViewController) save];
	}
	
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	if ( [((UINavigationController*)self.window.rootViewController).visibleViewController isKindOfClass:[PrinterViewController class]]){
		[((PrinterViewController *)((UINavigationController*)self.window.rootViewController).visibleViewController) save];
	}
}

@end
