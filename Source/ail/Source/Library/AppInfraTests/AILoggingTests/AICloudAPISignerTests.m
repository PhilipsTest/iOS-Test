//
//  AICloudAPISignerTests.m
//  AppInfraTests
//
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AICloudApiSigner.h"

#define sharedAPISecret @"YMV5QLdKOW9vlQ1fgG0txw8Tdglfe2ePIFwkub68eN8="
#define hexKey @"96a5cd559d9299e4632faae2320777347d0e35acd77e3c1e9edcf244a30443ad3fcefdbb62806f15bb758c5903a0d7be635e0240cc671261f14cb37cc2ef1153"

@interface AICloudAPISignerTests : XCTestCase {
    AICloudApiSigner *testAPISigner;
}
@end

@implementation AICloudAPISignerTests

- (void)setUp {
    [super setUp];
    testAPISigner = [[AICloudApiSigner alloc] initApiSigner:sharedAPISecret andhexKey:hexKey];
}

- (void)tearDown {
    testAPISigner = nil;
    [super tearDown];
}

- (void)testCreateSignature {
    AICloudApiSigner *logApiSigning = [[AICloudApiSigner alloc]initApiSigner:sharedAPISecret andhexKey:hexKey];
    NSDictionary *headerDict = @{@"SignedDate":@"testString"};
    NSString *createdSignature = [logApiSigning createSignature:nil dhpUrl:nil queryString:nil headers:headerDict requestBody:nil];
    NSString *expectedSignature = @"HmacSHA256;Credential:YMV5QLdKOW9vlQ1fgG0txw8Tdglfe2ePIFwkub68eN8=;SignedHeaders:SignedDate;Signature:c+ringIImXHGO4CcfN92klYih8/qxwYDMu4LORWsnH8=";
    XCTAssertEqualObjects(createdSignature, expectedSignature, @"Expected signature is not equal to created signature");
    
    headerDict = @{@"":@""};
    createdSignature = [logApiSigning createSignature:nil dhpUrl:nil queryString:nil headers:headerDict requestBody:nil];
    XCTAssertNotEqualObjects(createdSignature, expectedSignature, @"Expected signature should not be equal to created signature as signed date is passed empty");
}

@end
