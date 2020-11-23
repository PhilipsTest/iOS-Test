//
//  DCChatWithPhilipsViewController.m
//  DigitalCare
//
//  Created by sameer sulaiman on 21/01/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//
#import "DCChatWithPhilipsViewController.h"
#import "DCUtilities.h"
#import "UILabel+DCExternal.h"
#import "UIButton+DCExternal.h"
#import "UIImageView+DCExternal.h"
#import "DCConstants.h"
#import "DCPluginManager.h"
#import "DCAppInfraWrapper.h"
#import "DCWebViewController.h"
#import "DCHandler.h"
#import "DCContentConfiguration.h"

@interface DCChatWithPhilipsViewController ()

@property(nonatomic, weak)IBOutlet UIImageView *chatBGImage;
@property(nonatomic, weak)IBOutlet UIDLabel *chatDescLabel;

@end

@implementation DCChatWithPhilipsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.chatBGImage imageName:kChatImage];
    self.title = SharedInstance.themeConfig.navigationBarTitleRequired? LOCALIZE(KLiveChat):nil;
    self.chatDescLabel.text = [self getChatDescriptionText];
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:@"User viewing the screen" Message:@"Live chat selection"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackPageWithInfo:kContactLiveChatPage params:nil];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-parameter"
- (IBAction)chatNow:(id)sender {
    #pragma clang diagnostic pop
    DCWebViewController *controller = [DCWebViewController createWebViewForUrl:[self getChatURL] andType:DCLIVECHAT];
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSString*)getChatURL{
    if([DCHandler getAppSpecificLiveChatURL])
        return  [DCHandler getAppSpecificLiveChatURL];
    else
        return  [ServiceDiscoveryDict[kSDLIVECHATURL] valueForKey:@"url"]?[ServiceDiscoveryDict[kSDLIVECHATURL] valueForKey:@"url"]:SharedInstance.socialConfig.liveChatUrl;
}

- (NSString *)getChatDescriptionText {
    DCContentConfiguration *contentConfig = [DCHandler getContentConfiguration];
    if (contentConfig != nil && contentConfig.livechatDescText.length > 0)
        return contentConfig.livechatDescText;
    else
        return LOCALIZE(KChatDesc);
}

@end
