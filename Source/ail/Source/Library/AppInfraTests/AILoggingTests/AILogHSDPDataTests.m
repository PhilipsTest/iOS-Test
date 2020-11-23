//
//  AILogHSDPDataTests.m
//  AppInfraTests
//
//  Created by Chittaranjan Sahu on 10/3/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OCMock/OCMock.h"
#import "AIAppConfigurationProtocol.h"
#import "NSBundle+Bundle.h"
#import <AppInfra/AppInfra-Swift.h>
#import "AIAppConfiguration.h"
@import AppInfra;

@interface AILogHSDPDataTests : XCTestCase

@end

@implementation AILogHSDPDataTests

- (void)setUp {
    [super setUp];
    [NSBundle loadSwizzler];
}

- (void)tearDown {
    [NSBundle deSwizzele];
    [super tearDown];
}

- (void)testHSDPDataModel {
    AIAppInfra* appinfraMock = OCMClassMock([AIAppInfra class]);
    
    OCMStub([[appinfraMock appConfig] getPropertyForKey:HsdpData.acSecretKeyName group:HsdpData.acGroupName error:nil]).andReturn(@"hsdpSecretData");
    OCMStub([[appinfraMock appConfig] getPropertyForKey:HsdpData.acSharedKeyName group:HsdpData.acGroupName error:nil]).andReturn(@"hsdpSharedData");
    OCMStub([[appinfraMock appConfig] getPropertyForKey:HsdpData.acProductKeyName group:HsdpData.acGroupName error:nil]).andReturn(@"hsdpProductData");
    
    AIAppConfiguration *appConfiguration = [[AIAppConfiguration alloc] initWithAppInfra:appinfraMock];
    HsdpData *testData = [[HsdpData alloc] initWithAppConfig:appConfiguration];
    XCTAssertNotNil(testData, @"HSDP data returned is nil");
}

@end
