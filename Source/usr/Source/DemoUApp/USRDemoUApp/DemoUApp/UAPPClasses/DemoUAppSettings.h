//
//  DemoUAppSettings.h
//  DemoUApp
//
//  Created by Sai Pasumarthy on 19/06/17.
//  Copyright © 2017 Philips. All rights reserved.
//


#import <UAPPFramework/UAPPFramework.h>
#import "DemoUAppDependencies.h"

@interface DemoUAppSettings : UAPPSettings
+ (instancetype) sharedInstance;
@property (nonatomic, strong) DemoUAppDependencies *urDemodependencies;
@end
