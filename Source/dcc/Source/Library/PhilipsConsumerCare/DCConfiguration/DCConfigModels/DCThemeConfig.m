//
//  DCThemeConfig.m
//  DigitalCare
//
//  Created by KRISHNA KUMAR on 06/04/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "DCThemeConfig.h"
#import "DCConstants.h"

@implementation DCThemeConfig

-(id)initWithDictionary:(NSDictionary*)dict {
    self = [self init];
    if (self){
        _screenBackgroundColor=[dict objectForKey:kSCREENBACKGROUNDCOLOR];
        _navigationBarTitleRequired=[[dict objectForKey:KNAVIGATIONBARTITLEREQUIRED] boolValue];
        _backGroundImage=[dict objectForKey:kBACKGROUNDIMAGE];
        _iPadLandscapePadding = [[dict objectForKey:kIpadLandscapePadding] floatValue];
    }
    return self;
}

@end
