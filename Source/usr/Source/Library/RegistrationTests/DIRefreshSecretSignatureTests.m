//
//  DIRefreshSecretSignatureTests.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <XCTest/XCTest.h>
#import "DIRefreshSecretSignature.h"

@interface DIRefreshSecretSignatureTests : XCTestCase

@end

@implementation DIRefreshSecretSignatureTests

- (void)testGetAuthorizationHeader {
    NSString *apiSignature = [DIRefreshSecretSignature buildRefreshSignatureFromDate:@"2016-03-28 07:20:31" refreshSecret:@"aa6c3f0dd953bcf11053e00e686af2e0d9b1d05b" accessToken:@"3kr6baw3tqbuyg58"];
    XCTAssertTrue([@"YPCh1N0aEs3r4+2uKoNTqBeT/aw=" isEqualToString:apiSignature]);
}

@end
