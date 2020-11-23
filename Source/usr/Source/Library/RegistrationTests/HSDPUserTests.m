//
//  HSDPUserTests.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <XCTest/XCTest.h>
#import "HSDPUser.h"
#import "URRSAEncryptor.h"
#import "URRSADecryptorMock.h"
#import "HSDPUserTestsHelper.h"
@import AppInfra;
#import "URSettingsWrapper.h"
#import "DIConstants.h"


@interface HSDPUserTests : XCTestCase

@end

@implementation HSDPUserTests

- (void)setUp {
    [super setUp];

    AIAppInfra *appInfra = [[AIAppInfra alloc] initWithBuilder:nil];
    URDependencies *dependencies = [[URDependencies alloc] init];
    dependencies.appInfra = appInfra;
    [URSettingsWrapper sharedInstance].dependencies = dependencies;
}

- (void)tearDown {
    [super tearDown];
    [URSettingsWrapper sharedInstance].dependencies = nil;
}

- (void)testHSDPUserFail {
    HSDPUser *invalidUser = [[HSDPUser alloc] initWithSignInResponseDictionary:[HSDPUserTestsHelper mockInvalidJsonResponse] refreshSecret:nil];
    XCTAssertNil(invalidUser.accessToken,@"Access token should be nil if invalid json is provided");
    XCTAssertNil(invalidUser.refreshToken,@"Refresh token should be nil if invalid json is provided");
}

- (void)testHSDPUserPass {
    HSDPUser *user = [[HSDPUser alloc] initWithSignInResponseDictionary:[HSDPUserTestsHelper mockJsonResponse] refreshSecret:nil];
    XCTAssertNotNil(user.accessToken, @"Access token can not be nil if valid json is provided");
    XCTAssertNotNil(user.refreshToken, @"Refresh token can not be nil if valid json is provided");
    XCTAssertNotNil(user.userUUID, @"User uuid can not be nil if valid json is provided");
    XCTAssertEqualObjects([HSDPUserTestsHelper mockJsonResponse][@"exchange"][@"accessCredential"][@"accessToken"], user.accessToken, @"Access token should be same as provided in json response");
    XCTAssertEqualObjects([HSDPUserTestsHelper mockJsonResponse][@"exchange"][@"accessCredential"][@"refreshToken"], user.refreshToken, @"Refresh token should be same as provided in json response");
    XCTAssertEqualObjects([HSDPUserTestsHelper mockJsonResponse][@"exchange"][@"user"][@"userUUID"], user.userUUID, @"User UUID token should be same as provided in json response");
    user=nil;
}

- (void)testTokenInitializer {
    HSDPUser *user = [[HSDPUser alloc] initWithUUID:@"dummyUUID" tokenDictionary:[HSDPUserTestsHelper mockTokenDictionary]];
    XCTAssertNotNil(user, @"User should not be nil when correct dictionary is provided");
    XCTAssertNotNil(user.userUUID, @"UUID should not be nil when correct dictionary is provided");
    XCTAssertNotNil(user.accessToken, @"Access Token should not be nil when correct dictionary is provided");
    XCTAssertNotNil(user.refreshToken, @"Refresh Token should not be nil when correct dictionary is provided");
}

- (void)testRefreshSecretInitializer {
    HSDPUser *user = [[HSDPUser alloc] initWithUUID:@"dummy-UUID" refreshSecret:@"refresh-secret"
                                    tokenDictionary:[HSDPUserTestsHelper mockRefreshSecretDictionary]];
    XCTAssertNotNil(user, @"User should not be nil when correct inputs are provided");
    XCTAssertNotNil(user.userUUID, @"UUID should not be nil when correct inputs are provided");
    XCTAssertNotNil(user.accessToken, @"Access Token should not be nil when correct inputs are provided");
    XCTAssertNotNil(user.refreshSecret, @"Refresh Secret should not be nil when correct inputs are provided");
    XCTAssertNil(user.refreshToken, @"Refresh token must be nil when refresh secret is available");
    XCTAssertTrue([user isSignedIn], @"User must be signed in when all required fields are available");
    [user saveCurrentInstance];
    HSDPUser *recoveredUser = [HSDPUser loadPreviousInstance];
    XCTAssertNotNil(recoveredUser, @"Recovered user should not be nil when it was stored with correct details");
    [recoveredUser removeCurrentInstance];
    HSDPUser *recoveredUserAfterDeletion = [HSDPUser loadPreviousInstance];
    XCTAssertNil(recoveredUserAfterDeletion, @"User object should not be available when deleted");
}

- (void)testURRSAEncryptorKey {
    NSString *toBeEncrypted = @"Hello World!";
    
    NSString *newEncryptedKey = [URRSAEncryptor encryptString:toBeEncrypted withPublicKey:kHSDPSecurePubKey];
    NSString *decryptedString   = [URRSADecryptorMock decryptString:newEncryptedKey withPrivateKey:kHSDPSecurePrivateKey];
    
    XCTAssertEqualObjects(toBeEncrypted, decryptedString, @"Encrypted string should be equal");
}

@end
