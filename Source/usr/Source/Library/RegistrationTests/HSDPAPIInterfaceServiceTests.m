//
//  HSDPAPIInterfaceServiceTests.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <XCTest/XCTest.h>
#import "HSDPAPIInterfaceService.h"
#import "URDependencies.h"
#import "URSettingsWrapper.h"
#import "DIHSDPConfiguration.h"

@interface HSDPAPIInterfaceServiceTests : XCTestCase
@property (nonatomic, strong) HSDPAPIInterfaceService *hsdpService;
@end

@implementation HSDPAPIInterfaceServiceTests

- (void)setUp {
    [super setUp];
    URDependencies *dependencies = [[URDependencies alloc] init];
    dependencies.appInfra = [[AIAppInfra alloc] initWithBuilder:nil];
    
    NSError *error = nil;
    [dependencies.appInfra.appConfig setPropertyForKey:@"HSDPConfiguration.ApplicationName" group:@"UserRegistration"  value:@"uGrow" error:&error];
    [dependencies.appInfra.appConfig setPropertyForKey:@"HSDPConfiguration.Shared" group:@"UserRegistration"  value:@"e95f5e71-c3c0-4b52-8b12-ec297d8ae960" error:&error];
    [dependencies.appInfra.appConfig setPropertyForKey:@"HSDPConfiguration.BaseURL" group:@"UserRegistration"  value:@"https://user-registration-assembly-staging.eu-west.philips-healthsuite.com" error:&error];
    [dependencies.appInfra.appConfig setPropertyForKey:@"HSDPConfiguration.Secret" group:@"UserRegistration"  value:@"e33a4d97-6ada-491f-84e4-a2f7006625e2" error:&error];
    [URSettingsWrapper sharedInstance].dependencies = dependencies;
    DIHSDPConfiguration *config = [[DIHSDPConfiguration alloc] initWithCountryCode:@"US" baseURL:nil];
    _hsdpService = [[HSDPAPIInterfaceService alloc] initWithConfiguration:config];
}

- (void)tearDown {
    [super tearDown];
    URDependencies *dependencies = [URSettingsWrapper sharedInstance].dependencies;
    NSError *error = nil;
    [dependencies.appInfra.appConfig setPropertyForKey:@"HSDPConfiguration.ApplicationName" group:@"UserRegistration"  value:nil error:&error];
    [dependencies.appInfra.appConfig setPropertyForKey:@"HSDPConfiguration.Shared" group:@"UserRegistration"  value:nil error:&error];
    [dependencies.appInfra.appConfig setPropertyForKey:@"HSDPConfiguration.BaseURL" group:@"UserRegistration"  value:nil error:&error];
    [dependencies.appInfra.appConfig setPropertyForKey:@"HSDPConfiguration.Secret" group:@"UserRegistration"  value:nil error:&error];
    [URSettingsWrapper sharedInstance].dependencies = nil;
}

- (void)testGetLogoutRequest {
    NSString *accessToken = nil;
    NSString *userUUID  = nil;
    XCTAssertNil([self.hsdpService logoutRequestForAccessToken:accessToken andUUID:userUUID], @"Request can not be generated if any of the parameters is nil");
    accessToken = @"aDummyAccessToken";
    userUUID  = @"a-dummy-user-uuid";
    NSURLRequest *request = [self.hsdpService logoutRequestForAccessToken:accessToken andUUID:userUUID];
    XCTAssertEqualObjects(request.HTTPMethod, @"PUT", @"Logout service with PUT method only is valid");
    XCTAssertEqualObjects(request.allHTTPHeaderFields[@"accessToken"], accessToken, @"Access token in header should be same as provided");
    NSRange range=[[request.URL absoluteString] rangeOfString:userUUID];
    XCTAssertFalse(range.location==NSNotFound, @"Request URL must contain the user UUID as provided");
}

- (void)testGetRefreshTokenRequest {
    NSString *refreshToken = nil;
    NSString *userUUID  = nil;
    XCTAssertNil([self.hsdpService refreshRequestWithRefreshToken:refreshToken userUUID:userUUID], @"Request can not be generated if any of the parameters is nil");
    refreshToken = @"aDummyRefreshToken";
    userUUID  = @"a-dummy-user-uuid";
    NSURLRequest *request = [self.hsdpService refreshRequestWithRefreshToken:refreshToken userUUID:userUUID];
    XCTAssertEqualObjects(request.HTTPMethod, @"PUT", @"Refresh service with PUT method only is valid");
    NSDictionary *lDict=[NSJSONSerialization JSONObjectWithData:request.HTTPBody options:kNilOptions error:nil];
    XCTAssertEqualObjects(refreshToken, lDict[@"refreshToken"], @"Request body should have same parameters as provided");
    NSRange range=[[request.URL absoluteString] rangeOfString:userUUID];
    XCTAssertFalse(range.location==NSNotFound, @"Request URL must contain the user UUID as provided");
}

- (void)testGetRefreshSecretRequest {
    NSString *accessToken = nil;
    NSString *refreshSecret = nil;
    NSString *userUUID  = nil;
    XCTAssertNil([self.hsdpService refreshRequestWithAccessToken:accessToken refreshSecret:refreshSecret userUUID:userUUID], @"Request can not be generated if any of the parameters is nil");
    accessToken = @"aDummyAccessToken";
    refreshSecret = @"aDummyRefreshSecret";
    userUUID  = @"a-dummy-user-uuid";
    NSURLRequest *request = [self.hsdpService refreshRequestWithAccessToken:accessToken refreshSecret:refreshSecret userUUID:userUUID];
    XCTAssertEqualObjects(request.HTTPMethod, @"POST", @"Refresh using refresh secret service with POST method only is valid");
    NSDictionary *lDict=request.allHTTPHeaderFields;
    XCTAssertEqualObjects(accessToken, lDict[@"accessToken"], @"Request header should have same parameters as provided");
    XCTAssertNotNil(lDict[@"api-version"], @"API version must be provided for refresh API");
    XCTAssertEqualObjects(lDict[@"api-version"], @"2", @"HSDP API version 2 must be used for refresh API");
    NSRange range=[[request.URL absoluteString] rangeOfString:userUUID];
    XCTAssertFalse(range.location==NSNotFound, @"Request URL must contain the user UUID as provided");
}


- (void)testGetSocialSignInRequest {
    NSString *email = nil;
    NSString *accessToken  = nil;
    NSString *refreshtoken  = nil;
    XCTAssertNil([self.hsdpService socialSignInRequestWithEmail:email accessToken:accessToken refreshSecret:refreshtoken], @"Request can not be generated if any of the parameters is nil");
    email = @"test@mail.com";
    accessToken = @"aDummyAccessToken";
    refreshtoken = @"aDummyRefreshtoken";
    NSURLRequest *request=[self.hsdpService socialSignInRequestWithEmail:email accessToken:accessToken refreshSecret:refreshtoken];
    XCTAssertTrue(request!=nil,@"Request should not be nil if both parameters are present");
    XCTAssertNotNil(request.allHTTPHeaderFields[@"api-version"], @"API version must be provided for social sign In");
    XCTAssertEqualObjects(request.allHTTPHeaderFields[@"api-version"], @"2", @"HSDP API version 2 must be used for social sign In");
    NSDictionary *lDict=[NSJSONSerialization JSONObjectWithData:request.HTTPBody options:kNilOptions error:nil];
    XCTAssertEqualObjects(email, lDict[@"loginId"], @"Request body should have same parameters as provided");
}
@end
