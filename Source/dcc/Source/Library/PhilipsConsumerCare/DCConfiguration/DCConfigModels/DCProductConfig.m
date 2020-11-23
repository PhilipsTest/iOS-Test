//
//  DCProductConfig.m
//  DigitalCare
//
//  Created by KRISHNA KUMAR on 06/04/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "DCProductConfig.h"

@implementation DCProductConfig

-(id)initWithArrayData:(NSArray*)array;
{
    self = [self init];
    if (self) {
        _productConfigArray=array;
    }
    return self;
}

@end
