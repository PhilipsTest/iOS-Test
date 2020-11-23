//
//  AIRESTClientTests.m
//  AppInfra
//
//  Created by Ravi Kiran HR on 17/08/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AIRESTClientInterface.h"
#import <OCMock/OCMock.h>
@import AppInfra;
#import "AFHTTPSessionManager+Swizzle.h"
#import "NSBundle+Bundle.h"
#import <objc/runtime.h>
#import "RESTClientReachability.h"
#import "AIAppInfra.h"
@interface AIRESTClientInterface()

-(BOOL)isValidUrl:(NSString *)urlString;
-(void)addAuthenticationData;
-(BOOL)isAuthTypeSupported:(AIRESTClientTokenType)authType;

@end

@interface AIRESTClientTests : XCTestCase <AIRESTClientDelegate>
{
    AIRESTClientInterface *restClient;
}
@end

@implementation AIRESTClientTests

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
    //    [AFHTTPSessionManager loadSwizzler];
    [NSBundle loadSwizzler];
    AIAppInfra * appInfra = [AIRESTClientTests sharedAppInfra];
    restClient = [[AIRESTClientInterface alloc]initWithAppInfra:appInfra];
}

-(void)testGETHttp {
    XCTAssertThrows([restClient GET:@"http://example.com" parameters:nil progress:nil success:nil failure:nil]);
}

-(void)testGETHttps {
    
    XCTAssertNoThrow([restClient GET:@"https://example.com" parameters:nil progress:nil success:nil failure:nil]);
}

-(void)testHEADHttps {
    XCTAssertNoThrow([restClient HEAD:@"https://example.com" parameters:nil success:nil failure:nil]);
}

-(void)testPostHttp {
    XCTAssertThrows([restClient POST:@"http://example.com" parameters:nil progress:nil success:nil failure:nil]);
}

-(void)testPostHttps {
    XCTAssertNoThrow([restClient POST:@"https://example.com" parameters:nil progress:nil success:nil failure:nil]);
}

-(void)testPutHttp {
    XCTAssertThrows([restClient PUT:@"http://example.com" parameters:nil success:nil failure:nil]);
}

-(void)testPutHttps {
    XCTAssertNoThrow([restClient PUT:@"https://example.com" parameters:nil success:nil failure:nil]);
}

-(void)testPatchHttp {
    XCTAssertThrows([restClient PATCH:@"http://example.com" parameters:nil success:nil failure:nil]);
}

-(void)testPatchHttps {
    
    XCTAssertNoThrow([restClient PATCH:@"https://example.com" parameters:nil success:nil failure:nil]);
}

-(void)testDeleteHttp {
    XCTAssertThrows([restClient DELETE:@"http://example.com" parameters:nil success:nil failure:nil]);
}

-(void)testDeleteHttps {
    XCTAssertNoThrow([restClient DELETE:@"https://example.com" parameters:nil success:nil failure:nil]);
}

-(void)testisValidUrl {
    XCTAssertFalse([restClient isValidUrl:@"http://test.com"]);
    XCTAssertTrue([restClient isValidUrl:@"https://test.com"]);
}

-(void)testManager {
    id<AIRESTClientProtocol> client = [restClient manager];
    XCTAssertNotNil(client);
    XCTAssertTrue([client isKindOfClass:[AIRESTClientInterface class]]);
}

- (void)testCreateInstanceWithUrl
{
    NSObject *obj = [restClient createInstanceWithBaseURL:[NSURL URLWithString:@"http://www.google.com"]];
    XCTAssertNotNil(obj);
    XCTAssertTrue([obj isKindOfClass:[AIRESTClientInterface class]]);
    
}
-(void)testCreateInstanceWithConfigAndUrl
{
    NSObject *obj = [restClient createInstanceWithBaseURL:[NSURL URLWithString:@"http://www.google.com"] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    XCTAssertNotNil(obj);
    XCTAssertTrue([obj isKindOfClass:[AIRESTClientInterface class]]);
    
}
-(void)testCreateInstanceWithConfig
{
    NSObject *obj = [restClient createInstanceWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    XCTAssertNotNil(obj);
    XCTAssertTrue([obj isKindOfClass:[AIRESTClientInterface class]]);
    
}
-(void)testCreateInstanceWithConfigAndCache
{
    NSObject *obj = [restClient createInstanceWithBaseURL:[NSURL URLWithString:@"http://www.google.com"] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] withCachePolicy:AIRESTURLRequestUseProtocolCachePolicy];
    XCTAssertNotNil(obj);
    XCTAssertTrue([obj isKindOfClass:[AIRESTClientInterface class]]);
    
}
-(void)testDownloadTaskWithRequestWithHttp
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]];
    XCTAssertThrows( [restClient downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return nil;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
    }],@"Should through exception");
    
}
-(void)testDownloadTaskWithRequest
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com"]];
    XCTAssertNoThrow( [restClient downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return nil;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
    }],@"Dont through exception");
    
}
-(void)testUploadTaskWithRequestFromFile
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com"]];
    XCTAssertNoThrow( [restClient uploadTaskWithRequest:request fromFile:[NSURL URLWithString:@"FilePath"] progress:^(NSProgress * _Nonnull uploadProgress) {
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
    }],@"Dont through exception");
}
-(void)testUploadTaskWithRequestFromFileWithHttp
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]];
    XCTAssertThrows( [restClient uploadTaskWithRequest:request fromFile:[NSURL URLWithString:@"FilePath"] progress:^(NSProgress * _Nonnull uploadProgress) {
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
    }],@"should through exception");
}
-(void)testUploadTaskWithRequestFromDataWithHttp
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]];
    XCTAssertThrows( [restClient uploadTaskWithRequest:request fromData:[NSData data] progress:^(NSProgress * _Nonnull uploadProgress) {
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
    }],@"should through exception");
}
-(void)testUploadTaskWithRequestFromData
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com"]];
    XCTAssertNoThrow( [restClient uploadTaskWithRequest:request fromData:[NSData data] progress:^(NSProgress * _Nonnull uploadProgress) {
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
    }],@"Dont through exception");
}
-(void)testUploadTaskWithStreamedRequest
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com"]];
    XCTAssertNoThrow( [restClient uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
    }],@"Dont through exception");
}
-(void)testUploadTaskWithStreamedRequestWithHttp
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]];
    XCTAssertThrows( [restClient uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
    }],@"should through exception");
}
-(void)testDataTaskWithRequestWithProgress
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com"]];
    XCTAssertNoThrow( [restClient dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
    }],@"Dont through exception");
}

-(void)testDataTaskWithRequestWithProgressWithHttpCall
{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]];
    XCTAssertThrows( [restClient dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSLog(@"%@",responseObject);
    }],@"should through exception");
}

-(void)testDataTaskWithRequest
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com"]];
    XCTAssertNoThrow( [restClient dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"%@",responseObject);
    }],@"Dont through exception");
}
-(void)testDataTaskWithRequestWithHttp
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]];
    XCTAssertThrows( [restClient dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
    }],@"should through exception");
}

-(void)testClearCacheResponse {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com"]];
    NSURLResponse *urlResponse = [[NSURLResponse alloc] initWithURL:[request URL] MIMEType:@"application/json" expectedContentLength:-1 textEncodingName:@"UTF-8"];
    NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:urlResponse data:[[NSData alloc] init]];
    [[NSURLCache sharedURLCache] storeCachedResponse:cachedResponse forRequest:request];
    XCTAssertNotNil([[NSURLCache sharedURLCache] cachedResponseForRequest:request]);
    XCTAssertNoThrow([restClient clearCacheResponse]);
    XCTAssertNil([[NSURLCache sharedURLCache] cachedResponseForRequest:request]);
}

-(void)testisAuthTypeSupported{
    XCTAssertFalse([restClient isAuthTypeSupported:-1]);
    XCTAssertFalse([restClient isAuthTypeSupported:0]);
    XCTAssertTrue ([restClient isAuthTypeSupported:AIRESTClientTokenTypeOAUTH2]);
    XCTAssertFalse([restClient isAuthTypeSupported:2]);
}

-(void)testAddAuthenticationData{
    restClient.delegate = self;
    [restClient addAuthenticationData];
    
    NSDictionary* headers = restClient.requestSerializer.HTTPRequestHeaders;
    XCTAssertNotNil(headers[@"Authorization"]);
    XCTAssertEqualObjects(headers[@"Authorization"], @"Bearer 123456");
}

-(void)testAddAuthenticationDataInvalidTokenValue{
    
    id mockDelegate = [OCMockObject niceMockForClass:[self class]];
    [[[mockDelegate stub] andReturn:nil] getTokenValue];
    
    
    restClient.delegate = mockDelegate;
    [restClient addAuthenticationData];
    
    NSDictionary* headers = restClient.requestSerializer.HTTPRequestHeaders;
    XCTAssertNil(headers[@"Authorization"]);
}

-(void)testAddAuthenticationDatamockTokenValue{
    
    id mockDelegate = [OCMockObject niceMockForClass:[self class]];
    [[[mockDelegate stub] andReturn:@"abcd"] getTokenValue];
    [[[mockDelegate stub] andReturnValue:[NSNumber numberWithUnsignedInteger:AIRESTClientTokenTypeOAUTH2]] getTokenType];
    
    restClient.delegate = mockDelegate;
    [restClient addAuthenticationData];
    
    NSDictionary* headers = restClient.requestSerializer.HTTPRequestHeaders;
    XCTAssertNotNil(headers[@"Authorization"]);
    XCTAssertEqualObjects(headers[@"Authorization"], @"Bearer abcd");
}
-(void)testAddAuthenticationDatamockOnlyTokenValue{
    
    id mockDelegate = [OCMockObject niceMockForClass:[self class]];
    [[[mockDelegate stub] andReturn:@"abcd"] getTokenValue];
    
    
    restClient.delegate = mockDelegate;
    [restClient addAuthenticationData];
    
    NSDictionary* headers = restClient.requestSerializer.HTTPRequestHeaders;
    XCTAssertNil(headers[@"Authorization"]);
    
}

-(void)testAddAuthenticationDatamockOnlyTokenType{
    
    id mockDelegate = [OCMockObject niceMockForClass:[self class]];
    [[[mockDelegate stub] andReturn:@"abcd"] getTokenValue];
    
    
    restClient.delegate = mockDelegate;
    [restClient addAuthenticationData];
    
    NSDictionary* headers = restClient.requestSerializer.HTTPRequestHeaders;
    XCTAssertNil(headers[@"Authorization"]);
    
}


-(AIRESTClientTokenType)getTokenType{
    NSLog(@"getting token type");
    return AIRESTClientTokenTypeOAUTH2;
}
-(NSString*)getTokenValue{
    
    return @"123456";
}
-(void)testAddAuthenticationDataWithoutDelegate{
    
    [restClient addAuthenticationData];
    NSDictionary* headers = restClient.requestSerializer.HTTPRequestHeaders;
    XCTAssertNil(headers[@"Authorization"]);
}

-(void)testWiFiNetworkReachability
{
    [self de_SwizzleAll];
    [self swizzleReachableViaWWAN_False];
    [self swizzleReachableViaWiFi];
    AIRESTClientReachabilityStatus status = [restClient getNetworkReachabilityStatus];
    XCTAssertEqual(status, AIRESTClientReachabilityStatusReachableViaWiFi);
}
-(void)testNetworkReachability
{
    [self de_SwizzleAll];
//    [self swizzleReachableViaWiFi];
    [self swizzleReachableViaWWAN];
    XCTAssertTrue([restClient isInternetReachable]);
}

-(void)testNetworkReachability_UnHappyFlow
{
    [self swizzleReachableViaWiFi_False];
    [self swizzleReachableViaWWAN_False];
    XCTAssertFalse([restClient isInternetReachable]);
}


-(void)teestWWANNetworkReachability
{
    //[self de_SwizzleAll];
    [self swizzleReachableViaWiFi_False];
    [self swizzleReachableViaWWAN];
    AIRESTClientReachabilityStatus status = [restClient getNetworkReachabilityStatus];
    XCTAssertEqual(status, AIRESTClientReachabilityStatusReachableViaWWAN);
}

-(void)swizzleIsReachable
{
    
    Method originalMethod = class_getInstanceMethod([RESTClientReachability class], @selector(currentReachabilityStatus));
    Method testMethod = class_getInstanceMethod([self class], @selector(isReachableTestMethod));
    method_exchangeImplementations(originalMethod, testMethod);
}
-(void)swizzleIsReachable_True
{
    
    Method originalMethod = class_getInstanceMethod([RESTClientReachability class], @selector(currentReachabilityStatus));
    Method testMethod = class_getInstanceMethod([self class], @selector(isReachableTestMethod_True));
    method_exchangeImplementations(originalMethod, testMethod);
}
-(void)swizzleReachableViaWWAN
{
    Method originalMethod = class_getInstanceMethod([RESTClientReachability class], @selector(currentReachabilityStatus));
    Method testMethod = class_getInstanceMethod([self class], @selector(isReachableViaWWANTestMethod));
    method_exchangeImplementations(originalMethod, testMethod);
}
-(void)swizzleReachableViaWiFi
{
    Method originalMethod = class_getInstanceMethod([RESTClientReachability class], @selector(currentReachabilityStatus));
    Method testMethod = class_getInstanceMethod([self class], @selector(isReachableViaWiFiTestMethod));
    method_exchangeImplementations(originalMethod, testMethod);
}
-(void)swizzleReachableViaWWAN_False
{
    Method originalMethod = class_getInstanceMethod([RESTClientReachability class], @selector(currentReachabilityStatus));
    Method testMethod = class_getInstanceMethod([self class], @selector(isReachableViaWWANTestMethod_False));
    method_exchangeImplementations(originalMethod, testMethod);
}
-(void)swizzleReachableViaWiFi_False
{
    Method originalMethod = class_getInstanceMethod([RESTClientReachability class], @selector(currentReachabilityStatus));
    Method testMethod = class_getInstanceMethod([self class], @selector(isReachableViaWiFiTestMethod_False));
    method_exchangeImplementations(originalMethod, testMethod);
}
-(void)de_SwizzleAll
{
    Method originalMethod1 = class_getInstanceMethod([RESTClientReachability class], @selector(currentReachabilityStatus));
    Method testMethod1 = class_getInstanceMethod([self class], @selector(isReachableTestMethod));
    method_exchangeImplementations(testMethod1,originalMethod1);
    
    Method originalMethod2 = class_getInstanceMethod([RESTClientReachability class], @selector(currentReachabilityStatus));
    Method testMethod2 = class_getInstanceMethod([self class], @selector(isReachableViaWWANTestMethod));
    method_exchangeImplementations(testMethod2,originalMethod2);
    
    Method originalMethod3 = class_getInstanceMethod([RESTClientReachability class], @selector(currentReachabilityStatus));
    Method testMethod3 = class_getInstanceMethod([self class], @selector(isReachableViaWiFiTestMethod_False));
    method_exchangeImplementations(testMethod3,originalMethod3);
}
-(void)deSwizzleWifi
{
    Method originalMethod3 = class_getInstanceMethod([RESTClientReachability class], @selector(currentReachabilityStatus));
    Method testMethod3 = class_getInstanceMethod([self class], @selector(isReachableViaWiFiTestMethod_False));
    method_exchangeImplementations(testMethod3,originalMethod3);
}
-(NetworkStatus)isReachableTestMethod
{
    return NotReachable;
}
-(BOOL)isReachableTestMethod_True
{
    return true;
}
-(NetworkStatus)isReachableViaWWANTestMethod
{
    return ReachableViaWWAN;
}
-(NetworkStatus)isReachableViaWiFiTestMethod
{
    return ReachableViaWiFi;
}
-(NetworkStatus)isReachableViaWWANTestMethod_False
{
    return NotReachable;
}
-(NetworkStatus)isReachableViaWiFiTestMethod_False
{
    return NotReachable;
}
-(void)tearDown {
    [super tearDown];
    restClient.delegate = nil;
    restClient = nil;
    [self de_SwizzleAll];
}


@end
