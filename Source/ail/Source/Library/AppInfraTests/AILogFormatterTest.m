//
//  AILogFormatterTest.m
//  AppInfra
//
//  Created by Senthil on 26/04/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AILogFormatter.h"



@interface AILogFormatterTest : XCTestCase {
    AILogFormatter *aiLogFormatter;
    
}

@end

@implementation AILogFormatterTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    aiLogFormatter = [[AILogFormatter alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testtimeZoneUTC{

    XCTAssertNotNil([aiLogFormatter timeZoneUTC],@"value is not nill");
}
- (void)testlogLevel{
    XCTAssertNotNil([aiLogFormatter logLevel:0],@"value is not nill");
    XCTAssertTrue([aiLogFormatter logLevel:0],@"value is TRUE");
}

-(void)testLogErrorEqual{

    XCTAssertEqualObjects([aiLogFormatter logLevel:1], @"ERROR");
}

-(void)testLogWarningEqual{
    XCTAssertEqualObjects([aiLogFormatter logLevel:2], @"WARNING");
}

-(void)testLogVerboseEqual{
    XCTAssertEqualObjects([aiLogFormatter logLevel:3], @"VERBOSE");
}

-(void)testLogInfoEqual{
    XCTAssertEqualObjects([aiLogFormatter logLevel:4], @"INFO");
}

-(void)testLogErrorNotEqual{
    NSString *exp1 = [aiLogFormatter logLevel:1];
    NSString *exp2 = @"Verbose";
    XCTAssertNotEqualObjects(exp1, exp2);
}

-(void)testLogWarningNotEqual{
    NSString *exp1 = [aiLogFormatter logLevel:2];
    NSString *exp2 = @"Verbose";
    XCTAssertNotEqualObjects(exp1, exp2);
}

-(void)testLogVerboseNotEqual{
    NSString *exp1 = [aiLogFormatter logLevel:3];
    NSString *exp2 = @"Error";
    XCTAssertNotEqualObjects(exp1, exp2);
}

-(void)testLogInfoNotEqual{
    NSString *exp1 = [aiLogFormatter logLevel:4];
    NSString *exp2 = @"Verbose";
    XCTAssertNotEqualObjects(exp1, exp2);
}

- (void)testReleaseBuildConfiguration {
    
#ifndef Release
    XCTAssertEqual(AI_LOGLEVEL, DDLogLevelAll);
    XCTAssertEqual(FILE_LOG_ENABLED, 1);
    XCTAssertEqual(CONSOLE_LOG_ENABLED, 1);
    XCTAssertEqual(MODULE_LEVEL_LOG_ENABLED, 1);
#endif
}

- (void)testDebugBuildConfiguration {
    
#ifndef DEBUG
    XCTAssertEqual(AI_LOGLEVEL, DDLogLevelAll);
    XCTAssertEqual(FILE_LOG_ENABLED, 1);
    XCTAssertEqual(CONSOLE_LOG_ENABLED, 1);
    XCTAssertEqual(MODULE_LEVEL_LOG_ENABLED, 1);
#endif
}

-(void)testLogFormatNotNil{

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:1308031456];
    DDLogMessage *ddLogm = [[DDLogMessage alloc] initWithMessage:@"Test Method | Test Message" level:4 flag:4 context:0 file:@"Test Case" function:nil line:4 tag:nil options:4 timestamp:date];
     XCTAssertNotNil([aiLogFormatter formatLogMessage:ddLogm],@"value is not nil");
}

@end
