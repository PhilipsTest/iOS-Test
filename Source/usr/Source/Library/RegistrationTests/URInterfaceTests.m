//
//  URInterfaceTests.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 26/07/17.
//  Copyright © 2017 Philips. All rights reserved.
//

@import AppInfra;
#import "URSettingsWrapper.h"
#import "URInterface.h"
#import "URStartViewController.h"
#import "UROptInViewController.h"
#import "URMarketingConsentHandler.h"
#import "MyDetailsViewController.h"
#import "Kiwi.h"


SPEC_BEGIN(URInterfaceSpec)

describe(@"URInterface", ^{
    
    context(@"when initialized", ^{
        
        it(@"should correctly set dependencies to URSettingsWrapper when provided", ^{
            AIAppInfra *appInfra = [[AIAppInfra alloc] initWithBuilder:nil];
            URDependencies *dependencies = [[URDependencies alloc] init];
            dependencies.appInfra = appInfra;
            __unused URInterface *interface = [[URInterface alloc] initWithDependencies:dependencies andSettings:nil];
            URSettingsWrapper *settingsWrapper = [URSettingsWrapper sharedInstance];
            [[settingsWrapper.dependencies shouldNot] beNil];
            [[settingsWrapper.dependencies.appInfra shouldNot] beNil];
        });
        
        it(@"should register marketing handler with Consent Manager", ^{
            AIAppInfra *appInfra = [[AIAppInfra alloc] initWithBuilder:nil];
            id consentManager = [KWMock mockForProtocol:@protocol(AIConsentManagerProtocol)];
            [[consentManager should] receive:@selector(registerHandlerWithHandler:forConsentTypes:error:) withCount:2];
            [consentManager stub:@selector(registerHandlerWithHandler:forConsentTypes:error:) withBlock:^id(NSArray *params) {
                id handler = params[0];
                NSArray *consentTypes = params[1];
                NSError *error = params[2];
                [[handler shouldNot] beNil];
                [[theValue([handler isKindOfClass:[URMarketingConsentHandler class]]) should] beTrue];
                [[consentTypes shouldNot] beEmpty];
                [[consentTypes.firstObject should] equal:kUSRMarketingConsentKey];
                [[error should] equal:thePointerValue(nil)];
                return nil;
            }];
            appInfra.consentManager = consentManager;
            URDependencies *dependencies = [[URDependencies alloc] init];
            dependencies.appInfra = appInfra;
            __unused URInterface *interface = [[URInterface alloc] initWithDependencies:dependencies andSettings:nil];
            // Creating a URInterface again just to make sure no problems are encountered when URInterface is initialised twice
            __unused URInterface *interfaceAgain = [[URInterface alloc] initWithDependencies:dependencies andSettings:nil];
        });
    });
    
    context(@"method instantiateViewController:withErrorHandler:", ^{
        __block DIUser *diUserMocked;
        __block URInterface *interface;
        beforeAll(^{
            diUserMocked = [KWMock mockForClass:[DIUser class]];
            AIAppInfra *appInfra = [[AIAppInfra alloc] initWithBuilder:nil];
            URDependencies *dependencies = [[URDependencies alloc] init];
            dependencies.appInfra = appInfra;
            interface = [[URInterface alloc] initWithDependencies:dependencies andSettings:nil];
        });
       
        it(@"should return StartViewController when user is not logged in", ^{
            [diUserMocked stub:@selector(userLoggedInState) andReturn:theValue(UserLoggedInStateUserNotLoggedIn)];
            URLaunchInput *launchInput = [[URLaunchInput alloc] init];
            UIViewController *registrationController = [interface instantiateViewController:launchInput withErrorHandler:nil];
            [[registrationController should] beKindOfClass:[URStartViewController class]];
        });
        
        it(@"should return OptInViewController if user is logged in", ^{
            [[DIUser should] receive:@selector(getInstance) andReturn:diUserMocked];
            [diUserMocked stub:@selector(userLoggedInState) andReturn:theValue(UserLoggedInStateUserLoggedIn)];
            URLaunchInput *launchInput = [[URLaunchInput alloc] init];
            UIViewController *registrationController = [interface instantiateViewController:launchInput withErrorHandler:nil];
            [[registrationController should] beKindOfClass:[UROptInViewController class]];
        });
        
        it(@"should return MyDetailsViewController if user is logged in and end point is my details", ^{
            [[DIUser should] receive:@selector(getInstance) andReturn:diUserMocked];
            [diUserMocked stub:@selector(userLoggedInState) andReturn:theValue(UserLoggedInStateUserLoggedIn)];
            URLaunchInput *launchInput = [[URLaunchInput alloc] init];
            launchInput.registrationFlowConfiguration.loggedInScreen = URLoggedInScreenMyDetails;
            UIViewController *registrationController = [interface instantiateViewController:launchInput withErrorHandler:nil];
            [[registrationController should] beKindOfClass:[MyDetailsViewController class]];
        });
    });
});

SPEC_END
