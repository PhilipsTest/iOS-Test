//
//  DCContactsParserTest.m
//  DigitalCareLibrary
//
//  Created by sameer sulaiman on 26/05/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DCContactsParser.h"
#import "DCContactsModel.h"
#import "DCUtilities.h"

@interface DCContactsParserTests : XCTestCase
{
       NSData *jsonData;
       NSData *errorResponse;
       DCContactsParser *contactsParser;
}
@end

@implementation DCContactsParserTests

- (void)setUp
{
    [super setUp];

    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"result" ofType:@"json"];
    jsonData = [NSData dataWithContentsOfFile:filePath];
    contactsParser = [[DCContactsParser alloc] init];
}

- (void)tearDown
{
    contactsParser = nil;
    [super tearDown];
}

- (void)testParseContactDetailsForProperData
{
    NSDictionary *contactsDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    NSDictionary *phoneDataDict = [[[contactsDict objectForKey:@"data"] objectForKey:@"phone"] objectAtIndex:0];
    NSDictionary *chatDataDict = [[[contactsDict objectForKey:@"data"] objectForKey:@"chat"] objectAtIndex:0];
    NSDictionary *emailDataDict = [[[contactsDict objectForKey:@"data"] objectForKey:@"email"]objectAtIndex:0];
    DCContactsModel *contactsModel = [contactsParser parse:jsonData];
    XCTAssertNotNil(contactsModel,@"Contacts Model supposed to be formed");
    XCTAssertEqualObjects(contactsModel.phoneNumber, [DCUtilities formattedPhoneNumber:[phoneDataDict objectForKey:@"phoneNumber"]]);
    XCTAssertEqualObjects(contactsModel.openingHoursWeekdays, [phoneDataDict objectForKey:@"openingHoursWeekdays"]);
    XCTAssertEqualObjects(contactsModel.openingHoursSaturday, [phoneDataDict objectForKey:@"openingHoursSaturday"]);
    XCTAssertEqualObjects(contactsModel.chatContent,[chatDataDict objectForKey:@"content"]);
    XCTAssertEqualObjects(contactsModel.chatOpeningHoursSaturday, [chatDataDict objectForKey:@"openingHoursSaturday"]);
    XCTAssertEqualObjects(contactsModel.chatOpeningHoursWeekdays, [chatDataDict objectForKey:@"openingHoursWeekdays"]);
    XCTAssertEqualObjects(contactsModel.emailContentPath, [emailDataDict objectForKey:@"contentPath"]);
    XCTAssertEqualObjects(contactsModel.emailLabel, [emailDataDict objectForKey:@"label"]);
}

-(void)testPhoneKeyinDataParsing
{
    NSDictionary *contactsDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    NSDictionary *phoneDataDict = [[[contactsDict objectForKey:@"data"] objectForKey:@"phone"] objectAtIndex:0];
    DCContactsModel *contactsModel = [contactsParser parse:jsonData];
    
    XCTAssertEqualObjects(contactsModel.phoneNumber,[DCUtilities formattedPhoneNumber:[phoneDataDict objectForKey:@"phoneNumber"]]);
    XCTAssertEqualObjects(contactsModel.openingHoursSaturday, [phoneDataDict objectForKey:@"openingHoursSaturday"]);
    XCTAssertEqualObjects(contactsModel.openingHoursWeekdays, [phoneDataDict objectForKey:@"openingHoursWeekdays"]);
}

-(void)testChatKeyinDataParsing
{
    NSDictionary *contactsDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    NSDictionary *chatDataDict = [[[contactsDict objectForKey:@"data"] objectForKey:@"chat"] objectAtIndex:0];
    DCContactsModel *contactsModel = [contactsParser parse:jsonData];
    
    XCTAssertEqualObjects(contactsModel.chatContent,[chatDataDict objectForKey:@"content"]);
    XCTAssertEqualObjects(contactsModel.chatOpeningHoursWeekdays, [chatDataDict objectForKey:@"openingHoursWeekdays"]);
    XCTAssertEqualObjects(contactsModel.chatOpeningHoursSaturday, [chatDataDict objectForKey:@"openingHoursSaturday"]);
}

-(void)testEmailKeyinDataParsing
{
    NSDictionary *contactsDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    NSDictionary *emailDataDict = [[[contactsDict objectForKey:@"data"] objectForKey:@"email"]objectAtIndex:0];
    DCContactsModel *contactsModel = [contactsParser parse:jsonData];
    XCTAssertEqualObjects(contactsModel.emailContentPath,[emailDataDict objectForKey:@"contentPath"]);
    XCTAssertEqualObjects(contactsModel.emailLabel, [emailDataDict objectForKey:@"label"]);
}

-(void)testParsingErrorResponse
{
    [self loadErrorResponse];
    NSDictionary *contactsDict = [NSJSONSerialization JSONObjectWithData:errorResponse options:kNilOptions error:nil];
    BOOL errorMessageDict = [[contactsDict objectForKey:@"success"] boolValue];
    XCTAssertFalse(errorMessageDict,@"Error response received");
}

-(void)testParsingSuccessResponse
{
    NSDictionary *contactsDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    BOOL errorMessageDict = [[contactsDict objectForKey:@"success"] boolValue];
    XCTAssertTrue(errorMessageDict,@"Success  response received");
}

-(void)testEmailKeyinErrorResponse
{
    [self loadErrorResponse];
    NSDictionary *contactsDict = [NSJSONSerialization JSONObjectWithData:errorResponse options:kNilOptions error:nil];
    XCTAssertNotNil([contactsDict objectForKey:@"error"],@"No email data received");
}

-(void)loadErrorResponse
{
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"resultError" ofType:@"json"];
    errorResponse = [NSData dataWithContentsOfFile:filePath];
}

@end
