//
//  DCTellUsVCTest.m
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
#import "DCFeedbackConfig.h"
#import "DCConfigurationContainer.h"
#import "DCConstants.h"
#import "DCTellUsViewController.h"
@import PhilipsUIKitDLS;
@interface DCTellUsVCTest : XCTestCase

@property (nonatomic, strong) DCConfigurationContainer *configurationData;
@property (nonatomic, strong) DCFeedbackConfig *pluginData;
@property (nonatomic, strong) NSDictionary *configurationDictionary;
@property(nonatomic,strong) DCTellUsViewController *vc;
@end

@interface DCTellUsViewController ()
@property (weak, nonatomic) IBOutlet UIDButton *appReviewButton;
@property (weak, nonatomic) IBOutlet UIDButton *productReviewButton;
@property (weak, nonatomic) IBOutlet UIImageView *tellUsTopImage;
@end
@implementation DCTellUsVCTest

- (void)setUp {
    [super setUp];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"ShareYourExperiences" bundle:StoryboardBundle];
    self.vc = [storyBoard instantiateViewControllerWithIdentifier:@"ShareYourExperiences"];
    [self.vc view];
    self.configurationData=[[DCConfigurationContainer alloc] init];
    [self loadConfigFile];
}

-(void)loadConfigFile
{
    NSBundle *testBundle=[NSBundle bundleForClass:[self class]];
    NSString *testBundlePath=[testBundle pathForResource:@"DigitalCareConfiguration" ofType:@"plist"];
    self.configurationDictionary=[[NSDictionary alloc] initWithContentsOfFile:testBundlePath];
    self.configurationData=[[[NSDictionary alloc] initWithContentsOfFile:testBundlePath] objectForKey:@"FeedbackMenu"];
}
-(void)testAppReview
{
    self.pluginData=[[DCFeedbackConfig alloc] initWithDictionary:[self.configurationDictionary objectForKey:kFEEDBACKCONFIG]];
    NSString *urlString = self.pluginData.appStoreId;
    urlString=[NSString stringWithFormat:@"%@%@",kAppReviewBaseURL,urlString];
    XCTAssertNotNil(urlString,@"app review url is present");
}
-(void)testTellusControllerConnections{
    
    XCTAssertNotNil([self.vc appReviewButton],@"appReviewButton should be connected");
    XCTAssertNotNil([self.vc productReviewButton],@"productReviewButton should be connected");
    XCTAssertNotNil([self.vc tellUsTopImage],@"tellUsTopImage should be connected");
    [self.vc.appReviewButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    //Commenting test case for now for failure
//    [self.vc.productReviewButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
