//
//  AppDelegate.h
//  ProductSelection
//
//  Created by KRISHNA KUMAR on 13/01/16.
//  Copyright © 2016 KRISHNA KUMAR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AppInfra/AppInfra.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) id<AIAppTaggingProtocol> objAppTaggingForDemo;
@property (nonatomic, strong) id<AIAppInfraProtocol> appInfra;

+(instancetype)sharedAppDelegate;
@end

