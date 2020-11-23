//
//  PPRRequestHandlerTests.m
//  PhilipsProductRegistration
//
//  Created by DV Ravikumar on 10/03/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <PhilipsRegistration/DIUser.h>
#import <PhilipsRegistration/DIRegistrationJsonConfiguration.h>
#import <PhilipsPRXClient/PRXRequestManager.h>
#import "PhilipsProductRegistrationTests-Swift.h"
#import "PPRUserRegistrationConfigObject.h"

@interface PPRRequestHandlerTests : XCTestCase
@property (nonatomic,strong) DIRegistrationJsonConfiguration *jsonConfig;
@property (nonatomic,strong) PPRRequestHandler *requestHandler;
@property (nonatomic,strong) id requestHandlerMock;
@end

@interface PPRRequestHandler ()
@property (nonatomic, strong) DIUser *user;
@end


@implementation PPRRequestHandlerTests

- (void)setUp {
    [super setUp];
    self.jsonConfig = [PPRUserRegistrationConfigObject fakeDIRegistrationJSONConfigWith:@"Staging"];
    DIUser *user = [self fakeUserWithEmail];
    self.requestHandler = [[PPRRequestHandler alloc] initWithUser:user];
    self.requestHandlerMock = [OCMockObject partialMockForObject:self.requestHandler];
}

- (void)tearDown {
    [super tearDown];
}

- (DIUser *)fakeDIUSerWithEmail:(NSString *)email{
    id mock = [OCMockObject niceMockForClass:[DIUser class]];
    [[[mock stub] andReturn:email] email];
    [[[mock stub] andReturnValue:[NSNumber numberWithBool:YES]] isLoggedIn];
    [[[mock stub] andReturn:@"SBSDBASSAF"] getJanrainAccessToken];
    return mock;
}

- (DIUser *)fakeUserLogOut {
    id mock = [OCMockObject niceMockForClass:[DIUser class]];
    [[[mock stub] andReturnValue:[NSNumber numberWithBool:NO]] isLoggedIn];
    return mock;
}

- (PPRProduct *)fakeProductWithCTNNotNull:(BOOL)isCTNNotNull validDate:(BOOL)isValidDate
{
    id productMock = [OCMockObject niceMockForClass:[PPRProduct class]];
    [[[productMock stub] andReturnValue:[NSNumber numberWithBool:isCTNNotNull]] isCTNNotNil];
    [[[productMock stub] andReturnValue:[NSNumber numberWithBool:isValidDate]] isValidDate];
    return productMock;
}

- (void)testUserLogin {
    DIUser *user = [self fakeUserWithEmail];
    XCTAssertEqualObjects(user.email,@"dv1@mailinator.com");
    XCTAssertTrue(user.isLoggedIn);
    XCTAssertEqual(user.janrainAccessToken, @"SBSDBASSAF");
}

- (void)testUserLogOut {
    DIUser *user = [self fakeUserLogOut];
    XCTAssertEqualObjects(user.email,nil);
    XCTAssertFalse(user.isLoggedIn);
    XCTAssertEqual(user.janrainAccessToken, nil);
}

- (DIUser *)fakeUserWithEmail {
    return [self fakeDIUSerWithEmail:@"dv1@mailinator.com"];
}

- (void)testJSONConfig {
    XCTAssertNotNil(self.jsonConfig);
    XCTAssertEqual(self.jsonConfig.signInProviders.count, 3);
    XCTAssertEqualObjects(self.jsonConfig.pILConfiguration.micrositeID, @"77000");
    XCTAssertEqual(self.jsonConfig.pILConfiguration.registrationEnvironment,kRegistrationEnvironmentStaging);
    XCTAssertTrue(self.jsonConfig.flow.isEmailVerificationRequired);
    XCTAssertTrue(self.jsonConfig.flow.isTermsAndConditionsAcceptanceRequired);
    XCTAssertTrue(self.jsonConfig.flow.minimumAgeLimit);
    XCTAssertEqualObjects(self.jsonConfig.janRainConfiguration.registrationClientID, @"f2stykcygm7enbwfw2u9fbg6h6syb8yd");
}

- (void)testRequestHandlerWithUserLoggedIn {
    DIUser *user = [self fakeUserWithEmail];
    PPRRequestHandler *requestHadnler = [[PPRRequestHandler alloc] initWithUser:user];
    XCTAssertTrue(requestHadnler.user.isLoggedIn);
    XCTAssertEqualObjects(requestHadnler.user.email, @"dv1@mailinator.com");
    XCTAssertEqualObjects(requestHadnler.user.janrainAccessToken, @"SBSDBASSAF");
}

- (void)testRequestHandlerWithUserLogOut {
    DIUser *user = [self fakeUserLogOut];
    PPRRequestHandler *requestHadnler = [[PPRRequestHandler alloc] initWithUser:user];
    XCTAssertFalse(requestHadnler.user.isLoggedIn);
}

- (void)testRegisterProductSuccess {
    PPRProduct *product = [self fakeProductWithCTNNotNull:true validDate:true];
    XCTestExpectation *registerProdcut = [self expectationWithDescription:@"Register"];
    
    void (^callSuccess)(NSInvocation *) = ^(NSInvocation *invocation) {
        void(^success)(PRXResponseData *data);
        [invocation getArgument:&success atIndex:3];
        success(nil);
    };
    
    [[[self.requestHandlerMock expect] andDo:callSuccess] registerProduct:[OCMArg any]
                                                                  success:[OCMArg any]
                                                                  failure:[OCMArg any]];
    [self.requestHandler registerProduct:product success:^(PRXResponseData *response) {
        [registerProdcut fulfill];
        XCTAssertTrue(true);
    } failure:^(NSError *error) {
        [registerProdcut fulfill];
        XCTFail(@"Expecting get success block");
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testRegisterProductWithCTNNullError {
    PPRProduct *product = [self fakeProductWithCTNNotNull:false validDate:true];
    XCTestExpectation *registerProdcut = [self expectationWithDescription:@"Register"];
    
    void (^callFailure)(NSInvocation *) = ^(NSInvocation *invocation) {
        void(^failure)(NSError *error);
        [invocation getArgument:&failure atIndex:4];
        failure([NSError errorWithDomain:@"Error" code:PPRErrorCTN_NOT_ENTERED userInfo:nil]);
    };
    
    [[[self.requestHandlerMock expect] andDo:callFailure] registerProduct:[OCMArg any]
                                                                  success:[OCMArg any]
                                                                  failure:[OCMArg any]];
    [self.requestHandler registerProduct:product success:^(PRXResponseData *response) {
        [registerProdcut fulfill];
        XCTFail(@"Expecting get failure block with CTN not enterd error");
    } failure:^(NSError *error) {
        [registerProdcut fulfill];
        XCTAssertTrue(error.code == PPRErrorCTN_NOT_ENTERED);
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testRegisterProductWithUserNotLoggedInError {
    PPRProduct *product = [self fakeProductWithCTNNotNull:false validDate:true];
    XCTestExpectation *registerProdcut = [self expectationWithDescription:@"Register"];
    
    void (^callFailure)(NSInvocation *) = ^(NSInvocation *invocation) {
        void(^failure)(NSError *error);
        [invocation getArgument:&failure atIndex:4];
        failure([NSError errorWithDomain:@"Error" code:PPRErrorUSER_NOT_LOGGED_IN userInfo:nil]);
    };
    
    [[[self.requestHandlerMock expect] andDo:callFailure] registerProduct:[OCMArg any]
                                                                  success:[OCMArg any]
                                                                  failure:[OCMArg any]];
    [self.requestHandler registerProduct:product success:^(PRXResponseData *response) {
        [registerProdcut fulfill];
        XCTFail(@"Expecting get failure block with user not loggedin error");
    } failure:^(NSError *error) {
        [registerProdcut fulfill];
        XCTAssertTrue(error.code == PPRErrorUSER_NOT_LOGGED_IN);
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testRegisterProductWithInvalidPurchaseDateError {
    PPRProduct *product = [self fakeProductWithCTNNotNull:false validDate:true];
    XCTestExpectation *registerProdcut = [self expectationWithDescription:@"Register"];
    
    void (^callFailure)(NSInvocation *) = ^(NSInvocation *invocation) {
        void(^failure)(NSError *error);
        [invocation getArgument:&failure atIndex:4];
        failure([NSError errorWithDomain:@"Error" code:PPRErrorINVALID_PURCHASE_DATE userInfo:nil]);
    };
    
    [[[self.requestHandlerMock expect] andDo:callFailure] registerProduct:[OCMArg any]
                                                                  success:[OCMArg any]
                                                                  failure:[OCMArg any]];
    [self.requestHandler registerProduct:product success:^(PRXResponseData *response) {
        [registerProdcut fulfill];
        XCTFail(@"Expecting get failure block with Invalid purchasedate error");
    } failure:^(NSError *error) {
        [registerProdcut fulfill];
        XCTAssertTrue(error.code == PPRErrorINVALID_PURCHASE_DATE);
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testRegisterProductWithRequiredPurchaseDateError {
    PPRProduct *product = [self fakeProductWithCTNNotNull:false validDate:true];
    XCTestExpectation *registerProdcut = [self expectationWithDescription:@"Register"];
    
    void (^callFailure)(NSInvocation *) = ^(NSInvocation *invocation) {
        void(^failure)(NSError *error);
        [invocation getArgument:&failure atIndex:4];
        failure([NSError errorWithDomain:@"Error" code:PPRErrorREQUIRED_PURCHASE_DATE userInfo:nil]);
    };
    
    [[[self.requestHandlerMock expect] andDo:callFailure] registerProduct:[OCMArg any]
                                                                  success:[OCMArg any]
                                                                  failure:[OCMArg any]];
    [self.requestHandler registerProduct:product success:^(PRXResponseData *response) {
        [registerProdcut fulfill];
        XCTFail(@"Expecting get failure block with required purchasedate error");
    } failure:^(NSError *error) {
        [registerProdcut fulfill];
        XCTAssertTrue(error.code == PPRErrorREQUIRED_PURCHASE_DATE);
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testRegisterProductWithInvalidSerialNumberError {
    PPRProduct *product = [self fakeProductWithCTNNotNull:false validDate:true];
    XCTestExpectation *registerProdcut = [self expectationWithDescription:@"Register"];
    
    void (^callFailure)(NSInvocation *) = ^(NSInvocation *invocation) {
        void(^failure)(NSError *error);
        [invocation getArgument:&failure atIndex:4];
        failure([NSError errorWithDomain:@"Error" code:PPRErrorINVALID_SERIAL_NUMBER userInfo:nil]);
    };
    
    [[[self.requestHandlerMock expect] andDo:callFailure] registerProduct:[OCMArg any]
                                                                  success:[OCMArg any]
                                                                  failure:[OCMArg any]];
    [self.requestHandler registerProduct:product success:^(PRXResponseData *response) {
        [registerProdcut fulfill];
        XCTFail(@"Expecting get failure block with Invalid serial number error");
    } failure:^(NSError *error) {
        [registerProdcut fulfill];
        XCTAssertTrue(error.code == PPRErrorINVALID_SERIAL_NUMBER);
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testRegisterProductWithInvalidSerialNumberAndReqPurchaseDateError {
    PPRProduct *product = [self fakeProductWithCTNNotNull:false validDate:true];
    XCTestExpectation *registerProdcut = [self expectationWithDescription:@"Register"];
    
    void (^callFailure)(NSInvocation *) = ^(NSInvocation *invocation) {
        void(^failure)(NSError *error);
        [invocation getArgument:&failure atIndex:4];
        failure([NSError errorWithDomain:@"Error" code:PPRErrorINVALID_SERIAL_NUMBER_AND_PURCHASE_DATE userInfo:nil]);
    };
    
    [[[self.requestHandlerMock expect] andDo:callFailure] registerProduct:[OCMArg any]
                                                                  success:[OCMArg any]
                                                                  failure:[OCMArg any]];
    [self.requestHandler registerProduct:product success:^(PRXResponseData *response) {
        [registerProdcut fulfill];
        XCTFail(@"Expecting get failure block with Invalid serialnumber and purchase date required error");
    } failure:^(NSError *error) {
        [registerProdcut fulfill];
        XCTAssertTrue(error.code == PPRErrorINVALID_SERIAL_NUMBER_AND_PURCHASE_DATE);
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testRegisterProductWithAlredayRegistredError {
    PPRProduct *product = [self fakeProductWithCTNNotNull:false validDate:true];
    XCTestExpectation *registerProdcut = [self expectationWithDescription:@"Register"];
    
    void (^callFailure)(NSInvocation *) = ^(NSInvocation *invocation) {
        void(^failure)(NSError *error);
        [invocation getArgument:&failure atIndex:4];
        failure([NSError errorWithDomain:@"Error" code:PPRErrorPRODUCT_ALREADY_REGISTERD userInfo:nil]);
    };
    
    [[[self.requestHandlerMock expect] andDo:callFailure] registerProduct:[OCMArg any]
                                                                  success:[OCMArg any]
                                                                  failure:[OCMArg any]];
    [self.requestHandler registerProduct:product success:^(PRXResponseData *response) {
        [registerProdcut fulfill];
        XCTFail(@"Expecting get failure block with Product already registred error");
    } failure:^(NSError *error) {
        [registerProdcut fulfill];
        XCTAssertTrue(error.code == PPRErrorPRODUCT_ALREADY_REGISTERD);
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

//- (void)testGetMetadataSuccess {
//    PPRProduct *product = [self fakeProductWithCTNNotNull:false validDate:true];
//    XCTestExpectation *registerProdcut = [self expectationWithDescription:@"Metadata"];
//    
//    void (^callSuccess)(NSInvocation *) = ^(NSInvocation *invocation) {
//        void(^success)(PRXResponseData *data);
//        [invocation getArgument:&success atIndex:3];
//        success(nil);
//    };
//    
//    [[[self.requestHandlerMock expect] andDo:callSuccess] getProductMetaDataWithProductInfo:[OCMArg any]
//                                                                                    success:[OCMArg any]
//                                                                                    failure:[OCMArg any]];
//    [self.requestHandler getProductMetaDataWithProductInfo:productInfo success:^(PRXResponseData *response) {
//        [registerProdcut fulfill];
//        XCTAssertTrue(true);
//    } failure:^(NSError *error) {
//        [registerProdcut fulfill];
//        XCTFail(@"Expecting to get success");
//    }];
//    [self waitForExpectationsWithTimeout:5.0 handler:nil];
//}
//
//- (void)testGetMetadataWithCTNNotEnteredError {
//    PPRProductRegistrationInfo *productInfo = [self fakeProductInfoWithCTNNotNull:false validDate:true];
//    XCTestExpectation *registerProdcut = [self expectationWithDescription:@"Metadata"];
//    
//    void (^callFailure)(NSInvocation *) = ^(NSInvocation *invocation) {
//        void(^failure)(NSError *error);
//        [invocation getArgument:&failure atIndex:4];
//        failure([NSError errorWithDomain:@"Error" code:ErrorCTN_NOT_ENTERED userInfo:nil]);
//    };
//    
//    [[[self.requestHandlerMock expect] andDo:callFailure] getProductMetaDataWithProductInfo:[OCMArg any]
//                                                                                    success:[OCMArg any]
//                                                                                    failure:[OCMArg any]];
//    [self.requestHandler getProductMetaDataWithProductInfo:productInfo success:^(PRXResponseData *response) {
//        [registerProdcut fulfill];
//        XCTFail(@"Expecting get failure block with CTN not enterd error");
//    } failure:^(NSError *error) {
//        [registerProdcut fulfill];
//        XCTAssertTrue(error.code == ErrorCTN_NOT_ENTERED);
//    }];
//    [self waitForExpectationsWithTimeout:5.0 handler:nil];
//}

- (void)testGetRegistredProductListSuccess {
    XCTestExpectation *registerProdcut = [self expectationWithDescription:@"ProductList"];
    
    void (^callSuccess)(NSInvocation *) = ^(NSInvocation *invocation) {
        void(^success)(PRXResponseData *data);
        [invocation getArgument:&success atIndex:2];
        success(nil);
    };
    
    [[[self.requestHandlerMock expect] andDo:callSuccess] getRegisteredProductList:[OCMArg any]
                                                                           failure:[OCMArg any]];
    [self.requestHandler getRegisteredProductList:^(PRXResponseData *response) {
        [registerProdcut fulfill];
        XCTAssertTrue(true);
    } failure:^(NSError *error) {
        [registerProdcut fulfill];
        XCTFail(@"Expecting to get success");
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testGetRegistredProductListWithError {
    XCTestExpectation *registerProdcut = [self expectationWithDescription:@"ProductList"];
    
    void (^callFailure)(NSInvocation *) = ^(NSInvocation *invocation) {
        void(^failure)(NSError *error);
        [invocation getArgument:&failure atIndex:3];
        failure([NSError errorWithDomain:@"Error" code:PPRErrorNO_INTERNET_CONNECTION userInfo:nil]);
    };
    
    [[[self.requestHandlerMock expect] andDo:callFailure] getRegisteredProductList:[OCMArg any]
                                                                           failure:[OCMArg any]];
    [self.requestHandler getRegisteredProductList:^(PRXResponseData *response) {
        [registerProdcut fulfill];
        XCTFail(@"Expecting to get error");
    } failure:^(NSError *error) {
        [registerProdcut fulfill];
        XCTAssertTrue(error.code == PPRErrorNO_INTERNET_CONNECTION);
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

@end
