//
//  DCConsumerProductInfoTests.m
//  DigitalCareLibrary
//
//  Created by KRISHNA KUMAR on 04/03/16.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import <XCTest/XCTest.h>
#import "DCConsumerProductInformation.h"
#import "PRXSummaryData.h"

@interface DCConsumerProductInfoTests : XCTestCase
{
    DCConsumerProductInformation *dcInfo;
}

@end

@implementation DCConsumerProductInfoTests

-(void)testSummaryDataWithNil
{
    dcInfo = [[DCConsumerProductInformation alloc]initWithSummaryData:nil withSector:B2C withCatalog:CARE];
    XCTAssertNotNil(dcInfo);
}
-(void)testSummaryData
{
    NSString *filePath = [[NSBundle bundleForClass:[self class]]pathForResource:@"PrxResponseWithProperData" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSError* error;
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:kNilOptions
                                                           error:&error];
    PRXSummaryData *prxSummaryData = [[PRXSummaryData alloc]initWithDictionary:[dict valueForKey:@"data"]];
    dcInfo = [[DCConsumerProductInformation alloc]initWithSummaryData:prxSummaryData withSector:B2C withCatalog:CARE];
    XCTAssertNotNil(dcInfo);
}
@end
