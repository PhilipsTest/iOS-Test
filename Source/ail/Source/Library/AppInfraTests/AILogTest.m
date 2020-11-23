//
//  AILogTest.m
//  AppInfra
//
//  Created by Senthil on 26/04/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AILog.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface AILogTest : XCTestCase {
    AILog *aiLog;
}

@end

@implementation AILogTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    aiLog = [[AILog alloc] init];
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



-(void)testDDLogLevelOffEqual{
    DDLogLevel loglevel = [AILog logLevelFrom:0];
    XCTAssertEqual(loglevel, DDLogLevelOff);
}

-(void)testDDLogLevelErrorEqual{
    DDLogLevel loglevel = [AILog logLevelFrom:@1];
    XCTAssertEqual(loglevel, DDLogLevelError);
}

-(void)testDDLogLevelWarningEqual{
    DDLogLevel loglevel = [AILog logLevelFrom:@2];
    XCTAssertEqual(loglevel, DDLogLevelWarning);
}

-(void)testDDLogLevelInfoEqual{
    DDLogLevel loglevel = [AILog logLevelFrom:@3];
    XCTAssertEqual(loglevel, DDLogLevelInfo);
}

-(void)testDDLogLevelDebugEqual{
    DDLogLevel loglevel = [AILog logLevelFrom:@4];
    XCTAssertEqual(loglevel, DDLogLevelDebug);
}

-(void)testDDLogLevelVerboseEqual{
    DDLogLevel loglevel = [AILog logLevelFrom:@5];
    XCTAssertEqual(loglevel, DDLogLevelVerbose);
}

-(void)testDDLogLevelAllEqual{
    DDLogLevel loglevel = [AILog logLevelFrom:@6];
    XCTAssertEqual(loglevel, DDLogLevelAll);
    
}

-(void)testmoduleLoglevelForFileDDLogLevelOffEqual{
    NSString *myString = @"/Users/RakeshR/Desktop/aa/App BUP/Source/DemoAppFramework/DemoAppFramework/ViewController/Testing/DemoTestingViewController.m";
    const char *cString = [myString cStringUsingEncoding:NSASCIIStringEncoding];
    DDLogLevel loglevel = [AILog moduleLoglevelForFile:cString];
    XCTAssertEqual(loglevel, DDLogLevelOff);
    
}

-(void)testmoduleLoglevelForFileDDLogLevelOffNotEqual{
    NSString *myString = @"/Users/RakeshR/Desktop/aa/App BUP/Source/DemoAppFramework/DemoAppFramework/ViewController/Testing/DemoTestingViewController.m";
    const char *cString = [myString cStringUsingEncoding:NSASCIIStringEncoding];
    DDLogLevel loglevel = [AILog moduleLoglevelForFile:cString];
    XCTAssertNotEqual(loglevel, DDLogLevelAll);
    
}

@end
