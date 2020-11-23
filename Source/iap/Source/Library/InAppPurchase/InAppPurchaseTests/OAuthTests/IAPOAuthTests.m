//
//  IAPOAuthTests.m
//  InAppPurchase
//
//  Created by Rayan Sequeira on 29/03/16.
//  Copyright © 2016 Rakesh R. All rights reserved.
//

#import <XCTest/XCTest.h>
//#import <OCMock/OCMock.h>
#import "InAppPurchaseTests-Swift.h"


@interface IAPOAuthTests : XCTestCase

@end

@implementation IAPOAuthTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDownloadManager {
//    id mock = [OCMockObject niceMockForClass:[IAPOAuthDownloadManager class]];
    id mock = [[IAPOauthDownloadManager alloc] init];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
