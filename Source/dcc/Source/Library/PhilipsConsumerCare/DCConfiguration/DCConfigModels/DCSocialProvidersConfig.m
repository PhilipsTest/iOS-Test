//
//  DCSocialProvidersConfig.m
//  DigitalCareLibrary
//
//  Created by KRISHNA KUMAR on 21/05/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "DCSocialProvidersConfig.h"

@implementation DCSocialProvidersConfig

-(id)initWithArrayData:(NSArray*)array;{
    self = [self init];
    if (self) {
        _socialServiceProvidersArray=array;
    }
    return self;
}

@end
