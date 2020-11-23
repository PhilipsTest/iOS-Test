//
//  Logging.m
//  AppInfraTests
//
//  Created by leslie on 19/10/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AILogging.h"
#import "AILoggingProtocol.h"
#import <OCMock/OCMock.h>
#import <CocoaLumberjack/DDLog.h>
#import "NSBundle+Bundle.h"
#import "AILoggingFormatter.h"
#import "AILogMetaData.h"


@interface AILogging()

- (void)log:(BOOL)asynchronous
      level:(DDLogLevel)level
       flag:(DDLogFlag)flag
    message:(NSString *)message
        tag:(AILogMetaData*)tag;

@end

@interface LoggingTests : XCTestCase

@property(nonatomic, strong)AIAppInfra * appinfra;

@end

@implementation LoggingTests

+ (id) sharedAppInfra {
    static dispatch_once_t time = 0;
    static AIAppInfra *_sharedObject = nil;
    dispatch_once(&time, ^{
        _sharedObject = [AIAppInfra buildAppInfraWithBlock:nil];
    });
    return _sharedObject;
}

- (void)setUp {
    [super setUp];
    [NSBundle loadSwizzler];
    self.appinfra = [LoggingTests sharedAppInfra];
}

//Test Case 24303
//Verify the Log Format under console and file

- (void)test24306{
    AILogging * logger = [self.appinfra.logging createInstanceForComponent:@"cm1" componentVersion:@"1.1"];
    id mock = OCMPartialMock(logger);
    
    NSString *message = @"test24306_testMessage";
    [logger log:AILogLevelError eventId:@"test" message:message];
    OCMVerify([mock log:YES level:DDLogLevelAll flag:DDLogFlagError message:message tag:[OCMArg checkWithBlock:^BOOL(AILogMetaData *metadata) {
        XCTAssertEqualObjects(metadata.eventId,@"test" );
        XCTAssertEqualObjects(metadata.component,@"cm1:1.1" );
        return YES;
    }]]);
}

- (void)test24305 {
    AILogging * logger = [self.appinfra.logging createInstanceForComponent:@"cm2" componentVersion:@"1.3"];
    id mock = OCMPartialMock(logger);
    
    NSString *message = @"test24305_message";

    [logger log:AILogLevelInfo eventId:@"event24305" message:message];
    OCMVerify([mock log:YES level:DDLogLevelAll flag:DDLogFlagInfo message:message tag:[OCMArg checkWithBlock:^BOOL(AILogMetaData *metadata) {
        XCTAssertEqualObjects(metadata.eventId,@"event24305" );
        XCTAssertEqualObjects(metadata.component,@"cm2:1.3" );
        return YES;
    }]]);

}

- (void)test24308 {
    AILogging * logger = [self.appinfra.logging createInstanceForComponent:@"cm3" componentVersion:@"3.0"];
    id mock = OCMPartialMock(logger);

    NSString *message = @"test24308_message";
    [logger log:AILogLevelDebug eventId:@"event24308" message:message];
    OCMVerify([mock log:YES level:DDLogLevelAll flag:DDLogFlagDebug message:message tag:[OCMArg checkWithBlock:^BOOL(AILogMetaData *metadata) {
        XCTAssertEqualObjects(metadata.eventId,@"event24308" );
        XCTAssertEqualObjects(metadata.component,@"cm3:3.0" );
        return YES;
    }]]);

}



- (void)test24309 {
    AILogging * logger = [self.appinfra.logging createInstanceForComponent:@"cm4" componentVersion:@"1.6"];
    id mock = OCMPartialMock(logger);
    
    NSString * newMessage = @"test24309_message";
    
    [logger log:AILogLevelVerbose eventId:@"event24309" message:newMessage];
    OCMVerify([mock log:YES level:DDLogLevelAll flag:DDLogFlagVerbose message:newMessage tag:[OCMArg checkWithBlock:^BOOL(AILogMetaData *metadata) {
        XCTAssertEqualObjects(metadata.eventId,@"event24309" );
        XCTAssertEqualObjects(metadata.component,@"cm4:1.6" );
        return YES;
    }]]);

}

- (void)test24307 {
    AILogging * logger = [self.appinfra.logging createInstanceForComponent:@"cm" componentVersion:@"1.7"];
    id mock = OCMPartialMock(logger);

    NSString * newMessage = @"test24307_message";
    [logger log:AILogLevelWarning eventId:@"event24307" message:newMessage];
    OCMVerify([mock log:YES level:DDLogLevelAll flag:DDLogFlagWarning message:newMessage  tag:[OCMArg checkWithBlock:^BOOL(AILogMetaData *metadata) {
        XCTAssertEqualObjects(metadata.eventId,@"event24307" );
        XCTAssertEqualObjects(metadata.component,@"cm:1.7" );
        return YES;
    }]]);
}


- (void)test24303 {
    AILoggingFormatter * formatter = [[AILoggingFormatter alloc]init];
    
    XCTAssertEqualObjects(formatter.dateFormatter.dateFormat, @"yyyy-MM-dd HH:mm:ss.SSS Z");
    NSDate * date = [formatter.dateFormatter dateFromString:@"2017-11-10 06:56:38.911 +0000"];
    XCTAssertNotNil(date);
    XCTAssertEqualObjects([formatter.dateFormatter stringFromDate:date], @"2017-11-10 06:56:38.911 +0000");
}


- (void)test46456 {
    AILogging * logger = [self.appinfra.logging createInstanceForComponent:@"cm5" componentVersion:@"5.3"];
    id mock = OCMPartialMock(logger);
    
    NSDictionary * dictionary = @{@"test":@"testVal"};
    NSString * newMessage = @"test46456_message";
    
    [logger log:AILogLevelError eventId:@"event46456" message:newMessage dictionary:dictionary];
    OCMVerify([mock log:YES level:DDLogLevelAll flag:DDLogFlagError message:newMessage   tag:[OCMArg checkWithBlock:^BOOL(AILogMetaData *metadata) {
        XCTAssertEqualObjects(metadata.eventId,@"event46456" );
        XCTAssertEqualObjects(metadata.component,@"cm5:5.3" );
        XCTAssertEqualObjects(metadata.params,dictionary);
        return YES;
    }]]);

}


- (void)test46458 {
    AILogging * logger = [self.appinfra.logging createInstanceForComponent:@"cm1" componentVersion:@"5.2"];
    id mock = OCMPartialMock(logger);
    
    NSDictionary * dictionary = @{@"test":@"testVal" ,@"randomNum":[NSNumber numberWithInt:arc4random()]};
    NSString * newMessage = @"test46458";
    
    [logger log:AILogLevelInfo eventId:@"event46458" message:newMessage dictionary:dictionary];
    OCMVerify([mock log:YES level:DDLogLevelAll flag:DDLogFlagInfo message:newMessage tag:[OCMArg checkWithBlock:^BOOL(AILogMetaData *metadata) {
        XCTAssertEqualObjects(metadata.eventId,@"event46458");
        XCTAssertEqualObjects(metadata.component,@"cm1:5.2" );
        XCTAssertEqualObjects(metadata.params,dictionary);
        return YES;
    }]]);
}

- (void)test53406 {
    AILogging * logger = [self.appinfra.logging createInstanceForComponent:@"cm2" componentVersion:@"15.0"];
    id mock = OCMPartialMock(logger);
    
    NSDictionary * dictionary = @{@"test":@"testVal",@"randomNum1":[NSNumber numberWithInt:arc4random()]};
    NSString * newMessage = @"test53406";
    
    [logger log:AILogLevelVerbose eventId:@"event53406" message:newMessage dictionary:dictionary];
    OCMVerify([mock log:YES level:DDLogLevelAll flag:DDLogFlagVerbose message:newMessage tag:[OCMArg checkWithBlock:^BOOL(AILogMetaData *metadata) {
        XCTAssertEqualObjects(metadata.eventId,@"event53406");
        XCTAssertEqualObjects(metadata.component,@"cm2:15.0" );
        XCTAssertEqualObjects(metadata.params,dictionary);
        return YES;
    }]]);

}


- (void)test46456Debug {
    AILogging * logger = [self.appinfra.logging createInstanceForComponent:@"cm3" componentVersion:@"4.2"];
    id mock = OCMPartialMock(logger);
    
    NSDictionary * dictionary = @{@"test":@"testVal",@"randomNum1":[NSNumber numberWithInt:arc4random()]};
    NSString * newMessage = @"test46456Debug";

    [logger log:AILogLevelDebug eventId:@"event46456Debug" message:newMessage dictionary:dictionary];
    OCMVerify([mock log:YES level:DDLogLevelAll flag:DDLogFlagDebug message:newMessage tag:[OCMArg checkWithBlock:^BOOL(AILogMetaData *metadata) {
        XCTAssertEqualObjects(metadata.eventId,@"event46456Debug");
        XCTAssertEqualObjects(metadata.component,@"cm3:4.2" );
        XCTAssertEqualObjects(metadata.params,dictionary);
        return YES;
    }]]);

}

- (void)test46456Warning {
    AILogging * logger = [self.appinfra.logging createInstanceForComponent:@"cm7" componentVersion:@"4.6"];
    id mock = OCMPartialMock(logger);
    
    NSDictionary * dictionary = @{@"test":@"testVal",@"randomNum1":[NSNumber numberWithInt:arc4random()]};
    NSString * newMessage = @"test46456Warning";
    
    [logger log:AILogLevelWarning eventId:@"event46456Warning" message:newMessage dictionary:dictionary];
    OCMVerify([mock log:YES level:DDLogLevelAll flag:DDLogFlagWarning message:newMessage  tag:[OCMArg checkWithBlock:^BOOL(AILogMetaData *metadata) {
        XCTAssertEqualObjects(metadata.eventId,@"event46456Warning");
        XCTAssertEqualObjects(metadata.component,@"cm7:4.6" );
        XCTAssertEqualObjects(metadata.params,dictionary);
        return YES;
    }]]);

}


- (void)testComponentLevelFilteringComponentPresentORAbsent {
    AILogging * logger = [self.appinfra.logging createInstanceForComponent:@"cm11" componentVersion:@"1.11"];
    logger.logConfig.componentIds = @[@"cm2",@"cm1"];
    logger.logConfig.componentLevelLogEnabled = YES;
    id mock = OCMPartialMock(logger);
    
    NSString * newMessage = @"testComponentLevelFiltering";
    
    OCMReject([mock log:YES level:DDLogLevelAll flag:DDLogFlagWarning message:newMessage tag:[OCMArg checkWithBlock:^BOOL(AILogMetaData *metadata) {
        XCTAssertEqualObjects(metadata.eventId,@"event111");
        XCTAssertEqualObjects(metadata.component,@"cm11:1.11" );
        return YES;
    }]]);
    [logger log:AILogLevelWarning eventId:@"event111" message:newMessage];
    
    
    AILogging * logger2 = [self.appinfra.logging createInstanceForComponent:@"cm11" componentVersion:@"1.11"];
    logger2.logConfig.componentIds = @[@"cm",@"cm11"];
    logger2.logConfig.componentLevelLogEnabled = YES;
    id mock2 = OCMPartialMock(logger2);
    [logger2 log:AILogLevelWarning eventId:@"event111" message:newMessage];
    OCMVerify([mock2 log:YES level:DDLogLevelAll flag:DDLogFlagWarning message:newMessage tag:[OCMArg checkWithBlock:^BOOL(AILogMetaData *metadata) {
        XCTAssertEqualObjects(metadata.eventId,@"event111");
        XCTAssertEqualObjects(metadata.component,@"cm11:1.11" );
        return YES;
    }]]);
}

- (void)testComponentLevelFilteringComponentPresentORAbsentandDisabled {
    
    AILogging *logger = [self.appinfra.logging createInstanceForComponent:@"cm11" componentVersion:@"1.11"];
    logger.logConfig.componentIds = @[@"cm2",@"cm1"];
    logger.logConfig.componentLevelLogEnabled = NO;
    id mock = OCMPartialMock(logger);

    NSString * newMessage = @"testComponentLevelFiltering";
    [logger log:AILogLevelWarning eventId:@"event111" message:newMessage];
    OCMVerify([mock log:YES level:DDLogLevelAll flag:DDLogFlagWarning message:newMessage tag:[OCMArg checkWithBlock:^BOOL(AILogMetaData *metadata) {
        XCTAssertEqualObjects(metadata.eventId,@"event111");
        XCTAssertEqualObjects(metadata.component,@"cm11:1.11" );
        return YES;
    }]]);


    AILogging * logger2 = [self.appinfra.logging createInstanceForComponent:@"cm11" componentVersion:@"1.11"];
    logger2.logConfig.componentIds = @[@"cm",@"cm11"];
    logger2.logConfig.componentLevelLogEnabled = NO;
    id mock2 = OCMPartialMock(logger2);
    [logger2 log:AILogLevelWarning eventId:@"event111" message:newMessage];
    OCMVerify([mock2 log:YES level:DDLogLevelAll flag:DDLogFlagWarning message:newMessage tag:[OCMArg checkWithBlock:^BOOL(AILogMetaData *metadata) {
        XCTAssertEqualObjects(metadata.eventId,@"event111");
        XCTAssertEqualObjects(metadata.component,@"cm11:1.11" );
        return YES;
    }]]);
}


@end
