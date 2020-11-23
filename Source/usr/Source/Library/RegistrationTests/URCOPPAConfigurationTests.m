//
//  URCOPPAConfigurationTests.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 26/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URCOPPAConfiguration.h"
#import "Kiwi.h"

SPEC_BEGIN(URCOPPAConfigurationSpec)

describe(@"URCOPPAConfiguration", ^{
    
    __block URCOPPAConfiguration *coppaConfiguration = [[URCOPPAConfiguration alloc] init];
    
    context(@"when instantiated", ^{
        it(@"should not be nil", ^{
            [[coppaConfiguration shouldNot] beNil];
        });
        
        it(@"should have non-nil campaignID", ^{
            [[coppaConfiguration.campaignID shouldNot] beNil];
        });
    });
    
});

SPEC_END
