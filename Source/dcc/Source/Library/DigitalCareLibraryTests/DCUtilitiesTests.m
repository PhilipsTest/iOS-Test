//
//  DCUtilitiesTest.m
//  DigitalCareLibrary
//
//  Created by sameer sulaiman on 04/06/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import <XCTest/XCTest.h>
#import "DCConstants.h"
#import <UIKit/UIKit.h>
#import "DCUtilities.h"
#import <OCMock/OCMock.h>
#import "DCHandler.h"
#import "DCPluginManager.h"
@import PhilipsUIKitDLS;
@import PhilipsIconFontDLS;

@interface TestDC: DCUtilities
@property(nonatomic) BOOL isCalled;
@end

@implementation TestDC
- (void) ccOpenURL:(NSURL *)url {
    [TestDC ccOpenURL:url];
    self.isCalled = TRUE;
}
@end

@interface DCUtilitiesTests : XCTestCase

@property (nonatomic,strong) NSString *bundlePath;

@end
@interface DCUtilities (Tests)
+(NSString*)getSDTwitterName;
@end
@implementation DCUtilitiesTests

- (void)setUp {
    [super setUp];
    [self loadResources];
}

-(void)loadResources
{
    NSBundle *resourceBundle=[NSBundle bundleForClass:[self class]];
    self.bundlePath=[resourceBundle pathForResource:@"DigitalCareBundle" ofType:@"bundle"];
}

-(void)testForDifferentImage
{
    UIImage *firtsImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@/images/",self.bundlePath],kTwitterIconImage]];
    UIImage *secondImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@/images/",self.bundlePath],kFacebookIconImage]];
    XCTAssertFalse([DCUtilities isSameImage:firtsImage image:secondImage], @"Different image");
    
}

-(void)testFormattedPhoneNumber
{
    NSString *phoneNumber= @"098080800";
    XCTAssertEqualObjects([DCUtilities formattedPhoneNumber:phoneNumber], @"098080800");
}

-(void)testFormattedPhoneNumberWithTollFreeText
{
    NSString *phoneNumber= @"1800 102 2929  (Toll-free)<br/ >1860 180 1111 (Standard call rate)";
    NSString *number = @"1800 102 2929";
    XCTAssertEqualObjects([DCUtilities formattedPhoneNumber:phoneNumber],number);
}

-(void)testFormattedPhoneNumberWithoutTollFreeText
{
    NSString *phoneNumber= @"1800 102 2929 <br/ >1860 180 1111 (Standard call rate)";
    NSString *number = @"1800 102 2929 ";
    XCTAssertEqualObjects([DCUtilities formattedPhoneNumber:phoneNumber],number);
}

-(void)testUrlWithSpace
{
    NSString *faqURL =@"https://www.p4c.philips.com/cgi-bin/oleeview?view=aa12_view_iframe.html&dct=QAD&refnr=0102430&slg=DEU&scy=DE&ctn= RQ1250/16 ";
    NSString *faqEncodedURL =@"https://www.p4c.philips.com/cgi-bin/oleeview?view=aa12_view_iframe.html&dct=QAD&refnr=0102430&slg=DEU&scy=DE&ctn=%20RQ1250/16%20";
    NSLog(@"%@",faqURL);
    NSLog(@"%@",[DCUtilities urlEncode:faqURL]);
    XCTAssertTrue([[DCUtilities urlEncode:faqURL] isEqualToString:faqEncodedURL],@"values should be equal after encoding");
    
}

/*- (void)testReviewUrlWithValidData
{
    XCTAssertTrue([DCUtilities getReviewURL:@"en_GB"]);
}

- (void)testReviewUrlWithInValidData
{
    XCTAssertTrue([defaultBaseUrl isEqualToString:[DCUtilities getReviewURL:@"fr_IN"]]);
}*/

-(void)testimageForTextwithFontSizeandColor
{
    UIColor *gradientColor = [UIDThemeManager sharedInstance].defaultTheme.buttonSocialMediaPrimaryBackground;
    //UIImage *image = [DCUtilities imageForText:@"\ue901" withFontSize:22.0 withColor:gradientColor];
    UIImage *image = [DCUtilities imageForText:[PhilipsDLSIcon unicodeWithIconType:PhilipsDLSIconTypeNavigationRight32] withFontSize:22.0 withColor:gradientColor];
    XCTAssertNotNil(image);
}

- (void)testAppName
{
    XCTAssertTrue([@"PhilipsConsumerCareDemo" isEqualToString:[DCUtilities appName]]);
}

-(void)testDCHandlerAppSpecificPath
{
    [DCHandler setAppSpecificLiveChatURL:@"http://ph-china.livecom.cn/webapp/index.html?app_openid=ph_6idvd4fj&token=PhilipsTest"];
    XCTAssertNotNil([DCHandler getAppSpecificLiveChatURL]);
    [DCHandler setAppSpecificLiveChatURL:nil];
    XCTAssertNil([DCHandler getAppSpecificLiveChatURL]);
}

-(void)testNilConsumerProductInfo
{
    [DCHandler setConsumerProductInfo:nil];
    XCTAssertNil([DCHandler getConsumerProductInfo]);
}

-(void)testCCOpenrUrl
{
    TestDC *mockDC = [TestDC new];
    XCTAssertEqual(mockDC.isCalled, false);
    [mockDC ccOpenURL:[NSURL URLWithString:@"https://www.google.com"]];
    XCTAssertEqual(mockDC.isCalled, true);
}

-(void)testTwitterPage
{
    NSString *page = @"@PhilipsCare";
    XCTAssertEqualObjects([DCUtilities getTwitterPageName], page);
}

-(void)testTwitterPageNotNull
{
    XCTAssertNotNil([DCUtilities getTwitterPageName],@"Twiiter page name is not nil");
}

- (void)testSDTwitterPage{
   if([ServiceDiscoveryDict[kSDTWITTERURL] valueForKey:@"url"])
    XCTAssertNotNil([DCUtilities getSDTwitterName],@"SD Twitter page is available");
    else
        XCTAssertNil([DCUtilities getSDTwitterName],@"SD Twitter page not available" );
}

-(void)testDCMenuIcons{
    NSString *socialMenuFirstIcon = [[DCUtilities dcMenuIconIcons] objectForKey:[[SharedInstance.socialServiceProvidersConfig.socialServiceProvidersArray objectAtIndex:(NSUInteger) 0] objectForKey:@"IconName"]];
    NSString *emailIcon = [PhilipsDLSIcon unicodeWithIconType:PhilipsDLSIconTypeMessage];
    XCTAssertNotNil(socialMenuFirstIcon,@"socialMenuFirstIcon is not nil");
    XCTAssertEqualObjects(socialMenuFirstIcon, emailIcon);

}


@end





