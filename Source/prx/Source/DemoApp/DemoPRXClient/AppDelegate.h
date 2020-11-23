//
//  AppDelegate.h
//  DemoPRXClient
//
//  Created by sameer sulaiman on 10/22/15.
//  Copyright © 2017 Koninklijke Philips N.V.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppInfra.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id<AIAppInfraProtocol>applicationAppInfra;
@property (strong, nonatomic) id <AILoggingProtocol>prxLogging;

@end

