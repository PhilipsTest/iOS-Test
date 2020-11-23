//
//  ConsumerCareMicroAppSettings.h
//  ConsumerCareMicroApp
//
//  Created by Niharika Bundela on 3/22/17.
//  Copyright © 2017 Niharika Bundela. All rights reserved.
//


#import <UAPPFramework/UAPPFramework.h>
#import "ConsumerCareMicroAppDependencies.h"
@interface ConsumerCareMicroAppSettings : UAPPSettings
+ (instancetype) sharedInstance;
@property (nonatomic , strong) ConsumerCareMicroAppDependencies *ccAppDependencies;
@end
