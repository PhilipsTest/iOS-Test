//
//  NSString+DCAdditionsTest.m
//  DigitalCareLibrary
//
//  Created by KRISHNA KUMAR on 10/06/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSString+DCAdditions.h"

@interface NSString_DCAdditionsTest : XCTestCase

@end

@implementation NSString_DCAdditionsTest

-(void)testGetHexColorNotEqualObjects
{
    NSString *color=@"#345645";
   XCTAssertNotEqualObjects(color,[color getHexColor]);
}

-(void)testGetHexColorEqualObjects
{
    NSString *color=@"#FF0000";
    UIColor *test=[UIColor redColor];
    XCTAssertEqualObjects(test,[color getHexColor]);
}

@end
