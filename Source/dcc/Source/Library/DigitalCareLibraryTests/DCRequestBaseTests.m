//
//  DCRequestBaseTests.m
//  PhilipsConsumerCare
//
//  Created by sameer sulaiman on 7/25/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DCRequestBaseUrl.h"

@interface DCRequestBaseTests : XCTestCase

@end

@implementation DCRequestBaseTests

-(void)testRequestBase
{
    DCRequestBaseUrl *baseRequest = [[DCRequestBaseUrl alloc] init];
    XCTAssertThrows([baseRequest requestUrl]);
}

@end
