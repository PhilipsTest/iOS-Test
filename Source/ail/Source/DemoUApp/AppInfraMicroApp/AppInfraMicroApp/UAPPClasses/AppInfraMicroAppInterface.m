//
//  AppInfraMicroAppInterface.m
//  AppInfraMicroApp
//
//  Created by Ravi Kiran HR on 15/03/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "AppInfraMicroAppInterface.h"
#import <UIKit/UIKit.h>
#import "AilShareduAppDependency.h"

@implementation AppInfraMicroAppInterface

- (instancetype)initWithDependencies:(UAPPDependencies * _Nonnull) dependencies andSettings : (UAPPSettings * _Nullable) settings {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [AilShareduAppDependency sharedDependency].uAppDependency = dependencies;
    [[AilShareduAppDependency sharedDependency] initialize];
    
    return self;
}

- (UIViewController * _Nullable)instantiateViewController:(UAPPLaunchInput * _Nonnull) launchInput withErrorHandler:(void (^ _Nullable)(NSError * _Nullable error))completionHandler {
   
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:self.class]];
    UIViewController *rootViewController = [storyboard instantiateInitialViewController];
    return rootViewController;
}

@end
