//
//  DIHSDPServiceTests.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 29/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

@import AppInfra;
#import "DIRegistrationConstants.h"
#import "URSettingsWrapper.h"
#import "HSDPService.h"
#import "DIHSDPConfiguration.h"
#import "DIHTTPUtility.h"
#import "HSDPUserTestsHelper.h"
#import "Kiwi.h"
#import "URRSAEncryptor.h"
#import "URRSADecryptorMock.h"
#import "DIConstants.h"
#import "RegistrationAnalyticsConstants.h"


SPEC_BEGIN(HSDPServiceSpec)

describe(@"HSDPService", ^{
    
    __block HSDPService *hsdpService;
    
    beforeAll(^{
        AIAppInfra *appInfra = [[AIAppInfra alloc] initWithBuilder:nil];
        URDependencies *dependencies = [[URDependencies alloc] init];
        dependencies.appInfra = appInfra;
        [URSettingsWrapper sharedInstance].dependencies = dependencies;
        NSError *error;
        [appInfra.appConfig setPropertyForKey:HSDPConfiguration_ApplicationName group:@"UserRegistration" value:@"CDP" error:&error];
        [appInfra.appConfig setPropertyForKey:HSDPConfiguration_Shared group:@"UserRegistration"
                                        value:@"fe53a854-f9b0-11e6-bc64-92361f002671" error:&error];
        [appInfra.appConfig setPropertyForKey:HSDPConfiguration_Secret group:@"UserRegistration"
                                        value:@"057b97e0-f9b1-11e6-bc64-92361f002671" error:&error];
        [appInfra.appConfig setPropertyForKey:HSDPConfiguration_BaseURL group:@"UserRegistration"
                                        value:@"https://user-registration-assembly-hsdpchinadev.cn1.philips-healthsuite.com.cn" error:&error];
        hsdpService = [[HSDPService alloc] initWithCountryCode:@"IN" baseURL:nil];
    });
    
    afterAll(^{
        [URSettingsWrapper sharedInstance].dependencies = nil;
        hsdpService = nil;
    });
    
    context(@"method isHSDPConfigurationAvailableForCountry:", ^{
        
        it(@"should return YES if YES is returned by HSDPConfiguration", ^{
            __unused id hsdpConfigurationMock = [KWMock mockForClass:[DIHSDPConfiguration class]];
            [[DIHSDPConfiguration should] receive:@selector(isHSDPConfigurationAvailableForCountry:) andReturn:theValue(YES)];
            [[theValue([HSDPService isHSDPConfigurationAvailableForCountry:nil]) should] equal:theValue(YES)];
        });
        
        
        it(@"should return NO if NO is returned by HSDPConfiguration", ^{
            __unused id hsdpConfigurationMock = [KWMock mockForClass:[DIHSDPConfiguration class]];
            [[DIHSDPConfiguration should] receive:@selector(isHSDPConfigurationAvailableForCountry:) andReturn:theValue(NO)];
            [[theValue([HSDPService isHSDPConfigurationAvailableForCountry:nil]) should] equal:theValue(NO)];
        });
    });
    
    
    context(@"method loginWithSocialUsingEmail:accessToken:refreshSecret:completion:", ^{
        
        it(@"should return error if email is not provided", ^{
            [hsdpService loginWithSocialUsingEmail:nil accessToken:@"someDummyvalue" refreshSecret:@"someDummy-Value" completion:^(HSDPUser *user, NSError *error) {
                [[user should] beNil];
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should return error if refreshSecret is not provided", ^{
            [hsdpService loginWithSocialUsingEmail:@"dummy@mail.com" accessToken:@"someDummyToken" refreshSecret:nil completion:^(HSDPUser *user, NSError *error) {
                [[user should] beNil];
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should return error if token is not provided", ^{
            [hsdpService loginWithSocialUsingEmail:@"dummy@mail.com" accessToken:nil refreshSecret:@"someDummy-Value" completion:^(HSDPUser *user, NSError *error) {
                [[user should] beNil];
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should return error if DIHTTPUtility failed to get data", ^{
            id httpUtlityMock = [DIHTTPUtility mock];
            [[httpUtlityMock should] receive:@selector(startURLConnectionWithRequest:completionHandler:)];
            KWCaptureSpy *spy = [httpUtlityMock captureArgument:@selector(startURLConnectionWithRequest:completionHandler:) atIndex:1];
            
            [hsdpService setValue:httpUtlityMock forKeyPath:@"httpUtility"];
            __block NSError *receivedError;
            [hsdpService loginWithSocialUsingEmail:@"dummy@mail.com" accessToken:@"someDummyToken" refreshSecret:@"someDummySecret" completion:^(HSDPUser *user, NSError *error) {
                [[user should] beNil];
                receivedError = error;
            }];
            DIHTTPConnectionCompletionHandler handler = spy.argument;
            handler(nil, nil, [NSError errorWithDomain:@"dummyDomain" code:1006 userInfo:nil]);
            [[receivedError shouldNotEventuallyBeforeTimingOutAfter(2.0)] beNil];
        });
        
        
        it(@"should return error if malformed JSON is received from server", ^{
            id httpUtlityMock = [DIHTTPUtility mock];
            [[httpUtlityMock should] receive:@selector(startURLConnectionWithRequest:completionHandler:)];
            KWCaptureSpy *spy = [httpUtlityMock captureArgument:@selector(startURLConnectionWithRequest:completionHandler:) atIndex:1];
            
            [hsdpService setValue:httpUtlityMock forKeyPath:@"httpUtility"];
            __block NSError *receivedError;
            [hsdpService loginWithSocialUsingEmail:@"dummy@mail.com" accessToken:@"someDummyToken" refreshSecret:@"someDummySecret" completion:^(HSDPUser *user, NSError *error) {
                [[user should] beNil];
                receivedError = error;
            }];
            DIHTTPConnectionCompletionHandler handler = spy.argument;
            handler(nil, [@"someDummyString" dataUsingEncoding:NSUTF8StringEncoding], nil);
            [[receivedError shouldNotEventuallyBeforeTimingOutAfter(2.0)] beNil];
        });
        
        
        it(@"should return correct HSDPUser instance if correct data is received from server", ^{
            id httpUtlityMock = [DIHTTPUtility mock];
            [[httpUtlityMock should] receive:@selector(startURLConnectionWithRequest:completionHandler:)];
            KWCaptureSpy *spy = [httpUtlityMock captureArgument:@selector(startURLConnectionWithRequest:completionHandler:) atIndex:1];
            
            [hsdpService setValue:httpUtlityMock forKeyPath:@"httpUtility"];
            __block HSDPUser *receivedUser;
            [hsdpService loginWithSocialUsingEmail:@"dummy@mail.com" accessToken:@"someDummyToken" refreshSecret:@"someDummySecret" completion:^(HSDPUser *user, NSError *error) {
                [[error should] beNil];
                receivedUser = user;
                [[user.userUUID shouldNot] beNil];
                [[user.accessToken shouldNot] beNil];
                [[user.refreshToken shouldNot] beNil];
                [[user.refreshSecret shouldNot] beNil];
            }];
            DIHTTPConnectionCompletionHandler handler = spy.argument;
            NSData *returnData = [NSJSONSerialization dataWithJSONObject:[HSDPUserTestsHelper mockJsonResponse] options:kNilOptions error:nil];
            handler(nil, returnData, nil);
            [[receivedUser shouldNotEventuallyBeforeTimingOutAfter(2.0)] beNil];
        });
        
        it(@"should call tagging if HSDP UUID upload configuration is set to true", ^{
            id httpUtlityMock = [DIHTTPUtility mock];
            KWCaptureSpy *spy = [httpUtlityMock captureArgument:@selector(startURLConnectionWithRequest:completionHandler:) atIndex:1];
            [hsdpService setValue:httpUtlityMock forKeyPath:@"httpUtility"];
            id appTaggingMock = [KWMock mockForProtocol:@protocol(AIAppTaggingProtocol)];
            URSettingsWrapper.sharedInstance.appTagging = appTaggingMock;
            [URSettingsWrapper.sharedInstance.dependencies.appInfra.appConfig setPropertyForKey:HSDPUUIDUpload group:@"UserRegistration" value:[NSNumber numberWithBool:YES] error:nil];
            [[appTaggingMock should] receive:@selector(trackActionWithInfo:params:)];
            NSString *hsdpUUID = @"some-dummy-uuid-1223-456";
            [appTaggingMock stub:@selector(trackActionWithInfo:params:) withBlock:^id(NSArray *params) {
                [[params[0] should] equal:kRegSendData];
                NSDictionary *lDict = params[1];
                [[lDict shouldNot] beNil];
                [[lDict[kRegistrationUuidKey] shouldNot] beNil];
                NSString *decryptedUUID = [URRSADecryptorMock decryptString:lDict[kRegistrationUuidKey] withPrivateKey:kHSDPSecurePrivateKey];
                [[decryptedUUID should] equal:hsdpUUID];
                return nil;
            }];
            [hsdpService loginWithSocialUsingEmail:@"dummy@mail.com" accessToken:@"someDummyToken" refreshSecret:@"someDummySecret" completion:^(HSDPUser *user, NSError *error) {
                [[error should] beNil];
            }];
            
            DIHTTPConnectionCompletionHandler handler = spy.argument;
            NSDictionary *responseDict = @{@"exchange": @{@"user": @{@"userUUID": hsdpUUID}},
                                           @"responseCode": @"200"
                                           };
            NSData *returnData = [NSJSONSerialization dataWithJSONObject:responseDict options:kNilOptions error:nil];
            handler(nil, returnData, nil);
        });
        
        it(@"should not call tagging if HSDP UUID upload configuration is set to false", ^{
            id httpUtlityMock = [DIHTTPUtility mock];
            KWCaptureSpy *spy = [httpUtlityMock captureArgument:@selector(startURLConnectionWithRequest:completionHandler:) atIndex:1];
            [hsdpService setValue:httpUtlityMock forKeyPath:@"httpUtility"];
            id appTaggingMock = [KWMock mockForProtocol:@protocol(AIAppTaggingProtocol)];
            URSettingsWrapper.sharedInstance.appTagging = appTaggingMock;
            [URSettingsWrapper.sharedInstance.dependencies.appInfra.appConfig setPropertyForKey:HSDPUUIDUpload group:@"UserRegistration" value:[NSNumber numberWithBool:NO] error:nil];
            [[appTaggingMock shouldNot] receive:@selector(trackActionWithInfo:params:)];
            
            [hsdpService loginWithSocialUsingEmail:@"dummy@mail.com" accessToken:@"someDummyToken" refreshSecret:@"someDummySecret" completion:^(HSDPUser *user, NSError *error) {
                [[error should] beNil];
            }];
            
            DIHTTPConnectionCompletionHandler handler = spy.argument;
            NSData *returnData = [NSJSONSerialization dataWithJSONObject:[HSDPUserTestsHelper mockJsonResponse] options:kNilOptions error:nil];
            handler(nil, returnData, nil);
        });
    });
    
    
    context(@"method refreshSessionForUUID:accessToken:refreshSecret:completion:", ^{
        
        it(@"should return error if UUID is not provided", ^{
            [hsdpService refreshSessionForUUID:nil accessToken:@"someDummyValue" refreshSecret:@"anotherDummyValue" completion:^(HSDPUser *user, NSError *error) {
                [[user should] beNil];
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should return error if accessToken is not provided", ^{
            [hsdpService refreshSessionForUUID:@"someDummyUUID" accessToken:nil refreshSecret:@"anotherDummyValue" completion:^(HSDPUser *user, NSError *error) {
                [[user should] beNil];
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should return error if refreshSecret is not provided", ^{
            [hsdpService refreshSessionForUUID:@"someDummyUUID" accessToken:@"someDummyValue" refreshSecret:nil completion:^(HSDPUser *user, NSError *error) {
                [[user should] beNil];
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should return error if DIHTTPUtility failed to get data", ^{
            id httpUtlityMock = [DIHTTPUtility mock];
            [[httpUtlityMock should] receive:@selector(startURLConnectionWithRequest:completionHandler:)];
            KWCaptureSpy *spy = [httpUtlityMock captureArgument:@selector(startURLConnectionWithRequest:completionHandler:) atIndex:1];
            
            [hsdpService setValue:httpUtlityMock forKeyPath:@"httpUtility"];
            __block NSError *receivedError;
            [hsdpService refreshSessionForUUID:@"someDummyUUID" accessToken:@"someDummyValue" refreshSecret:@"anotherDummyValue" completion:^(HSDPUser *user, NSError *error) {
                [[user should] beNil];
                receivedError = error;
            }];
            DIHTTPConnectionCompletionHandler handler = spy.argument;
            handler(nil, nil, [NSError errorWithDomain:@"dummyDomain" code:1007 userInfo:nil]);
            [[receivedError shouldNotEventuallyBeforeTimingOutAfter(2.0)] beNil];
        });
        
        it(@"should return error if malformed JSON is received from server", ^{
            id httpUtlityMock = [DIHTTPUtility mock];
            [[httpUtlityMock should] receive:@selector(startURLConnectionWithRequest:completionHandler:)];
            KWCaptureSpy *spy = [httpUtlityMock captureArgument:@selector(startURLConnectionWithRequest:completionHandler:) atIndex:1];
            
            [hsdpService setValue:httpUtlityMock forKeyPath:@"httpUtility"];
            __block NSError *receivedError;
            [hsdpService refreshSessionForUUID:@"someDummyUUID" accessToken:@"someDummyValue" refreshSecret:@"anotherDummyValue" completion:^(HSDPUser *user, NSError *error) {
                [[user should] beNil];
                receivedError = error;
            }];
            DIHTTPConnectionCompletionHandler handler = spy.argument;
            handler(nil, [@"someDummyString" dataUsingEncoding:NSUTF8StringEncoding], nil);
            [[receivedError shouldNotEventuallyBeforeTimingOutAfter(2.0)] beNil];
        });
        
        it(@"should return correct HSDPUser instance if correct data is received from server", ^{
            id httpUtlityMock = [DIHTTPUtility mock];
            [[httpUtlityMock should] receive:@selector(startURLConnectionWithRequest:completionHandler:)];
            KWCaptureSpy *spy = [httpUtlityMock captureArgument:@selector(startURLConnectionWithRequest:completionHandler:) atIndex:1];
            
            [hsdpService setValue:httpUtlityMock forKeyPath:@"httpUtility"];
            __block HSDPUser *receivedUser;
            [hsdpService refreshSessionForUUID:@"someDummyUUID" accessToken:@"someDummyValue" refreshSecret:@"anotherDummyValue" completion:^(HSDPUser *user, NSError *error) {
                [[error should] beNil];
                receivedUser = user;
                [[user.accessToken shouldNot] beNil];
                [[user.userUUID shouldNot] beNil];
                [[user.refreshSecret shouldNot] beNil];
                [[user.refreshToken should] beNil];
            }];
            DIHTTPConnectionCompletionHandler handler = spy.argument;
            NSData *returnData = [NSJSONSerialization dataWithJSONObject:[HSDPUserTestsHelper mockRefreshSecretDictionary] options:kNilOptions error:nil];
            handler(nil, returnData, nil);
            [[receivedUser shouldNotEventuallyBeforeTimingOutAfter(2.0)] beNil];
        });
    });
    
    
    context(@"method refreshSessionForUUID:refreshToken:completion:", ^{
        
        it(@"should return error if UUID is not provided", ^{
            [hsdpService refreshSessionForUUID:nil refreshToken:@"someDummyValue" completion:^(HSDPUser *user, NSError *error) {
                [[user should] beNil];
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should return error if refreshToken is not provided", ^{
            [hsdpService refreshSessionForUUID:@"someDummyUUID" refreshToken:nil completion:^(HSDPUser *user, NSError *error) {
                [[user should] beNil];
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should return error if DIHTTPUtility failed to get data", ^{
            id httpUtlityMock = [DIHTTPUtility mock];
            [[httpUtlityMock should] receive:@selector(startURLConnectionWithRequest:completionHandler:)];
            KWCaptureSpy *spy = [httpUtlityMock captureArgument:@selector(startURLConnectionWithRequest:completionHandler:) atIndex:1];
            
            [hsdpService setValue:httpUtlityMock forKeyPath:@"httpUtility"];
            __block NSError *receivedError;
            [hsdpService refreshSessionForUUID:@"someDummyUUID" refreshToken:@"someDummyValue" completion:^(HSDPUser *user, NSError *error) {
                [[user should] beNil];
                receivedError = error;
            }];
            DIHTTPConnectionCompletionHandler handler = spy.argument;
            handler(nil, nil, [NSError errorWithDomain:@"dummyDomain" code:1008 userInfo:nil]);
            [[receivedError shouldNotEventuallyBeforeTimingOutAfter(2.0)] beNil];
        });
        
        it(@"should return correct HSDPUser instance if correct data is received from server", ^{
            id httpUtlityMock = [DIHTTPUtility mock];
            [[httpUtlityMock should] receive:@selector(startURLConnectionWithRequest:completionHandler:)];
            KWCaptureSpy *spy = [httpUtlityMock captureArgument:@selector(startURLConnectionWithRequest:completionHandler:) atIndex:1];
            
            [hsdpService setValue:httpUtlityMock forKeyPath:@"httpUtility"];
            __block HSDPUser *receivedUser;
            [hsdpService refreshSessionForUUID:@"someDummyUUID" refreshToken:@"someDummyValue" completion:^(HSDPUser *user, NSError *error) {
                [[error should] beNil];
                receivedUser = user;
                [[user.userUUID shouldNot] beNil];
                [[user.accessToken shouldNot] beNil];
                [[user.refreshToken shouldNot] beNil];
                [[user.refreshSecret should] beNil];
            }];
            DIHTTPConnectionCompletionHandler handler = spy.argument;
            NSData *returnData = [NSJSONSerialization dataWithJSONObject:[HSDPUserTestsHelper mockTokenDictionary] options:kNilOptions error:nil];
            handler(nil, returnData, nil);
            [[receivedUser shouldNotEventuallyBeforeTimingOutAfter(2.0)] beNil];
        });
    });
    
    
    context(@"method logoutUserWithUUID:accessToken:completion:", ^{
        
        it(@"should return error if UUID is not provided", ^{
            [hsdpService logoutUserWithUUID:nil accessToken:@"someDummyValue" completion:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should return error if accessToken is not provided", ^{
            [hsdpService logoutUserWithUUID:@"someDummyUUID" accessToken:nil completion:^(NSError *error) {
                [[error shouldNot] beNil];
            }];
        });
        
        it(@"should return error if server returns error", ^{
            id httpUtlityMock = [DIHTTPUtility mock];
            [[httpUtlityMock should] receive:@selector(startURLConnectionWithRequest:completionHandler:)];
            KWCaptureSpy *spy = [httpUtlityMock captureArgument:@selector(startURLConnectionWithRequest:completionHandler:) atIndex:1];
            
            [hsdpService setValue:httpUtlityMock forKeyPath:@"httpUtility"];
            __block NSError *receivedError;
            [hsdpService logoutUserWithUUID:@"someDummyUUID" accessToken:@"someDummyValue" completion:^(NSError *error) {
                receivedError = error;
            }];
            DIHTTPConnectionCompletionHandler handler = spy.argument;
            handler(nil, nil, [NSError errorWithDomain:@"dummyDomain" code:1009 userInfo:nil]);
            [[receivedError shouldNotEventuallyBeforeTimingOutAfter(2.0)] beNil];
        });
        
        it(@"should return success if user is logged out successfully on server", ^{
            id httpUtlityMock = [DIHTTPUtility mock];
            [[httpUtlityMock should] receive:@selector(startURLConnectionWithRequest:completionHandler:)];
            KWCaptureSpy *spy = [httpUtlityMock captureArgument:@selector(startURLConnectionWithRequest:completionHandler:) atIndex:1];
            
            [hsdpService setValue:httpUtlityMock forKeyPath:@"httpUtility"];
            __block NSError *receivedError = [NSError errorWithDomain:@"dummyDomain" code:1010 userInfo:nil];
            [hsdpService logoutUserWithUUID:@"someDummyUUID" accessToken:@"someDummyValue" completion:^(NSError *error) {
                receivedError = error;
            }];
            NSDictionary *responseDict = @{@"responseCode" : @"200",
                                           @"responseMessage" : @"Success"};
            NSData *responseData = [NSJSONSerialization dataWithJSONObject:responseDict options:kNilOptions error:nil];
            DIHTTPConnectionCompletionHandler handler = spy.argument;
            handler(nil, responseData, nil);
            [[receivedError shouldEventuallyBeforeTimingOutAfter(2.0)] beNil];
        });
    });
});

SPEC_END
