//
//  COPPAExtensionTests.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 27/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "DICoppaExtension.h"
#import "DICoppaExtensionUtility.h"
#import "COPPAExtensionHelper.h"
#import "DIUser.h"
#import "Kiwi.h"


SPEC_BEGIN(DICOPPAExtensionSpec)

describe(@"DICOPPAExtension", ^{
    __block DICOPPAExtension *coppaExtension = [[DICOPPAExtension alloc] init];
    
    it(@"should not be nil when instantiated", ^{
        [[coppaExtension shouldNot] beNil];
    });
    
    context(@"method getCoppaEmailConsentStatus", ^{
        
        it(@"should return correct coppa cosent status as returned by DICoppaExtensionUtility", ^{
            id coppaUtility = [DICoppaExtensionUtility mock];
            [coppaExtension setValue:coppaUtility forKeyPath:@"coppaExtensionUtility"];
            JRConsentsElement *consent = [COPPAExtensionHelper getConsent:@"somevalue" consentGiven:@(NO) confirmationGiven:nil addDate:NO];
            [[coppaUtility should] receive:@selector(getConsentElementWithCampaignID:) andReturn:consent];
            [[coppaUtility should] receive:@selector(getCoppaStatusForConsent:) andReturn:theValue(kDICOPPAConsentNotGiven)];
            [[theValue([coppaExtension getCoppaEmailConsentStatus]) should] equal:theValue(kDICOPPAConsentNotGiven)];
        });
    });
    
    context(@"method getCoppaConsentLocale", ^{
        
        it(@"should return correct locale value for fetched consent", ^{
            id coppaUtility = [DICoppaExtensionUtility mock];
            [coppaExtension setValue:coppaUtility forKeyPath:@"coppaExtensionUtility"];
            JRConsentsElement *consent = [COPPAExtensionHelper getConsent:@"somevalue" consentGiven:@(NO) confirmationGiven:nil addDate:NO];
            [[coppaUtility should] receive:@selector(getConsentElementWithCampaignID:) andReturn:consent];
            [[[coppaExtension getCoppaConsentLocale] should] equal:@"en_US"];
        });
    });
    
    
    context(@"method fetchCoppaEmailConsentStatusWithCompletion:", ^{
        
        it(@"should return error if DIUser fails to refetch user profile", ^{
            id diUserMock = [KWMock mockForClass:[DIUser class]];
            [DIUser stub:@selector(getInstance) andReturn:diUserMock];
            [[diUserMock should] receive:@selector(addSessionRefreshListener:)];
            [[diUserMock should] receive:@selector(addUserDetailsListener:)];
            KWCaptureSpy *spy = [diUserMock captureArgument:@selector(addUserDetailsListener:) atIndex:0];
            [[diUserMock should] receive:@selector(removeSessionRefreshListener:)];
            [[diUserMock should] receive:@selector(removeUserDetailsListener:)];
            [diUserMock stub:@selector(refetchUserProfile) withBlock:^id(NSArray *params) {
                id<UserDetailsDelegate> delegate = spy.argument;
                [delegate didUserInfoFetchingFailedWithError:[NSError errorWithDomain:@"Some domain" code:1005 userInfo:nil]];
                return nil;
            }];
            __block NSError *receivedError;
            [coppaExtension fetchCoppaEmailConsentStatusWithCompletion:^(DICOPPASTATUS status, NSError *error) {
                receivedError = error;
            }];
            [[receivedError shouldNotEventuallyBeforeTimingOutAfter(2.0)] beNil];
        });
        
        it(@"should return coppa consent status if DIUser refetch user profile was successful", ^{
            id diUserMock = [KWMock mockForClass:[DIUser class]];
            [DIUser stub:@selector(getInstance) andReturn:diUserMock];
            [[diUserMock should] receive:@selector(addSessionRefreshListener:)];
            [[diUserMock should] receive:@selector(addUserDetailsListener:)];
            KWCaptureSpy *spy = [diUserMock captureArgument:@selector(addUserDetailsListener:) atIndex:0];
            [[diUserMock should] receive:@selector(removeSessionRefreshListener:)];
            [[diUserMock should] receive:@selector(removeUserDetailsListener:)];
            [diUserMock stub:@selector(refetchUserProfile) withBlock:^id(NSArray *params) {
                id<UserDetailsDelegate> delegate = spy.argument;
                [delegate didUserInfoFetchingSuccessWithUser:diUserMock];
                return nil;
            }];
            
            id coppaUtility = [DICoppaExtensionUtility mock];
            [coppaExtension setValue:coppaUtility forKeyPath:@"coppaExtensionUtility"];
            JRConsentsElement *consent = [COPPAExtensionHelper getConsent:@"somevalue" consentGiven:@(NO) confirmationGiven:nil addDate:NO];
            [[coppaUtility should] receive:@selector(getConsentElementWithCampaignID:) andReturn:consent];
            [[coppaUtility should] receive:@selector(getCoppaStatusForConsent:) andReturn:theValue(kDICOPPAConsentNotGiven)];
            __block DICOPPASTATUS consentStatus;
            [coppaExtension fetchCoppaEmailConsentStatusWithCompletion:^(DICOPPASTATUS status, NSError *error) {
                consentStatus = status;
                [[error should] beNil];
            }];
            [[theValue(consentStatus) shouldEventuallyBeforeTimingOutAfter(2.0)] equal:theValue(kDICOPPAConsentNotGiven)];
        });
        
        it(@"should return consent status after session refresh if session is expired", ^{
            id diUserMock = [KWMock mockForClass:[DIUser class]];
            [DIUser stub:@selector(getInstance) andReturn:diUserMock];
            [[diUserMock should] receive:@selector(addSessionRefreshListener:)];
            [[diUserMock should] receive:@selector(addUserDetailsListener:)];
            KWCaptureSpy *userDetailsSpy = [diUserMock captureArgument:@selector(addUserDetailsListener:) atIndex:0];
            KWCaptureSpy *sessionRefreshSpy = [diUserMock captureArgument:@selector(addSessionRefreshListener:) atIndex:0];
            [[diUserMock should] receive:@selector(removeSessionRefreshListener:)];
            [[diUserMock should] receive:@selector(removeUserDetailsListener:)];
            __block BOOL isSessionRefreshed = NO;
            [diUserMock stub:@selector(refetchUserProfile) withBlock:^id(NSArray *params) {
                id<UserDetailsDelegate> delegate = userDetailsSpy.argument;
                if(!isSessionRefreshed) {
                    [delegate didUserInfoFetchingFailedWithError:[NSError errorWithDomain:@"Some domain" code:DISessionExpiredErrorCode
                                                                                 userInfo:nil]];
                }else {
                    [delegate didUserInfoFetchingSuccessWithUser:diUserMock];
                }
                return nil;
            }];
            [diUserMock stub:@selector(refreshLoginSession) withBlock:^id(NSArray *params) {
                id<SessionRefreshDelegate> delegate = sessionRefreshSpy.argument;
                isSessionRefreshed = YES;
                [delegate loginSessionRefreshSucceed];
                return nil;
            }];
            
            id coppaUtility = [DICoppaExtensionUtility mock];
            [coppaExtension setValue:coppaUtility forKeyPath:@"coppaExtensionUtility"];
            JRConsentsElement *consent = [COPPAExtensionHelper getConsent:@"somevalue" consentGiven:@(NO) confirmationGiven:nil addDate:NO];
            [[coppaUtility should] receive:@selector(getConsentElementWithCampaignID:) andReturn:consent];
            [[coppaUtility should] receive:@selector(getCoppaStatusForConsent:) andReturn:theValue(kDICOPPAConsentNotGiven)];
            __block DICOPPASTATUS consentStatus;
            [coppaExtension fetchCoppaEmailConsentStatusWithCompletion:^(DICOPPASTATUS status, NSError *error) {
                consentStatus = status;
                [[error should] beNil];
            }];
            [[theValue(consentStatus) shouldEventuallyBeforeTimingOutAfter(2.0)] equal:theValue(kDICOPPAConsentNotGiven)];
        });
    });
});

SPEC_END
