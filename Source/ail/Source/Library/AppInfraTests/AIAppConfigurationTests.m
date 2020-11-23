//
//  AIAppConfigurationTests.m
//  AppInfra
//
//  Created by leslie on 01/08/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AIAppConfigurationProtocol.h"
#import "AIAppConfiguration.h"
#import "AIStorageProvider.h"
#import "AIAppInfra.h"
#import "AIAppInfraBuilder.h"
#import "AILogging.h"
#import "NSBundle+Bundle.h"
#import <OCMock/OCMock.h>
#import "AIServiceDiscovery.h"
#import "AIRESTClientInterface.h"

#define kErrorDomainAppConfig @"com.philips.platform.appinfra.AppConfiguration"
#define kTestAppConfigSecureKey @"ail.app_config"
#define kTestAppDynamicConfigSecureStoreKey @"ail.app_dynamic_config"
@interface AIAppConfiguration()

@property(nonatomic,strong)NSDictionary *configuration;
@property(nonatomic,strong)NSDictionary *staticConfiguration;
@property(nonatomic,strong)NSDictionary *cloudConfiguration;

@property(nonatomic,strong) AIAppInfra *aiAppInfra;

-(NSDictionary *)getSavedConfig;
-(void)storeConfigSecurely:(NSDictionary *)config;
-(id)uppercaseKeysForDictionary:(NSDictionary*)inputData;
-(void)downloadConfigFromCloud:(void(^)(AIACRefreshResult refreshResult,NSError * error))completionHandler;
-(NSString *)cloudConfigPath;
-(NSDictionary*)removeCommonKeysforDictionary:(NSDictionary*)dictionary1
                               withDictionary:(NSDictionary*)dictionary2;
-(NSDictionary *)readAppConfigurationFromFile;
-(void)migrateIfNeeded;
-(BOOL)isValidValue:(id)value;

@end

@interface AIAppConfigurationTests : XCTestCase
{
    AIAppConfiguration * appConfiguration;
    AIStorageProvider * storageProvider;
    AIAppInfra * appInfra;
}
@end

@implementation AIAppConfigurationTests

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
    
    appInfra = [AIAppConfigurationTests sharedAppInfra];
    appConfiguration = [[AIAppConfiguration alloc]initWithAppInfra:appInfra];
    storageProvider = appInfra.storageProvider;
}

#pragma mark get test cases

//getting default configuration
-(void)testGetProperty {
    NSError * error;
    NSString * value = (NSString *)[appConfiguration getPropertyForKey:@"MicrositeID" group:@"AI" error:&error];
    XCTAssertNotNil(value, "value should not be nil");
    XCTAssertNil(error, "error should be nil");
    XCTAssertEqualObjects(value, @77000,"fetching property is not working");
}

//getting default configuration
-(void)testGetSavedConfig {
    
    NSDictionary * initialValue = [appConfiguration getSavedConfig];
    XCTAssertNotNil(initialValue, "value should not be nil");
    
    NSString *jsonPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"AppConfig" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:jsonPath];
    NSError * error;
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    json = [appConfiguration uppercaseKeysForDictionary:json];
    XCTAssertNil(error);
    [appConfiguration storeConfigSecurely:json];
    
    NSDictionary * value = [appConfiguration getSavedConfig];
    XCTAssertNotNil(value, "value should not be nil");
    XCTAssertEqualObjects(value, json,"fetching config is not working");
}

//getting default configuration for wrong group
-(void)testGetPropertyWrongGroup {
    NSError * error;
    
    NSString * value = (NSString *)[appConfiguration getPropertyForKey:@"Development" group:@"A" error:&error];
    XCTAssertNil(value, "value should be nil");
    XCTAssertNotNil(error, "error should not be nil");
    XCTAssertEqualObjects(error.domain, kErrorDomainAppConfig, "error domain not correct");
    XCTAssertEqual(error.code, 4, "error code not correct");
    XCTAssertEqualObjects([error.userInfo valueForKey:@"NSLocalizedDescription"], @"The given group doesn't exists");
}

//getting default configuration for wrong key
-(void)testGetPropertyWrongKey {
    NSError * error;
    
    NSString * value = (NSString *)[appConfiguration getPropertyForKey:@"A1" group:@"UR" error:&error];
    XCTAssertNil(value, "value should be nil");
    XCTAssertNotNil(error, "error should not be nil");
    XCTAssertEqualObjects(error.domain, kErrorDomainAppConfig, "error domain not correct");
    XCTAssertEqual(error.code, 5, "error code not correct");
    XCTAssertEqualObjects([error.userInfo valueForKey:@"NSLocalizedDescription"], @"The given key doesn't exists", "error description not correct");
}

//getting default configuration for empty key
-(void)testGetPropertyInvalidParameter {
    
    XCTAssertThrowsSpecificNamed([appConfiguration getPropertyForKey:@"A" group:@"" error:nil], NSException, NSInvalidArgumentException, "should throw exception");
    
    XCTAssertThrowsSpecificNamed([appConfiguration getPropertyForKey:@"A" group:@" " error:nil], NSException, NSInvalidArgumentException, "should throw exception");
    
    XCTAssertThrowsSpecificNamed([appConfiguration getPropertyForKey:@"" group:@"UR" error:nil], NSException, NSInvalidArgumentException, "should throw exception");
    
    XCTAssertThrowsSpecificNamed([appConfiguration getPropertyForKey:@" " group:@"UR" error:nil], NSException, NSInvalidArgumentException, "should throw exception");
    
    XCTAssertThrowsSpecificNamed([appConfiguration getPropertyForKey:nil group:nil error:nil], NSException, NSInvalidArgumentException, "should throw exception");
    
    XCTAssertThrowsSpecificNamed([appConfiguration getPropertyForKey:@"eweq&%^&^%" group:@"UR" error:nil], NSException, NSInvalidArgumentException, "should throw exception");
    
    XCTAssertThrowsSpecificNamed([appConfiguration getPropertyForKey:@"dsdaA233)" group:@"UR" error:nil], NSException, NSInvalidArgumentException, "should throw exception");
    
    XCTAssertNoThrow([appConfiguration getPropertyForKey:@"ewe._-A898" group:@"UR" error:nil],"should not throw exception");
    
}
//Testing get default config

-(void)testGetDefaultProperty {
    NSError * setError;
    BOOL success = [appConfiguration setPropertyForKey:@"Development" group:@"UR" value:@"modifiedValue" error:&setError];
    XCTAssertTrue(success);
    XCTAssertNil(setError, "error should be nil");
    NSError * getError;
    NSString * newValue = [appConfiguration getPropertyForKey:@"Development" group:@"UR" error:&getError];
    XCTAssertNil(getError,"error should be nil");
    XCTAssertNotNil(newValue, "value should not be nil");
    XCTAssertEqualObjects(newValue, @"modifiedValue", "value should be equal");
    NSError * getDefaultError;
    NSString * defaultValue = [appConfiguration getDefaultPropertyForKey:@"Development" group:@"UR" error:&getDefaultError];
    XCTAssertNil(getDefaultError,"error should be nil");
    XCTAssertNotNil(defaultValue, "value should not be nil");
    XCTAssertEqualObjects(defaultValue, @"ad7nn99y2mv5berw5jxewzagazafbyhu", "value should be equal");
    
}

#define kAppIdentityGroupName @"appinfra"
-(void)testGetDefaultAIProperties {
    
    //micrositeId
    NSError * getDefaultmicrositeIdError;
    NSString * defaultmicrositeIdValue = [[appConfiguration getDefaultPropertyForKey:@"appidentity.micrositeId" group:kAppIdentityGroupName error:&getDefaultmicrositeIdError] stringValue];
    XCTAssertNil(getDefaultmicrositeIdError,"error should be nil");
    XCTAssertNotNil(defaultmicrositeIdValue, "value should not be nil");
    XCTAssertEqualObjects(defaultmicrositeIdValue,@"77000", "value should be equal");
    
    //sector
    NSError * getDefaultsectorError;
    NSString * defaultsectorValue = [appConfiguration getDefaultPropertyForKey:@"appidentity.sector" group:kAppIdentityGroupName error:&getDefaultsectorError];
    XCTAssertNil(getDefaultsectorError,"error should be nil");
    XCTAssertNotNil(defaultsectorValue, "value should not be nil");
    XCTAssertEqualObjects(defaultsectorValue,@"b2c", "value should be equal");
    
    //state
    NSError * getDefaultstateError;
    NSString * defaultstateValue = [appConfiguration getDefaultPropertyForKey:@"appidentity.appState" group:kAppIdentityGroupName error:&getDefaultstateError];
    XCTAssertNil(getDefaultstateError,"error should be nil");
    XCTAssertNotNil(defaultstateValue, "value should not be nil");
    XCTAssertEqualObjects(defaultstateValue,@"development", "value should be equal");
    
    
    //serviceDiscoveryEnvironment
    NSError * getDefaultserviceDiscoveryEnvironmentError;
    NSString * defaultserviceDiscoveryEnvironmentValue = [appConfiguration getDefaultPropertyForKey:@"appidentity.serviceDiscoveryEnvironment" group:kAppIdentityGroupName error:&getDefaultserviceDiscoveryEnvironmentError];
    XCTAssertNil(getDefaultserviceDiscoveryEnvironmentError,"error should be nil");
    XCTAssertNotNil(defaultserviceDiscoveryEnvironmentValue, "value should not be nil");
    XCTAssertEqualObjects(defaultserviceDiscoveryEnvironmentValue,@"production", "value should be equal");
    
}

-(void)testGetDefaultPropertyAfterModifying {
    
    NSError * setError;
    BOOL success = [appConfiguration setPropertyForKey:@"appidentity.sector" group:kAppIdentityGroupName value:@"new value" error:&setError];
    XCTAssertTrue(success);
    XCTAssertNil(setError, "error should be nil");
    NSError * getError;
    NSString * newValue = [appConfiguration getPropertyForKey:@"appidentity.sector" group:kAppIdentityGroupName error:&getError];
    XCTAssertNil(getError,"error should be nil");
    XCTAssertNotNil(newValue, "value should not be nil");
    XCTAssertEqualObjects(newValue, @"new value", "value should be equal");
    
    
    //sector
    NSError * getDefaultsectorError;
    NSString * defaultsectorValue = [appConfiguration getDefaultPropertyForKey:@"appidentity.sector" group:kAppIdentityGroupName error:&getDefaultsectorError];
    XCTAssertNil(getDefaultsectorError,"error should be nil");
    XCTAssertNotNil(defaultsectorValue, "value should not be nil");
    XCTAssertEqualObjects(defaultsectorValue,@"b2c", "value should be equal");
    
    
}

//testing no group configuration
-(void)testNoDataForGroup {
    NSString *jsonPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"ConfigNoDataForGroup" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:jsonPath];
    NSError * error;
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    XCTAssertNil(error);
    [storageProvider removeValueForKey:kTestAppConfigSecureKey];
    AIAppConfiguration * appConfig = [[AIAppConfiguration alloc]init];
    appConfig.configuration = json;
    appConfig.staticConfiguration = json;
    NSError * errorConfig;
    id value = [appConfig getPropertyForKey:@"A" group:@"AI" error:&errorConfig];
    
    XCTAssertNil(value, "value should be nil");
    XCTAssertNotNil(errorConfig, "error should not be nil");
    XCTAssertEqualObjects(errorConfig.domain, kErrorDomainAppConfig, "error domain not correct");
    XCTAssertEqual(errorConfig.code, 5, "error code not correct");
    XCTAssertEqualObjects([errorConfig.userInfo valueForKey:@"NSLocalizedDescription"], @"The given key doesn't exists", "error description not correct");
    
}

//testing no data for key
-(void)testNoDataForKey {
    NSString *jsonPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"ConfigNoDataForKey" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:jsonPath];
    NSError * error;
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    json = [appConfiguration uppercaseKeysForDictionary:json];
    XCTAssertNil(error);
    [storageProvider removeValueForKey:@"com.Philips.AppInfra.AppConfig"];
    AIAppConfiguration * appConfig = [[AIAppConfiguration alloc]init];
    appConfig.configuration = json;
    
    NSError * errorConfig;
    id value = [appConfig getPropertyForKey:@"MicrositeID" group:@"AI" error:&errorConfig];
    
    XCTAssertNil(value, "value should be nil");
    XCTAssertNotNil(errorConfig, "error should not be nil");
    XCTAssertEqualObjects(errorConfig.domain, kErrorDomainAppConfig, "error domain not correct");
    XCTAssertEqual(errorConfig.code, 3, "error code not correct");
    XCTAssertEqualObjects([errorConfig.userInfo valueForKey:@"NSLocalizedDescription"], @"No data found for the given key", "error description not correct");
    
}

#pragma mark set test cases

//test for setting property value
-(void)testSetProperty {
    NSError * setError;
    BOOL success = [appConfiguration setPropertyForKey:@"Development" group:@"UR" value:@"new value" error:&setError];
    XCTAssertTrue(success);
    XCTAssertNil(setError, "error should be nil");
    NSError * getError;
    NSString * newValue = [appConfiguration getPropertyForKey:@"Development" group:@"UR" error:&getError];
    XCTAssertNil(getError,"error should be nil");
    XCTAssertNotNil(newValue, "value should not be nil");
    XCTAssertEqualObjects(newValue, @"new value", "value should be equal");
    
}


-(void)testSetPropertyInvalidParameter {
    
    XCTAssertThrowsSpecificNamed([appConfiguration setPropertyForKey:@"A" group:@"" value:@"new value" error:nil], NSException, NSInternalInconsistencyException, "should throw exception");
    
    XCTAssertThrowsSpecificNamed([appConfiguration setPropertyForKey:@"A" group:@" " value:@"new value" error:nil], NSException, NSInternalInconsistencyException, "should throw exception");
    
    XCTAssertThrowsSpecificNamed([appConfiguration setPropertyForKey:@"" group:@"UR" value:@"new value" error:nil], NSException, NSInternalInconsistencyException, "should throw exception");
    
    XCTAssertThrowsSpecificNamed([appConfiguration setPropertyForKey:@" " group:@"UR" value:@"new value" error:nil], NSException, NSInternalInconsistencyException, "should throw exception");
    
    XCTAssertThrowsSpecificNamed([appConfiguration setPropertyForKey:nil group:nil value:@"new value" error:nil], NSException, NSInternalInconsistencyException, "should throw exception");
    
    XCTAssertThrowsSpecificNamed([appConfiguration setPropertyForKey:@"eweq&%^&^%" group:@"UR" value:@"new value" error:nil], NSException, NSInternalInconsistencyException, "should throw exception");
    
    XCTAssertThrowsSpecificNamed([appConfiguration setPropertyForKey:@"dsdaA233)" group:@"UR" value:@"new value" error:nil], NSException, NSInternalInconsistencyException, "should throw exception");
    
    XCTAssertNoThrow([appConfiguration setPropertyForKey:@"ewe._-A898" group:@"UR" value:@"new value" error:nil],"should not throw exception");
    
}

//test case for not existing group
-(void)testSetPropertyNewGroup {
    NSError * error;
    BOOL success = [appConfiguration setPropertyForKey:@"A" group:@"A" value:@"new" error:&error];
    XCTAssertNil(error, "error should be nil");
    
    XCTAssertTrue(success);
    NSError * getError;
    NSString * newValue = [appConfiguration getPropertyForKey:@"A" group:@"A" error:&getError];
    XCTAssertNil(getError,"error should be nil");
    XCTAssertNotNil(newValue, "value should not be nil");
    XCTAssertEqualObjects(newValue, @"new", "value should be equal");
}

//test case for not existing key
-(void)testSetPropertyNewKey {
    NSError * error;
    BOOL success = [appConfiguration setPropertyForKey:@"A" group:@"UR" value:@"new" error:&error];
    XCTAssertNil(error, "error should be nil");
    
    XCTAssertTrue(success);
    NSError * getError;
    NSString * newValue = [appConfiguration getPropertyForKey:@"A" group:@"UR" error:&getError];
    XCTAssertNil(getError,"error should be nil");
    XCTAssertNotNil(newValue, "value should not be nil");
    XCTAssertEqualObjects(newValue, @"new", "value should be equal");
}

//test for setting number
-(void)testSetPropertyWithNumber {
    NSError * error;
    BOOL success = [appConfiguration setPropertyForKey:@"A" group:@"UR" value:@2 error:&error];
    XCTAssertNil(error, "error should be nil");
    
    XCTAssertTrue(success);
    NSError * getError;
    NSNumber * newValue = [appConfiguration getPropertyForKey:@"A" group:@"UR" error:&getError];
    XCTAssertNil(getError,"error should be nil");
    XCTAssertNotNil(newValue, "value should not be nil");
    XCTAssertEqualObjects(newValue, @2, "value should be equal");
}

//test for setting array
-(void)testSetPropertyWithArrayOfStrings {
    NSError * error;
    BOOL success = [appConfiguration setPropertyForKey:@"A" group:@"UR" value:[NSArray arrayWithObjects:@"A",@"B", @"C", nil] error:&error];
    XCTAssertNil(error, "error should be nil");
    
    XCTAssertTrue(success);
    NSError * getError;
    NSArray * values = [appConfiguration getPropertyForKey:@"A" group:@"UR" error:&getError];
    XCTAssertNil(getError,"error should be nil");
    XCTAssertNotNil(values, "value should not be nil");
    XCTAssertEqualObjects(values[0], @"A", "value should be equal");
    XCTAssertEqualObjects(values[1], @"B", "value should be equal");
    XCTAssertEqualObjects(values[2], @"C", "value should be equal");
}

//test for setting Array Of Numbers
-(void)testSetPropertyWithArrayOfNumbers {
    NSError * error;
    BOOL success = [appConfiguration setPropertyForKey:@"A" group:@"UR" value:[NSArray arrayWithObjects:@1,@2, @3, nil] error:&error];
    XCTAssertNil(error, "error should be nil");
    
    XCTAssertTrue(success);
    NSError * getError;
    NSArray * values = [appConfiguration getPropertyForKey:@"A" group:@"UR" error:&getError];
    XCTAssertNil(getError,"error should be nil");
    XCTAssertNotNil(values, "value should not be nil");
    XCTAssertEqualObjects(values[0], @1, "value should be equal");
    XCTAssertEqualObjects(values[1], @2, "value should be equal");
    XCTAssertEqualObjects(values[2], @3, "value should be equal");
}

//test for setting Array Of Numbers And Strings
-(void)testSetPropertyWithArrayOfNumbersAndStrings {
    NSError * error;
    BOOL success = [appConfiguration setPropertyForKey:@"A" group:@"UR" value:[NSArray arrayWithObjects:@1,@"A", @3, nil] error:&error];
    XCTAssertNil(error, "error should be nil");
    
    XCTAssertTrue(success);
    NSError * getError;
    NSArray * values = [appConfiguration getPropertyForKey:@"A" group:@"UR" error:&getError];
    XCTAssertNil(getError,"error should be nil");
    XCTAssertNotNil(values, "value should not be nil");
    XCTAssertEqualObjects(values[0], @1, "value should be equal");
    XCTAssertEqualObjects(values[1], @"A", "value should be equal");
    XCTAssertEqualObjects(values[2], @3, "value should be equal");
}

//test for setting Dictionary
-(void)testSetPropertyWithDictionary {
    NSError * error;
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"key1",@"value1",@"key2",@"value2", nil];
    XCTAssertNoThrow([appConfiguration setPropertyForKey:@"A" group:@"UR" value:dict error:&error],"should not throw exception");
}

//test for setting Dictionary In Array
-(void)testSetPropertyWithDictionaryInArray {
    NSError * error;
    NSArray * arr = [NSArray arrayWithObjects:@1,@"A", [NSDictionary dictionaryWithObjectsAndKeys:@"key1",@"value1",@"key2",@"value2", nil], nil];
    XCTAssertThrowsSpecificNamed([appConfiguration setPropertyForKey:@"A" group:@"UR" value:arr error:&error], NSException, NSInternalInconsistencyException, "should throw exception");
}

//test for setting Custom Object
-(void)testSetPropertyWithCustomObject {
    NSError * error;
    AIAppConfiguration * appConfig = [[AIAppConfiguration alloc]init];
    XCTAssertThrowsSpecificNamed([appConfiguration setPropertyForKey:@"A" group:@"UR" value:appConfig error:&error], NSException, NSInternalInconsistencyException, "should throw exception");
}

//test for setting array
-(void)testSetNewKey {
    NSError * error;
    BOOL success = [appConfiguration setPropertyForKey:@"newK" group:@"UR" value:@"" error:&error];
    XCTAssertNil(error, "error should be nil");
    
    XCTAssertTrue(success);
    NSError * getError;
    NSString * value = [appConfiguration getPropertyForKey:@"newK" group:@"UR" error:&getError];
    XCTAssertNil(getError,"error should be nil");
    XCTAssertNotNil(value, "value should not be nil");
    XCTAssertEqualObjects(value, @"", "value should be equal");
}

//test for setting Array Of Numbers And Strings
-(void)testSetNillForKEey{
    NSError * error;
    NSError * getError;
    
    BOOL success = [appConfiguration setPropertyForKey:@"Development" group:@"UR" value:@"blahblah" error:&error];
    XCTAssertTrue(success);
    id value = [appConfiguration getPropertyForKey:@"Development" group:@"UR" error:&getError];
    XCTAssertEqualObjects(value, @"blahblah");
    
    id defaultValue = [appConfiguration getDefaultPropertyForKey:@"Development" group:@"UR" error:&getError];
    XCTAssertEqualObjects(@"ad7nn99y2mv5berw5jxewzagazafbyhu", defaultValue);
    
    
    success = [appConfiguration setPropertyForKey:@"Development" group:@"UR" value:nil error:&error];
    XCTAssertTrue(success);
    id newValue = [appConfiguration getPropertyForKey:@"Development" group:@"UR" error:&getError];
    XCTAssertEqualObjects(defaultValue, newValue);
    
}

-(void)testGetDefaultPropertyDictionary {
    NSError * setError;
    BOOL success = [appConfiguration setPropertyForKey:@"Dictionary" group:@"UR" value:@[@"a",@"b"] error:&setError];
    XCTAssertNil(setError, "error should be nil");
    
    
    NSDictionary* allSupportedTypes =@{@"key1":@"value2",
                                       @"newkey":@"newvalue",
                                       @"int":@123,
                                       @"arrayString":@[@"a",@"b"],
                                       @"arrayInt":@[@1,@2],
                                       @"complexDict":@{
                                               @"key1":@"value2",
                                               @"newkey":@"level2",
                                               @"int":@123,
                                               @"arrayString":@[@"a",@"b"],
                                               @"arrayInt":@[@1,@2],
                                               @"complexDict":@{
                                                       @"key1":@"value2",
                                                       @"newkey":@"level3",
                                                       @"int":@123,
                                                       @"arrayString":@[@"a",@"b"],
                                                       @"arrayInt":@[@1,@2],
                                                       @"complexDict":@{
                                                               @"newkey":@"level4",
                                                               }
                                                       
                                                       }
                                               
                                               }
                                       };
    
    success = [appConfiguration setPropertyForKey:@"Dictionary" group:@"UR" value:allSupportedTypes error:&setError];
    
    XCTAssertTrue(success);
    XCTAssertNil(setError, "error should be nil");
    NSError * getError;
    NSDictionary * newValue = [appConfiguration getPropertyForKey:@"Dictionary" group:@"UR" error:&getError];
    XCTAssertNil(getError,"error should be nil");
    XCTAssertNotNil(newValue, "value should not be nil");
    XCTAssertEqualObjects(newValue[@"key1"], @"value2", "value should be equal");
    XCTAssertEqualObjects(newValue[@"newkey"], @"newvalue", "value should be equal");
    XCTAssertEqualObjects(newValue[@"complexDict"][@"newkey"],@"level2", "value should be equal");
    XCTAssertEqualObjects(newValue[@"complexDict"][@"complexDict"][@"newkey"],@"level3", "value should be equal");
    XCTAssertEqualObjects(newValue[@"complexDict"][@"complexDict"][@"complexDict"][@"newkey"],@"level4", "value should be equal");
    
    NSError * getDefaultError;
    NSDictionary * defaultValue = [appConfiguration getDefaultPropertyForKey:@"Dictionary" group:@"UR" error:&getDefaultError];
    XCTAssertNil(getDefaultError,"error should be nil");
    XCTAssertNotNil(defaultValue, "value should not be nil");
    XCTAssertEqualObjects(defaultValue[@"key1"], @"value1", "value should be equal");
    
}

//test for caseInsensitiveData
-(void)testcaseInsensitiveData {
    
    
    NSDictionary *dict = @{@"Test":@"value1",
                           @"test":@"value2",
                           @"TEST":@"value3",
                           @"Test-1":@"value4",
                           @"Int":@1,
                           @"Array":@[@"Test",@"test"]
                           };
    
    NSDictionary *newDict = [appConfiguration uppercaseKeysForDictionary:dict];
    
    XCTAssertNotNil(newDict[@"ARRAY"], "value should not be nil");
    XCTAssertNotNil(newDict[@"INT"], "value should not be nil");
    XCTAssertNotNil(newDict[@"TEST-1"], "value should not be nil");
    XCTAssertNotNil(newDict[@"TEST"], "value should not be nil");
    
    
    XCTAssertEqualObjects(newDict[@"ARRAY"][0], @"Test", "value should be equal");
    XCTAssertEqualObjects(newDict[@"ARRAY"][1], @"test", "value should be equal");
    XCTAssertEqualObjects(newDict[@"INT"], @1, "value should be equal");
    XCTAssertEqualObjects(newDict[@"TEST-1"], @"value4", "value should be equal");
    
}

//test for caseInsensitiveData
-(void)testcaseInsensitiveDataWithInnerDictionary {
    
    NSDictionary *dict = @{@"group1":@{@"group1key1":@"value1",
                                       @"Group1Key2":@"value2",
                                       @"GroUp1KEy3":@"value3",
                                       @"GROUP1KEY4":@"value4"},
                           @"Group2":@{@"group2key1-int":@1,
                                       @"Group2Key2_array":@[@1,@2],
                                       @"GroUp2KEy3.dictionary":@{@"key1":@"value1"},
                                       @"GROUP2KEY4.stringArray":@[@"a",@"b"],
                                       },
                           @"GroUp3":@{},
                           @"GROUP4":@"value4"
                           };
    
    NSDictionary *newDict = [appConfiguration uppercaseKeysForDictionary:dict];
    XCTAssertNotNil(newDict[@"GROUP1"], "value should not be nil");
    XCTAssertNotNil(newDict[@"GROUP2"], "value should not be nil");
    XCTAssertNotNil(newDict[@"GROUP3"], "value should not be nil");
    XCTAssertNotNil(newDict[@"GROUP4"], "value should not be nil");
    XCTAssertNil(newDict[@"group1"], "value should be nil");
    XCTAssertNil(newDict[@"Group2"], "value should be nil");
    XCTAssertNil(newDict[@"GroUp3"], "value should be nil");
    
    
    XCTAssertEqualObjects(newDict[@"GROUP1"][@"GROUP1KEY1"], @"value1", "value should be equal");
    XCTAssertEqualObjects(newDict[@"GROUP1"][@"GROUP1KEY2"], @"value2", "value should be equal");
    XCTAssertEqualObjects(newDict[@"GROUP1"][@"GROUP1KEY3"], @"value3", "value should be equal");
    XCTAssertEqualObjects(newDict[@"GROUP1"][@"GROUP1KEY4"], @"value4", "value should be equal");
    
}


-(void)testCaseInsensitive{
    NSError * error;
    BOOL success = [appConfiguration setPropertyForKey:@"newKey" group:@"newG" value:@"testValue" error:&error];
    XCTAssertNil(error, "error should be nil");
    
    XCTAssertTrue(success);
    NSError * getError;
    NSString * value = [appConfiguration getPropertyForKey:@"newKey" group:@"newG" error:&getError];
    XCTAssertNil(getError,"error should be nil");
    XCTAssertNotNil(value, "value should not be nil");
    XCTAssertEqualObjects(value, @"testValue", "value should be equal");
    
    value = [appConfiguration getPropertyForKey:@"nEwKEY" group:@"nEwG" error:&getError];
    XCTAssertNil(getError,"error should be nil");
    XCTAssertNotNil(value, "value should not be nil");
    XCTAssertEqualObjects(value, @"testValue", "value should be equal");
    
    
    value = [appConfiguration getPropertyForKey:@"newkey" group:@"newg" error:&getError];
    XCTAssertNil(getError,"error should be nil");
    XCTAssertNotNil(value, "value should not be nil");
    XCTAssertEqualObjects(value, @"testValue", "value should be equal");
    
    success = [appConfiguration setPropertyForKey:@"NEWKey" group:@"newG" value:@"newtestValue" error:&error];
    XCTAssertNil(error, "error should be nil");
    
    value = [appConfiguration getPropertyForKey:@"newKey" group:@"newG" error:&getError];
    XCTAssertNil(getError,"error should be nil");
    XCTAssertNotNil(value, "value should not be nil");
    XCTAssertEqualObjects(value, @"newtestValue", "value should be equal");
    
    value = [appConfiguration getPropertyForKey:@"nEwKEY" group:@"nEwG" error:&getError];
    XCTAssertNil(getError,"error should be nil");
    XCTAssertNotNil(value, "value should not be nil");
    XCTAssertEqualObjects(value, @"newtestValue", "value should be equal");
    
    
    value = [appConfiguration getPropertyForKey:@"newkey" group:@"newg" error:&getError];
    XCTAssertNil(getError,"error should be nil");
    XCTAssertNotNil(value, "value should not be nil");
    XCTAssertEqualObjects(value, @"newtestValue", "value should be equal");
}

#pragma mark cloud config tests
-(void)testdownloadConfigFromCloud {
    AIAppConfiguration * appConfig = [[AIAppConfiguration alloc]initWithAppInfra:appInfra];
    [appConfig.aiAppInfra.storageProvider removeValueForKey:@"ail.cloudconfig"];
    ((AIAppConfiguration*)(appInfra.appConfig)).configuration = @{@"APPINFRA":@{@"APPCONFIG.CLOUDSERVICEID":@""}};
    id mock = OCMClassMock([AIServiceDiscovery class]);
    appConfig.aiAppInfra.serviceDiscovery = mock;
//    [[[mock expect]andDo:^(NSInvocation *invocation) {
//        void (^completionHandler)(NSString *serviceURL, NSError *serviceURLError);
//        [invocation getArgument:&completionHandler atIndex:3];
//        completionHandler(@"https://www.philips.com/wrx/b2c/c/de/de/apps/77000/appconfig_acc_v1.json", nil);
//    }]getServiceUrlWithCountryPreference:OCMOCK_ANY withCompletionHandler:OCMOCK_ANY];
    //mock SD
    [[[mock expect]andDo:^(NSInvocation *invocation) {
        void (^completionHandler)(NSDictionary<NSString*,AISDService*> *services,NSError *error);
        AISDService *service = [[AISDService alloc]initWithUrl:@"https://www.philips.com/wrx/b2c/c/de/de/apps/77000/appconfig_acc_v1.json" andLocale:@"en_GB"];
        NSDictionary *servicesDictionary = @{@"": service};
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(servicesDictionary, nil);
    }]getServicesWithCountryPreference:OCMOCK_ANY withCompletionHandler:OCMOCK_ANY replacement:nil];
    
    NSString * configPath = [[NSBundle bundleForClass:self.class] pathForResource:@"CloudConfig" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:configPath];
    NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    id restMock = OCMClassMock([AIRESTClientInterface class]);
    appConfig.aiAppInfra.RESTClient = restMock;
    [[[restMock expect]andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSURLSessionDataTask * task, id responseObject);
        
        [invocation getArgument:&successBlock atIndex:5];
        successBlock(nil, json);
    }] GET:@"https://www.philips.com/wrx/b2c/c/de/de/apps/77000/appconfig_acc_v1.json" parameters:nil progress:nil success:OCMOCK_ANY failure:OCMOCK_ANY];
    
    [appConfig downloadConfigFromCloud:^(AIACRefreshResult refreshResult, NSError *error) {
        XCTAssertEqual(refreshResult, AIACRefreshResultRefreshedFromServer);
        XCTAssertNil(error);
    }];
    
    [appConfig downloadConfigFromCloud:^(AIACRefreshResult refreshResult, NSError *error) {
        XCTAssertEqual(refreshResult, AIACRefreshResultNoRefreshRequired);
        XCTAssertNil(error);
    }];
    
    [mock verify];
}

-(void)testRemoveCommonKeysforDictionary{
    AIAppConfiguration * appConfig = [[AIAppConfiguration alloc]initWithAppInfra:appInfra];
    NSDictionary *oldData1 = @{
                               @"string":@"stringValue",
                               @"int":@1,
                               @"stringArray":@[@"a",@"b"],
                               @"intArray":@[@1,@2,@3],
                               @"dict":@{
                                       @"string":@"stringValue",
                                       @"int":@1,
                                       @"stringArray":@[@"a",@"b"],
                                       @"intArray":@[@1,@2,@3]
                                       },
                               @"string1":@"stringValue1",
                               @"int1":@11,
                               @"stringArray1":@[@"a1",@"b1"],
                               @"intArray1":@[@11,@21,@31],
                               @"dict1":@{
                                       @"string1":@"stringValue1",
                                       @"int1":@11,
                                       @"stringArray1":@[@"a1",@"b1"],
                                       @"intArray1":@[@11,@21,@31]
                                       }
                               };
    
    NSDictionary *newData1 = @{
                               @"string":@"stringValue",
                               @"int":@1,
                               @"stringArray":@[@"a",@"b"],
                               @"intArray":@[@1,@2,@3],
                               @"dict":@{
                                       @"string":@"stringValue",
                                       @"int":@1,
                                       @"stringArray":@[@"a",@"b"],
                                       @"intArray":@[@1,@2,@3]
                                       },
                               @"string1":@"stringValue2",
                               @"int1":@12,
                               @"stringArray1":@[@"a2",@"b2"],
                               @"intArray1":@[@12,@22,@32],
                               @"dict1":@{
                                       @"string1":@"stringValue1",
                                       @"int1":@11,
                                       @"stringArray1":@[@"a1",@"b1"],
                                       @"intArray1":@[@12,@21,@31]
                                       }
                               };
    
    NSDictionary *dict = [appConfig removeCommonKeysforDictionary:oldData1 withDictionary:newData1];
    
    NSDictionary *expectedDict = @{
                                   @"string1":@"stringValue1",
                                   @"int1":@11,
                                   @"stringArray1":@[@"a1",@"b1"],
                                   @"intArray1":@[@11,@21,@31],
                                   @"dict1":@{
                                           @"string1":@"stringValue1",
                                           @"int1":@11,
                                           @"stringArray1":@[@"a1",@"b1"],
                                           @"intArray1":@[@11,@21,@31]
                                           }
                                   };
    XCTAssertEqualObjects(dict, expectedDict);
    
}
//getDefaultPropertyForKey shouldcall readAppConfigurationFromFile if static config is nill

-(void)testGetDefaultPropertyCallsReadAppConfigurationFromFile{
    // first create an object that you want to test:
    AIAppConfiguration * localAppConfig = [[AIAppConfiguration alloc]initWithAppInfra:appInfra];
    localAppConfig.staticConfiguration = nil;
    // create a partial mock for that object
    id mock = [OCMockObject partialMockForObject:localAppConfig];
    // tell the mock object what you expect
    [[mock expect] readAppConfigurationFromFile];
    // call the actual method on the mock object
    [mock getDefaultPropertyForKey:@"someKey" group:@"someGroup" error:nil];
    // and finally verify
    [mock verify];
}

-(void)testmigrateIfNeeded{
    id lstorageProvider = [[AIStorageProvider alloc]init];
    id mockStorageProvider = [OCMockObject partialMockForObject:lstorageProvider];
    id mockAppInfra = [OCMockObject partialMockForObject:appInfra];
    [[[mockAppInfra stub] andReturn:mockStorageProvider] storageProvider];
    
    
    appInfra.storageProvider = mockStorageProvider;
    
    AIAppConfiguration * localAppConfig = [[AIAppConfiguration alloc]initWithAppInfra:mockAppInfra];
    //set old data in config
    NSDictionary *oldData =@{
                             @"APPINFRA" :@{
                                     @"APPIDENTITY.MICROSITEID" : @12345,//modified
                                     @"APPIDENTITY.SECTOR" : @"b2c", //same
                                     @"APPIDENTITY.SERVICEDISCOVERYENVIRONMENT" : @"staging",//modified
                                     @"APPIDENTITY.APPSTATE" : @"development",//same
                                     @"RESTCLIENT.CACHESIZEINKB" : @51200,//same
                                     @"TEST.APPCONFIGDOWNLOADENVIRONMENT" : @"stage",//modified
                                     },
                             @"TESTING1"  :@{
                                     @"APPCONFIGDOWNLOADLOCALE" : @"ml_IN",//new one
                                     @"ARRAYVALUE" : @[ //new one
                                             @"one-1",
                                             @"two-2",
                                             @"three-3"
                                             ]
                                     }
                             };
    NSError* error;
    NSDictionary *expectedDict = @{
                                   @"APPINFRA" :@{
                                           @"APPIDENTITY.MICROSITEID" : @12345,//modified
                                           @"APPIDENTITY.SERVICEDISCOVERYENVIRONMENT" : @"staging",//modified
                                           @"TEST.APPCONFIGDOWNLOADENVIRONMENT" : @"stage",//modified
                                           },
                                   @"TESTING1"  :@{
                                           @"APPCONFIGDOWNLOADLOCALE" : @"ml_IN",//new one
                                           @"ARRAYVALUE" : @[ //new one
                                                   @"one-1",
                                                   @"two-2",
                                                   @"three-3"
                                                   ]
                                           }
                                   };
    [[[mockStorageProvider stub] andReturn:oldData] fetchValueForKey:kTestAppConfigSecureKey error:[OCMArg anyObjectRef]];
    [appInfra.storageProvider storeValueForKey:kTestAppConfigSecureKey value:oldData error:&error];
    
    NSDictionary* migratedDict = [localAppConfig getSavedConfig];
    XCTAssertEqualObjects(migratedDict,expectedDict);
    
}

-(void)testGetPropertyForKeyWithAllPossible{
    AIAppConfiguration * localAppConfig = [[AIAppConfiguration alloc]initWithAppInfra:appInfra];
    
    NSDictionary *staticConfiguration = @{@"staticOnly":@{
                                                  @"string":@"stringvalue",
                                                  @"dict":@{
                                                          @"dictKey":@"dictValue"
                                                          }
                                                  },
                                          @"common":@{
                                                  @"commonkey":@"commonStaticvalue",
                                                  @"commonkey1":@"commonStaticvalue1",
                                                  @"commonkey1":@"commonStaticvalue2",
                                                  }
                                          };
    staticConfiguration = [localAppConfig uppercaseKeysForDictionary:staticConfiguration];
    NSDictionary *configuration = @{@"dynamicOnly":@{
                                            @"string":@"stringvalue",
                                            @"dict":@{
                                                    @"dictKey":@"dictValue"
                                                    }
                                            },
                                    @"common":@{
                                            @"commonkey":@"commonDynamicvalue",
                                            @"commonkey1":@"commonDynamicvalue1",
                                            @"commonkey1":@"commonDynamicvalue2",
                                            }
                                    };
    configuration = [localAppConfig uppercaseKeysForDictionary:configuration];
    NSDictionary *cloudConfiguration =  @{@"cloudOnly":@{
                                                  @"string":@"stringvalue",
                                                  @"dict":@{
                                                          @"dictKey":@"dictValue"
                                                          }
                                                  },
                                          @"common":@{
                                                  @"commonkey":@"commonCloudvalue",
                                                  @"commonkey1":@"commonCloudvalue1",
                                                  @"commonkey1":@"commonCloudvalue2",
                                                  }
                                          };
    cloudConfiguration = [localAppConfig uppercaseKeysForDictionary:cloudConfiguration];
    
    
    localAppConfig.staticConfiguration = staticConfiguration;
    localAppConfig.configuration = configuration;
    localAppConfig.cloudConfiguration = cloudConfiguration;
    
    
    
    NSError* error;
    //from static file
    id valueDefault = [localAppConfig getDefaultPropertyForKey:@"string" group:@"staticOnly" error:&error];
    XCTAssertEqualObjects(valueDefault, @"stringvalue");
    XCTAssertNil(error);
    
    error = nil;
    id value = [localAppConfig getPropertyForKey:@"string" group:@"staticOnly" error:&error];
    XCTAssertEqualObjects(value, @"stringvalue");
    XCTAssertNil(error);
    
    //from cloud file
    error = nil;
    valueDefault = [localAppConfig getDefaultPropertyForKey:@"string" group:@"cloudOnly" error:&error];
    XCTAssertNil(valueDefault);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, 4);
    
    error = nil;
    value = [localAppConfig getPropertyForKey:@"string" group:@"cloudOnly" error:&error];
    if (value) {
        XCTAssertEqualObjects(value, @"stringvalue");
        XCTAssertNil(error);
    }
    
    //from dynamic file
    error = nil;
    valueDefault = [localAppConfig getDefaultPropertyForKey:@"string" group:@"dynamicOnly" error:&error];
    XCTAssertNil(valueDefault);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, 4);
    
    error = nil;
    value = [localAppConfig getPropertyForKey:@"string" group:@"dynamicOnly" error:&error];
    XCTAssertEqualObjects(value, @"stringvalue");
    XCTAssertNil(error);
}

-(void)testGetPropertyForKeyWithAllDynamic{
    AIAppConfiguration * localAppConfig = [[AIAppConfiguration alloc]initWithAppInfra:appInfra];
    
    NSDictionary *staticConfiguration = @{@"staticOnly":@{
                                                  @"string":@"stringvalue",
                                                  @"dict":@{
                                                          @"dictKey":@"dictValue"
                                                          }
                                                  },
                                          @"common":@{
                                                  @"commonkey":@"commonStaticvalue",
                                                  @"commonkey1":@"commonStaticvalue1",
                                                  @"commonkey1":@"commonStaticvalue2",
                                                  }
                                          };
    staticConfiguration = [localAppConfig uppercaseKeysForDictionary:staticConfiguration];
    NSDictionary *configuration = @{@"dynamicOnly":@{
                                            @"string":@"stringvalue",
                                            @"dict":@{
                                                    @"dictKey":@"dictValue"
                                                    }
                                            },
                                    @"common":@{
                                            @"commonkey":@"commonDynamicvalue",
                                            @"commonkey1":@"commonDynamicvalue1",
                                            @"commonkey1":@"commonDynamicvalue2",
                                            }
                                    };
    configuration = [localAppConfig uppercaseKeysForDictionary:configuration];
    NSDictionary *cloudConfiguration =  @{@"cloudOnly":@{
                                                  @"string":@"stringvalue",
                                                  @"dict":@{
                                                          @"dictKey":@"dictValue"
                                                          }
                                                  },
                                          @"common":@{
                                                  @"commonkey":@"commonCloudvalue",
                                                  @"commonkey1":@"commonCloudvalue1",
                                                  @"commonkey1":@"commonCloudvalue2",
                                                  }
                                          };
    cloudConfiguration = [localAppConfig uppercaseKeysForDictionary:cloudConfiguration];
    
    id mocklocalAppConfig = [OCMockObject partialMockForObject:localAppConfig];
    [[[mocklocalAppConfig stub] andReturn:staticConfiguration] staticConfiguration];
    [[[mocklocalAppConfig stub] andReturn:configuration] configuration];
    [[[mocklocalAppConfig stub] andReturn:cloudConfiguration] cloudConfiguration];
    
    
    NSError *error ;
    id valueDefault = [mocklocalAppConfig getDefaultPropertyForKey:@"commonkey" group:@"common" error:&error];
    XCTAssertEqualObjects(valueDefault, @"commonStaticvalue");
    XCTAssertNil(error);
    
    //dynamic
    error = nil;
    id value = [mocklocalAppConfig getPropertyForKey:@"commonkey" group:@"common" error:&error];
    XCTAssertEqualObjects(value, @"commonDynamicvalue");
    XCTAssertNil(error);
    
}
-(void)testGetPropertyForKeyWithAllCloud{
    AIAppConfiguration * localAppConfig = [[AIAppConfiguration alloc]initWithAppInfra:appInfra];
    
    NSDictionary *staticConfiguration = @{@"staticOnly":@{
                                                  @"string":@"stringvalue",
                                                  @"dict":@{
                                                          @"dictKey":@"dictValue"
                                                          }
                                                  },
                                          @"common":@{
                                                  @"commonkey":@"commonStaticvalue",
                                                  @"commonkey1":@"commonStaticvalue1",
                                                  @"commonkey1":@"commonStaticvalue2",
                                                  }
                                          };
    staticConfiguration = [localAppConfig uppercaseKeysForDictionary:staticConfiguration];
    NSDictionary *configuration = @{@"dynamicOnly":@{
                                            @"string":@"stringvalue",
                                            @"dict":@{
                                                    @"dictKey":@"dictValue"
                                                    }
                                            },
                                    @"common":@{
                                            //@"commonkey":@"commonDynamicvalue",
                                            @"commonkey1":@"commonDynamicvalue1",
                                            @"commonkey1":@"commonDynamicvalue2",
                                            }
                                    };
    configuration = [localAppConfig uppercaseKeysForDictionary:configuration];
    NSDictionary *cloudConfiguration =  @{@"cloudOnly":@{
                                                  @"string":@"stringvalue",
                                                  @"dict":@{
                                                          @"dictKey":@"dictValue"
                                                          }
                                                  },
                                          @"common":@{
                                                  @"commonkey":@"commonCloudvalue",
                                                  @"commonkey1":@"commonCloudvalue1",
                                                  @"commonkey1":@"commonCloudvalue2",
                                                  }
                                          };
    cloudConfiguration = [localAppConfig uppercaseKeysForDictionary:cloudConfiguration];
    
    
    localAppConfig.staticConfiguration = staticConfiguration;
    localAppConfig.configuration = configuration;
    localAppConfig.cloudConfiguration = cloudConfiguration;
    
    
    
    NSError* error;
    //from static file
    id valueDefault = [localAppConfig getDefaultPropertyForKey:@"string" group:@"staticOnly" error:&error];
    XCTAssertEqualObjects(valueDefault, @"stringvalue");
    XCTAssertNil(error);
    
    error = nil;
    id value = [localAppConfig getPropertyForKey:@"string" group:@"staticOnly" error:&error];
    XCTAssertEqualObjects(value, @"stringvalue");
    XCTAssertNil(error);
    
    //from cloud file
    error = nil;
    valueDefault = [localAppConfig getDefaultPropertyForKey:@"string" group:@"cloudOnly" error:&error];
    XCTAssertNil(valueDefault);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, 4);
    
    error = nil;
    value = [localAppConfig getPropertyForKey:@"string" group:@"cloudOnly" error:&error];
    if (value) {
        XCTAssertEqualObjects(value, @"stringvalue");
        XCTAssertNil(error);
    }
    
    //from dynalic file
    error = nil;
    valueDefault = [localAppConfig getDefaultPropertyForKey:@"string" group:@"dynamicOnly" error:&error];
    XCTAssertNil(valueDefault);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, 4);
    
    error = nil;
    value = [localAppConfig getPropertyForKey:@"string" group:@"dynamicOnly" error:&error];
    XCTAssertEqualObjects(value, @"stringvalue");
    XCTAssertNil(error);
    
    
    
    id mocklocalAppConfig = [OCMockObject partialMockForObject:localAppConfig];
    [[[mocklocalAppConfig stub] andReturn:staticConfiguration] staticConfiguration];
    [[[mocklocalAppConfig stub] andReturn:configuration] configuration];
    [[[mocklocalAppConfig stub] andReturn:cloudConfiguration] cloudConfiguration];
    
    
    error = nil;
    valueDefault = [mocklocalAppConfig getDefaultPropertyForKey:@"commonkey" group:@"common" error:&error];
    XCTAssertEqualObjects(valueDefault, @"commonStaticvalue");
    XCTAssertNil(error);
    
    
    //cloud
    error = nil;
    value = [mocklocalAppConfig getPropertyForKey:@"commonkey" group:@"common" error:&error];
    XCTAssertEqualObjects(value, @"commonCloudvalue");
    XCTAssertNil(error);
    
    error = nil;
    [mocklocalAppConfig setPropertyForKey:@"commonkey1" group:@"common" value:nil error:&error];
    value = [mocklocalAppConfig getPropertyForKey:@"commonkey1" group:@"common" error:&error];
    XCTAssertEqualObjects(value, @"commonCloudvalue1");
    XCTAssertNil(error);
    
    
}
-(void)testGetPropertyForKeyWithMockForStatic{
    AIAppConfiguration * localAppConfig = [[AIAppConfiguration alloc]initWithAppInfra:appInfra];
    
    NSDictionary *staticConfiguration = @{@"staticOnly":@{
                                                  @"string":@"stringvalue",
                                                  @"dict":@{
                                                          @"dictKey":@"dictValue"
                                                          }
                                                  },
                                          @"common":@{
                                                  @"commonkey":@"commonStaticvalue",
                                                  @"commonkey1":@"commonStaticvalue1",
                                                  @"commonkey1":@"commonStaticvalue2",
                                                  }
                                          };
    staticConfiguration = [localAppConfig uppercaseKeysForDictionary:staticConfiguration];
    NSDictionary *configuration = @{@"dynamicOnly":@{
                                            @"string":@"stringvalue",
                                            @"dict":@{
                                                    @"dictKey":@"dictValue"
                                                    }
                                            },
                                    @"common":@{
                                            //@"commonkey":@"commonDynamicvalue",
                                            @"commonkey1":@"commonDynamicvalue1",
                                            @"commonkey1":@"commonDynamicvalue2",
                                            }
                                    };
    configuration = [localAppConfig uppercaseKeysForDictionary:configuration];
    NSDictionary *cloudConfiguration =  @{@"cloudOnly":@{
                                                  @"string":@"stringvalue",
                                                  @"dict":@{
                                                          @"dictKey":@"dictValue"
                                                          }
                                                  },
                                          @"common":@{
                                                  //@"commonkey":@"commonCloudvalue",
                                                  @"commonkey1":@"commonCloudvalue1",
                                                  @"commonkey1":@"commonCloudvalue2",
                                                  }
                                          };
    cloudConfiguration = [localAppConfig uppercaseKeysForDictionary:cloudConfiguration];
    
    
    
    id mocklocalAppConfig = [OCMockObject partialMockForObject:localAppConfig];
    [[[mocklocalAppConfig stub] andReturn:staticConfiguration] staticConfiguration];
    [[[mocklocalAppConfig stub] andReturn:configuration] configuration];
    [[[mocklocalAppConfig stub] andReturn:cloudConfiguration] cloudConfiguration];
    
    
    NSError *error = nil;
    id valueDefault = [mocklocalAppConfig getDefaultPropertyForKey:@"commonkey" group:@"common" error:&error];
    XCTAssertEqualObjects(valueDefault, @"commonStaticvalue");
    XCTAssertNil(error);
    
    //static
    error = nil;
    id value = [mocklocalAppConfig getPropertyForKey:@"commonkey" group:@"common" error:&error];
    XCTAssertEqualObjects(value, @"commonStaticvalue");
    XCTAssertNil(error);
    
    
}
//dictionary contains invalid class
-(void)testIsValidValue{
    AIAppConfiguration *localAppConfig = [[AIAppConfiguration alloc]initWithAppInfra:appInfra];
    NSDictionary *dictDict = @{@"outerKey":@"outerValue",@"dict":@{@"invalid":localAppConfig}};
    BOOL isValid =  [localAppConfig isValidValue:dictDict];
    XCTAssertFalse(isValid);
}

-(void)testNilDynamicConfig{
    id lstorageProvider = [[AIStorageProvider alloc]init];
    id mockStorageProvider = [OCMockObject partialMockForObject:lstorageProvider];
    id mockAppInfra = [OCMockObject partialMockForObject:appInfra];
    [[[mockAppInfra stub] andReturn:mockStorageProvider] storageProvider];
    
    appInfra.storageProvider = mockStorageProvider;
    
    AIAppConfiguration * localAppConfig = [[AIAppConfiguration alloc]initWithAppInfra:mockAppInfra];
    [[[mockStorageProvider stub] andReturn:nil] fetchValueForKey:kTestAppDynamicConfigSecureStoreKey error:[OCMArg anyObjectRef]];
    NSDictionary* migratedDict = [localAppConfig getSavedConfig];
    XCTAssertNil(migratedDict);
    
}

-(void)testResetConfigWithBothCloudAndDynamicValues
{
    AIAppConfiguration * localAppConfig = [[AIAppConfiguration alloc]initWithAppInfra:appInfra];
    
    NSDictionary *staticConfiguration = @{@"common":@{
                                                  @"commonkey":@"commonStaticvalue",
                                                  @"commonkey1":@"commonStaticvalue1",
                                                  @"commonkey2":@"commonStaticvalue2",
                                                  }
                                          };
    staticConfiguration = [localAppConfig uppercaseKeysForDictionary:staticConfiguration];
    
    NSDictionary *cloudConfiguration =  @{@"common":@{
                                                  @"commonkey":@"commonCloudvalue",
                                                  @"commonkey1":@"commonCloudvalue1",
                                                  @"commonkey2":@"commonCloudvalue2",
                                                  }
                                          };
    cloudConfiguration = [localAppConfig uppercaseKeysForDictionary:cloudConfiguration];
    
    NSDictionary *dynamicConfiguration = @{@"common":@{
                                            @"commonkey":@"commonDynamicvalue",
                                            @"commonkey1":@"commonDynamicvalue1",
                                            @"commonkey2":@"commonDynamicvalue2",
                                            }
                                    };
    dynamicConfiguration = [localAppConfig uppercaseKeysForDictionary:dynamicConfiguration];
    
    localAppConfig.staticConfiguration = staticConfiguration;
    localAppConfig.configuration = dynamicConfiguration;
    localAppConfig.cloudConfiguration = cloudConfiguration;
    
    NSError* error;
 
    id value = [localAppConfig getPropertyForKey:@"commonkey" group:@"common" error:&error];
    XCTAssertEqualObjects(value, @"commonDynamicvalue");
    
    // reset config
    XCTAssertTrue([localAppConfig resetConfig:&error]);
    
    id value1 = [localAppConfig getPropertyForKey:@"commonkey" group:@"common" error:&error];
    XCTAssertEqualObjects(value1, @"commonStaticvalue");
 
}

-(void)testResetConfigWithOutDynamicValues
{
    AIAppConfiguration * localAppConfig = [[AIAppConfiguration alloc]initWithAppInfra:appInfra];
    
    NSDictionary *staticConfiguration = @{@"common":@{
                                                  @"commonkey":@"commonStaticvalue",
                                                  @"commonkey1":@"commonStaticvalue1",
                                                  @"commonkey2":@"commonStaticvalue2",
                                                  }
                                          };
    staticConfiguration = [localAppConfig uppercaseKeysForDictionary:staticConfiguration];
    
    NSDictionary *cloudConfiguration =  @{@"common":@{
                                                  @"commonkey":@"commonCloudvalue",
                                                  @"commonkey1":@"commonCloudvalue1",
                                                  @"commonkey2":@"commonCloudvalue2",
                                                  }
                                          };
    cloudConfiguration = [localAppConfig uppercaseKeysForDictionary:cloudConfiguration];
    
    localAppConfig.staticConfiguration = staticConfiguration;
    localAppConfig.cloudConfiguration = cloudConfiguration;
    
    NSError* error;
    
    id value = [localAppConfig getPropertyForKey:@"commonkey" group:@"common" error:&error];
    XCTAssertEqualObjects(value, @"commonCloudvalue");
    
    // reset config
    XCTAssertTrue([localAppConfig resetConfig:&error]);
    
    id value1 = [localAppConfig getPropertyForKey:@"commonkey" group:@"common" error:&error];
    XCTAssertEqualObjects(value1, @"commonStaticvalue");
    
}

// remove the config
-(void)tearDown {
    [storageProvider removeValueForKey:kTestAppConfigSecureKey];
    
}
@end
