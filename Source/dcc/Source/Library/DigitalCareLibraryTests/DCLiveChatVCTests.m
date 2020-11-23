//
//  DCLiveChatVCTests.m
//  PhilipsConsumerCare
//
//  Created by sameer sulaiman on 8/22/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DCChatWithPhilipsViewController.h"
#import "DCConstants.h"
#import "DCPluginManager.h"
#import "DCContentConfiguration.h"
#import "DCHandler.h"

@interface DCLiveChatVCTests : XCTestCase
{
  UIStoryboard *storyboard;
}
@property(nonatomic,strong) DCChatWithPhilipsViewController *vc;
    
@end

@interface DCChatWithPhilipsViewController(Testing)
    
- (NSString*)getChatURL;
- (NSString *)getChatDescriptionText;
    
@end

@implementation DCLiveChatVCTests

- (void)setUp {
    [super setUp];
    storyboard = [UIStoryboard storyboardWithName:@"ContactUs" bundle:StoryboardBundle];
    self.vc = [storyboard instantiateViewControllerWithIdentifier:@"ChatWithPhilips"];
    [self.vc view];
}

-(void)testLiveChatURL
{
    XCTAssertNotNil([self.vc getChatURL],@"Livechat url is not nil");
}

- (void)testServiceDiscoveryLiveChat
{
  if([ServiceDiscoveryDict[kSDTWITTERURL] valueForKey:@"url"])
    XCTAssertNotNil([ServiceDiscoveryDict[kSDTWITTERURL] valueForKey:@"url"], @"service discovery live chat url available");
    else
    XCTAssertNil([ServiceDiscoveryDict[kSDTWITTERURL] valueForKey:@"url"], @"service discovery live chat url  is not available");
}
    
@end
