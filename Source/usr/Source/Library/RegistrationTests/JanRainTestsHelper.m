//
//  JanRainTestsHelper.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 30/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "JanRainTestsHelper.h"

@implementation JanRainTestsHelper

+ (NSDictionary *)dummyServiceURLs {
    return @{@"userreg.hsdp.userserv":            @"https://user-registration-assembly-staging.eu-west.philips-healthsuite.com",
             @"userreg.janrain.api.v2":              @"https://philips.eval.janraincapture.com",
             @"userreg.janrain.cdn.v2":              @"https://d1lqe9temigv1p.cloudfront.net",
             @"userreg.janrain.engage.v2":           @"www.dummy_value.com",
             @"userreg.landing.emailverif":       @"https://stg.philips.co.in/c-w/verify-account.html",
             @"userreg.landing.myphilips":        @"https://stg.philips.co.in/myphilips/login.html",
             @"userreg.landing.resetpass":        @"https://stg.philips.co.in/myphilips/reset-password.html?cl=mob",
             @"userreg.smssupported":             @"www.dummy_value.com",
             @"userreg.urx.verificationsmscode":  @"www.dummy_value.com"
             };
}

+ (DIConsumerInterest *)dummyConsumerInterest {
    DIConsumerInterest *interest = [[DIConsumerInterest alloc] init];
    interest.campaignName = @"dummyCampaignName";
    interest.subjectArea = @"dummySubjectArea";
    interest.topicCommunicationKey = @"dummyTopicCommunicationKey";
    interest.topicValue = @"dummyTopicValue";
    return interest;
}

@end
