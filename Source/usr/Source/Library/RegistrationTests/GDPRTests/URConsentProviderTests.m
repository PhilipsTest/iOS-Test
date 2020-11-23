//
//  URConsentProviderTests.m
//  RegistrationTests
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "URConsentProvider.h"
#import "DIConstants.h"
#import "Kiwi.h"

SPEC_BEGIN(URConsentProviderSpec)

describe(@"URConsentProvider", ^{
    
    context(@"while fetching marketing consent definition", ^{
        
        it(@"should return nil if we pass empty locale", ^{
            ConsentDefinition *consentDefinition = [URConsentProvider fetchMarketingConsentDefinition:@""];
            [[consentDefinition  shouldNot] beNil];
        });
        
        it(@"should return consent definition object if we pass valid locale", ^{
            ConsentDefinition *consentDefinition = [URConsentProvider fetchMarketingConsentDefinition:@"en_US"];
            [[consentDefinition  shouldNot] beNil];
        });
        
    });
         
     context(@"while fetching personal consent definition", ^{
         
         it(@"should return error message string", ^{
             NSString *errorMessage = [URConsentProvider personalConsentErrorMessage];
             [[errorMessage  shouldNot] beNil];
         });
         
         it(@"should return consent definition object of personal consent", ^{
             ConsentDefinition *consentDefinition = [URConsentProvider fetchPersonalConsentDefinition];
             [[consentDefinition  shouldNot] beNil];
         });
         
     });

});

SPEC_END
