//
//  testNetworkWrapper.m
//  PRXClient
//
//  Created by Hashim MH on 09/01/17.
//  Copyright © 2017 Koninklijke Philips N.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PRXNetworkWrapper.h"

@interface testNetworkWrapper : XCTestCase

@end

@interface PRXNetworkWrapper (){
}
- (void)createCustomError:(NSURLSessionDataTask *)task
                    error:(NSError *)error
              withFailure:(void(^)(NSError *error))failure;

@end

@implementation testNetworkWrapper

- (void)testCustomError {
    PRXNetworkWrapper *networkWrapper = [[PRXNetworkWrapper alloc]init];
    
    XCTestExpectation *expectation =
    [self expectationWithDescription:@"customError"];
    
    [networkWrapper createCustomError:nil error:nil withFailure:^(NSError *error) {
        
        XCTAssertNotNil(error);
        [expectation fulfill];


    }];

    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];

   
    
}


@end
