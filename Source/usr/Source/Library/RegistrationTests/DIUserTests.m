//
//  DIUserTests.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 03/07/17.
//  Copyright © 2017 Philips. All rights reserved.
//

@import AppInfra;
#import "URSettingsWrapper.h"
#import "DIUser+Authentication.h"
#import "DIUser+PrivateData.h"
#import "DIUser+DataInterface.h"
#import "JanrainService.h"
#import "HSDPService.h"
#import "JRCaptureError.h"
#import "Kiwi.h"
#import "JRCapture.h"
#import "URServiceDiscoveryWrapper.h"
#import "DIConstants.h"
#import "URGoogleLoginHandler.h"
#import "FBSDKLoginHandler.h"


SPEC_BEGIN(DIUserSpec)

describe(@"DIUser", ^{
    
    context(@"method registerNewUserUsingTraditional:withMobileNumber:withName:withOlderThanAgeLimit:withReceiveMarketingMails:withPassword:", ^{
        
        __block DIUser *userHandler;
        __block id mockedJanrainService;
        __block id userRegistrationListener;
        
        beforeEach(^{
            mockedJanrainService = [JanrainService mock];
            userHandler = [DIUser getInstance];
            [userHandler setValue:mockedJanrainService forKeyPath:@"janrainService"];
        });
        
        afterEach(^{
            [mockedJanrainService clearStubs];
            [userHandler removeUserRegistrationListener:userRegistrationListener];
        });
    
        
        it(@"should return error to delegates when JanrainService returns error", ^{
            userRegistrationListener = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
            [userHandler addUserRegistrationListener:userRegistrationListener];
            [[userRegistrationListener shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didRegisterFailedwithError:)];
            
            [userRegistrationListener stub:@selector(didRegisterFailedwithError:) withBlock:^id(NSArray *params) {
                NSError *error = params[0];
                [[error shouldNot] beNil];
                return nil;
            }];
            
            [mockedJanrainService stub:@selector(registerNewUserUsingEmail:orMobileNumber:password:firstName:lastName:ageLimitPassed:marketingOptIn:withSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
                JanrainServiceFailureHandler failureHandler = params[8];
                failureHandler([NSError errorWithDomain:@"Dummy Error Domain" code:3001 userInfo:nil]);
                return nil;
            }];
            
            [userHandler registerNewUserUsingTraditional:@"aksjf" withMobileNumber:nil withFirstName:@"firstName" withLastName:@"lastName" withOlderThanAgeLimit:YES withReceiveMarketingMails:YES withPassword:@"siowef"];
        });
        
        it(@"should return valid User object and no error when JanrainService returns success", ^{
            userRegistrationListener = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
            [userHandler addUserRegistrationListener:userRegistrationListener];
            [[userRegistrationListener shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didRegisterSuccessWithUser:)];
            
            [userRegistrationListener stub:@selector(didRegisterSuccessWithUser:) withBlock:^id(NSArray *params) {
                id userObject = params[0];
                [[userObject shouldNot] beNil];
                [[userObject should] beKindOfClass:[DIUser class]];
                return nil;
            }];
            
            [mockedJanrainService stub:@selector(registerNewUserUsingEmail:orMobileNumber:password:firstName:lastName:ageLimitPassed:marketingOptIn:withSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
                JanrainServiceSuccessHandler successHandler = params[7];
                successHandler([JRCaptureUser new], NO);
                return nil;
            }];
            
            [userHandler registerNewUserUsingTraditional:@"aksjf" withMobileNumber:nil withFirstName:@"firstName" withLastName:@"lastName" withOlderThanAgeLimit:YES withReceiveMarketingMails:YES withPassword:@"siowef"];
        });
    });
    
    context(@"method resendVerificationMail:", ^{
        
        __block DIUser *userHandler;
        __block id mockedJanrainService;
        __block id userRegistrationListener;
        
        beforeEach(^{
            mockedJanrainService = [JanrainService mock];
            userHandler = [DIUser getInstance];
            [userHandler setValue:mockedJanrainService forKeyPath:@"janrainService"];
        });
        
        afterEach(^{
            [mockedJanrainService clearStubs];
            [userHandler removeUserRegistrationListener:userRegistrationListener];
        });
       
        it(@"should send error callback when JanrainService returns error", ^{
            userRegistrationListener = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
            [userHandler addUserRegistrationListener:userRegistrationListener];
            [[userRegistrationListener shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didResendEmailverificationFailedwithError:)];
            
            [userRegistrationListener stub:@selector(didResendEmailverificationFailedwithError:) withBlock:^id(NSArray *params) {
                NSError *error = params[0];
                [[error shouldNot] beNil];
                return nil;
            }];
            
            [mockedJanrainService stub:@selector(resendVerificationMailForEmail:withSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
                JanrainServiceFailureHandler failureHandler = params[2];
                failureHandler([NSError errorWithDomain:@"Dummy Error Domain" code:3002 userInfo:nil]);
                return nil;
            }];
            
            [userHandler resendVerificationMail:@"some@mail.com"];
        });
        
        it(@"should send success callback when JanrainService returns success", ^{
            userRegistrationListener = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
            [userHandler addUserRegistrationListener:userRegistrationListener];
            [[userRegistrationListener shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didResendEmailverificationSuccess)];
            
            [mockedJanrainService stub:@selector(resendVerificationMailForEmail:withSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
                dispatch_block_t successHandler = params[1];
                successHandler();
                return nil;
            }];
            
            [userHandler resendVerificationMail:@"some@mail.com"];
        });
    });
    
    context(@"method forgotPasswordForEmail:", ^{
        
        __block DIUser *userHandler;
        __block id mockedJanrainService;
        __block id userRegistrationListener;
        
        beforeEach(^{
            mockedJanrainService = [JanrainService mock];
            userHandler = [DIUser getInstance];
            [userHandler setValue:mockedJanrainService forKeyPath:@"janrainService"];
        });
        
        afterEach(^{
            [mockedJanrainService clearStubs];
            [userHandler removeUserRegistrationListener:userRegistrationListener];
        });
        
        it(@"should send error callback when JanrainService returns error", ^{
            userRegistrationListener = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
            [userHandler addUserRegistrationListener:userRegistrationListener];
            [[userRegistrationListener shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didSendForgotPasswordFailedwithError:)];
            
            [userRegistrationListener stub:@selector(didSendForgotPasswordFailedwithError:) withBlock:^id(NSArray *params) {
                NSError *error = params[0];
                [[error shouldNot] beNil];
                return nil;
            }];
            
            [mockedJanrainService stub:@selector(resetPasswordForEmail:withSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
                JanrainServiceFailureHandler failureHandler = params[2];
                failureHandler([NSError errorWithDomain:@"Dummy Error Domain" code:3003 userInfo:nil]);
                return nil;
            }];
            
            [userHandler forgotPasswordForEmail:@"some@mail.com"];
        });
        
        it(@"should return success callback when JanrainService returns success", ^{
            userRegistrationListener = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
            [userHandler addUserRegistrationListener:userRegistrationListener];
            [[userRegistrationListener shouldEventuallyBeforeTimingOutAfter(2.0)] receive:@selector(didSendForgotPasswordSuccess)];
            [userRegistrationListener stub:@selector(didSendForgotPasswordSuccess) withBlock:^id(NSArray *params) {
                return nil;
            }];
            
            [mockedJanrainService stub:@selector(resetPasswordForEmail:withSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
                dispatch_block_t successHandler = params[1];
                successHandler();
                return nil;
            }];
            
            [userHandler forgotPasswordForEmail:@"some@mail.com"];
        });
    });
    
    context(@"method resendVerificationCodeForMobile:", ^{
        
        __block DIUser *userHandler;
        __block id mockedJanrainService;
        __block id userRegistrationListener;
        
        beforeEach(^{
            mockedJanrainService = [JanrainService mock];
            userHandler = [DIUser getInstance];
            [userHandler setValue:mockedJanrainService forKeyPath:@"janrainService"];
        });
        
        afterEach(^{
            [mockedJanrainService clearStubs];
            [userHandler removeUserRegistrationListener:userRegistrationListener];
        });
        
        it(@"should return success callback if JanrainService returns success", ^{
            userRegistrationListener = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
            [userHandler addUserRegistrationListener:userRegistrationListener];
            [[userRegistrationListener shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didResendMobileverificationSuccess)];
            
            [mockedJanrainService stub:@selector(resendVerificationCodeForMobileNumber:withSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
                dispatch_block_t successHandler = params[1];
                successHandler();
                return nil;
            }];
            
            [userHandler resendVerificationCodeForMobile:@"9876543210"];
        });
        
        it(@"should send error callback when JanrainService returns error", ^{
            userRegistrationListener = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
            [userHandler addUserRegistrationListener:userRegistrationListener];
            [[userRegistrationListener shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didResendMobileverificationFailedwithError:)];
            
            [userRegistrationListener stub:@selector(didResendMobileverificationFailedwithError:) withBlock:^id(NSArray *params) {
                NSError *error = params[0];
                [[error shouldNot] beNil];
                return nil;
            }];
            
            [mockedJanrainService stub:@selector(resendVerificationCodeForMobileNumber:withSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
                JanrainServiceFailureHandler failureHandler = params[2];
                failureHandler([NSError errorWithDomain:@"Dummy Error Domain" code:NSURLErrorNotConnectedToInternet userInfo:nil]);
                return nil;
            }];
            [userHandler resendVerificationCodeForMobile:@"9876543210"];
        });
    });
    
    context(@"method verificationCodeForMobile:", ^{
        
        __block DIUser *userHandler;
        __block id mockedJanrainService;
        __block id userRegistrationListener;
        
        beforeEach(^{
            mockedJanrainService = [JanrainService mock];
            userHandler = [DIUser getInstance];
            [userHandler setValue:mockedJanrainService forKeyPath:@"janrainService"];
        });
        
        afterEach(^{
            [mockedJanrainService clearStubs];
            [userHandler removeUserRegistrationListener:userRegistrationListener];
        });
        
        it(@"should send error callback when JanrainService returns error", ^{
            userRegistrationListener = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
            [userHandler addUserRegistrationListener:userRegistrationListener];
            [[userRegistrationListener shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didVerificationForMobileFailedwithError:)];
            
            [userRegistrationListener stub:@selector(didVerificationForMobileFailedwithError:) withBlock:^id(NSArray *params) {
                NSError *error = params[0];
                [[error shouldNot] beNil];
                return nil;
            }];
            
            [mockedJanrainService stub:@selector(activateAccountWithVerificationCode:forUUID:withSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
                JanrainServiceFailureHandler failureHandler = params[3];
                failureHandler([NSError errorWithDomain:@"Dummy Error Domain" code:3005 userInfo:nil]);
                return nil;
            }];
            
            [userHandler verificationCodeForMobile:@"9876543210"];
        });
        
        it(@"should send success callback if JanrainService returns error", ^{
            userRegistrationListener = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
            [userHandler addUserRegistrationListener:userRegistrationListener];
            [[userRegistrationListener shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didVerificationForMobileSuccess)];
            
            [mockedJanrainService stub:@selector(activateAccountWithVerificationCode:forUUID:withSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
                dispatch_block_t successHandler = params[2];
                successHandler();
                return nil;
            }];
            
            [userHandler verificationCodeForMobile:@"9876543210"];
        });
    });
    
    
    context(@"method verificationCodeToResetPassword:", ^{
        
        __block DIUser *userHandler;
        __block id mockedJanrainService;
        __block id userRegistrationListener;
        
        beforeEach(^{
            mockedJanrainService = [JanrainService mock];
            userHandler = [DIUser getInstance];
            [userHandler setValue:mockedJanrainService forKeyPath:@"janrainService"];
        });
        
        afterEach(^{
            [mockedJanrainService clearStubs];
            [userHandler removeUserRegistrationListener:userRegistrationListener];
        });
        
        it(@"should send failure callback when JanrainService returns error", ^{
            userRegistrationListener = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
            [userHandler addUserRegistrationListener:userRegistrationListener];
            [[userRegistrationListener shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didVerificationForMobileToResetPasswordFailedwithError:)];
            
            [userRegistrationListener stub:@selector(didVerificationForMobileToResetPasswordFailedwithError:) withBlock:^id(NSArray *params) {
                NSError *error = params[0];
                [[error shouldNot] beNil];
                return nil;
            }];
            
            [mockedJanrainService stub:@selector(resetPasswordForMobileNumber:withSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
                JanrainServiceFailureHandler failureHandler = params[2];
                failureHandler([NSError errorWithDomain:@"Dummy Error Domain" code:3006 userInfo:nil]);
                return nil;
            }];
            
            [userHandler verificationCodeToResetPassword:@"9876543210"];
        });
        
        it(@"should return success when JanrainService returns success", ^{
            userRegistrationListener = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
            [userHandler addUserRegistrationListener:userRegistrationListener];
            [[userRegistrationListener shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didVerificationForMobileToResetPasswordSuccessWithToken:)];
            
            [mockedJanrainService stub:@selector(resetPasswordForMobileNumber:withSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
                typedef void (^SuccessHandler) (NSString *token);
                SuccessHandler handler = params[1];
                handler(@"someToken");
                return nil;
            }];
            
            [userHandler verificationCodeToResetPassword:@"9876543210"];
        });
    });
    
    context(@"method loginUsingTraditionalWithEmail:password:", ^{
        
        __block DIUser *userHandler;
        __block id mockedJanrainService;
        __block id userRegistrationListener;
        
        beforeEach(^{
            mockedJanrainService = [JanrainService mock];
            userHandler = [DIUser getInstance];
            [userHandler setValue:mockedJanrainService forKeyPath:@"janrainService"];
        });
        
        afterEach(^{
            [mockedJanrainService clearStubs];
            [userHandler removeUserRegistrationListener:userRegistrationListener];
        });
        
        it(@"should return failure callback if JanrainService returned error", ^{
            userRegistrationListener = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
            [userHandler addUserRegistrationListener:userRegistrationListener];
            [[userRegistrationListener shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didLoginFailedwithError:)];
            
            [userRegistrationListener stub:@selector(didLoginFailedwithError:) withBlock:^id(NSArray *params) {
                NSError *error = params[0];
                [[error shouldNot] beNil];
                return nil;
            }];
            
            [mockedJanrainService stub:@selector(loginToTraditionalUsingEmail:password:withSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
                JanrainServiceFailureHandler failureHandler = params[3];
                failureHandler([NSError errorWithDomain:@"Dummy Error Domain" code:3007 userInfo:nil]);
                return nil;
            }];
            
            [userHandler loginUsingTraditionalWithEmail:@"some@mail.com" password:@"123456"];
        });
        
        it(@"should return failure when logged in user does not have email or mobile number", ^{
            userRegistrationListener = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
            [userHandler addUserRegistrationListener:userRegistrationListener];
            [[userRegistrationListener shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didLoginFailedwithError:)];
            
            [userRegistrationListener stub:@selector(didLoginFailedwithError:) withBlock:^id(NSArray *params) {
                NSError *error = params[0];
                [[error shouldNot] beNil];
                return nil;
            }];
            
            [mockedJanrainService stub:@selector(loginToTraditionalUsingEmail:password:withSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
                JanrainServiceSuccessHandler successHandler = params[2];
                successHandler([JRCaptureUser new], NO);
                return nil;
            }];
            
            [userHandler loginUsingTraditionalWithEmail:@"some@mail.com" password:@"123456"];
        });
        
        it(@"should return failure when logged in user has mobile number but is not verified", ^{
            userRegistrationListener = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
            [userHandler addUserRegistrationListener:userRegistrationListener];
            [[userRegistrationListener shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didLoginFailedwithError:)];
            
            [userRegistrationListener stub:@selector(didLoginFailedwithError:) withBlock:^id(NSArray *params) {
                NSError *error = params[0];
                [[error shouldNot] beNil];
                return nil;
            }];
            
            [mockedJanrainService stub:@selector(loginToTraditionalUsingEmail:password:withSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
                JanrainServiceSuccessHandler successHandler = params[2];
                JRCaptureUser *user = [JRCaptureUser new];
                user.mobileNumber = @"9876543210";
                successHandler(user, NO);
                return nil;
            }];
            
            [userHandler loginUsingTraditionalWithEmail:@"some@mail.com" password:@"123456"];
        });
        
        it(@"should return failure when logged in user has email but is not verified", ^{
            URLaunchInput *launchInput = [[URLaunchInput alloc] init];
            [URSettingsWrapper sharedInstance].launchInput = launchInput;
            
            userRegistrationListener = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
            [userHandler addUserRegistrationListener:userRegistrationListener];
            [[userRegistrationListener shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didLoginFailedwithError:)];
            
            [userRegistrationListener stub:@selector(didLoginFailedwithError:) withBlock:^id(NSArray *params) {
                NSError *error = params[0];
                [[error shouldNot] beNil];
                return nil;
            }];
            
            [mockedJanrainService stub:@selector(loginToTraditionalUsingEmail:password:withSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
                JanrainServiceSuccessHandler successHandler = params[2];
                JRCaptureUser *user = [JRCaptureUser new];
                user.email = params[0];
                successHandler(user, NO);
                return nil;
            }];
            
            [userHandler loginUsingTraditionalWithEmail:@"some@mail.com" password:@"123456"];
        });
        
        it(@"should return success if JanrainService returns success and HSDP service is not available", ^{
            userRegistrationListener = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
            [userHandler addUserRegistrationListener:userRegistrationListener];
            [[userRegistrationListener shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didLoginWithSuccessWithUser:)];
            [userHandler setValue:nil forKeyPath:@"hsdpService"];
            
            [userRegistrationListener stub:@selector(didLoginWithSuccessWithUser:) withBlock:^id(NSArray *params) {
                DIUser *user = params[0];
                [[user.email shouldNot] beNil];
                [[theValue(user.isEmailVerified) should] beYes];
                return nil;
            }];
            
            [mockedJanrainService stub:@selector(loginToTraditionalUsingEmail:password:withSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
                JanrainServiceSuccessHandler successHandler = params[2];
                JRCaptureUser *user = [JRCaptureUser new];
                user.email = params[0];
                user.emailVerified = [NSDate date];
                successHandler(user, NO);
                return nil;
            }];
            
            [userHandler loginUsingTraditionalWithEmail:@"some@mail.com" password:@"some-password"];
        });
        
//        it(@"should return failure if HSDP Service failed even though JanrainService succeeded", ^{
//            userRegistrationListener = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
//            [userHandler addUserRegistrationListener:userRegistrationListener];
//            [[userRegistrationListener shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didLoginFailedwithError:)];
//            __block NSError *loginErorr = nil;
//            [userRegistrationListener stub:@selector(didLoginFailedwithError:) withBlock:^id(NSArray *params) {
//                NSError *error = params[0];
//                [[error shouldNot] beNil];
//                [[theValue(error.code) should] equal:theValue(3008)];
//                loginErorr = error;
//                return nil;
//            }];
//            
//            HSDPService *mockedHSDPService = [HSDPService mock];
//            [userHandler setValue:mockedHSDPService forKeyPath:@"hsdpService"];
//            [[mockedHSDPService should] receive:@selector(loginWithSocialUsingEmail:accessToken:refreshSecret:completion:)];
//            
//            [mockedHSDPService stub:@selector(loginWithSocialUsingEmail:accessToken:refreshSecret:completion:) withBlock:^id(NSArray *params) {
//                HSDPServiceCompletionHandler completionHandler = params[3];
//                completionHandler(nil, [NSError errorWithDomain:@"Dummy Error Domain" code:3008 userInfo:nil]);
//                return nil;
//            }];
//            
//            [mockedJanrainService stub:@selector(loginToTraditionalUsingEmail:password:withSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
//                JanrainServiceSuccessHandler successHandler = params[2];
//                JRCaptureUser *user = [JRCaptureUser new];
//                user.email = params[0];
//                user.emailVerified = [NSDate date];
//                successHandler(user, NO);
//                return nil;
//            }];
//            
//            [userHandler loginUsingTraditionalWithEmail:@"some@mail.com" password:@"some-password"];
//            [[expectFutureValue(loginErorr) shouldNotEventuallyBeforeTimingOutAfter(1.0)] beNil];
//            [mockedHSDPService clearStubs];
//            [userHandler setValue:nil forKeyPath:@"hsdpService"];
//        });
//        
//        it(@"should return success when JanrainService and HSDPService both return success result", ^{
//            userRegistrationListener = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
//            [userHandler addUserRegistrationListener:userRegistrationListener];
//            [[userRegistrationListener shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didLoginWithSuccessWithUser:)];
//            __block DIUser *loggedInUser = nil;
//            [userRegistrationListener stub:@selector(didLoginWithSuccessWithUser:) withBlock:^id(NSArray *params) {
//                DIUser *user = params[0];
//                [[user.email shouldNot] beNil];
//                [[theValue(user.isEmailVerified) should] beYes];
//                [[user.hsdpUUID shouldNot] beNil];
//                loggedInUser = user;
//                return nil;
//            }];
//            
//            HSDPService *mockedHSDPService = [HSDPService mock];
//            [userHandler setValue:mockedHSDPService forKeyPath:@"hsdpService"];
//            [[mockedHSDPService should] receive:@selector(loginWithSocialUsingEmail:accessToken:refreshSecret:completion:)];
//            
//            [mockedHSDPService stub:@selector(loginWithSocialUsingEmail:accessToken:refreshSecret:completion:) withBlock:^id(NSArray *params) {
//                HSDPServiceCompletionHandler completionHandler = params[3];
//                HSDPUser *hsdpUser = [HSDPUser new];
//                hsdpUser.userUUID = @"some-dummy-UUID";
//                completionHandler(hsdpUser, nil);
//                return nil;
//            }];
//            
//            [mockedJanrainService stub:@selector(loginToTraditionalUsingEmail:password:withSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
//                JanrainServiceSuccessHandler successHandler = params[2];
//                JRCaptureUser *user = [JRCaptureUser new];
//                user.email = params[0];
//                user.emailVerified = [NSDate date];
//                successHandler(user, NO);
//                return nil;
//            }];
//            
//            [userHandler loginUsingTraditionalWithEmail:@"some@mail.com" password:@"some-password"];
//            [[expectFutureValue(loggedInUser) shouldNotEventuallyBeforeTimingOutAfter(1.0)] beNil];
//            [mockedHSDPService clearStubs];
//            [userHandler setValue:nil forKeyPath:@"hsdpService"];
//        });
        
        it(@"should tag hsdp uuid if hsdp user profile is there and hsdpUUIDUpload is set to true", ^{
            id appTaggingMock = [KWMock mockForProtocol:@protocol(AIAppTaggingProtocol)];
            URSettingsWrapper.sharedInstance.appTagging = appTaggingMock;
            [URSettingsWrapper.sharedInstance.dependencies.appInfra.appConfig setPropertyForKey:HSDPUUIDUpload group:@"UserRegistration" value:[NSNumber numberWithBool:YES] error:nil];
            [[appTaggingMock should] receive:@selector(trackActionWithInfo:params:) withCount:2];
            
            id hsdpUserMock = [HSDPUser mock];
            [hsdpUserMock stub:@selector(loadPreviousInstance) withBlock:^id(NSArray *params) {
                return hsdpUserMock;
            }];
            __unused DIUser *loggedInUser = [[DIUser alloc] init];
        });
        
        it(@"should not tag hsdp uuid if hsdp user profile is there and hsdpUUIDUpload is set to false", ^{
            id appTaggingMock = [KWMock mockForProtocol:@protocol(AIAppTaggingProtocol)];
            URSettingsWrapper.sharedInstance.appTagging = appTaggingMock;
            [URSettingsWrapper.sharedInstance.dependencies.appInfra.appConfig setPropertyForKey:HSDPUUIDUpload group:@"UserRegistration" value:[NSNumber numberWithBool:NO] error:nil];
            [[appTaggingMock should] receive:@selector(trackActionWithInfo:params:)];//tag should be called based on user state and clear user data, not for HSDP UUID
            
            id hsdpUserMock = [HSDPUser mock];
            [hsdpUserMock stub:@selector(loadPreviousInstance) withBlock:^id(NSArray *params) {
                return hsdpUserMock;
            }];
            __unused DIUser *loggedInUser = [[DIUser alloc] init];
        });
    });
    
    context(@"method handleMergeRegisterWithEmail:withPassword:", ^{
        __block DIUser *userHandler;
        __block id mockedJanrainService;
        __block id userRegistrationListener;
        
        beforeEach(^{
            mockedJanrainService = [JanrainService mock];
            userHandler = [DIUser getInstance];
            [userHandler setValue:mockedJanrainService forKeyPath:@"janrainService"];
        });
        
        afterEach(^{
            [mockedJanrainService clearStubs];
            [userHandler removeUserRegistrationListener:userRegistrationListener];
        });
        
        it(@"should return merge failure if Janrain had returned error", ^{
            userRegistrationListener = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
            [userHandler addUserRegistrationListener:userRegistrationListener];
            [[userRegistrationListener shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didFailHandleMerging:)];
            
            [userRegistrationListener stub:@selector(didFailHandleMerging:) withBlock:^id(NSArray *params) {
                NSError *error = params[0];
                [[error shouldNot] beNil];
                return nil;
            }];
            
            [mockedJanrainService stub:@selector(handleTraditionalToSocialMergeWithEmail:password:mergeToken:successHandler:failureHandler:) withBlock:^id(NSArray *params) {
                JanrainServiceFailureHandler failureHandler = params[4];
                NSError *error = [NSError errorWithDomain:@"Dummy Domain" code:7001 userInfo:nil];
                failureHandler(error);
                return nil;
            }];
            
            [userHandler handleMergeRegisterWithEmail:@"some@one.co" withPassword:@"dummy-password12"];
        });
        
        it(@"should return failure if Janrain returns unverified user", ^{
            userRegistrationListener = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
            [userHandler addUserRegistrationListener:userRegistrationListener];
            [[userRegistrationListener shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didLoginFailedwithError:)];
            
            URLaunchInput *launchInput = [[URLaunchInput alloc] init];
            [URSettingsWrapper sharedInstance].launchInput = launchInput;
            
            [userRegistrationListener stub:@selector(didLoginFailedwithError:) withBlock:^id(NSArray *params) {
                NSError *error = params[0];
                [[error shouldNot] beNil];
                return nil;
            }];
            
            [mockedJanrainService stub:@selector(handleTraditionalToSocialMergeWithEmail:password:mergeToken:successHandler:failureHandler:) withBlock:^id(NSArray *params) {
                JanrainServiceSuccessHandler successHandler = params[3];
                JRCaptureUser *user = [JRCaptureUser new];
                user.email = @"some@mail.com";
                successHandler(user, NO);
                return nil;
            }];
            
            [userHandler handleMergeRegisterWithEmail:@"some@one.com" withPassword:@"dummy-password12"];
        });
        
        it(@"should return success if Janrain returns success with verified user", ^{
            userRegistrationListener = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
            [userHandler addUserRegistrationListener:userRegistrationListener];
            [[userRegistrationListener shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didLoginWithSuccessWithUser:)];
            
            [userRegistrationListener stub:@selector(didLoginWithSuccessWithUser:) withBlock:^id(NSArray *params) {
                DIUser *user = params[0];
                [[user.email shouldNot] beNil];
                [[theValue(user.isEmailVerified) should] beYes];
                return nil;
            }];
            
            [mockedJanrainService stub:@selector(handleTraditionalToSocialMergeWithEmail:password:mergeToken:successHandler:failureHandler:) withBlock:^id(NSArray *params) {
                JanrainServiceSuccessHandler successHandler = params[3];
                JRCaptureUser *user = [JRCaptureUser new];
                user.email = @"some@one.com";
                user.emailVerified = [NSDate date];
                successHandler(user, NO);
                return nil;
            }];
            
            [userHandler handleMergeRegisterWithEmail:@"some@one.com" withPassword:@"dummy-password12"];
        });
    });
    
    context(@"method completeSocialProviderLoginWithEmail:withMobileNumber:withOlderThanAgeLimit:withReceiveMarketingMails:", ^{
        
        __block DIUser *userHandler;
        __block id mockedJanrainService;
        __block id userRegistrationListener;
        
        beforeEach(^{
            mockedJanrainService = [JanrainService mock];
            userHandler = [DIUser getInstance];
            [userHandler setValue:mockedJanrainService forKeyPath:@"janrainService"];
        });
        
        afterEach(^{
            [mockedJanrainService clearStubs];
            [userHandler removeUserRegistrationListener:userRegistrationListener];
        });
        
        it(@"should return failure if Janrain returns error while creating the user", ^{
            userRegistrationListener = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
            [userHandler addUserRegistrationListener:userRegistrationListener];
            [[userRegistrationListener shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didRegisterFailedwithError:)];
            
            [userRegistrationListener stub:@selector(didRegisterFailedwithError:) withBlock:^id(NSArray *params) {
                [[params[0] shouldNot] beNil];
                return nil;
            }];
            
            [mockedJanrainService stub:@selector(completeSocialLoginForProfile:registrationToken:withSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
                JanrainServiceFailureHandler failureHandler = params[3];
                NSError *error = [NSError errorWithDomain:@"Dummy-Domain" code:7002 userInfo:nil];
                failureHandler(error);
                return nil;
            }];
            
            [userHandler completeSocialProviderLoginWithEmail:@"some@mail.com" withMobileNumber:nil withOlderThanAgeLimit:YES withReceiveMarketingMails:YES];
        });
        
        it(@"should return success if Janrain completed login successfully", ^{
            userRegistrationListener = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
            [userHandler addUserRegistrationListener:userRegistrationListener];
            [[userRegistrationListener shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didRegisterSuccessWithUser:)];
            
            [userRegistrationListener stub:@selector(didRegisterSuccessWithUser:) withBlock:^id(NSArray *params) {
                DIUser *user = params[0];
                [[user.email shouldNot] beNil];
                return nil;
            }];
            
            [mockedJanrainService stub:@selector(completeSocialLoginForProfile:registrationToken:withSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
                JanrainServiceSuccessHandler handler = params[2];
                JRCaptureUser *user = params[0];
                user.emailVerified = [NSDate date];
                handler(user, NO);
                return nil;
            }];
            [userHandler setValue:[JRCaptureUser new] forKeyPath:@"userProfile"];
            [userHandler completeSocialProviderLoginWithEmail:@"some@mail.com" withMobileNumber:nil withOlderThanAgeLimit:YES withReceiveMarketingMails:YES];
        });
    });
    
    context(@"user name accessors", ^{
        
        afterAll(^{
            [[DIUser getInstance] setValue:nil forKey:@"userProfile"];
        });
        
        it(@"should return nil if JanrainUser does not exist", ^{
            DIUser *user = [DIUser getInstance];
            [user setValue:nil forKey:@"userProfile"];
            
            [[user.givenName should] beNil];
            [[user.familyName should] beNil];
        });
        
        
        it(@"should read values from JanrainUser object and return nil if JanrainUser returns those values as nil", ^{
            JRCaptureUser *mockUser = [JRCaptureUser mock];
            DIUser *user = [DIUser getInstance];
            [user setValue:mockUser forKey:@"userProfile"];
            
            [[mockUser should] receive:@selector(givenName) andReturn:nil];
            [[mockUser should] receive:@selector(familyName) andReturn:nil];
            
            [[user.givenName should] beNil];
            [[user.familyName should] beNil];
        });
        
        it(@"should read values from JanrainUser object only and return correct value if JanrainUser returns qualified values", ^{
            JRCaptureUser *mockUser = [JRCaptureUser mock];
            DIUser *user = [DIUser getInstance];
            [user setValue:mockUser forKey:@"userProfile"];
            
            [[mockUser should] receive:@selector(givenName) andReturn:@"Django" withCount:2];
            [[mockUser should] receive:@selector(familyName) andReturn:@"Unchained" withCount:2];
            
            [[user.givenName shouldNot] beNil];
            [[user.familyName shouldNot] beNil];
            
            [[user.givenName should] equal:@"Django"];
            [[user.familyName should] equal:@"Unchained"];
        });
    });
    
    
    context(@"marketing timestamp accessors", ^{
        afterAll(^{
            [[DIUser getInstance] setValue:nil forKey:@"userProfile"];
        });
        
        it(@"should return nil if JanrainUser does not exist", ^{
            DIUser *user = [DIUser getInstance];
            [user setValue:nil forKey:@"userProfile"];
            [[user.marketingConsentTimestamp should] beNil];
        });
        
        it(@"should read values from JanrainUser object and return nil if JanrainUser returns timestamp as nil", ^{
            JRCaptureUser *mockUser = [JRCaptureUser mock];
            DIUser *user = [DIUser getInstance];
            [user setValue:mockUser forKey:@"userProfile"];
            [[mockUser should] receive:@selector(marketingOptIn) andReturn:nil];
            [[user.marketingConsentTimestamp should] beNil];
        });

        it(@"should read values from JanrainUser object only and return correct timestamp if JanrainUser returns qualified timestamp", ^{
            JRCaptureUser *mockUser = [JRCaptureUser mock];
            NSDate *unixTime = [NSDate dateWithTimeIntervalSince1970:0];
            DIUser *user = [DIUser getInstance];
            [user setValue:mockUser forKey:@"userProfile"];
            JRMarketingOptIn *mockMarketingConsent = [JRMarketingOptIn mock];
            [mockMarketingConsent stub:@selector(timestamp)andReturn:unixTime];
            [mockUser stub:@selector(marketingOptIn)andReturn:mockMarketingConsent];
            
            [[user.marketingConsentTimestamp shouldNot] beNil];
            [[user.marketingConsentTimestamp should] equal:unixTime];
        });
    });
    
    context(@"user gender accessor", ^{
        
        afterAll(^{
            [[DIUser getInstance] setValue:nil forKey:@"userProfile"];
        });
        
        it(@"should return gender none if user profile does not exist", ^{
            DIUser *user = [DIUser getInstance];
            [user setValue:nil forKey:@"userProfile"];
            
            [[theValue(user.gender) should] equal:theValue(UserGenderNone)];
        });
        
        it(@"should return gender none if user profile exists but gender information does not exist", ^{
            DIUser *user = [DIUser getInstance];
            JRCaptureUser *mockedUser = [KWMock partialMockForObject:[JRCaptureUser new]];
            mockedUser.gender = nil;
            [user setValue:mockedUser forKey:@"userProfile"];
            
            [[theValue(user.gender) should] equal:theValue(UserGenderNone)];
        });
        
        it(@"should return gender none if user profile exists but gender information is not a valid value", ^{
            DIUser *user = [DIUser getInstance];
            JRCaptureUser *mockedUser = [KWMock partialMockForObject:[JRCaptureUser new]];
            mockedUser.gender = @"";
            [user setValue:mockedUser forKey:@"userProfile"];
            
            [[theValue(user.gender) should] equal:theValue(UserGenderNone)];
            
            mockedUser.gender = @"some value";
            [[theValue(user.gender) should] equal:theValue(UserGenderNone)];
            
            mockedUser.gender = @"___ __ ";
            [[theValue(user.gender) should] equal:theValue(UserGenderNone)];
            
            mockedUser.gender = @"*** ***";
            [[theValue(user.gender) should] equal:theValue(UserGenderNone)];
            
            mockedUser.gender = @"     ";
            [[theValue(user.gender) should] equal:theValue(UserGenderNone)];
        });
        
        it(@"should return corrent gnder enum reagrdless of case store gender string", ^{
            DIUser *user = [DIUser getInstance];
            JRCaptureUser *mockedUser = [KWMock partialMockForObject:[JRCaptureUser new]];
            [user setValue:mockedUser forKey:@"userProfile"];
            
            mockedUser.gender = @"male";
            [[theValue(user.gender) should] equal:theValue(UserGenderMale)];
            
            mockedUser.gender = @"Male";
            [[theValue(user.gender) should] equal:theValue(UserGenderMale)];
            
            mockedUser.gender = @"MALE";
            [[theValue(user.gender) should] equal:theValue(UserGenderMale)];
            
            mockedUser.gender = @"MAle";
            [[theValue(user.gender) should] equal:theValue(UserGenderMale)];
            
            mockedUser.gender = @"female";
            [[theValue(user.gender) should] equal:theValue(UserGenderFemale)];
            
            mockedUser.gender = @"Female";
            [[theValue(user.gender) should] equal:theValue(UserGenderFemale)];
            
            mockedUser.gender = @"FEMALE";
            [[theValue(user.gender) should] equal:theValue(UserGenderFemale)];
            
            mockedUser.gender = @"FEmale";
            [[theValue(user.gender) should] equal:theValue(UserGenderFemale)];
            
            mockedUser.gender = @"FEMale";
            [[theValue(user.gender) should] equal:theValue(UserGenderFemale)];
        });
    });
    
    context(@"when refresh session has failed", ^{
        
        it(@"should tag the error if HSDP failed due to 1151", ^{
            id taggingMock = [KWMock mockForProtocol:@protocol(AIAppTaggingProtocol)];
            [taggingMock stub:@selector(trackActionWithInfo:params:) withBlock:^id(NSArray *params) {
                NSString *taggedString = params[1][@"technicalError"];
                [[taggedString should] containString:@"UR"];
                [[taggedString should] containString:@"HSDP"];
                [[taggedString should] containString:@"ForceLogout"];
                [[taggedString should] containString:@"1151"];
                return nil;
            }];
            URSettingsWrapper.sharedInstance.appTagging = taggingMock;
            id timeMock = [KWMock mockForProtocol:@protocol(AITimeProtocol)];
            [timeMock stub:@selector(getUTCTime) withBlock:^id(NSArray *params) {
                return [[NSDate date] dateByAddingTimeInterval:3000];
            }];
            [timeMock stub:@selector(isSynchronized) andReturn:@(1)];
            URSettingsWrapper.sharedInstance.dependencies.appInfra.time = timeMock;
            DIUser *user = [DIUser getInstance];
            id janrainServiceMock = [KWMock mockForClass:[JanrainService class]];
            id hsdpServiceMock = [KWMock mockForClass:[HSDPService class]];
            id hsdpUser = [[HSDPUser alloc] initWithUUID:@"some_uuid" refreshSecret:@"some_refresh_secret" tokenDictionary:@{@"exchange": @{@"accessCredentials": @{@"accessToken": @"some_access_token"}}}];
            [user setValue:janrainServiceMock forKey:@"janrainService"];
            [user setValue:hsdpServiceMock forKey:@"hsdpService"];
            [user setValue:@(1) forKey:@"isCompleteFlowDownloaded"];
            [user setValue:hsdpUser forKey:@"hsdpUser"];

            [janrainServiceMock stub:@selector(refreshAccessTokenWithSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
                void(^failureHandler)(NSError*) = params[1];
                failureHandler([NSError errorWithDomain:@"Janrain" code:1345 userInfo:nil]);
                return nil;
            }];

            [hsdpServiceMock stub:@selector(refreshSessionForUUID:accessToken:refreshSecret:completion:) withBlock:^id(NSArray *params) {
                void(^completion)(HSDPUser *, NSError *) = params[3];
                completion(nil, [NSError errorWithDomain:@"HSDP" code:3413 userInfo:@{@"responseCode": @"1151"}]);
                return nil;
            }];
            [user refreshLoginSession];
            [XCTWaiter waitForExpectations:@[] timeout:5.0];
        });
        
        it(@"should tag the error if Janrain failed due to 3413", ^{
            id taggingMock = [KWMock mockForProtocol:@protocol(AIAppTaggingProtocol)];
            [taggingMock stub:@selector(trackActionWithInfo:params:) withBlock:^id(NSArray *params) {
                NSString *taggedString = params[1][@"Error"];
                [[taggedString should] containString:@"UR"];
                [[taggedString should] containString:@"Janrain"];
                [[taggedString should] containString:@"ForceLogout"];
                [[taggedString should] containString:@"3413"];
                return nil;
            }];
            URSettingsWrapper.sharedInstance.appTagging = taggingMock;
            id timeMock = [KWMock mockForProtocol:@protocol(AITimeProtocol)];
            [timeMock stub:@selector(getUTCTime) withBlock:^id(NSArray *params) {
                return [[NSDate date] dateByAddingTimeInterval:-3000];
            }];
            [timeMock stub:@selector(isSynchronized) andReturn:@(1)];
            URSettingsWrapper.sharedInstance.dependencies.appInfra.time = timeMock;
            DIUser *user = [DIUser getInstance];
            id janrainServiceMock = [KWMock mockForClass:[JanrainService class]];
            id hsdpServiceMock = [KWMock mockForClass:[HSDPService class]];
            id hsdpUser = [[HSDPUser alloc] initWithUUID:@"some_uuid" refreshSecret:@"some_refresh_secret" tokenDictionary:@{@"exchange": @{@"accessCredentials": @{@"accessToken": @"some_access_token"}}}];
            [user setValue:janrainServiceMock forKey:@"janrainService"];
            [user setValue:hsdpServiceMock forKey:@"hsdpService"];
            [user setValue:@(1) forKey:@"isCompleteFlowDownloaded"];
            [user setValue:hsdpUser forKey:@"hsdpUser"];

            [janrainServiceMock stub:@selector(refreshAccessTokenWithSuccessHandler:failureHandler:) withBlock:^id(NSArray *params) {
                void(^failureHandler)(NSError*) = params[1];
                failureHandler([NSError errorWithDomain:@"Janrain" code:3413 userInfo:nil]);
                return nil;
            }];

            [hsdpServiceMock stub:@selector(refreshSessionForUUID:accessToken:refreshSecret:completion:) withBlock:^id(NSArray *params) {
                void(^completion)(HSDPUser *, NSError *) = params[3];
                completion(nil, [NSError errorWithDomain:@"HSDP" code:3413 userInfo:@{@"responseCode": @"1008"}]);
                return nil;
            }];
            [user refreshLoginSession];
            __unused XCTWaiterResult result = [XCTWaiter waitForExpectations:@[] timeout:3.0];
            URSettingsWrapper.sharedInstance.appTagging = nil;
        });
    });
    
    context(@"when logging-in using provider", ^{
        __block DIUser *userHandler;
        beforeAll(^{
            userHandler = [DIUser getInstance];
        });
        context(@"if provider is Google", ^{
            __block URGoogleLoginHandler *googleLoginHandler = nil;
            beforeAll(^{
                googleLoginHandler = [KWMock mockForClass:[URGoogleLoginHandler class]];
                [userHandler setValue:googleLoginHandler forKey:@"googleLoginHandler"];
                userHandler.janrainService = [[JanrainService alloc] init];
            });
            
            afterAll(^{
                userHandler.janrainService = nil;
            });
            
            it(@"should return socialAuthenticationCancelled delegate method when URGoogleLoginHandler returns cancelled error", ^{
                [googleLoginHandler stub:@selector(startGoogleLoginFrom:completion:) withBlock:^id(NSArray *params) {
                    URGoogleLoginCompletion completion = params[1];
                    completion(nil, nil, [NSError errorWithDomain:@"URErrorDomain" code:DIRegAuthenticationError userInfo:nil]);
                    return nil;
                }];
                id protocolMock = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
                [userHandler addUserRegistrationListener:protocolMock];
                [[protocolMock shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(socialAuthenticationCanceled)];
                [userHandler loginUsingProvider:kProviderNameGoogle];
                [userHandler removeUserRegistrationListener:protocolMock];
            });
            
            it(@"should return socialAuthenticationCancelled delegate method when JanrainService returns cancelled error", ^{
                [googleLoginHandler stub:@selector(startGoogleLoginFrom:completion:) withBlock:^id(NSArray *params) {
                    URGoogleLoginCompletion completion = params[1];
                    completion(@"some-dummy-token", @"som@mail.com", nil);
                    return nil;
                }];
                
                [JRCapture stub:@selector(startEngageSignInWithNativeProviderToken:withToken:andTokenSecret:mergeToken:withCustomInterfaceOverrides:forDelegate:) withBlock:^id(NSArray *params) {
                    [[params[0] shouldNot] beNil];
                    [[params[1] shouldNot] beNil];
                    id<JRCaptureDelegate> delegate = params[5];
                    [delegate engageAuthenticationDidCancel];
                    return nil;
                }];
                id protocolMock = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
                [userHandler addUserRegistrationListener:protocolMock];
                [[protocolMock shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(socialAuthenticationCanceled)];
                [userHandler loginUsingProvider:kProviderNameGoogle];
                [userHandler removeUserRegistrationListener:protocolMock];
            });
            
            it(@"should call didLoginFailedwithError: delegate method when URGoogleLoginHandler returns error", ^{
                [googleLoginHandler stub:@selector(startGoogleLoginFrom:completion:) withBlock:^id(NSArray *params) {
                    URGoogleLoginCompletion completion = params[1];
                    completion(nil, nil, [NSError errorWithDomain:@"URErrorDomain" code:1001 userInfo:nil]);
                    return nil;
                }];
                id protocolMock = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
                [userHandler addUserRegistrationListener:protocolMock];
                [[protocolMock shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didLoginFailedwithError:)];
                [userHandler loginUsingProvider:kProviderNameGoogle];
                [userHandler removeUserRegistrationListener:protocolMock];
            });
            
            it(@"shoud call didSocialRegistrationReachedSecoundStepWithUser:withProvide: delegate mtethod when JanrainService returns two step error", ^{
                [googleLoginHandler stub:@selector(startGoogleLoginFrom:completion:) withBlock:^id(NSArray *params) {
                    URGoogleLoginCompletion completion = params[1];
                    completion(@"some-dummy-token", @"som@mail.com", nil);
                    return nil;
                }];
                [JRCapture stub:@selector(startEngageSignInWithNativeProviderToken:withToken:andTokenSecret:mergeToken:withCustomInterfaceOverrides:forDelegate:) withBlock:^id(NSArray *params) {
                    [[params[0] shouldNot] beNil];
                    [[params[1] shouldNot] beNil];
                    id<JRCaptureDelegate> delegate = params[5];
                    JRCaptureError *error = [JRCaptureError errorWithDomain:@"URErrorDomain" code:JRCaptureApidErrorRecordNotFound userInfo:nil];
                    [delegate captureSignInDidFailWithError:error];
                    return nil;
                }];
                id protocolMock = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
                [userHandler addUserRegistrationListener:protocolMock];
                [[protocolMock shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didSocialRegistrationReachedSecoundStepWithUser:withProvide:)];
                [userHandler loginUsingProvider:kProviderNameGoogle];
                [userHandler removeUserRegistrationListener:protocolMock];
            });
            
            it(@"should call handleAccountSocailMergeWithExistingAccountProvider:provider: delegate method when JanrainService returns merge flow error", ^{
                [googleLoginHandler stub:@selector(startGoogleLoginFrom:completion:) withBlock:^id(NSArray *params) {
                    URGoogleLoginCompletion completion = params[1];
                    completion(@"some-dummy-token", @"som@mail.com", nil);
                    return nil;
                }];
                [JRCapture stub:@selector(startEngageSignInWithNativeProviderToken:withToken:andTokenSecret:mergeToken:withCustomInterfaceOverrides:forDelegate:) withBlock:^id(NSArray *params) {
                    [[params[0] shouldNot] beNil];
                    [[params[1] shouldNot] beNil];
                    id<JRCaptureDelegate> delegate = params[5];
                    JRCaptureError *error = [JRCaptureError errorWithDomain:@"URErrorDomain" code:JRCaptureApidErrorEmailAddressInUse userInfo:nil];
                    [delegate captureSignInDidFailWithError:error];
                    return nil;
                }];
                id protocolMock = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
                [userHandler addUserRegistrationListener:protocolMock];
                [[protocolMock shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(handleAccountSocailMergeWithExistingAccountProvider:provider:)];
                [userHandler loginUsingProvider:kProviderNameGoogle];
                [userHandler removeUserRegistrationListener:protocolMock];
            });
            
            it(@"should call didAuthenticationCompleteForLogin: delegate method when JanrainService returns success for provder authentication", ^{
                [googleLoginHandler stub:@selector(startGoogleLoginFrom:completion:) withBlock:^id(NSArray *params) {
                    URGoogleLoginCompletion completion = params[1];
                    completion(@"some-dummy-token", @"som@mail.com", nil);
                    return nil;
                }];
                [JRCapture stub:@selector(startEngageSignInWithNativeProviderToken:withToken:andTokenSecret:mergeToken:withCustomInterfaceOverrides:forDelegate:) withBlock:^id(NSArray *params) {
                    [[params[0] shouldNot] beNil];
                    [[params[1] shouldNot] beNil];
                    id<JRCaptureDelegate> delegate = params[5];
                    [delegate engageAuthenticationDidSucceedForUser:@{@"profile": @{@"email": @"some@mail.com"}} forProvider:kProviderNameGoogle];
                    return nil;
                }];
                
                id protocolMock = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
                [userHandler addUserRegistrationListener:protocolMock];
                [[protocolMock shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didAuthenticationCompleteForLogin:)];
                [userHandler loginUsingProvider:kProviderNameGoogle];
                [userHandler removeUserRegistrationListener:protocolMock];
            });
            
            it(@"should call didLoginWithSuccessWithUser: delegate method when JanrainService returns capture sign in success", ^{
                [googleLoginHandler stub:@selector(startGoogleLoginFrom:completion:) withBlock:^id(NSArray *params) {
                    URGoogleLoginCompletion completion = params[1];
                    completion(@"some-dummy-token", @"som@mail.com", nil);
                    return nil;
                }];
                [JRCapture stub:@selector(startEngageSignInWithNativeProviderToken:withToken:andTokenSecret:mergeToken:withCustomInterfaceOverrides:forDelegate:) withBlock:^id(NSArray *params) {
                    [[params[0] shouldNot] beNil];
                    [[params[1] shouldNot] beNil];
                    id<JRCaptureDelegate> delegate = params[5];
                    JRCaptureUser *user = [KWMock partialMockForObject:[JRCaptureUser new]];
                    [user stub:@selector(replaceVisitedMicroSitesArrayOnCaptureForDelegate:context:)];
                    user.email = @"some@email.com";
                    user.emailVerified = [NSDate date];
                    JRVisitedMicroSitesElement *element = [JRVisitedMicroSitesElement new];
                    element.microSiteID = @"70000";
                    element.timestamp = [NSDate date];
                    user.visitedMicroSites = @[element];
                    [delegate captureSignInDidSucceedForUser:user status:JRCaptureRecordExists];
                    return nil;
                }];
                userHandler.hsdpService = nil;
                id protocolMock = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
                [userHandler addUserRegistrationListener:protocolMock];
                [[protocolMock shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didLoginWithSuccessWithUser:)];
                [userHandler loginUsingProvider:kProviderNameGoogle];
                [userHandler removeUserRegistrationListener:protocolMock];
            });
        });
        
        context(@"if provider is facebook and FBSDK login is available", ^{
            __block FBSDKLoginHandler *fbHandler;
            beforeAll(^{
                [FBSDKLoginHandler stub:@selector(isNativeFBLoginAvailable) andReturn:theValue(true)];
                fbHandler = [KWMock mockForClass:[FBSDKLoginHandler class]];
                userHandler.fbLoginHandler = fbHandler;
                userHandler.janrainService = [[JanrainService alloc] init];
            });
            
            afterAll(^{
                userHandler.janrainService = nil;
            });
            
            it(@"should return didLoginFailedwithError: if FBSDKHandler returns error", ^{
                [fbHandler stub:@selector(startFacebookLoginFrom:completion:) withBlock:^id(NSArray *params) {
                    FBSDKLoginHandlerCompletion completion = params[1];
                    completion(nil, nil, [NSError errorWithDomain:@"URErrorDomain" code:1003 userInfo:nil]);
                    return nil;
                }];
                id protocolMock = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
                [userHandler addUserRegistrationListener:protocolMock];
                [[protocolMock shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didLoginFailedwithError:)];
                [userHandler loginUsingProvider:kProviderNameFacebook];
                [userHandler removeUserRegistrationListener:protocolMock];
            });
            
            it(@"should return didLoginWithSuccessWithUser: if FBSDKHandler returns success and so as JanrainService ", ^{
                [fbHandler stub:@selector(startFacebookLoginFrom:completion:) withBlock:^id(NSArray *params) {
                    FBSDKLoginHandlerCompletion completion = params[1];
                    completion(@"some-dummy-token", @"som@mail.com", nil);
                    return nil;
                }];
                
                [JRCapture stub:@selector(startEngageSignInWithNativeProviderToken:withToken:andTokenSecret:mergeToken:withCustomInterfaceOverrides:forDelegate:) withBlock:^id(NSArray *params) {
                    [[params[0] shouldNot] beNil];
                    [[params[1] shouldNot] beNil];
                    id<JRCaptureDelegate> delegate = params[5];
                    JRCaptureUser *user = [KWMock partialMockForObject:[JRCaptureUser new]];
                    [user stub:@selector(replaceVisitedMicroSitesArrayOnCaptureForDelegate:context:)];
                    [user stub:@selector(replaceRolesArrayOnCaptureForDelegate:context:)];
                    [user stub:@selector(updateOnCaptureForDelegate:context:)];
                    user.email = @"some@email.com";
                    user.emailVerified = [NSDate date];
                    [delegate captureSignInDidSucceedForUser:user status:JRCaptureRecordNewlyCreated];
                    return nil;
                }];
                
                userHandler.hsdpService = nil;
                id protocolMock = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
                [userHandler addUserRegistrationListener:protocolMock];
                [[protocolMock shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didLoginWithSuccessWithUser:)];
                [userHandler loginUsingProvider:kProviderNameFacebook];
                [userHandler removeUserRegistrationListener:protocolMock];
            });
        });
        
        context(@"if provider is facebook and FBSDK is not available", ^{
            beforeAll(^{
                [FBSDKLoginHandler stub:@selector(isNativeFBLoginAvailable) andReturn:theValue(false)];
                userHandler.janrainService = [[JanrainService alloc] init];
            });
            
            afterAll(^{
                userHandler.janrainService = nil;
            });
            
            it(@"should call engage dialog and return error if it fails to show up", ^{
                [JRCapture stub:@selector(startEngageSignInDialogOnProvider:withCustomInterfaceOverrides:mergeToken:forDelegate:) withBlock:^id(NSArray *params) {
                    [[params[0] shouldNot] beNil];
                    [[params[1] shouldNot] beNil];
                    id<JRCaptureDelegate> delegate = params[3];
                    [delegate engageAuthenticationDialogDidFailToShowWithError:[NSError errorWithDomain:@"URErrorDomain" code:1004 userInfo:nil]];
                    return nil;
                }];
                id protocolMock = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
                [userHandler addUserRegistrationListener:protocolMock];
                [[protocolMock shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(socialLoginCannotLaunch:)];
                [userHandler loginUsingProvider:kProviderNameFacebook];
                [userHandler removeUserRegistrationListener:protocolMock];
            });
        });
    });
    
    context(@"when merging social to social", ^{
        __block DIUser *userHandler;
        beforeAll(^{
            userHandler = [DIUser getInstance];
            userHandler.janrainService = [[JanrainService alloc] init];
        });
        
        afterAll(^{
            userHandler.janrainService = nil;
        });
        
        context(@"if provider is facebook but FB SDK is not available", ^{
            beforeAll(^{
                [FBSDKLoginHandler stub:@selector(isNativeFBLoginAvailable) andReturn:theValue(false)];
            });
            it(@"should return error if JR SDK returns error", ^{
                [JRCapture stub:@selector(startEngageSignInDialogOnProvider:withCustomInterfaceOverrides:mergeToken:forDelegate:) withBlock:^id(NSArray *params) {
                    [[params[0] shouldNot] beNil];
                    id<JRCaptureDelegate> delegate = params[3];
                    JRCaptureError *error = [JRCaptureError errorWithDomain:@"URErrorDomain" code:1004 userInfo:nil];
                    [delegate captureSignInDidFailWithError:error];
                    return nil;
                }];
                id protocolMock = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
                [userHandler addUserRegistrationListener:protocolMock];
                [[protocolMock shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didFailHandleMerging:)];
                [userHandler handleMergeRegisterWithProvider:kProviderNameFacebook];
                [userHandler removeUserRegistrationListener:protocolMock];
            });
        });
        
        context(@"if provider is facebook and FBSDK is available", ^{
            __block FBSDKLoginHandler *fbHandler;
            beforeAll(^{
                [FBSDKLoginHandler stub:@selector(isNativeFBLoginAvailable) andReturn:theValue(true)];
                fbHandler = [KWMock mockForClass:[FBSDKLoginHandler class]];
                userHandler.fbLoginHandler = fbHandler;
            });
            
            it(@"should return auth cancelled if FBSDK returns auth cancelled error", ^{
                [fbHandler stub:@selector(startFacebookLoginFrom:completion:) withBlock:^id(NSArray *params) {
                    FBSDKLoginHandlerCompletion completion = params[1];
                    completion(nil, nil, [NSError errorWithDomain:@"URErrorDomain" code:DIRegAuthenticationError userInfo:nil]);
                    return nil;
                }];
                id protocolMock = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
                [userHandler addUserRegistrationListener:protocolMock];
                [[protocolMock shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(socialAuthenticationCanceled)];
                [userHandler handleMergeRegisterWithProvider:kProviderNameFacebook];
                [userHandler removeUserRegistrationListener:protocolMock];
            });
            
            it(@"should return success if FBSDK returns token and email and JR SDK returns success", ^{
                [fbHandler stub:@selector(startFacebookLoginFrom:completion:) withBlock:^id(NSArray *params) {
                    FBSDKLoginHandlerCompletion completion = params[1];
                    completion(@"some-dummy-token", @"some@mail.com", nil);
                    return nil;
                }];
                [JRCapture stub:@selector(startEngageSignInWithNativeProviderToken:withToken:andTokenSecret:mergeToken:withCustomInterfaceOverrides:forDelegate:) withBlock:^id(NSArray *params) {
                    [[params[0] shouldNot] beNil];
                    [[params[0] should] equal:kProviderNameFacebook];
                    [[params[1] shouldNot] beNil];
                    id<JRCaptureDelegate> delegate = params[5];
                    JRCaptureUser *user = [KWMock partialMockForObject:[JRCaptureUser new]];
                    [user stub:@selector(replaceVisitedMicroSitesArrayOnCaptureForDelegate:context:)];
                    [user stub:@selector(replaceRolesArrayOnCaptureForDelegate:context:)];
                    [user stub:@selector(updateOnCaptureForDelegate:context:)];
                    user.email = @"some@email.com";
                    user.emailVerified = [NSDate date];
                    [delegate captureSignInDidSucceedForUser:user status:JRCaptureRecordNewlyCreated];
                    return nil;
                }];
                userHandler.hsdpService = nil;
                id protocolMock = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
                [userHandler addUserRegistrationListener:protocolMock];
                [[protocolMock shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didLoginWithSuccessWithUser:)];
                [userHandler handleMergeRegisterWithProvider:kProviderNameFacebook];
                [userHandler removeUserRegistrationListener:protocolMock];
            });
        });
        
        context(@"if provider is google", ^{
            __block URGoogleLoginHandler *googleHanlder = nil;
            beforeAll(^{
                googleHanlder = [KWMock mockForClass:[URGoogleLoginHandler class]];
                userHandler.googleLoginHandler = googleHanlder;
            });
            
            it(@"should return error if Google handler returns error", ^{
                [googleHanlder stub:@selector(startGoogleLoginFrom:completion:) withBlock:^id(NSArray *params) {
                    URGoogleLoginCompletion completion = params[1];
                    completion(nil, nil, [NSError errorWithDomain:@"URErrorDomain" code:1005 userInfo:nil]);
                    return nil;
                }];
                id protocolMock = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
                [userHandler addUserRegistrationListener:protocolMock];
                [[protocolMock shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didFailHandleMerging:)];
                [userHandler handleMergeRegisterWithProvider:kProviderNameGoogle];
                [userHandler removeUserRegistrationListener:protocolMock];
            });
            
            it(@"should return success if Google handler returns token and JR SDK returns success", ^{
                [googleHanlder stub:@selector(startGoogleLoginFrom:completion:) withBlock:^id(NSArray *params) {
                    URGoogleLoginCompletion completion = params[1];
                    completion(@"some-dummy-token", @"some@mail.com", nil);
                    return nil;
                }];
                [JRCapture stub:@selector(startEngageSignInWithNativeProviderToken:withToken:andTokenSecret:mergeToken:withCustomInterfaceOverrides:forDelegate:) withBlock:^id(NSArray *params) {
                    [[params[0] shouldNot] beNil];
                    [[params[0] should] equal:kProviderNameGoogle];
                    [[params[1] shouldNot] beNil];
                    [[params[1] should] equal:@"some-dummy-token"];
                    id<JRCaptureDelegate> delegate = params[5];
                    JRCaptureUser *user = [KWMock partialMockForObject:[JRCaptureUser new]];
                    [user stub:@selector(replaceVisitedMicroSitesArrayOnCaptureForDelegate:context:)];
                    [user stub:@selector(replaceRolesArrayOnCaptureForDelegate:context:)];
                    [user stub:@selector(updateOnCaptureForDelegate:context:)];
                    user.email = @"some@email.com";
                    user.emailVerified = [NSDate date];
                    [delegate captureSignInDidSucceedForUser:user status:JRCaptureRecordNewlyCreated];
                    return nil;
                }];
                userHandler.hsdpService = nil;
                id protocolMock = [KWMock mockForProtocol:@protocol(UserRegistrationDelegate)];
                [userHandler addUserRegistrationListener:protocolMock];
                [[protocolMock shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(didLoginWithSuccessWithUser:)];
                [userHandler handleMergeRegisterWithProvider:kProviderNameGoogle];
                [userHandler removeUserRegistrationListener:protocolMock];
            });
        });
    });
    
    context(@"user's state while logging in", ^{
        
        afterAll(^{
            [[DIUser getInstance] setValue:nil forKey:@"userProfile"];
        });
        
        it(@"should return user state as not logged in if user janrain config does not exist", ^{
            DIUser *user = [DIUser getInstance];
            [user setValue:nil forKey:@"userProfile"];
            
            [[theValue(user.userLoggedInState) should] equal:theValue(UserLoggedInStateUserNotLoggedIn)];
        });
        
        it(@"should return user state as pending verification when user has not verified mobile number", ^{
            JRCaptureUser *mockUser = [JRCaptureUser mock];
            DIUser *user = [DIUser getInstance];
            [user setValue:mockUser forKey:@"userProfile"];
            [[JRCaptureData sharedCaptureData] setValue:@"asdasdasdas" forKeyPath:@"accessToken"];
            [mockUser stub:@selector(givenName) andReturn:@"Django"];
            [mockUser stub:@selector(familyName) andReturn:@"Unchained"];
            [mockUser stub:@selector(mobileNumber) andReturn:@"Unchained"];
            [mockUser stub:@selector(mobileNumberVerified) andReturn:nil];
            [mockUser stub:@selector(email) andReturn:@"some@mail.com"];
            [mockUser stub:@selector(emailVerified) andReturn:nil];
            [mockUser stub:@selector(uuid) andReturn:@"Unchained"];

            [[theValue(user.userLoggedInState) shouldNot] equal:theValue(UserLoggedInStateUserNotLoggedIn)];
            [[theValue(user.userLoggedInState) should] equal:theValue(UserLoggedInStatePendingVerification)];
        });
        
        it(@"should return user state as pending verification when user has not verified email", ^{
            JRCaptureUser *mockUser = [JRCaptureUser mock];
            DIUser *user = [DIUser getInstance];
            [user setValue:mockUser forKey:@"userProfile"];
            [[JRCaptureData sharedCaptureData] setValue:@"ccascasc" forKeyPath:@"accessToken"];
            [mockUser stub:@selector(givenName) andReturn:@"Django"];
            [mockUser stub:@selector(familyName) andReturn:@"Unchained"];
            [mockUser stub:@selector(mobileNumber) andReturn:nil];
            [mockUser stub:@selector(mobileNumberVerified) andReturn:nil];
            [mockUser stub:@selector(email) andReturn:@"some@mail.com"];
            [mockUser stub:@selector(uuid) andReturn:@"sadasdas"];
            [mockUser stub:@selector(emailVerified) andReturn:nil];
            
            [[theValue(user.userLoggedInState) shouldNot] equal:theValue(UserLoggedInStateUserNotLoggedIn)];
            [[theValue(user.userLoggedInState) should] equal:theValue(UserLoggedInStatePendingVerification)];
        });
        
        it(@"should return user state as pending T&C when user has not accepted terms and conditions", ^{
            JRCaptureUser *mockUser = [JRCaptureUser mock];
            DIUser *user = [DIUser getInstance];
            [user setValue:mockUser forKey:@"userProfile"];
            [[JRCaptureData sharedCaptureData] setValue:@"ccascasc" forKeyPath:@"accessToken"];
            [mockUser stub:@selector(givenName) andReturn:@"Django"];
            [mockUser stub:@selector(familyName) andReturn:@"Unchained"];
            [mockUser stub:@selector(mobileNumber) andReturn:nil];
            [mockUser stub:@selector(email) andReturn:nil];
            [mockUser stub:@selector(uuid) andReturn:@"asdadas"];

            NSLocale* currentLocale = [NSLocale currentLocale];
            [mockUser stub:@selector(mobileNumberVerified) andReturn:[[NSDate date] descriptionWithLocale:currentLocale]];
            [mockUser stub:@selector(userIdentifier) andReturn:@"dummyUser"];
            [RegistrationUtility stub:@selector(hasUserAcceptedTermsnConditions:) andReturn:theValue(NO)];
            
            [[theValue(user.userLoggedInState) shouldNot] equal:theValue(UserLoggedInStateUserNotLoggedIn)];
            [[theValue(user.userLoggedInState) shouldNot] equal:theValue(UserLoggedInStatePendingVerification)];
            [[theValue(user.userLoggedInState) should] equal:theValue(UserLoggedInStatePendingTnC)];
        });
        
        it(@"should return user state as pending HSDPLogin when HSDP is not configured", ^{
            JRCaptureUser *mockUser = [JRCaptureUser mock];
            DIUser *user = [DIUser getInstance];
            [user setValue:mockUser forKey:@"userProfile"];
            [[JRCaptureData sharedCaptureData] setValue:@"ccascasc" forKeyPath:@"accessToken"];

            [mockUser stub:@selector(givenName) andReturn:@"Django"];
            [mockUser stub:@selector(familyName) andReturn:@"Unchained"];
            [mockUser stub:@selector(mobileNumber) andReturn:nil];
            [mockUser stub:@selector(email) andReturn:nil];
            [mockUser stub:@selector(uuid) andReturn:@"dadsada"];

            NSLocale* currentLocale = [NSLocale currentLocale];
            [mockUser stub:@selector(mobileNumberVerified) andReturn:[[NSDate date] descriptionWithLocale:currentLocale]];
            [mockUser stub:@selector(userIdentifier) andReturn:@"dummyUser"];
            [RegistrationUtility stub:@selector(hasUserAcceptedTermsnConditions:) andReturn:theValue(YES)];
            
            [[theValue(user.userLoggedInState) shouldNot] equal:theValue(UserLoggedInStateUserNotLoggedIn)];
            [[theValue(user.userLoggedInState) shouldNot] equal:theValue(UserLoggedInStatePendingVerification)];
            [[theValue(user.userLoggedInState) shouldNot] equal:theValue(UserLoggedInStatePendingTnC)];
            [[theValue(user.userLoggedInState) should] equal:theValue(UserLoggedInStatePendingHSDPLogin)];
        });
        
        it(@"should return user state as user logged in", ^{
            JRCaptureUser *mockUser = [JRCaptureUser mock];
            DIUser *user = [DIUser getInstance];
            [user setValue:mockUser forKey:@"userProfile"];
            [[JRCaptureData sharedCaptureData] setValue:@"ccascasc" forKeyPath:@"accessToken"];
            [mockUser stub:@selector(givenName) andReturn:@"Django"];
            [mockUser stub:@selector(familyName) andReturn:@"Unchained"];
            [mockUser stub:@selector(mobileNumber) andReturn:nil];
            [mockUser stub:@selector(email) andReturn:nil];
            [mockUser stub:@selector(emailVerified) andReturn:nil];
            [mockUser stub:@selector(uuid) andReturn:@"sadasdas"];

            NSLocale* currentLocale = [NSLocale currentLocale];
            [mockUser stub:@selector(mobileNumberVerified) andReturn:[[NSDate date] descriptionWithLocale:currentLocale]];
            [mockUser stub:@selector(userIdentifier) andReturn:@"dummyUser"];
            [RegistrationUtility stub:@selector(hasUserAcceptedTermsnConditions:) andReturn:theValue(YES)];
            [HSDPService stub:@selector(isHSDPConfigurationAvailableForCountry:) andReturn:theValue(NO)];
            
            [[theValue(user.userLoggedInState) shouldNot] equal:theValue(UserLoggedInStateUserNotLoggedIn)];
            [[theValue(user.userLoggedInState) shouldNot] equal:theValue(UserLoggedInStatePendingVerification)];
            [[theValue(user.userLoggedInState) shouldNot] equal:theValue(UserLoggedInStatePendingTnC)];
            [[theValue(user.userLoggedInState) shouldNot] equal:theValue(UserLoggedInStatePendingHSDPLogin)];
            [[theValue(user.userLoggedInState) should] equal:theValue(UserLoggedInStateUserLoggedIn)];
        });
    });
    
    context(@"HSDP login states", ^{
        
        afterAll(^{
            [[DIUser getInstance] setValue:nil forKey:@"userProfile"];
        });
        
        it(@"should return HSDP state as janrain not logged in", ^{
            DIUser *user = [DIUser getInstance];
            [user setValue:nil forKey:@"userProfile"];
            
            [user authorizeWithHSDPWithCompletion:^(BOOL success, NSError * _Nullable error) {
                [[error shouldNot] beNil];
                [[theValue(error.code) should] equal:theValue(44)];
            }];
        });
        
        it(@"should return HSDP state as not configured for country", ^{
            JRCaptureUser *mockUser = [JRCaptureUser mock];
            DIUser *user = [DIUser getInstance];
            [user setValue:mockUser forKey:@"userProfile"];
            [[JRCaptureData sharedCaptureData] setValue:@"ccascasc" forKeyPath:@"accessToken"];

            [mockUser stub:@selector(givenName) andReturn:@"Django"];
            [mockUser stub:@selector(familyName) andReturn:@"Unchained"];
            [mockUser stub:@selector(mobileNumber) andReturn:(@"9876543210")];
            [mockUser stub:@selector(mobileNumberVerified) andReturn:nil];
            [mockUser stub:@selector(uuid) andReturn:@"asdasdsad"];

            [HSDPService stub:@selector(isHSDPConfigurationAvailableForCountry:) andReturn:theValue(NO)];
            
            [user authorizeWithHSDPWithCompletion:^(BOOL success, NSError * _Nullable error) {
                [[error shouldNot] beNil];
                [[theValue(error.code) should] equal:theValue(45)];
            }];
        });
        
        it(@"should return HSDP state as already signed in", ^{
            JRCaptureUser *mockUser = [JRCaptureUser mock];
            DIUser *user = [DIUser getInstance];
            HSDPUser *hsdpUserMock = [HSDPUser mock];
            [user setValue:mockUser forKey:@"userProfile"];
            id hsdpUserDefault = user.hsdpUser;
            [[JRCaptureData sharedCaptureData] setValue:@"ccascasc" forKeyPath:@"accessToken"];
            [mockUser stub:@selector(givenName) andReturn:@"Django"];
            [mockUser stub:@selector(familyName) andReturn:@"Unchained"];
            [mockUser stub:@selector(mobileNumber) andReturn:(@"9876543210")];
            [mockUser stub:@selector(mobileNumberVerified) andReturn:nil];
            [HSDPService stub:@selector(isHSDPConfigurationAvailableForCountry:) andReturn:theValue(YES)];
            [hsdpUserMock stub:@selector(userUUID) andReturn:@"dummyUUID"];
            user.hsdpUser = hsdpUserMock;
            [hsdpUserMock stub:@selector(isSignedIn) andReturn:theValue(YES)];
            [mockUser stub:@selector(uuid) andReturn:@"asdasdsad"];

            [user authorizeWithHSDPWithCompletion:^(BOOL success, NSError * _Nullable error) {
                [[error shouldNot] beNil];
                [[theValue(error.code) should] equal:theValue(46)];
            }];
            user.hsdpUser = hsdpUserDefault;
        });
        
        it(@"should return HSDP authorization success if HSDP state is not signed in", ^{
            JRCaptureUser *mockUser = [JRCaptureUser mock];
            DIUser *user = [DIUser getInstance];
            HSDPUser *hsdpUserMock = [HSDPUser mock];
            [user setValue:mockUser forKey:@"userProfile"];
            [[JRCaptureData sharedCaptureData] setValue:@"ccascasc" forKeyPath:@"accessToken"];

            [mockUser stub:@selector(givenName) andReturn:@"Django"];
            [mockUser stub:@selector(familyName) andReturn:@"Unchained"];
            [mockUser stub:@selector(mobileNumber) andReturn:(@"9876543210")];
            [mockUser stub:@selector(mobileNumberVerified) andReturn:nil];
            [mockUser stub:@selector(uuid) andReturn:@"asddasd"];

            [HSDPService stub:@selector(isHSDPConfigurationAvailableForCountry:) andReturn:theValue(YES)];
            [hsdpUserMock stub:@selector(isSignedIn) andReturn:theValue(NO)];
            
            HSDPService *mockedHSDPService = [HSDPService mock];
            [user setValue:mockedHSDPService forKeyPath:@"hsdpService"];
            [user stub:@selector(hsdpUserIdentifier) andReturn:@"abc.xyz@mail.com"];
            
            [mockedHSDPService stub:@selector(loginWithSocialUsingEmail:accessToken:refreshSecret:completion:) withBlock:^id(NSArray *params) {
                HSDPServiceCompletionHandler completionHandler = params[3];
                HSDPUser *hsdpUser = [HSDPUser new];
                completionHandler(hsdpUser, nil);
                return nil;
            }];
            
            [user authorizeWithHSDPWithCompletion:^(BOOL success, NSError * _Nullable error) {
                [[error should] beNil];
            }];
        });
        
        it(@"should return HSDP authorization failure if error exists", ^{
            JRCaptureUser *mockUser = [JRCaptureUser mock];
            DIUser *user = [DIUser getInstance];
            HSDPUser *hsdpUserMock = [HSDPUser mock];
            [user setValue:mockUser forKey:@"userProfile"];
            [[JRCaptureData sharedCaptureData] setValue:@"ccascasc" forKeyPath:@"accessToken"];

            [mockUser stub:@selector(givenName) andReturn:@"Django"];
            [mockUser stub:@selector(familyName) andReturn:@"Unchained"];
            [mockUser stub:@selector(mobileNumber) andReturn:(@"9876543210")];
            [mockUser stub:@selector(mobileNumberVerified) andReturn:nil];
            [mockUser stub:@selector(uuid) andReturn:@"sadasd"];

            [HSDPService stub:@selector(isHSDPConfigurationAvailableForCountry:) andReturn:theValue(YES)];
            [hsdpUserMock stub:@selector(userUUID) andReturn:@"dummyUUID"];
            [hsdpUserMock stub:@selector(isSignedIn) andReturn:theValue(NO)];
            
            HSDPService *mockedHSDPService = [HSDPService mock];
            [user setValue:mockedHSDPService forKeyPath:@"hsdpService"];
            [user stub:@selector(hsdpUserIdentifier) andReturn:@"abc.xyz@mail.com"];
            
            [mockedHSDPService stub:@selector(loginWithSocialUsingEmail:accessToken:refreshSecret:completion:) withBlock:^id(NSArray *params) {
                HSDPServiceCompletionHandler completionHandler = params[3];
                completionHandler(nil, [NSError errorWithDomain:@"Dummy Error Domain" code:3008 userInfo:nil]);
                return nil;
            }];
            
            [user authorizeWithHSDPWithCompletion:^(BOOL success, NSError * _Nullable error) {
                [[error shouldNot] beNil];
            }];
        });        
    });
});

SPEC_END
