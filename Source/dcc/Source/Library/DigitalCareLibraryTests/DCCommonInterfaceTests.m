//
//  DCCommonInterfaceTests.m
//  PhilipsConsumerCare
//
//  Created by sameer sulaiman on 9/16/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DCLaunchInput.h"
#import "DCInterface.h"
#import <UAPPFramework/UAPPFramework.h>
#import "DCDependencies.h"

@interface DCCommonInterfaceTests : XCTestCase
@property(nonatomic,strong)DCLaunchInput *launchInput;
@property(nonatomic,strong)DCInterface *dcInterface;
@end

@implementation DCCommonInterfaceTests

- (void)testDCLaunchInput {
    _launchInput = [[DCLaunchInput alloc] init];
    XCTAssertTrue([_launchInput isKindOfClass:[UAPPLaunchInput class]], @"Class type must be UAPPLaunchInput class");
}

-(void)testDCInterface{
    DCDependencies *dcDependencies = [[DCDependencies alloc] init];
    _dcInterface = [[DCInterface alloc]initWithDependencies:dcDependencies andSettings:nil];
    XCTAssertNotNil(_dcInterface,@"dcInterface is not nil");
    UIViewController *viewController = [_dcInterface instantiateViewController:_launchInput withErrorHandler:^(NSError * _Nullable error) {
        NSLog(@"Error %@",[error description]);
    }];
    XCTAssertNotNil(viewController,@"DCViewcontroller is not nil");
}

-(void)testDCInterfaseinstantiateViewController
{
    UIViewController *viewController;
    viewController = [self.dcInterface instantiateViewController:self.launchInput withErrorHandler:^(NSError *error) {
        NSLog(@"error happened");
        XCTAssertNotNil(viewController,@"dcInteviewControllerrface is not nil");
    }];
}
@end
