//
//  ConsumerCareMicroAppInterface.m
//  ConsumerCareMicroApp
//
//  Created by Niharika Bundela on 3/22/17.
//  Copyright © 2017 Niharika Bundela. All rights reserved.
//

#import "ConsumerCareMicroAppInterface.h"
#import <UIKit/UIKit.h>
//@import ConsumerCareMicroApp;
#import "DCDemoViewController.h"

#import "ConsumerCareMicroAppSettings.h"

@implementation ConsumerCareMicroAppInterface

- (instancetype)initWithDependencies:(UAPPDependencies *) dependencies andSettings : (UAPPSettings *) settings {
    self = [super init];
    if (self)
    {
        [ConsumerCareMicroAppSettings sharedInstance].ccAppDependencies = (ConsumerCareMicroAppDependencies *)dependencies;
    }
    return self;
}

- (UIViewController * _Nullable)instantiateViewController:(UAPPLaunchInput * _Nonnull) launchInput withErrorHandler:(void (^ _Nullable)(NSError * _Nullable error))completionHandler {
    UIStoryboard *dcStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:[self class]]];
    DCDemoViewController *dcRootViewController = [dcStoryboard instantiateViewControllerWithIdentifier:@"RootView"];
    dcRootViewController.appInfra = self.appInfra;
   return dcRootViewController;
}

@end
