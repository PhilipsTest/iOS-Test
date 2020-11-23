//
//  MockStudNsobjectClassTest.m
//  DigitalCare
//
//  Created by KRISHNA KUMAR on 23/03/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "DCUtilities.h"
#import "dcconfigurationContainer.h"
#import "DCServiceTaskHandler.h"
#import "DCServiceTaskFactory.h"
#import "DCRequestBaseUrl.h"
#import "DCContactsModel.h"
#import "DCParser.h"
#import "DCContactsRequestUrl.h"

@interface DCClassMockingAndStubTest : XCTestCase

@end

@implementation DCClassMockingAndStubTest

- (void)testCanStubUtilityClassMethod
{
    DCUtilities *dummyObject = [[DCUtilities alloc] init];
    id mock = [OCMockObject mockForClass:[dummyObject class]];
    [[[mock stub] andReturn:dummyObject] new];
    id newObject = [DCUtilities new];
    XCTAssertEqualObjects(dummyObject, newObject, @"Should have stubbed + new method");
}

- (void)testCanStubConfigurationClassMethod
{
    DCConfigurationContainer *dummyObject = [[DCConfigurationContainer alloc] init];
    id mock = [OCMockObject mockForClass:[DCConfigurationContainer class]];
    [[[mock stub] andReturn:dummyObject] new];
    id newObject = [DCConfigurationContainer new];
    XCTAssertEqualObjects(dummyObject, newObject, @"Should have stubbed +new method");
}

- (void)testCanStubServiceTaskClassMethod
{
    DCServiceTaskHandler *dummyObject = [[DCServiceTaskHandler alloc] init];
    id mock = [OCMockObject mockForClass:[DCServiceTaskHandler class]];
    [[[mock stub] andReturn:dummyObject] new];
    id newObject = [DCServiceTaskHandler new];
    XCTAssertEqualObjects(dummyObject, newObject, @"Should have stubbed +new method");
}

- (void)testCanStubServiceTaskFactoryMethod
{
    DCServiceTaskFactory *dummyObject = [[DCServiceTaskFactory alloc] init];
    id mock = [OCMockObject mockForClass:[DCServiceTaskFactory class]];
    [[[mock stub] andReturn:dummyObject] new];
    id newObject = [DCServiceTaskFactory new];
    XCTAssertEqualObjects(dummyObject, newObject, @"Should have stubbed +new method");
    DCContactsRequestUrl *requestObject = [[DCContactsRequestUrl alloc] init];
    DCServiceTaskHandler *handlerObject = [[DCServiceTaskHandler alloc] init];
    DCServiceTaskHandler *handlerObject1 = [dummyObject getInstanceforRequest:requestObject];
    XCTAssertNotEqualObjects(handlerObject,handlerObject1 , @"Should be differnt handler objects");
}

- (void)testCanStubRequestBaseClassMethod
{
    DCRequestBaseUrl *dummyObject = [[DCRequestBaseUrl alloc] init];
    id mock = [OCMockObject mockForClass:[DCRequestBaseUrl class]];
    [[[mock stub] andReturn:dummyObject] new];
    id newObject = [DCRequestBaseUrl new];
    XCTAssertEqualObjects(dummyObject, newObject, @"Should have stubbed +new method");
}

- (void)testCanStubContactsModelClassMethod
{
    DCContactsModel *dummyObject = [[DCContactsModel alloc] init];
    id mock = [OCMockObject mockForClass:[DCContactsModel class]];
    [[[mock stub] andReturn:dummyObject] new];
    id newObject = [DCContactsModel new];
    XCTAssertEqualObjects(dummyObject, newObject, @"Should have stubbed +new method");
}

- (void)testCanStubParserClassMethod
{
    DCParser *dummyObject = [[DCParser alloc] init];
    XCTAssertNil([dummyObject parse:nil]);
    id mock = [OCMockObject mockForClass:[DCParser class]];
    [[[mock stub] andReturn:dummyObject] new];
    id newObject = [DCParser new];
    XCTAssertEqualObjects(dummyObject, newObject, @"Should have stubbed +new method");
}
@end
