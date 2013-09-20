//
//  AppDelegate.m
//  SecureNSCoder
//
//  Created by Tom Daniels on 9/17/13.
//  Copyright (c) 2013 iSEC Partners. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSKeyedArchiver *)coder
{
    // Opt-in to state preservation.
    return TRUE;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSKeyedUnarchiver *)coder
{
    // Opt-in to state restoration.
    return TRUE;
}

@end
