//
//  AILoggingTests.m
//  AppInfra
//
//  Created by Philips on 08/05/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AILogging.h"
#import "AILoggingProtocol.h"
#import "NSBundle+Bundle.h"

@interface AILogging(AILoggingTest)

- (AICloudLogMetadata *)cloudLogMetaData;
- (AILoggingConfig *)getConfiguration;
- (BOOL)shouldComponentFilteredOut;

@end

@interface AILoggingTests : XCTestCase

@property(nonatomic, strong)AILogging * logging;

@end

@implementation AILoggingTests

- (void)setUp {
    [super setUp];
    [NSBundle loadSwizzler];
    AIAppInfra *testAppInfra = [[AIAppInfra alloc] initWithBuilder:nil];
    self.logging = [[AILogging alloc]initWithAppInfra:testAppInfra];
}

- (void)tearDown {
    self.logging = nil;
    [NSBundle deSwizzele];
    [super tearDown];
}

- (void)testCreateInstanceForComponent {
    id loggingWrapper = [self.logging createInstanceForComponent:@"AITest" componentVersion:@"1.0"];
    XCTAssertNotNil(loggingWrapper, @"Log instance should not be nil");
    XCTAssertTrue([loggingWrapper conformsToProtocol:@protocol(AILoggingProtocol)]);
}

- (void)testCloudLoggingConsentIdentifier {
    NSString *testCloudConsentIdentifier = [self.logging getCloudLoggingConsentIdentifier];
    XCTAssertEqualObjects(testCloudConsentIdentifier, @"AIL_CloudConsent", @"Both identifiers should be equal");
}

- (void)testCloudLogMetaData {
    AICloudLogMetadata *testCloudMetaData = [self.logging cloudLogMetaData];
    XCTAssertNotNil(testCloudMetaData, @"Cloud log meta data should not be nil");
}

- (void)testGetConfiguration {
    AILoggingConfig *testLoggingConfig = [self.logging getConfiguration];
    XCTAssertNotNil(testLoggingConfig, @"Logging config data should not be nil");
}

- (void)testShouldComponentFilteredOut {
    BOOL shouldComponentFilteredOut = [self.logging shouldComponentFilteredOut];
    XCTAssertFalse(shouldComponentFilteredOut == true);
}

- (void)testLogging {
    id loggingWrapper = [self.logging createInstanceForComponent:@"AITest" componentVersion:@"1.0"];
    XCTAssertNoThrow([loggingWrapper log:AILogLevelError eventId:@"Unit test" message:@"Unit test"]);
    NSDictionary *testDict = @{@"key":@"value"};
    XCTAssertNoThrow([loggingWrapper log:AILogLevelError eventId:@"Unit test" message:@"Unit test" dictionary:testDict]);
    XCTAssertNoThrow([loggingWrapper log:AILogLevelError eventId:@"Unit test" message:@"Unit test" dictionary:nil]);
}

@end
