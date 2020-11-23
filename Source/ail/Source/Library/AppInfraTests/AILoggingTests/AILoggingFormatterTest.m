//
//  AILoggingFormatterTest.m
//  AppInfra
//
//  Created by Senthil on 22/06/16.
/*  Copyright ©  Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/
//

#import <XCTest/XCTest.h>
#import "AILoggingFormatter.h"

@interface AILoggingFormatter(AILoggingFormatterTest)

- (NSString *)formattedUTCTimeString:(NSDate*)networkDate;
- (NSString *)logLevel:(DDLogFlag )flag;

@end

@interface AILoggingFormatterTest : XCTestCase{
    AILoggingFormatter *aiLoggingFormatter;
}
@end

@implementation AILoggingFormatterTest

- (void)setUp {
    [super setUp];
    aiLoggingFormatter = [[AILoggingFormatter alloc] init];
}

- (void)tearDown {
    aiLoggingFormatter = nil;
    [super tearDown];
}

- (void)testFormattedUTCTimeString {
    NSString *formattedTime = [aiLoggingFormatter formattedUTCTimeString:[[NSDate alloc] init]];
    XCTAssertNotNil(formattedTime, @"Formatted time is nil");
}

- (void)testLogLevel {
    NSString *testLogLevel = [aiLoggingFormatter logLevel:DDLogFlagWarning];
    XCTAssertNotNil(testLogLevel, @"Log level is nil");
    XCTAssertTrue([testLogLevel isEqualToString:@"WARNING"]);
}

- (void) testformatLogMessage{
    DDLogMessage *dummyMessage=[[DDLogMessage alloc]initWithMessage:@"Some dummy message" level:DDLogLevelInfo flag:DDLogFlagInfo context:0 file:@__FILE__ function:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] line:__LINE__ tag:0 options:0 timestamp:[NSDate date]];
    XCTAssertNotNil([aiLoggingFormatter formatLogMessage:dummyMessage], @"value should not be nill");
}

@end

