//
//  DCRequestTest.m
//  DigitalCareLibrary
//
//  Created by KRISHNA KUMAR on 08/12/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import <XCTest/XCTest.h>
#import "DCContactsRequestUrl.h"
#import "DCServiceTaskHandler.h"
#import "DCCategoryRequestUrl.h"
#import <OCMock/OCMock.h>
#import "DCConstants.h"
#import "DCRequestBaseUrl.h"
#import "DCPluginManager.h"

#define TIMEOUT 10

@interface DCRequestUrlTest : XCTestCase

@property (nonatomic,assign)BOOL isWaitingForResponse;
@property (nonatomic,assign)BOOL isFetchedResponse;

@end

@implementation DCRequestUrlTest

- (void)testContactRequestUrl
{
    DCContactsRequestUrl *contactRequest=[[DCContactsRequestUrl alloc] init];
    contactRequest.subUrl = [self requestUrl];
    contactRequest.productCategory = @"Product";
    XCTAssertTrue([[contactRequest requestUrl] isKindOfClass:[NSString class]]);
    XCTAssertNotNil([contactRequest requestUrl]);
}

- (void)testCategoryRequestUrl
{
    DCCategoryRequestUrl *categoryRequest=[[DCCategoryRequestUrl alloc] init];
    categoryRequest.subUrl = [self requestUrl];
    XCTAssertTrue([[categoryRequest requestUrl] isKindOfClass:[NSString class]]);
    XCTAssertNotNil([categoryRequest requestUrl]);
}

- (NSString*)requestUrl
{
    NSString *url = [NSString stringWithFormat:@"https://www.philips.com/search/search?q='""'&lat=0.000f&lng=0.000f&subcategory=%@&country=%@&type=servicers&sid=cp-dlr&output=json",@"HAIR_STYLERS_SU",  @"in"];
    return  url;
}

-(void)testRequestBase
{
    DCRequestBaseUrl *baseRequest = [[DCRequestBaseUrl alloc] init];
    XCTAssertThrows([baseRequest requestUrl]);
}

@end
