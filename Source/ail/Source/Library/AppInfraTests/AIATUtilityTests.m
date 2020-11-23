//
//  AIATUtilityTests.m
//  AppInfra
//
//  Created by leslie on 20/09/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AIATUtility.h"


@interface AIATUtilityTests : XCTestCase

@end

@implementation AIATUtilityTests

- (void)testInit {
    AIATUtility *utility = [AIATUtility sharedInstance];
    utility.previousPage = @"test";
    XCTAssertEqualObjects(utility.previousPage, [AIATUtility sharedInstance].previousPage);
}

@end

