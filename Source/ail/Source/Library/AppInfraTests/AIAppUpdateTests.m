//
//  AIAppUpdateTests.m
//  AppInfra
//
//  Created by Hashim MH on 11/05/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSBundle+Bundle.h"
#import <OCMock/OCMock.h>
#import "AIAppUpdateProtocol.h"
#import <AppInfra/AIAppUpdateProtocol.h>
#import "AIUtility.h"
#import "AIRESTMock.h"

@import AppInfra;

#define testServiceId @"appinfra.appupdate"
#define testOverviewUrl @"https://hashim-rest.herokuapp.com/sd/tst/en_IN/appinfra/version.json"
//#define testOverviewUrl @"https://localhost.com/sd/tst/en_IN/appinfra/version.json";

@interface AIAppUpdateTests : XCTestCase{
    AIAppUpdate  *appUpdate;
    AIAppInfra *appInfra;
}

@end

@interface AIAppUpdate (){

}
//
@property(nonatomic,weak) id<AIRESTClientProtocol> RESTClient;
@end


@implementation AIAppUpdateTests
+ (id) sharedAppInfra {
    static dispatch_once_t time = 0;
    static AIAppInfra *_sharedObject = nil;
    dispatch_once(&time, ^{
        _sharedObject = [AIAppInfra buildAppInfraWithBlock:nil];
    });
    return _sharedObject;
}

//+(void)setUp{
//    [NSBundle loadSwizzler];
//}

- (void)setUp {
    [super setUp];

    [NSBundle loadSwizzler];
    appInfra = [AIAppInfra buildAppInfraWithBlock:nil];
}

//MARK: - unit tests

/*Given
 * update info is not already downloaded,
 * autorefresh config is true in appconfig
 *When
 * app infra initializes
 *Then
 * appupdate refresh should be called
 */

-(void)testAppUpdateRefreshWithInvalidConfig{
    [self removeFile];
    
    //mock appconfig
    id mockAppConfig = [OCMockObject partialMockForObject:appInfra.appConfig];
    appInfra.appConfig = mockAppConfig;
    [[[mockAppConfig expect] andReturn:testServiceId] getPropertyForKey:@"appUpdate.autoRefresh" group:OCMOCK_ANY error:[OCMArg anyObjectRef]];
    
    AIRESTMock *restMock = [[AIRESTMock alloc]init];
    NSDictionary *mockData=@{ testServiceId:testOverviewUrl,
                              testOverviewUrl:@{
                                      @"success": [self sampleDictionary]
                                      }
                              };
    restMock.mockData = mockData;
    
    AIAppUpdate *lappUpdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    [lappUpdate setValue:restMock forKey:@"RESTClient"];
    
    XCTAssertFalse([lappUpdate isDeprecated]);
    XCTAssertFalse([lappUpdate isToBeDeprecated]);
    XCTAssertFalse([lappUpdate isUpdateAvailable]);
    XCTAssertNil([lappUpdate getUpdateMessage]);
    XCTAssertNil([lappUpdate getMinimumVersion]);
    XCTAssertNil([lappUpdate getDeprecateMessage]);
    
}


-(void)testAppUpdateRefreshShouldFailForInvalidData{
    [self removeFile];
    
    
    AIRESTMock *restMock = [[AIRESTMock alloc]init];
    NSDictionary *mockData=@{ testServiceId:testOverviewUrl,
                              testOverviewUrl:@{
                                      @"success": [[NSData alloc]init]
                                      }
                              };
    restMock.mockData = mockData;
    
    AIAppUpdate *lappUpdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    [lappUpdate setValue:restMock forKey:@"RESTClient"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Refreshtestappupdate"];
    [lappUpdate refresh:^(AIAppUpdateRefreshStatus status, NSError *error) {
        NSLog(@"error: %@",error.localizedDescription);
        [expectation fulfill];
        XCTAssertNotNil(error);
        XCTAssertTrue(status == AIAppUpdateRefreshStatusFailed);
        XCTAssertTrue(error.code == 3301);
        XCTAssertEqualObjects(error.localizedDescription, @"error trying to convert data to JSON");
        XCTAssertFalse([lappUpdate isDeprecated]);
        XCTAssertFalse([lappUpdate isToBeDeprecated]);
        
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

-(void)testAppUpdateRefreshShouldFailForMissingInfo{
    [self removeFile];
    
    
    AIRESTMock *restMock = [[AIRESTMock alloc]init];
    NSDictionary *mockData=@{ testServiceId:testOverviewUrl,
                              testOverviewUrl:@{
                                      @"success": @{@"key":@"blah blah"}
                                      }
                              };
    restMock.mockData = mockData;
    
    AIAppUpdate *lappUpdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    [lappUpdate setValue:restMock forKey:@"RESTClient"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Refreshtestappupdate"];
    [lappUpdate refresh:^(AIAppUpdateRefreshStatus status, NSError *error) {
        NSLog(@"error: %@",error.localizedDescription);
        [expectation fulfill];
        XCTAssertNotNil(error);
        XCTAssertTrue(status == AIAppUpdateRefreshStatusFailed);
        XCTAssertTrue(error.code == 3302);
        XCTAssertEqualObjects(error.localizedDescription, @"ios appupdate info is missing in response");
        
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}


//-(void)testAppUpdateRefreshShouldFailForMissingInfo{
//    [self removeFile];
//    
//    
//    AIRESTMock *restMock = [[AIRESTMock alloc]init];
//    NSDictionary *mockData=@{ testServiceId:testOverviewUrl,
//                              testOverviewUrl:@{
//                                      @"success": @{@"key":@"blah blah"}
//                                      }
//                              };
//    restMock.mockData = mockData;
//    
//    AIAppUpdate *lappUpdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
//    [lappUpdate setValue:restMock forKey:@"RESTClient"];
//    
//    XCTestExpectation *expectation = [self expectationWithDescription:@"Refreshtestappupdate"];
//    [lappUpdate refresh:^(AIAppUpdateRefreshStatus status, NSError *error) {
//        NSLog(@"error: %@",error.localizedDescription);
//        [expectation fulfill];
//        XCTAssertNotNil(error);
//        XCTAssertTrue(status == AIAppUpdateRefreshStatusFailed);
//        XCTAssertTrue(error.code == 3302);
//        XCTAssertEqualObjects(error.localizedDescription, @"ios appupdate info is missing in response");
//        
//    }];
//    
//    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
//        if (error) {
//            NSLog(@"Timeout Error: %@", error);
//        }
//    }];
//}

-(void)testAppUpdateWithOutRefresh{
    [self removeFile];    
    AIAppUpdate *lappUpdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    XCTAssertFalse([lappUpdate isDeprecated]);
    XCTAssertFalse([lappUpdate isToBeDeprecated]);
    XCTAssertFalse([lappUpdate isUpdateAvailable]);
    XCTAssertNil([lappUpdate getUpdateMessage]);
    XCTAssertNil([lappUpdate getMinimumVersion]);
    XCTAssertNil([lappUpdate getDeprecateMessage]);

}

-(void)testRefreshAppUpdate {

    [self removeFile];
    AIRESTMock *restMock = [[AIRESTMock alloc]init];
    NSDictionary *mockData=@{ testServiceId:testOverviewUrl,
                              testOverviewUrl:@{
                                      @"success": [self sampleDictionary]
                                      }
                              };
    restMock.mockData = mockData;
    
    AIAppUpdate *lappUpdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    [lappUpdate setValue:restMock forKey:@"RESTClient"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Refreshtestappupdate"];
    [lappUpdate refresh:^(AIAppUpdateRefreshStatus status, NSError *error) {
        [expectation fulfill];
        XCTAssertNil(error);
        XCTAssertTrue(status == AIAppUpdateRefreshStatusSuccess);
        
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

-(void)testRefreshAppUpdateWithNullMinimumVersion{
    
    [self removeFile];
    AIRESTMock *restMock = [[AIRESTMock alloc]init];
    NSDictionary *sampleDictionary = @{@"iOS": @{
                                                      @"version": @{
                                                              @"minimumVersion": [NSNull null],
                                                              @"deprecatedVersion": @"3.0.0-SNAPSHOT.1",
                                                              @"deprecationDate": @"2050-07-12",
                                                              @"currentVersion": @"300.1.0"
                                                              },
                                                      @"messages": @{
                                                              @"minimumVersionMessage": @"The current version is outdated in. Please update the app.",
                                                              @"sunsetVersionMessage": @"The current version will be outdated by 2050-07-12. Please update the app soon.",
                                                              @"currentVersionMessage": @"A new version is now available."
                                                              },
                                                      @"requirements": @{
                                                              @"minimumOSVersion": @"9.0"
                                                              }
                                                      }
                                              };
    NSDictionary *mockData=@{ testServiceId:testOverviewUrl,
                              testOverviewUrl:@{
                                      @"success": sampleDictionary
                                      }
                              };
    restMock.mockData = mockData;
    
    AIAppUpdate *lappUpdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    [lappUpdate setValue:restMock forKey:@"RESTClient"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Refreshtestappupdate"];
    [lappUpdate refresh:^(AIAppUpdateRefreshStatus status, NSError *error) {
        [expectation fulfill];
        XCTAssertNil([lappUpdate getMinimumVersion]);
        XCTAssertNil(error);
        XCTAssertTrue(status == AIAppUpdateRefreshStatusSuccess);
        
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
   
}

-(void)testRefreshAppUpdateWithrareMinimumVersion{
    
    [self removeFile];
    AIRESTMock *restMock = [[AIRESTMock alloc]init];
    NSDictionary *sampleDictionary = @{@"iOS": @{
                                               @"version": @{
                                                       @"minimumVersion": @"0.5.0-SNAPSHOT.1",
                                                       @"deprecatedVersion": @"3.0.0",
                                                       @"deprecationDate": @"2050-07-12",
                                                       @"currentVersion": @"300.1.0"
                                                       },
                                               @"messages": @{
                                                       @"minimumVersionMessage": @"The current version is outdated in. Please update the app.",
                                                       @"sunsetVersionMessage": @"The current version will be outdated by 2050-07-12. Please update the app soon.",
                                                       @"currentVersionMessage": @"A new version is now available."
                                                       },
                                               @"requirements": @{
                                                       @"minimumOSVersion": @"9.0"
                                                       }
                                               }
                                       };
    NSDictionary *mockData=@{ testServiceId:testOverviewUrl,
                              testOverviewUrl:@{
                                      @"success": sampleDictionary
                                      }
                              };
    restMock.mockData = mockData;
    
    AIAppUpdate *lappUpdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    [lappUpdate setValue:restMock forKey:@"RESTClient"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Refreshtestappupdate"];
    [lappUpdate refresh:^(AIAppUpdateRefreshStatus status, NSError *error) {
        [expectation fulfill];
        XCTAssertNotNil([lappUpdate getMinimumVersion]);
        XCTAssertNil(error);
        XCTAssertFalse([lappUpdate isDeprecated]);
        XCTAssertTrue(status == AIAppUpdateRefreshStatusSuccess);
        
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
}
-(void)testRefreshAppUpdateWithEmptyMinimumVersion{
    
    [self removeFile];
    AIRESTMock *restMock = [[AIRESTMock alloc]init];
    NSDictionary *sampleDictionary = @{@"iOS": @{
                                               @"version": @{
                                                       //@"minimumVersion": @"",
                                                       @"deprecatedVersion": @"3.0.0",
                                                       @"deprecationDate": @"2050-07-12",
                                                       @"currentVersion": @"300.1.0"
                                                       },
                                               @"messages": @{
                                                       @"minimumVersionMessage": @"The current version is outdated in. Please update the app.",
                                                       @"sunsetVersionMessage": @"The current version will be outdated by 2050-07-12. Please update the app soon.",
                                                       @"currentVersionMessage": @"A new version is now available."
                                                       },
                                               @"requirements": @{
                                                       @"minimumOSVersion": @"9.0"
                                                       }
                                               }
                                       };
    NSDictionary *mockData=@{ testServiceId:testOverviewUrl,
                              testOverviewUrl:@{
                                      @"success": sampleDictionary
                                      }
                              };
    restMock.mockData = mockData;
    
    AIAppUpdate *lappUpdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    [lappUpdate setValue:restMock forKey:@"RESTClient"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Refreshtestappupdate"];
    [lappUpdate refresh:^(AIAppUpdateRefreshStatus status, NSError *error) {
        [expectation fulfill];
        XCTAssertNil([lappUpdate getMinimumVersion]);
        XCTAssertNil(error);
        XCTAssertFalse([lappUpdate isDeprecated]);
        XCTAssertTrue(status == AIAppUpdateRefreshStatusSuccess);
        
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
}

//test Refresh with nil service url
-(void)testRefreshWithoutServiceUrl{
    //mock SD
    id mockSD = [OCMockObject partialMockForObject:appInfra.serviceDiscovery];
    appInfra.serviceDiscovery = mockSD;
    
    [[[mockSD expect]andDo:^(NSInvocation *invocation) {
        void (^completionHandler)(NSDictionary<NSString*,AISDService*> *services,NSError *error);
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(nil, nil);
    }]getServicesWithCountryPreference:@[testServiceId] withCompletionHandler:OCMOCK_ANY replacement:nil];
    
    
    AIAppUpdate *lappUpdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Refreshtestappupdate"];
    [lappUpdate refresh:^(AIAppUpdateRefreshStatus status, NSError *error) {        
        NSLog(@"error: %@",error.localizedDescription);
        [expectation fulfill];
        XCTAssertTrue(status == AIAppUpdateRefreshStatusFailed);
        XCTAssertEqualObjects([error localizedDescription], @"Service discovery cannot find any url");
        
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        
        [mockSD verify];
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
   
}
//test Refresh with nil serviceid
-(void)testRefreshWithoutAppUpdateServiceIDKey{
    //mock appconfig
    id mockAppConfig = [OCMockObject partialMockForObject:appInfra.appConfig];
    appInfra.appConfig = mockAppConfig;
//    [[[mockAppConfig expect] andReturn:testServiceId] getPropertyForKey:@"appUpdate.serviceId" group:OCMOCK_ANY error:[OCMArg anyObjectRef]];
    
    NSUInteger expectedCode = 25;
    NSError *error=  [NSError errorWithDomain:NSURLErrorDomain code:expectedCode userInfo:nil];
    [[[mockAppConfig expect] andReturn:nil] getPropertyForKey:@"appUpdate.serviceId" group:OCMOCK_ANY error:((NSError __autoreleasing **)[OCMArg setTo:error])];
    
    
    AIAppUpdate *lappUpdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Refreshtestappupdate"];
    [lappUpdate refresh:^(AIAppUpdateRefreshStatus status, NSError *error) {
        
        XCTAssertTrue(status == AIAppUpdateRefreshStatusFailed);
        XCTAssertTrue(error.code == expectedCode);
        [mockAppConfig verify];
        [expectation fulfill];

    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        

        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
    
}


//test deprecated
-(void)testDeprecated{
    [self removeFile];
    NSString *testMinimumVersionMessage = @"test minimum version message";
    NSDictionary *sampleDictionary = @{
                                               @"version": @{
                                                       @"minimumVersion": @"1001.0.0",
                                                       @"deprecatedVersion": @"1002.0.0",
                                                       @"deprecationDate": @"2050-07-12",
                                                       @"currentVersion": @"1003.1.0"
                                                       },
                                               @"messages": @{
                                                       @"minimumVersionMessage": testMinimumVersionMessage,
                                                       @"sunsetVersionMessage": @"The current version will be outdated by 2050-07-12. Please update the app soon.",
                                                       @"currentVersionMessage": @"A new version is now available."
                                                       },
                                               @"requirements": @{
                                                       @"minimumOSVersion": @"9.0"
                                                       }
                                       };

    [self saveSampleDictionary:sampleDictionary];
    
    
    AIAppUpdate *lappupdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    XCTAssertTrue( [lappupdate isDeprecated]);
    XCTAssertEqualObjects(testMinimumVersionMessage, [lappupdate getDeprecateMessage]);
    
}
//test deprecated for not deprecatedApplication
-(void)testDeprecatedForFalse{
    [self removeFile];
    NSString *testMinimumVersionMessage = @"test minimum version message";
    NSDictionary *sampleDictionary = @{
                                       @"version": @{
                                               @"minimumVersion":[self currentVersion],
                                               @"deprecatedVersion": @"1002.0.0",
                                               @"deprecationDate": @"2050-07-12",
                                               @"currentVersion": @"1003.1.0"
                                               },
                                       @"messages": @{
                                               @"minimumVersionMessage": testMinimumVersionMessage,
                                               @"sunsetVersionMessage": @"The current version will be outdated by 2050-07-12. Please update the app soon.",
                                               @"currentVersionMessage": @"A new version is now available."
                                               },
                                       @"requirements": @{
                                               @"minimumOSVersion": @"9.0"
                                               }
                                       };
    
    [self saveSampleDictionary:sampleDictionary];
    
    
    AIAppUpdate *lappupdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    XCTAssertFalse( [lappupdate isDeprecated]);
    
}


//test deprecated since tobedeprecatedDate is over
-(void)testDeprecatedAfterTobeDeprecateddate{
    [self removeFile];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *pastDate = [formatter stringFromDate: [NSDate dateWithTimeIntervalSinceNow:-60*60*48]];

    NSString *testMinimumVersionMessage = @"test minimum version message";
    NSDictionary *sampleDictionary = @{
                                       @"version": @{
                                               @"minimumVersion": @"0.0.0",
                                               @"deprecatedVersion": [self greaterVersion:nil],
                                               @"deprecationDate": pastDate,
                                               @"currentVersion": @"1003.1.0"
                                               },
                                       @"messages": @{
                                               @"minimumVersionMessage": testMinimumVersionMessage,
                                               @"sunsetVersionMessage": @"The current version will be outdated by 2050-07-12. Please update the app soon.",
                                               @"currentVersionMessage": @"A new version is now available."
                                               },
                                       @"requirements": @{
                                               @"minimumOSVersion": @"9.0"
                                               }
                                       };
    
    [self saveSampleDictionary:sampleDictionary];
    
    
    AIAppUpdate *lappupdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    XCTAssertTrue( [lappupdate isDeprecated]);
    XCTAssertEqualObjects(testMinimumVersionMessage, [lappupdate getDeprecateMessage]);
    
}

-(void)testDeprecatedAfterTobeDeprecateddateWithInvalidDate{
    [self removeFile];
    
    NSString *testMinimumVersionMessage = @"test minimum version message";
    NSDictionary *sampleDictionary = @{
                                       @"version": @{
                                               @"minimumVersion": @"0.0.0",
                                               @"deprecatedVersion": [self greaterVersion:nil],
                                               @"deprecationDate": @"blahblah",
                                               @"currentVersion": @"1003.1.0"
                                               },
                                       @"messages": @{
                                               @"minimumVersionMessage": testMinimumVersionMessage,
                                               @"sunsetVersionMessage": @"The current version will be outdated by 2050-07-12. Please update the app soon.",
                                               @"currentVersionMessage": @"A new version is now available."
                                               },
                                       @"requirements": @{
                                               @"minimumOSVersion": @"9.0"
                                               }
                                       };
    
    [self saveSampleDictionary:sampleDictionary];
    
    
    AIAppUpdate *lappupdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    XCTAssertFalse( [lappupdate isDeprecated]);
    XCTAssertEqualObjects(testMinimumVersionMessage, [lappupdate getDeprecateMessage]);
    
}


//test deprecated since tobedeprecatedDate is not over
-(void)testDeprecatedBeforeTobeDeprecateddate{
    [self removeFile];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *futureDate = [formatter stringFromDate: [NSDate dateWithTimeIntervalSinceNow:60*60*48]];
    
    NSString *testMinimumVersionMessage = @"test minimum version message";
    NSDictionary *sampleDictionary = @{
                                       @"version": @{
                                               @"minimumVersion": @"0.0.0",
                                               @"deprecatedVersion": [self greaterVersion:nil],
                                               @"deprecationDate": futureDate,
                                               @"currentVersion": @"1003.1.0"
                                               },
                                       @"messages": @{
                                               @"minimumVersionMessage": testMinimumVersionMessage,
                                               @"sunsetVersionMessage": @"The current version will be outdated by 2050-07-12. Please update the app soon.",
                                               @"currentVersionMessage": @"A new version is now available."
                                               },
                                       @"requirements": @{
                                               @"minimumOSVersion": @"9.0"
                                               }
                                       };
    
    [self saveSampleDictionary:sampleDictionary];
    
    
    AIAppUpdate *lappupdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    XCTAssertFalse( [lappupdate isDeprecated]);
    XCTAssertEqualObjects(testMinimumVersionMessage, [lappupdate getDeprecateMessage]);
    
}

//test isToBedeprecated
-(void)testTobeDeprecatedYES{
    [self removeFile];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *futureDate = [formatter stringFromDate: [NSDate dateWithTimeIntervalSinceNow:60*60*48]];
    
    NSString *testDeprecatedMessage = @"test deprecated version message";
    NSDictionary *sampleDictionary = @{
                                       @"version": @{
                                               @"minimumVersion": @"0.0.0",
                                               @"deprecatedVersion": [self greaterVersion:nil],
                                               @"deprecationDate": futureDate,
                                               @"currentVersion": @"1003.1.0"
                                               },
                                       @"messages": @{
                                               @"minimumVersionMessage": @"minimumVersionMessage",
                                               @"deprecatedVersionMessage": testDeprecatedMessage,
                                               @"currentVersionMessage": @"A new version is now available."
                                               },
                                       @"requirements": @{
                                               @"minimumOSVersion": @"9.0"
                                               }
                                       };
    
    [self saveSampleDictionary:sampleDictionary];
    
    
    AIAppUpdate *lappupdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    XCTAssertFalse( [lappupdate isDeprecated]);
    XCTAssertTrue( [lappupdate isToBeDeprecated]);
    XCTAssertEqualObjects(testDeprecatedMessage, [lappupdate getToBeDeprecatedMessage]);
}
-(void)testTobeDeprecatedYESForSameVersion{
    [self removeFile];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *futureDate = [formatter stringFromDate: [NSDate dateWithTimeIntervalSinceNow:60*60*48]];
    
    NSString *testDeprecatedMessage = @"test deprecated version message";
    NSDictionary *sampleDictionary = @{
                                       @"version": @{
                                               @"minimumVersion": @"0.0.0",
                                               @"deprecatedVersion": [self currentVersion],
                                               @"deprecationDate": futureDate,
                                               @"currentVersion": @"1003.1.0"
                                               },
                                       @"messages": @{
                                               @"minimumVersionMessage": @"minimumVersionMessage",
                                               @"deprecatedVersionMessage": testDeprecatedMessage,
                                               @"currentVersionMessage": @"A new version is now available."
                                               },
                                       @"requirements": @{
                                               @"minimumOSVersion": @"9.0"
                                               }
                                       };
    
    [self saveSampleDictionary:sampleDictionary];
    
    
    AIAppUpdate *lappupdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    XCTAssertFalse( [lappupdate isDeprecated]);
    XCTAssertTrue( [lappupdate isToBeDeprecated]);
    XCTAssertEqualObjects(testDeprecatedMessage, [lappupdate getToBeDeprecatedMessage]);
}
-(void)testTobeDeprecatedNO{
    [self removeFile];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *futureDate = [formatter stringFromDate: [NSDate dateWithTimeIntervalSinceNow:60*60*48]];
    
    NSString *testDeprecatedMessage = @"test deprecated version message";
    NSDictionary *sampleDictionary = @{
                                       @"version": @{
                                               @"minimumVersion": @"0.0.0",
                                               @"deprecatedVersion": [self lessVersion:nil],
                                               @"deprecationDate": futureDate,
                                               @"currentVersion": @"1003.1.0"
                                               },
                                       @"messages": @{
                                               @"minimumVersionMessage": @"minimumVersionMessage",
                                               @"deprecatedVersionMessage": testDeprecatedMessage,
                                               @"currentVersionMessage": @"A new version is now available."
                                               },
                                       @"requirements": @{
                                               @"minimumOSVersion": @"9.0"
                                               }
                                       };
    
    [self saveSampleDictionary:sampleDictionary];
    
    
    AIAppUpdate *lappupdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    XCTAssertFalse( [lappupdate isDeprecated]);
    XCTAssertFalse( [lappupdate isToBeDeprecated]);
    XCTAssertEqualObjects(testDeprecatedMessage, [lappupdate getToBeDeprecatedMessage]);
}

-(void)testGetMinimumOsMessage {
    [self removeFile];
    
    NSString *testMinimumOsMessage = @"You need to update os greater than 9.0 to run this application";
    NSDictionary *sampleDictionary = @{
                                       @"version": @{
                                               @"minimumVersion": @"0.0.0",
                                               @"deprecatedVersion": @"0.0.0",
                                               @"deprecationDate": @"2017-08-12",
                                               @"currentVersion": @"1003.1.0"
                                               },
                                       @"messages": @{
                                               @"minimumVersionMessage": @"minimumVersionMessage",
                                               @"deprecatedVersionMessage": @"asdsd",
                                               @"currentVersionMessage": @"test deprecated version message",
                                               @"minimumOSMessage": testMinimumOsMessage
                                               },
                                       @"requirements": @{
                                               @"minimumOSVersion": @"9.0"
                                               }
                                       };
    [self saveSampleDictionary:sampleDictionary];
    AIAppUpdate *lappupdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    XCTAssertEqualObjects(testMinimumOsMessage, [lappupdate getMinimumOsMessage]);
}

-(void)testIsUpdateAvailable{
    [self removeFile];
    NSString *testUpdateAvailablemsg = @"test update available message";
    NSDictionary *sampleDictionary = @{
                                       @"version": @{
                                               @"minimumVersion": @"0.0.0",
                                               @"deprecatedVersion": @"0.0.0",
                                               @"deprecationDate": @"2017-08-12",
                                               @"currentVersion": @"1003.1.0"
                                               },
                                       @"messages": @{
                                               @"minimumVersionMessage": @"minimumVersionMessage",
                                               @"deprecatedVersionMessage": @"asdsd",
                                               @"currentVersionMessage": testUpdateAvailablemsg
                                               },
                                       @"requirements": @{
                                               @"minimumOSVersion": @"9.0"
                                               }
                                       };
    
    [self saveSampleDictionary:sampleDictionary];
    
    
    AIAppUpdate *lappupdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    XCTAssertTrue( [lappupdate isUpdateAvailable]);
    XCTAssertEqualObjects(testUpdateAvailablemsg, [lappupdate getUpdateMessage]);
   
}

-(void)testIsUpdateAvailableFalse{
    [self removeFile];
    NSString *testUpdateAvailablemsg = @"test update available message";
    NSDictionary *sampleDictionary = @{
                                       @"version": @{
                                               @"minimumVersion": @"0.0.0",
                                               @"deprecatedVersion": @"0.0.0",
                                               @"deprecationDate": @"2017-08-12",
                                               @"currentVersion": [self lessVersion:nil]
                                               },
                                       @"messages": @{
                                               @"minimumVersionMessage": @"minimumVersionMessage",
                                               @"deprecatedVersionMessage": @"asdsd",
                                               @"currentVersionMessage": testUpdateAvailablemsg
                                               },
                                       @"requirements": @{
                                               @"minimumOSVersion": @"9.0"
                                               }
                                       };
    
    [self saveSampleDictionary:sampleDictionary];
    
    
    AIAppUpdate *lappupdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    XCTAssertFalse( [lappupdate isUpdateAvailable]);
    
}

-(void)testIsUpdateAvailableFalseForsameVersion{
    [self removeFile];
    NSString *testUpdateAvailablemsg = @"test update available message";
    NSDictionary *sampleDictionary = @{
                                       @"version": @{
                                               @"minimumVersion": @"0.0.0",
                                               @"deprecatedVersion": @"0.0.0",
                                               @"deprecationDate": @"2017-08-12",
                                               @"currentVersion": [self currentVersion]
                                               },
                                       @"messages": @{
                                               @"minimumVersionMessage": @"minimumVersionMessage",
                                               @"deprecatedVersionMessage": @"asdsd",
                                               @"currentVersionMessage": testUpdateAvailablemsg
                                               },
                                       @"requirements": @{
                                               @"minimumOSVersion": @"9.0"
                                               }
                                       };
    
    [self saveSampleDictionary:sampleDictionary];
    
    
    AIAppUpdate *lappupdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    XCTAssertFalse( [lappupdate isUpdateAvailable]);
    
}


-(void)testISUpdateAvailableForSameVersion{
    [self removeFile];
    NSString *testUpdateAvailablemsg = @"test update available message";
    NSDictionary *sampleDictionary = @{
                                       @"version": @{
                                               @"minimumVersion": @"0.0.0",
                                               @"deprecatedVersion": @"0.0.0",
                                               @"deprecationDate": @"2017-08-12",
                                               @"currentVersion": [self currentVersion]
                                               },
                                       @"messages": @{
                                               @"minimumVersionMessage": @"minimumVersionMessage",
                                               @"deprecatedVersionMessage": @"asdsd",
                                               @"currentVersionMessage": testUpdateAvailablemsg
                                               },
                                       @"requirements": @{
                                               @"minimumOSVersion": @"9.0"
                                               }
                                       };
    
    [self saveSampleDictionary:sampleDictionary];
    
    
    AIAppUpdate *lappupdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    XCTAssertFalse( [lappupdate isUpdateAvailable]);
    XCTAssertEqualObjects(testUpdateAvailablemsg, [lappupdate getUpdateMessage]);
    
}

-(void)testgetOSVersion{
    [self removeFile];
    NSDictionary *sampleDictionary = @{
                                       @"version": @{
                                               @"minimumVersion": @"0.0.0",
                                               @"deprecatedVersion": @"0.0.0",
                                               @"deprecationDate": @"2017-08-12",
                                               @"currentVersion": @"0.0.0"
                                               },
                                       @"messages": @{
                                               @"minimumVersionMessage": @"minimumVersionMessage",
                                               @"deprecatedVersionMessage": @"asdsd",
                                               @"currentVersionMessage": @"adkd"
                                               },
                                       @"requirements": @{
                                               @"minimumOSVersion": @"9.0"
                                               }
                                       };
    
    [self saveSampleDictionary:sampleDictionary];
    
    
    AIAppUpdate *lappupdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    XCTAssertEqualObjects(@"9.0", [lappupdate getMinimumOsVersion]);
    
}

-(void)testgetMinimumVersion{
    [self removeFile];
    NSDictionary *sampleDictionary = @{
                                       @"version": @{
                                               @"minimumVersion": @"1.2.3",
                                               @"deprecatedVersion": @"0.0.0",
                                               @"deprecationDate": @"2017-08-12",
                                               @"currentVersion": @"0.0.0"
                                               },
                                       @"messages": @{
                                               @"minimumVersionMessage": @"minimumVersionMessage",
                                               @"deprecatedVersionMessage": @"asdsd",
                                               @"currentVersionMessage": @"adkd"
                                               },
                                       @"requirements": @{
                                               @"minimumOSVersion": @"9.0"
                                               }
                                       };
    
    [self saveSampleDictionary:sampleDictionary];
    
    
    AIAppUpdate *lappupdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    XCTAssertEqualObjects(@"1.2.3", [lappupdate getMinimumVersion]);
    
}

-(void)testgetDeprecatedDate{
    [self removeFile];
    NSString *dateString = @"2017-08-12";
    NSDictionary *sampleDictionary = @{
                                       @"version": @{
                                               @"minimumVersion": @"1.2.3",
                                               @"deprecatedVersion": @"0.0.0",
                                               @"deprecationDate": dateString,
                                               @"currentVersion": @"0.0.0"
                                               },
                                       @"messages": @{
                                               @"minimumVersionMessage": @"minimumVersionMessage",
                                               @"deprecatedVersionMessage": @"asdsd",
                                               @"currentVersionMessage": @"adkd"
                                               },
                                       @"requirements": @{
                                               @"minimumOSVersion": @"9.0"
                                               }
                                       };
    
    [self saveSampleDictionary:sampleDictionary];
    
    
    AIAppUpdate *lappupdate = [[AIAppUpdate alloc]initWithAppinfra:appInfra];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:dateString];
    NSDate *toBeDeprecatedDate= [lappupdate getToBeDeprecatedDate];
    
   NSComparisonResult result =   [date compare:toBeDeprecatedDate];
    XCTAssertTrue(result == NSOrderedSame);
    
}

//MARK : -  helper methods
-(void)saveSampleDictionary:(NSDictionary*)dictionary{
    [AIUtility saveDictionary:dictionary toPath:@"appupdateinfo"];
}

-(void)removeFile{
     NSString *path = [[AIUtility appInfraDocumentsDirectory] stringByAppendingPathComponent:@"/appupdateinfo"];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

-(NSString*)lessVersion:(NSString*)version{
    if (!version) {
        version = [self currentVersion];
    }
    version = [NSString stringWithFormat:@"0.%@",version];
    return version;
}

-(NSString*)greaterVersion:(NSString*)version{
    if (!version) {
        version = [self currentVersion];
    }
    version = [NSString stringWithFormat:@"1000.%@",version];
    return version;

}

-(NSString*)currentVersion{
  
    NSString * appVersion = [[[NSBundle bundleForClass:[AIUtility class]]
 infoDictionary] objectForKey:@"CFBundleShortVersionString"];
   return  appVersion;
}
-(NSDictionary*)sampleDictionary{
    NSDictionary *sampleDictionary = @{@"iOS": @{
                                       @"version": @{
                                               @"minimumVersion": @"100.0.0",
                                               @"deprecatedVersion": @"200.0.0",
                                               @"deprecationDate": @"2050-07-12",
                                               @"currentVersion": @"300.1.0"
                                               },
                                       @"messages": @{
                                               @"minimumVersionMessage": @"The current version is outdated in. Please update the app.",
                                               @"sunsetVersionMessage": @"The current version will be outdated by 2050-07-12. Please update the app soon.",
                                               @"currentVersionMessage": @"A new version is now available."
                                               },
                                       @"requirements": @{
                                               @"minimumOSVersion": @"9.0"
                                               }
                                       }
                                       };
    return sampleDictionary;
}

@end
