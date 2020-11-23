//
//  AIServiceDiscoveryTests.m
//  AppInfra
//
//  Created by Hashim MH on 05/08/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AIServiceDiscoveryProtocol.h"
#import "AIServiceDiscovery.h"
#import "NSBundle+Bundle.h"
#import <OCMock/OCMock.h>
#import "AISDService.h"
#import "AppInfra.h"
#import "AISDManager.h"
#import "AISDModel.h"
#import "AISDResults.h"
#import "AISDNetworkWrapper.h"
#import "AIInternalTaggingUtility.h"
#import "AIAppTagging.h"

typedef NS_ENUM(NSUInteger, AISDURLType)
{   AISDURLTypeProposition =1,
    AISDURLTypePlatform
};

@interface AAServiceDiscoveryTests : XCTestCase{
    
    AIServiceDiscovery * serviceDiscovery;
    AISDManager * manager;
}

@end

@interface AIInternalTaggingUtility()
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
+(void)tagError:(NSError *)error
errorCategory:(NSString *)errorCategory
errorMessage:(NSString *)errorMessage;
@end

@interface AISDModel()

-(NSString*)urlDecodeForServiceDiscovery:(NSString*)url;
-(AISDResults *)getCorrectResultsForLocaleList:(NSArray *)localeList results:(NSArray *)resultsArray;
-(BOOL)isPropostionEnabled;
@end

@interface AISDManager()

@property(nonatomic, strong)AISDNetworkWrapper *networkWrapper;
@property(nonatomic, strong)NSString *homeCountryCode;
-(NSString*)localeCorrectionForSDServer:(NSString*)localeString;
-(void)fetchServiceDicoveryWithcompletionHandler:(void (^)( AISDURLs*  SDURLs, NSError *  error))completionHandler;
-(void)cacheDownloadedURLs:(NSDictionary *)downloadedJson URLString:(NSString *)URLString URLType:(AISDURLType)URLType;
-(NSString *)getAppStateStringFromState:(AIAIAppState)state;
-(NSString *)getSDURLForType:(AISDURLType)URLType;
-(void)saveCountryCode:(NSString *)countryCode sourceType:(NSString *)sourceType;
-(NSString *)savedCountryCode ;

@end

@interface AIServiceDiscovery ()

@property(nonatomic, strong)AISDManager * sdManager;
@property(nonatomic, strong)NSString *homeCountryCode;

-(AISDResults*)serviceDataForPreferredLanguageWithResults:(NSArray*)arrResults;
-(NSString*)urlDecodeForServiceDiscovery:(NSString*)url;
-(BOOL)shouldRetryDownload;
@property(nonatomic,strong)NSDate *lastErrorTimeStamp;

@end

@implementation AAServiceDiscoveryTests

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
    
    if (!serviceDiscovery) {
        AIAppInfra * appInfra = [AAServiceDiscoveryTests sharedAppInfra];
        serviceDiscovery =  [[AIServiceDiscovery alloc]initWithAppInfra:appInfra];
        manager = [[AISDManager alloc]initWithAppInfra:appInfra];
    }
    
    NSString * path = [[NSBundle bundleForClass:self.class] pathForResource:@"SDURLs" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    [manager cacheDownloadedURLs:json URLString:[manager getSDURLForType:AISDURLTypeProposition] URLType:AISDURLTypeProposition];
    
    NSString * pathPlatform = [[NSBundle bundleForClass:self.class] pathForResource:@"SDURLsPlatform" ofType:@"json"];
    NSData * dataPlatform = [NSData dataWithContentsOfFile:pathPlatform];
    NSDictionary * jsonPlatform = [NSJSONSerialization JSONObjectWithData:dataPlatform options:0 error:nil];
    
    [manager cacheDownloadedURLs:jsonPlatform URLString:[manager getSDURLForType:AISDURLTypePlatform] URLType:AISDURLTypePlatform];
    
}

//-(void)testSDDownload {
//    
//    NSString * propositionpath = [[NSBundle bundleForClass:self.class] pathForResource:@"SDURLsPlatform" ofType:@"json"];
//    NSData * propositiondata = [NSData dataWithContentsOfFile:propositionpath];
//    NSDictionary * propositionJson = [NSJSONSerialization JSONObjectWithData:propositiondata options:0 error:nil];
//    
//    NSString * platformpath = [[NSBundle bundleForClass:self.class] pathForResource:@"SDURLs" ofType:@"json"];
//    NSData * platformdata = [NSData dataWithContentsOfFile:platformpath];
//    NSDictionary * platformJson = [NSJSONSerialization JSONObjectWithData:platformdata options:0 error:nil];
//    
//    NSString * propositionURL = [manager getSDURLForType:AISDURLTypeProposition];
//    NSString * platformURL = [manager getSDURLForType:AISDURLTypePlatform];
//    
//    id mock = OCMClassMock([AISDNetworkWrapper class]);
//    manager.networkWrapper = mock;
//    
//    [[[mock expect]andDo:^(NSInvocation *invocation) {
//        void (^successBlock)( NSDictionary*  responseObject, NSError *  error);
//        
//        [invocation getArgument:&successBlock atIndex:3];
//        successBlock(propositionJson, nil);
//    }] serviceDiscoveryDataWithURL:propositionURL completionHandler:OCMOCK_ANY];
//    
//    [[[mock expect]andDo:^(NSInvocation *invocation) {
//        void (^successBlock)( NSDictionary*  responseObject, NSError *  error);
//        
//        [invocation getArgument:&successBlock atIndex:3];
//        successBlock(platformJson, nil);
//    }] serviceDiscoveryDataWithURL:platformURL completionHandler:OCMOCK_ANY];
//    
//    [manager getServiceDiscoveryDataWithcompletionHandler:^(AISDURLs *SDURLs, NSError *error) {
//        XCTAssertNil(error);
//        XCTAssertNotNil(SDURLs);
//        NSLog(@"XXXX");
//    }];
//    
//    [mock verify];
//    
//    
//    [manager getServiceDiscoveryDataWithcompletionHandler:^(AISDURLs *SDURLs, NSError *error) {
//        XCTAssertNotNil(SDURLs);
//    }];
//    
//}

-(void)testSetInvalidHomeCountry
{
    XCTAssertThrows([serviceDiscovery setHomeCountry:@"test"]);
    XCTAssertThrows([serviceDiscovery setHomeCountry:@"in"]);
    XCTAssertNoThrow([serviceDiscovery setHomeCountry:@"IN"]);
    
}

// Commenting this as it was failing randomly

//-(void)testGetHomeCountry {
//    XCTestExpectation *expectation = [self expectationWithDescription:@"sd"];
//
//    [serviceDiscovery getHomeCountry:^(NSString *countryCode, NSString *sourceType, NSError *error) {
//
//        if (countryCode) {
//            XCTAssertNotNil(countryCode);
//            XCTAssertTrue(countryCode.length == 2);
//
//            BOOL isValidSource = ([sourceType isEqualToString:@"GEOIP"]||
//                                  [sourceType isEqualToString:@"PREF"]||
//                                  [sourceType isEqualToString:@"SIM"]);
//
//            XCTAssertTrue(isValidSource);
//
//        }
//        [expectation fulfill];
//
//    }];
//
//    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
//        if (error) {
//            NSLog(@"Timeout Error: %@", error);
//        }
//    }];
//}

-(void)testSetHomeCountry {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testSetHomeCountry"];
    
    [serviceDiscovery setHomeCountry:@"XX"];
    
    [serviceDiscovery getHomeCountry:^(NSString *countryCode, NSString *sourceType, NSError *error) {
        [expectation fulfill];
        XCTAssertNotNil(countryCode);
        XCTAssertTrue(countryCode.length == 2);
        XCTAssertEqualObjects(countryCode, @"XX");
        BOOL isValidSource = ([sourceType isEqualToString:@"PREF"]);
        XCTAssertTrue(isValidSource);
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        [serviceDiscovery setHomeCountry:@"IN"];
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

/*-(void)testhomeCountryCodeWithCompletion {
    XCTestExpectation *expectation = [self expectationWithDescription:@"homeCountryCodeWithCompletion"];
    [manager homeCountryCodeWithCompletion:^(NSString *countryCode, NSString *sourceType, NSError *error) {
        XCTAssertNil(error);
        XCTAssertEqualObjects(countryCode, @"US");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}*/

-(void)testapplyURLParameters {
    NSString * url = @"https://acc.philips.com/prx/product/%sector%/de_DE/%catalog%/products/%ctn%.assets";
    NSDictionary * map = @{@"sector":@"sec1",@"catalog":@"cat1",@"ctn":@"ctn1"};
    NSString * output = [serviceDiscovery applyURLParameters:url parameters:map];
    NSString * expect = @"https://acc.philips.com/prx/product/sec1/de_DE/cat1/products/ctn1.assets";
    XCTAssertEqualObjects(output, expect);
}

-(void)testapplyURLParametersWithNull {
    NSString * url = @"https://acc.philips.com/prx/product/%sector%/de_DE/%catalog%/products/%ctn%.assets";
    NSDictionary * map = @{@"sector":@"sec1",[NSNull null]:[NSNull null],@"ctn":[NSObject new]};
    NSString * output = [serviceDiscovery applyURLParameters:url parameters:map];
    NSString * expect = @"https://acc.philips.com/prx/product/sec1/de_DE/%catalog%/products/%ctn%.assets";
    XCTAssertEqualObjects(output, expect);
}

-(void)testURLCaching {
    AISDURLs * SDURLs = [manager getCachedData];
    XCTAssertNotNil(SDURLs.platformURLs);
    XCTAssertNotNil(SDURLs.propositionURLs);
}

-(void)testcachedURLsExpired {
    AIAppInfra * appInfra = [AIAppInfra buildAppInfraWithBlock:nil];
    AISDManager * sdManager = [[AISDManager alloc]initWithAppInfra:appInfra];
    XCTAssertFalse([sdManager isRefreshRequired]);
}

-(void)testgetAppState {
    AIAppInfra * appInfra = [AIAppInfra buildAppInfraWithBlock:nil];
    AISDManager * sdManager = [[AISDManager alloc]initWithAppInfra:appInfra];
    XCTAssertEqualObjects([sdManager getAppStateStringFromState:AIAIAppStateTEST], @"apps%2b%2benv%2btest");
    XCTAssertEqualObjects([sdManager getAppStateStringFromState:AIAIAppStateDEVELOPMENT], @"apps%2b%2benv%2bdev");
    XCTAssertEqualObjects([sdManager getAppStateStringFromState:AIAIAppStateSTAGING], @"apps%2b%2benv%2bstage");
    XCTAssertEqualObjects([sdManager getAppStateStringFromState:AIAIAppStateACCEPTANCE], @"apps%2b%2benv%2bacc");
    XCTAssertEqualObjects([sdManager getAppStateStringFromState:AIAIAppStatePRODUCTION], @"apps%2b%2benv%2bprod");
}

-(void)testShouldRetryServiceDiscoveryWithNoTime
{
    [serviceDiscovery setLastErrorTimeStamp:nil];
    BOOL result = [serviceDiscovery shouldRetryDownload];
    XCTAssertTrue(result);
}

-(void)testShouldRetryServiceDiscoveryWithCurrentTime
{
    [serviceDiscovery setLastErrorTimeStamp:[NSDate date]];
    BOOL result = [serviceDiscovery shouldRetryDownload];
    XCTAssertFalse(result);
}

-(void)testShouldRetryServiceDiscoveryWithPastTime
{
    [serviceDiscovery setLastErrorTimeStamp:[[NSDate date] dateByAddingTimeInterval:-11]];
    BOOL result = [serviceDiscovery shouldRetryDownload];
    XCTAssertTrue(result);
}

-(void)testgetActualResultsForLocaleList {
    NSString * path = [[NSBundle bundleForClass:self.class] pathForResource:@"SDURLs-Multiple-Results" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    AISDModel * model = [[AISDModel alloc]initWithDictionary:json[@"payload"] appInfra:[AAServiceDiscoveryTests sharedAppInfra]];
    AISDResults * results = [model getCorrectResultsForLocaleList:@[@"fr_FR", @"nl_BE"] results:model.matchByCountry.results];
    XCTAssertEqualObjects(results.locale, @"fr_BE");
    
    AISDResults * results1 = [model getCorrectResultsForLocaleList:@[@"nl_BE"] results:model.matchByCountry.results];
    XCTAssertEqualObjects(results1.locale, @"nl_BE");
    
    AISDResults * results2 = [model getCorrectResultsForLocaleList:@[@"fr_BE"] results:model.matchByCountry.results];
    XCTAssertEqualObjects(results2.locale, @"fr_BE");
    
    AISDResults * results3 = [model getCorrectResultsForLocaleList:@[@"en_IN", @"fr_BE"] results:model.matchByCountry.results];
    XCTAssertEqualObjects(results3.locale, @"fr_BE");
    
    AISDResults * results4 = [model getCorrectResultsForLocaleList:@[@"en_IN", @"fr_BE"] results:[NSArray new]];
    XCTAssertNil(results4);
    
    AISDResults * results5 = [model getCorrectResultsForLocaleList:@[@"en_IN", @"en_UK"] results:model.matchByCountry.results];
    XCTAssertEqualObjects(results5.locale, @"nl_BE");
    
}

#pragma mark Multiple configs

-(void)testGetServicesMultipleConfigs {
    NSString * path = [[NSBundle bundleForClass:self.class] pathForResource:@"SDURLs-Multiple-Configs" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    [manager clearDownloadedURLs];
    [manager cacheDownloadedURLs:json URLString:[manager getSDURLForType:AISDURLTypeProposition] URLType:AISDURLTypeProposition];
    
    NSString * pathPlatform = [[NSBundle bundleForClass:self.class] pathForResource:@"SDURLsPlatform" ofType:@"json"];
    NSData * dataPlatform = [NSData dataWithContentsOfFile:pathPlatform];
    NSDictionary * jsonPlatform = [NSJSONSerialization JSONObjectWithData:dataPlatform options:0 error:nil];
    
    [manager cacheDownloadedURLs:jsonPlatform URLString:[manager getSDURLForType:AISDURLTypePlatform] URLType:AISDURLTypePlatform];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGetServicesMultipleConfigs"];
    [serviceDiscovery getServicesWithLanguagePreference:@[@"appinfra.testing.config1", @"appinfra.testing.config2", @"appinfra.testing.config3", @"notfound"] withCompletionHandler:^(NSDictionary<NSString *,AISDService *> *services, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(services);
        AISDService * service1 = services[@"appinfra.testing.config1"];
        AISDService * service2 = services[@"appinfra.testing.config2"];
        AISDService * service3 = services[@"appinfra.testing.config3"];
        AISDService * service4 = services[@"notfound"];
        XCTAssertEqualObjects(service1.url, @"config11L");
        XCTAssertEqualObjects(service2.url, @"config21L");
        XCTAssertEqualObjects(service3.url, @"config32L");
        XCTAssertEqualObjects(service4.url, nil);
        XCTAssertNotNil(service4.error);
        [expectation fulfill];
    } replacement:nil];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}
#pragma mark SD proposition Disable config
-(void)testSDshouldDownloadPlatformandPropositionIfNoConfig{
    //[serviceDiscovery.sdManager clearDownloadedURLs];
    AIAppInfra * appInfra = [AIAppInfra buildAppInfraWithBlock:nil];
    //[serviceDiscovery setHomeCountry:@"IN"];

    AISDManager *lmanager = [[AISDManager alloc]initWithAppInfra:appInfra];
    
    id mockappConfig = [OCMockObject partialMockForObject:appInfra.appConfig];
    appInfra.appConfig = mockappConfig;
    NSError *error=  [NSError errorWithDomain:NSURLErrorDomain code:23 userInfo:nil];
    [[[mockappConfig expect] andReturn:nil] getPropertyForKey:@"servicediscovery.propositionEnabled" group:OCMOCK_ANY error:((NSError __autoreleasing **)[OCMArg setTo:error])];

    NSString * propositionpath = [[NSBundle bundleForClass:self.class] pathForResource:@"SDURLsPlatform" ofType:@"json"];
    NSData * propositiondata = [NSData dataWithContentsOfFile:propositionpath];
    NSDictionary * propositionJson = [NSJSONSerialization JSONObjectWithData:propositiondata options:0 error:nil];
    
    NSString * platformpath = [[NSBundle bundleForClass:self.class] pathForResource:@"SDURLs" ofType:@"json"];
    NSData * platformdata = [NSData dataWithContentsOfFile:platformpath];
    NSDictionary * platformJson = [NSJSONSerialization JSONObjectWithData:platformdata options:0 error:nil];
    
    NSString * propositionURL = [manager getSDURLForType:AISDURLTypeProposition];
    NSString * platformURL = [manager getSDURLForType:AISDURLTypePlatform];
    
    id mock = OCMClassMock([AISDNetworkWrapper class]);
    lmanager.networkWrapper = mock;
    
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)( NSDictionary*  responseObject, NSError *  error);
        
        [invocation getArgument:&successBlock atIndex:3];
        successBlock(propositionJson, nil);
    }] serviceDiscoveryDataWithURL:propositionURL completionHandler:OCMOCK_ANY];
    
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)( NSDictionary*  responseObject, NSError *  error);
        
        [invocation getArgument:&successBlock atIndex:3];
        successBlock(platformJson, nil);
    }] serviceDiscoveryDataWithURL:platformURL completionHandler:OCMOCK_ANY];
    
    [lmanager getServiceDiscoveryDataWithcompletionHandler:^(AISDURLs *SDURLs, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(SDURLs);
        XCTAssertNotNil(SDURLs.propositionURLs);
        XCTAssertNotNil(SDURLs.platformURLs);

    }];
    
    [mock verify];
    [mockappConfig stopMocking];
    [mock stopMocking];
    AIAppInfra * appInfra1 = [AIAppInfra buildAppInfraWithBlock:nil];
}

-(void)testSDshouldDownloadPlatformandPropositionIfConfigTrue{

    NSString * propositionpath = [[NSBundle bundleForClass:self.class] pathForResource:@"SDURLsPlatform" ofType:@"json"];
    NSData * propositiondata = [NSData dataWithContentsOfFile:propositionpath];
    NSDictionary * propositionJson = [NSJSONSerialization JSONObjectWithData:propositiondata options:0 error:nil];
    
    NSString * platformpath = [[NSBundle bundleForClass:self.class] pathForResource:@"SDURLs" ofType:@"json"];
    NSData * platformdata = [NSData dataWithContentsOfFile:platformpath];
    NSDictionary * platformJson = [NSJSONSerialization JSONObjectWithData:platformdata options:0 error:nil];
    
    NSString * propositionURL = [manager getSDURLForType:AISDURLTypeProposition];
    NSString * platformURL = [manager getSDURLForType:AISDURLTypePlatform];
  
    AISDManager *lmanager = manager;
    id mock = OCMClassMock([AISDNetworkWrapper class]);
    [(AISDManager*)lmanager setNetworkWrapper:mock];

    [[[mock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)( NSDictionary*  responseObject, NSError *  error);
        
        [invocation getArgument:&successBlock atIndex:3];
        successBlock(propositionJson, nil);
    }] serviceDiscoveryDataWithURL:propositionURL completionHandler:OCMOCK_ANY];
    
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)( NSDictionary*  responseObject, NSError *  error);
        
        [invocation getArgument:&successBlock atIndex:3];
        successBlock(platformJson, nil);
    }] serviceDiscoveryDataWithURL:platformURL completionHandler:OCMOCK_ANY];
    
    XCTestExpectation *expectation =
    [self expectationWithDescription:@"testSDshouldDownloadPlatformandPropositionIfConfigTrue"];
    
    [lmanager getServiceDiscoveryDataWithcompletionHandler:^(AISDURLs *SDURLs, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(SDURLs);
        XCTAssertNotNil(SDURLs.propositionURLs);
        XCTAssertNotNil(SDURLs.platformURLs);
        [mock verify];
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];


}
-(void)testSDshouldDownloadOnlyPlatformIfConfigFalse{
    [manager clearDownloadedURLs];

    NSString * platformpath = [[NSBundle bundleForClass:self.class] pathForResource:@"SDURLs" ofType:@"json"];
    NSData * platformdata = [NSData dataWithContentsOfFile:platformpath];
    NSDictionary * platformJson = [NSJSONSerialization JSONObjectWithData:platformdata options:0 error:nil];
    
    NSString * platformURL = [manager getSDURLForType:AISDURLTypePlatform];
    
    id lmanager = (AISDManager*)[OCMockObject partialMockForObject:manager];
    [[[lmanager stub]andReturnValue:OCMOCK_VALUE(NO)] isPropostionEnabled];
    //AISDManager *lmanager = manager;
    
    id mock = OCMClassMock([AISDNetworkWrapper class]);
    [(AISDManager*)lmanager setNetworkWrapper:mock];

    [[[mock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)( NSDictionary*  responseObject, NSError *  error);
        
        [invocation getArgument:&successBlock atIndex:3];
        successBlock(platformJson, nil);
    }] serviceDiscoveryDataWithURL:platformURL completionHandler:OCMOCK_ANY];
    
    XCTestExpectation *expectation =
    [self expectationWithDescription:@"testSDshouldDownloadOnlyPlatformIfConfigFalse"];
    [lmanager getServiceDiscoveryDataWithcompletionHandler:^(AISDURLs *SDURLs, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(SDURLs);
        XCTAssertNil(SDURLs.propositionURLs);
        XCTAssertNotNil(SDURLs.platformURLs);
        [expectation fulfill];
    }];
    
    [mock verify];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];

    
}

#pragma mark synchronous home country
-(void)testSynchronousHomeCountry {
    [((AIAppInfra *)[AAServiceDiscoveryTests sharedAppInfra]).storageProvider removeValueForKey:@"ail.Locale.CountryCode"];
    serviceDiscovery.sdManager.homeCountryCode = nil;
    XCTAssertNil([serviceDiscovery getHomeCountry]);
    [serviceDiscovery setHomeCountry:@"US"];
    XCTAssertEqualObjects([serviceDiscovery getHomeCountry], @"US");
}

#pragma mark set home country notification
-(void)testSetHomeCountryNotification {
    id observerMock = OCMObserverMock();
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock name:AILServiceDiscoveryHomeCountryChangedNotification object:nil];
    [[observerMock expect] notificationWithName:AILServiceDiscoveryHomeCountryChangedNotification object:[OCMArg any] userInfo:@{@"ail.servicediscovery.homeCountry":@"UK"}];
    [serviceDiscovery setHomeCountry:@"UK"];
    OCMVerifyAll(observerMock);
}

-(void)testSetHomeCountryWithMappings {
    [((AIAppInfra *)[AAServiceDiscoveryTests sharedAppInfra]).storageProvider removeValueForKey:@"ail.Locale.CountryCode"];
    serviceDiscovery.sdManager.homeCountryCode = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"testSetHomeCountry"];
    [serviceDiscovery setHomeCountry:@"MO"];
    XCTAssertEqualObjects([serviceDiscovery getHomeCountry], @"MO");

    [serviceDiscovery getHomeCountry:^(NSString *countryCode, NSString *sourceType, NSError *error) {
        [expectation fulfill];
        XCTAssertNotNil(countryCode);
        XCTAssertTrue(countryCode.length == 2);
        XCTAssertEqualObjects(countryCode, @"MO");
        BOOL isValidSource = ([sourceType isEqualToString:@"PREF"]);
        XCTAssertTrue(isValidSource);
        NSString * platformURL = [serviceDiscovery.sdManager getSDURLForType:AISDURLTypePlatform];
        BOOL isMapped = [platformURL containsString:@"country=HK"];
        XCTAssertTrue(isMapped);
        
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        [serviceDiscovery setHomeCountry:@"IN"];
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

-(void)testSetHomeCountryWithMappingsInConfig {
    
    AIAppInfra * appInfra = [AAServiceDiscoveryTests sharedAppInfra];
    NSDictionary *countryMaps = [appInfra.appConfig getPropertyForKey:@"servicediscovery.countryMapping"
                                                                group:@"appinfra" error:nil];
    if(!countryMaps || countryMaps.count == 0){
        return;
    }
    [((AIAppInfra *)[AAServiceDiscoveryTests sharedAppInfra]).storageProvider removeValueForKey:@"ail.Locale.CountryCode"];
    serviceDiscovery.sdManager.homeCountryCode = nil;
    
    NSString *aCountryTobeMapped = [countryMaps allKeys][0];
    NSString *mappedCountry = [countryMaps objectForKey:aCountryTobeMapped];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testSetHomeCountry"];
    [serviceDiscovery setHomeCountry:aCountryTobeMapped];
    [serviceDiscovery getHomeCountry:^(NSString *countryCode, NSString *sourceType, NSError *error) {
        [expectation fulfill];
        XCTAssertNotNil(countryCode);
        XCTAssertTrue(countryCode.length == 2);
        XCTAssertEqualObjects(countryCode, aCountryTobeMapped);
        BOOL isValidSource = ([sourceType isEqualToString:@"PREF"]);
        XCTAssertTrue(isValidSource);
        NSString * platformURL = [serviceDiscovery.sdManager getSDURLForType:AISDURLTypePlatform];
        NSString *countryPart = [NSString stringWithFormat:@"country=%@",mappedCountry];
        BOOL isMapped = [platformURL containsString:countryPart];
        XCTAssertTrue(isMapped);
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        [serviceDiscovery setHomeCountry:@"IN"];
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

-(void)testSetHomeCountryWithoutMappingsInConfig {
    
    [((AIAppInfra *)[AAServiceDiscoveryTests sharedAppInfra]).storageProvider removeValueForKey:@"ail.Locale.CountryCode"];
    serviceDiscovery.sdManager.homeCountryCode = nil;
    

    XCTestExpectation *expectation = [self expectationWithDescription:@"testSetHomeCountry"];
    [serviceDiscovery setHomeCountry:@"IN"];
    [serviceDiscovery getHomeCountry:^(NSString *countryCode, NSString *sourceType, NSError *error) {
        [expectation fulfill];
        XCTAssertNotNil(countryCode);
        XCTAssertTrue(countryCode.length == 2);
        XCTAssertEqualObjects(countryCode, @"IN");
        BOOL isValidSource = ([sourceType isEqualToString:@"PREF"]);
        XCTAssertTrue(isValidSource);
        NSString * platformURL = [serviceDiscovery.sdManager getSDURLForType:AISDURLTypePlatform];
        NSString *countryPart = [NSString stringWithFormat:@"country=IN"];
        BOOL isMapped = [platformURL containsString:countryPart];
        XCTAssertTrue(isMapped);
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        [serviceDiscovery setHomeCountry:@"IN"];
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

/*This is to test the end to end edge case of country mapping without sim
 *Bug #62032
 */
-(void)d_testSDshouldDownloadPlatformandPropositionIfConfigTrueWithMapping{
    [((AIAppInfra *)[AAServiceDiscoveryTests sharedAppInfra]).storageProvider removeValueForKey:@"ail.Locale.CountryCode"];
    serviceDiscovery.sdManager.homeCountryCode = nil;
    
    [serviceDiscovery.sdManager clearDownloadedURLs];

    NSArray *callExpectedOrder=@[@"proprositionWithoutCountry",@"proprositionWithCountry",@"platformWithCountry"];
    __block NSMutableArray *callActualOrder = [[NSMutableArray alloc]initWithCapacity:3];
    NSString * propositionpath = [[NSBundle bundleForClass:self.class] pathForResource:@"SDURLsPlatform" ofType:@"json"];
    NSData * propositiondata = [NSData dataWithContentsOfFile:propositionpath];
    NSMutableDictionary * propositionJson = [NSJSONSerialization JSONObjectWithData:propositiondata options:0 error:nil] ;
    
    NSMutableDictionary * propositionJsonLU = [[NSJSONSerialization JSONObjectWithData:propositiondata options:0 error:nil] mutableCopy];
    

    NSString * platformpath = [[NSBundle bundleForClass:self.class] pathForResource:@"SDURLs" ofType:@"json"];
    NSData * platformdata = [NSData dataWithContentsOfFile:platformpath];
    NSMutableDictionary * platformJson = [NSJSONSerialization JSONObjectWithData:platformdata options:0 error:nil];

    NSMutableDictionary *payload = [propositionJsonLU[@"payload"] mutableCopy];
    [payload setObject:@"LU" forKey:@"country"];
    [propositionJsonLU setObject:payload forKey:@"payload"];
    
    AISDManager *lmanager = manager;
    id mock = OCMClassMock([AISDNetworkWrapper class]);
    [(AISDManager*)lmanager setNetworkWrapper:mock];
    
    NSString * propositionURLLU = [lmanager getSDURLForType:AISDURLTypeProposition];
    NSString * propositionURL = [NSString stringWithFormat:@"%@&country=BE",propositionURLLU];
    NSString * platformURL = [lmanager getSDURLForType:AISDURLTypePlatform];
    
    platformURL = [NSString stringWithFormat:@"%@&country=BE",platformURL];
    

    
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)( NSDictionary*  responseObject, NSError *  error);
        [callActualOrder addObject:callExpectedOrder[0]];
        [invocation getArgument:&successBlock atIndex:3];
        successBlock(propositionJsonLU, nil);
    }] serviceDiscoveryDataWithURL:propositionURLLU completionHandler:OCMOCK_ANY];
    
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)( NSDictionary*  responseObject, NSError *  error);
        [callActualOrder addObject:callExpectedOrder[1]];
        [invocation getArgument:&successBlock atIndex:3];
        successBlock(propositionJson, nil);
    }] serviceDiscoveryDataWithURL:propositionURL completionHandler:OCMOCK_ANY];
    

    [[[mock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)( NSDictionary*  responseObject, NSError *  error);
        [callActualOrder addObject:callExpectedOrder[2]];
        [invocation getArgument:&successBlock atIndex:3];
        successBlock(platformJson, nil);
    }] serviceDiscoveryDataWithURL:platformURL completionHandler:OCMOCK_ANY];
    
    XCTestExpectation *expectation =
    [self expectationWithDescription:@"testSDshouldDownloadPlatformandPropositionIfConfigTrueWithMapping"];
    
    [lmanager getServiceDiscoveryDataWithcompletionHandler:^(AISDURLs *SDURLs, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(SDURLs);
        XCTAssertNotNil(SDURLs.propositionURLs);
        XCTAssertNotNil(SDURLs.platformURLs);
        XCTAssertEqual(callExpectedOrder[0], callActualOrder[0]);
        XCTAssertEqual(callExpectedOrder[1], callActualOrder[1]);
        XCTAssertEqual(callExpectedOrder[2], callActualOrder[2]);
        [mock verify];
        [expectation fulfill];
    }];
    
    
    
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        
        NSLog(@"h>%@", callActualOrder);
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
}

-(void)testServiceModel{
    NSString *url = @"http://testurl.com";
    NSString *locale = @"mi_IN";
    AISDService *service = [[AISDService alloc]initWithUrl:url andLocale:locale];
    XCTAssertTrue([[service description] containsString:url]);
    XCTAssertTrue([[service description] containsString:locale]);

}
-(void)testLocaleCorrection{
    XCTAssertEqualObjects([manager localeCorrectionForSDServer:@"es_MX"], @"es_MX");
    XCTAssertEqualObjects([manager localeCorrectionForSDServer:@"es_419"], @"es");
    XCTAssertEqualObjects([manager localeCorrectionForSDServer:@"es"], @"es");
}

- (void)tearDown {
    [super tearDown];
    [serviceDiscovery setLastErrorTimeStamp:nil];
//  [manager clearDownloadedURLs];
}

#pragma mark - Tagging tests

-(void)testSDshouldTagWhenSetHomeCountry{
    
    NSString * propositionpath = [[NSBundle bundleForClass:self.class] pathForResource:@"SDURLsPlatform" ofType:@"json"];
    NSData * propositiondata = [NSData dataWithContentsOfFile:propositionpath];
    NSDictionary * propositionJson = [NSJSONSerialization JSONObjectWithData:propositiondata options:0 error:nil];
    
    NSString * platformpath = [[NSBundle bundleForClass:self.class] pathForResource:@"SDURLs" ofType:@"json"];
    NSData * platformdata = [NSData dataWithContentsOfFile:platformpath];
    NSDictionary * platformJson = [NSJSONSerialization JSONObjectWithData:platformdata options:0 error:nil];
    
    NSString * propositionURL = [manager getSDURLForType:AISDURLTypeProposition];
    NSString * platformURL = [manager getSDURLForType:AISDURLTypePlatform];
    
    AISDManager *lmanager = manager;
    
    id mock = OCMClassMock([AISDNetworkWrapper class]);
    [(AISDManager*)lmanager setNetworkWrapper:mock];
    
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)( NSDictionary*  responseObject, NSError *  error);
        
        [invocation getArgument:&successBlock atIndex:3];
        successBlock(propositionJson, nil);
    }] serviceDiscoveryDataWithURL:propositionURL completionHandler:OCMOCK_ANY];
    
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)( NSDictionary*  responseObject, NSError *  error);
        
        [invocation getArgument:&successBlock atIndex:3];
        successBlock(platformJson, nil);
    }] serviceDiscoveryDataWithURL:platformURL completionHandler:OCMOCK_ANY];
    
    XCTestExpectation *expectation =
    [self expectationWithDescription:@"testSDshouldTagSetHomeCountryTags"];
    NSString *currentCountry = [((AIAppInfra*)[AAServiceDiscoveryTests sharedAppInfra]).serviceDiscovery getHomeCountry];
    NSString *country = [currentCountry isEqualToString:@"XX"]?@"LL":@"XX";

    [lmanager getServiceDiscoveryDataWithcompletionHandler:^(AISDURLs *SDURLs, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(SDURLs);
        XCTAssertNotNil(SDURLs.propositionURLs);
        XCTAssertNotNil(SDURLs.platformURLs);
        [((AIAppInfra*)[AAServiceDiscoveryTests sharedAppInfra]).serviceDiscovery setHomeCountry:country];
        [mock verify];
        [expectation fulfill];
      
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

-(void)testSDshouldTagDownloadSDPropositionData{
    NSString * platformpath = [[NSBundle bundleForClass:self.class] pathForResource:@"SDURLs" ofType:@"json"];
    NSData * platformdata = [NSData dataWithContentsOfFile:platformpath];
    NSDictionary * platformJson = [NSJSONSerialization JSONObjectWithData:platformdata options:0 error:nil];
    NSString * platformURL = [manager getSDURLForType:AISDURLTypePlatform];
    
    
    id lmanager = (AISDManager*)[OCMockObject partialMockForObject:manager];
    [[[lmanager stub]andReturnValue:OCMOCK_VALUE(NO)] isPropostionEnabled];
    id mock = OCMClassMock([AISDNetworkWrapper class]);
    [(AISDManager*)lmanager setNetworkWrapper:mock];
    
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)( NSDictionary*  responseObject, NSError *  error);
        
        [invocation getArgument:&successBlock atIndex:3];
        successBlock(platformJson, nil);
    }] serviceDiscoveryDataWithURL:OCMOCK_ANY completionHandler:OCMOCK_ANY];
    
    XCTestExpectation *expectation =
    [self expectationWithDescription:@"testSDshouldTagDownloadPlatformandPropositionIfConfigTrue"];
    
    [lmanager getServiceDiscoveryDataWithcompletionHandler:^(AISDURLs *SDURLs, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(SDURLs);
        XCTAssertNil(SDURLs.propositionURLs);
        XCTAssertNotNil(SDURLs.platformURLs);
        [((AIAppInfra*)[AAServiceDiscoveryTests sharedAppInfra]).serviceDiscovery setHomeCountry:@"XX"];
        [mock verify];
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

-(void)testSDshouldTagDownloadSDPropositionPlatformData{
    NSString * platformpath = [[NSBundle bundleForClass:self.class] pathForResource:@"SDURLs" ofType:@"json"];
    NSData * platformdata = [NSData dataWithContentsOfFile:platformpath];
    NSDictionary * platformJson = [NSJSONSerialization JSONObjectWithData:platformdata options:0 error:nil];
   
    NSString * propositionURL = [manager getSDURLForType:AISDURLTypeProposition];
    NSString * platformURL = [manager getSDURLForType:AISDURLTypePlatform];
    
    
    id lmanager = (AISDManager*)[OCMockObject partialMockForObject:manager];
    id mock = OCMClassMock([AISDNetworkWrapper class]);
    [(AISDManager*)lmanager setNetworkWrapper:mock];
    
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)( NSDictionary*  responseObject, NSError *  error);
        
        [invocation getArgument:&successBlock atIndex:3];
        successBlock(platformJson, nil);
    }] serviceDiscoveryDataWithURL:OCMOCK_ANY completionHandler:OCMOCK_ANY];
    
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)( NSDictionary*  responseObject, NSError *  error);
        
        [invocation getArgument:&successBlock atIndex:3];
        successBlock(platformJson, nil);
    }] serviceDiscoveryDataWithURL:OCMOCK_ANY completionHandler:OCMOCK_ANY];
    
    
    XCTestExpectation *expectation =
    [self expectationWithDescription:@"testSDshouldTagDownloadPlatformandPropositionIfConfigTrue"];
    
    [lmanager getServiceDiscoveryDataWithcompletionHandler:^(AISDURLs *SDURLs, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(SDURLs);
        XCTAssertNotNil(SDURLs.propositionURLs);
        XCTAssertNotNil(SDURLs.platformURLs);
        [((AIAppInfra*)[AAServiceDiscoveryTests sharedAppInfra]).serviceDiscovery setHomeCountry:@"XX"];
        [mock verify];
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testTagRefreshFailed {
    AIServiceDiscovery *sd  = [[AIServiceDiscovery alloc] initWithAppInfra: [AAServiceDiscoveryTests sharedAppInfra]];
    id tagMock = OCMClassMock([AIAppTagging class]);
    [[tagMock expect] trackErrorAction:AITaggingTechnicalError taggingError:OCMOCK_ANY];
    [[AAServiceDiscoveryTests sharedAppInfra] setTagging:tagMock];
    
    id sdMock = (AIServiceDiscovery*)[OCMockObject partialMockForObject:sd];
    [[[sdMock expect] andDo:^(NSInvocation *invocation) {
        void (^completion)(AISDURLs*  SDURLs, NSError *  error);
        NSError * error = [[NSError alloc]initWithDomain:@"sd.test" code:111 userInfo:[NSDictionary dictionaryWithObject:@"test error" forKey:NSLocalizedDescriptionKey]];
        [invocation getArgument:&completion atIndex:2];
        completion(nil,error);
    }] fetchServiceDicoveryWithcompletionHandler:OCMOCK_ANY];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testTagRefreshFailed"];
    
    [sdMock refresh:^(NSError *error) {
        [tagMock verify];
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testTagRefreshFailedNoInternet {
    AIServiceDiscovery *sd  = [[AIServiceDiscovery alloc] initWithAppInfra: [AAServiceDiscoveryTests sharedAppInfra]];
    id tagMock = OCMClassMock([AIAppTagging class]);
    [[tagMock expect] trackErrorAction:AITaggingInformationalError taggingError:OCMOCK_ANY];
    [[AAServiceDiscoveryTests sharedAppInfra] setTagging:tagMock];
    
    id sdMock = (AIServiceDiscovery*)[OCMockObject partialMockForObject:sd];
    [[[sdMock expect] andDo:^(NSInvocation *invocation) {
        void (^completion)(AISDURLs*  SDURLs, NSError *  error);
        NSError * error = [[NSError alloc]initWithDomain:@"sd.test" code:NSURLErrorNetworkConnectionLost userInfo:[NSDictionary dictionaryWithObject:@"test error" forKey:NSLocalizedDescriptionKey]];
        [invocation getArgument:&completion atIndex:2];
        completion(nil,error);
    }] fetchServiceDicoveryWithcompletionHandler:OCMOCK_ANY];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testTagRefreshFailed"];
    
    [sdMock refresh:^(NSError *error) {
        [tagMock verify];
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

-(void)testTagGetHomecountryFailed{
    AIServiceDiscovery *sd  = [[AIServiceDiscovery alloc]initWithAppInfra:[AAServiceDiscoveryTests sharedAppInfra]];
    
    id tagMock = OCMClassMock([AIAppTagging class]);
    [[tagMock expect] trackErrorAction:AITaggingTechnicalError taggingError:OCMOCK_ANY];
    [[AAServiceDiscoveryTests sharedAppInfra] setTagging:tagMock];
        
     AISDManager* sdmanager = [[AISDManager alloc]initWithAppInfra:[AAServiceDiscoveryTests sharedAppInfra]];
     id lmanager = (AISDManager*)[OCMockObject partialMockForObject:sdmanager];
     sd.sdManager = lmanager;
    
    [[[lmanager  expect]andDo:^(NSInvocation *invocation) {
        void (^completion)(NSString *homeCountryCode, NSString *sourceType, NSError *error);
         NSError * error = [[NSError alloc]initWithDomain:@"sd.test" code:112 userInfo:[NSDictionary dictionaryWithObject:@"test home country error" forKey:NSLocalizedDescriptionKey]];
        [invocation getArgument:&completion atIndex:2];
        completion(nil,nil,error);
    }] homeCountryCodeWithCompletion:OCMOCK_ANY];
    
    XCTestExpectation *expectation =
    [self expectationWithDescription:@"testTagGetHomecountryFailed"];
    [sd getHomeCountry:^(NSString *countryCode, NSString *sourceType, NSError *error){
        [tagMock verify];
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

-(void)testTagSaveCountryFailed{
    
    AIAppInfra* ai = [AIAppInfra buildAppInfraWithBlock:nil];
    id ssMock =[OCMockObject partialMockForObject:ai.storageProvider];
    ai.storageProvider = ssMock;
    
    NSError *error=  [NSError errorWithDomain:NSURLErrorDomain code:23 userInfo:nil];
    [[[ssMock expect]andReturnValue:@(NO)] storeValueForKey:@"ail.Locale.CountryCode" value:@"XY" error:((NSError __autoreleasing **)[OCMArg setTo:error])];
        
    id tagMock = OCMClassMock([AIAppTagging class]);
    [[tagMock expect] trackErrorAction:AITaggingTechnicalError taggingError:OCMOCK_ANY];
    [ai setTagging:tagMock];
    
    AISDManager* lmanager = [[AISDManager alloc]initWithAppInfra:ai];
    [lmanager saveCountryCode:@"XY" sourceType:@"GEOIP"];
    [tagMock verify];
    [ssMock stopMocking];
}
#pragma clang diagnostic pop
@end
