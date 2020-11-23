//
//  AppDelegate.h
//  DemoApp
//
//  Created by leslie on 16/06/17.
//  Copyright © 2017 philips. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AppInfraMicroApp;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) AppInfraMicroAppInterface *objAppInfraMicroAppInterface;
+(instancetype)sharedAppDelegate;

@end

