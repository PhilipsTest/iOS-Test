//
//  AppDelegate.h
//  DigitalCareLibraryDemo
//
//  Created by KRISHNA KUMAR on 25/05/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+(instancetype)sharedAppDelegate;

@end

