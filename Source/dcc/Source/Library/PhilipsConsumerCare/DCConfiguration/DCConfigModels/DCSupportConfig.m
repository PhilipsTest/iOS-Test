//
//  DCSupportConfig.m
//  DigitalCare
//
//  Created by KRISHNA KUMAR on 06/04/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "DCSupportConfig.h"

@implementation DCSupportConfig

-(id)initWithArrayData:(NSArray*)array{
    self = [self init];
    if (self){
        _supportConfigArray=array;
    }
    return self;
}

@end
