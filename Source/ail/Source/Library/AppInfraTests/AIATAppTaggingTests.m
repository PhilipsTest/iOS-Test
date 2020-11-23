//
//  AIATAppTaggingTests.m
//  AppInfra
//
//  Created by Ravi Kiran HR on 4/25/16.
/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */
//

#import <XCTest/XCTest.h>
#import "AppInfra.h"
#import "AIAppTaggingProtocol.h"
#import "AIAppTagging.h"
#import <OCMock/OCMock.h>
#import "NSBundle+Bundle.h"
#import "AIAppInfraBuilder.h"
#import "AILogging.h"
#import <objc/runtime.h>
#import "AIAppInfraProtocol.h"
#import <AdobeMobileSDK/ADBMobile.h>
#import "AIInternalLogger.h"
#import "AIAppTaggingPrivacyStatus.h"

@import AppInfra;

@interface AIAppInfra()
@property (nonatomic,strong) id<AILoggingProtocol> appInfraLogger;
@end

@interface AIATAppTaggingTests : XCTestCase{
    
    AIAppInfra *objAppInfra ;
    id mockedObject;
}
@end

@interface AILogging()
-(NSDictionary *)getLoggingConfigDictionary;

@end

@interface AIAppTagging()

- (void)postActionWithApplicationState:(NSString*)actionName withDict:(NSDictionary*)contextDict;
- (void)postTaggingData:(NSDictionary *)data;
- (void)postPageData:(NSString *)pageName withDict:(NSDictionary *)contextDict;
- (void)trackTimedActionStart:(nullable NSString *)action data:(nullable NSDictionary *)data;

@property (nonatomic, strong) NSString *strTrackingID;
@end

static NSString *const adbTaggingStatusKey = @"ail_adb_status";

@implementation AIATAppTaggingTests

+ (id) sharedAppInfra {
    static dispatch_once_t time = 0;
    static AIAppInfra *_sharedObject = nil;
    dispatch_once(&time, ^{
        [ADBMobile overrideConfigPath:[[NSBundle mainBundle] pathForResource:@"ADBMobileConfig" ofType:@"json"]];
        _sharedObject = [AIAppInfra buildAppInfraWithBlock:nil];
    });
    return _sharedObject;
}

- (void)setUp {
    [super setUp];
    [NSBundle loadSwizzler];
    objAppInfra = [AIATAppTaggingTests sharedAppInfra];
    mockedObject = OCMClassMock([ADBMobile class]);
    OCMStub([mockedObject trackingIdentifier]).andReturn(@"AdobeIDForUnitTesting");
}

- (void)tearDown {
    [super tearDown];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:adbTaggingStatusKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)testTrackPageWithInfoWithValidParams {

    [[[mockedObject expect] andDo:^(NSInvocation *invocation) {
        
        __unsafe_unretained  NSString *strPageName;
        __unsafe_unretained  NSDictionary *dictParam;
        [invocation getArgument:&strPageName atIndex:2];
        [invocation getArgument:&dictParam atIndex:3];
        
        XCTAssertEqualObjects(strPageName, @"testPageName2");
        XCTAssertTrue([dictParam.allKeys containsObject:@"UTCTimestamp"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"appsId"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"language"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"localTimeStamp"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"testKey"]);
        
        if([dictParam.allKeys containsObject:@"UTCTimestamp"])
            XCTAssertNotNil([dictParam objectForKey:@"UTCTimestamp"]);
        
        if([dictParam.allKeys containsObject:@"appsId"])
            XCTAssertNotNil([dictParam objectForKey:@"appsId"]);
        
        if([dictParam.allKeys containsObject:@"language"])
            XCTAssertNotNil([dictParam objectForKey:@"language"]);
        
        if([dictParam.allKeys containsObject:@"timestamp"])
            XCTAssertNotNil([dictParam objectForKey:@"timestamp"]);
        
        if([dictParam.allKeys containsObject:@"testKey"])
            XCTAssertEqualObjects([dictParam objectForKey:@"testKey"], @"testValue");
        
    }] trackState:[OCMArg any] data:[OCMArg any]];
    [objAppInfra.tagging trackPageWithInfo:@"testPageName2" params:@{@"testKey":@"testValue"}];
    OCMVerify(mockedObject);
}

- (void)testTrackPageWithInfoWithInValidParams {

    [[[mockedObject expect] andDo:^(NSInvocation *invocation) {
        
        __unsafe_unretained  NSString *strPageName;
        __unsafe_unretained  NSDictionary *dictParam;
        [invocation getArgument:&strPageName atIndex:2];
        [invocation getArgument:&dictParam atIndex:3];
        
        XCTAssertNotEqualObjects(strPageName, @"testPageName1");
        XCTAssertFalse([dictParam.allKeys containsObject:@"UTCTimestamp1"]);
        XCTAssertFalse([dictParam.allKeys containsObject:@"appsId1"]);
        XCTAssertFalse([dictParam.allKeys containsObject:@"language1"]);
        XCTAssertFalse([dictParam.allKeys containsObject:@"timestamp1"]);
        XCTAssertFalse([dictParam.allKeys containsObject:@"testKey1"]);
        
        if([dictParam.allKeys containsObject:@"testKey"])
            XCTAssertNotEqualObjects([dictParam objectForKey:@"testKey"], @"paramValue");
        
    }] trackState:[OCMArg any] data:[OCMArg any]];
    [objAppInfra.tagging trackPageWithInfo:@"testPageName" params:@{@"testKey":@"testValue"}];
    OCMVerify(mockedObject);
}

- (void)testTrackPageWithSingleValueWithValidParams {
    
    [[[mockedObject expect] andDo:^(NSInvocation *invocation) {
        __unsafe_unretained  NSString *strPageName;
        __unsafe_unretained  NSDictionary *dictParam;
        [invocation getArgument:&strPageName atIndex:2];
        [invocation getArgument:&dictParam atIndex:3];
        
        XCTAssertEqualObjects(strPageName, @"testPageName4");
        XCTAssertTrue([dictParam.allKeys containsObject:@"UTCTimestamp"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"appsId"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"language"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"localTimeStamp"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"paramKey"]);
        
        if([dictParam.allKeys containsObject:@"UTCTimestamp"])
            XCTAssertNotNil([dictParam objectForKey:@"UTCTimestamp"]);
        
        if([dictParam.allKeys containsObject:@"appsId"])
            XCTAssertNotNil([dictParam objectForKey:@"appsId"]);
        
        if([dictParam.allKeys containsObject:@"language"])
            XCTAssertNotNil([dictParam objectForKey:@"language"]);
        
        if([dictParam.allKeys containsObject:@"timestamp"])
            XCTAssertNotNil([dictParam objectForKey:@"timestamp"]);
        
        if([dictParam.allKeys containsObject:@"paramKey"])
            XCTAssertEqualObjects([dictParam objectForKey:@"paramKey"], @"paramValue");
        
    }] trackState:[OCMArg any] data:[OCMArg any]];
    [objAppInfra.tagging trackPageWithInfo:@"testPageName4" paramKey:@"paramKey" andParamValue:@"paramValue"];
    OCMVerify(mockedObject);
    
}
- (void)testTrackPageWithSingleValueWithInvalidParams {
    
    [[[mockedObject expect] andDo:^(NSInvocation *invocation) {
        __unsafe_unretained  NSString *strPageName;
        __unsafe_unretained  NSDictionary *dictParam;
        [invocation getArgument:&strPageName atIndex:2];
        [invocation getArgument:&dictParam atIndex:3];
        
        XCTAssertEqualObjects(strPageName, @"testPageName3");
        XCTAssertTrue([dictParam.allKeys containsObject:@"UTCTimestamp"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"appsId"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"language"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"localTimeStamp"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"paramKey"]);
        
        if([dictParam.allKeys containsObject:@"UTCTimestamp"])
            XCTAssertNotNil([dictParam objectForKey:@"UTCTimestamp"]);
        
        if([dictParam.allKeys containsObject:@"appsId"])
            XCTAssertNotNil([dictParam objectForKey:@"appsId"]);
        
        if([dictParam.allKeys containsObject:@"language"])
            XCTAssertNotNil([dictParam objectForKey:@"language"]);
        
        if([dictParam.allKeys containsObject:@"timestamp"])
            XCTAssertNotNil([dictParam objectForKey:@"timestamp"]);
        
        if([dictParam.allKeys containsObject:@"paramKey"])
            XCTAssertNotEqualObjects([dictParam objectForKey:@"paramKey"], @"paramValue1");
        
    }] trackState:[OCMArg any] data:[OCMArg any]];
    [objAppInfra.tagging trackPageWithInfo:@"testPageName3" paramKey:@"paramKey" andParamValue:@"paramValue"];
    OCMVerify(mockedObject);
    
}
- (void)testTrackActionWithInfoWithValidParams {
    
    
    [[[mockedObject expect] andDo:^(NSInvocation *invocation) {
        
        __unsafe_unretained  NSString *strButtonName;
        __unsafe_unretained  NSDictionary *dictParam;
        [invocation getArgument:&strButtonName atIndex:2];
        [invocation getArgument:&dictParam atIndex:3];
        
        XCTAssertEqualObjects(strButtonName, @"testButtonName");
        XCTAssertTrue([dictParam.allKeys containsObject:@"UTCTimestamp"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"appsId"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"language"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"localTimeStamp"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"testKey"]);
        
        if([dictParam.allKeys containsObject:@"UTCTimestamp"])
            XCTAssertNotNil([dictParam objectForKey:@"UTCTimestamp"]);
        
        if([dictParam.allKeys containsObject:@"appsId"])
            XCTAssertNotNil([dictParam objectForKey:@"appsId"]);
        
        if([dictParam.allKeys containsObject:@"language"])
            XCTAssertNotNil([dictParam objectForKey:@"language"]);
        
        if([dictParam.allKeys containsObject:@"timestamp"])
            XCTAssertNotNil([dictParam objectForKey:@"timestamp"]);
        
        if([dictParam.allKeys containsObject:@"testKey"])
            XCTAssertEqualObjects([dictParam objectForKey:@"testKey"], @"testValue");
        
    }] trackAction:[OCMArg any] data:[OCMArg any]];
    [objAppInfra.tagging trackActionWithInfo:@"testButtonName" params:@{@"testKey":@"testValue"}];
    OCMVerify(mockedObject);
    
}

- (void)testTrackActionWithInfoWithInValidParams {
    
    [[[mockedObject expect] andDo:^(NSInvocation *invocation) {
        
        __unsafe_unretained  NSString *strButtonName;
        __unsafe_unretained  NSDictionary *dictParam;
        [invocation getArgument:&strButtonName atIndex:2];
        [invocation getArgument:&dictParam atIndex:3];
        
        XCTAssertNotEqualObjects(strButtonName, @"testButtonName1");
        XCTAssertFalse([dictParam.allKeys containsObject:@"UTCTimestamp1"]);
        XCTAssertFalse([dictParam.allKeys containsObject:@"appsId1"]);
        XCTAssertFalse([dictParam.allKeys containsObject:@"language1"]);
        XCTAssertFalse([dictParam.allKeys containsObject:@"timestamp1"]);
        XCTAssertFalse([dictParam.allKeys containsObject:@"testKey1"]);
        
        if([dictParam.allKeys containsObject:@"testKey"])
            XCTAssertNotEqualObjects([dictParam objectForKey:@"testKey"], @"paramValue");
        
    }] trackAction:[OCMArg any] data:[OCMArg any]];
    [objAppInfra.tagging trackActionWithInfo:@"testButtonName" params:@{@"testKey":@"testValue"}];
    OCMVerify(mockedObject);
}

- (void)testTrackActionWithSingleValueWithValidParams {
    
    [[[mockedObject expect] andDo:^(NSInvocation *invocation) {
        __unsafe_unretained  NSString *strButtonName;
        __unsafe_unretained  NSDictionary *dictParam;
        [invocation getArgument:&strButtonName atIndex:2];
        [invocation getArgument:&dictParam atIndex:3];
        
        XCTAssertEqualObjects(strButtonName, @"testButtonName");
        XCTAssertTrue([dictParam.allKeys containsObject:@"UTCTimestamp"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"appsId"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"language"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"localTimeStamp"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"paramKey"]);
        
        if([dictParam.allKeys containsObject:@"UTCTimestamp"])
            XCTAssertNotNil([dictParam objectForKey:@"UTCTimestamp"]);
        
        if([dictParam.allKeys containsObject:@"appsId"])
            XCTAssertNotNil([dictParam objectForKey:@"appsId"]);
        
        if([dictParam.allKeys containsObject:@"language"])
            XCTAssertNotNil([dictParam objectForKey:@"language"]);
        
        if([dictParam.allKeys containsObject:@"timestamp"])
            XCTAssertNotNil([dictParam objectForKey:@"timestamp"]);
        
        if([dictParam.allKeys containsObject:@"paramKey"])
            XCTAssertEqualObjects([dictParam objectForKey:@"paramKey"], @"paramValue");
        
    }] trackAction:[OCMArg any] data:[OCMArg any]];
    [objAppInfra.tagging trackActionWithInfo:@"testButtonName" paramKey:@"paramKey" andParamValue:@"paramValue"];
    OCMVerify(mockedObject);
    
}
- (void)testTrackActionWithSingleValueWithInvalidParams {
    
    [[[mockedObject expect] andDo:^(NSInvocation *invocation) {
        __unsafe_unretained  NSString *strButtonName;
        __unsafe_unretained  NSDictionary *dictParam;
        [invocation getArgument:&strButtonName atIndex:2];
        [invocation getArgument:&dictParam atIndex:3];
        
        XCTAssertEqualObjects(strButtonName, @"testButtonName");
        XCTAssertTrue([dictParam.allKeys containsObject:@"UTCTimestamp"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"appsId"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"language"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"localTimeStamp"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"paramKey"]);
        
        if([dictParam.allKeys containsObject:@"UTCTimestamp"])
            XCTAssertNotNil([dictParam objectForKey:@"UTCTimestamp"]);
        
        if([dictParam.allKeys containsObject:@"appsId"])
            XCTAssertNotNil([dictParam objectForKey:@"appsId"]);
        
        if([dictParam.allKeys containsObject:@"language"])
            XCTAssertNotNil([dictParam objectForKey:@"language"]);
        
        if([dictParam.allKeys containsObject:@"timestamp"])
            XCTAssertNotNil([dictParam objectForKey:@"timestamp"]);
        
        if([dictParam.allKeys containsObject:@"paramKey"])
            XCTAssertNotEqualObjects([dictParam objectForKey:@"paramKey"], @"");
        
    }] trackAction:[OCMArg any] data:[OCMArg any]];
    [objAppInfra.tagging trackActionWithInfo:@"testButtonName" paramKey:@"paramKey" andParamValue:@"paramValue"];
    OCMVerify(mockedObject);
    
}

-(void)testSetPrivacyConsentOptIn
{
    [objAppInfra.tagging setPrivacyConsent:AIATPrivacyStatusOptIn];
    AIATPrivacyStatus privacyStatus = [objAppInfra.tagging getPrivacyConsent];
    XCTAssertEqual(privacyStatus, AIATPrivacyStatusOptIn);
}

-(void)testSetPrivacyConsentOptOut
{
    [objAppInfra.tagging setPrivacyConsent:AIATPrivacyStatusOptOut];
    AIATPrivacyStatus privacyStatus = [objAppInfra.tagging getPrivacyConsent];
    XCTAssertEqual(privacyStatus, AIATPrivacyStatusOptOut);
}

-(void)testSetPrivacyConsentOptUnknown
{
    [objAppInfra.tagging setPrivacyConsent:AIATPrivacyStatusOptIn];
    AIATPrivacyStatus privacyStatus = [objAppInfra.tagging getPrivacyConsent];
    XCTAssertEqual(privacyStatus, AIATPrivacyStatusOptIn);
}
-(void)testSetPrivacyConsentNegativeCase
{
    [objAppInfra.tagging setPrivacyConsent:AIATPrivacyStatusOptOut];
    AIATPrivacyStatus privacyStatus = [objAppInfra.tagging getPrivacyConsent];
    XCTAssertNotEqual(privacyStatus, AIATPrivacyStatusUnknown);
}

- (void)testSetPreviousPage {
    id mockedObject = OCMClassMock([AIAppTagging class]);
    [[[mockedObject expect] andDo:^(NSInvocation *invocation) {
        __unsafe_unretained  NSString *strPreviousPageName;
        [invocation getArgument:&strPreviousPageName atIndex:2];
        XCTAssertNotNil(strPreviousPageName);
        XCTAssertEqualObjects(strPreviousPageName, @"testPreviousPage");
    }] setPreviousPage:[OCMArg any]];
    [objAppInfra.tagging setPreviousPage:@"testPreviousPage"];
    OCMVerify(mockedObject);
}

-(void)testCreateInstanceForComponent
{
    AIAppTagging *objAppTagging = [objAppInfra.tagging createInstanceForComponent:@"testComponent" componentVersion:@"test.0.1"];
    
    XCTAssertNotNil(objAppTagging);
    
    
    [[[mockedObject expect] andDo:^(NSInvocation *invocation) {
        
        __unsafe_unretained  NSDictionary *dictParam;
        [invocation getArgument:&dictParam atIndex:3];
        XCTAssertTrue([dictParam.allKeys containsObject:@"componentId"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"componentVersion"]);
        
        
        if([dictParam.allKeys containsObject:@"componentId"])
            XCTAssertNotNil([dictParam objectForKey:@"componentId"]);
        
        if([dictParam.allKeys containsObject:@"componentVersion"])
            XCTAssertNotNil([dictParam objectForKey:@"componentVersion"]);
        
        if([dictParam.allKeys containsObject:@"componentId"])
            XCTAssertEqualObjects([dictParam objectForKey:@"componentId"], @"testComponent");
        
        if([dictParam.allKeys containsObject:@"componentVersion"])
            XCTAssertEqualObjects([dictParam objectForKey:@"componentVersion"], @"test.0.1");
        
        
        
    }] trackState:[OCMArg any] data:[OCMArg any]];
    [objAppTagging trackPageWithInfo:@"testPageName" paramKey:@"paramKey" andParamValue:@"paramValue"];
    OCMVerify(mockedObject);
}
-(void)testCreateInstanceForComponentNegativeCase
{
    AIAppTagging *objAppTagging = [objAppInfra.tagging createInstanceForComponent:@"testComponent" componentVersion:@"test.0.1"];
    
    XCTAssertNotNil(objAppTagging);
    
    
    [[[mockedObject expect] andDo:^(NSInvocation *invocation) {
        
        __unsafe_unretained  NSDictionary *dictParam;
        [invocation getArgument:&dictParam atIndex:3];
        XCTAssertTrue([dictParam.allKeys containsObject:@"componentId"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"componentVersion"]);
        
        if([dictParam.allKeys containsObject:@"componentId"])
            XCTAssertNotNil([dictParam objectForKey:@"componentId"]);
        
        if([dictParam.allKeys containsObject:@"componentVersion"])
            XCTAssertNotNil([dictParam objectForKey:@"componentVersion"]);
        
        if([dictParam.allKeys containsObject:@"componentId"])
            XCTAssertNotEqualObjects([dictParam objectForKey:@"componentId"], @"");
        
        if([dictParam.allKeys containsObject:@"componentVersion"])
            XCTAssertNotEqualObjects([dictParam objectForKey:@"componentVersion"], @"");
    }] trackState:[OCMArg any] data:[OCMArg any]];
    [objAppTagging trackPageWithInfo:@"testPageName1" paramKey:@"paramKey" andParamValue:@"paramValue"];
    OCMVerify(mockedObject);
}

- (void)testTrackAppState {
    
    
    [[[mockedObject expect] andDo:^(NSInvocation *invocation) {
        
        __unsafe_unretained  NSString *strButtonName;
        __unsafe_unretained  NSDictionary *dictParam;
        [invocation getArgument:&strButtonName atIndex:2];
        [invocation getArgument:&dictParam atIndex:3];
        XCTAssertEqualObjects(strButtonName, @"testButtonName");
        XCTAssertTrue([dictParam.allKeys containsObject:@"testKey"]);
        if([dictParam.allKeys containsObject:@"testKey"])
            XCTAssertEqualObjects([dictParam objectForKey:@"testKey"], @"testValue");
        
    }] trackAction:[OCMArg any] data:[OCMArg any]];
    AIAppTagging *obj = [[AIAppTagging alloc]init];
    
    [obj postActionWithApplicationState:@"testButtonName" withDict:@{@"testKey":@"testValue"}];
    OCMVerify(mockedObject);
    
}

-(void)testTrackVideoStart{
    
    
    [[[mockedObject expect] andDo:^(NSInvocation *invocation){
        __unsafe_unretained  NSDictionary *mediaDict;
        __unsafe_unretained  NSString *actionName;
        [invocation getArgument:&actionName atIndex:2];
        [invocation getArgument:&mediaDict atIndex:3];
        NSString *mediaFileName = [mediaDict valueForKey:@"videoName"];
        XCTAssertTrue([actionName isEqualToString:@"videoStart"]);
        XCTAssertTrue([mediaFileName isEqualToString:@"DemoTaggingMedia"]);
    }] trackAction:[OCMArg any] data:[OCMArg any]];
    
    [objAppInfra.tagging trackVideoStart:@"DemoTaggingMedia"];
    OCMVerify(mockedObject);
}


-(void)testTrackVideoEnd{
    
    
    [[[mockedObject expect] andDo:^(NSInvocation *invocation){
        __unsafe_unretained  NSDictionary *mediaDict;
        __unsafe_unretained  NSString *actionName;
        [invocation getArgument:&actionName atIndex:2];
        [invocation getArgument:&mediaDict atIndex:3];
        NSString *mediaFileName = [mediaDict valueForKey:@"videoName"];
        XCTAssertTrue([actionName isEqualToString:@"videoEnd"]);
        XCTAssertTrue([mediaFileName isEqualToString:@"DemoTaggingMedia"]);
    }] trackAction:[OCMArg any] data:[OCMArg any]];
    
    [objAppInfra.tagging trackVideoEnd:@"DemoTaggingMedia"];
    OCMVerify(mockedObject);
    
}


-(void)testTrackSocialSharingWithFacebbok{
    
    
    [[[mockedObject expect] andDo:^(NSInvocation *invocation){
        __unsafe_unretained  NSDictionary *socialMediaDict;
        [invocation getArgument:&socialMediaDict atIndex:3];
        NSString *socialMedia = [socialMediaDict valueForKey:@"socialType"];
        NSString *sharingItem = [socialMediaDict valueForKey:@"socialItem"];
        XCTAssertTrue([socialMedia isEqualToString:@"facebook"]);
        XCTAssertTrue([sharingItem isEqualToString:@"#PhilipsFacebook"]);
    }] trackAction:[OCMArg any] data:[OCMArg any]];
    
    [objAppInfra.tagging trackSocialSharing:AIATSocialMediaFacebook withItem:@"#PhilipsFacebook"];
    OCMVerify(mockedObject);
    
}


-(void)testTrackSocialSharingWithTwitter{
    
    
    [[[mockedObject expect] andDo:^(NSInvocation *invocation){
        __unsafe_unretained  NSDictionary *socialMediaDict;
        [invocation getArgument:&socialMediaDict atIndex:3];
        NSString *socialMedia = [socialMediaDict valueForKey:@"socialType"];
        NSString *sharingItem = [socialMediaDict valueForKey:@"socialItem"];
        XCTAssertTrue([socialMedia isEqualToString:@"twitter"]);
        XCTAssertTrue([sharingItem isEqualToString:@"#PhilipsTwitter"]);
    }] trackAction:[OCMArg any] data:[OCMArg any]];
    
    [objAppInfra.tagging trackSocialSharing:AIATSocialMediaTwitter withItem:@"#PhilipsTwitter"];
    OCMVerify(mockedObject);
    
}


-(void)testTrackSocialSharingWithMail{
    
    
    [[[mockedObject expect] andDo:^(NSInvocation *invocation){
        __unsafe_unretained  NSDictionary *socialMediaDict;
        [invocation getArgument:&socialMediaDict atIndex:3];
        NSString *socialMedia = [socialMediaDict valueForKey:@"socialType"];
        NSString *sharingItem = [socialMediaDict valueForKey:@"socialItem"];
        XCTAssertTrue([socialMedia isEqualToString:@"mail"]);
        XCTAssertTrue([sharingItem isEqualToString:@"#PhilipsMail"]);
    }] trackAction:[OCMArg any] data:[OCMArg any]];
    
    [objAppInfra.tagging trackSocialSharing:AIATSocialMediaMail withItem:@"#PhilipsMail"];
    OCMVerify(mockedObject);
    
}


-(void)testTrackSocialSharingWithAirDrop{
    
    
    [[[mockedObject expect] andDo:^(NSInvocation *invocation){
        __unsafe_unretained  NSDictionary *socialMediaDict;
        [invocation getArgument:&socialMediaDict atIndex:3];
        NSString *socialMedia = [socialMediaDict valueForKey:@"socialType"];
        NSString *sharingItem = [socialMediaDict valueForKey:@"socialItem"];
        XCTAssertTrue([socialMedia isEqualToString:@"airdrop"]);
        XCTAssertTrue([sharingItem isEqualToString:@"#PhilipsAirDrop"]);
    }] trackAction:[OCMArg any] data:[OCMArg any]];
    
    [objAppInfra.tagging trackSocialSharing:AIATSocialMediaAirDrop withItem:@"#PhilipsAirDrop"];
    OCMVerify(mockedObject);
    
}

-(void)testTrackTimedActionStart{
    
    [[[mockedObject expect] andDo:^(NSInvocation *invocation){
        __unsafe_unretained  NSString *actionName;
        __unsafe_unretained  NSDictionary *dictParam;
        [invocation getArgument:&actionName atIndex:2];
        [invocation getArgument:&dictParam atIndex:3];
        
        XCTAssertEqualObjects(actionName, @"testActionStart");
        XCTAssertTrue([dictParam.allKeys containsObject:@"UTCTimestamp"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"appsId"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"language"]);
        XCTAssertTrue([dictParam.allKeys containsObject:@"localTimeStamp"]);
        
        if([dictParam.allKeys containsObject:@"UTCTimestamp"])
            XCTAssertNotNil([dictParam objectForKey:@"UTCTimestamp"]);
        
        if([dictParam.allKeys containsObject:@"appsId"])
            XCTAssertNotNil([dictParam objectForKey:@"appsId"]);
        
        if([dictParam.allKeys containsObject:@"language"])
            XCTAssertNotNil([dictParam objectForKey:@"language"]);
        
        if([dictParam.allKeys containsObject:@"timestamp"])
            XCTAssertNotNil([dictParam objectForKey:@"timestamp"]);
        
        if([dictParam.allKeys containsObject:@"testKey"])
            XCTAssertEqualObjects([dictParam objectForKey:@"testKey"], @"testValue");
        
    }] trackTimedActionStart:[OCMArg any] data:[OCMArg any]];
    
    [objAppInfra.tagging trackTimedActionStart:@"testActionStart" data:@{@"testKey":@"testValue"}];
    OCMVerify(mockedObject);
}



-(void)testTrackTimedActionEnd{
    
    [[[mockedObject expect] andDo:^(NSInvocation *invocation){
        __unsafe_unretained  NSString *actionName;
        
        [invocation getArgument:&actionName atIndex:2];
        XCTAssertEqualObjects(actionName, @"testActionEnd");
        
    }] trackTimedActionEnd:[OCMArg any] logic:[OCMArg any]];
    
    [objAppInfra.tagging trackTimedActionEnd:@"testActionEnd" logic:nil];
    OCMVerify(mockedObject);
}

-(void)testExternalLink{
    
    [[[mockedObject expect] andDo:^(NSInvocation *invocation){
        __unsafe_unretained  NSString *externalUrl;
        
        [invocation getArgument:&externalUrl atIndex:2];
        XCTAssertEqualObjects(externalUrl, @"http://google.com");
        
    }] trackTimedActionEnd:[OCMArg any] logic:[OCMArg any]];
    
    [objAppInfra.tagging trackLinkExternal:@"http://google.com"];
    OCMVerify(mockedObject);
}

-(void)testExternalLinkParamCheck{
    
  AIAppTagging *tagging = [[AIAppTagging alloc]initWithAppInfra:objAppInfra];
    id  mockTagging = [OCMockObject partialMockForObject:tagging];
    
    [[mockTagging expect] trackLinkExternal:[OCMArg checkWithBlock:^(id value) {
        
        /* return YES if value is ok */
        if ([value isEqualToString:@"http://google.com"]) {
            return YES;
        }
        return NO;
        
    }]];
    
    
    [mockTagging trackLinkExternal:@"http://google.com"];
    [mockTagging verify];
}
-(void)testExternalLinkShouldCallTrackAction{
    
  AIAppTagging *tagging = [[AIAppTagging alloc]initWithAppInfra:objAppInfra];
    id  mockTagging = [OCMockObject partialMockForObject:tagging];
    
    
    [[mockTagging expect] trackActionWithInfo:[OCMArg checkWithBlock:^(id value) {
        
        /* return YES if value is ok */
        if ([value isEqualToString:@"sendData"]) {
            return YES;
        }
        return NO;
        
    }]
     
    params:[OCMArg checkWithBlock:^(id value) {
        
        /* return YES if value is ok */
        if ([[value objectForKey:@"exitLinkName" ] isEqualToString:@"http://google.com"]) {
            return YES;
        }
        return NO;
        
    }]
     ];

    
    [mockTagging trackLinkExternal:@"http://google.com"];
    [mockTagging verify];
}

-(void)testFileDownload{
    
    [[[mockedObject expect] andDo:^(NSInvocation *invocation){
        __unsafe_unretained  NSString *externalUrl;
        
        [invocation getArgument:&externalUrl atIndex:2];
        XCTAssertEqualObjects(externalUrl, @"http://google.com");
        
    }] trackTimedActionEnd:[OCMArg any] logic:[OCMArg any]];
    
    [objAppInfra.tagging trackFileDownload:@"profilepic.jpeg"];
    OCMVerify(mockedObject);
}

-(void)testFileDownloadParamCheck{
    
  AIAppTagging *tagging = [[AIAppTagging alloc]initWithAppInfra:objAppInfra];
    id  mockTagging = [OCMockObject partialMockForObject:tagging];
    
    [[mockTagging expect] trackFileDownload:[OCMArg checkWithBlock:^(id value) {
        
        /* return YES if value is ok */
        if ([value isEqualToString:@"video.mp4"]) {
            return YES;
        }
        return NO;
        
    }]];
    
    
    [mockTagging trackFileDownload:@"video.mp4"];
    [mockTagging verify];
}
-(void)testFileDownloadShouldCallTrackAction{
    
    AIAppTagging *tagging = [[AIAppTagging alloc]initWithAppInfra:objAppInfra];
    id  mockTagging = [OCMockObject partialMockForObject:tagging];
    
    
    [[mockTagging expect] trackActionWithInfo:[OCMArg checkWithBlock:^(id value) {
        
        /* return YES if value is ok */
        if ([value isEqualToString:@"sendData"]) {
            return YES;
        }
        return NO;
        
    }]
     
                                       params:[OCMArg checkWithBlock:^(id value) {
        
        /* return YES if value is ok */
        if ([[value objectForKey:@"fileName" ] isEqualToString:@"upload.txt"]) {
            return YES;
        }
        return NO;
        
    }]
     ];
    
    
    [mockTagging trackFileDownload:@"upload.txt"];
    [mockTagging verify];
}


-(void)testGetAnalyticsDefaultParams
{
    
    AIAppTagging *obj = [[AIAppTagging alloc]initWithAppInfra:objAppInfra];
    NSDictionary *dictParams = [obj getAnalyticsDefaultParams];
    NSArray *arrSensitiveDataKeys = [objAppInfra.appConfig getDefaultPropertyForKey:@"tagging.sensitiveData" group:@"appinfra" error:nil];
    
    NSArray *ParamsKeys = dictParams.allKeys;
    
    NSSet *setDefaultParamsdata = [[NSSet alloc]initWithArray:ParamsKeys];
    NSSet *setSensitivedata = [[NSSet alloc]initWithArray:arrSensitiveDataKeys];
    
    XCTAssertTrue([setSensitivedata isSubsetOfSet:setDefaultParamsdata]);
    
}

-(void)testSetPrivacyConsentForSensitiveData
{
    [objAppInfra.tagging setPrivacyConsentForSensitiveData:YES];
    XCTAssertTrue([objAppInfra.tagging getPrivacyConsentForSensitiveData]);
}

-(void)testSetPrivacyConsentForSensitiveDataNegative
{
    [objAppInfra.tagging setPrivacyConsentForSensitiveData:YES];
    XCTAssertFalse(![objAppInfra.tagging getPrivacyConsentForSensitiveData]);
}

-(void)testTrackingIdentifier{
    NSString* trackingId = [objAppInfra.tagging getTrackingIdentifier];
    NSString* adobeTrackingId = [ADBMobile trackingIdentifier];
    XCTAssertEqualObjects(trackingId, adobeTrackingId);
}

-(void)testTrackingIdentifierShouldCallAdobeTrackingIdentifier{
    id adobeMock = [OCMockObject mockForClass:[ADBMobile class]];
    NSString *testId = @"testtrackingidentifier";
    [[[adobeMock expect] andReturn:testId] trackingIdentifier];
    XCTAssertEqualObjects(testId, [objAppInfra.tagging getTrackingIdentifier]);
    [adobeMock verify];

}

-(void)testPostTaggingData
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"testValue1",@"testValue2",@"testKey1",@"testKey2", nil];
    
    AIAppTagging*obj = [[AIAppTagging alloc]init];
    [obj postTaggingData:dict];

    NSString *notificationName = kAilTaggingNotification;
    id observerMock = [OCMockObject observerMock];
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock name:notificationName object:self];
    [[observerMock expect]
     notificationWithName:notificationName
     object:self
     userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
        id value = [userInfo objectForKey:@"testKey1"];
        XCTAssertEqualObjects(@"testValue1", value);
        return YES;
    }]];

     [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
}

-(void)testClickStreamHandlerCreation
{
    XCTAssertNotNil(objAppInfra.tagging.getClickStreamConsentHandler);
}

-(void)testClickStreamHandlerCreatesOnlyOnce
{
    XCTAssertEqual(objAppInfra.tagging.getClickStreamConsentHandler, objAppInfra.tagging.getClickStreamConsentHandler);
}

-(void)testClickStreamHandlerIdentifier
{
    XCTAssertNotNil(objAppInfra.tagging.getClickStreamConsentIdentifier);
}

#pragma mark - pagename  and event name validation tests

-(void)testValidateLongPagename {
    id loggingMock = OCMClassMock([AIInternalLogger class]);
    objAppInfra.appInfraLogger = loggingMock;
    
    [objAppInfra.tagging trackPageWithInfo:@"100byteText100byteText100byteText100byteText100byteText100byteText100byteText100byteText100byteText100byteText" params:nil];
    
    OCMVerify([loggingMock log:AILogLevelError eventId:@"AITagging" message:@"tagging page name exceeds 100 bytes in length"]);
    
    [loggingMock stopMocking];
}

-(void)testValidateShortPagename {
    id loggingMock = OCMClassMock([AILogging class]);
    objAppInfra.appInfraLogger = loggingMock;
    
    [[loggingMock reject] log:AILogLevelError eventId:@"AppTagging" message:@"tagging page name exceeds 100 bytes in length"];
    
    [objAppInfra.tagging trackPageWithInfo:@"short page name" params:nil];
    [loggingMock verify];
    [loggingMock stopMocking];
}

-(void)testValidateNILPagename {
    id loggingMock = OCMClassMock([AIInternalLogger class]);
    objAppInfra.appInfraLogger = loggingMock;
    
    NSString * pagename = nil;
    [objAppInfra.tagging trackPageWithInfo:pagename params:nil];
    
    OCMVerify([loggingMock log:AILogLevelError eventId:@"AITagging" message:@"pagename is nil"]);
    
    [loggingMock stopMocking];
}

-(void)testValidateEqualPagename {
    id loggingMock = OCMClassMock([AIInternalLogger class]);
    objAppInfra.appInfraLogger = loggingMock;
    
    [objAppInfra.tagging trackPageWithInfo:@"page1" params:nil];
    [objAppInfra.tagging trackPageWithInfo:@"page1" params:nil];
    
    OCMVerify([loggingMock log:AILogLevelError eventId:@"AITagging" message:@"tagging pagename and previous pagename are equal"]);
    
    [loggingMock stopMocking];
}

-(void)testValidateDifferentPagename {
    id loggingMock = OCMClassMock([AILogging class]);
    objAppInfra.appInfraLogger = loggingMock;
    
    [[loggingMock reject] log:AILogLevelError eventId:@"AITagging" message:@"tagging pagename and previous pagename are equal"];
    
    [objAppInfra.tagging trackPageWithInfo:@"page1" params:nil];
    [objAppInfra.tagging trackPageWithInfo:@"page2" params:nil];
    
    [loggingMock verify];
    [loggingMock stopMocking];
}

-(void)testValidateLongEventname {
    id loggingMock = OCMClassMock([AIInternalLogger class]);
    objAppInfra.appInfraLogger = loggingMock;
    
    [objAppInfra.tagging trackActionWithInfo:@"255byteText255byteText255byteText255byteText255byteText255byteText255byteText255byteText255byteText255byteText255byteText255byteText255byteText255byteText255byteText255byteText255byteText255byteText255byteText255byteText255byteText255byteText255byteText255byteText" params:nil];
    
    OCMVerify([loggingMock log:AILogLevelError eventId:@"AITagging" message:@"tagging event names should not exceed  255 bytes in length"]);
    
    [loggingMock stopMocking];
}

-(void)testValidateShortEventname {
    id loggingMock = OCMClassMock([AILogging class]);
    objAppInfra.appInfraLogger = loggingMock;
    
    [[loggingMock reject] log:AILogLevelError eventId:@"App Tagging" message:@"tagging event names should not exceed  255 bytes in length"];
    
    [objAppInfra.tagging trackPageWithInfo:@"short event name" params:nil];
    [loggingMock verify];
    [loggingMock stopMocking];
}
    
-(void)testEnableAdobeLogs {
    [objAppInfra.appConfig setPropertyForKey:@"enableAdobeLogs" group:@"appinfra" value:@YES error:nil];
    AIAppTagging * tagging1 = [[AIAppTagging alloc]initWithAppInfra:objAppInfra];
    NSLog(@"%@", tagging1);
    XCTAssertTrue(ADBMobile.debugLogging);
    
    [objAppInfra.appConfig setPropertyForKey:@"enableAdobeLogs" group:@"appinfra" value:@NO error:nil];
    AIAppTagging * tagging2 = [[AIAppTagging alloc]initWithAppInfra:objAppInfra];
    XCTAssertFalse(ADBMobile.debugLogging);
    NSLog(@"%@", tagging2);
}
-(void)testSetPrivacyshouldTagForOptIN {
    id mock = OCMClassMock([ADBMobile class]);
    OCMStub([mock trackingIdentifier]).andReturn(@"AdobeIDForUnitTesting");
    [[mock expect] setPrivacyStatus:ADBMobilePrivacyStatusOptIn];
    [objAppInfra.tagging setPrivacyConsent:AIATPrivacyStatusOptIn];
    [mock verify];
}
-(void)testSetPrivacyshouldTagForOptOut {
    id mock = OCMClassMock([ADBMobile class]);
    OCMStub([mock trackingIdentifier]).andReturn(@"AdobeIDForUnitTesting");
    [[mock expect] setPrivacyStatus:ADBMobilePrivacyStatusOptIn];
    [objAppInfra.tagging setPrivacyConsent:AIATPrivacyStatusOptOut];
    [mock verify];
}
-(void)testSetPrivacyshouldTagForUnknown {
    id mock = OCMClassMock([ADBMobile class]);
    OCMStub([mock trackingIdentifier]).andReturn(@"AdobeIDForUnitTesting");
    [[mock expect] setPrivacyStatus:ADBMobilePrivacyStatusUnknown];
    [objAppInfra.tagging setPrivacyConsent:AIATPrivacyStatusUnknown];
    [mock verify];
}

-(void)testPrivacyStatusSetToOptInIfDefaultValueIsOptOff {
    [objAppInfra.tagging setPrivacyConsent:AIATPrivacyStatusOptOut];
    XCTAssertEqual([ADBMobile privacyStatus], ADBMobilePrivacyStatusOptIn);
    XCTAssertEqual([AIAppTaggingPrivacyStatus getPrivacyStatus], ADBMobilePrivacyStatusOptOut);
}

-(void)testGetPrivacyConsentForOptUnknown {
    AIAppTagging *tagging = [[AIAppTagging alloc]initWithAppInfra:objAppInfra];
    [tagging setPrivacyConsent:AIATPrivacyStatusUnknown];
    XCTAssertEqual([tagging getPrivacyConsent], AIATPrivacyStatusUnknown);
    XCTAssertEqual([AIAppTaggingPrivacyStatus getPrivacyStatus], AIATPrivacyStatusUnknown);
}

-(void)testGetPrivacyConsentForOptOff {
    AIAppTagging *tagging = [[AIAppTagging alloc]initWithAppInfra:objAppInfra];
    [tagging setPrivacyConsent:AIATPrivacyStatusOptOut];
    XCTAssertEqual([tagging getPrivacyConsent], AIATPrivacyStatusOptOut);
    XCTAssertEqual([AIAppTaggingPrivacyStatus getPrivacyStatus], AIATPrivacyStatusOptOut);
}

-(void)testGetPrivacyConsentForOptIn {
    AIAppTagging *tagging = [[AIAppTagging alloc]initWithAppInfra:objAppInfra];
    [tagging setPrivacyConsent:AIATPrivacyStatusOptIn];
    XCTAssertEqual([tagging getPrivacyConsent], AIATPrivacyStatusOptIn);
    XCTAssertEqual([AIAppTaggingPrivacyStatus getPrivacyStatus], AIATPrivacyStatusOptIn);
}

-(void)testTrackActionIsNotInvokedWhenOptOff {
    AIAppTagging *tagging = [[AIAppTagging alloc]initWithAppInfra:objAppInfra];
    [tagging setPrivacyConsent:AIATPrivacyStatusOptOut];
    id adbMock = OCMClassMock([ADBMobile class]);
    OCMReject([adbMock trackAction:nil data:nil]);
    [tagging postActionWithApplicationState:nil withDict:nil];
    [adbMock verify];
}

-(void)testTrackActionFromBackgroundIsNotInvokedWhenOptOff {
    id applicationMock = [OCMockObject partialMockForObject:[UIApplication sharedApplication]];
    OCMStub([applicationMock applicationState]).andReturn(UIApplicationStateBackground);
    [[[mockedObject expect] andDo:^(NSInvocation *invocation) {
        
        __unsafe_unretained  NSString *strButtonName;
        __unsafe_unretained  NSDictionary *dictParam;
        [invocation getArgument:&strButtonName atIndex:2];
        [invocation getArgument:&dictParam atIndex:3];
        XCTAssertEqualObjects(strButtonName, @"testButtonName");
        XCTAssertTrue([dictParam.allKeys containsObject:@"testKey"]);
        if([dictParam.allKeys containsObject:@"testKey"])
            XCTAssertEqualObjects([dictParam objectForKey:@"testKey"], @"testValue");
        
    }] trackAction:[OCMArg any] data:[OCMArg any]];
    AIAppTagging *obj = [[AIAppTagging alloc]init];
    
    [obj postActionWithApplicationState:@"testButtonName" withDict:@{@"testKey":@"testValue"}];
    OCMVerify(mockedObject);
}

-(void)testPostTaggingDataIsNotInvokedWhenOptOff {
    AIAppTagging *tagging = [[AIAppTagging alloc]initWithAppInfra:objAppInfra];
    [tagging setPrivacyConsent:AIATPrivacyStatusOptOut];
    id adbMock = OCMClassMock([ADBMobile class]);
    OCMReject([adbMock trackState:nil data:nil]);
    [tagging postPageData:nil withDict:nil];
    [adbMock verify];
}

-(void)testTrackTimedActionStartIsNotInvokedWhenOptOff {
    AIAppTagging *tagging = [[AIAppTagging alloc]initWithAppInfra:objAppInfra];
    [tagging setPrivacyConsent:AIATPrivacyStatusOptOut];
    id adbMock = OCMClassMock([ADBMobile class]);
    OCMReject([adbMock trackTimedActionStart:nil data:nil]);
    [tagging trackTimedActionStart:nil data:nil];
    [adbMock verify];
}

-(void)testTrackTimedActionEndIsNotInvokedWhenOptOff {
    AIAppTagging *tagging = [[AIAppTagging alloc]initWithAppInfra:objAppInfra];
    [tagging setPrivacyConsent:AIATPrivacyStatusOptOut];
    id adbMock = OCMClassMock([ADBMobile class]);
    OCMReject([adbMock trackTimedActionEnd:nil logic:nil]);
    [tagging trackTimedActionEnd:nil logic:nil];
    [adbMock verify];
}

@end
