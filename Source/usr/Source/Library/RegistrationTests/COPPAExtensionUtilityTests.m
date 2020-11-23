//
//  COPPAExtensionUtilityTests.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 26/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "DICoppaExtensionUtility.h"
#import "COPPAExtensionHelper.h"
#import "DIUser.h"
#import "Kiwi.h"


SPEC_BEGIN(DICoppaExtensionUtilitySpec)

describe(@"DICoppaExtensionUtility", ^{
    
    __block DICoppaExtensionUtility *coppaUtility = [[DICoppaExtensionUtility alloc] init];
    
    it(@"should not be nil when instantiated", ^{
        [[coppaUtility shouldNot] beNil];
    });
    
    
    context(@"method getConsentElementWithCampaignID:", ^{
       
        it(@"should return nil if no consent for provided campaignID is found", ^{
            JRConsentsElement *consent = [COPPAExtensionHelper getConsent:nil consentGiven:nil confirmationGiven:nil addDate:NO];
            id diUserClassMock = [KWMock mockForClass:[DIUser class]];
            [[DIUser should] receive:@selector(getInstance) andReturn:diUserClassMock];
            [[diUserClassMock should] receive:@selector(consents) andReturn:@[consent]];
            
            [[[coppaUtility getConsentElementWithCampaignID:@"someDummyConsentId"] should] beNil];
        });
        
        
        it(@"should return consent element for provided campaignID if it exists", ^{
            JRConsentsElement *consent = [COPPAExtensionHelper getConsent:@"someDummyConsentId" consentGiven:@(YES) confirmationGiven:@(YES) addDate:NO];
            id diUserClassMock = [KWMock mockForClass:[DIUser class]];
            [[DIUser should] receive:@selector(getInstance) andReturn:diUserClassMock];
            [[diUserClassMock should] receive:@selector(consents) andReturn:@[consent]];
            
            [[[coppaUtility getConsentElementWithCampaignID:@"someDummyConsentId"] shouldNot] beNil];
        });
    });
    
    
    context(@"method getCoppaStatusForConsent:", ^{
       
        it(@"should return kDICOPPAConsentPending if consent does not exist", ^{
            [[theValue([coppaUtility getCoppaStatusForConsent:nil]) should] equal:theValue(kDICOPPAConsentPending)];
        });
        
        
        it(@"should return kDICOPPAConsentPending if consent has not been displayed to user", ^{
            JRConsentsElement *element = [COPPAExtensionHelper getConsent:@"SomeDummyValue" consentGiven:nil confirmationGiven:nil addDate:NO];
            [[theValue([coppaUtility getCoppaStatusForConsent:element]) should] equal:theValue(kDICOPPAConsentPending)];
        });
        
        
        it(@"should return kDICOPPAConsentGiven if user has accepted first consent", ^{
            JRConsentsElement *element = [COPPAExtensionHelper getConsent:@"SomeDummyValue" consentGiven:@(YES) confirmationGiven:nil addDate:NO];
            [[theValue([coppaUtility getCoppaStatusForConsent:element]) should] equal:theValue(kDICOPPAConsentGiven)];
        });
        
        
        it(@"should return kDICOPPAConfirmationPending if first consent was accetped 24 hrs before and second consent is not displayed yet", ^{
            JRConsentsElement *element = [COPPAExtensionHelper getConsent:@"SomeDummyValue" consentGiven:@(YES) confirmationGiven:nil addDate:YES];
            [[theValue([coppaUtility getCoppaStatusForConsent:element]) should] equal:theValue(kDICOPPAConfirmationPending)];
        });
        
        
        it(@"should return kDICOPPAConsentNotGiven if user has declined first consent", ^{
            JRConsentsElement *element = [COPPAExtensionHelper getConsent:@"SomeDummyValue" consentGiven:@(NO) confirmationGiven:nil addDate:NO];
            [[theValue([coppaUtility getCoppaStatusForConsent:element]) should] equal:theValue(kDICOPPAConsentNotGiven)];
        });
        
        
        it(@"should return kDICOPPAConfirmationGiven is user has accepted second consent", ^{
            JRConsentsElement *element = [COPPAExtensionHelper getConsent:@"SomeDummyValue" consentGiven:@(YES) confirmationGiven:@(YES) addDate:NO];
            [[theValue([coppaUtility getCoppaStatusForConsent:element]) should] equal:theValue(kDICOPPAConfirmationGiven)];
        });
        
        
        it(@"should return kDICOPPAConfirmationNotGiven is user has declined second consent", ^{
            JRConsentsElement *element = [COPPAExtensionHelper getConsent:@"SomeDummyValue" consentGiven:@(YES) confirmationGiven:@(NO) addDate:NO];
            [[theValue([coppaUtility getCoppaStatusForConsent:element]) should] equal:theValue(kDICOPPAConfirmationNotGiven)];
        });
    });
});

SPEC_END
