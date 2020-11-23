//
//  DCWebViewTests.m
//  PhilipsConsumerCare
//
//  Created by sameer sulaiman on 7/26/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DCWebViewController.h"
#import "DCConstants.h"

@interface DCWebViewTests : XCTestCase
{
    UIStoryboard *storyboard;
}
@property (nonatomic,strong) DCWebViewController *webVC;
@end

@interface DCWebViewController ()
//- (UIFont*)getCCFont:(CGFloat)size;
-(void)showWebViewErrorAlertWith:(NSString*)title andMessage:(NSString*)msg;
@end

@implementation DCWebViewTests

- (void)setUp {
    [super setUp];
    storyboard = [UIStoryboard storyboardWithName:@"DCWebView" bundle:StoryboardBundle];
    self.webVC = [storyboard instantiateViewControllerWithIdentifier:@"DCWebView"];
    [self.webVC view];
}

-(void)testDCWebView{
    [_webVC showWebViewErrorAlertWith:@"Error" andMessage:@"WebView Error"];
}

@end
