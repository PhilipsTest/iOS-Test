//
//  TestAssertModel.m
//  PRXClient
//
//  Created by KRISHNA KUMAR on 04/11/15.
//  Copyright © 2017 Koninklijke Philips N.V.. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PRXAssetResponse.h"
#import "PRXAssetRequest.h"
#import "NSBundle+Bundle.h"
#import "AISDMock.h"
#import <AppInfra/AppInfra.h>
@interface testAssertModel : XCTestCase
{
    NSDictionary* json;
    id<AIAppInfraProtocol> appInfra;
}

@end

@implementation testAssertModel
- (void)setUp {
    [super setUp];
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"asset" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:kNilOptions
                                                           error:nil];
    
    [NSBundle loadSwizzler];
    appInfra  = [[AIAppInfra alloc]initWithBuilder:nil];
}

-(void)testAssetSuccessResponse
{
    PRXAssetResponse *response=[[PRXAssetResponse alloc] init];
    [response parseResponse:json];
    XCTAssertTrue(response.success, @"Success Response");
}

-(void)testAssetData
{
    PRXAssetResponse *response=[[PRXAssetResponse alloc] init];
    [response parseResponse:json];
    XCTAssertNotNil(response.data,@"Data object is not nill");
}

-(void)testErrorResponse
{
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"error" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    json = [NSJSONSerialization JSONObjectWithData:jsonData
                                           options:kNilOptions
                                             error:nil];
    PRXAssetResponse *response=[[PRXAssetResponse alloc] init];
    [response parseResponse:json];
    XCTAssertFalse(response.success, @"Error in response");
    
}


- (void) testResponseDataValidOrNot{
    PRXAssetRequest *request = [[PRXAssetRequest alloc] init];
    XCTAssertTrue([[request getResponse:json] isKindOfClass:[PRXAssetResponse class]]);
}

-(void)testGetRequestUrl
{
    PRXAssetRequest *data=[[PRXAssetRequest alloc] initWithSector:B2C ctnNumber:@"PR3743/00" catalog:CONSUMER];
   
    XCTestExpectation *expectation =
    [self expectationWithDescription:@"serviceUrl"];
    appInfra.serviceDiscovery = [[AISDMock alloc]init];
    [data getRequestUrlFromAppInfra:appInfra
                      completionHandler:^(NSString *serviceURL, NSError *error) {
                          
                          XCTAssertTrue([serviceURL containsString:@"https://www.philips.com/prx/product/B2C/"]);
                            XCTAssertTrue([serviceURL containsString:@"CONSUMER/products/PR3743/00.assets"]);
                        
                          
                          [expectation fulfill];
                          
                          
                      }];

    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

@end
