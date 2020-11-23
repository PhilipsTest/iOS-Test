//
//  DCWebViewController.m
//  PhilipsConsumerCare
//
//  Created by sameer sulaiman on 7/14/17.
//  Copyright © 2017 Philips. All rights reserved.
//
#import "DCWebViewController.h"
#import "DCPluginManager.h"
#import "DCConstants.h"
#import "DCAppInfraWrapper.h"
#import <WebKit/WebKit.h>

@interface DCWebViewController ()<WKNavigationDelegate>
@property (strong, nonatomic) WKWebView *webKitView;
@end

@implementation DCWebViewController

+ (instancetype)createWebViewForUrl:(NSString*)url andType:(DCWebViewType)type{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DCWebView" bundle:StoryboardBundle];
    DCWebViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"DCWebView"];
    controller.webViewModel = [DCWebViewModel getModelForType:type andUrl:url];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     ![DCUtilities isNetworkReachable]?[self showNoNetworkMessage]:nil;
    self.title = SharedInstance.themeConfig.navigationBarTitleRequired?self.webViewModel.navTitle:nil;
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:[NSString stringWithFormat:@"User viewing %@ screen",self.webViewModel.tagParamValue] Message:self.webViewModel.tagParamValue];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[DCUtilities urlEncode:self.webViewModel.url]]];
    [self addWebKitView];
    [self.webKitView loadRequest:request];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kServiceRequest paramKey:kServiceChannel andParamValue:self.webViewModel.tagParamValue];
    [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackPageWithInfo:self.webViewModel.tagPageKey params:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.webKitView.navigationDelegate = nil;
    [self.webKitView stopLoading];
    [self.webKitView removeFromSuperview];
}

-(void)showNoNetworkMessage{
    [[DCAppInfraWrapper sharedInstance].consumerCareTagging trackActionWithInfo:kSetError paramKey:kTechnicalError andParamValue:kNETWORKERROR];
    [self showWebViewErrorAlertWith:LOCALIZE(KNONetwork) andMessage:nil];
}

-(void)addWebKitView {
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    self.webKitView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
    self.webKitView.navigationDelegate = self;
    self.webKitView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:self.webKitView];
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.webKitView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.webKitView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.webKitView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.webKitView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.view addConstraints:@[left, right, top, bottom]];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-parameter"

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self startProgressIndicator];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self stopProgressIndicator];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:[NSString stringWithFormat:@"User gets error in %@",self.webViewModel.tagParamValue] Message:[error localizedDescription]];
    [self stopProgressIndicator];
    
    if([self.webViewModel.navTitle isEqualToString:LOCALIZE(KChatnow)]) {
        [self showWebViewErrorAlertWith:nil andMessage:@"Chat facility is currently unavailable for your country"];
    }
    else if([self.webViewModel.navTitle isEqualToString:LOCALIZE(KViewProductInformation)]) {
        [self showWebViewErrorAlertWith:nil andMessage:error.localizedDescription];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelInfo Event:[NSString stringWithFormat:@"User gets error in %@",self.webViewModel.tagParamValue] Message:[error localizedDescription]];
    [self stopProgressIndicator];
    
    if([self.webViewModel.navTitle isEqualToString:LOCALIZE(KChatnow)]) {
        [self showWebViewErrorAlertWith:nil andMessage:@"Chat facility is currently unavailable for your country"];
    }
    else if([self.webViewModel.navTitle isEqualToString:LOCALIZE(KViewProductInformation)]) {
        [self showWebViewErrorAlertWith:nil andMessage:error.localizedDescription];
    }
}

-(void)showWebViewErrorAlertWith:(NSString*)title andMessage:(NSString*)msg{
    UIDAlertController * webAlertVC = [[UIDAlertController alloc] initWithTitle:title icon:nil message:msg];
    UIDAction *webAlertAction = [[UIDAction alloc] initWithTitle:LOCALIZE(kOKKEY) style:UIDActionStylePrimary handler:^(UIDAction * _Nonnull action) {
        [webAlertVC dismissViewControllerAnimated:NO completion:^{}];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [webAlertVC addAction:webAlertAction];
    [self presentViewController:webAlertVC animated:YES completion:nil];
}
#pragma clang diagnostic pop

@end
