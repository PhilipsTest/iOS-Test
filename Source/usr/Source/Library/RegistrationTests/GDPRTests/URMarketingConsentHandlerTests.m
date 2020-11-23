//
//  URMarketingConsentHandlerTests.m
//  RegistrationTests
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "URMarketingConsentHandler.h"
#import "Kiwi.h"
#import "DIUser.h"
#import "DIConstants.h"
#import "DIRegistrationConstants.h"

SPEC_BEGIN(URMarketingConsentHandlerSpec)

describe(@"URMarketingConsentHandler", ^{
    
    __block URMarketingConsentHandler *consentHandler;
    
    beforeEach(^{
        consentHandler = [[URMarketingConsentHandler alloc] init];
    });
    
    it(@"should not be nil when URMarketingConsentHandler object is created", ^{
        [[consentHandler shouldNot] beNil];
    });
    
    context(@"method: fetchConsentTypeState", ^{
        it(@"should return consent status active with valid timestamp  for valid UR consent definition", ^{
            id userHandler = [KWMock mockForClass:[DIUser class]];
            [DIUser stub:@selector(getInstance) andReturn:userHandler];
            [[userHandler should] receive:@selector(addUserDetailsListener:)];
            KWCaptureSpy *spy = [userHandler captureArgument:@selector(addUserDetailsListener:) atIndex:0];
            [[userHandler should] receive:@selector(removeUserDetailsListener:)];
            [[userHandler should] receive:@selector(receiveMarketingEmails) andReturn:theValue(YES)];
            [[userHandler should] receive:@selector(marketingConsentTimestamp) andReturn:theValue([NSDate dateWithTimeIntervalSince1970:100]) withCount:2];
            [userHandler stub:@selector(refetchUserProfile) withBlock:^id(NSArray *params) {
                id<UserDetailsDelegate> delegate = spy.argument;
                [delegate didUserInfoFetchingSuccessWithUser:userHandler];
                return nil;
            }];
            __block ConsentStatus *consentDefStatus;
            [consentHandler fetchConsentTypeStateFor:kUSRMarketingConsentKey completion:^(ConsentStatus *consentStatus, NSError *error) {
                consentDefStatus = consentStatus;
                [[error should] beNil];
            }];
            [[theValue(consentDefStatus.status) shouldEventuallyBeforeTimingOutAfter(2.0)] equal:theValue(ConsentStatesActive)];
            [[theValue(consentDefStatus.version) shouldEventuallyBeforeTimingOutAfter(2.0)] equal:theValue(0)];
            [[theValue(consentDefStatus.timestamp) shouldEventuallyBeforeTimingOutAfter(2.0)] equal:theValue([NSDate dateWithTimeIntervalSince1970:100])];
        });
        
        it(@"should return consent status rejected with valid timestamp for valid UR consent definition", ^{
            id userHandler = [KWMock mockForClass:[DIUser class]];
            [DIUser stub:@selector(getInstance) andReturn:userHandler];
            [[userHandler should] receive:@selector(addUserDetailsListener:)];
            [[userHandler should] receive:@selector(marketingConsentTimestamp) andReturn:theValue([NSDate dateWithTimeIntervalSince1970:100]) withCount:2];
            KWCaptureSpy *spy = [userHandler captureArgument:@selector(addUserDetailsListener:) atIndex:0];
            [[userHandler should] receive:@selector(removeUserDetailsListener:)];
            [[userHandler should] receive:@selector(receiveMarketingEmails) andReturn:theValue(NO)];
            [userHandler stub:@selector(refetchUserProfile) withBlock:^id(NSArray *params) {
                id<UserDetailsDelegate> delegate = spy.argument;
                [delegate didUserInfoFetchingSuccessWithUser:userHandler];
                return nil;
            }];
            __block ConsentStatus *consentDefStatus;
            [consentHandler fetchConsentTypeStateFor:kUSRMarketingConsentKey completion:^(ConsentStatus *consentStatus, NSError *error) {
                consentDefStatus = consentStatus;
                [[error should] beNil];
            }];
            [[theValue(consentDefStatus.status) shouldEventuallyBeforeTimingOutAfter(2.0)] equal:theValue(ConsentStatesRejected)];
            [[theValue(consentDefStatus.timestamp) shouldEventuallyBeforeTimingOutAfter(2.0)] equal:theValue([NSDate dateWithTimeIntervalSince1970:100])];
        });
        
        it(@"should return consent status when there is network failure", ^{
            id userHandler = [KWMock mockForClass:[DIUser class]];
            [DIUser stub:@selector(getInstance) andReturn:userHandler];
            [[userHandler should] receive:@selector(addUserDetailsListener:)];
            KWCaptureSpy *spy = [userHandler captureArgument:@selector(addUserDetailsListener:) atIndex:0];
            [[userHandler should] receive:@selector(marketingConsentTimestamp) andReturn:theValue([NSDate dateWithTimeIntervalSince1970:100]) withCount:2];
            [[userHandler should] receive:@selector(removeUserDetailsListener:)];
            [[userHandler should] receive:@selector(receiveMarketingEmails)];
            [userHandler stub:@selector(refetchUserProfile) withBlock:^id(NSArray *params) {
                id<UserDetailsDelegate> delegate = spy.argument;
                [delegate didUserInfoFetchingFailedWithError:userHandler];
                return nil;
            }];
            __block ConsentStatus *consentDefStatus;
            [consentHandler fetchConsentTypeStateFor:kUSRMarketingConsentKey completion:^(ConsentStatus *consentStatus, NSError *error) {
                [[error should] beNil];
                consentDefStatus = consentStatus;
            }];
            [[theValue(consentDefStatus.status) shouldNotEventuallyBeforeTimingOutAfter(2.0)] beNil];
        });
        
        it(@"should return error status for invalid UR consent type", ^{
            __block NSError *receivedError;
            [consentHandler fetchConsentTypeStateFor:@"invalidConsentType" completion:^(ConsentStatus *consentStatus, NSError *error) {
                receivedError = error;
                [[consentStatus should] beNil];
            }];
            [[receivedError shouldNotEventuallyBeforeTimingOutAfter(2.0)] beNil];
            [[theValue(receivedError.code) should] equal:theValue(DIGDPRRegConsentError)];
        });
        
    });
    
    context(@"method: storeConsentState", ^{
        it(@"should successfully store consent for valid UR consent definitions", ^{
            id userHandler = [KWMock mockForClass:[DIUser class]];
            [DIUser stub:@selector(getInstance) andReturn:userHandler];
            [[userHandler should] receive:@selector(addUserDetailsListener:)];
            KWCaptureSpy *spy = [userHandler captureArgument:@selector(addUserDetailsListener:) atIndex:0];
            [[userHandler should] receive:@selector(removeUserDetailsListener:)];
            [[userHandler should] receive:@selector(updateReciveMarketingEmail:) andReturn:theValue(YES)];
            [userHandler stub:@selector(updateReciveMarketingEmail:) withBlock:^id(NSArray *params) {
                id<UserDetailsDelegate> delegate = spy.argument;
                [delegate didUpdateSuccess];
                return nil;
            }];
            __block BOOL receivedFlag = false;
            [consentHandler storeConsentStateFor:kUSRMarketingConsentKey withStatus:true withVersion:1 completion:^(BOOL storeFlag, NSError *error) {
                [[error should] beNil];
                receivedFlag = storeFlag;
            }];
            [[theValue(receivedFlag) should] equal:theValue(YES)];
        });
        
        it(@"should return error for storing consent definitions failed", ^{
            id userHandler = [KWMock mockForClass:[DIUser class]];
            [DIUser stub:@selector(getInstance) andReturn:userHandler];
            [[userHandler should] receive:@selector(addUserDetailsListener:)];
            KWCaptureSpy *spy = [userHandler captureArgument:@selector(addUserDetailsListener:) atIndex:0];
            [[userHandler should] receive:@selector(removeUserDetailsListener:)];
            [userHandler stub:@selector(updateReciveMarketingEmail:) withBlock:^id(NSArray *params) {
                id<UserDetailsDelegate> delegate = spy.argument;
                [delegate didUpdateFailedWithError:[NSError errorWithDomain:@"Some domain" code:DIGDPRRegConsentError userInfo:@{NSLocalizedDescriptionKey: @"Bad request: unknown error type"}]];
                return nil;
            }];
            __block NSError *receivedError;
            [consentHandler storeConsentStateFor:kUSRMarketingConsentKey withStatus:true withVersion:1 completion:^(BOOL storeFlag, NSError *error) {
                receivedError = error;
            }];
            [[receivedError shouldNotEventuallyBeforeTimingOutAfter(2.0)] beNil];
        });
        
        it(@"should return error status for invalid UR consent type", ^{
            __block NSError *receivedError;
            [consentHandler storeConsentStateFor:@"invalidConsentType" withStatus:true withVersion:1 completion:^(BOOL storeFlag, NSError *error) {
                receivedError = error;
            }];
            [[receivedError shouldNotEventuallyBeforeTimingOutAfter(0.3)] beNil];
            [[theValue(receivedError.code) shouldEventuallyBeforeTimingOutAfter(0.3)] equal:theValue(DIGDPRRegConsentError)];
        });
        
    });
    
});

SPEC_END

