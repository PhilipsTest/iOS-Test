//
//  URJanRainConfigurationTests.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 30/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URJanRainConfiguration.h"
#import "JRCapture.h"
#import "JREngage.h"
#import "JRCaptureConfig.h"
@import AppInfra;
#import "URSettingsWrapper.h"
#import "Kiwi.h"


SPEC_BEGIN(URJanRainConfigurationSpec)

describe(@"URJanRainConfiguration", ^{
    
    beforeAll(^{
        AIAppInfra *appInfra = [[AIAppInfra alloc] initWithBuilder:nil];
        URDependencies *dependencies = [[URDependencies alloc] init];
        dependencies.appInfra = appInfra;
        [URSettingsWrapper sharedInstance].dependencies = dependencies;
    });
    
    afterAll(^{
        [URSettingsWrapper sharedInstance].dependencies = nil;
    });
    
    it(@"should have all the properties when initialised and should not return error for flow download if flow was downloaded successfully", ^{
        NSDictionary *dict = @{@"userreg.hsdp.userserv":            @"https://user-registration-assembly-staging.eu-west.philips-healthsuite.com",
                               @"userreg.janrain.api.v2":              @"https://philips.eval.janraincapture.com",
                               @"userreg.janrain.cdn.v2":              @"https://d1lqe9temigv1p.cloudfront.net",
                               @"userreg.janrain.engage.v2":           @"www.dummy_value.com",
                               @"userreg.landing.emailverif":       @"https://stg.philips.co.in/c-w/verify-account.html",
                               @"userreg.landing.myphilips":        @"https://stg.philips.co.in/myphilips/login.html",
                               @"userreg.landing.resetpass":        @"https://stg.philips.co.in/myphilips/reset-password.html?cl=mob",
                               @"userreg.smssupported":             @"www.dummy_value.com",
                               @"userreg.urx.verificationsmscode":  @"www.dummy_value.com"
                               };
        __unused id jrCapture = [KWMock mockForClass:[JRCapture class]];
        [JRCapture stub:@selector(setRedirectUri:)];
        [JRCapture stub:@selector(setCaptureConfig:) withBlock:^id(NSArray *params) {
            JRCaptureConfig *captureConfig = params.firstObject;
            [[captureConfig.captureTraditionalRegistrationFormName should] equal:@"registrationForm"];
            [[captureConfig.captureFlowName should] equal:@"standard"];
            [[captureConfig.captureSocialRegistrationFormName should] equal:@"socialRegistrationForm"];
            [[captureConfig.forgottenPasswordFormName should] equal:@"forgotPasswordForm"];
            [[captureConfig.editProfileFormName should] equal:@"editform"];
            [[captureConfig.resendEmailVerificationFormName should] equal:@"resendVerificationForm"];
            [[captureConfig.captureSignInFormName should] equal:@"userInformationMobileForm"];
            [[theValue(captureConfig.enableThinRegistration) should] equal:theValue(NO)];
            [[captureConfig.customProviders should] beNil];
            [[theValue(captureConfig.captureTraditionalSignInType) should] equal:theValue(JRTraditionalSignInEmailPassword)];
            [[NSNotificationCenter defaultCenter] postNotificationName:JRFinishedUpdatingEngageConfigurationNotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:JRDownloadFlowResult object:nil];
            return nil;
        }];
        __block NSError *receivedError = [NSError errorWithDomain:@"Dummy-Domain" code:1011 userInfo:nil];
        URJanRainConfiguration *janrainConfiguration = [[URJanRainConfiguration alloc] initWithCountry:@"IN" locale:@"en_IN" serviceURLs:dict flowDownloadCompletion:^(NSError *error) {
            receivedError = error;
        }];
        [[janrainConfiguration shouldNot] beNil];
        [[janrainConfiguration.campaignID shouldNot] beNil];
        [[janrainConfiguration.micrositeID shouldNot] beNil];
        [[janrainConfiguration.resetPasswordURL shouldNot] beNil];
        [[janrainConfiguration.resetPasswordClientId shouldNot] beNil];
        [[janrainConfiguration.urxBaseURL shouldNot] beNil];
        [[expectFutureValue(receivedError) shouldEventuallyBeforeTimingOutAfter(2.0)] beNil];
    });
});

SPEC_END
