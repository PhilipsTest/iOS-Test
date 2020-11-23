//
//  DCTellUsViewController.m
//  DigitalCare
//
//  Created by sameer sulaiman on 12/01/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import "DCTellUsViewController.h"
#import "DCUtilities.h"
#import "UILabel+DCExternal.h"
#import "UIButton+DCExternal.h"
#import "DCConstants.h"
#import "DCPluginManager.h"
#import "DCHandler.h"
#import "DCWebViewController.h"
#import "DCConsumerProductInformation.h"
#import "DCAppInfraWrapper.h"
#import "UIImageView+DCExternal.h"
@import PhilipsIconFontDLS;

@interface DCTellUsViewController ()

@property (weak, nonatomic) IBOutlet UIDButton *appReviewButton;
@property (weak, nonatomic) IBOutlet UIDButton *productReviewButton;
@property (weak, nonatomic) IBOutlet UIImageView *tellUsTopImage;

- (IBAction)writeAppReview:(id)sender;
- (IBAction)writeProductReview:(id)sender;

@end

@implementation DCTellUsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = SharedInstance.themeConfig.navigationBarTitleRequired? LOCALIZE(KShareExperience):nil;
    [self.tellUsTopImage imageName:kShareExpImage];
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:@"User viewing the screen" Message:@"Tell us screen"];
    if([SharedInstance.feedbackConfig.appStoreId isEqualToString:@""] || (SharedInstance.feedbackConfig.appStoreId == nil))
        [self hideAppReviewFeature];
    if(![[DCHandler getConsumerProductInfo] productCTN] ||[ServiceDiscoveryDict[kPRODREVIEWURL] valueForKey:@"url"]==nil){
        [self hideProductReviewFeature];
    }
}

-(void)hideAppReviewFeature{
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:@"User cannot view menu:" Message:@"App rating menu"];
    [self.appReviewButton removeFromSuperview];
    [self.view updateConstraintsIfNeeded];
}

-(void)hideProductReviewFeature{
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:@"User cannot view menu:" Message:@"Product review menu"];
    [self.productReviewButton setHidden:YES];
    [self.view updateConstraintsIfNeeded];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackPageWithInfo:kRateThisAppPage params:nil];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-parameter"
- (IBAction)writeAppReview:(id)sender{
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:@"User clicked on button" Message:@"App rating Menu"];
    NSMutableDictionary *dataObj = [NSMutableDictionary new];
    [dataObj setObject:kRateThisApp forKey:kSPECIALEVENTS];
    [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kSENDDATA params:dataObj];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kAppReviewBaseURL,SharedInstance.feedbackConfig.appStoreId];
    [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelDebug Event:@"User accessing app url is" Message:urlString];
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]])
    {
        [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kExitLink paramKey:kExitLinkName andParamValue:urlString];
        [DCUtilities ccOpenURL:[NSURL URLWithString:urlString]];
    }
}

- (IBAction)writeProductReview:(id)sender{
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:@"User clicked on button" Message:@"Product review Menu"];
    NSMutableDictionary *dataObj = [NSMutableDictionary new];
    [dataObj setObject:kWriteProductReview forKey:kSPECIALEVENTS];
    [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kSENDDATA params:dataObj];
    NSString *url = [[ServiceDiscoveryDict[kPRODREVIEWURL] valueForKey:@"url"] stringByReplacingOccurrencesOfString:@"%productReviewURL%" withString:[[DCHandler getConsumerProductInfo] productReviewURL]];
    DCWebViewController *controller = [DCWebViewController createWebViewForUrl:url andType:DCPRODUCTREVIEW];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma clang diagnostic pop

@end
