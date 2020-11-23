//
//  DIErrorMappingTests.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <XCTest/XCTest.h>
#import "DIErrorMapping.h"
#import "JRCaptureError.h"
#import "DIRegistrationConstants.h"

@interface DIErrorMappingTests : XCTestCase

@end

@implementation DIErrorMappingTests

- (void)testErrorMap {
    NSError *sampleError = [NSError errorWithDomain:@"Sample Domain" code:JRCaptureApidErrorMissingArgument userInfo:nil];
    XCTAssertNotNil([URBaseErrorParser errorMap:sampleError], @"Error should not be nil");
    sampleError = [NSError errorWithDomain:@"Sample Domain" code:JRCaptureApidErrorInvalidArgument userInfo:nil];
    XCTAssertNotNil([URBaseErrorParser errorMap:sampleError], @"Error should not be nil");
    sampleError = [NSError errorWithDomain:@"Sample Domain" code:JRCaptureApidErrorDuplicateArgument userInfo:nil];
    XCTAssertNotNil([URBaseErrorParser errorMap:sampleError], @"Error should not be nil");
    sampleError = [NSError errorWithDomain:@"Sample Domain" code:JRCaptureApidErrorMissingRequiredAttribute userInfo:nil];
    XCTAssertNotNil([URBaseErrorParser errorMap:sampleError], @"Error should not be nil");
    sampleError = [NSError errorWithDomain:@"Sample Domain" code:JRCaptureLocalApidErrorInvalidArgument userInfo:nil];
    XCTAssertNotNil([URBaseErrorParser errorMap:sampleError], @"Error should not be nil");
    sampleError = [NSError errorWithDomain:@"Sample Domain" code:JRCaptureErrorGenericBadPassword userInfo:nil];
    XCTAssertNotNil([URBaseErrorParser errorMap:sampleError], @"Error should not be nil");
    sampleError = [NSError errorWithDomain:@"Sample Domain" code:JRCaptureApidErrorFormValidation userInfo:nil];
    XCTAssertNotNil([URBaseErrorParser errorMap:sampleError], @"Error should not be nil");
    sampleError = [NSError errorWithDomain:@"Sample Domain" code:JRCaptureApidErrorEmailAddressInUse userInfo:nil];
    XCTAssertNotNil([URBaseErrorParser errorMap:sampleError], @"Error should not be nil");
    sampleError = [NSError errorWithDomain:@"Sample Domain" code:3210 userInfo:nil];
    XCTAssertNotNil([URBaseErrorParser errorMap:sampleError], @"Error should not be nil");
    sampleError = [NSError errorWithDomain:@"Sample Domain" code:JRCaptureApidErrorAccessTokenExpired userInfo:nil];
    XCTAssertNotNil([URBaseErrorParser errorMap:sampleError], @"Error should not be nil");
    
    sampleError = [NSError errorWithDomain:@"Sample Domain" code:JRCaptureApidErrorUnexpectedError userInfo:nil];
    XCTAssertNotNil([URBaseErrorParser errorMap:sampleError], @"Error should not be nil");
    
    sampleError = [NSError errorWithDomain:@"Sample Domain" code:-1000 userInfo:nil];
    XCTAssertNotNil([URBaseErrorParser errorMap:sampleError], @"Error should not be nil");
    sampleError = [NSError errorWithDomain:@"Sample Domain" code:-1001 userInfo:nil];
    XCTAssertNotNil([URBaseErrorParser errorMap:sampleError], @"Error should not be nil");
    sampleError = [NSError errorWithDomain:@"Sample Domain" code:-1002 userInfo:nil];
    XCTAssertNotNil([URBaseErrorParser errorMap:sampleError], @"Error should not be nil");
    sampleError = [NSError errorWithDomain:@"Sample Domain" code:-1003 userInfo:nil];
    XCTAssertNotNil([URBaseErrorParser errorMap:sampleError], @"Error should not be nil");
    sampleError = [NSError errorWithDomain:@"Sample Domain" code:-1004 userInfo:nil];
    XCTAssertNotNil([URBaseErrorParser errorMap:sampleError], @"Error should not be nil");
    sampleError = [NSError errorWithDomain:@"Sample Domain" code:-1005 userInfo:nil];
    XCTAssertNotNil([URBaseErrorParser errorMap:sampleError], @"Error should not be nil");
    sampleError = [NSError errorWithDomain:@"Sample Domain" code:-1006 userInfo:nil];
    XCTAssertNotNil([URBaseErrorParser errorMap:sampleError], @"Error should not be nil");
    sampleError = [NSError errorWithDomain:@"Sample Domain" code:-1007 userInfo:nil];
    XCTAssertNotNil([URBaseErrorParser errorMap:sampleError], @"Error should not be nil");
    sampleError = [NSError errorWithDomain:@"Sample Domain" code:-1008 userInfo:nil];
    XCTAssertNotNil([URBaseErrorParser errorMap:sampleError], @"Error should not be nil");
    sampleError = [NSError errorWithDomain:@"Sample Domain" code:-1009 userInfo:nil];
    XCTAssertNotNil([URBaseErrorParser errorMap:sampleError], @"Error should not be nil");
    sampleError = [NSError errorWithDomain:@"Sample Domain" code:-1010 userInfo:nil];
    XCTAssertNotNil([URBaseErrorParser errorMap:sampleError], @"Error should not be nil");
    sampleError = [NSError errorWithDomain:@"Sample Domain" code:-1011 userInfo:nil];
    XCTAssertNotNil([URBaseErrorParser errorMap:sampleError], @"Error should not be nil");
    sampleError = [NSError errorWithDomain:@"Sample Domain" code:-1012 userInfo:nil];
    XCTAssertNotNil([URBaseErrorParser errorMap:sampleError], @"Error should not be nil");
}

@end
