//
//  AppIdentityTest.m
//  AppInfra
//
//  Created by Ravi Kiran HR on 6/1/16.
/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */
//

#import <XCTest/XCTest.h>
@import AppInfra;
#import "NSBundle+Bundle.h"
#import "AIAppInfra.h"
#import "AIAppInfraBuilder.h"


#define kMicrositeId @"appidentity.micrositeId"
#define kSector @"appidentity.sector"
#define kState @"appidentity.appState"
#define kSDEnvironment @"appidentity.serviceDiscoveryEnvironment"

@interface AIAppIdentityInterface ()

@property(nonatomic,strong)NSDictionary *dictAppIdentity;
@property(nonatomic,strong) AIAppInfra *aiAppInfra;

-(void)validateAppIdentity:(NSDictionary *) appIdentity;
-(BOOL)isValidAppVersion:(NSString *)appVersion;
-(NSString *)getAppStateString;

@end

@interface AppIdentityTest : XCTestCase
{
    AIAppIdentityInterface * appIdentity;
    AIAppInfra * appInfra;
    
}
@end

@implementation AppIdentityTest

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
    appInfra = [AppIdentityTest sharedAppInfra];
    appIdentity = [[AIAppIdentityInterface alloc]initWithAppInfra:appInfra];
}

-(void)testgetMicrositeId {
    NSString * micrositeId = [appIdentity getMicrositeId];
    XCTAssertEqualObjects(micrositeId, @"77000", "micrositeId doesn't match");
}

-(void)testgetAppState {
    AIAIAppState appState = [appIdentity getAppState];
    XCTAssertEqual(AIAIAppStateDEVELOPMENT, appState);
    
    NSMutableDictionary * newDict = [appIdentity.dictAppIdentity mutableCopy];
    
    [newDict setObject:@"TEST" forKey:kState];
    appIdentity.dictAppIdentity = newDict;
    appState = [appIdentity getAppState];
    XCTAssertEqual(AIAIAppStateDEVELOPMENT, appState);
    
    [newDict setObject:@"STAGING" forKey:kState];
    appIdentity.dictAppIdentity = newDict;
    appState = [appIdentity getAppState];
    XCTAssertEqual(AIAIAppStateDEVELOPMENT, appState);
    
    [newDict setObject:@"ACCEPTANCE" forKey:kState];
    appIdentity.dictAppIdentity = newDict;
    appState = [appIdentity getAppState];
    XCTAssertEqual(AIAIAppStateDEVELOPMENT, appState);
    
    [newDict setObject:@"PRODUCTION" forKey:kState];
    appIdentity.dictAppIdentity = newDict;
    appState = [appIdentity getAppState];
    XCTAssertEqual(AIAIAppStatePRODUCTION, appState);
    
    [newDict setObject:@"INVALID" forKey:kState];
    appIdentity.dictAppIdentity = newDict;
    appState = [appIdentity getAppState];
    XCTAssertEqual(AIAIAppStateDEVELOPMENT, appState);
}

-(void)testgetSector {
    NSString * sector = [appIdentity getSector];
    XCTAssertEqualObjects(sector, @"b2c", "sector doesn't match");
}

-(void)testgetServiceDiscoveryEnvironment {
    
    NSMutableDictionary * newDict = [appIdentity.dictAppIdentity mutableCopy];
    newDict[@"appidentity.appState"] = @"PRODUCTION";
    appIdentity.dictAppIdentity = newDict;
    NSString * sde = [appIdentity getServiceDiscoveryEnvironment];
    XCTAssertEqualObjects(sde, @"PRODUCTION", "serviceDiscoveryEnvironment doesn't match");
    
    [newDict setObject:@"STAGING" forKey:kSDEnvironment];
    appIdentity.dictAppIdentity = newDict;
    sde = [appIdentity getServiceDiscoveryEnvironment];
    XCTAssertEqualObjects(sde, @"STAGING", "serviceDiscoveryEnvironment doesn't match");
    
    [newDict setObject:@"STAGING" forKey:kSDEnvironment];
    appIdentity.dictAppIdentity = newDict;
    XCTAssertNoThrow([appIdentity getServiceDiscoveryEnvironment]);
}

-(void)testgetAppStateString {
    NSString* appState = [appIdentity getAppStateString];
    XCTAssertEqualObjects(@"DEVELOPMENT", appState);
    
    NSMutableDictionary * newDict = [appIdentity.dictAppIdentity mutableCopy];
    
    [newDict setObject:@"TEST" forKey:kState];
    appIdentity.dictAppIdentity = newDict;
    appState = [appIdentity getAppStateString];
    XCTAssertEqualObjects(@"DEVELOPMENT", appState);
    
    [newDict setObject:@"STAGING" forKey:kState];
    appIdentity.dictAppIdentity = newDict;
    appState = [appIdentity getAppStateString];
    XCTAssertEqualObjects(@"DEVELOPMENT", appState);
    
    [newDict setObject:@"ACCEPTANCE" forKey:kState];
    appIdentity.dictAppIdentity = newDict;
    appState = [appIdentity getAppStateString];
    XCTAssertEqualObjects(@"DEVELOPMENT", appState);
    
    [newDict setObject:@"PRODUCTION" forKey:kState];
    appIdentity.dictAppIdentity = newDict;
    appState = [appIdentity getAppStateString];
    XCTAssertEqualObjects(@"PRODUCTION", appState);
    
    [newDict setObject:@"$#!$#!$@3" forKey:kState];
    appIdentity.dictAppIdentity = newDict;
    appState = [appIdentity getAppStateString];
    XCTAssertEqualObjects(@"DEVELOPMENT", appState);
}

-(void)testgetAppName {
    NSString * name = [appIdentity getAppName];
    NSString * nameTest = [[[NSBundle bundleForClass:[self class]] infoDictionary]objectForKey:[NSString stringWithFormat:@"%@",kCFBundleNameKey]];
    XCTAssertEqualObjects(name, nameTest, "app name doesn't match");
}

-(void)testgetAppVersion {
    XCTAssertNoThrow([appIdentity getAppVersion],@"should not throw exception");
}

-(void)testgetLocalizedAppName {
    NSString * localizedName = [appIdentity getLocalizedAppName];
    NSString * localizedNameTest = [[[NSBundle bundleForClass:[self class]] localizedInfoDictionary]
                                    objectForKey:@"CFBundleDisplayName"];
    if (localizedNameTest == nil) {
        localizedNameTest = @"";
    }
    XCTAssertEqualObjects(localizedName, localizedNameTest, "localizedName doesn't match");
}

-(void)testisValidAppVersion {
    XCTAssertFalse([appIdentity isValidAppVersion:@"1.3"]);
    XCTAssertFalse([appIdentity isValidAppVersion:@"1"]);
    XCTAssertFalse([appIdentity isValidAppVersion:@"1.3ds"]);
    //    XCTAssertFalse([appIdentity isValidAppVersion:@"1.3.6$"]);
    
    XCTAssertTrue([appIdentity isValidAppVersion:@"1.3.5"]);
    XCTAssertTrue([appIdentity isValidAppVersion:@"1.2.3_rc1"]);
    XCTAssertTrue([appIdentity isValidAppVersion:@"1.2.3-rc1"]);
    XCTAssertFalse([appIdentity isValidAppVersion:@"1.3.5.5"]);
    XCTAssertFalse([appIdentity isValidAppVersion:@"blahblah.1.3.5"]);
}

@end
