//
//  DCHandlerTests.m
//  DigitalCareLibraryTests
//
//  Created by sameer sulaiman on 10/25/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DCHandler.h"
#import "DCLaunchInput.h"
#import "DCInterface.h"
#import "DCDependencies.h"
#import "DCContentConfiguration.h"
#import <PlatformInterfaces/PlatformInterfaces-Swift.h>
@interface DCHandlerTests : XCTestCase

@end

@implementation DCHandlerTests

- (void)testAppSpecificCongigPath {
    [DCHandler setAppSpecificConfigFilePath:[[NSBundle bundleForClass:self.class]pathForResource:@"DigitalCareConfiguration" ofType:@"plist"]];
    XCTAssertNotNil([DCHandler getAppSpecificConfigFilePath], @"App Specific Config file path available");
}

- (void)testLocationConsentDefinitionGetsSetFromLaunchInput {
    DCLaunchInput *dcLaunchInput = [[DCLaunchInput alloc]init];
    DCInterface *dcInterface = [[DCInterface alloc]initWithDependencies:[[DCDependencies alloc]init] andSettings:nil];
    dcLaunchInput.locationConsentDefinition = [[ConsentDefinition alloc]initWithType:@"dummy" text:@"Hi" helpText:@"Help hi" version:1 locale:@"en_US"];
    [dcInterface instantiateViewController:dcLaunchInput withErrorHandler:nil];
    XCTAssertEqual(dcLaunchInput.locationConsentDefinition, [DCHandler getLocationConsentDefinition]);
}

- (void)testGetContentConfiguration {
    NSString *customChatDesc = @"customized live chat desc";
    DCLaunchInput *dcLaunchInput = [[DCLaunchInput alloc]init];
    DCInterface *dcInterface = [[DCInterface alloc]initWithDependencies:[[DCDependencies alloc]init] andSettings:nil];
    DCContentConfiguration *contentConfig = [[DCContentConfiguration alloc] init];
    contentConfig.livechatDescText = customChatDesc;
    [dcLaunchInput setContentConfiguration:contentConfig];
    [dcInterface instantiateViewController:dcLaunchInput withErrorHandler:nil];
    
    XCTAssertEqual(customChatDesc, [[DCHandler getContentConfiguration] livechatDescText]);
}

@end
