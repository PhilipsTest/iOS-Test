//
//  DCSocialConfig.m
//  DigitalCare
//
//  Created by KRISHNA KUMAR on 06/04/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "DCSocialConfig.h"
#import "DCConstants.h"

@implementation DCSocialConfig
-(id)initWithDictionary:(NSDictionary*)dict {
    self = [self init];
    if (self){
        _facebookProductPageID=[dict objectForKey:kFACEBOOKPRODUCTPAGEID];
        _twitterPage=[dict objectForKey:kTWITTERPAGE];
        _liveChatRequired=[[dict objectForKey:kLIVECHATREQUIRED] boolValue];
        _liveChatUrl=[dict objectForKey:kLIVECHATURL];
    }
    return self;
}

@end
