//
//  AIRESTClientURLResponseSerializationTest.m
//  AppInfraTests
//
//  Created by philips on 5/22/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AIRESTClientURLResponseSerialization.h"

@interface AIRESTClientURLResponseSerializationTest : XCTestCase
@end

@implementation AIRESTClientURLResponseSerializationTest


- (void)testAIRESTClientHTTPResponseSerializerNoError {
    NSDictionary *value;
    NSDictionary *dataDict = @{@"someKey":@"SomeValue"
                               };
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil];
    AIRESTClientHTTPResponseSerializer * responseSerializer = [[AIRESTClientHTTPResponseSerializer alloc]init];
    NSError *error;
    value =[responseSerializer responseObjectForResponse:nil data:data error:&error];
    XCTAssertEqualObjects(value,data);
}

- (void)testAIRESTClientHTTPResponseSerializerWithError {
    NSDictionary *value;
    NSDictionary *dataDict = @{@"someKey":@"SomeValue"
                               };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil];
    NSError *error = [[NSError alloc] initWithDomain:NSURLErrorDomain code:1069 userInfo:nil];
    AIRESTClientHTTPResponseSerializer * responseSerializer = [[AIRESTClientHTTPResponseSerializer alloc]init];
    value =[responseSerializer responseObjectForResponse:nil data:data error:&error];
    XCTAssertEqualObjects(value,data);
}

- (void)testAIRESTClientJsonResponseSerializerNoError {
    NSDictionary *value;
    NSDictionary *dataDict = @{@"someKey":@"SomeValue"
                               };
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil];
    AIRESTClientJSONResponseSerializer * responseSerializer = [[AIRESTClientJSONResponseSerializer alloc]init];
    NSError *error;
    value =[responseSerializer responseObjectForResponse:nil data:data error:&error];
    XCTAssertEqualObjects(value,dataDict);
}

- (void)testAIRESTClientJsonResponseSerializerWithError {
    NSDictionary *value;
    NSDictionary *dataDict = @{@"someKey":@"SomeValue"
                               };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil];
    AIRESTClientJSONResponseSerializer * responseSerializer = [[AIRESTClientJSONResponseSerializer alloc]init];
    NSError *error = [[NSError alloc] initWithDomain:NSURLErrorDomain code:1069 userInfo:nil];
    value =[responseSerializer responseObjectForResponse:nil data:data error:&error];
    XCTAssertEqualObjects(value,dataDict);
}


@end
