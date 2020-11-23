//
//  DisclaimerTests.m
//  PRXClientTests
//
//  Created by Prasad Devadiga on 21/09/18.
//  Copyright © 2018 Koninklijke Philips N.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MockPRXAppInfra.h"
#import "PRXDependencies.h"
#import "MockPRXRequestManager.h"
#import "PRXDisclaimerData.h"
#import "PRXDisclaimers.h"
#import "PRXDisclaimerRequest.h"
#import "PRXDisclaimerResponse.h"


@interface DisclaimerTests : XCTestCase

@end

@implementation DisclaimerTests

- (void)testFetchDisclaimer {
    MockPRXAppInfra *appInfra = [[MockPRXAppInfra alloc] init];
    PRXDependencies *dependency = [[PRXDependencies alloc] initWithAppInfra:appInfra parentTLA:@"IAP"];
    MockPRXRequestManager *requestManager = [[MockPRXRequestManager alloc] initWithDependencies:dependency];
    requestManager.type = requestTypeDisclaimer;
    PRXDisclaimerRequest *request = [[PRXDisclaimerRequest alloc] initWithSector:B2C ctnNumber:@"123" catalog:CATALOG_DEFAULT];
    [requestManager execute:request completion:^(PRXResponseData *response) {
        if ([response isKindOfClass:[PRXDisclaimerResponse class]]) {
            PRXDisclaimerResponse *disclaimerResponse = (PRXDisclaimerResponse *) response;
            XCTAssertTrue([disclaimerResponse.data.disclaimers.disclaimer count] == 1);
        } else {
            XCTAssert("");
        }

    } failure:^(NSError *error) {

    }];
}

- (void)testFetchDisclaimerError {
    MockPRXAppInfra *appInfra = [[MockPRXAppInfra alloc] init];
    PRXDependencies *dependency = [[PRXDependencies alloc] initWithAppInfra:appInfra parentTLA:@"IAP"];
    MockPRXRequestManager *requestManager = [[MockPRXRequestManager alloc] initWithDependencies:dependency];
    requestManager.type = requestTypeError;
    PRXDisclaimerRequest *request = [[PRXDisclaimerRequest alloc] initWithSector:B2C ctnNumber:@"123" catalog:CATALOG_DEFAULT];
    [requestManager execute:request completion:^(PRXResponseData *response) {
        if ([response isKindOfClass:[PRXDisclaimerResponse class]]) {
            PRXDisclaimerResponse *disclaimerResponse = (PRXDisclaimerResponse *) response;
            XCTAssertTrue([disclaimerResponse.data.disclaimers.disclaimer count] == 0);
        } else {
            XCTAssert("");
        }

    } failure:^(NSError *error) {
        XCTAssertTrue(error.code == 0);
        XCTAssertTrue([error.domain isEqualToString:@"PRXClient"]);
    }];
}

@end
