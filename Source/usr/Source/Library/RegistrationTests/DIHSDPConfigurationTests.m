//
//  DIHSDPConfigurationTests.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 29/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URSettingsWrapper.h"
#import "DIHSDPConfiguration.h"
#import "Kiwi.h"


SPEC_BEGIN(DIHSDPConfigurationSpec)

describe(@"DIHSDPConfiguration", ^{
   
    context(@"when instantiated", ^{
        
        beforeEach(^{
            URDependencies *dependencies = [[URDependencies alloc] init];
            dependencies.appInfra = [[AIAppInfra alloc] initWithBuilder:nil];
            NSError *error = nil;
            [dependencies.appInfra.appConfig setPropertyForKey:@"HSDPConfiguration.ApplicationName" group:@"UserRegistration"  value:nil error:&error];
            [dependencies.appInfra.appConfig setPropertyForKey:@"HSDPConfiguration.Shared" group:@"UserRegistration"  value:nil error:&error];
            [dependencies.appInfra.appConfig setPropertyForKey:@"HSDPConfiguration.BaseURL" group:@"UserRegistration"  value:nil error:&error];
            [dependencies.appInfra.appConfig setPropertyForKey:@"HSDPConfiguration.Secret" group:@"UserRegistration"  value:nil error:&error];
            [URSettingsWrapper sharedInstance].dependencies = dependencies;
        });
        
        it(@"should be nil if configuration is not available from AppConfig", ^{
            DIHSDPConfiguration *hsdpConfiguration = [[DIHSDPConfiguration alloc] initWithCountryCode:@"US" baseURL:nil];
            [[hsdpConfiguration should] beNil];
        });
        
        it(@"should not be nil if configuration is available from AppConfig", ^{
            URDependencies *dependencies = [[URDependencies alloc] init];
            dependencies.appInfra = [[AIAppInfra alloc] initWithBuilder:nil];
            NSError *error = nil;
            [dependencies.appInfra.appConfig setPropertyForKey:@"HSDPConfiguration.ApplicationName" group:@"UserRegistration"  value:@"uGrow" error:&error];
            [dependencies.appInfra.appConfig setPropertyForKey:@"HSDPConfiguration.Shared" group:@"UserRegistration"  value:@"e95f5e71-c3c0-4b52-8b12-ec297d8ae960" error:&error];
            [dependencies.appInfra.appConfig setPropertyForKey:@"HSDPConfiguration.BaseURL" group:@"UserRegistration"  value:@"https://user-registration-assembly-staging.eu-west.philips-healthsuite.com" error:&error];
            [dependencies.appInfra.appConfig setPropertyForKey:@"HSDPConfiguration.Secret" group:@"UserRegistration"  value:@"e33a4d97-6ada-491f-84e4-a2f7006625e2" error:&error];
            [URSettingsWrapper sharedInstance].dependencies = dependencies;
            
            DIHSDPConfiguration *hsdpConfiguration = [[DIHSDPConfiguration alloc] initWithCountryCode:nil baseURL:nil];
            [[hsdpConfiguration shouldNot] beNil];
            [[hsdpConfiguration.baseURL shouldNot] beNil];
            [[hsdpConfiguration.sharedKey shouldNot] beNil];
            [[hsdpConfiguration.secretKey shouldNot] beNil];
            [[hsdpConfiguration.applicationName shouldNot] beNil];
        });
    });
    
    context(@"method isHSDPConfigurationAvailableForCountry", ^{
        
        it(@"should return true for if all parameters except URL is provided", ^{
            URDependencies *dependencies = [[URDependencies alloc] init];
            dependencies.appInfra = [[AIAppInfra alloc] initWithBuilder:nil];
            NSError *error = nil;
            [dependencies.appInfra.appConfig setPropertyForKey:@"HSDPConfiguration.ApplicationName" group:@"UserRegistration"  value:@"uGrow" error:&error];
            [dependencies.appInfra.appConfig setPropertyForKey:@"HSDPConfiguration.Shared" group:@"UserRegistration"  value:@"e95f5e71-c3c0-4b52-8b12-ec297d8ae960" error:&error];
            [dependencies.appInfra.appConfig setPropertyForKey:@"HSDPConfiguration.Secret" group:@"UserRegistration"  value:@"e33a4d97-6ada-491f-84e4-a2f7006625e2" error:&error];
            [URSettingsWrapper sharedInstance].dependencies = dependencies;
            BOOL isHSDPAvailable = [DIHSDPConfiguration isHSDPConfigurationAvailableForCountry:nil];
            //Kiwi theValue() expression has problem dealing with BOOL and Int. It treats YES and TRUE differently. Same goes for FALSE and NO. Update below line accordingly in case you change the return value of method and this test case starts failing.
            [[theValue(isHSDPAvailable) should] equal:theValue(YES)];
        });
    });
    
});

SPEC_END
