//
//  DemoUAppInterface.m
//  DemoUApp
//
//  Created by Sai Pasumarthy on 19/06/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "DemoUAppInterface.h"
#import "TestAppViewController.h"
#import "DemoUAppSettings.h"
#import <UIKit/UIKit.h>

#define URDEMO_RESOURCE_BUNDLE [NSBundle bundleForClass:[TestAppViewController class]]

@implementation DemoUAppInterface

- (instancetype)initWithDependencies:(UAPPDependencies * _Nonnull) dependencies andSettings : (UAPPSettings * _Nullable) settings {
    self = [super init];
    if (self) {
        [DemoUAppSettings sharedInstance].urDemodependencies = (DemoUAppDependencies*)dependencies;
    }
    return self;
}

- (UIViewController * _Nullable)instantiateViewController:(UAPPLaunchInput * _Nonnull) launchInput withErrorHandler:(void (^ _Nullable)(NSError * _Nullable error))completionHandler {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Registration" bundle:URDEMO_RESOURCE_BUNDLE];
    UIViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"TestAppViewController"];
   
    return viewController;
}

@end
