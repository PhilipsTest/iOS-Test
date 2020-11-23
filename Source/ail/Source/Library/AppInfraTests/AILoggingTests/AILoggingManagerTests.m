//
//  AILoggingManagerTests.m
//  AppInfraTests
//
//  Created by Hashim MH on 09/05/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AILoggingManager.h"
#import <OCMock/OCMock.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "AILoggingFormatter.h"
#import "NSBundle+Bundle.h"

@interface LoggingFileManagerDefault :DDLogFileManagerDefault

@property(nonatomic,retain)NSDateFormatter *dateFormatterFileName;
@property(nonatomic, strong)NSString * logFileName;

@end

@interface AILoggingManagerTests : XCTestCase

@end

@implementation AILoggingManagerTests

- (void)setUp {
    [super setUp];
    [NSBundle loadSwizzler];
}

- (void)tearDown {
	[NSBundle deSwizzele];
    [super tearDown];
}

- (void)testLoggingManagerFileLoggerNilForNilConfig {
    AILoggingManager *logManager = [[AILoggingManager alloc]initWithConfig:nil];
    XCTAssertNil([logManager fileLogger]);
}

- (void)testLoggingManagerConsoleLoggerNilForNilConfig {
    AILoggingManager *logManager = [[AILoggingManager alloc]initWithConfig:nil];
    XCTAssertNil([logManager consoleLogger]);
}

- (void)testLoggingManagerCloudLoggerNilForNilConfig {
    AILoggingManager *logManager = [[AILoggingManager alloc]initWithConfig:nil];
    XCTAssertNil([logManager cloudLoggerWithAppInfra:nil metaData:nil]);
}

- (void)testLoggingManagerFileLoggerNotNil {
    id config = OCMClassMock([AILoggingConfig class]);
    OCMExpect([config fileLogEnabled]).andReturn(YES);
    AILoggingManager *logManager = [[AILoggingManager alloc]initWithConfig:config];
    XCTAssertNotNil([logManager fileLogger]);
    OCMVerifyAll(config);
}

- (void)testLoggingManagerConsoleLoggerNotNil {
    id config = OCMClassMock([AILoggingConfig class]);
    OCMExpect([config consoleLogEnabled]).andReturn(YES);
    AILoggingManager *logManager = [[AILoggingManager alloc]initWithConfig:config];
    XCTAssertNotNil([logManager consoleLogger]);
    OCMVerifyAll(config);
}

- (void)testLoggingManagerCloudLoggerNotNil {
    id config = OCMClassMock([AILoggingConfig class]);
    OCMExpect([config cloudLogEnabled]).andReturn(YES);
    AILoggingManager *logManager = [[AILoggingManager alloc]initWithConfig:config];
    AIAppInfra *appinfra = [[AIAppInfra alloc]initWithBuilder:nil];
    XCTAssertNotNil([logManager cloudLoggerWithAppInfra:appinfra metaData:nil]);
    OCMVerifyAll(config);
}

- (void)testLoggingManagerShouldConfigureFileLogger {
    NSString *testFileName = @"testFile.log";
    unsigned long maximumNumberOfLogFiles = 3;
    unsigned long fileSizeInBytes = 100;
    id config = OCMClassMock([AILoggingConfig class]);
    OCMExpect([config fileLogEnabled]).andReturn(YES);
    OCMExpect([config fileName]).andReturn(testFileName);
    OCMExpect([config numberOfFiles]).andReturn(maximumNumberOfLogFiles);
    OCMExpect([config fileSizeInBytes]).andReturn(fileSizeInBytes);
    
    AILoggingManager *logManager = [[AILoggingManager alloc]initWithConfig:config];
    DDFileLogger *fileLogger = [logManager fileLogger];
    
    XCTAssertNotNil(fileLogger);
    XCTAssertNotNil(fileLogger.logFormatter);
    XCTAssertTrue([fileLogger.logFormatter isKindOfClass:[AILoggingFormatter class]]);

    XCTAssertEqualObjects(testFileName, ((LoggingFileManagerDefault*)(fileLogger.logFileManager)).logFileName );
    XCTAssertEqual(maximumNumberOfLogFiles, fileLogger.logFileManager.maximumNumberOfLogFiles );
    XCTAssertEqual(fileSizeInBytes, fileLogger.maximumFileSize );
    
    OCMVerifyAll(config);
}

- (void)testLoggingManagerShouldConfigureFileLoggerWithDefaultValue {
    AILoggingConfig *config = [[AILoggingConfig alloc]init];
    config.fileLogEnabled = YES;
    AILoggingManager *logManager = [[AILoggingManager alloc]initWithConfig:config];
    DDFileLogger *fileLogger = [logManager fileLogger];
    
    XCTAssertNotNil(fileLogger);
    XCTAssertNotNil(fileLogger.logFormatter);
    XCTAssertTrue([fileLogger.logFormatter isKindOfClass:[AILoggingFormatter class]]);

    //is this expected , need to verify this
    XCTAssertEqualObjects(nil, ((LoggingFileManagerDefault*)(fileLogger.logFileManager)).logFileName );
    XCTAssertEqual(0, fileLogger.logFileManager.maximumNumberOfLogFiles );
    XCTAssertEqual(0, fileLogger.maximumFileSize );
}

- (void)testLoggingManagerShouldConfigureCloudLoggerWithDefaultValue {
    id appinfraMock = [[AIAppInfra alloc]initWithBuilder:nil];
    id clMetadataMock = OCMClassMock([AICloudLogMetadata class]);
    
    AILoggingConfig *config = [[AILoggingConfig alloc]init];
    config.cloudLogEnabled = YES;
    AILoggingManager *logManager = [[AILoggingManager alloc]initWithConfig:config];
    AICloudLogger *cloudLoger = [logManager cloudLoggerWithAppInfra:appinfraMock metaData:clMetadataMock];
    
    XCTAssertNotNil(cloudLoger);
    XCTAssertEqualObjects(clMetadataMock, cloudLoger.cloudLogMetaData );
    XCTAssertEqualObjects(appinfraMock, cloudLoger.appInfra );
}

@end
