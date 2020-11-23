//
//  AppDelegate.m
//  DemoApp
//
//  Created by Sai Pasumarthy on 19/06/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "AppDelegate.h"
#import "ADBMobile.h"
#import "WXApi.h"
@import PhilipsRegistrationMicroApp;
@import PhilipsRegistration;
@import PhilipsUIKitDLS;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [ADBMobile overrideConfigPath:[[NSBundle bundleForClass:[AppDelegate class]] pathForResource:@"ADBMobileConfig" ofType:@"json"]];
    [WXApi registerApp:@"wxbdf2ab8822f6022f" universalLink:@"https://www.philips.com/udi/universal-links/com.philips.apps.registration.ent"];
    [[UIDThemeManager sharedInstance] setDefaultThemeWithTheme:[UIDTheme new] applyNavigationBarStyling:YES];
    return YES;
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    DIRInfoLog(@"appdelegate openURL*** : %@",url);
    return [DIUser application:app openURL:url options:options];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    NSURL *url = userActivity.webpageURL;
    DIRInfoLog(@"appdelegate useractivity*** : %@",userActivity);
    DIRInfoLog(@"appdelegate useractivity launched URL *** : %@",url);
    return [DIUser application:application openURL:url options:userActivity.userInfo];;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
