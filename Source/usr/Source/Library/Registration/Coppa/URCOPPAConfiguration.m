//
//  URCOPPAConfiguration.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 22/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URCOPPAConfiguration.h"
#import "RegistrationUtility.h"
#import "DIRegistrationConstants.h"

@interface URCOPPAConfiguration()

@property (nonatomic, strong, readwrite) NSString *campaignID;

@end

@implementation URCOPPAConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _campaignID = [RegistrationUtility configValueForKey:PILConfig_CampaignID countryCode:nil error:nil];
    }
    return self;
}

@end
