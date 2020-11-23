//
//  DCSupportVCtest.m
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
#import "DCContactUsViewController.h"
#import <OCMock/OCMock.h>
#import "DCUtilities.h"
#import "DCConstants.h"
#import "DCPluginManager.h"
#import "DCContactsModel.h"
#import "DCContactsParser.h"
#import "DCConstants.h"
#import "DCHandler.h"
#import "DCConsumerProductInformation.h"
#import "DCServiceTaskHandler.h"
#import "DCCustomButtonCell.h"
@import PhilipsPRXClient;
@import PhilipsProductSelection;
@import AppInfra;

@interface DCContactUsVCTest : XCTestCase
{
    DCContactsModel *contactsModel;
    DCContactsParser *contactsParser;
    NSDictionary *serviceDiscoveryDict;
}
@property(nonatomic,strong) DCContactUsViewController *contactVC;

@end

@interface DCContactUsViewController(Testing)
@property(nonatomic,weak)IBOutlet UIDButton *liveChatButton;
@property(nonatomic,weak)IBOutlet UIDButton *callButton;
@property (weak, nonatomic) IBOutlet UITableView *tblMenuItems;

-(void)launchSendMessageViewController;
-(void)LoadTwitterPostComposer;
-(void)OpenContactUS:(NSString *)title;
- (void)receiveResponse:(id)response;
-(void)setupTimeDetailView;
-(NSString *)formattedTimeDetailsString;
-(NSString *)getFacebookURL;
- (BOOL)isFacebookURLEmpty;
- (BOOL)isTwitterURLEmpty;
- (BOOL)verifyLiveChatNotavailable;
-(NSString*) getEmailServiceUrl;
-(void)getCategory;
- (void)sendCDLSRequestWith:(NSString*)category;
- (DCServiceTaskHandler*)getCategoryTaskhandler;
- (DCServiceTaskHandler*)getCDLSTaskhandler:(NSString*)category;
-(NSURL*)getFacebookProfileURL;
-(NSURL*)phoneNoURL;
@end

@implementation DCContactUsVCTest

- (void)setUp {
    [super setUp];
    contactsParser = [[DCContactsParser alloc]init];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"ContactUs" bundle:StoryboardBundle];
    self.contactVC = [storyBoard instantiateViewControllerWithIdentifier:@"ContactUs"];
    [self.contactVC view];
}

/*-(void)testOpenContactUsFaceBooktest
{
    id mockObject=[OCMockObject niceMockForClass:[DCContactUsViewController class]];
    [[mockObject expect] launchSendMessageViewController];
    [mockObject OpenContactUS:@"Facebook"];
    XCTAssertThrows([mockObject verify]);
}*/

-(void)testOpenContactUsTwittertest
{
    id mock=[OCMockObject niceMockForClass:[DCContactUsViewController class]];
    [[mock expect] LoadTwitterPostComposer];
    [mock OpenContactUS:@"Twitter"];
    XCTAssertThrows([mock verify]);
}

-(void)testCDLSResponse
{
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"result" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *contactsDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    NSDictionary *phoneDataDict = [[[contactsDict objectForKey:@"data"] objectForKey:@"phone"] objectAtIndex:0];
    NSDictionary *chatDataDict = [[[contactsDict objectForKey:@"data"] objectForKey:@"chat"] objectAtIndex:0];
    NSDictionary *emailDataDict = [[[contactsDict objectForKey:@"data"] objectForKey:@"email"]objectAtIndex:0];
    contactsModel = [contactsParser parse:jsonData];
    [self.contactVC receiveResponse:contactsModel];
    XCTAssertNotNil(contactsModel,@"Contacts Model supposed to be formed");
    XCTAssertEqualObjects(contactsModel.phoneNumber, [DCUtilities formattedPhoneNumber:[phoneDataDict objectForKey:@"phoneNumber"]]);
    XCTAssertEqualObjects(contactsModel.openingHoursWeekdays, [phoneDataDict objectForKey:@"openingHoursWeekdays"]);
    XCTAssertEqualObjects(contactsModel.openingHoursSaturday, [phoneDataDict objectForKey:@"openingHoursSaturday"]);
    XCTAssertEqualObjects(contactsModel.chatContent,[chatDataDict objectForKey:@"content"]);
    XCTAssertEqualObjects(contactsModel.chatOpeningHoursSaturday, [chatDataDict objectForKey:@"openingHoursSaturday"]);
    XCTAssertEqualObjects(contactsModel.chatOpeningHoursWeekdays, [chatDataDict objectForKey:@"openingHoursWeekdays"]);
    XCTAssertEqualObjects(contactsModel.emailContentPath, [emailDataDict objectForKey:@"contentPath"]);
    XCTAssertEqualObjects(contactsModel.emailLabel, [emailDataDict objectForKey:@"label"]);
    XCTAssertEqualObjects(contactsModel.openingHoursSunday, [phoneDataDict objectForKey:@"openingHoursSunday"]);
    XCTAssertEqualObjects(contactsModel.optionalData1, [phoneDataDict objectForKey:@"optionalData1"]);
    XCTAssertEqualObjects(contactsModel.optionalData2, [phoneDataDict objectForKey:@"optionalData2"]);
    XCTAssertEqualObjects(contactsModel.phoneTariff, [phoneDataDict objectForKey:@"phoneTariff"]);
}

-(void)testSetTimeDetails
{
    [self.contactVC setupTimeDetailView];
    NSString *formatedText = [self.contactVC formattedTimeDetailsString];
    XCTAssertNotNil(formatedText);
}


-(void)testFacebookURLAvailable
{
    XCTAssertNotNil([self.contactVC getFacebookURL],@"Facebook url not nil");
}

-(void)testFacebookURLNotNil
{
    NSLog(@"service dict data = %@",ServiceDiscoveryDict);
    XCTAssertFalse([self.contactVC isFacebookURLEmpty],@"No Facebook url available in service discovery and config file");
}

-(void)testTwitterURLNotNil
{
    XCTAssertFalse([self.contactVC isTwitterURLEmpty],@"No Twitter url available in service discovery and config file");
}

-(void)testLiveChatAvailable
{
    XCTAssertFalse([self.contactVC verifyLiveChatNotavailable],@"No LiveChat url available in service discovery and config file");
}

-(void)testSocialServiceDiscoveryRequest
{
    NSString *ServiceDiscoveryFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"ServiceDiscoveryResponse" ofType:@"plist"];
    if(ServiceDiscoveryFilePath)
    {
        NSDictionary *serviceDiscoveryDict = [[NSDictionary alloc]initWithContentsOfFile:ServiceDiscoveryFilePath];
        XCTAssertNotNil([serviceDiscoveryDict objectForKey:kSDFACEBOOKURL],@"Service Discovery Facebook response is not nill");
        XCTAssertNotNil([serviceDiscoveryDict objectForKey:kSDTWITTERURL],@"Service Discovery TWITTER response is not nill");
        XCTAssertNotNil([serviceDiscoveryDict objectForKey:kSDLIVECHATURL],@"Service Discovery LIVECHAT response is not nill");
    }
}

-(void)testContactUSControllerConnections{
    XCTAssertNotNil([self.contactVC callButton],@"callButton should be connected");
    XCTAssertNotNil([self.contactVC liveChatButton],@"liveChatButton should be connected");
    [self.contactVC.callButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self.contactVC.liveChatButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)testEmailService{
    XCTAssertNil([self.contactVC getEmailServiceUrl],@"Email serive url should  be nil");
}

-(void)testFacebookProfileURL{
    //[self.contactVC OpenContactUS:@"facebook"];
    XCTAssertNotNil([self.contactVC getFacebookProfileURL], @"Facebook profile url not nil");
}

-(void)testCDLSData
{
   /* PRXSummaryData *summaryModel = [[PRXSummaryData alloc] init];
    summaryModel.ctn = @"HD9240/90";
    summaryModel.productTitle = @"Avance Collection Airfryer XL";
    summaryModel.locale= @"en_IN";
    summaryModel.subcategory= @"AIRFRYER_SU";
    summaryModel.productURL= @"/c-p/HD9240_90/avance-collection-airfryer-xl-with-rapid-air-technology";
    summaryModel.domain= @"https://www.philips.co.in";
    summaryModel.imageURL= @"https://images.philips.com/is/image/PhilipsConsumer/HD9240_90-IMS-en_IN";
    
    PSHardcodedProductList *list = [[PSHardcodedProductList alloc] init];
    list.catalog = CARE;
    list.sector = B2C;
    [DCHandler setConsumerProductInfo:[[DCConsumerProductInformation alloc] initWithSummaryData:summaryModel withSector:list.sector withCatalog:list.catalog]];
    NSString *ServiceDiscoveryFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"ServiceDiscoveryResponse" ofType:@"plist"];
    if(ServiceDiscoveryFilePath)
    {
        ServiceDiscoveryDict = [[NSDictionary alloc]initWithContentsOfFile:ServiceDiscoveryFilePath];
    }
    id mock=[OCMockObject niceMockForClass:[DCContactUsViewController class]];
    [[mock expect] sendCDLSRequestWith:summaryModel.subcategory];
    [mock getCategory];
    XCTAssertThrows([mock verify]);*/
    //  [self.vc sendPRXrequestWith:[self.vc.productList.hardcodedProductListArray objectAtIndex:0]];
}

-(void)setServiceData{
    NSString *ServiceDiscoveryFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"ServiceDiscoveryResponse" ofType:@"plist"];
    if(ServiceDiscoveryFilePath)
    {
        serviceDiscoveryDict = [[NSDictionary alloc]initWithContentsOfFile:ServiceDiscoveryFilePath];
    }
}

- (void)testCategoryTaskHandlerObj{
    DCServiceTaskHandler *categoryHandler = [self.contactVC getCategoryTaskhandler];
//    XCTAssertTrue([categoryHandler isKindOfClass:[DCServiceTaskHandler class]], @"Class type must be Category DCServiceTaskHandler class");
    XCTAssertNotNil(categoryHandler, @"Object must not be nill");
}

- (void)testCDLSTaskHandlerObj{
    DCServiceTaskHandler *cdlsHandler = [self.contactVC getCDLSTaskhandler:@"AIRFRYER_SU"];
//    XCTAssertTrue([cdlsHandler isKindOfClass:[DCServiceTaskHandler class]], @"Class type must be CDLS DCServiceTaskHandler class");
    XCTAssertNotNil(cdlsHandler, @"Object must not be nill");
}

- (void)testPhoneNoURL{
    XCTAssertNotNil([self.contactVC phoneNoURL], @"Phone URL available ");
}

//- (void)testLocalization
//{
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
//    id tableView = [OCMockObject mockForClass:UITableView.class];
//    DCCustomButtonCell *cell = (DCCustomButtonCell *) [self.contactVC tblMenuItems:self.contactVC.tblMenuItems cellForRowAtIndexPath:indexPath];
//    XCTAssertEqualObjects(cell.lblMenuTitle.text, @"Email",);
//
//    indexPath = [NSIndexPath indexPathForItem:2 inSection:0];
//    cell = (DCCustomButtonCell *) [self.contactVC tableView:self.contactVC.tableView cellForRowAtIndexPath:indexPath];
//    XCTAssertEqualObjects(cell.lblMenuTitle.text, @"Facebook");
//}


/*-(void)testThatViewLoads
{
    XCTAssertNotNil(self.contactVC.view, @"View not initiated properly");
}

//- (void)testParentViewHasTableViewSubview
//{
//    NSArray *subviews = self.contactVC.view.subviews;
//    XCTAssertTrue([subviews containsObject:self.contactVC.tblMenuItems], @"View does not have a table subview");
//}

-(void)testThatTableViewLoads
{
    XCTAssertNotNil(self.contactVC.tblMenuItems, @"TableView not initiated");
}


- (void)testThatViewConformsToUITableViewDataSource
{
    XCTAssertTrue([self.contactVC conformsToProtocol:@protocol(UITableViewDataSource) ], @"View does not conform to UITableView datasource protocol");
}

- (void)testThatTableViewHasDataSource
{
    XCTAssertNotNil(self.contactVC.tblMenuItems.dataSource, @"Table datasource cannot be nil");
}

- (void)testThatViewConformsToUITableViewDelegate
{
    XCTAssertTrue([self.contactVC conformsToProtocol:@protocol(UITableViewDelegate) ], @"View does not conform to UITableView delegate protocol");
}

- (void)testTableViewIsConnectedToDelegate
{
    XCTAssertNotNil(self.contactVC.tblMenuItems.delegate, @"Table delegate cannot be nil");
}*/

@end
