//
//  AILoggingConfigTest.m
//  AppInfraTests
//
//  Created by philips on 4/25/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AILoggingConfig.h"

@interface AILoggingConfigTest : XCTestCase
    
@property(nonatomic, strong) AILoggingConfig *aiLoggingConfig;
@property(nonatomic, strong) NSMutableDictionary *configDict;

@end

@implementation AILoggingConfigTest

- (void)setUp {
    [super setUp];
    
    self.configDict = [[NSMutableDictionary alloc] init];
    [self.configDict setValue:@"AppInfraLog" forKey:@"fileName"];
    [self.configDict setValue:[NSNumber numberWithInteger:5] forKey:@"numberOfFiles"];
    [self.configDict setValue:[NSNumber numberWithInteger:50000] forKey:@"fileSizeInBytes"];
    [self.configDict setValue:@"All" forKey:@"logLevel"];
    [self.configDict setValue:[NSNumber numberWithBool:YES] forKey:@"fileLogEnabled"];
    [self.configDict setValue:[NSNumber numberWithBool:YES] forKey:@"consoleLogEnabled"];
    [self.configDict setValue:@[@"ail",@"comp1"] forKey:@"componentIds"];
    [self.configDict setValue:[NSNumber numberWithBool:YES] forKey:@"cloudLogEnabled"];
    [self.configDict setValue:[NSNumber numberWithInteger:15] forKey:@"cloudBatchLimit"];
}

- (void)testAILoggingConfigCloudEnabled {
   self.aiLoggingConfig = [[AILoggingConfig alloc] initWithConfig:self.configDict];
    XCTAssertEqual(self.aiLoggingConfig.cloudLogEnabled,YES);
    XCTAssertEqual(self.aiLoggingConfig.cloudBatchLimit, 15);
}
    
- (void)testAILoggingConfigCloudDisabled {
    [self.configDict setValue:[NSNumber numberWithBool:NO] forKey:@"cloudLogEnabled"];
    self.aiLoggingConfig = [[AILoggingConfig alloc] initWithConfig:self.configDict];
    XCTAssertEqual(self.aiLoggingConfig.cloudLogEnabled,NO);
    XCTAssertEqual(self.aiLoggingConfig.cloudBatchLimit, 15);
}
    
- (void)testAILoggingConfigCloudBatchLimitGreaterThan25 {
    [self.configDict setValue:[NSNumber numberWithInteger:30] forKey:@"cloudBatchLimit"];
    self.aiLoggingConfig = [[AILoggingConfig alloc] initWithConfig:self.configDict];
    XCTAssertEqual(self.aiLoggingConfig.cloudLogEnabled,YES);
    XCTAssertEqual(self.aiLoggingConfig.cloudBatchLimit, 25);
}
    
- (void)testAILoggingConfigCloudBatchLimitLessThan0 {
    [self.configDict setValue:[NSNumber numberWithInteger:-5] forKey:@"cloudBatchLimit"];
    self.aiLoggingConfig = [[AILoggingConfig alloc] initWithConfig:self.configDict];
    XCTAssertEqual(self.aiLoggingConfig.cloudLogEnabled,YES);
    XCTAssertEqual(self.aiLoggingConfig.cloudBatchLimit, 25);
}

- (void)testAILoggingConfigCloudBatchLimitNotDefined {
    [self.configDict removeObjectForKey:@"cloudBatchLimit"];
    self.aiLoggingConfig = [[AILoggingConfig alloc] initWithConfig:self.configDict];
    XCTAssertEqual(self.aiLoggingConfig.cloudLogEnabled,YES);
    XCTAssertEqual(self.aiLoggingConfig.cloudBatchLimit, 5);
}

-(void)testallValuesAreInitialized {
    NSArray * array = @[@"ail",@"comp1"];
    self.aiLoggingConfig = [[AILoggingConfig alloc] initWithConfig:self.configDict];
    XCTAssertEqual(self.aiLoggingConfig.fileName, @"AppInfraLog");
    XCTAssertEqual(self.aiLoggingConfig.numberOfFiles, 5);
    XCTAssertEqual(self.aiLoggingConfig.fileSizeInBytes, 50000);
    XCTAssertEqual(self.aiLoggingConfig.logLevel,DDLogLevelAll);
    XCTAssertEqual(self.aiLoggingConfig.fileLogEnabled, YES);
    XCTAssertEqual(self.aiLoggingConfig.consoleLogEnabled, YES);
    XCTAssertEqual(self.aiLoggingConfig.componentIds.count,array.count);
    for (int i = 0; i < self.aiLoggingConfig.componentIds.count ; i++){
        XCTAssertEqual([self.aiLoggingConfig.componentIds objectAtIndex:i], [array objectAtIndex:i]);
    }
    XCTAssertEqual(self.aiLoggingConfig.cloudLogEnabled,YES);
    XCTAssertEqual(self.aiLoggingConfig.cloudBatchLimit, 15);
}

-(void)testloglevelValueNottheirAndIsReleaseConfigIsTrue {
    [self.configDict removeObjectForKey:@"logLevel"];
    NSArray * array = @[@"ail",@"comp1"];
    self.aiLoggingConfig.isReleaseConfig = YES;
    self.aiLoggingConfig = [[AILoggingConfig alloc] initWithConfig:self.configDict];
    XCTAssertEqual(self.aiLoggingConfig.fileName, @"AppInfraLog");
    XCTAssertEqual(self.aiLoggingConfig.numberOfFiles, 5);
    XCTAssertEqual(self.aiLoggingConfig.fileSizeInBytes, 50000);
    XCTAssertEqual(self.aiLoggingConfig.fileLogEnabled, YES);
    XCTAssertEqual(self.aiLoggingConfig.consoleLogEnabled, YES);
    XCTAssertEqual(self.aiLoggingConfig.componentIds.count,array.count);
    for (int i = 0; i < self.aiLoggingConfig.componentIds.count ; i++){
        XCTAssertEqual([self.aiLoggingConfig.componentIds objectAtIndex:i], [array objectAtIndex:i]);
    }
    XCTAssertEqual(self.aiLoggingConfig.cloudLogEnabled,YES);
    XCTAssertEqual(self.aiLoggingConfig.cloudBatchLimit, 15);
}

-(void)testBatchLimitToZero {
    [self.configDict setValue:[NSNumber numberWithInteger:0] forKey:@"cloudBatchLimit"];
    self.aiLoggingConfig = [[AILoggingConfig alloc] initWithConfig:self.configDict];
    XCTAssertEqual(self.aiLoggingConfig.cloudBatchLimit, 5);
}

@end
