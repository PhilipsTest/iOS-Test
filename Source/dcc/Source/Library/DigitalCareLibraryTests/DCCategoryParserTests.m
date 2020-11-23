//
//  DCCategoryParserTests.m
//  PhilipsConsumerCare
//
//  Created by sameer sulaiman on 8/3/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DCCategoryParser.h"
#import "DCCategoryModel.h"

@interface DCCategoryParserTests : XCTestCase
{
    NSData *jsonData;
    NSData *errorResponse;
    DCCategoryParser *categoryParser;
}
@end

@implementation DCCategoryParserTests

- (void)setUp {
    [super setUp];

    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"categorySuccessResponse" ofType:@"json"];
    jsonData = [NSData dataWithContentsOfFile:filePath];
    categoryParser = [[DCCategoryParser alloc] init];
}

- (void)tearDown {
    categoryParser = nil;
    [super tearDown];
}

- (void)testCategoryData
{
    NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    DCCategoryModel *categoryModel = [categoryParser parse:jsonData];
    XCTAssertEqualObjects(categoryModel.productCategory, [[dict objectForKey:@"data"] objectForKey:@"parentCode"]);
}

-(void)testParsingErrorResponse
{
    [self loadErrorResponse];
    NSDictionary *categoryDict = [NSJSONSerialization JSONObjectWithData:errorResponse options:kNilOptions error:nil];
   DCCategoryModel *categoryModel = [categoryParser parse:errorResponse];
    NSLog(@"error === %@",[categoryDict objectForKey:@"ERROR"]);
    XCTAssertEqualObjects(categoryModel.exceptionMessage, [[categoryDict objectForKey:@"ERROR"] objectForKey:@"errorMessage"]);
}

- (void)loadErrorResponse
{
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"categoryErrorResponse" ofType:@"json"];
    errorResponse = [NSData dataWithContentsOfFile:filePath];
}

@end
