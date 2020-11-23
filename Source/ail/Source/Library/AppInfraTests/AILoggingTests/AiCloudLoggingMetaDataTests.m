//
//  AiCloudLoggingMetaDataTests.m
//  AppInfraTests
//
//  Created by Hashim MH on 09/05/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AICloudLogMetadata.h"
#import <OCMock/OCMock.h>
#import "NSBundle+Bundle.h"
#import "AILogging.h"

@interface AICloudLogMetadata()
@property(nonatomic, weak) AIAppInfra *appInfra;
@end

@interface AILogging()
@property (nonatomic, strong) AICloudLogMetadata *cloudLogMetaData;
@end

@interface AiCloudLoggingMetaDataTests : XCTestCase

@end

@implementation AiCloudLoggingMetaDataTests

- (void)setUp {
    [super setUp];
    [NSBundle loadSwizzler];
}

- (void)tearDown {
	[NSBundle deSwizzele];
    [super tearDown];
}

- (void)testCloudLogMetaDataShouldBeIntializedWithAppInfra {
    id appinfraMock = OCMClassMock([AIAppInfra class]);
    AICloudLogMetadata *cloudData = [[AICloudLogMetadata alloc]initWithAppInfra:appinfraMock];
    XCTAssertNotNil(cloudData);
    XCTAssertEqualObjects(cloudData.appInfra,appinfraMock);
}

- (void)testCloudLogMetaDataShouldUpdateAppIdFromAppInfraTagging {
    NSString *testAppsId = @"testTrackingid123";
    AIAppInfra* appinfraMock = OCMClassMock([AIAppInfra class]);
    id taggingMock  = OCMProtocolMock(@protocol(AIAppTaggingProtocol));
    OCMExpect([appinfraMock tagging]).andReturn(taggingMock);
    OCMExpect([appinfraMock tagging]).andReturn(taggingMock);
    OCMExpect([taggingMock getTrackingIdentifier]).andReturn(testAppsId);
    OCMExpect([taggingMock getTrackingIdentifier]).andReturn(testAppsId);
    
    AICloudLogMetadata *cloudData = [[AICloudLogMetadata alloc]initWithAppInfra:appinfraMock];
    [cloudData updateInfo];
    OCMVerifyAll(taggingMock);
    XCTAssertEqualObjects(cloudData.appId, testAppsId);
}

- (void)testCloudLogMetaDataShouldUpdateAppNameFromAppInfraAppIdentity {
    NSString *testAppName = @"testAppname123";
    AIAppInfra* appinfraMock = OCMClassMock([AIAppInfra class]);
    id identityMock  = OCMProtocolMock(@protocol(AIAppIdentityProtocol));
    OCMStub([appinfraMock appIdentity]).andReturn(identityMock);
    OCMExpect([identityMock getAppName]).andReturn(testAppName);
    OCMExpect([identityMock getAppName]).andReturn(testAppName);
    
    AICloudLogMetadata *cloudData = [[AICloudLogMetadata alloc]initWithAppInfra:appinfraMock];
    [cloudData updateInfo];
    OCMVerifyAll(identityMock);
    XCTAssertEqualObjects(cloudData.appName, testAppName);
}

- (void)testCloudLogMetaDataShouldUpdateAppStateFromAppInfraAppIdentity {
    AIAIAppState testAppState = AIAIAppStateSTAGING;
    AIAppInfra* appinfraMock = OCMClassMock([AIAppInfra class]);
    id identityMock  = OCMProtocolMock(@protocol(AIAppIdentityProtocol));
    OCMStub([appinfraMock appIdentity]).andReturn(identityMock);
    OCMExpect([identityMock getAppState]).andReturn(testAppState);
    
    AICloudLogMetadata *cloudData = [[AICloudLogMetadata alloc]initWithAppInfra:appinfraMock];
    [cloudData updateInfo];
    OCMVerifyAll(identityMock);
    XCTAssertEqualObjects(@"STAGING", cloudData.appState);
}
- (void)testCloudLogMetaDataShouldUpdateAppVersionFromAppInfraAppIdentity {
    NSString *appVersion = @"1.22.333";
    AIAppInfra* appinfraMock = OCMClassMock([AIAppInfra class]);
    id identityMock  = OCMProtocolMock(@protocol(AIAppIdentityProtocol));
    OCMStub([appinfraMock appIdentity]).andReturn(identityMock);
    OCMExpect([identityMock getAppVersion]).andReturn(appVersion);
    OCMExpect([identityMock getAppVersion]).andReturn(appVersion);
    
    AICloudLogMetadata *cloudData = [[AICloudLogMetadata alloc]initWithAppInfra:appinfraMock];
    [cloudData updateInfo];
    OCMVerifyAll(identityMock);
    XCTAssertEqualObjects(appVersion, cloudData.appVersion);
}

- (void)testCloudLogMetaDataShouldUpdateLocaleFromAppInfraInternationalization {
    NSString *appLocale = @"en_IN";
    AIAppInfra* appinfraMock = OCMClassMock([AIAppInfra class]);
    id intMock  = OCMProtocolMock(@protocol(AIInternationalizationProtocol));
    OCMStub([appinfraMock internationalization]).andReturn(intMock);
    OCMExpect([intMock getUILocaleString]).andReturn(appLocale);
    OCMExpect([intMock getUILocaleString]).andReturn(appLocale);
    
    AICloudLogMetadata *cloudData = [[AICloudLogMetadata alloc]initWithAppInfra:appinfraMock];
    [cloudData updateInfo];
    OCMVerifyAll(intMock);
    XCTAssertEqualObjects(appLocale, cloudData.locale);
}

- (void)testCloudLogMetaDataShouldUpdateCountryFromAppInfraServiceDiscovery{
    NSString *testCountry = @"IN";
    AIAppInfra* appinfraMock = OCMClassMock([AIAppInfra class]);
    id sdMock  = OCMProtocolMock(@protocol(AIServiceDiscoveryProtocol));
    OCMStub([appinfraMock serviceDiscovery]).andReturn(sdMock);
    OCMExpect([sdMock getHomeCountry]).andReturn(testCountry);
    OCMExpect([sdMock getHomeCountry]).andReturn(testCountry);
    
    AICloudLogMetadata *cloudData = [[AICloudLogMetadata alloc]initWithAppInfra:appinfraMock];
    [cloudData updateInfo];
    OCMVerifyAll(sdMock);
    XCTAssertEqualObjects(testCountry, cloudData.homeCountry);
}

- (void)testCloudLogMetaDataShouldUpdateNWTypeFromAppInfraRESTClient{
    AIRESTClientReachabilityStatus nwType = AIRESTClientReachabilityStatusReachableViaWWAN;
    AIAppInfra* appinfraMock = OCMClassMock([AIAppInfra class]);
    id restMock  = OCMProtocolMock(@protocol(AIRESTClientProtocol));
    OCMStub([appinfraMock RESTClient]).andReturn(restMock);
    OCMExpect([restMock getNetworkReachabilityStatus]).andReturn(nwType);
    
    AICloudLogMetadata *cloudData = [[AICloudLogMetadata alloc]initWithAppInfra:appinfraMock];
    [cloudData updateInfo];
    OCMVerifyAll(restMock);
    XCTAssertEqualObjects(@"MOBILE_DATA", cloudData.networkType);
}

- (void)testCloudLogMetaDataShouldUpdateCountryFromAppInfraServiceDiscoveryWhenUpdateHomeCountry{
    NSString *testCountry = @"IN";
    AIAppInfra* appinfraMock = OCMClassMock([AIAppInfra class]);
    id sdMock  = OCMProtocolMock(@protocol(AIServiceDiscoveryProtocol));
    OCMStub([appinfraMock serviceDiscovery]).andReturn(sdMock);
    OCMExpect([sdMock getHomeCountry]).andReturn(testCountry);
    OCMExpect([sdMock getHomeCountry]).andReturn(testCountry);
    
    AICloudLogMetadata *cloudData = [[AICloudLogMetadata alloc]initWithAppInfra:appinfraMock];
    [cloudData updateHomeCountry];
    OCMVerifyAll(sdMock);
    XCTAssertEqualObjects(testCountry, cloudData.homeCountry);
}

- (void)testCloudLogMetaDataShouldUpdateCountryFromAppInfraServiceDiscoveryOnCountryChange{
    NSString *testCountry = @"AA";
    AIAppInfra* appinfra = [[AIAppInfra alloc]initWithBuilder:nil];
    [appinfra.serviceDiscovery setHomeCountry:testCountry];
    AICloudLogMetadata *cloudData = ((AILogging*)(appinfra.logging)).cloudLogMetaData;
    id cloudDataMock  = OCMPartialMock(cloudData);
    XCTAssertEqualObjects(testCountry, cloudData.homeCountry);
    
    OCMExpect([cloudDataMock updateHomeCountry]);
    NSString *newCountry = @"BB";
    [appinfra.serviceDiscovery setHomeCountry:newCountry];
    OCMVerifyAll(cloudDataMock);
}
- (void)testCloudLogMetaDataShouldUpdateNWTypeFromAppInfraRESTClientWhenUpdateNetwork{
    AIRESTClientReachabilityStatus nwType = AIRESTClientReachabilityStatusReachableViaWWAN;
    AIAppInfra* appinfraMock = OCMClassMock([AIAppInfra class]);
    id restMock  = OCMProtocolMock(@protocol(AIRESTClientProtocol));
    OCMStub([appinfraMock RESTClient]).andReturn(restMock);
    OCMExpect([restMock getNetworkReachabilityStatus]).andReturn(nwType);
    
    AICloudLogMetadata *cloudData = [[AICloudLogMetadata alloc]initWithAppInfra:appinfraMock];
    [cloudData updateNetworkType];
    OCMVerifyAll(restMock);
    XCTAssertEqualObjects(@"MOBILE_DATA", cloudData.networkType);
}
- (void)testCloudLogMetaDataShouldUpdateCountryFromAppInfraServiceDiscoveryOnNetworkChange{
    AIAppInfra* appinfra = [[AIAppInfra alloc]initWithBuilder:nil];
    AICloudLogMetadata *cloudData = ((AILogging*)(appinfra.logging)).cloudLogMetaData;
    id cloudDataMock  = OCMPartialMock(cloudData);
    OCMExpect([cloudDataMock updateNetworkType]);
    [[NSNotificationCenter defaultCenter]postNotificationName:kAILReachabilityChangedNotification object:nil];
    OCMVerifyAll(cloudDataMock);
}

@end
