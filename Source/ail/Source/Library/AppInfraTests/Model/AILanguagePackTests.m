//
//  AILanguagePackTests.m
//  AppInfra
//
//  Created by Hashim MH on 13/03/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppInfra.h"
#import "AILanguagePack.h"
#import "NSBundle+Bundle.h"
#import <OCMock/OCMock.h>
#import "AIAppConfiguration.h"
#import "AIRESTClientInterface.h"
#import "AIUtility.h"
#import "AIRESTClientProtocol.h"
#define testServiceId @"appinfra.languagepack"

@interface AILanguagePackTests : XCTestCase {
    //id<AILanguagePackProtocol> languagePack;
    AILanguagePack  *languagePack;
    AIAppInfra * appInfra;
}
@end

@interface AILanguagePack (){
}

-(NSDictionary *)getPreferredLanguagePackInfo;
-(BOOL)shouldUpdateCurrentLanguagePack;
//-(NSArray*)getPreferredLocales;
-(NSString*)getPreferredLocales;
@property(nonatomic,weak) id<AIRESTClientProtocol> RESTClient;
@end


@implementation AILanguagePackTests
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
    appInfra = [AIAppInfra buildAppInfraWithBlock:nil];
    languagePack = [[AILanguagePack alloc]initWithAppInfra:appInfra];
}

- (void)testRefresh{
    
    [self removeFileAtPath:[self downloadedJasonFilePath]];
    [self removeFileAtPath:[self activatedJasonFilePath]];
    [self removeFileAtPath:[self metedataFilePath]];
    NSString *testOverviewUrl = @"https://hashim-rest.herokuapp.com/sd/tst/en_IN/appinfra/lp.json";
    id mockSD = [OCMockObject partialMockForObject:appInfra.serviceDiscovery];
    appInfra.serviceDiscovery = mockSD;
    
    
    //mock SD
    [[[mockSD expect]andDo:^(NSInvocation *invocation) {
        void (^completionHandler)(NSDictionary<NSString*,AISDService*> *services,NSError *error);
        AISDService *service = [[AISDService alloc]initWithUrl:testOverviewUrl andLocale:@"en_GB"];
        NSDictionary *servicesDictionary = @{@"appinfra.languagepack": service};
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(servicesDictionary, nil);
    }]getServicesWithCountryPreference:OCMOCK_ANY withCompletionHandler:OCMOCK_ANY replacement:nil];
    
    //mock REST
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    id lpMock = [OCMockObject partialMockForObject:lp];
    [[[lpMock expect] andReturnValue:OCMOCK_VALUE(YES)] shouldUpdateCurrentLanguagePack];
    

    id restMock =[OCMockObject partialMockForObject:lp.RESTClient];
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        NSDictionary * json = @{
                                @"languages": @[
                                        @{
                                            @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en.json",
                                            @"locale": @"en",
                                            @"remoteVersion": @"1"
                                            }                                        ]
                                };

        [invocation getArgument:&successBlock atIndex:5];
        successBlock(nil, json);
    }] GET:testOverviewUrl parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        NSDictionary * json = @{ @"locale":@"en",
                                 @"testKey":@"testDownload"
                                 };
        successBlock(nil, json);
    }] GET:@"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en.json"parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];

    
    
    XCTestExpectation *expectation =[self expectationWithDescription:@"LanguagePack"];
    [lpMock refresh:^(AILPRefreshStatus refreshResult, NSError * _Nullable error) {
        //[mockappConfig verify];
        [mockSD verify];
        [restMock verify];
        [expectation fulfill];
        XCTAssertEqual(refreshResult, AILPRefreshStatusRefreshedFromServer);
        XCTAssertTrue([[lp description] isKindOfClass:[NSString class]]);
        
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}
- (void)testRefreshIfAlreadyRefreshed{
    
    
    NSString *testOverviewUrl = @"https://hashim-rest.herokuapp.com/sd/tst/en_IN/appinfra/lp.json";
    id mockSD = [OCMockObject partialMockForObject:appInfra.serviceDiscovery];
    appInfra.serviceDiscovery = mockSD;
    
    
    //mock SD
    [[[mockSD expect]andDo:^(NSInvocation *invocation) {
        void (^completionHandler)(NSDictionary<NSString*,AISDService*> *services,NSError *error);
        AISDService *service = [[AISDService alloc]initWithUrl:testOverviewUrl andLocale:@"en_GB"];
        NSDictionary *servicesDictionary = @{@"appinfra.languagepack": service};
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(servicesDictionary, nil);
    }]getServicesWithCountryPreference:OCMOCK_ANY withCompletionHandler:OCMOCK_ANY replacement:nil];
    
    
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    id lpMock = [OCMockObject partialMockForObject:lp];
    [[[lpMock expect] andReturnValue:OCMOCK_VALUE(NO)] shouldUpdateCurrentLanguagePack];
    

    //mock REST
    NSString * configPath = [[NSBundle bundleForClass:self.class] pathForResource:@"lpOverview" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:configPath];
    NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    id restMock =[OCMockObject partialMockForObject:lp.RESTClient];
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        successBlock(nil, json);
    }] GET:testOverviewUrl parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    XCTestExpectation *expectation =[self expectationWithDescription:@"LanguagePack"];
    [lpMock refresh:^(AILPRefreshStatus refreshResult, NSError * _Nullable error) {
        //[mockappConfig verify];
        [mockSD verify];
        [restMock verify];
        [expectation fulfill];
        XCTAssertEqual(refreshResult, AILPRefreshStatusNoRefreshRequired);
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}


- (void)d_testRefreshShouldNotRefreshIfAlreadyRefreshed{
    NSString *testOverviewUrl = @"https://hashim-rest.herokuapp.com/sd/tst/en_IN/appinfra/lp.json";
    id mockappConfig = [OCMockObject partialMockForObject:appInfra.appConfig];
    id mockSD = [OCMockObject partialMockForObject:appInfra.serviceDiscovery];
    appInfra.appConfig = mockappConfig;
    appInfra.serviceDiscovery = mockSD;
    //mock app config
    [[[mockappConfig expect] andReturn:testServiceId] getPropertyForKey:@"languagePack.serviceId" group:OCMOCK_ANY error:[OCMArg anyObjectRef]];
    
    //mock SD
    [[[mockSD expect]andDo:^(NSInvocation *invocation) {
        void (^completionHandler)(NSDictionary<NSString*,AISDService*> *services,NSError *error);
        AISDService *service = [[AISDService alloc]initWithUrl:testOverviewUrl andLocale:@"en_GB"];
        NSDictionary *servicesDictionary = @{@"appinfra.languagepack": service};
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(servicesDictionary, nil);
    }]getServicesWithCountryPreference:OCMOCK_ANY withCompletionHandler:OCMOCK_ANY replacement:nil];
    
    //mock REST
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    id restMock =[OCMockObject partialMockForObject:lp.RESTClient];
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        [invocation getArgument:&successBlock atIndex:5];
        NSDictionary *json = @{@"locale" : @"en_GB",
                 @"remoteVersion" : @"1",
                 @"url" : @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_US.json",
                 };
        json = @{
                 @"languages": @[
                         @{
                             @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_US.json",
                             @"locale": @"en_US",
                             @"remoteVersion": @"1"
                             }                                        ]
                 };

        successBlock(nil, json);
    }] GET:testOverviewUrl parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        NSDictionary * json = @{
                                @"locale":@"en_US",
                                @"testKey":@"testDownload"
                                 };
        successBlock(nil, json);
    }] GET:@"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_US.json"parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];

    
    [self removeFileAtPath:[self metedataFilePath]];
    XCTestExpectation *expectation =[self expectationWithDescription:@"LanguagePack"];
    [lp refresh:^(AILPRefreshStatus refreshResult, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
        XCTestExpectation *expectation =[self expectationWithDescription:@"LanguagePackRefresh"];
        [lp refresh:^(AILPRefreshStatus refreshResult, NSError * _Nullable error) {
            [mockappConfig verify];
            [mockSD verify];
            [restMock verify];
            XCTAssertEqual(refreshResult, AILPRefreshStatusNoRefreshRequired);
            [expectation fulfill];

        }];

        
        [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
            if (error) {
                NSLog(@"Timeout Error: %@", error);
            }
        }];

    }];
    
    
    
}

- (void)testRefreshShouldGetServiceIdFromAppConfig{
    id mockappConfig = [OCMockObject partialMockForObject:appInfra.appConfig];
    appInfra.appConfig = mockappConfig;
    //mock app config
    [[[mockappConfig expect] andReturn:testServiceId] getPropertyForKey:@"languagePack.serviceId" group:OCMOCK_ANY error:[OCMArg anyObjectRef]];    
    
    NSString *testOverviewUrl = @"https://hashim-rest.herokuapp.com/sd/tst/en_IN/appinfra/lp.json";
    id mockSD = [OCMockObject partialMockForObject:appInfra.serviceDiscovery];
    appInfra.serviceDiscovery = mockSD;
    
    
    //mock SD
    [[[mockSD expect]andDo:^(NSInvocation *invocation) {
        void (^completionHandler)(NSDictionary<NSString*,AISDService*> *services,NSError *error);
        AISDService *service = [[AISDService alloc]initWithUrl:testOverviewUrl andLocale:@"en_GB"];
        NSDictionary *servicesDictionary = @{@"appinfra.languagepack": service};
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(servicesDictionary, nil);
    }]getServicesWithCountryPreference:@[testServiceId] withCompletionHandler:OCMOCK_ANY replacement:nil];
    
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    id lpMock = [OCMockObject partialMockForObject:lp];
    [[[lpMock expect] andReturnValue:OCMOCK_VALUE(NO)] shouldUpdateCurrentLanguagePack];
    
    
    //mock REST
    NSString * configPath = [[NSBundle bundleForClass:self.class] pathForResource:@"lpOverview" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:configPath];
    NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    id restMock =[OCMockObject partialMockForObject:lp.RESTClient];
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        successBlock(nil, json);
    }] GET:testOverviewUrl parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    XCTestExpectation *expectation =[self expectationWithDescription:@"LanguagePack"];
    [lpMock refresh:^(AILPRefreshStatus refreshResult, NSError * _Nullable error) {
        [mockappConfig verify];
        [mockSD verify];
        [restMock verify];
        [expectation fulfill];
        XCTAssertEqual(refreshResult, AILPRefreshStatusNoRefreshRequired);
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];

    
}

- (void)testRefreshShouldNotAssertfornilServiceid{
    id mockappConfig = [OCMockObject partialMockForObject:appInfra.appConfig];
    appInfra.appConfig = mockappConfig;
    //mock app config
    [[[mockappConfig expect] andReturn:nil] getPropertyForKey:@"languagePack.serviceId" group:OCMOCK_ANY error:[OCMArg anyObjectRef]];
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    XCTAssertNoThrow([lp refresh:nil]);
}

- (void)testRefreshShouldAssertforNonStringServiceid{
    id mockappConfig = [OCMockObject partialMockForObject:appInfra.appConfig];
    appInfra.appConfig = mockappConfig;
    //mock app config
    [[[mockappConfig expect] andReturn:@5] getPropertyForKey:@"languagePack.serviceId" group:OCMOCK_ANY error:[OCMArg anyObjectRef]];
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    XCTAssertThrows([lp refresh:nil]);
}

- (void)testRefreshAppConfigError {
    id mockappConfig = [OCMockObject partialMockForObject:appInfra.appConfig];
    appInfra.appConfig = mockappConfig;
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    
    NSError *error=  [NSError errorWithDomain:NSURLErrorDomain code:23 userInfo:nil];
    [[[mockappConfig expect] andReturn:@"asd"] getPropertyForKey:@"languagePack.serviceId" group:OCMOCK_ANY error:((NSError __autoreleasing **)[OCMArg setTo:error])];
    
    XCTestExpectation *expectation =[self expectationWithDescription:@"LanguagePack"];
    [lp refresh:^(AILPRefreshStatus refreshResult, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertEqual(refreshResult, AILPRefreshStatusRefreshFailed);
        XCTAssertEqual(error.code, 23);
        [mockappConfig verify];
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testRefreshSDError {
    
    id mockappConfig = [OCMockObject partialMockForObject:appInfra.appConfig];
    id mockSD = [OCMockObject partialMockForObject:appInfra.serviceDiscovery];
    appInfra.appConfig = mockappConfig;
    appInfra.serviceDiscovery = mockSD;
    //mock app config
    [[[mockappConfig expect] andReturn:testServiceId] getPropertyForKey:@"languagePack.serviceId" group:OCMOCK_ANY error:[OCMArg anyObjectRef]];
    
    //mock SD
    [[[mockSD expect]andDo:^(NSInvocation *invocation) {
        void (^completionHandler)(NSDictionary<NSString*,AISDService*> *services,NSError *error);
        [invocation getArgument:&completionHandler atIndex:3];
        NSError *error=  [NSError errorWithDomain:NSURLErrorDomain code:23 userInfo:nil];
        completionHandler(nil, error);
    }]getServicesWithCountryPreference:@[testServiceId] withCompletionHandler:OCMOCK_ANY replacement:nil];
    
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    
    XCTestExpectation *expectation =[self expectationWithDescription:@"LanguagePack"];
    [lp refresh:^(AILPRefreshStatus refreshResult, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertEqual(refreshResult, AILPRefreshStatusRefreshFailed);
        XCTAssertEqual(error.code, 23);
        [mockappConfig verify];
        [mockSD verify];
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
}
// Crashing.. must be fixed

//- (void)testRefreshSDErrorEmptyurl {
//
//
//    id mockappConfig = [OCMockObject partialMockForObject:appInfra.appConfig];
//    id mockSD = [OCMockObject partialMockForObject:appInfra.serviceDiscovery];
//    appInfra.appConfig = mockappConfig;
//    appInfra.serviceDiscovery = mockSD;
//    //mock app config
//    [[[mockappConfig expect] andReturn:testServiceId] getPropertyForKey:@"languagePack.serviceId" group:OCMOCK_ANY error:[OCMArg anyObjectRef]];
//
//    //mock SD
//    [[[mockSD expect]andDo:^(NSInvocation *invocation) {
//        void (^completionHandler)(NSString *serviceURL, NSError *serviceURLError);
//        [invocation getArgument:&completionHandler atIndex:3];
//        completionHandler(@"", nil);
//    }]getServiceUrlWithCountryPreference:testServiceId withCompletionHandler:OCMOCK_ANY];
//
//
//    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
//
//    XCTestExpectation *expectation =[self expectationWithDescription:@"LanguagePack"];
//    [lp refresh:^(AILPRefreshStatus refreshResult, NSError * _Nullable error) {
//        XCTAssertNotNil(error);
//        XCTAssertEqual(refreshResult, AILPRefreshStatusRefreshFailed);
//        XCTAssertEqual(error.code, -1002);//unsupportrd url
//        [mockappConfig verify];
//        [mockSD verify];
//        [expectation fulfill];
//    }];
//
//    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
//        if (error) {
//            NSLog(@"Timeout Error: %@", error);
//        }
//    }];
//
//}

- (void)testRefreshRESTError {
    NSString *testOverviewUrl = @"https://hashim-rest.herokuapp.com/sd/tst/en_IN/appinfra/lp.json";
    id mockappConfig = [OCMockObject partialMockForObject:appInfra.appConfig];
    id mockSD = [OCMockObject partialMockForObject:appInfra.serviceDiscovery];
    appInfra.appConfig = mockappConfig;
    appInfra.serviceDiscovery = mockSD;
    //mock app config
    [[[mockappConfig expect] andReturn:testServiceId] getPropertyForKey:@"languagePack.serviceId" group:OCMOCK_ANY error:[OCMArg anyObjectRef]];
    
    //mock SD
    [[[mockSD expect]andDo:^(NSInvocation *invocation) {
        void (^completionHandler)(NSDictionary<NSString*,AISDService*> *services,NSError *error);
        AISDService *service = [[AISDService alloc]initWithUrl:testOverviewUrl andLocale:@"en_IN"];
        NSDictionary *servicesDictionary = @{@"appinfra.languagepack": service};
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(servicesDictionary, nil);    }]getServicesWithCountryPreference:@[testServiceId] withCompletionHandler:OCMOCK_ANY replacement:nil];
    //mock REST
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    id restMock =[OCMockObject partialMockForObject:lp.RESTClient];
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^errorBlock)(NSURLSessionDataTask * task, NSError* error);
        NSError *error=  [NSError errorWithDomain:NSURLErrorDomain code:23 userInfo:nil];
        [invocation getArgument:&errorBlock atIndex:6];
        errorBlock(nil, error);
    }] GET:testOverviewUrl parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    
    
    XCTestExpectation *expectation =[self expectationWithDescription:@"LanguagePack"];
    [lp refresh:^(AILPRefreshStatus refreshResult, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertEqual(refreshResult, AILPRefreshStatusRefreshFailed);
        XCTAssertEqual(error.code, 23);
        [mockappConfig verify];
        [mockSD verify];
        [restMock verify];
        [expectation fulfill];
        XCTAssertEqual(refreshResult, AILPRefreshStatusRefreshFailed);
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidateOverviewData{
    NSString *appLocalisations=@"en";
    NSString *testOverviewUrl = @"https://hashim-rest.herokuapp.com/sd/tst/en_IN/appinfra/lp.json";
    //id mockappConfig = [OCMockObject partialMockForObject:appInfra.appConfig];
    id mockSD = [OCMockObject partialMockForObject:appInfra.serviceDiscovery];
    //appInfra.appConfig = mockappConfig;
    appInfra.serviceDiscovery = mockSD;
    //mock app config
    //[[[mockappConfig expect] andReturn:testServiceId] getPropertyForKey:@"languagePack.serviceId" group:OCMOCK_ANY error:[OCMArg anyObjectRef]];
    
    //mock SD
    [[[mockSD expect]andDo:^(NSInvocation *invocation) {
        void (^completionHandler)(NSDictionary<NSString*,AISDService*> *services,NSError *error);
        AISDService *service = [[AISDService alloc]initWithUrl:testOverviewUrl andLocale:appLocalisations];
        NSDictionary *servicesDictionary = @{@"appinfra.languagepack": service};
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(servicesDictionary, nil);
    }]getServicesWithCountryPreference:@[testServiceId] withCompletionHandler:OCMOCK_ANY replacement:nil];
    
    //mock REST
    NSDictionary * json = @{
                            @"languages": @[
                                    @{
                                        @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/nl_NL.json",
                                        @"locale": @"nl_NL",
                                        @"remoteVersion": @"1"
                                        },
                                    @{
                                        @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/xx_XX.json",
                                        @"locale": @"xx_XX",
                                        @"remoteVersion": @"1"
                                        },
                                    
                                    @{
                                        @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en.json",
                                        @"locale": @"en",
                                        @"remoteVersion": @"111"
                                        }

                                    ]
                            };
    
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    id restMock =[OCMockObject partialMockForObject:lp.RESTClient];
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        successBlock(nil, json);
    }] GET:testOverviewUrl parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        NSDictionary * json = @{ @"locale":@"en",
                                 @"testKey":@"testDownload"
                                 };
        successBlock(nil, json);
    }] GET:@"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en.json"parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    id lpMock = [OCMockObject partialMockForObject:lp];
    [[[lpMock expect] andReturnValue:OCMOCK_VALUE(NO)] shouldUpdateCurrentLanguagePack];
    [[[lpMock expect]andReturn:appLocalisations] getPreferredLocales];
    
    XCTestExpectation *expectation =[self expectationWithDescription:@"LanguagePack"];
    [lpMock refresh:^(AILPRefreshStatus refreshResult, NSError * _Nullable error) {
        //[mockappConfig verify];
        [mockSD verify];
        //[restMock verify];
        [expectation fulfill];        
        NSDictionary *lpinfo = [lp getPreferredLanguagePackInfo];
        NSLog(@"%@",lpinfo);
        XCTAssertEqualObjects(lpinfo[@"locale"], @"en");
        XCTAssertEqualObjects(lpinfo[@"remoteVersion"], @"111");
        XCTAssertEqualObjects(lpinfo[@"url"], @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en.json");

    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
    
}
//disabled because now no fallback to en_US
- (void)d_testValidateOverviewDataEn_US{
    NSString *appLocalisations=@"hi_IN";
    NSString *testOverviewUrl = @"https://hashim-rest.herokuapp.com/sd/tst/en_IN/appinfra/lp.json";
    //id mockappConfig = [OCMockObject partialMockForObject:appInfra.appConfig];
    id mockSD = [OCMockObject partialMockForObject:appInfra.serviceDiscovery];
    //appInfra.appConfig = mockappConfig;
    appInfra.serviceDiscovery = mockSD;
    //mock app config
    //[[[mockappConfig expect] andReturn:testServiceId] getPropertyForKey:@"languagePack.serviceId" group:OCMOCK_ANY error:[OCMArg anyObjectRef]];
    
    //mock SD
    [[[mockSD expect]andDo:^(NSInvocation *invocation) {
        void (^completionHandler)(NSDictionary<NSString*,AISDService*> *services,NSError *error);
        AISDService *service = [[AISDService alloc]initWithUrl:testOverviewUrl andLocale:appLocalisations];
        NSDictionary *servicesDictionary = @{@"appinfra.languagepack": service};
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(servicesDictionary, nil);
    }]getServicesWithCountryPreference:@[testServiceId] withCompletionHandler:OCMOCK_ANY replacement:nil];

    //mock REST
    NSDictionary * json = @{
                            @"languages": @[
                                    @{
                                        @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/nl_NL.json",
                                        @"locale": @"nl_NL",
                                        @"remoteVersion": @"1"
                                        },
                                    @{
                                        @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en.json",
                                        @"locale": @"en",
                                        @"remoteVersion": @"1"
                                        },
                                    
                                    @{
                                        @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_US.json",
                                        @"locale": @"en_US",
                                        @"remoteVersion": @"222"
                                        }
                                    
                                    ]
                            };
    
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    id restMock =[OCMockObject partialMockForObject:lp.RESTClient];
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        successBlock(nil, json);
    }] GET:testOverviewUrl parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        NSDictionary * json = @{ @"locale":@"en",
                                 @"testKey":@"testDownload"
                                 };
        successBlock(nil, json);
    }] GET:@"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_US.json"parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    
    id lpMock = [OCMockObject partialMockForObject:lp];
    [[[lpMock expect] andReturnValue:OCMOCK_VALUE(NO)] shouldUpdateCurrentLanguagePack];
    [[[lpMock expect]andReturn:appLocalisations] getPreferredLocales];
    
    XCTestExpectation *expectation =[self expectationWithDescription:@"LanguagePack"];
    [lpMock refresh:^(AILPRefreshStatus refreshResult, NSError * _Nullable error) {
        //[mockappConfig verify];
        [mockSD verify];
        //[restMock verify];
        [expectation fulfill];
        NSDictionary *lpinfo = [lp getPreferredLanguagePackInfo];
        NSLog(@"%@",lpinfo);
        XCTAssertEqualObjects(lpinfo[@"locale"], @"en_US");
        XCTAssertEqualObjects(lpinfo[@"remoteVersion"], @"222");
        XCTAssertEqualObjects(lpinfo[@"url"], @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_US.json");
        
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
    
}
//disabled because now fallback to en
- (void)d_testValidateOverviewDataEn{
    NSString *appLocalisations=@"hi_IN";
    NSString *testOverviewUrl = @"https://hashim-rest.herokuapp.com/sd/tst/en_IN/appinfra/lp.json";
    //id mockappConfig = [OCMockObject partialMockForObject:appInfra.appConfig];
    id mockSD = [OCMockObject partialMockForObject:appInfra.serviceDiscovery];
    //appInfra.appConfig = mockappConfig;
    appInfra.serviceDiscovery = mockSD;
    //mock app config
    //[[[mockappConfig expect] andReturn:testServiceId] getPropertyForKey:@"languagePack.serviceId" group:OCMOCK_ANY error:[OCMArg anyObjectRef]];
    
    //mock SD
    [[[mockSD expect]andDo:^(NSInvocation *invocation) {
        void (^completionHandler)(NSDictionary<NSString*,AISDService*> *services,NSError *error);
        AISDService *service = [[AISDService alloc]initWithUrl:testOverviewUrl andLocale:appLocalisations];
        NSDictionary *servicesDictionary = @{@"appinfra.languagepack": service};
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(servicesDictionary, nil);
    }]getServicesWithCountryPreference:@[testServiceId] withCompletionHandler:OCMOCK_ANY replacement:nil];

    
    //mock REST
    NSDictionary * json = @{
                            @"languages": @[
                                    @{
                                        @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/nl_NL.json",
                                        @"locale": @"nl_NL",
                                        @"remoteVersion": @"1"
                                        },
                                    @{
                                        @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/xx_XX.json",
                                        @"locale": @"xx_XX",
                                        @"remoteVersion": @"1"
                                        },
                                    
                                    @{
                                        @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en.json",
                                        @"locale": @"en",
                                        @"remoteVersion": @"333"
                                        }
                                    
                                    ]
                            };
    
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    id restMock =[OCMockObject partialMockForObject:lp.RESTClient];
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        successBlock(nil, json);
    }] GET:testOverviewUrl parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        NSDictionary * json = @{ @"locale":@"en",
                                 @"testKey":@"testDownload"
                                 };
        successBlock(nil, json);
    }] GET:@"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en.json"parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    
    id lpMock = [OCMockObject partialMockForObject:lp];
    [[[lpMock expect] andReturnValue:OCMOCK_VALUE(NO)] shouldUpdateCurrentLanguagePack];
    [[[lpMock expect]andReturn:appLocalisations] getPreferredLocales];
    
    XCTestExpectation *expectation =[self expectationWithDescription:@"LanguagePack"];
    [lpMock refresh:^(AILPRefreshStatus refreshResult, NSError * _Nullable error) {
        //[mockappConfig verify];
        [mockSD verify];
        //[restMock verify];
        [expectation fulfill];
        NSDictionary *lpinfo = [lp getPreferredLanguagePackInfo];
        NSLog(@"%@",lpinfo);
        XCTAssertEqualObjects(lpinfo[@"locale"], @"en");
        XCTAssertEqualObjects(lpinfo[@"remoteVersion"], @"333");
        XCTAssertEqualObjects(lpinfo[@"url"], @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en.json");
        
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testLanguagePackUrlforLanguageCodeOnly{
    NSString *testOverviewUrl = @"https://hashim-rest.herokuapp.com/sd/tst/en_IN/appinfra/lp.json";
    
    //mock SD
    id mockSD = [OCMockObject partialMockForObject:appInfra.serviceDiscovery];
    appInfra.serviceDiscovery = mockSD;
    [[[mockSD expect]andDo:^(NSInvocation *invocation) {
        void (^completionHandler)(NSDictionary<NSString*,AISDService*> *services,NSError *error);
        AISDService *service = [[AISDService alloc]initWithUrl:testOverviewUrl andLocale:@"en_IN"];
        NSDictionary *servicesDictionary = @{@"appinfra.languagepack": service};
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(servicesDictionary, nil);
    }]getServicesWithCountryPreference:@[testServiceId] withCompletionHandler:OCMOCK_ANY replacement:nil];

    //mock REST
    NSString * configPath = [[NSBundle bundleForClass:self.class] pathForResource:@"lpOverview" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:configPath];
    NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    id restMock =[OCMockObject partialMockForObject:lp.RESTClient];
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        successBlock(nil, json);
    }] GET:testOverviewUrl parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        NSDictionary * json = @{ @"locale":@"en",
                                 @"testKey":@"testDownload"
                                 };
        successBlock(nil, json);
    }] GET:@"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en.json"parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    

    
    id lpMock = [OCMockObject partialMockForObject:lp];
    [[[lpMock expect] andReturnValue:OCMOCK_VALUE(YES)] shouldUpdateCurrentLanguagePack];
    NSString *appLocalisations=@"en";
    [[[lpMock expect]andReturn:appLocalisations] getPreferredLocales];
    
    XCTestExpectation *expectation =[self expectationWithDescription:@"LanguagePack"];
    [lpMock refresh:^(AILPRefreshStatus refreshResult, NSError * _Nullable error) {
        [mockSD verify];
        [restMock verify];
        [lpMock verify];
        NSString *url = [lp getPreferredLanguagePackInfo][@"url"];
        XCTAssertEqualObjects(url,@"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en.json");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
    
}

- (void)testLanguagePackUrlForFullLocale{
    NSString *testOverviewUrl = @"https://hashim-rest.herokuapp.com/sd/tst/en_IN/appinfra/lp.json";
    
    NSString *appLocalisations=@"en_GB";
    
    //mock SD
    id mockSD = [OCMockObject partialMockForObject:appInfra.serviceDiscovery];
    appInfra.serviceDiscovery = mockSD;
    [[[mockSD expect]andDo:^(NSInvocation *invocation) {
        void (^completionHandler)(NSDictionary<NSString*,AISDService*> *services,NSError *error);
        AISDService *service = [[AISDService alloc]initWithUrl:testOverviewUrl andLocale:appLocalisations];
        NSDictionary *servicesDictionary = @{@"appinfra.languagepack": service};
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(servicesDictionary, nil);
    }]getServicesWithCountryPreference:OCMOCK_ANY withCompletionHandler:OCMOCK_ANY replacement:nil];
    
    //mock REST
    NSString * configPath = [[NSBundle bundleForClass:self.class] pathForResource:@"lpOverview" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:configPath];
    NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    id restMock =[OCMockObject partialMockForObject:lp.RESTClient];
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        successBlock(nil, json);
    }] GET:testOverviewUrl parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        NSDictionary * json = @{ @"locale":@"en_SL",
                                 @"testKey":@"testDownload"
                                 };
        successBlock(nil, json);
    }] GET:@"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_GB.json"parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    

    id lpMock = [OCMockObject partialMockForObject:lp];
    [[[lpMock expect] andReturnValue:OCMOCK_VALUE(YES)] shouldUpdateCurrentLanguagePack];
    [[[lpMock expect]andReturn:appLocalisations] getPreferredLocales];
    
    XCTestExpectation *expectation =[self expectationWithDescription:@"LanguagePack"];
    [lpMock refresh:^(AILPRefreshStatus refreshResult, NSError * _Nullable error) {
        [mockSD verify];
        [restMock verify];
        XCTAssertEqual(refreshResult, AILPRefreshStatusRefreshedFromServer);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testLanguagePackUrlForBlankURL{
    NSString *testOverviewUrl = @"https://hashim-rest.herokuapp.com/sd/tst/en_IN/appinfra/lp.json";
    
    NSString *appLocalisations=@"en_GB";
    
    //mock SD
    id mockSD = [OCMockObject partialMockForObject:appInfra.serviceDiscovery];
    appInfra.serviceDiscovery = mockSD;
    [[[mockSD expect]andDo:^(NSInvocation *invocation) {
        void (^completionHandler)(NSDictionary<NSString*,AISDService*> *services,NSError *error);
        AISDService *service = [[AISDService alloc]initWithUrl:testOverviewUrl andLocale:appLocalisations];
        NSDictionary *servicesDictionary = @{@"appinfra.languagepack": service};
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(servicesDictionary, nil);
    }]getServicesWithCountryPreference:OCMOCK_ANY withCompletionHandler:OCMOCK_ANY replacement:nil];
    
    //mock REST
    NSString * configPath = [[NSBundle bundleForClass:self.class] pathForResource:@"lpOverview" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:configPath];
    NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    id restMock =[OCMockObject partialMockForObject:lp.RESTClient];
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        successBlock(nil, json);
    }] GET:testOverviewUrl parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    id lpMock = [OCMockObject partialMockForObject:lp];
    [[[lpMock expect] andReturnValue:OCMOCK_VALUE(YES)] shouldUpdateCurrentLanguagePack];
    [[[lpMock stub]andReturn:appLocalisations] getPreferredLocales];
    
    
    NSDictionary * wrongJson = @{
                                 @"languages": @[
                                         @{
                                             @"locale": @"en_GB",
                                             @"remoteVersion": @"1"
                                             }
                                         ]
                                 };
    [[[lpMock expect] andReturnValue:OCMOCK_VALUE(wrongJson)] getPreferredLanguagePackInfo];
    
    XCTestExpectation *expectation =[self expectationWithDescription:@"LanguagePack"];
    [lpMock refresh:^(AILPRefreshStatus refreshResult, NSError * _Nullable error) {
        [mockSD verify];
        [restMock verify];
        [lpMock verify];
        [expectation fulfill];
        XCTAssertEqual(refreshResult, AILPRefreshStatusRefreshFailed);
        
        
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
        //[bundleMock stopMocking];
        //[mockMainBundle stopMocking];
    }];
}

//disables now no fallback to genneric language
- (void)d_testLanguagePackUrlforGenericLocale{
    NSString *testOverviewUrl = @"https://hashim-rest.herokuapp.com/sd/tst/en_IN/appinfra/lp.json";
    
    NSString *appLocalisations=@"en_XX";
    
    
    //mock SD
    id mockSD = [OCMockObject partialMockForObject:appInfra.serviceDiscovery];
    appInfra.serviceDiscovery = mockSD;
    [[[mockSD expect]andDo:^(NSInvocation *invocation) {
        void (^completionHandler)(NSDictionary<NSString*,AISDService*> *services,NSError *error);
        AISDService *service = [[AISDService alloc]initWithUrl:testOverviewUrl andLocale:appLocalisations];
        NSDictionary *servicesDictionary = @{@"appinfra.languagepack": service};
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(servicesDictionary, nil);
    }]getServicesWithCountryPreference:@[testServiceId] withCompletionHandler:OCMOCK_ANY replacement:nil];

    
    //mock REST
    NSString * configPath = [[NSBundle bundleForClass:self.class] pathForResource:@"lpOverview" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:configPath];
    NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    id restMock =[OCMockObject partialMockForObject:lp.RESTClient];
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        successBlock(nil, json);
    }] GET:testOverviewUrl parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        NSDictionary * json = @{ @"locale":@"en",
                                 @"testKey":@"testDownload"
                                 };
        successBlock(nil, json);
    }] GET:@"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en.json"parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    

    id lpMock = [OCMockObject partialMockForObject:lp];
    [[[lpMock expect] andReturnValue:OCMOCK_VALUE(YES)] shouldUpdateCurrentLanguagePack];
    [[[lpMock stub]andReturn:appLocalisations] getPreferredLocales];
    
    XCTestExpectation *expectation =[self expectationWithDescription:@"LanguagePack"];
    [lpMock refresh:^(AILPRefreshStatus refreshResult, NSError * _Nullable error) {
        [mockSD verify];
        [restMock verify];
        NSString *url = [lp getPreferredLanguagePackInfo][@"url"];
        XCTAssertEqualObjects(url,@"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en.json");
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

//disabled , now no fallback to genericVarient
- (void)d_testLanguagePackUrlforVariantRegionLocale{
    NSString *testOverviewUrl = @"https://hashim-rest.herokuapp.com/sd/tst/en_IN/appinfra/lp.json";
    
    NSString *appLocalisations=@"en_IN";
    
    //mock SD
    id mockSD = [OCMockObject partialMockForObject:appInfra.serviceDiscovery];
    appInfra.serviceDiscovery = mockSD;
    [[[mockSD expect]andDo:^(NSInvocation *invocation) {
        void (^completionHandler)(NSDictionary<NSString*,AISDService*> *services,NSError *error);
        AISDService *service = [[AISDService alloc]initWithUrl:testOverviewUrl andLocale:appLocalisations];
        NSDictionary *servicesDictionary = @{@"appinfra.languagepack": service};
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(servicesDictionary, nil);
    }]getServicesWithCountryPreference:@[testServiceId] withCompletionHandler:OCMOCK_ANY replacement:nil];

    
    //mock REST
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    id restMock =[OCMockObject partialMockForObject:lp.RESTClient];
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        NSDictionary * json = @{
                                @"languages": @[
                                        @{
                                            @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_GB.json",
                                            @"locale": @"en_GB",
                                            @"remoteVersion": @"1"
                                            }
                                        ]
                                };
        successBlock(nil, json);
    }] GET:testOverviewUrl parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        NSDictionary * json = @{ @"locale":@"en_GB",
                                 @"testKey":@"testDownload"
                                 };
        successBlock(nil, json);
    }] GET:@"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_GB.json"parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
 
    id lpMock = [OCMockObject partialMockForObject:lp];
    [[[lpMock expect] andReturnValue:OCMOCK_VALUE(YES)] shouldUpdateCurrentLanguagePack];
    [[[lpMock stub]andReturn:appLocalisations] getPreferredLocales];
    
    XCTestExpectation *expectation =[self expectationWithDescription:@"LanguagePack"];
    [lpMock refresh:^(AILPRefreshStatus refreshResult, NSError * _Nullable error) {
        [mockSD verify];
        [restMock verify];
        NSString *url = [lp getPreferredLanguagePackInfo][@"url"];
        XCTAssertEqualObjects(url,@"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_GB.json");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

-(void)testDownloadLanguagePackNotPresent{
    NSString *testOverviewUrl = @"https://hashim-rest.herokuapp.com/sd/tst/en_IN/appinfra/lp.json";
    
    //mock SD
    id mockSD = [OCMockObject partialMockForObject:appInfra.serviceDiscovery];
    appInfra.serviceDiscovery = mockSD;
    [[[mockSD expect]andDo:^(NSInvocation *invocation) {
        void (^completionHandler)(NSDictionary<NSString*,AISDService*> *services,NSError *error);
        AISDService *service = [[AISDService alloc]initWithUrl:testOverviewUrl andLocale:@"en_GB"];
        NSDictionary *servicesDictionary = @{@"appinfra.languagepack": service};
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(servicesDictionary, nil);
    }]getServicesWithCountryPreference:OCMOCK_ANY withCompletionHandler:OCMOCK_ANY replacement:nil];
    
    //mock REST
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    id restMock =[OCMockObject partialMockForObject:lp.RESTClient];
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        NSDictionary * json = @{
                                @"languages": @[
                                        ]
                                };
        successBlock(nil, json);
    }] GET:testOverviewUrl parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    id lpMock = [OCMockObject partialMockForObject:lp];
    [[[lpMock expect]andReturnValue:OCMOCK_VALUE(YES)] shouldUpdateCurrentLanguagePack];
    XCTestExpectation *expectation =[self expectationWithDescription:@"LanguagePack"];
    [lpMock refresh:^(AILPRefreshStatus refreshResult, NSError * _Nullable error) {
        [mockSD verify];
        [restMock verify];
        XCTAssertNotNil(error);
        XCTAssertEqualObjects(error.localizedDescription, @"Not able to find the url for language pack");
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}
    
-(void)testDownloadLanguagePackInvalid {
    NSString *testOverviewUrl = @"https://hashim-rest.herokuapp.com/sd/tst/en_IN/appinfra/lp.json";
    
    //mock SD
    id mockSD = [OCMockObject partialMockForObject:appInfra.serviceDiscovery];
    appInfra.serviceDiscovery = mockSD;
    [[[mockSD expect]andDo:^(NSInvocation *invocation) {
        void (^completionHandler)(NSDictionary<NSString*,AISDService*> *services,NSError *error);
        AISDService *service = [[AISDService alloc]initWithUrl:testOverviewUrl andLocale:@"en_IN"];
        NSDictionary *servicesDictionary = @{@"appinfra.languagepack": service};
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(servicesDictionary, nil);
    }]getServicesWithCountryPreference:@[testServiceId] withCompletionHandler:OCMOCK_ANY replacement:nil];

    
    //mock REST
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    id restMock =[OCMockObject partialMockForObject:lp.RESTClient];
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        NSDictionary * json = @{
                                @"languages": @[
                                        @{
                                            @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_US.json",
                                            @"locale": @"en_US",
                                            @"remoteVersion": @"1"
                                            },
                                        @{
                                            @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_GB.json",
                                            @"locale": @"en_GB",
                                            @"remoteVersion": @"1"
                                            },
                                        @{
                                            @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_FR.json",
                                            @"locale": @"en_FR",
                                            @"remoteVersion": @"1"
                                            },
                                        @{
                                            @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_SP.json",
                                            @"locale": @"en_SP",
                                            @"remoteVersion": @"1"
                                            },
                                        @{
                                            @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_SL.json",
                                            @"locale": @"en_SL",
                                            @"remoteVersion": @"1"
                                            },
                                        @{
                                            @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_IN.json",
                                            @"locale": @"en_IN",
                                            @"remoteVersion": @"1"
                                            }
                                        ]
                                };
        successBlock(nil, json);
    }] GET:testOverviewUrl parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    id lpMock = [OCMockObject partialMockForObject:lp];
    [[[lpMock expect]andReturnValue:OCMOCK_VALUE(YES)] shouldUpdateCurrentLanguagePack];
    
    NSDictionary *lpInfo =@{@"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_SL.json",
                            @"locale": @"en_SL",
                            @"remoteVersion": @"1"
                            };
    
    [[[lpMock expect]andReturn:lpInfo] getPreferredLanguagePackInfo];
    
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        NSArray * json = @[ @"locale",@"en_SL",
                            @"testKey",@"testDownload"
                            ];
        successBlock(nil, json);
    }] GET:lpInfo[@"url"] parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    [lpMock refresh:^(AILPRefreshStatus refreshResult, NSError * _Nullable error) {
        [mockSD verify];
        [restMock verify];
        XCTAssertEqual(refreshResult, AILPRefreshStatusRefreshFailed);
        XCTAssertEqual(error.code, AILPErrorInvalidJson);
    }];
}
    
-(void)testDownloadLanguagePack{
    NSString *testOverviewUrl = @"https://hashim-rest.herokuapp.com/sd/tst/en_IN/appinfra/lp.json";
    
    //mock SD
    id mockSD = [OCMockObject partialMockForObject:appInfra.serviceDiscovery];
    appInfra.serviceDiscovery = mockSD;
    [[[mockSD expect]andDo:^(NSInvocation *invocation) {
        void (^completionHandler)(NSDictionary<NSString*,AISDService*> *services,NSError *error);
        AISDService *service = [[AISDService alloc]initWithUrl:testOverviewUrl andLocale:@"en_GB"];
        NSDictionary *servicesDictionary = @{@"appinfra.languagepack": service};
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(servicesDictionary, nil);
    }]getServicesWithCountryPreference:OCMOCK_ANY withCompletionHandler:OCMOCK_ANY replacement:nil];
    
    //mock REST
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    id restMock =[OCMockObject partialMockForObject:lp.RESTClient];
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        NSDictionary * json = @{
                                @"languages": @[
                                        @{
                                            @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_US.json",
                                            @"locale": @"en_US",
                                            @"remoteVersion": @"1"
                                            },
                                        @{
                                            @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_GB.json",
                                            @"locale": @"en_GB",
                                            @"remoteVersion": @"1"
                                            },
                                        @{
                                            @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_FR.json",
                                            @"locale": @"en_FR",
                                            @"remoteVersion": @"1"
                                            },
                                        @{
                                            @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_SP.json",
                                            @"locale": @"en_SP",
                                            @"remoteVersion": @"1"
                                            },
                                        @{
                                            @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_SL.json",
                                            @"locale": @"en_SL",
                                            @"remoteVersion": @"1"
                                            },
                                        @{
                                            @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_IN.json",
                                            @"locale": @"en_IN",
                                            @"remoteVersion": @"1"
                                            }
                                        ]
                                };
        successBlock(nil, json);
    }] GET:testOverviewUrl parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    id lpMock = [OCMockObject partialMockForObject:lp];
    [[[lpMock expect]andReturnValue:OCMOCK_VALUE(YES)] shouldUpdateCurrentLanguagePack];
    
    NSDictionary *lpInfo =@{@"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_SL.json",
                            @"locale": @"en_SL",
                            @"remoteVersion": @"1"
                            };
    
    [[[lpMock expect]andReturn:lpInfo] getPreferredLanguagePackInfo];
    
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        NSDictionary * json = @{ @"locale":@"en_SL",
                                 @"testKey":@"testDownload"
                                 };
        successBlock(nil, json);
    }] GET:lpInfo[@"url"] parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    
    XCTestExpectation *expectation =[self expectationWithDescription:@"LanguagePack"];
    [lpMock refresh:^(AILPRefreshStatus refreshResult, NSError * _Nullable error) {
        [mockSD verify];
        [restMock verify];
        [lp activate:^(AILPActivateStatus activatedStatus, NSError * _Nullable error) {
            XCTAssertEqualObjects(@"testDownload",[lp localizedStringForKey:@"testKey"]);
            [expectation fulfill];
        }];
        
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}
-(NSDictionary *)getTestLanguagePack{
    return @{
             @"1":@"germanTest-Straßen­übergangs­änderungs­gesetz",
             @"2":@"swidishTest-smörgåsbord",
             @"3":@"specialTest-é, ß, ü, ä, ö or å ",
             @"4":@"escapeTest-string/\%%",
             @"5":@"chinaTest-丂丄丅丆丏",
             @"6":@"☃",
             @"7":@"エンコーディングは難しくない",
             @"8":@"\n\b\t\a/\'\"",
             @"nonEu":@"縧",
             @"mbString":@"漢",
             @"Hiragana":@"あ"
             };
}


-(void)testlocalizedString{
    [self saveDictionary:@{@"testKey":@"testValue"}
                  atPath:[self activatedJasonFilePath]];
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    XCTAssertEqualObjects(@"testValue",[lp localizedStringForKey:@"testKey"]);
    XCTAssertEqualObjects(@"KeyThatDoesntExist",[lp localizedStringForKey:@"KeyThatDoesntExist"]);
}

-(void)testlocalizedStringWithoutCloud{
    
    id mockMainBundle = [OCMockObject partialMockForObject:[NSBundle mainBundle]];
    [[[mockMainBundle stub] andReturn:@"testingValue"] localizedStringForKey:@"bundleOnlykey" value:OCMOCK_ANY table:OCMOCK_ANY];

    [self removeFileAtPath:[self downloadedJasonFilePath]];
    [self removeFileAtPath:[self activatedJasonFilePath]];
    [self removeFileAtPath:[self metedataFilePath]];
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    XCTAssertEqualObjects(@"testingValue",[lp localizedStringForKey:@"bundleOnlykey"]);
    XCTAssertEqualObjects(@"KeyThatDoesntExist",[lp localizedStringForKey:@"KeyThatDoesntExist"]);
    [mockMainBundle stopMocking];
}

-(void)testActivateWithAllFiles{
    [self saveDictionary:@{@"testKey":@"testValue"}
                  atPath:[self activatedJasonFilePath]];
    
    [self removeFileAtPath:[self metedataFilePath]];
    [self removeFileAtPath:[self activatedJasonFilePath]];
    [self removeFileAtPath:[self downloadedJasonFilePath]];
    
    
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    [lp activate:^(AILPActivateStatus activateResult, NSError * _Nullable error) {
        
    }];
    
    
}

-(void)testActivateWithNoFiles{
    
    [self removeFileAtPath:[self metedataFilePath]];
    [self removeFileAtPath:[self activatedJasonFilePath]];
    [self removeFileAtPath:[self downloadedJasonFilePath]];
    
    
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    
    XCTestExpectation *expectation =
    [self expectationWithDescription:@"activet1"];
    
    [lp activate:^(AILPActivateStatus activateResult, NSError * _Nullable error) {
        XCTAssertEqual(activateResult, AILPActivateStatusFailed);
        XCTAssertTrue(error.code == 3);
        XCTAssertEqualObjects(@"No Language Pack Available", [error localizedDescription]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        
        
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}
//downloaded and not previously activated
-(void)testActivateWithOnlyDownloaded{
    
    [self removeFileAtPath:[self metedataFilePath]];
    [self removeFileAtPath:[self activatedJasonFilePath]];
    [self removeFileAtPath:[self downloadedJasonFilePath]];
    
    [self saveDictionary:@{@"downloadedKey":@"downloadedValue"}
                  atPath:[self downloadedJasonFilePath]];
    
    
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"activet1"];
    
    [lp activate:^(AILPActivateStatus activateResult, NSError * _Nullable error) {
        XCTAssertEqual(activateResult, AILPActivateStatusUpdateActivated);
        XCTAssertNil(error);
        XCTAssertEqualObjects(@"downloadedValue",[lp localizedStringForKey:@"downloadedKey"]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        
        
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

//downloaded and  previously activated
-(void)testActivateWithDownloadedandActivated{
    
    [self removeFileAtPath:[self metedataFilePath]];
    [self removeFileAtPath:[self activatedJasonFilePath]];
    [self removeFileAtPath:[self downloadedJasonFilePath]];
    
    [self saveDictionary:@{@"downloadedKey1":@"downloadedValue1"}
                  atPath:[self downloadedJasonFilePath]];
    
    
    [self saveDictionary:@{@"activatedKey":@"activatedValue"}
                  atPath:[self activatedJasonFilePath]];
    
    
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"activet2"];
    
    [lp activate:^(AILPActivateStatus activateResult, NSError * _Nullable error) {
        XCTAssertEqual(activateResult, AILPActivateStatusUpdateActivated);
        XCTAssertNil(error);
        XCTAssertEqualObjects(@"downloadedValue1",[lp localizedStringForKey:@"downloadedKey1"]);
        NSString *nilKey = nil;
        XCTAssertEqualObjects([lp localizedStringForKey:nilKey],@"");
        [expectation fulfill];
        BOOL isDownloaded = [[NSFileManager defaultManager]fileExistsAtPath:[self downloadedJasonFilePath]];
        XCTAssertFalse(isDownloaded);
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        
        
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

-(void)testshouldNotUpdateCurrentLanguagePackForSameDownloadedLP{
    
    [self removeFileAtPath:[self metedataFilePath]];
    [self removeFileAtPath:[self activatedJasonFilePath]];
    [self removeFileAtPath:[self downloadedJasonFilePath]];

    NSString *testOverviewUrl = @"https://hashim-rest.herokuapp.com/sd/tst/en_IN/appinfra/lp.json";
    
    NSString *appLocalisations=@"en";
    
    //mock SD
    id mockSD = [OCMockObject partialMockForObject:appInfra.serviceDiscovery];
    appInfra.serviceDiscovery = mockSD;
    [[[mockSD expect]andDo:^(NSInvocation *invocation) {
        void (^completionHandler)(NSDictionary<NSString*,AISDService*> *services,NSError *error);
        AISDService *service = [[AISDService alloc]initWithUrl:testOverviewUrl andLocale:appLocalisations];
        NSDictionary *servicesDictionary = @{@"appinfra.languagepack": service};
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(servicesDictionary, nil);
    }]getServicesWithCountryPreference:@[testServiceId] withCompletionHandler:OCMOCK_ANY replacement:nil];

    //mock REST
    NSString * configPath = [[NSBundle bundleForClass:self.class] pathForResource:@"lpOverview" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:configPath];
    NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    id restMock =[OCMockObject partialMockForObject:lp.RESTClient];
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        successBlock(nil, json);
    }] GET:testOverviewUrl parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    
    id lpMock = [OCMockObject partialMockForObject:lp];
    [[[lpMock stub]andReturn:appLocalisations] getPreferredLocales];
    
    [[[restMock stub]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        NSDictionary * json = @{
                                @"languages": @[
                                        @{
                                            @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_US.json",
                                            @"locale": @"en_US",
                                            @"remoteVersion": @"1"
                                            },
                                        @{
                                            @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en_GB.json",
                                            @"locale": @"en_GB",
                                            @"remoteVersion": @"1"
                                            },
                                        @{
                                            @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en.json",
                                            @"locale": @"en",
                                            @"remoteVersion": @"1"
                                            }
                                        ]
                                };
        successBlock(nil, json);
    }] GET:@"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/en.json" parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    
    XCTestExpectation *expectation =[self expectationWithDescription:@"LanguagePackupdate"];
    [lpMock refresh:^(AILPRefreshStatus refreshResult, NSError * _Nullable error) {
        [mockSD verify];
        [lpMock verify];
        [expectation fulfill];
        [[[lpMock expect]andReturn:@[@"en"]] getPreferredLocales];
        BOOL shouldUpdate = [lpMock shouldUpdateCurrentLanguagePack];
        XCTAssertFalse(shouldUpdate);
        
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        
        
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
    
    
    
}

-(void)testShouldDeleteLanguagePackIfLocalechanged{
    [self removeFileAtPath:[self metedataFilePath]];
    [self removeFileAtPath:[self activatedJasonFilePath]];
    [self removeFileAtPath:[self downloadedJasonFilePath]];
    
    [self saveDictionary:@{@"downloadedKey1":@"downloadedValue1"}
                  atPath:[self downloadedJasonFilePath]];
    
    
    [self saveDictionary:@{@"activatedKey":@"activatedValue"}
                  atPath:[self activatedJasonFilePath]];
    NSDictionary * json = @{
                                        @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/xx_XX.json",
                                        @"locale": @"xx_XX",
                                        @"remoteVersion": @"1"
                                    };
    
    [self saveDictionary:json
                  atPath:[self metedataFilePath]];
    
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:[self metedataFilePath]]);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:[self activatedJasonFilePath]]);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:[self downloadedJasonFilePath]]);


    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    XCTAssertNotNil(lp);
    XCTAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:[self metedataFilePath]]);
    XCTAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:[self activatedJasonFilePath]]);
    XCTAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:[self downloadedJasonFilePath]]);
}

-(void)testShouldNotDeleteLanguagePackIfLocaleSame{
    [self removeFileAtPath:[self metedataFilePath]];
    [self removeFileAtPath:[self activatedJasonFilePath]];
    [self removeFileAtPath:[self downloadedJasonFilePath]];
    
    [self saveDictionary:@{@"downloadedKey1":@"downloadedValue1"}
                  atPath:[self downloadedJasonFilePath]];
    
    
    [self saveDictionary:@{@"activatedKey":@"activatedValue"}
                  atPath:[self activatedJasonFilePath]];
    NSDictionary * json = @{
                            @"url": @"https://hashim-rest.herokuapp.com/sd/dev/en_IN/appinfra/lp/xx_XX.json",
                            @"locale": [appInfra.internationalization getUILocaleString],
                            @"remoteVersion": @"1"
                            };
    
    [self saveDictionary:json
                  atPath:[self metedataFilePath]];
    
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:[self metedataFilePath]]);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:[self activatedJasonFilePath]]);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:[self downloadedJasonFilePath]]);
    
    AILanguagePack *lp = [[AILanguagePack alloc]initWithAppInfra:appInfra];
    XCTAssertNotNil(lp);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:[self metedataFilePath]]);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:[self activatedJasonFilePath]]);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:[self downloadedJasonFilePath]]);
}


-(NSString*)metedataFilePath{
    return [[AIUtility appInfraDocumentsDirectory] stringByAppendingPathComponent:@"/AILanguagePack/LangPackMetadata.json"];
}

-(NSString*)activatedJasonFilePath{
    return [[AIUtility appInfraDocumentsDirectory] stringByAppendingPathComponent:@"/AILanguagePack/ActivatedLangPack.json"];
}

-(NSString*)downloadedJasonFilePath{
    return  [[AIUtility appInfraDocumentsDirectory] stringByAppendingPathComponent:@"/AILanguagePack/DownloadedLangPack.json"];
}

-(void)removeFileAtPath:(NSString*)path{
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}
-(void)saveDictionary:(NSDictionary*)dictionary atPath:(NSString*)path{
    [self createDirectory];
    if (dictionary) {
        [dictionary writeToFile:path atomically:YES];
    }
    
}
-(void)createDirectory{
    NSString *dataPath = [[AIUtility appInfraDocumentsDirectory] stringByAppendingPathComponent:@"/AILanguagePack"];
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])//Check
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Will Create folder
}

@end
