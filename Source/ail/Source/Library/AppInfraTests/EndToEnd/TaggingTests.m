//
//  TaggingTests.m
//  AppInfraTests
//
//  Created by leslie on 10/11/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppInfra.h"
#import "NSBundle+Bundle.h"
#import "OCMock/OCMock.h"
#import "AIAppConfiguration.h"
#import <AdobeMobileSDK/ADBMobile.h>
#import "AIAppTagging.h"

@import AppInfra;
@interface AIAppConfiguration()

@property(nonatomic,strong)NSDictionary *staticConfiguration;

@end

@interface TaggingTests : XCTestCase

@property(nonatomic, strong)AIAppInfra * appinfra;

@end

static NSString *const adbTaggingStatusKey = @"ail_adb_status";

@implementation TaggingTests
+ (id) sharedAppInfra {
    static dispatch_once_t time = 0;
    static AIAppInfra *_sharedObject = nil;
    dispatch_once(&time, ^{
        [ADBMobile overrideConfigPath:[[NSBundle bundleForClass:self.class] pathForResource:@"ADBMobileConfig" ofType:@"json"]];
        _sharedObject = [AIAppInfra buildAppInfraWithBlock:nil];
    });
    return _sharedObject;
}

- (void)setUp {
    [super setUp];
    [NSBundle loadSwizzler];
    self.appinfra = [TaggingTests sharedAppInfra];
    AIAppTagging *objAppTagging = [self.appinfra.tagging createInstanceForComponent:@"testComponent" componentVersion:@"test.0.1"];
    self.appinfra.tagging = objAppTagging;
}

- (void)tearDown {
    [super tearDown];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:adbTaggingStatusKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

//Test Case 13172:HF-Verify for the Bundle ID when App State is Develoment
-(void)test13172 {
    [self.appinfra.tagging setPrivacyConsentForSensitiveData:YES];
    [self.appinfra.tagging setPrivacyConsent:AIATPrivacyStatusOptIn];
    id mock = OCMClassMock([ADBMobile class]);
    NSString * appState = [(AIAppIdentityInterface*)self.appinfra.appIdentity getAppStateString];
    OCMStub([mock trackingIdentifier]).andReturn(@"AdobeIDForUnitTesting");
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        __weak NSDictionary * dict;
        [invocation getArgument:&dict atIndex:3];
        [invocation retainArguments];
        XCTAssertEqualObjects(dict[@"bundleId"], appState);
    }]trackState:OCMOCK_ANY data:OCMOCK_ANY];
    [self.appinfra.tagging trackPageWithInfo:@"test" params:@{@"test":@"value"}];
    [mock verify];
}


//Test Case 13181:HF-Verify that app Infra Tagging has a config item ('appinfra'/'tagging.sensitivedata') able to filter from tag requests going to the cloud server
-(void)test13172Case1 {
    //precondition
    AIAppConfiguration * config = (AIAppConfiguration *)self.appinfra.appConfig;
    NSMutableDictionary * dict = config.staticConfiguration[@"APPINFRA"];
    dict[@"TAGGING.SENSITIVEDATA"] = @[@"appsId",@"UTCtimestamp",@"localTimeStamp",@"bundleId",@"language"];

    [self.appinfra.tagging setPrivacyConsentForSensitiveData:YES];
    [self.appinfra.tagging setPrivacyConsent:AIATPrivacyStatusOptIn];
    id mock = OCMClassMock([ADBMobile class]);
    OCMStub([mock trackingIdentifier]).andReturn(@"AdobeIDForUnitTesting");
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        __weak NSDictionary * dict;
        [invocation getArgument:&dict atIndex:3];
        XCTAssertNil(dict[@"appsId"]);
        XCTAssertNil(dict[@"UTCtimestamp"]);
        XCTAssertNil(dict[@"localTimeStamp"]);
        XCTAssertNil(dict[@"bundleId"]);
        XCTAssertNil(dict[@"language"]);
    }]trackState:OCMOCK_ANY data:OCMOCK_ANY];
    [self.appinfra.tagging trackPageWithInfo:@"test" params:@{@"test":@"value"}];
    [mock verify];
}

-(void)test13172Case2 {
    //precondition
    AIAppConfiguration * config = (AIAppConfiguration *)self.appinfra.appConfig;
    NSMutableDictionary * dict = config.staticConfiguration[@"APPINFRA"];
    dict[@"TAGGING.SENSITIVEDATA"] = nil;
    [self.appinfra.tagging setPrivacyConsentForSensitiveData:YES];
    [self.appinfra.tagging setPrivacyConsent:AIATPrivacyStatusOptIn];
    id mock = OCMClassMock([ADBMobile class]);
    OCMStub([mock trackingIdentifier]).andReturn(@"AdobeIDForUnitTesting");
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        __weak NSDictionary * dict;
        [invocation getArgument:&dict atIndex:3];
        XCTAssertNotNil(dict[@"appsId"]);
        XCTAssertNotNil(dict[@"UTCTimestamp"]);
        XCTAssertNotNil(dict[@"localTimeStamp"]);
        XCTAssertNotNil(dict[@"bundleId"]);
        XCTAssertNotNil(dict[@"language"]);
    }]trackState:OCMOCK_ANY data:OCMOCK_ANY];
    [self.appinfra.tagging trackPageWithInfo:@"test" params:@{@"test":@"value"}];
    [mock verify];
}

//Test Case 13188:To verify whether user actions are uploaded based on the user consent PrivacyStatusOptIn
-(void)test13188 {
    [self.appinfra.tagging setPrivacyConsent:AIATPrivacyStatusOptIn];
    XCTAssertEqual(ADBMobile.privacyStatus, ADBMobilePrivacyStatusOptIn);
}

//Test Case 13189:To verify whether user actions are uploaded based on the user consent PrivacyStatusOptOut
-(void)test13189 {
    [self.appinfra.tagging setPrivacyConsent:AIATPrivacyStatusOptOut];
    XCTAssertEqual(ADBMobile.privacyStatus, ADBMobilePrivacyStatusOptIn);
}

//Test Case 13198:HF-Verify the start action when user tap on start
//Test Case 13199:HF-Verify the End action when user tap on End
-(void)test13198 {
    [self.appinfra.tagging setPrivacyConsent:AIATPrivacyStatusOptIn];
    id mock = OCMClassMock([ADBMobile class]);
    OCMStub([mock trackingIdentifier]).andReturn(@"AdobeIDForUnitTesting");
    [[mock expect]trackTimedActionStart:@"trackTimedAction" data:OCMOCK_ANY];
    
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        void (^logic)(NSTimeInterval inAppDuration, NSTimeInterval totalDuration, NSMutableDictionary*  data);
        [invocation getArgument:&logic atIndex:3];
        logic(2.0,3.0,@{@"key":@"value"});
    }] trackTimedActionEnd:@"trackTimedAction" logic:OCMOCK_ANY];
    [self.appinfra.tagging trackTimedActionStart:@"trackTimedAction" data:@{@"key":@"value"}];
    [self.appinfra.tagging trackTimedActionEnd:@"trackTimedAction" logic:^BOOL(NSTimeInterval inAppDuration, NSTimeInterval totalDuration, NSMutableDictionary * _Nullable data) {
        XCTAssertEqual(inAppDuration, 2.0);
        XCTAssertEqual(totalDuration, 3.0);
        return true;
    }];
    
    [mock verify];
}

//Test Case 13219:HF-Verify the Video name tagged for video playbackNote:trackActionWithInfo("video Start"/"videoed", "video Name", video Name)
//Test Case 13220:HF-Verify the action tagged for video playback when the Video is started
-(void)test13219 {
    [self.appinfra.tagging setPrivacyConsent:AIATPrivacyStatusOptIn];
    id mock = OCMClassMock([ADBMobile class]);
    OCMStub([mock trackingIdentifier]).andReturn(@"AdobeIDForUnitTesting");
    XCTestExpectation *expectation = [self expectationWithDescription:@"test13219"];
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        __weak NSDictionary * dict;
        [invocation getArgument:&dict atIndex:3];
        XCTAssertEqual(dict[@"videoName"], @"videoname");
        [expectation fulfill];
    }] trackAction:@"videoStart" data:OCMOCK_ANY];
    [self.appinfra.tagging trackVideoStart:@"videoname"];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        NSLog(@"error :%@",[error localizedDescription]);
    }];
    [mock verify];
}

//Test Case 13221:HF-Verify the action tagged for video playback when the Video is stop
-(void)test13221 {
    id mock = OCMClassMock([ADBMobile class]);
    XCTestExpectation *expectation = [self expectationWithDescription:@"test13221"];
    OCMStub([mock trackingIdentifier]).andReturn(@"AdobeIDForUnitTesting");
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        __weak NSDictionary * dict;
        [invocation getArgument:&dict atIndex:3];
        XCTAssertEqual(dict[@"videoName"], @"videoname");
        [expectation fulfill];
    }] trackAction:@"videoEnd" data:OCMOCK_ANY];
    [self.appinfra.tagging trackVideoEnd:@"videoname"];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        NSLog(@"error :%@",[error localizedDescription]);
    }];
    [mock verify];
}

//Test Case 13222:HF-Verify the Social share is tagged for Facebook
-(void)test13222 {
    id mock = OCMClassMock([ADBMobile class]);
    XCTestExpectation *expectation = [self expectationWithDescription:@"test13222"];
    OCMStub([mock trackingIdentifier]).andReturn(@"AdobeIDForUnitTesting");
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        __weak NSDictionary * dict;
        [invocation getArgument:&dict atIndex:3];
        XCTAssertEqual(dict[@"socialItem"], @"facebookItem");
        XCTAssertEqualObjects(dict[@"socialType"], @"facebook");
        [expectation fulfill];

    }] trackAction:@"socialShare" data:OCMOCK_ANY];
    [self.appinfra.tagging trackSocialSharing:AIATSocialMediaFacebook withItem:@"facebookItem"];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        NSLog(@"error :%@",[error localizedDescription]);
    }];
    [mock verify];
}

//Test Case 13224:HF-Verify the Social share is tagged for Twitter
-(void)test13224 {
    id mock = OCMClassMock([ADBMobile class]);
    XCTestExpectation *expectation = [self expectationWithDescription:@"test13224"];
    OCMStub([mock trackingIdentifier]).andReturn(@"AdobeIDForUnitTesting");
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        __weak NSDictionary * dict;
        [invocation getArgument:&dict atIndex:3];
        XCTAssertEqual(dict[@"socialItem"], @"twitterItem");
        XCTAssertEqualObjects(dict[@"socialType"], @"twitter");
        [expectation fulfill];

    }] trackAction:@"socialShare" data:OCMOCK_ANY];
    
    [self.appinfra.tagging trackSocialSharing:AIATSocialMediaTwitter withItem:@"twitterItem"];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        NSLog(@"error :%@",[error localizedDescription]);
    }];
    [mock verify];
}

//Test Case 13226:HF-Verify the Social share is tagged for Mail
-(void)test13226 {
    
    id mock = OCMClassMock([ADBMobile class]);
    OCMStub([mock trackingIdentifier]).andReturn(@"AdobeIDForUnitTesting");
    XCTestExpectation *expectation = [self expectationWithDescription:@"test13226"];

    [[[mock expect]andDo:^(NSInvocation *invocation) {
        __weak NSDictionary * dict;
        [invocation getArgument:&dict atIndex:3];
        XCTAssertEqual(dict[@"socialItem"], @"mailItem");
        XCTAssertEqualObjects(dict[@"socialType"], @"mail");
        [expectation fulfill];

    }] trackAction:@"socialShare" data:OCMOCK_ANY];
    
    [self.appinfra.tagging trackSocialSharing:AIATSocialMediaMail withItem:@"mailItem"];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        NSLog(@"error :%@",[error localizedDescription]);
    }];

    [mock verify];
}

//Test Case 13285:HS:Verify that user is getting key as "exitLinkName"
-(void)test13285 {
    id mock = OCMClassMock([ADBMobile class]);
    XCTestExpectation *expectation = [self expectationWithDescription:@"test13285"];
    OCMStub([mock trackingIdentifier]).andReturn(@"AdobeIDForUnitTesting");
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        __weak NSDictionary * dict;
        [invocation getArgument:&dict atIndex:3];
        XCTAssertEqual(dict[@"exitLinkName"], @"https:philips.com");
        [expectation fulfill];

    }] trackAction:@"sendData" data:OCMOCK_ANY];
    [self.appinfra.tagging trackLinkExternal:@"https:philips.com"];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        NSLog(@"error :%@",[error localizedDescription]);
    }];
    [mock verify];
}

-(void)test13286 {
    id mock = OCMClassMock([ADBMobile class]);
    XCTestExpectation *expectation = [self expectationWithDescription:@"test13286"];
    OCMStub([mock trackingIdentifier]).andReturn(@"AdobeIDForUnitTesting");
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        __weak NSDictionary * dict;
        [invocation getArgument:&dict atIndex:3];
        XCTAssertTrue([dict[@"technicalError"] isEqualToString:@"testComponent:TestErrorType:TestServerName:TestMessage:TestCode"]);
        [expectation fulfill];

    }] trackAction:@"sendData" data:OCMOCK_ANY];
    
    AITaggingError *taggingError = [[AITaggingError alloc] initWithErrorType:@"TestErrorType"
                                                                  serverName:@"TestServerName"
                                                                   errorCode:@"TestCode"
                                                                errorMessage:@"TestMessage"];
    [self.appinfra.tagging trackErrorAction:AITaggingTechnicalError taggingError:taggingError];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        NSLog(@"error :%@",[error localizedDescription]);
    }];
    [mock verify];
}

-(void)test132867{
    id mock = OCMClassMock([ADBMobile class]);
    XCTestExpectation *expectation = [self expectationWithDescription:@"test13287"];
    OCMStub([mock trackingIdentifier]).andReturn(@"AdobeIDForUnitTesting");
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        __weak NSDictionary * dict;
        [invocation getArgument:&dict atIndex:3];
        XCTAssertTrue([dict[@"technicalError"] isEqualToString:@"testComponent:TestErrorType:TestServerName:TestMessage:TestCode"]);
        XCTAssertTrue([dict[@"testkey"] isEqualToString:@"testData"]);
        [expectation fulfill];

    }] trackAction:@"sendData" data:OCMOCK_ANY];
    
    AITaggingError *taggingError = [[AITaggingError alloc] initWithErrorType:@"TestErrorType"
                                                                  serverName:@"TestServerName"
                                                                   errorCode:@"TestCode"
                                                                errorMessage:@"TestMessage"];
    [self.appinfra.tagging trackErrorAction:AITaggingTechnicalError params:@{@"testkey":@"testData"} taggingError:taggingError];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        NSLog(@"error :%@",[error localizedDescription]);
    }];
    [mock verify];
}

-(void)test13288 {
    id mock = OCMClassMock([ADBMobile class]);
    XCTestExpectation *expectation = [self expectationWithDescription:@"test13288"];
    OCMStub([mock trackingIdentifier]).andReturn(@"AdobeIDForUnitTesting");
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        __weak NSDictionary * dict;
        [invocation getArgument:&dict atIndex:3];
        XCTAssertTrue([dict[@"informationalError"] isEqualToString:@"testComponent:TestErrorType:TestMessage"]);
        [expectation fulfill];

    }] trackAction:@"sendData" data:OCMOCK_ANY];
    
    AITaggingError *taggingError = [[AITaggingError alloc] initWithErrorType:@"TestErrorType"
                                                                  serverName:nil
                                                                   errorCode:nil
                                                                errorMessage:@"TestMessage"];
    [self.appinfra.tagging trackErrorAction:AITaggingInformationalError taggingError:taggingError];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        NSLog(@"error :%@",[error localizedDescription]);
    }];
    [mock verify];
}

-(void)test13289 {
    id mock = OCMClassMock([ADBMobile class]);
    XCTestExpectation *expectation = [self expectationWithDescription:@"test13289"];
    OCMStub([mock trackingIdentifier]).andReturn(@"AdobeIDForUnitTesting");
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        __weak NSDictionary * dict;
        [invocation getArgument:&dict atIndex:3];
        XCTAssertTrue([dict[@"informationalError"] isEqualToString:@"testComponent:TestErrorType:TestMessage"]);
        XCTAssertTrue([dict[@"testkey"] isEqualToString:@"testData"]);
        XCTAssertNil(dict[@"technicalError"]);
        [expectation fulfill];

    }] trackAction:@"sendData" data:OCMOCK_ANY];
    
    AITaggingError *taggingError = [[AITaggingError alloc] initWithErrorType:@"TestErrorType"
                                                                  serverName:nil
                                                                   errorCode:nil
                                                                errorMessage:@"TestMessage"];
    [self.appinfra.tagging trackErrorAction:AITaggingInformationalError params:@{@"testkey":@"testData"} taggingError:taggingError];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        NSLog(@"error :%@",[error localizedDescription]);
    }];
    [mock verify];
}

-(void)test13290 {
    id mock = OCMClassMock([ADBMobile class]);
    XCTestExpectation *expectation = [self expectationWithDescription:@"test13290"];
    OCMStub([mock trackingIdentifier]).andReturn(@"AdobeIDForUnitTesting");
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        __weak NSDictionary * dict;
        [invocation getArgument:&dict atIndex:3];
        XCTAssertTrue([dict[@"userError"] isEqualToString:@"testComponent:TestErrorType:TestMessage"]);
        [expectation fulfill];

    }] trackAction:@"sendData" data:OCMOCK_ANY];
    
    AITaggingError *taggingError = [[AITaggingError alloc] initWithErrorType:@"TestErrorType"
                                                                  serverName:nil
                                                                   errorCode:nil
                                                                errorMessage:@"TestMessage"];
    [self.appinfra.tagging trackErrorAction:AITaggingUserError taggingError:taggingError];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        NSLog(@"error :%@",[error localizedDescription]);
    }];
    [mock verify];
}

-(void)test13291 {
    id mock = OCMClassMock([ADBMobile class]);
    XCTestExpectation *expectation = [self expectationWithDescription:@"test13291"];
    OCMStub([mock trackingIdentifier]).andReturn(@"AdobeIDForUnitTesting");
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        __weak NSDictionary * dict;
        [invocation getArgument:&dict atIndex:3];
        XCTAssertTrue([dict[@"userError"] isEqualToString:@"testComponent:TestErrorType:TestMessage"]);
        XCTAssertTrue([dict[@"testkey"] isEqualToString:@"testData"]);
        XCTAssertNil(dict[@"technicalError"]);
        [expectation fulfill];

    }] trackAction:@"sendData" data:OCMOCK_ANY];
    
    AITaggingError *taggingError = [[AITaggingError alloc] initWithErrorType:@"TestErrorType"
                                                                  serverName:nil
                                                                   errorCode:nil
                                                                errorMessage:@"TestMessage"];
    [self.appinfra.tagging trackErrorAction:AITaggingUserError params:@{@"testkey":@"testData"} taggingError:taggingError];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        NSLog(@"error :%@",[error localizedDescription]);
    }];
    [mock verify];
}


-(void)test13292 {
    id mock = OCMClassMock([ADBMobile class]);
    XCTestExpectation *expectation = [self expectationWithDescription:@"test13292"];
    OCMStub([mock trackingIdentifier]).andReturn(@"AdobeIDForUnitTesting");
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        __weak NSDictionary * dict;
        [invocation getArgument:&dict atIndex:3];
        XCTAssertTrue([dict[@"userError"] isEqualToString:@"testComponent:TestMessage"]);
        XCTAssertTrue([dict[@"testkey"] isEqualToString:@"testData"]);
        XCTAssertNil(dict[@"technicalError"]);
        [expectation fulfill];

    }] trackAction:@"sendData" data:OCMOCK_ANY];
    
    AITaggingError *taggingError = [[AITaggingError alloc] initWithErrorType:nil
                                                                  serverName:nil
                                                                   errorCode:nil
                                                                errorMessage:@"TestMessage"];
    [self.appinfra.tagging trackErrorAction:AITaggingUserError params:@{@"testkey":@"testData"} taggingError:taggingError];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        NSLog(@"error :%@",[error localizedDescription]);
    }];
    [mock verify];
}

-(void)test13293 {
    id mock = OCMClassMock([ADBMobile class]);
    XCTestExpectation *expectation = [self expectationWithDescription:@"test13293"];
    OCMStub([mock trackingIdentifier]).andReturn(@"AdobeIDForUnitTesting");
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        __weak NSDictionary * dict;
        [invocation getArgument:&dict atIndex:3];
        XCTAssertTrue([dict[@"userError"] isEqualToString:@"testComponent:TestMessage"]);
        XCTAssertTrue([dict[@"testkey"] isEqualToString:@"testData"]);
        XCTAssertNil(dict[@"technicalError"]);
        [expectation fulfill];

    }] trackAction:@"sendData" data:OCMOCK_ANY];
    AITaggingError *taggingError = [[AITaggingError alloc] initWithErrorMessage:@"TestMessage"];
    [self.appinfra.tagging trackErrorAction:AITaggingUserError params:@{@"testkey":@"testData"} taggingError:taggingError];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        NSLog(@"error :%@",[error localizedDescription]);
    }];
    [mock verify];
}

@end
