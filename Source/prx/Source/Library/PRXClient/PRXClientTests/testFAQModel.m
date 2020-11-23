//
//  testFAQModel.m
//  PRXClient
//
//  Created by KRISHNA KUMAR on 04/11/15.
//  Copyright © 2017 Koninklijke Philips N.V.. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PRXSupportResponse.h"
#import "PRXSupportRequest.h"
#import "NSBundle+Bundle.h"
#import <AppInfra/AppInfra.h>
#import "AISDMock.h"
@interface testFAQModel : XCTestCase
{
    NSDictionary* json;
    id<AIAppInfraProtocol> appInfra;
}

@end

@implementation testFAQModel

- (void)setUp {
    [super setUp];
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"faq" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    json = [NSJSONSerialization JSONObjectWithData:jsonData
                                           options:kNilOptions
                                             error:nil];
    [NSBundle loadSwizzler];
    appInfra  = [[AIAppInfra alloc]initWithBuilder:nil];
}

-(void)testAssetSuccessResponse
{
    PRXSupportResponse *response=[[PRXSupportResponse alloc] init];
    [response parseResponse:json];
    XCTAssertTrue(response.success, @"Success Response");
}

-(void)testAssetData
{
    PRXSupportResponse *response=[[PRXSupportResponse alloc] init];
    [response parseResponse:json];
    XCTAssertNotNil(response.data,@"Data object is not nill");
}

-(void)testResponseDataValidOrNot
{
    PRXSupportRequest *builder=[[PRXSupportRequest alloc] init];
    XCTAssertTrue([[builder getResponse:json] isKindOfClass:[PRXSupportResponse class]]);
}

-(void)testGetRequestUrl
{
    PRXSupportRequest *data=[[PRXSupportRequest alloc] initWithSector:B2C ctnNumber:@"PR3743/00" catalog:CONSUMER];
   
    XCTestExpectation *expectation =
    [self expectationWithDescription:@"testGetRequestUrl.faqmodel"];
        appInfra  = [[AIAppInfra alloc]initWithBuilder:nil];
    AISDMock *sdmock = [[AISDMock alloc]init];
    sdmock.urls =  @{@"prxclient.support":@"https://www.philips.com/prx/product/B2C/CONSUMER/products/PR3743/00.support"};
    appInfra.serviceDiscovery = sdmock;
    [data getRequestUrlFromAppInfra:appInfra
                  completionHandler:^(NSString *serviceURL, NSError *error) {
                      
                      XCTAssertTrue([serviceURL containsString:@"https://www.philips.com/prx/product/B2C/"]);
                      XCTAssertTrue([serviceURL containsString:@"CONSUMER/products/PR3743/00.support"]);
                      
                      
                      [expectation fulfill];
                      
                      
                  }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];

}

@end
