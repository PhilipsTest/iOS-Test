//
//  InternationalizationTests.m
//  AppInfra
//
//  Created by Ravi Kiran HR on 12/07/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
@import AppInfra;

@interface InternationalizationTests : XCTestCase

@end

@implementation InternationalizationTests

- (void)setUp {
    [super setUp];
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    //    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)testGetLocale {
    
    AIInternationalizationInterface *obj = [[AIInternationalizationInterface alloc]init];
    NSLocale *locale = [obj getUILocale];
    XCTAssertNotNil(locale);
}

- (void)testGetLocaleString {
    
    AIInternationalizationInterface *obj = [[AIInternationalizationInterface alloc]init];
    XCTAssertNotNil([obj getUILocaleString]);
    
    NSString *locale = [obj getUILocaleString];
    XCTAssertTrue((locale.length>1 && locale.length<=6));
}

- (void)testGetLocaleStringAppSupportsLanguageWithOutCountry{
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en_IN"];
    NSArray *preferredLanguages = @[@"en-IN"];
    NSArray *appLocalisations = @[@"en"];
    
    id localeMock = [OCMockObject mockForClass:[NSLocale class]];
    [[[[localeMock stub] classMethod] andReturn:locale] currentLocale];
    [[[[localeMock stub] classMethod] andReturn:preferredLanguages] preferredLanguages];
    
    id mockMainBundle = [OCMockObject partialMockForObject:[NSBundle mainBundle]];
    [[[mockMainBundle stub] andReturn:appLocalisations] preferredLocalizations];
    
    id bindleMock = [OCMockObject mockForClass:[NSBundle class]];
    [[[[bindleMock stub] classMethod] andReturn:mockMainBundle] mainBundle];
    
    AIInternationalizationInterface *obj = [[AIInternationalizationInterface alloc]init];
    XCTAssertNotNil([obj getUILocaleString]);
    NSString *localeString = [obj getUILocaleString];
    XCTAssertEqualObjects(localeString, @"en");
    NSLocale *uilocale = [obj getUILocale];
    XCTAssertNotNil(uilocale);
}

- (void)testGetLocaleStringAppSupportsLanguageWithCountry{
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en_IN"];
    NSArray *preferredLanguages = @[@"en-IN"];
    NSArray *appLocalisations = @[@"en-IN"];
    
    id localeMock = [OCMockObject mockForClass:[NSLocale class]];
    [[[[localeMock stub] classMethod] andReturn:locale] currentLocale];
    [[[[localeMock stub] classMethod] andReturn:preferredLanguages] preferredLanguages];
    
    id mockMainBundle = [OCMockObject partialMockForObject:[NSBundle mainBundle]];
    [[[mockMainBundle stub] andReturn:appLocalisations] preferredLocalizations];
    
    id bindleMock = [OCMockObject mockForClass:[NSBundle class]];
    [[[[bindleMock stub] classMethod] andReturn:mockMainBundle] mainBundle];
    
    AIInternationalizationInterface *obj = [[AIInternationalizationInterface alloc]init];
    XCTAssertNotNil([obj getUILocaleString]);
    NSString *localeString = [obj getUILocaleString];
    XCTAssertEqual(localeString.length, 5);
    XCTAssertEqualObjects(localeString, @"en_IN");
    NSLocale *uilocale = [obj getUILocale];
    XCTAssertNotNil(uilocale);

}

- (void)testGetLocaleStringAppSupportsLanguageWithScriptAndWithoutCountry{
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    NSArray *preferredLanguages = @[];
    NSArray *appLocalisations = @[@"zh-Hant",@"en-IN"];
    
    id localeMock = [OCMockObject mockForClass:[NSLocale class]];
    [[[[localeMock stub] classMethod] andReturn:locale] currentLocale];
    [[[[localeMock stub] classMethod] andReturn:preferredLanguages] preferredLanguages];
    
    id mockMainBundle = [OCMockObject partialMockForObject:[NSBundle mainBundle]];
    [[[mockMainBundle stub] andReturn:appLocalisations] preferredLocalizations];
    
    id bindleMock = [OCMockObject mockForClass:[NSBundle class]];
    [[[[bindleMock stub] classMethod] andReturn:mockMainBundle] mainBundle];
    
    AIInternationalizationInterface *obj = [[AIInternationalizationInterface alloc]init];
    XCTAssertNotNil([obj getUILocaleString]);
    NSString *localeString = [obj getUILocaleString];
    XCTAssertEqualObjects(localeString, @"zh_TW");
    NSLocale *uilocale = [obj getUILocale];
    XCTAssertNotNil(uilocale);
}

- (void)testGetLocaleStringAppSupportsLanguageWithScriptAndWithCountry{
    
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    NSArray *preferredLanguages = @[];
    NSArray *appLocalisations = @[@"zh-Hant-HK",@"en-IN"];
    
    id localeMock = [OCMockObject mockForClass:[NSLocale class]];
    [[[[localeMock stub] classMethod] andReturn:locale] currentLocale];
    [[[[localeMock stub] classMethod] andReturn:preferredLanguages] preferredLanguages];
    
    id mockMainBundle = [OCMockObject partialMockForObject:[NSBundle mainBundle]];
    [[[mockMainBundle stub] andReturn:appLocalisations] preferredLocalizations];
    
    id bindleMock = [OCMockObject mockForClass:[NSBundle class]];
    [[[[bindleMock stub] classMethod] andReturn:mockMainBundle] mainBundle];
    
    AIInternationalizationInterface *obj = [[AIInternationalizationInterface alloc]init];
    XCTAssertNotNil([obj getUILocaleString]);
    NSString *localeString = [obj getUILocaleString];
    XCTAssertEqual(localeString.length, 5);
    XCTAssertEqualObjects(localeString, @"zh_TW");
    NSLocale *uilocale = [obj getUILocale];
    XCTAssertNotNil(uilocale);
}

- (void)testGetLocaleStringAppSupportsLanguageWithScriptAndWithCountryForChina{
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    NSArray *preferredLanguages = @[];
    NSArray *appLocalisations = @[@"zh-Hans-HK",@"en-IN"];
    
    id localeMock = [OCMockObject mockForClass:[NSLocale class]];
    [[[[localeMock stub] classMethod] andReturn:locale] currentLocale];
    [[[[localeMock stub] classMethod] andReturn:preferredLanguages] preferredLanguages];
    
    id mockMainBundle = [OCMockObject partialMockForObject:[NSBundle mainBundle]];
    [[[mockMainBundle stub] andReturn:appLocalisations] preferredLocalizations];
    
    id bindleMock = [OCMockObject mockForClass:[NSBundle class]];
    [[[[bindleMock stub] classMethod] andReturn:mockMainBundle] mainBundle];
    
    AIInternationalizationInterface *obj = [[AIInternationalizationInterface alloc]init];
    XCTAssertNotNil([obj getUILocaleString]);
    NSString *localeString = [obj getUILocaleString];
    XCTAssertEqual(localeString.length, 5);
    XCTAssertEqualObjects(localeString, @"zh_CN");
    NSLocale *uilocale = [obj getUILocale];
    XCTAssertNotNil(uilocale);
}

-(void)testGetCurrentLocaleNilCheck{
    AIInternationalizationInterface *obj = [[AIInternationalizationInterface alloc]init];
    XCTAssertNotNil([obj getBCP47UILocale]);
}

-(void)testGetCurrentLocale{
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    id localeMock = [OCMockObject mockForClass:[NSLocale class]];
    [[[[localeMock stub] classMethod] andReturn:locale] currentLocale];
    AIInternationalizationInterface *obj = [[AIInternationalizationInterface alloc]init];
    NSString *result = [obj getBCP47UILocale];
    XCTAssertEqualObjects(result, @"en-US");
}

@end
