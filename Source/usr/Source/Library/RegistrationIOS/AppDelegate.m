//
//  AppDelegate.m
//  RegistrationIOS
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "AppDelegate.h"
#import "DIUser.h"
#import "ADBMobile.h"
#import "DILogger.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@import PhilipsUIKitDLS;
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ADBMobile overrideConfigPath:[[NSBundle bundleForClass:[AppDelegate class]] pathForResource:@"ADBMobileConfig" ofType:@"json"]];
    [WXApi registerApp:@"wxbdf2ab8822f6022f" universalLink:@"https://www.philips.com/udi/universal-links/com.philips.apps.registration.ent"];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
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
@end
