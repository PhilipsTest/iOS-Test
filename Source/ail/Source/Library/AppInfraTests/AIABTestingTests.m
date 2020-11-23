//
//  AIABTestingTests.m
//  AppInfra
//
//  Created by Hashim MH on 03/10/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppInfra.h"
#import "AIABTest.h"
#import "NSBundle+Bundle.h"
#import <OCMock/OCMock.h>


@interface AIABTestingTests : XCTestCase
{
    AIABTest * abTest;
    AIAppInfra * appInfra;

}

@end

@implementation AIABTestingTests

+ (id) sharedAppInfra {
    static dispatch_once_t time = 0;
    static AIAppInfra *_sharedObject = nil;
    dispatch_once(&time, ^{
        _sharedObject = [AIAppInfra buildAppInfraWithBlock:nil];
    });
    return _sharedObject;
}

- (void)setUp {
    [super setUp];
    [NSBundle loadSwizzler];
    appInfra = [AIABTestingTests sharedAppInfra];
    abTest = [[AIABTest alloc]initWithAppInfra:appInfra];
   }

-(void)testGetMappedTestValue{
    
    NSString*value =  [abTest getTestValue:@"ai.componentTestname" defaultContent:@"Value" updateType:AIABTestUpdateTypeAppStart];
    XCTAssertEqualObjects(@"Value", value);
    XCTAssertEqual(@"Value", value);
}

- (void)tearDown {
    [super tearDown];
    appInfra = nil;
    abTest = nil;
}


@end
