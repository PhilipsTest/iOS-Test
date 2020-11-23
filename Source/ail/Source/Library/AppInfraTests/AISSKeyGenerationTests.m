//
//  secKeyGenerationTests.m
//  AppInfra
//
//  Created by Ravi Kiran HR on 4/6/16.
/* Copyright (c) Koninklijke Philips N.V., 2016
* All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
*/  
//

#import <XCTest/XCTest.h>
#import "AISSCloneableClientGenerator.h"
#import <CommonCrypto/CommonCrypto.h>

@interface AISSKeyGenerationTests : XCTestCase

@end

@implementation AISSKeyGenerationTests

// test Key Generator
- (void)testKeyGenerator {
    
    NSData *dataSecureKey = [AISSCloneableClientGenerator generateSecureAccessKey];
    XCTAssertNotNil(dataSecureKey);
    XCTAssertTrue(dataSecureKey.length == kCCKeySizeAES256); // 256 bits key is used in the algorithm
}

// test Initialisation vector generator with valid key
- (void)testgenerateInitialisationVectorWithValidKey
{
    NSData *dataSecureKey = [AISSCloneableClientGenerator generateSecureAccessKey];
    NSData *dataInitializationVector = [AISSCloneableClientGenerator generateInitialisationVectorForKey:dataSecureKey];
    XCTAssertNotNil(dataInitializationVector);
    XCTAssertTrue(dataInitializationVector.length == kCCKeySizeAES128); // IV size must be the same length as the selected algorithm's block size(i.e 128 bits)
}

// test Initialisation vector generator with no key
- (void)testgenerateInitialisationVectorWithNoKey
{
    NSData *dataInitializationVector = [AISSCloneableClientGenerator generateInitialisationVectorForKey:nil];
    XCTAssertNil(dataInitializationVector);
}


@end
