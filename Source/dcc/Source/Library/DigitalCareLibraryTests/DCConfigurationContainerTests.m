//
//  DCConfigurationContainerTest.m
//  DigitalCareLibrary
//
//  Created by KRISHNA KUMAR on 04/06/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DCConfigurationContainer.h"
#import "DCThemeConfig.h"
#import "DCSupportConfig.h"
#import "DCProductConfig.h"
#import "DCSocialProvidersConfig.h"
#import "DCSocialConfig.h"
#import "DCFeedbackConfig.h"
#import "DCConstants.h"



@interface DCConfigurationContainerTests : XCTestCase

@property (nonatomic, strong) DCConfigurationContainer *configurationData;
@property (nonatomic, strong) NSDictionary *configurationDictionary;

@end

@interface DCConfigurationContainer()
-(NSString*)ccConfigFilePath;
@end

@implementation DCConfigurationContainerTests

- (void)setUp {
    [super setUp];
    self.configurationData=[[DCConfigurationContainer alloc] init];
    [self loadConfigFile];
}

-(void)loadConfigFile
{
    NSBundle *testBundle=[NSBundle bundleForClass:[self class]];
    NSString *testBundlePath=[testBundle pathForResource:@"DigitalCareConfiguration" ofType:@"plist"];
    self.configurationDictionary=[[NSDictionary alloc] initWithContentsOfFile:testBundlePath];
}

-(void)testNotNillConfigurationData
{
    XCTAssertNotNil(self.configurationData);
}

-(void)testDataValidity
{
    XCTAssertTrue([self.configurationData.themeConfig isKindOfClass:[DCThemeConfig class]]);
    XCTAssertTrue([self.configurationData.supportConfig isKindOfClass:[DCSupportConfig class]]);
    XCTAssertTrue([self.configurationData.productConfig isKindOfClass:[DCProductConfig class]]);
    XCTAssertTrue([self.configurationData.socialConfig isKindOfClass:[DCSocialConfig class]]);
    XCTAssertTrue([self.configurationData.feedbackConfig isKindOfClass:[DCFeedbackConfig class]]);
}

-(void)testNonZeroSocialMenu
{
    DCSocialProvidersConfig *socialProvider=[[DCSocialProvidersConfig alloc] initWithArrayData:[self.configurationDictionary objectForKey:kSOCIALSERVICEPROVIDERS]];
    XCTAssertGreaterThan(socialProvider.socialServiceProvidersArray.count, 0);
}

-(void)testNonZeroSupportMenu
{
    DCSupportConfig *supportData=[[DCSupportConfig alloc] initWithArrayData:[self.configurationDictionary objectForKey:kSUPPORTCONFIG]];
    XCTAssertGreaterThan(supportData.supportConfigArray.count, 0);
}

-(void)testNonZeroProductMenu
{
    DCProductConfig *productData=[[DCProductConfig alloc] initWithArrayData:[self.configurationDictionary objectForKey:kPRODUCTCONFIG]];
    XCTAssertGreaterThan(productData.productConfigArray.count, 0);
    
}

-(void)testFeedbackIdAvailable
{
    DCFeedbackConfig *feedbackData=[[DCFeedbackConfig alloc] initWithDictionary:[self.configurationDictionary objectForKey:kFEEDBACKCONFIG]];
    XCTAssertNotNil(feedbackData.appStoreId);
}

-(void)testSocialConfigData
{
    DCSocialConfig *socialData=[[DCSocialConfig alloc] initWithDictionary:[self.configurationDictionary objectForKey:kSOCIALCONFIG]];
    XCTAssertNotNil(socialData.facebookProductPageID);
    XCTAssertNotNil(socialData.twitterPage);
}

-(void)testUIThemeConfigData
{
    DCThemeConfig *themeData=[[DCThemeConfig alloc] initWithDictionary:[self.configurationDictionary objectForKey:kTHEMECONFIG]];
    XCTAssertNotNil(themeData);
}
-(void)testDCConfigurationContainer
{
    DCConfigurationContainer *configContainer = [[DCConfigurationContainer alloc]init];
    XCTAssertTrue([configContainer isKindOfClass:[DCConfigurationContainer class]]);
    XCTAssertNotNil(configContainer,@"DCConfigurationContainer is not nil");
}

-(void)testPropConfigFilePath{
    XCTAssertNotNil([_configurationData ccConfigFilePath], @"ccConfig File Path is available");
}
@end
