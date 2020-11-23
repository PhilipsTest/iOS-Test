//
//  DCPluginManager.m
//  DigitalCare
//
//  Created by sameer sulaiman on 29/03/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
#import "DCPluginManager.h"
#import "DCConfigurationContainer.h"

@implementation DCPluginManager

+ (DCPluginManager*)sharedInstance{
    static DCPluginManager * pluginManagerSharedInstance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        pluginManagerSharedInstance = [[DCPluginManager alloc] init];
    });
    return pluginManagerSharedInstance;
}

-(DCConfigurationContainer *)configData{
    if(_configData == nil)
        _configData = [[DCConfigurationContainer alloc] init];
    return _configData;
}

@end
