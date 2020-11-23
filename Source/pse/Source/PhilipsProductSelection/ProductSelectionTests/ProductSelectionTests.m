//
//  ProductSelectionTests.m
//  ProductSelectionTests
//
//  Created by KRISHNA KUMAR on 13/01/16.
//  Copyright © 2016 KRISHNA KUMAR. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PSUtility.h"

@interface ProductSelectionTests : XCTestCase

@end

@implementation ProductSelectionTests

-(void)testValidImageTypeOrNot
{
   XCTAssertFalse([PSUtility isRequiredTypeImage:@"ABC"]);
   XCTAssertTrue([PSUtility isRequiredTypeImage:@"APP"]);
   XCTAssertTrue([PSUtility isRequiredTypeImage:@"DPP"]);
   XCTAssertTrue([PSUtility isRequiredTypeImage:@"MI1"]);
   XCTAssertTrue([PSUtility isRequiredTypeImage:@"PID"]);
   XCTAssertFalse([PSUtility isRequiredTypeImage:@"123"]);
   XCTAssertFalse([PSUtility isRequiredTypeImage:@""]);
}

-(void)testReachableUtility
{
    XCTAssertTrue([PSUtility isNetworkReachable]);
}

//-(void)testPortraitModeUtility
//{
//    XCTAssertTrue([PSUtility isPortraitMode]);
//}

//-(void)testDeviceUtiltiy
//{
//    XCTAssertTrue([PSUtility isIphone]);
//}

@end
