//
//  testSummaryModel.m
//  PRXClient
//
//  Created by KRISHNA KUMAR on 04/11/15.
//  Copyright © 2017 Koninklijke Philips N.V.. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PRXSummaryResponse.h"
#import "PRXSummaryRequest.h"
#import "NSBundle+Bundle.h"
#import <AppInfra/AppInfra.h>
#import "AISDMock.h"
@interface testSummaryModel : XCTestCase
{
    NSDictionary* json;
    id<AIAppInfraProtocol> appInfra;
}

@end

@implementation testSummaryModel

- (void)setUp {
    [super setUp];
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"summary" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    json = [NSJSONSerialization JSONObjectWithData:jsonData
                                           options:kNilOptions
                                             error:nil];
    [NSBundle loadSwizzler];
    appInfra  = [[AIAppInfra alloc]initWithBuilder:nil];
}

-(void)testAssetSuccessResponse
{
    PRXSummaryResponse *response=[[PRXSummaryResponse alloc] init];
    [response parseResponse:json];
    XCTAssertTrue(response.success, @"Success Response");
}

-(void)testAssetData
{
    PRXSummaryResponse *response=[[PRXSummaryResponse alloc] init];
    [response parseResponse:json];
    XCTAssertNotNil(response.data,@"Data object is not nill");
}

-(void)testResponseDataValidOrNot
{
    PRXSummaryRequest *builder=[[PRXSummaryRequest alloc] init];
    XCTAssertTrue([[builder getResponse:json] isKindOfClass:[PRXSummaryResponse class]]);
}


-(void)testGetRequestUrl
{
    PRXSummaryRequest *data=[[PRXSummaryRequest alloc] initWithSector:B2C ctnNumber:@"PR3743/00" catalog:CONSUMER];
    XCTestExpectation *expectation =
    [self expectationWithDescription:@"serviceUrl"];
    AISDMock *sdmock = [[AISDMock alloc]init];
    sdmock.urls =  @{@"prxclient.summary":@"https://www.philips.com/prx/product/B2C/CONSUMER/products/PR3743/00.summary"};
    appInfra.serviceDiscovery = sdmock;
    [data getRequestUrlFromAppInfra:appInfra
                  completionHandler:^(NSString *serviceURL, NSError *error) {
                      
                      XCTAssertTrue([serviceURL containsString:@"https://www.philips.com/prx/product/B2C/"]);
                      XCTAssertTrue([serviceURL containsString:@"CONSUMER/products/PR3743/00.summary"]);
                      
                      
                      [expectation fulfill];
                      
                      
                  }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];

}

@end
