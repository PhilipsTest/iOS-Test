//
//  AppDelegate.m
//  RegistrationIOS
//
//  Created by viswaradh on 05/02/14.
//  Copyright (c) 2014 Philips. All rights reserved.
//

#import "AppDelegate.h"
#import "ADBMobile.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ADBMobile overrideConfigPath:[[NSBundle bundleForClass:[AppDelegate class]] pathForResource:@"ADBMobileConfig" ofType:@"json"]];

    return YES;
}

@end