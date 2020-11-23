//
//  AICloudLoggerTests.m
//  AppInfraTests
//
//  Created by Hashim MH on 03/05/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AICloudLogger.h"
#import "AILogMetaData.h"
#import "AILogging.h"
#import "AILoggingProtocol.h"
#import "OCMock/OCMock.h"
#import "AIAppInfra.h"
#import "NSBundle+Bundle.h"
@interface AICloudLogger ()
- (BOOL)isMessageExceedsSizeLimitForMessage:(DDLogMessage *)logMessage;
- (void)logMessage:(DDLogMessage *)logMessage;
@end

@interface AICloudLoggerTests : XCTestCase
@property(nonatomic, strong)AIAppInfra * appinfra;
@end


@implementation AICloudLoggerTests

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
    self.appinfra = [AICloudLoggerTests sharedAppInfra];
}

- (void)tearDown {
    self.appinfra = nil;
    [super tearDown];
}

//MARK:- message length check

-(void)testMessageLengthRestrictionTrue{
    AICloudLogger *cloudLogger = [[AICloudLogger alloc]init];
    AILogMetaData *metadata = [[AILogMetaData alloc]init];
    metadata.params = @{};
    NSString *lengthyMessage = [self sampleString:@"a" :1024];
    DDLogMessage *message  = [[DDLogMessage alloc]initWithMessage:lengthyMessage
                                                            level:DDLogLevelAll
                                                             flag:DDLogFlagInfo
                                                          context:0 file:@"test"
                                                         function:nil
                                                             line:0
                                                              tag:metadata
                                                          options:DDLogMessageDontCopyMessage
                                                        timestamp:nil];
    
    BOOL actualResult =  [cloudLogger isMessageExceedsSizeLimitForMessage:message];
    XCTAssertTrue(actualResult);
}

-(void)testMessageLengthRestrictionFalseLength0{
    AICloudLogger *cloudLogger = [[AICloudLogger alloc]init];
    AILogMetaData *metadata = [[AILogMetaData alloc]init];
    metadata.params = @{};
    NSString *lengthyMessage = [self sampleString:@"a" :0];
    DDLogMessage *message  = [[DDLogMessage alloc]initWithMessage:lengthyMessage
                                                            level:DDLogLevelAll
                                                             flag:DDLogFlagInfo
                                                          context:0
                                                             file:@"test"
                                                         function:nil
                                                             line:0
                                                              tag:metadata
                                                          options:DDLogMessageDontCopyMessage
                                                        timestamp:nil];
    
    BOOL actualResult =  [cloudLogger isMessageExceedsSizeLimitForMessage:message];
    XCTAssertFalse(actualResult);
}

-(void)testMessageLengthRestrictionFalseLength1023{
    AICloudLogger *cloudLogger = [[AICloudLogger alloc]init];
    AILogMetaData *metadata = [[AILogMetaData alloc]init];
    metadata.params = nil;
    NSString *lengthyMessage = [self sampleString:@"a" :1023];
    DDLogMessage *message  = [[DDLogMessage alloc]initWithMessage:lengthyMessage
                                                            level:DDLogLevelAll
                                                             flag:DDLogFlagInfo
                                                          context:0
                                                             file:@"test"
                                                         function:nil
                                                             line:0
                                                              tag:metadata
                                                          options:DDLogMessageDontCopyMessage
                                                        timestamp:nil];
    
    BOOL actualResult =  [cloudLogger isMessageExceedsSizeLimitForMessage:message];
    XCTAssertFalse(actualResult);
}

-(void)testMessageLengthRestrictionFalseLength1023WithDictionary{
    AICloudLogger *cloudLogger = [[AICloudLogger alloc]init];
    AILogMetaData *metadata = [[AILogMetaData alloc]init];
    metadata.params = @{@"somekey":@"someValue"};
    NSUInteger paramLength = metadata.params.description.length;
    NSString *lengthyMessage = [self sampleString:@"a" :1023-paramLength];
    DDLogMessage *message  = [[DDLogMessage alloc]initWithMessage:lengthyMessage
                                                            level:DDLogLevelAll
                                                             flag:DDLogFlagInfo
                                                          context:0
                                                             file:@"test"
                                                         function:nil
                                                             line:0
                                                              tag:metadata
                                                          options:DDLogMessageDontCopyMessage
                                                        timestamp:nil];
    
    BOOL actualResult =  [cloudLogger isMessageExceedsSizeLimitForMessage:message];
    XCTAssertFalse(actualResult);
}

-(void)testMessageLengthRestrictionFalseLength1024WithDictionary{
    AICloudLogger *cloudLogger = [[AICloudLogger alloc]init];
    AILogMetaData *metadata = [[AILogMetaData alloc]init];
    metadata.params = @{@"somekey":@"someValue"};
    NSUInteger paramLength = metadata.params.description.length;
    NSString *lengthyMessage = [self sampleString:@"a" :1024-paramLength];
    DDLogMessage *message  = [[DDLogMessage alloc]initWithMessage:lengthyMessage
                                                            level:DDLogLevelAll
                                                             flag:DDLogFlagInfo
                                                          context:0
                                                             file:@"test"
                                                         function:nil
                                                             line:0
                                                              tag:metadata
                                                          options:DDLogMessageDontCopyMessage
                                                        timestamp:nil];
    BOOL actualResult =  [cloudLogger isMessageExceedsSizeLimitForMessage:message];
    XCTAssertTrue(actualResult);
}

-(void)testMessageLengthRestrictionFalse{
    AICloudLogger *cloudLogger = [[AICloudLogger alloc]init];
    AILogMetaData *metadata = [[AILogMetaData alloc]init];
    metadata.params = @{};
    
    DDLogMessage *message  = [[DDLogMessage alloc]initWithMessage:@""
                                                            level:DDLogLevelAll
                                                             flag:DDLogFlagInfo
                                                          context:0 file:@"test"
                                                         function:nil
                                                             line:0
                                                              tag:metadata
                                                          options:DDLogMessageDontCopyMessage
                                                        timestamp:nil];
    
    BOOL actualResult =  [cloudLogger isMessageExceedsSizeLimitForMessage:message];
    XCTAssertFalse(actualResult);
}

//TODO: check this
-(void)testMessageLengthRestrictionTrueForNilMessage{
    AICloudLogger *cloudLogger = [[AICloudLogger alloc]init];
    BOOL actualResult =  [cloudLogger isMessageExceedsSizeLimitForMessage:nil];
    XCTAssertFalse(actualResult);
}

-(NSString*)sampleString:(NSString* )ch :( NSUInteger) len{
    NSMutableString *sampleString = [@"" mutableCopy];
    for (int i=0; i<len; i++) {
        [sampleString appendString:ch];
    }
    return sampleString;
}

@end
