//
//  DCFAQTests.m
//  DigitalCareLibrary
//
//  Created by KRISHNA KUMAR on 19/04/16.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import <XCTest/XCTest.h>
#import "DCFAQQuestionViewController.h"
#import "DCWebViewController.h"
#import "DCConstants.h"
#import "DCQuestionCell.h"
#import "DCFAQCell.h"
#import <AppInfra/AppInfra.h>
#import <OCMock/OCMock.h>
#import "PRXResponseData.h"
#import <PhilipsPRXClient/PRXSupportResponse.h>
#import <PhilipsPRXClient/PRXFaqData.h>
#import <PhilipsPRXClient/PRXFaqRichTexts.h>
#import <PhilipsPRXClient/PRXFaqRichText.h>
#import <PhilipsPRXClient/PRXFaqChapter.h>
#import "DCAppInfraWrapper.h"
#import "AppDelegate.h"
#import "PRXFaqItem.h"

@interface DCFAQTests : XCTestCase
{
    UIStoryboard *storyboard;
    NSData *jsonData;
    NSDictionary *dict;
    NSMutableArray *questionData;
    
}
@property (nonatomic,strong) DCFAQQuestionViewController *vc;
@property(nonatomic,strong) DCWebViewController *detailVC;
@property(nonatomic,strong) PRXSupportResponse *responseData;

@end
@interface DCFAQQuestionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain)NSMutableArray *tableData;
-(void)pushWebViewWithUrlString:(NSString *)urlString;
-(void)parseFAQFromResponse:(NSArray *)response;
@end

@implementation DCFAQTests


- (void)setUp {
    [super setUp];
    NSString *filePath = [[NSBundle bundleForClass:[self class]]pathForResource:@"FAQResponse" ofType:@"json"];
    jsonData = [NSData dataWithContentsOfFile:filePath];
    [DCAppInfraWrapper sharedInstance].appInfra = [AIAppInfra buildAppInfraWithBlock:nil];
    dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData: jsonData options:NSJSONReadingMutableContainers error:nil];
    questionData = [[NSMutableArray alloc]initWithArray:[[[[[dict objectForKey:@"data"] objectForKey:@"richTexts"] objectForKey:@"richText"] valueForKey:@"item"] objectAtIndex:0]];
    storyboard = [UIStoryboard storyboardWithName:@"ReadFAQs" bundle:StoryboardBundle];
    self.vc = [storyboard instantiateViewControllerWithIdentifier:@"ReadFAQs"];
    [self.vc view];
    self.detailVC = [DCWebViewController createWebViewForUrl:@"http://www.google.com" andType:DCFAQDETAILS];
    [self.detailVC view];
    PRXResponseData *PRXResponseData = [[PRXSupportResponse alloc] parseResponse:dict];
    self.responseData = (PRXSupportResponse *)PRXResponseData;
    self.vc.tableData = [NSMutableArray arrayWithArray:self.responseData.data.richTexts.richText];
}

- (void)tearDown {
    self.vc = nil;
    self.detailVC = nil;
    jsonData=nil;
    [super tearDown];
}

#pragma mark - UITableView tests
- (void)testThatViewConformsToUITableViewDataSource
{
    XCTAssertTrue([self.vc conformsToProtocol:@protocol(UITableViewDataSource) ], @"View does not conform to UITableView datasource protocol");
}


- (void)testThatViewConformsToUITableViewDelegate
{
    XCTAssertTrue([self.vc conformsToProtocol:@protocol(UITableViewDelegate) ], @"View does not conform to UITableView delegate protocol");
}
- (void)testTableHasDataSource
{
    XCTAssertNotNil(self.vc.tblQuestionList.dataSource, @"Table datasource cannot be nil");
}

- (void)testTableHasDelegate
{
    XCTAssertNotNil(self.vc.tblQuestionList.delegate, @"Table delegate cannot be nil");
}

-(void)PushWebViewWithUrlString
{
    NSString *strUrl = @"http://www.philips.co.in/c-f/XC000004953/can-i-swim/sunbathe/salon-tan-or-use-a-sauna-after-epilating?";
     XCTAssertNotNil(self.detailVC,@"DCWebView is not nil");
    [self.vc pushWebViewWithUrlString:strUrl];
    id mockNavController = [OCMockObject mockForClass:[UINavigationController class]];
    id mock = [OCMockObject partialMockForObject:self.vc];
    [[[mock stub] andReturn:mockNavController] navigationController];
    [[mockNavController expect] pushViewController:self.detailVC animated:YES];
    [mock verify];
}

-(void)testParseFAQFromResponse
{
    PRXFaqRichTexts *richText = [PRXFaqRichTexts modelObjectWithDictionary:[[dict objectForKey:@"data"] objectForKey:@"richTexts"]];
    PRXResponseData *PRXResponseData = [[PRXSupportResponse alloc] parseResponse:dict];
    self.responseData = (PRXSupportResponse *)PRXResponseData;
    [self.vc parseFAQFromResponse:self.responseData.data.richTexts.richText];
    XCTAssertNotNil(self.responseData,@"responseData is not nil");
    XCTAssertEqualObjects([[richText.richText objectAtIndex:0] valueForKey:@"supportType"], [[[[[dict objectForKey:@"data"] objectForKey:@"richTexts"] objectForKey:@"richText"] objectAtIndex:0]valueForKey:@"type"]);
    XCTAssertEqualObjects([[[richText.richText objectAtIndex:0] valueForKey:@"chapter"] valueForKey:@"referenceName"], [[[[[[dict objectForKey:@"data"] objectForKey:@"richTexts"] objectForKey:@"richText"] objectAtIndex:0]valueForKey:@"chapter"] valueForKey:@"referenceName"]);
    XCTAssertEqualObjects([[[richText.richText objectAtIndex:0] valueForKey:@"chapter"] valueForKey:@"code"], [[[[[[dict objectForKey:@"data"] objectForKey:@"richTexts"] objectForKey:@"richText"] objectAtIndex:0]valueForKey:@"chapter"] valueForKey:@"code"]);
    XCTAssertEqualObjects([[[richText.richText objectAtIndex:0] valueForKey:@"chapter"] valueForKey:@"name"], [[[[[[dict objectForKey:@"data"] objectForKey:@"richTexts"] objectForKey:@"richText"] objectAtIndex:0]valueForKey:@"chapter"] valueForKey:@"name"]);
    XCTAssertEqualObjects([[[richText.richText objectAtIndex:0] valueForKey:@"chapter"] valueForKey:@"rank"], [[[[[[dict objectForKey:@"data"] objectForKey:@"richTexts"] objectForKey:@"richText"] objectAtIndex:0]valueForKey:@"chapter"] valueForKey:@"rank"]);
    XCTAssertEqualObjects([[[[richText.richText objectAtIndex:0] valueForKey:@"questionList"] objectAtIndex:0] valueForKey:@"code"],[[[[[[[dict objectForKey:@"data"] objectForKey:@"richTexts"] objectForKey:@"richText"] valueForKey:@"item"] objectAtIndex:0]valueForKey:@"code"] objectAtIndex:0]);
    XCTAssertEqualObjects([[[[richText.richText objectAtIndex:0] valueForKey:@"questionList"] objectAtIndex:0] valueForKey:@"asset"],[[[[[[[dict objectForKey:@"data"] objectForKey:@"richTexts"] objectForKey:@"richText"] valueForKey:@"item"] objectAtIndex:0]valueForKey:@"asset"] objectAtIndex:0]);
    XCTAssertEqualObjects([[[[richText.richText objectAtIndex:0] valueForKey:@"questionList"] objectAtIndex:0] valueForKey:@"lang"],[[[[[[[dict objectForKey:@"data"] objectForKey:@"richTexts"] objectForKey:@"richText"] valueForKey:@"item"] objectAtIndex:0]valueForKey:@"lang"] objectAtIndex:0]);
    XCTAssertEqualObjects([[[[richText.richText objectAtIndex:0] valueForKey:@"questionList"] objectAtIndex:0] valueForKey:@"rank"],[[[[[[[dict objectForKey:@"data"] objectForKey:@"richTexts"] objectForKey:@"richText"] valueForKey:@"item"] objectAtIndex:0]valueForKey:@"rank"] objectAtIndex:0]);
    XCTAssertEqualObjects([[[[richText.richText objectAtIndex:0] valueForKey:@"questionList"] objectAtIndex:0] valueForKey:@"head"],[[[[[[[dict objectForKey:@"data"] objectForKey:@"richTexts"] objectForKey:@"richText"] valueForKey:@"item"] objectAtIndex:0]valueForKey:@"head"] objectAtIndex:0]);
}

/*- (void)testTableViewHeightForRowAtIndexPath
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    CGFloat actualHeight = 81.0;//self.vc.tblQuestionList.rowHeight;
    CGFloat height = [self.vc tableView:self.vc.tblQuestionList heightForRowAtIndexPath:indexPath];
    XCTAssertEqual(height, actualHeight, @"Cell should have %f height, but they have %f", height, actualHeight);
}*/


-(void)testTableViewWillSelectRowAtIndexPath{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.vc tableView:self.vc.tblQuestionList willSelectRowAtIndexPath:indexPath];
    [self PushWebViewWithUrlString];
}
- (void)testTableViewCellCreateCellsWithReuseIdentifier
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    DCQuestionCell *cell = (DCQuestionCell *)[self.vc tableView:self.vc.tblQuestionList cellForRowAtIndexPath:indexPath];
    NSString *expectedReuseIdentifier = @"QuestionCell";
    NSMutableAttributedString* attrString = [[NSMutableAttributedString  alloc] initWithString:[[[[self.vc.tableData objectAtIndex:indexPath.section] questionList]objectAtIndex:indexPath.row] head]];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:5];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, attrString.length)];
    
    XCTAssertTrue([cell.lblQuestion.attributedText isEqualToAttributedString:attrString],@"Question cells have different contents");
    XCTAssertTrue([cell.reuseIdentifier isEqualToString:expectedReuseIdentifier], @"Table does not create reusable cells");
    
}


@end
