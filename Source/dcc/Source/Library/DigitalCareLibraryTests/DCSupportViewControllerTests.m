//
//  DCSupportViewControllerTests.m
//  PhilipsConsumerCare
//
//  Created by Niharika Bundela on 2/16/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DCSupportViewController.h"
#import "DCPluginManager.h"
#import "DCConstants.h"
#import <OCMock/OCMock.h>
#import <PhilipsProductSelection/PSHandler.h>
#import <AppInfra/AppInfra.h>
#import "DCAppInfraWrapper.h"

@interface DCSupportViewControllerTests : XCTestCase
@property (nonatomic, strong)DCSupportViewController *vc;
@property (strong, nonatomic) PSHardcodedProductList *productList;
@property (nonatomic, strong)AIAppInfra * appInfra;

@end
@interface DCSupportViewController (test)
-(void)getServiceURLs;
-(void)getSummaryData;
- (void) invokeProductSelection;
- (void)sendPRXrequestWith:(NSString*)productCtn;
-(void)updateUI;
- (void) removeSelBtnWithTitle:(NSString *)title;
- (void)showError;
- (BOOL) isConsumerCareMenus;
- (BOOL)noContactUsConfigData;
- (void)justInTimeConsentAccepted;
- (void)justInTimeConsentCancelled;
-(void)justInTimeConsentDismissed;
@property(nonatomic)UITableView *supportTable;
@end
@implementation DCSupportViewControllerTests
{
    NSDictionary *serviceDiscoveryDict;
    NSData *jsonData;
}

- (void)setUp {
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DCSupport" bundle:StoryboardBundle];
    self.vc = [storyboard instantiateViewControllerWithIdentifier:@"DCSupportView"];
    self.vc.productList = [[PSHardcodedProductList alloc]initWithArray:[NSArray arrayWithObject:@"HD9240/90"]];
    self.appInfra = [AIAppInfra buildAppInfraWithBlock:nil];
    [DCAppInfraWrapper sharedInstance].appInfra = self.appInfra;
    [self.vc view];
}

- (void)tearDown {
    self.vc = nil;
    [super tearDown];
}

-(void)testSupportViewControllerViewLoaded
{
//    [_vc.supportTable.delegate tableView:_vc.supportTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertNotNil(self.vc.view, @"View not initiated properly");
}

-(void)testgetSummaryData
{
    id mock=[OCMockObject niceMockForClass:[DCSupportViewController class]];
    [[mock expect] sendPRXrequestWith:[self.vc.productList.hardcodedProductListArray objectAtIndex:0]];
    [mock getSummaryData];
    XCTAssertThrows([mock verify]);
}
-(void)testgetinvokeProductSelection
{
    [self.vc invokeProductSelection];
    [PSHandler invokeProductSelectionWithParentController:self.vc productModelSelection:self.vc.productList andCompletionHandler:^(PRXSummaryData* selectedPRXSummary) {
        if(selectedPRXSummary)
        {
           XCTAssertNotNil(selectedPRXSummary, @"selectedPRXSummary should not be nil.");
            NSLog(@"success testgetinvokeProductSelection");
        }
    }];
}

-(void)testupdateUI
{
    [self.vc updateUI];
    if(([self.vc.productList.hardcodedProductListArray count]<=1))
    {
        XCTAssertNotNil(self.vc.productList.hardcodedProductListArray,@"hardcodedProductListArray count is not nil");
    }
    
}
-(void)testshowError
{
    [self.vc showError];
   if([self.vc.productList.hardcodedProductListArray count]<=1)
   {
       XCTAssertNotNil(@"hardcodedProductListArray count is not nil");
       [self.vc removeSelBtnWithTitle:KChangeSelectedProduct];
   }
}

-(void)testisConsumerCareMenus
{
    BOOL isConsumerCareMenus = [self.vc isConsumerCareMenus];
    XCTAssertTrue(isConsumerCareMenus,@"ConsumerCareMenus is availabel");
}

-(void)testgetServiceURLs
{
    [self.vc getServiceURLs];
    NSString *ServiceDiscoveryFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"ServiceDiscoveryResponse" ofType:@"plist"];
    if(ServiceDiscoveryFilePath)
    {
        serviceDiscoveryDict = [[NSDictionary alloc]initWithContentsOfFile:ServiceDiscoveryFilePath];
    }
    XCTAssertNotNil(serviceDiscoveryDict,@"Service Discovery response is not nill");
    XCTAssertNotNil([serviceDiscoveryDict objectForKey:@"cc.atos"],@"Service Discovery atos response is not nill");
    XCTAssertNotNil([serviceDiscoveryDict objectForKey:@"cc.cdls"],@"Service Discovery cdls response is not nill");
    XCTAssertNotNil([serviceDiscoveryDict objectForKey:@"cc.emailformurl"],@"Service Discovery emailformurl response is not nill");
    XCTAssertNotNil([serviceDiscoveryDict objectForKey:@"cc.productreviewurl"],@"Service Discovery productreviewurl response is not nill");
    XCTAssertNotNil([serviceDiscoveryDict objectForKey:@"cc.prx.category"],@"Service Discovery prx Ucategory response is not nill");
}

- (void)testTableHasDataSource
{
    XCTAssertNotNil(self.vc.supportTable.dataSource, @"Table datasource cannot be nil");
}

- (void)testTableHasDelegate
{
    XCTAssertNotNil(self.vc.supportTable.delegate, @"Table delegate cannot be nil");
}

-(void)testNoContactConfigData{
    XCTAssertFalse([self.vc noContactUsConfigData],@"Contact Config data not available");
}

@end
