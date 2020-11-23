//
//  JanRainServiceTests.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 30/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <Kiwi/KWNilMatcher.h>
#import <Kiwi/KWEqualMatcher.h>
#import "JanrainService.h"
#import "JRCaptureUser+Extras.h"
#import "URJanRainConfiguration.h"
#import "JRCapture.h"
#import "JRCaptureConfig.h"
#import "JRCaptureData.h"
#import "JREngage.h"
#import "JREngageError.h"
#import "JanRainTestsHelper.h"
#import "DIConsumerInterest.h"
#import "DIHTTPUtility.h"
#import "JRSessionData.h"
#import "URSettingsWrapper.h"

SPEC_BEGIN(JanrainServiceSpec)

describe(@"JanrainService", ^{
    
    __block JanrainService *janrainService;
    
    beforeAll(^{
        janrainService = [[JanrainService alloc] init];
    });
    
    it(@"should not be nil when initialized and should not return error for flow download if flow is downloaded successfully", ^{
        __unused id jrCapture = [KWMock mockForClass:[JRCapture class]];
        [JRCapture stub:@selector(setRedirectUri:)];
        [JRCapture stub:@selector(setCaptureConfig:) withBlock:^id(NSArray *params) {
            [[NSNotificationCenter defaultCenter] postNotificationName:JRFinishedUpdatingEngageConfigurationNotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:JRDownloadFlowResult object:nil];
            return nil;
        }];
        __block NSError *receivedError = [NSError errorWithDomain:@"Dummy-Domain" code:1012 userInfo:nil];
        janrainService = [[JanrainService alloc] init];
        [janrainService downloadConfigurationForCountryCode:@"IN" locale:@"en_IN" serviceURLs:[JanRainTestsHelper dummyServiceURLs] completion:^(NSError *error) {
            receivedError = error;
        }];
        [[janrainService shouldNot] beNil];
        [[expectFutureValue(receivedError) shouldEventually] beNil];
    });
    
    
    context(@"method loginToTraditionalUsingEmail:password:withSuccessHandler:failureHandler:", ^{
        
        it(@"should return error if email is nil", ^{
            [janrainService loginToTraditionalUsingEmail:nil password:@"someDummyPassword" withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                fail(@"can not be successful if email is not provided");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should return error if password is nil", ^{
           [janrainService loginToTraditionalUsingEmail:@"dummy@mail.com" password:nil withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
               fail(@"can not be successful if password is not provided");
           } failureHandler:^(NSError *error) {
               [[error shouldNot] beNil];
           }];
        });
        
        it(@"should return error if JR SDK returns error", ^{
            __unused id jrCapture = [KWMock mockForClass:[JRCapture class]];
            [JRCapture stub:@selector(startCaptureTraditionalSignInForUser:withPassword:mergeToken:forDelegate:) withBlock:^id(NSArray *params) {
                id<JRCaptureDelegate> delegate = params[3];
                [delegate captureSignInDidFailWithError:[NSError errorWithDomain:@"Dummay-Domain" code:1013 userInfo:nil]];
                return nil;
            }];
            [janrainService loginToTraditionalUsingEmail:@"dummy@mail.com" password:@"someDummyPassword" withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                fail(@"can not be successful if JR SDK returned error");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should return JRCaptureUser object and no error if JR SDK returns success", ^{
            __unused id jrCapture = [KWMock mockForClass:[JRCapture class]];
            [JRCapture stub:@selector(startCaptureTraditionalSignInForUser:withPassword:mergeToken:forDelegate:) withBlock:^id(NSArray *params) {
                id<JRCaptureDelegate> delegate = params[3];
                JRCaptureUser *user = [JRCaptureUser new];
                [user stub:@selector(replaceVisitedMicroSitesArrayOnCaptureForDelegate:context:)];
                [delegate captureSignInDidSucceedForUser:user status:JRCaptureRecordExists];
                return nil;
            }];
            [janrainService loginToTraditionalUsingEmail:@"dummy@mail.com" password:@"someDummyPassword" withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                [[user shouldNot] beNil];
                [[theValue(isUpdated) should] equal:theValue(NO)];
            } failureHandler:^(NSError *error) {
                fail(@"can not fail if JR SDK returned success");
            }];
        });
    });
    
    context(@"method refreshAccessTokenWithSuccessHandler:failureHandler:", ^{
        
        it(@"should return error if accessToken is not available", ^{
            [[JRCaptureData sharedCaptureData] setValue:nil forKeyPath:@"accessToken"];
            [janrainService refreshAccessTokenWithSuccessHandler:^{
                fail(@"can not be successful if accessToken is not available");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should return error if JR SDK returns error", ^{
            [[JRCaptureData sharedCaptureData] setValue:@"some-Dummy-Token" forKeyPath:@"accessToken"];
            __unused id jrCapture = [KWMock mockForClass:[JRCapture class]];
            [JRCapture stub:@selector(refreshAccessTokenForDelegate:context:) withBlock:^id(NSArray *params) {
                id<JRCaptureDelegate> delegate = params[0];
                [delegate refreshAccessTokenDidFailWithError:[NSError errorWithDomain:@"Dummy-Domain" code:1014 userInfo:nil] context:nil];
                return nil;
            }];
            [janrainService refreshAccessTokenWithSuccessHandler:^{
                fail(@"can not be successful if JR SDK returned error");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should return success if JR SDK returns success", ^{
            [[JRCaptureData sharedCaptureData] setValue:@"some-Dummy-Token" forKeyPath:@"accessToken"];
            __unused id jrCapture = [KWMock mockForClass:[JRCapture class]];
            [JRCapture stub:@selector(refreshAccessTokenForDelegate:context:) withBlock:^id(NSArray *params) {
                id<JRCaptureDelegate> delegate = params[0];
                [delegate refreshAccessTokenDidSucceedWithContext:nil];
                return nil;
            }];
            [janrainService refreshAccessTokenWithSuccessHandler:^{
                NSLog(@"test case passed");
            } failureHandler:^(NSError *error) {
                fail(@"can not be successful if JR SDK returned error");
            }];
        });
    });
    
    context(@"method logoutWithCompletion:", ^{
       
        it(@"should never fail", ^{
            [janrainService logoutWithCompletion:^{
                NSLog(@"Logout has not failure case");
            }];
        });
    });
    
    context(@"method registerNewUserUsingEmail:orMobileNumber:password:name:ageLimitPassed:marketingOptIn:withSuccessHandler:failureHandler:", ^{
        
        it(@"should return error if email and mobile both are not provided", ^{
            [janrainService registerNewUserUsingEmail:nil orMobileNumber:nil password:@"someDummyPassword" firstName:@"dummyFirstName" lastName:@"dummyLastName" ageLimitPassed:YES marketingOptIn:YES withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                fail(@"must not be success if email and mobile both are not provided");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should return error if password is not provided", ^{
            [janrainService registerNewUserUsingEmail:@"dummy@mail.com" orMobileNumber:nil password:nil firstName:@"dummyFirstName" lastName:@"dummyLastName" ageLimitPassed:YES marketingOptIn:YES withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                fail(@"must not be success if password is not provided");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should return error if name is not provided", ^{
           [janrainService registerNewUserUsingEmail:@"dummy@mail.com" orMobileNumber:nil password:@"dummyPassword" firstName:nil lastName:@"dummyLastName" ageLimitPassed:YES marketingOptIn:YES withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
               fail(@"must not be success if name is not provided");
           } failureHandler:^(NSError *error) {
               [[error shouldNot] beNil];
           }];
        });
        
        it(@"should return error if age limit is not passed", ^{
           [janrainService registerNewUserUsingEmail:@"dummy@mail.com" orMobileNumber:nil password:@"somePassword" firstName:@"dummyFirstName" lastName:@"dummyLastName" ageLimitPassed:NO marketingOptIn:YES withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
              fail(@"must not be success if age limit is not passed");
           } failureHandler:^(NSError *error) {
               [[error shouldNot] beNil];
           }];
        });
        
        it(@"should return error if JR SDK has returned error", ^{
            __unused id jrCapture = [KWMock mockForClass:[JRCapture class]];
            [JRCapture stub:@selector(registerNewUser:socialRegistrationToken:forDelegate:) withBlock:^id(NSArray *params) {
                id<JRCaptureDelegate> delegate = params[2];
                [delegate registerUserDidFailWithError:[NSError errorWithDomain:@"Dummy-Domain" code:1015 userInfo:nil]];
                return nil;
            }];
            [janrainService registerNewUserUsingEmail:@"dummy@mail.com" orMobileNumber:nil password:@"dummyPassword" firstName:@"dummyFirstName" lastName:@"dummyLastName" ageLimitPassed:YES marketingOptIn:YES withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                fail(@"must not be success if JR SDK returned error");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should return user object if JR SDK returns success with user", ^{
            __unused id jrCapture = [KWMock mockForClass:[JRCapture class]];
            [JRCapture stub:@selector(registerNewUser:socialRegistrationToken:forDelegate:) withBlock:^id(NSArray *params) {
                id<JRCaptureDelegate> delegate = params[2];
                JRCaptureUser *user = [JRCaptureUser new];
                [user stub:@selector(updateOnCaptureForDelegate:context:)];
                [user stub:@selector(replaceVisitedMicroSitesArrayOnCaptureForDelegate:context:)];
                [user stub:@selector(replaceRolesArrayOnCaptureForDelegate:context:)];
                [delegate registerUserDidSucceed:user];
                return nil;
            }];
            [janrainService registerNewUserUsingEmail:@"dummy@mail.com" orMobileNumber:nil password:@"dummyPassword" firstName:@"dummyFirstName" lastName:@"dummyLastName" ageLimitPassed:YES marketingOptIn:YES withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated){
                [[user shouldNot] beNil];
                [[theValue(isUpdated) should] equal:theValue(NO)];
            } failureHandler:^(NSError *error) {
                fail(@"must not fail if JR SDK retuned success with user object");
            }];
        });
    });
    
    context(@"method resendVerificationMailForEmail:withSuccessHandler:failureHandler:", ^{
       
        it(@"should return error if email is not provided", ^{
            [janrainService resendVerificationMailForEmail:nil withSuccessHandler:^{
                fail(@"must not be success if email is not provided");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should return error if JR SDK returned error", ^{
            __unused id jrCapture = [KWMock mockForClass:[JRCapture class]];
            [JRCapture stub:@selector(resendVerificationEmail:delegate:) withBlock:^id(NSArray *params) {
                id<JRCaptureDelegate> delegate = params[1];
                [delegate resendVerificationEmailDidFailWithError:[NSError errorWithDomain:@"Dummy-Domain" code:1016 userInfo:nil]];
                return nil;
            }];
            [janrainService resendVerificationMailForEmail:@"dummy@mail.com" withSuccessHandler:^{
                fail(@"must not be success if server returns error");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should return success if server returns success", ^{
            __unused id jrCapture = [KWMock mockForClass:[JRCapture class]];
            [JRCapture stub:@selector(resendVerificationEmail:delegate:) withBlock:^id(NSArray *params) {
                id<JRCaptureDelegate> delegate = params[1];
                [delegate resendVerificationEmailDidSucceed];
                return nil;
            }];
            [janrainService resendVerificationMailForEmail:@"dummy@mail.com" withSuccessHandler:^{
                NSLog(@"resend verification email test succeeded");
            } failureHandler:^(NSError *error) {
                fail(@"must not fail if server returned success");
            }];
        });
    });
    
    context(@"method updateFields:forUser:withSuccessHandler:failureHandler:", ^{
        
        beforeEach(^{
            [NSKeyedArchiver stub:@selector(archivedDataWithRootObject:) withBlock:^id(NSArray *params) {
                return params[0];
            }];
            [NSKeyedUnarchiver stub:@selector(unarchiveObjectWithData:) withBlock:^id(NSArray *params) {
                return params[0];
            }];
        });
        
        afterEach(^{
            [NSKeyedArchiver clearStubs];
            [NSKeyedUnarchiver clearStubs];
        });
        
        it(@"should return error if user object is not provided", ^{
            NSDictionary *fields = @{@"receiveMarketingEmail": @(YES)};
            [janrainService updateFields:fields forUser:nil withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                fail(@"must not succeed if user object is nil");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should return error if server returns error", ^{
            JRCaptureUser *mockedUser = [KWMock partialMockForObject:[JRCaptureUser new]];
            [mockedUser stub:@selector(updateOnCaptureForDelegate:context:) withBlock:^id(NSArray *params) {
                id<JRCaptureObjectDelegate> delegate = params[0];
                [delegate updateDidFailForObject:mockedUser withError:[NSError errorWithDomain:@"Dummy-Domain" code:1017 userInfo:nil] context:nil];
                return nil;
            }];
            NSDictionary *fields = @{@"receiveMarketingEmail": @(YES)};
            [janrainService updateFields:fields forUser:mockedUser withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                fail(@"must not succeed if server returned error");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should refresh token if session expiration error is received and return error if refresh fails", ^{
            //mock user object to return token expiration error
            JRCaptureUser *mockedUser = [KWMock partialMockForObject:[JRCaptureUser new]];
            [[mockedUser should] receive:@selector(updateOnCaptureForDelegate:context:) withCount:1];
            [mockedUser stub:@selector(updateOnCaptureForDelegate:context:) withBlock:^id(NSArray *params) {
                id<JRCaptureObjectDelegate> delegate = params[0];
                id context = params[1];
                [delegate updateDidFailForObject:mockedUser withError:[NSError errorWithDomain:@"Dummy-Domain" code:3414 userInfo:nil] context:context];
                return nil;
            }];

            //Mock JRCapture to return error at refresh token.
            [[JRCaptureData sharedCaptureData] setValue:@"some-Dummy-Token" forKeyPath:@"accessToken"];
            [[JRCapture should] receive:@selector(refreshAccessTokenForDelegate:context:) withCount:1];
            [JRCapture stub:@selector(refreshAccessTokenForDelegate:context:) withBlock:^id(NSArray *params) {
                id<JRCaptureDelegate> delegate = params[0];
                [delegate refreshAccessTokenDidFailWithError:[NSError errorWithDomain:@"Dummy-Domain" code:1014 userInfo:nil] context:nil];
                return nil;
            }];
            
            //Call update API
            NSDictionary *fields = @{@"receiveMarketingEmail": @(YES)};
            [janrainService updateFields:fields forUser:mockedUser withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                fail(@"Should not succeed if token has expired and refresh token has failed");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
                [[theValue(error.code) should] equal:theValue(DIUnexpectedErrorCode)];
            }];
        });
        
        it(@"should refresh token if session is expired and return error if update error is received after that", ^{
            //mock user object to return token expiration error and then update error
            __block BOOL shouldReturnRefreshError = YES;
            JRCaptureUser *mockedUser = [KWMock partialMockForObject:[JRCaptureUser new]];
            [[mockedUser should] receive:@selector(updateOnCaptureForDelegate:context:) withCount:2];
            [mockedUser stub:@selector(updateOnCaptureForDelegate:context:) withBlock:^id(NSArray *params) {
                id<JRCaptureObjectDelegate> delegate = params[0];
                id context = params[1];
                if(shouldReturnRefreshError) {
                    shouldReturnRefreshError = NO;
                    [delegate updateDidFailForObject:mockedUser withError:[NSError errorWithDomain:@"Dummy-Domain" code:3414 userInfo:nil] context:context];
                } else {
                    [delegate updateDidFailForObject:mockedUser withError:[NSError errorWithDomain:@"Dummy-Domain" code:1014 userInfo:nil] context:context];
                }
                return nil;
            }];
            
            //Mock JRCapture to return success at refresh token.
            [[JRCaptureData sharedCaptureData] setValue:@"some-Dummy-Token" forKeyPath:@"accessToken"];
            [[JRCapture should] receive:@selector(refreshAccessTokenForDelegate:context:) withCount:1];
            [JRCapture stub:@selector(refreshAccessTokenForDelegate:context:) withBlock:^id(NSArray *params) {
                id<JRCaptureDelegate> delegate = params[0];
                [delegate refreshAccessTokenDidSucceedWithContext:nil];
                return nil;
            }];
            
            //Call update API
            NSDictionary *fields = @{@"receiveMarketingEmail": @(YES)};
            [janrainService updateFields:fields forUser:mockedUser withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                fail(@"Should not succeed if update has failed even after token refresh");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
                [[theValue(error.code) should] equal:theValue(DIUnexpectedErrorCode)];
            }];
        });
        
        it(@"should refresh token if session is expired and return success if update is successful after refresh", ^{
            //mock user object to return token expiration error and then update success
            __block BOOL shouldReturnError = YES;
            JRCaptureUser *mockedUser = [KWMock partialMockForObject:[JRCaptureUser new]];
            [[mockedUser should] receive:@selector(updateOnCaptureForDelegate:context:) withCount:2];
            [mockedUser stub:@selector(updateOnCaptureForDelegate:context:) withBlock:^id(NSArray *params) {
                id<JRCaptureObjectDelegate> delegate = params[0];
                id context = params[1];
                if(shouldReturnError) {
                    shouldReturnError = NO;
                    [delegate updateDidFailForObject:mockedUser withError:[NSError errorWithDomain:@"Dummy-Domain" code:3414 userInfo:nil] context:context];
                } else {
                    [delegate updateDidSucceedForObject:mockedUser context:context];
                }
                return nil;
            }];
            
            //Mock JRCapture to return success at refresh token.
            [[JRCaptureData sharedCaptureData] setValue:@"some-Dummy-Token" forKeyPath:@"accessToken"];
            [[JRCapture should] receive:@selector(refreshAccessTokenForDelegate:context:) withCount:1];
            [JRCapture stub:@selector(refreshAccessTokenForDelegate:context:) withBlock:^id(NSArray *params) {
                id<JRCaptureDelegate> delegate = params[0];
                [delegate refreshAccessTokenDidSucceedWithContext:nil];
                return nil;
            }];
            
            //Call update API
            NSDictionary *fields = @{@"receiveMarketingEmail": @(YES)};
            [janrainService updateFields:fields forUser:mockedUser withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                [[user shouldNot] beNil];
                [[theValue(isUpdated) should] equal:theValue(YES)];
            } failureHandler:^(NSError *error) {
                fail(@"Must not fail if refresh session was success and update after that was also successful");
            }];
        });
        
        it(@"should return updated user object when server returns success", ^{
            JRCaptureUser *mockedUser = [KWMock partialMockForObject:[JRCaptureUser new]];
            [mockedUser stub:@selector(updateOnCaptureForDelegate:context:) withBlock:^id(NSArray *params) {
                id<JRCaptureObjectDelegate> delegate = params[0];
                [delegate updateDidSucceedForObject:mockedUser context:nil];
                return nil;
            }];
            NSDate *marketingTimestamp = [NSDate date];
            JRMarketingOptIn *marketingOptIn = [[JRMarketingOptIn alloc] init];
            marketingOptIn.locale = @"en-US";
            marketingOptIn.timestamp = marketingTimestamp;
            mockedUser.marketingOptIn = marketingOptIn;
            mockedUser.receiveMarketingEmail = @(YES);
            NSDictionary *fields = @{@"receiveMarketingEmail": @(YES)};
            
            [janrainService updateFields:fields forUser:mockedUser withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                [[user shouldNot] beNil];
                [[user.marketingOptIn shouldNot] beNil];
                [[user.marketingOptIn.locale should] equal:@"en-US"];
                [[user.marketingOptIn.timestamp should] equal:marketingTimestamp];
                [[user.receiveMarketingEmail should] equal:@(YES)];
                [[theValue(isUpdated) should] equal:theValue(YES)];
            } failureHandler:^(NSError *error) {
                fail(@"must not fail when server has returned success");
            }];
        });
    });
    
    context(@"method replaceConsumerInterests:forUser:withSuccessHandler:failureHandler:", ^{
        
        it(@"should return error if interests are not provided", ^{
            [janrainService replaceConsumerInterests:nil forUser:[JRCaptureUser new] withSuccessHandler:^{
                fail(@"must not succeed if interests are nil");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should return error if user object is not provided", ^{
            DIConsumerInterest *interest = [[DIConsumerInterest alloc] init];
            [janrainService replaceConsumerInterests:@[interest] forUser:nil withSuccessHandler:^{
                fail(@"must not succeed if user object is not available");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should return error if server returned error", ^{
            JRCaptureUser *mockedUser = [KWMock partialMockForObject:[JRCaptureUser new]];
            [mockedUser stub:@selector(replaceConsumerInterestsArrayOnCaptureForDelegate:context:) withBlock:^id(NSArray *params) {
                id<JRCaptureObjectDelegate> delegate = params[0];
                [delegate replaceArrayDidFailForObject:mockedUser arrayNamed:@"consumerInterests" withError:[NSError errorWithDomain:@"Dummy-Domain" code:1018 userInfo:nil] context:nil];
                return nil;
            }];
            DIConsumerInterest *interest = [JanRainTestsHelper dummyConsumerInterest];
            [janrainService replaceConsumerInterests:@[interest] forUser:mockedUser withSuccessHandler:^{
                fail(@"must not succeed if server has returned error");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should return success if server returns success", ^{
            JRCaptureUser *mockedUser = [KWMock partialMockForObject:[JRCaptureUser new]];
            [mockedUser stub:@selector(replaceConsumerInterestsArrayOnCaptureForDelegate:context:) withBlock:^id(NSArray *params) {
                id<JRCaptureObjectDelegate> delegate = params[0];
                [delegate replaceArrayDidSucceedForObject:mockedUser newArray:nil named:@"consumerInterests" context:nil];
                return nil;
            }];
            DIConsumerInterest *interest = [JanRainTestsHelper dummyConsumerInterest];
            [janrainService replaceConsumerInterests:@[interest] forUser:mockedUser withSuccessHandler:^{
                NSLog(@"update success");
            } failureHandler:^(NSError *error) {
                fail(@"must not fail if server returned success for update");
            }];
        });
    });
    
    context(@"method updateCOPPAConsentAcceptance:forUser:withSuccessHandler:failureHandler:", ^{

        it(@"it should return error if server returns error", ^{
            [NSKeyedArchiver stub:@selector(archivedDataWithRootObject:) withBlock:^id(NSArray *params) {
                return params[0];
            }];
            [NSKeyedUnarchiver stub:@selector(unarchiveObjectWithData:) withBlock:^id(NSArray *params) {
                return params[0];
            }];
            JRCaptureUser *mockedUser = [KWMock partialMockForObject:[JRCaptureUser new]];
            [mockedUser stub:@selector(replaceConsentsArrayOnCaptureForDelegate:context:) withBlock:^id(NSArray *params) {
                id<JRCaptureObjectDelegate> delegate = params[0];
                [delegate replaceArrayDidFailForObject:mockedUser arrayNamed:@"consents" withError:[NSError errorWithDomain:@"Dummy-Domain" code:1019 userInfo:nil] context:nil];
                return nil;
            }];
            [janrainService updateCOPPAConsentAcceptance:YES forUser:mockedUser withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                fail(@"must not succeed if server has returned error");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });

        it(@"it should return updated user object if server returns success", ^{
            [NSKeyedArchiver stub:@selector(archivedDataWithRootObject:) withBlock:^id(NSArray *params) {
                return params[0];
            }];
            [NSKeyedUnarchiver stub:@selector(unarchiveObjectWithData:) withBlock:^id(NSArray *params) {
                return params[0];
            }];
            JRCaptureUser *mockedUser = [KWMock partialMockForObject:[JRCaptureUser new]];
            [mockedUser stub:@selector(replaceConsentsArrayOnCaptureForDelegate:context:) withBlock:^id(NSArray *params) {
                id<JRCaptureObjectDelegate> delegate = params[0];
                [delegate replaceArrayDidSucceedForObject:mockedUser newArray:nil named:@"consents" context:nil];
                return nil;
            }];
            [janrainService updateCOPPAConsentAcceptance:YES forUser:mockedUser withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                [[user shouldNot] beNil];
                [[user.consents should] haveCountOfAtLeast:1];
                JRConsentsElement *consent = user.consents.firstObject;
                [[consent.given should] equal:@(YES)];
            } failureHandler:^(NSError *error) {
                fail(@"must not fail when server returned success");
            }];
        });
    });
    
    context(@"method updateCOPPAConsentApproval:forUser:withSuccessHandler:failureHandler:", ^{
        
        it(@"should return error if server returned error", ^{
            [NSKeyedArchiver stub:@selector(archivedDataWithRootObject:) withBlock:^id(NSArray *params) {
                return params[0];
            }];
            [NSKeyedUnarchiver stub:@selector(unarchiveObjectWithData:) withBlock:^id(NSArray *params) {
                return params[0];
            }];
            JRCaptureUser *mockedUser = [KWMock partialMockForObject:[JRCaptureUser new]];
            [mockedUser stub:@selector(replaceConsentsArrayOnCaptureForDelegate:context:) withBlock:^id(NSArray *params) {
                id<JRCaptureObjectDelegate> delegate = params[0];
                [delegate replaceArrayDidFailForObject:mockedUser arrayNamed:@"consents" withError:[NSError errorWithDomain:@"Dummy-Domain" code:1019 userInfo:nil] context:nil];
                return nil;
            }];
            [janrainService updateCOPPAConsentApproval:YES forUser:mockedUser withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                fail(@"must not succeed if server returned error");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should return updated user object if server returned success", ^{
            [NSKeyedArchiver stub:@selector(archivedDataWithRootObject:) withBlock:^id(NSArray *params) {
                return params[0];
            }];
            [NSKeyedUnarchiver stub:@selector(unarchiveObjectWithData:) withBlock:^id(NSArray *params) {
                return params[0];
            }];
            JRCaptureUser *mockedUser = [KWMock partialMockForObject:[JRCaptureUser new]];
            [mockedUser stub:@selector(replaceConsentsArrayOnCaptureForDelegate:context:) withBlock:^id(NSArray *params) {
                id<JRCaptureObjectDelegate> delegate = params[0];
                [delegate replaceArrayDidSucceedForObject:mockedUser newArray:nil named:@"consents" context:nil];
                return nil;
            }];
            [janrainService updateCOPPAConsentApproval:YES forUser:mockedUser withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                [[user shouldNot] beNil];
                [[theValue(isUpdated) should] equal:theValue(NO)];
                JRConsentsElement *consent = user.consents.firstObject;
                [[consent.confirmationGiven should] equal:@(YES)];
            } failureHandler:^(NSError *error) {
                fail(@"must not fail if server has returned success");
            }];
        });
    });

    context(@"method refetchUserProfileWithSuccessHandler:failure:", ^{

        it(@"should fail if access token is not available", ^{
            [[JRCaptureData sharedCaptureData] setValue:nil forKeyPath:@"accessToken"];
            [janrainService refetchUserProfileWithSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                fail(@"must not success if access token not available");
            } failure:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });

        it(@"should return error if server returned error", ^{
            [[JRCaptureData sharedCaptureData] setValue:@"dummyAccessToken" forKeyPath:@"accessToken"];
            __unused id mockedUser = [KWMock mockForClass:[JRCaptureUser class]];
            [JRCaptureUser stub:@selector(fetchCaptureUserFromServerForDelegate:context:) withBlock:^id(NSArray *params) {
                id<JRCaptureUserDelegate> delegate = params[0];
                [delegate fetchUserDidFailWithError:[NSError errorWithDomain:@"Dummy-Domain" code:1020 userInfo:nil] context:nil];
                return nil;
            }];
            [janrainService refetchUserProfileWithSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                fail(@"must not succeed if server returned error");
            } failure:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });

        it(@"should return latest user object if server returned success", ^{
            [[JRCaptureData sharedCaptureData] setValue:@"dummyAccessToken" forKeyPath:@"accessToken"];
            __unused id mockedUser = [KWMock mockForClass:[JRCaptureUser class]];
            [JRCaptureUser stub:@selector(fetchCaptureUserFromServerForDelegate:context:) withBlock:^id(NSArray *params) {
                id<JRCaptureUserDelegate> delegate = params[0];
                [delegate fetchUserDidSucceed:[JRCaptureUser  new] context:nil];
                return nil;
            }];
            [janrainService refetchUserProfileWithSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                [[user shouldNot] beNil];
                [[theValue(isUpdated) should] equal:theValue(NO)];
            } failure:^(NSError *error) {
                fail(@"must not fail if server returned success");
            }];
        });
    });

    context(@"method resetPasswordForEmail:withSuccessHandler:failureHandler:", ^{

        it(@"should return error if email is not provided", ^{
            [janrainService resetPasswordForEmail:nil withSuccessHandler:^{
                fail(@"must not pass if email is not provided");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });

        it(@"should return error if server returned error", ^{
            id httpUtilityMock = [DIHTTPUtility mock];
            [[httpUtilityMock should] receive:@selector(startURLConnectionWithRequest:completionHandler:)];
            KWCaptureSpy *spy = [httpUtilityMock captureArgument:@selector(startURLConnectionWithRequest:completionHandler:) atIndex:1];
            [janrainService setValue:httpUtilityMock forKeyPath:@"httpUtility"];

            __block NSError *receivedError;
            [janrainService resetPasswordForEmail:@"dummay@mail.com" withSuccessHandler:^{
                fail(@"must not pass if server returned error");
            } failureHandler:^(NSError *error) {
                receivedError = error;
            }];

            DIHTTPConnectionCompletionHandler handler = spy.argument;
            handler(nil, nil, [NSError errorWithDomain:@"dummyDomain" code:1006 userInfo:nil]);
            [[receivedError shouldNotEventuallyBeforeTimingOutAfter(2.0)] beNil];
        });

        it(@"should return error if server response is malformed", ^{
            id httpUtilityMock = [DIHTTPUtility mock];
            [[httpUtilityMock should] receive:@selector(startURLConnectionWithRequest:completionHandler:)];
            KWCaptureSpy *spy = [httpUtilityMock captureArgument:@selector(startURLConnectionWithRequest:completionHandler:) atIndex:1];
            [janrainService setValue:httpUtilityMock forKeyPath:@"httpUtility"];

            __block NSError *receivedError;
            [janrainService resetPasswordForEmail:@"dummay@mail.com" withSuccessHandler:^{
                fail(@"must not succeed if server returned malformed response");
            } failureHandler:^(NSError *error) {
                receivedError = error;
            }];
            DIHTTPConnectionCompletionHandler handler = spy.argument;
            handler([NSURLResponse new], [NSData new], nil);
            [[receivedError shouldNotEventuallyBeforeTimingOutAfter(2.0)] beNil];
        });

        it(@"should return success if server returned success", ^{
            id httpUtilityMock = [DIHTTPUtility mock];
            [[httpUtilityMock should] receive:@selector(startURLConnectionWithRequest:completionHandler:)];
            KWCaptureSpy *spy = [httpUtilityMock captureArgument:@selector(startURLConnectionWithRequest:completionHandler:) atIndex:1];
            [janrainService setValue:httpUtilityMock forKeyPath:@"httpUtility"];

            [janrainService resetPasswordForEmail:@"dummay@mail.com" withSuccessHandler:^{
                NSLog(@"successfully sent reset password link");
            } failureHandler:^(NSError *error) {
                fail(@"must not fail if server returned success");
            }];
            DIHTTPConnectionCompletionHandler handler = spy.argument;
            NSDictionary *expectedResponse = @{@"stat": @"ok"};
            handler([NSURLResponse new], [NSJSONSerialization dataWithJSONObject:expectedResponse options:kNilOptions error:nil], nil);
        });
    });

    context(@"method resendVerificationCodeForMobileNumber:withSuccessHandler:failureHandler:", ^{

        it(@"should return error if mobile number is not provided", ^{
            [janrainService resendVerificationCodeForMobileNumber:nil withSuccessHandler:^{
                fail(@"must not succeed if mobile number is not provided");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });

        it(@"should return error if server returned error", ^{
            id httpUtilityMock = [DIHTTPUtility mock];
            [[httpUtilityMock should] receive:@selector(startURLConnectionWithRequest:completionHandler:)];
            KWCaptureSpy *spy = [httpUtilityMock captureArgument:@selector(startURLConnectionWithRequest:completionHandler:) atIndex:1];
            [janrainService setValue:httpUtilityMock forKeyPath:@"httpUtility"];

            __block NSError *receivedError;
            [janrainService resendVerificationCodeForMobileNumber:@"9876543210" withSuccessHandler:^{
                fail(@"must not succeed if server returned error");
            } failureHandler:^(NSError *error) {
                receivedError = error;
            }];
            DIHTTPConnectionCompletionHandler handler = spy.argument;
            handler(nil, nil, [NSError errorWithDomain:@"Dummy-Domain" code:1021 userInfo:nil]);
            [[receivedError shouldNotEventuallyBeforeTimingOutAfter(2.0)] beNil];
        });

        it(@"should return error if server did not return success code in response data", ^{
            id httpUtilityMock = [DIHTTPUtility mock];
            [[httpUtilityMock should] receive:@selector(startURLConnectionWithRequest:completionHandler:)];
            KWCaptureSpy *spy = [httpUtilityMock captureArgument:@selector(startURLConnectionWithRequest:completionHandler:) atIndex:1];
            [janrainService setValue:httpUtilityMock forKeyPath:@"httpUtility"];

            __block NSError *receivedError;
            [janrainService resendVerificationCodeForMobileNumber:@"9876543210" withSuccessHandler:^{
                fail(@"must not pass if server did not return success code in response data");
            } failureHandler:^(NSError *error) {
                receivedError = error;
            }];
            DIHTTPConnectionCompletionHandler handler = spy.argument;
            NSDictionary *expectedResponse = @{@"errorCode": @"20"};
            NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"dummyURL"] statusCode:200 HTTPVersion:nil headerFields:nil];
            handler(response, [NSJSONSerialization dataWithJSONObject:expectedResponse options:kNilOptions error:nil], nil);
            [[receivedError shouldNotEventuallyBeforeTimingOutAfter(2.0)] beNil];
        });

        /*it(@"should return error if server did not return 200 status code", ^{
            id httpUtilityMock = [DIHTTPUtility mock];
            [[httpUtilityMock should] receive:@selector(startURLConnectionWithRequest:completionHandler:)];
            KWCaptureSpy *spy = [httpUtilityMock captureArgument:@selector(startURLConnectionWithRequest:completionHandler:) atIndex:1];
            [janrainService setValue:httpUtilityMock forKeyPath:@"httpUtility"];

            __block NSError *receivedError;
            [janrainService resendVerificationCodeForMobileNumber:@"9876543210" withSuccessHandler:^{
                fail(@"must not pass if server did not return success code in response data");
            } failureHandler:^(NSError *error) {
                receivedError = error;
            }];
            DIHTTPConnectionCompletionHandler handler = spy.argument;
            NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"dummyURL"] statusCode:403 HTTPVersion:nil headerFields:nil];
            handler(response, nil, nil);
            [[receivedError shouldNotEventuallyBeforeTimingOutAfter(2.0)] beNil];
        });*/

        it(@"should return success if server returned success response correctly", ^{
            id httpUtilityMock = [DIHTTPUtility mock];
            [[httpUtilityMock should] receive:@selector(startURLConnectionWithRequest:completionHandler:)];
            KWCaptureSpy *spy = [httpUtilityMock captureArgument:@selector(startURLConnectionWithRequest:completionHandler:) atIndex:1];
            [janrainService setValue:httpUtilityMock forKeyPath:@"httpUtility"];

            [janrainService resendVerificationCodeForMobileNumber:@"9876543210" withSuccessHandler:^{
                NSLog(@"OTP sent successfully");
            } failureHandler:^(NSError *error) {
                fail(@"must not fail of server returned success response correctly");
            }];
            DIHTTPConnectionCompletionHandler handler = spy.argument;
            NSDictionary *expectedResponse = @{@"errorCode": @"0"};
            NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"dummyURL"] statusCode:200 HTTPVersion:nil headerFields:nil];
            handler(response, [NSJSONSerialization dataWithJSONObject:expectedResponse options:kNilOptions error:nil], nil);
        });
    });

    context(@"method activateAccountWithVerificationCode:forUUID:withSuccessHandler:failureHandler:", ^{

        it(@"should return error if verification code is not provided", ^{
            [janrainService activateAccountWithVerificationCode:nil forUUID:@"someDummyUUID" withSuccessHandler:^{
                fail(@"must not succeed if verification code is not provided");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });

        it(@"should return error if UUID is not provided", ^{
            [janrainService activateAccountWithVerificationCode:@"someDummyCode" forUUID:nil withSuccessHandler:^{
                fail(@"must not succeed if UUID is not provided");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });

        it(@"should return error if server returned error", ^{
            id httpUtilityMock = [DIHTTPUtility mock];
            [[httpUtilityMock should] receive:@selector(startURLConnectionWithRequest:completionHandler:)];
            KWCaptureSpy *spy = [httpUtilityMock captureArgument:@selector(startURLConnectionWithRequest:completionHandler:) atIndex:1];
            [janrainService setValue:httpUtilityMock forKeyPath:@"httpUtility"];

            __block  NSError *receivedError;
            [janrainService activateAccountWithVerificationCode:@"dummy-code" forUUID:@"some-dummy-UUID" withSuccessHandler:^{
                fail(@"must not succeed if server returned error");
            } failureHandler:^(NSError *error) {
                receivedError = error;
            }];
            DIHTTPConnectionCompletionHandler handler = spy.argument;
            handler(nil, nil, [NSError errorWithDomain:@"Dummy-Domain" code:1021 userInfo:nil]);
            [[receivedError shouldNotEventuallyBeforeTimingOutAfter(2.0)] beNil];
        });

        it(@"should return success if server returned success response correctly", ^{
            id httpUtilityMock = [DIHTTPUtility mock];
            [[httpUtilityMock should] receive:@selector(startURLConnectionWithRequest:completionHandler:)];
            KWCaptureSpy *spy = [httpUtilityMock captureArgument:@selector(startURLConnectionWithRequest:completionHandler:) atIndex:1];
            [janrainService setValue:httpUtilityMock forKeyPath:@"httpUtility"];

            __block NSError *someError = [NSError errorWithDomain:@"Dummy-Domain" code:1021 userInfo:nil];
            [janrainService activateAccountWithVerificationCode:@"dummy-code" forUUID:@"some-dummy-UUID" withSuccessHandler:^{
                someError = nil;
            } failureHandler:^(NSError *error) {
                fail(@"must not fail if server returned success response correctly");
            }];
            DIHTTPConnectionCompletionHandler handler = spy.argument;
            NSDictionary *expectedResponse = @{@"stat": @"ok"};
            NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"dummyURL"] statusCode:200 HTTPVersion:nil headerFields:nil];
            handler(response, [NSJSONSerialization dataWithJSONObject:expectedResponse options:kNilOptions error:nil], nil);
            [[someError shouldEventuallyBeforeTimingOutAfter(2.0)] beNil];
        });
    });

    context(@"method resetPasswordForMobileNumber:withSuccessHandler:failureHandler:", ^{

        it(@"should return error if mobile number is not provided", ^{
            [janrainService resetPasswordForMobileNumber:nil withSuccessHandler:^(NSString *token) {
                fail(@"must not succeed if mobile number is not provided");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });

        it(@"should return error if server returned error", ^{
            id httpUtilityMock = [DIHTTPUtility mock];
            [[httpUtilityMock should] receive:@selector(startURLConnectionWithRequest:completionHandler:)];
            KWCaptureSpy *spy = [httpUtilityMock captureArgument:@selector(startURLConnectionWithRequest:completionHandler:) atIndex:1];
            [janrainService setValue:httpUtilityMock forKeyPath:@"httpUtility"];

            __block NSError *receivedError;
            [janrainService resetPasswordForMobileNumber:@"9876543210" withSuccessHandler:^(NSString *token) {
                fail(@"must not pass if server returned error");
            } failureHandler:^(NSError *error) {
                receivedError = error;
            }];
            DIHTTPConnectionCompletionHandler handler = spy.argument;
            handler(nil, nil, [NSError errorWithDomain:@"Dummy-Domain" code:1022 userInfo:nil]);
            [[receivedError shouldNotEventuallyBeforeTimingOutAfter(2.0)] beNil];
        });

        it(@"should return success if server returned success", ^{
            id httpUtilityMock = [DIHTTPUtility mock];
            [[httpUtilityMock should] receive:@selector(startURLConnectionWithRequest:completionHandler:)];
            KWCaptureSpy *spy = [httpUtilityMock captureArgument:@selector(startURLConnectionWithRequest:completionHandler:) atIndex:1];
            [janrainService setValue:httpUtilityMock forKeyPath:@"httpUtility"];

            __block NSString *receivedToken;
            [janrainService resetPasswordForMobileNumber:@"9876543210" withSuccessHandler:^(NSString *token) {
                receivedToken = token;
            } failureHandler:^(NSError *error) {
                fail(@"must not fail if server returned success");
            }];
            NSDictionary *expectedResult = @{@"errorCode": @"0", @"payload":@{@"token":@"some-dummy-token"}};
            NSData *expectedData = [NSJSONSerialization dataWithJSONObject:expectedResult options:kNilOptions error:nil];
            NSHTTPURLResponse *expectedResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://dummy-url.com"] statusCode:200 HTTPVersion:nil headerFields:nil];
            DIHTTPConnectionCompletionHandler handler = spy.argument;
            handler(expectedResponse, expectedData, nil);
            [[receivedToken shouldNotEventuallyBeforeTimingOutAfter(2.0)] beNil];
            [[receivedToken shouldEventuallyBeforeTimingOutAfter(2.0)] equal:@"some-dummy-token"];
        });
    });
    

    context(@"method completeSocialLoginForProfile:registrationToken:withSuccessHandler:failureHandler:", ^{

        it(@"should return error if profile is not provided", ^{
            [janrainService completeSocialLoginForProfile:nil registrationToken:@"some-dummy-token" withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                fail(@"must not succeed if profile is not available");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });

        it(@"should return error if token is not provided", ^{
            [janrainService completeSocialLoginForProfile:[JRCaptureUser new] registrationToken:nil withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                fail(@"must not succeed if token is not available");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });

        it(@"should return error if server returned error", ^{
            [JRCapture stub:@selector(registerNewUser:socialRegistrationToken:forDelegate:) withBlock:^id(NSArray *params) {
                id<JRCaptureDelegate> delegate = params[2];
                [delegate registerUserDidFailWithError:[NSError errorWithDomain:@"Dummy-Domain" code:1024 userInfo:nil]];
                return nil;
            }];
            [janrainService completeSocialLoginForProfile:[JRCaptureUser new] registrationToken:@"some-dummy-token" withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                fail(@"must not pass if server returned error");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });

        it(@"should return registered user if server returned success", ^{
            [JRCapture stub:@selector(registerNewUser:socialRegistrationToken:forDelegate:) withBlock:^id(NSArray *params) {
                id<JRCaptureDelegate> delegate = params[2];
                [delegate registerUserDidSucceed:params[0]];
                return nil;
            }];
            
            JRCaptureUser *mockedUser = [KWMock partialMockForObject:[JRCaptureUser new]];
            [mockedUser stub:@selector(replaceVisitedMicroSitesArrayOnCaptureForDelegate:context:)];
            [mockedUser stub:@selector(replaceRolesArrayOnCaptureForDelegate:context:)];
            [mockedUser stub:@selector(updateOnCaptureForDelegate:context:)];
            
            [janrainService completeSocialLoginForProfile:mockedUser registrationToken:@"some-dummy-token" withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                [[user shouldNot] beNil];
            } failureHandler:^(NSError *error) {
                fail(@"must not fail ig server returned success");
            }];
        });
    });


    context(@"method handleTraditionalToSocialMergeWithEmail:password:mergeToken:successHandler:failureHandler:", ^{

        it(@"should return error if email is not provided", ^{
            [janrainService handleTraditionalToSocialMergeWithEmail:nil password:@"dummy-password" mergeToken:@"some-dummy-token" successHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                fail(@"must not succeed if email is not provided");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });

        it(@"should return error if password is not provided", ^{
            [janrainService handleTraditionalToSocialMergeWithEmail:@"dummy@mail.com" password:nil mergeToken:@"some-dummy-token" successHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                fail(@"must not succeed if password is not provided");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });

        it(@"should return error if merger token is not provided", ^{
            [janrainService handleTraditionalToSocialMergeWithEmail:@"dummy@mail.com" password:@"dummy-password" mergeToken:nil successHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                fail(@"must not succeed if merge token is not provided");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });

        it(@"should return error if server returned error", ^{
            [JRCapture stub:@selector(startCaptureTraditionalSignInForUser:withPassword:mergeToken:forDelegate:) withBlock:^id(NSArray *params) {
                id<JRCaptureDelegate> delegate = params[3];
                [delegate captureSignInDidFailWithError:[NSError errorWithDomain:@"dummy-domain" code:1026 userInfo:nil]];
                return nil;
            }];
            [janrainService handleTraditionalToSocialMergeWithEmail:@"dummy@mail.com" password:@"password" mergeToken:@"token" successHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                fail(@"must not succeed if server returned error");
            } failureHandler:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });
    });
});

SPEC_END
