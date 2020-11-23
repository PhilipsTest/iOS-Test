//
//  AILoggingUtilitiesTest.m
//  AppInfraTests
//
//  Created by Hashim MH on 03/05/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AILogUtilities.h"
#import "AIRESTClientInterface.h"
#import <OCMock/OCMock.h>
#import "AIAppIdentityProtocol.h"
#import "AILoggingProtocol.h"

@interface AILoggingUtilitiesTest : XCTestCase

@end

@implementation AILoggingUtilitiesTest

-(void)testNetworkTypeFromRESTClientMobileData{
    AIRESTClientInterface *rest = [[AIRESTClientInterface alloc]init];
    id restMock = OCMPartialMock(rest);
    OCMExpect([restMock getNetworkReachabilityStatus]).andReturn(AIRESTClientReachabilityStatusReachableViaWWAN);
    NSString *networkType = [AILogUtilities networkTypeFromRESTClient:restMock];
    XCTAssertEqualObjects(@"MOBILE_DATA", networkType);
    OCMVerifyAll(restMock);
}

-(void)testNetworkTypeFromRESTClientWiFi{
    AIRESTClientInterface *rest = [[AIRESTClientInterface alloc]init];
    id restMock = OCMPartialMock(rest);
    OCMExpect([restMock getNetworkReachabilityStatus]).andReturn(AIRESTClientReachabilityStatusReachableViaWiFi);
    NSString *networkType = [AILogUtilities networkTypeFromRESTClient:restMock];
    XCTAssertEqualObjects(@"WIFI", networkType);
    OCMVerifyAll(restMock);
}

-(void)testNetworkTypeFromRESTClientOffline{
    AIRESTClientInterface *rest = [[AIRESTClientInterface alloc]init];
    id restMock = OCMPartialMock(rest);
    OCMExpect([restMock getNetworkReachabilityStatus]).andReturn(AIRESTClientReachabilityStatusNotReachable);
    NSString *networkType = [AILogUtilities networkTypeFromRESTClient:restMock];
    XCTAssertEqualObjects(@"NO_NETWORK", networkType);
    OCMVerifyAll(restMock);
}

- (void)testStateString {
    XCTAssertEqualObjects(@"TEST", [AILogUtilities stateString:AIAIAppStateTEST]);
    XCTAssertEqualObjects(@"DEVELOPMENT", [AILogUtilities stateString:AIAIAppStateDEVELOPMENT]);
    XCTAssertEqualObjects(@"STAGING", [AILogUtilities stateString:AIAIAppStateSTAGING]);
    XCTAssertEqualObjects(@"ACCEPTANCE", [AILogUtilities stateString:AIAIAppStateACCEPTANCE]);
    XCTAssertEqualObjects(@"PRODUCTION", [AILogUtilities stateString:AIAIAppStatePRODUCTION]);
    XCTAssertEqualObjects(@"", [AILogUtilities stateString:111]);

}

-(void)testLogId{
   NSString *logId =  [AILogUtilities generateLogId];
    XCTAssertNotNil(logId);
    XCTAssertTrue([logId isKindOfClass:[NSString class]]);
    XCTAssertEqual(logId.length, 36);
}

-(void)testDeviceName{
    NSString *deviceName =  [AILogUtilities deviceName];
    XCTAssertNotNil(deviceName);
    XCTAssertTrue([deviceName isKindOfClass:[NSString class]]);
    NSArray *expectedDeviceType = @[@"x86_64",@"iPhone",@"iPad"];
    XCTAssertTrue([expectedDeviceType containsObject:deviceName]);
}

-(void)testlogLevel{
    XCTAssertEqualObjects(@"ERROR", [AILogUtilities logLevel:DDLogFlagError]);
    XCTAssertEqualObjects(@"WARNING", [AILogUtilities logLevel:DDLogFlagWarning]);
    XCTAssertEqualObjects(@"INFO", [AILogUtilities logLevel:DDLogFlagInfo]);
    XCTAssertEqualObjects(@"DEBUG", [AILogUtilities logLevel:DDLogFlagDebug]);
    XCTAssertEqualObjects(@"VERBOSE", [AILogUtilities logLevel:DDLogFlagVerbose]);
}

-(void)testsystemInfo{
    NSString *systemInfo =  [AILogUtilities systemInfo];
    XCTAssertNotNil(systemInfo);
    XCTAssertTrue([systemInfo isKindOfClass:[NSString class]]);
    BOOL osInfoPesent =  [systemInfo containsString:@"iOS"];
    BOOL seperatorPresent =  [systemInfo containsString:@"/"];
    XCTAssertTrue(osInfoPesent&&seperatorPresent);
}

-(void)testaiFlagtoDDLogFlag{
    XCTAssertEqual(DDLogFlagError, [AILogUtilities aiFlagtoDDLogFlag:AILogLevelError]);
    XCTAssertEqual(DDLogFlagError, [AILogUtilities aiFlagtoDDLogFlag:0]);
    XCTAssertEqual(DDLogFlagWarning, [AILogUtilities aiFlagtoDDLogFlag:AILogLevelWarning]);
    XCTAssertEqual(DDLogFlagWarning, [AILogUtilities aiFlagtoDDLogFlag:1]);
    XCTAssertEqual(DDLogFlagInfo, [AILogUtilities aiFlagtoDDLogFlag:AILogLevelInfo]);
    XCTAssertEqual(DDLogFlagInfo, [AILogUtilities aiFlagtoDDLogFlag:2]);
    XCTAssertEqual(DDLogFlagDebug, [AILogUtilities aiFlagtoDDLogFlag:AILogLevelDebug]);
    XCTAssertEqual(DDLogFlagDebug, [AILogUtilities aiFlagtoDDLogFlag:3]);
    XCTAssertEqual(DDLogFlagVerbose, [AILogUtilities aiFlagtoDDLogFlag:AILogLevelVerbose]);
    XCTAssertEqual(DDLogFlagVerbose, [AILogUtilities aiFlagtoDDLogFlag:4]);
}
@end
