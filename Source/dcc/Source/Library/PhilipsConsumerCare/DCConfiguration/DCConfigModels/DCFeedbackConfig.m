//
//  DCFeedbackConfig.m
//  DigitalCareLibrary
//
//  Created by KRISHNA KUMAR on 21/05/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "DCFeedbackConfig.h"
#import "DCConstants.h"

@implementation DCFeedbackConfig
-(id)initWithDictionary:(NSDictionary*)dict {
    self = [self init];
    if (self)
    {
        _appStoreId=[dict objectForKey:kAPPSTOREID];
    }
    return self;
}

@end
