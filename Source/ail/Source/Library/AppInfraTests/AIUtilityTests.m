//
//  AIUtilityTests.m
//  AppInfra
//
//  Created by Hashim MH on 16/08/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AIUtility.h"
@interface AIUtilityTests : XCTestCase
{
    NSDate *convertedDate;
    NSString *convertedString;
    NSString *givenStrDate;
    NSDate *givenDate;
}

@end

@implementation AIUtilityTests

- (void)setUp {
    [super setUp];
}

- (void)testUnsafeCharacter {
    XCTAssertTrue([AIUtility URLUnSafeCharactersExists:@"http://!*'();:@&=+$,/?%#[]"]);
    XCTAssertFalse([AIUtility URLUnSafeCharactersExists:@"www.philips.com"]);
}

-(void)testIsNull {
    id value1 = nil;
    XCTAssertTrue([AIUtility isNull:value1]);
    id value2 = NULL;
    XCTAssertTrue([AIUtility isNull:value2]);
    id value3 = [NSNull null];
    XCTAssertTrue([AIUtility isNull:value3]);
    id value4;
    XCTAssertTrue([AIUtility isNull:value4]);
    
    id value5 = [NSObject new];
    XCTAssertFalse([AIUtility isNull:value5]);
}

-(void)givenDateToConvert:(NSDate *)date{
    givenDate = date;
}

-(void)givenStringToConvert:(NSString *)strDate{
    givenStrDate = strDate;
}

-(void)whenConvertDateToStringInvoked{
    convertedString = [AIUtility convertDatetoString:givenDate];
}

-(void)whenConvertStringToDateInvoked{
    convertedDate = [AIUtility convertStringtoDate:givenStrDate];
}

-(void)thenDateConvertedToExpectedDateString:(NSString *)expectedStrDate{
    XCTAssertEqualObjects([[convertedString componentsSeparatedByString:@"T"]objectAtIndex:0],[[expectedStrDate componentsSeparatedByString:@"T"]objectAtIndex:0]);
}

-(void)thenConvertedDateIsNotNil{
    XCTAssertNotNil(convertedDate);
}

-(void)thenConvertedDateStringIsNotNil{
    XCTAssertNotNil(convertedString);
}

-(void)thenStringConvertedToExpectedDate:(NSString *)strExpectedDate{
    NSString *strConvertedDate = [AIUtility convertDatetoString:convertedDate];
    XCTAssertEqualObjects(strConvertedDate,strExpectedDate);
}

-(void)testDateToStringConversion{
    [self givenDateToConvert:[[NSDate alloc]initWithTimeIntervalSince1970:0]];
    [self whenConvertDateToStringInvoked];
    [self thenDateConvertedToExpectedDateString:@"1970-01-01T05:30:00.000Z"];
    [self thenConvertedDateStringIsNotNil];
}

-(void)testStringToDateConversion{
    [self givenStringToConvert:@"1970-01-01T05:30:00.000Z"];
    [self whenConvertStringToDateInvoked];
    [self thenConvertedDateIsNotNil];
    [self thenStringConvertedToExpectedDate:@"1970-01-01T05:30:00.000Z"];
}



@end
