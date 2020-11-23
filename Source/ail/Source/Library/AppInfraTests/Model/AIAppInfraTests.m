//
//  AIAppInfraTests.m
//  AppInfra
//
//  Created by Ravi Kiran HR on 09/03/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AIAppInfra.h"
#import "NSBundle+Bundle.h"

@interface ResponseSerializerUtility: NSObject
+(void)processSSLPublicPinsFromResponse:(NSHTTPURLResponse *)response;
@end


@interface AIAppInfraTests : XCTestCase

@end

@implementation AIAppInfraTests
{
    AIAppInfra * appInfra;
}

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
    appInfra = [AIAppInfraTests sharedAppInfra];
}

- (void)testGetComponentId {
    XCTAssertEqualObjects([appInfra getComponentId], @"ail");
}

- (void)testGetComponentVersion {
    appInfra.appVersion = @"1.2.3";
    XCTAssertEqualObjects([appInfra getVersion], @"1.2.3");
}

- (void)testGetComponentVersionUnHappyFlow {
    appInfra.appVersion = @"";
    XCTAssertNotEqualObjects([appInfra getVersion], @"1.2.3");
}

-(void)testSomething {
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://www.google.com"] statusCode:100 HTTPVersion:nil headerFields:@{@"public-key-pins": @"pin-sha256=\"Vjs8r4z+80wjNcr1YKepWQboSIRi63WsWXhIMN+eWys=\"; pin-sha256=\"bpdmEJVOD+Mv6cdLBnP2sKXCQ9+B+X+xEvvWzLqwWus=\"; max-age=300"}];
    [ResponseSerializerUtility processSSLPublicPinsFromResponse:response];
}
@end
