//
//  URSettingsWrapperTests.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 26/07/17.
//  Copyright © 2017 Philips. All rights reserved.
//

@import AppInfra;
#import "URSettingsWrapper.h"
#import "Kiwi.h"


SPEC_BEGIN(URSettingsWrapperSpec)


describe(@"URSettingsWrapper", ^{
    
    context(@"method executeCompletionHandlerWithError:", ^{
        
        it(@"should execute the completion handler with provided error object", ^{
            [[[URSettingsWrapper sharedInstance] should] receive:@selector(setLaunchInput:) withCount:2];
            [[URSettingsWrapper sharedInstance] setCompletionHandler:^(NSError *error) {
                [[error should] beNil];
            }];
            [[URSettingsWrapper sharedInstance] executeCompletionHandlerWithError:nil];
            
            [[URSettingsWrapper sharedInstance] setCompletionHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
            [[URSettingsWrapper sharedInstance] executeCompletionHandlerWithError:[NSError errorWithDomain:@"Dummy Domain" code:1002 userInfo:nil]];
        });
    });
    
    context(@"method setLaunchInput:", ^{
        
        it(@"should execute loadCountrySpecificConfigurationsForCountryCode of registrationFlowConfiguration for setLaunchInput", ^{
            id flowConfigurationMock = [DIRegistrationFlowConfiguration mock];
            [[flowConfigurationMock should] receive:@selector(loadCountrySpecificConfigurationsForCountryCode:serviceURLs:)];
            URLaunchInput *launchInput = [[URLaunchInput alloc] init];
            [launchInput setValue:flowConfigurationMock forKeyPath:@"registrationFlowConfiguration"];
            
            [[URSettingsWrapper sharedInstance] setLaunchInput:launchInput];
        });
    });
    
    context(@"experience", ^{
        
        it(@"should be equal to what has been set by explicitly if its not equal to URReceiveMarketingFlowFromServer", ^{
            URLaunchInput *lauchInput = [[URLaunchInput alloc] init];
            lauchInput.registrationFlowConfiguration.receiveMarketingFlow = URReceiveMarketingFlowSplitSignUp;
            URSettingsWrapper.sharedInstance.launchInput = lauchInput;
            [[theValue([[URSettingsWrapper sharedInstance] experience]) should] equal:theValue(URReceiveMarketingFlowSplitSignUp)];
        });
        
        it(@"should return experience URReceiveMarketingFlowControl if server server returns unexpected value and proposition has set it to URReceiveMarketingFlowFromServer", ^{
            AIAppInfra *appInfra = [[AIAppInfra alloc] initWithBuilder:nil];
            id abTest = [KWMock mockForProtocol:@protocol(AIABTestProtocol)];
            [[abTest should] conformToProtocol:@protocol(AIABTestProtocol)];
            [[abTest should] receive:@selector(getTestValue:defaultContent:updateType:) andReturn:@"AddBenefitsToOptInIn"];
            appInfra.abtest = abTest;
            URDependencies *dependencies = [[URDependencies alloc] init];
            dependencies.appInfra = appInfra;
            [URSettingsWrapper sharedInstance].dependencies = dependencies;
            URLaunchInput *lauchInput = [[URLaunchInput alloc] init];
            lauchInput.registrationFlowConfiguration.receiveMarketingFlow = URReceiveMarketingFlowFromServer;
            URSettingsWrapper.sharedInstance.launchInput = lauchInput;
            [[theValue([[URSettingsWrapper sharedInstance] experience]) should] equal:theValue(URReceiveMarketingFlowControl)];
        });
    });
});


SPEC_END
