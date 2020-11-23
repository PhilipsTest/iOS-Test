//
//  DCWebViewModelTests.m
//  PhilipsConsumerCare
//
//  Created by sameer sulaiman on 7/26/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "DCWebViewModel.h"

@interface DCWebViewModelTests : XCTestCase

@end

@implementation DCWebViewModelTests

- (void)testCanStubWebViewModelClassMethod
{
    DCWebViewModel *dummyObject = [DCWebViewModel getModelForType:DCLIVECHAT andUrl:kLocateNearYouURL];
    id mock = [OCMockObject mockForClass:[DCWebViewModel class]];
    [[[mock stub] andReturn:dummyObject] new];
    id newObject = [DCWebViewModel new];
    XCTAssertEqualObjects(dummyObject, newObject, @"Webview Should have stubbed +new method");
}

- (void)testCanStubWebViewModelClassMethodForEmail
{
    DCWebViewModel *dummyObject = [DCWebViewModel getModelForType:DCEMAIL andUrl:kLocateNearYouURL];
    id mock = [OCMockObject mockForClass:[DCWebViewModel class]];
    [[[mock stub] andReturn:dummyObject] new];
    id newObject = [DCWebViewModel new];
    XCTAssertEqualObjects(dummyObject, newObject, @"Webview Should have stubbed EMail model");
}

- (void)testCanStubWebViewModelClassMethodForFacebook
{
    DCWebViewModel *dummyObject = [DCWebViewModel getModelForType:DCFACEBOOK andUrl:kLocateNearYouURL];
    id mock = [OCMockObject mockForClass:[DCWebViewModel class]];
    [[[mock stub] andReturn:dummyObject] new];
    id newObject = [DCWebViewModel new];
    XCTAssertEqualObjects(dummyObject, newObject, @"Webview Should have stubbed Facebook model");
}

- (void)testCanStubWebViewModelClassMethodForTwitter
{
    DCWebViewModel *dummyObject = [DCWebViewModel getModelForType:DCTWITTER andUrl:kLocateNearYouURL];
    id mock = [OCMockObject mockForClass:[DCWebViewModel class]];
    [[[mock stub] andReturn:dummyObject] new];
    id newObject = [DCWebViewModel new];
    XCTAssertEqualObjects(dummyObject, newObject, @"Webview Should have stubbed Twitter model");
}

- (void)testCanStubWebViewModelClassMethodForProductInfo
{
    DCWebViewModel *dummyObject = [DCWebViewModel getModelForType:DCPRODUCTINFO andUrl:kLocateNearYouURL];
    id mock = [OCMockObject mockForClass:[DCWebViewModel class]];
    [[[mock stub] andReturn:dummyObject] new];
    id newObject = [DCWebViewModel new];
    XCTAssertEqualObjects(dummyObject, newObject, @"Webview Should have stubbed Prodcut info model");
}

- (void)testCanStubWebViewModelClassMethodForProductManual
{
    DCWebViewModel *dummyObject = [DCWebViewModel getModelForType:DCPRODUCTMANUAL andUrl:kLocateNearYouURL];
    id mock = [OCMockObject mockForClass:[DCWebViewModel class]];
    [[[mock stub] andReturn:dummyObject] new];
    id newObject = [DCWebViewModel new];
    XCTAssertEqualObjects(dummyObject, newObject, @"Webview Should have stubbed Productmanual model");
}

- (void)testCanStubWebViewModelClassMethodForProductReview
{
    DCWebViewModel *dummyObject = [DCWebViewModel getModelForType:DCPRODUCTREVIEW andUrl:kLocateNearYouURL];
    id mock = [OCMockObject mockForClass:[DCWebViewModel class]];
    [[[mock stub] andReturn:dummyObject] new];
    id newObject = [DCWebViewModel new];
    XCTAssertEqualObjects(dummyObject, newObject, @"Webview Should have stubbed Product review model");
}

- (void)testCanStubWebViewModelClassMethodForFaqDetails
{
    DCWebViewModel *dummyObject = [DCWebViewModel getModelForType:DCFAQDETAILS andUrl:kLocateNearYouURL];
    id mock = [OCMockObject mockForClass:[DCWebViewModel class]];
    [[[mock stub] andReturn:dummyObject] new];
    id newObject = [DCWebViewModel new];
    XCTAssertEqualObjects(dummyObject, newObject, @"Webview Should have stubbed FaqDetails model");
}

@end
