//
//  URLaunchInput.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 11/08/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "URLaunchInput.h"

@implementation URLaunchInput

- (instancetype) init {
    self = [super init];
    if (self) {
        _registrationFlowConfiguration = [[DIRegistrationFlowConfiguration alloc] init];
        _registrationContentConfiguration = [[DIRegistrationContentConfiguration alloc] init];
    }
    return self;
}


-(BOOL)isPersonalConsentToBeShown {
    BOOL usrConsentStatus = self.registrationFlowConfiguration.userPersonalConsentStatus;
    BOOL isConsentConfigurationPresent = self.registrationFlowConfiguration.isPersonalConsentToBeShown;
    
    BOOL isConsentToBeShown = true;
    // Configuration has to be true and user consent state has to be inactive.
    if ((isConsentConfigurationPresent == false) &&
        (usrConsentStatus == ConsentStatesInactive)) {
        isConsentToBeShown = false;
    }
    return isConsentToBeShown;
}


@end
