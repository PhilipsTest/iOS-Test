//
//  testAbstractMethods.m
//  PRXClient
//
//  Created by KRISHNA KUMAR on 08/12/15.
//  Copyright © 2017 Koninklijke Philips N.V.. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PRXResponseData.h"
#import "PRXRequest.h"

@interface testAbstractMethods : XCTestCase
{
    
}

@end

@implementation testAbstractMethods

- (void)setUp {
    [super setUp];
}

-(void)testResponseAbstract
{
    PRXResponseData *data=[[PRXResponseData alloc] init];
    XCTAssertThrowsSpecificNamed([data parseResponse:nil], NSException, NSInternalInconsistencyException);
}

-(void)testBuilderAbstract
{
    PRXRequest *builder=[[PRXRequest alloc] init];
    XCTAssertThrowsSpecificNamed([builder getResponse:nil], NSException, NSInternalInconsistencyException);
    
}


@end
