//
//  RegistrationUtilityTests.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <XCTest/XCTest.h>

#import "RegistrationUtility.h"
#import "DIUser.h"
#import "HSDPService.h"
#import "HSDPUser.h"
#import "URSettingsWrapper.h"
#import "DIRegistrationConstants.h"
#import "JanrainService.h"
#import "DIUser+DataInterface.h"
#import <PlatformInterfaces/PlatformInterfaces-Swift.h>

@interface RegistrationUtilityTests : XCTestCase

@property (nonatomic, strong) AIAppInfra *appInfra;

@end

@implementation RegistrationUtilityTests

- (void)setUp {
    [super setUp];

    self.appInfra = [[AIAppInfra alloc] initWithBuilder:nil];
    URDependencies *dependencies = [[URDependencies alloc] init];
    dependencies.appInfra = self.appInfra;
    [URSettingsWrapper sharedInstance].dependencies = dependencies;
}

- (void)testUnsupportedTwitterSignInProviderSuccess
{
    XCTAssertThrows([RegistrationUtility checkForUnsupportedSigninProviders:[NSArray arrayWithObject:@"twitter"]],@"Expect exception for Unsupported provider");
}

- (void)testUnsupportedTwitterSignInProviderFailure
{
    XCTAssertNoThrow([RegistrationUtility checkForUnsupportedSigninProviders:[NSArray arrayWithObject:@"facebook"]],@"Expect exception for Unsupported provider");
}

- (void)testUserRegistrationSupportedCountries {
    NSArray *supportedCountries = @[@"RW",@"BG",@"CZ",@"DK",@"AT",@"CH",@"DE",@"GR",@"AU",@"CA",@"GB",@"HK",@"ID",@"IE",@"IN",@"MY",@"NZ",@"PH",@"PK",@"SA",@"SG",@"US",@"ZA",@"AR",@"CL",@"CO",@"ES",@"MX",@"PE",@"EE",@"FI",@"BE",@"FR",@"HR",@"HU",@"IT",@"JP",@"KR",@"LT",@"LV",@"NL",@"NO",@"PL",@"BR",@"PT",@"RO",@"RU",@"UA",@"SI",@"SK",@"SE",@"TH",@"TR",@"VN",@"CN",@"TW",@"AE",@"BH",@"EG",@"KW",@"LB",@"OM",@"QA",@"BY"];
    NSArray *receivedArray = [RegistrationUtility userregistrationSupportedCountries];
    XCTAssertTrue([supportedCountries isEqualToArray:receivedArray]);
}

- (void)testSupportedHomeCountries {
    NSMutableOrderedSet *supportedCountries = [NSMutableOrderedSet orderedSetWithArray:@[@"RW",@"BG",@"CZ",@"DK",@"AT",@"CH",@"DE",@"GR",@"AU",@"CA",@"GB",@"HK",@"ID",@"IE",@"IN",@"MY",@"NZ",@"PH",@"PK",@"SA",@"SG",@"US",@"ZA",@"AR",@"CL",@"CO",@"ES",@"MX",@"PE",@"EE",@"FI",@"BE",@"FR",@"HR",@"HU",@"IT",@"JP",@"KR",@"LT",@"LV",@"NL",@"NO",@"PL",@"BR",@"PT",@"RO",@"RU",@"UA",@"SI",@"SK",@"SE",@"TH",@"TR",@"VN",@"CN",@"TW",@"AE",@"BH",@"EG",@"KW",@"LB",@"OM",@"QA",@"BY",@"LU",@"MO"]];
    NSArray *receivedArray = [RegistrationUtility getSupportedCountries];
    XCTAssertTrue([[supportedCountries array] isEqualToArray:receivedArray]);
}

- (void)testDummyUserAcceptedTermsAndConditions {
    NSString *emailId = @"dummy123@mailinator.com";
    [RegistrationUtility userAcceptedTermsnConditions:emailId];
    XCTAssertTrue([RegistrationUtility hasUserAcceptedTermsnConditions:emailId]);
}

- (void)testNullUserAcceptedTermsAndConditions {
    NSString *emailId;
    [RegistrationUtility userAcceptedTermsnConditions:emailId];
    XCTAssertFalse([RegistrationUtility hasUserAcceptedTermsnConditions:emailId]);
}

- (void)testServiceNameForTokenNameForKeyChainTokenType {
    XCTAssertNotNil([RegistrationUtility serviceNameForTokenName:@"keychain_storage_token_type"]);
}

- (void)testOldServiceNameForTokenNameForKeyChainTokenType {
    XCTAssertNotNil([RegistrationUtility oldServiceNameForTokenName:@"keychain_storage_token_type"]);
}

- (void)testPropositionFallbackCountry {
    XCTAssertNotNil([RegistrationUtility propositionFallbackCountry]);
}

- (void)testGetURConfigurationLog {
    NSString *configurationLog = [NSString stringWithFormat:@"App Name : %@,\n App LocalizedName : %@,\n App Version : %@,\n App MicrositeID : %@,\n App State : %@,\n App Sector : %@,\n App ServiceDiscoveryEnvironment : %@\n",[DIRegistrationAppIdentity getAppName],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"],[DIRegistrationAppIdentity getAppVersion],[DIRegistrationAppIdentity getMicrositeId],[RegistrationUtility getAppStateString:[DIRegistrationAppIdentity getAppState]],
                                  [DIRegistrationAppIdentity getSector],
                                  [DIRegistrationAppIdentity getServiceDiscoveryEnvironment]];
    NSString *actualConfigurationLog = [RegistrationUtility getURConfigurationLog];
    XCTAssertTrue([configurationLog isEqualToString:actualConfigurationLog]);
}

- (void)testGetURFormattedLogError {
    NSError *inputError = [[NSError alloc] initWithDomain:@"URConsentErrorDomain" code:DIGDPRRegConsentError userInfo:@{NSLocalizedDescriptionKey: @"Unsupported Consent Key"}];
    NSString *inputErrorFormat = [NSString stringWithFormat:@"errorCode:%ld, errorDomain:%@, userInfo:%@", (long)inputError.code, inputError.domain, inputError.userInfo.description];
    NSString *receivedErrorFormat = [RegistrationUtility getURFormattedLogError:inputError withDomain:nil];
    XCTAssertTrue([receivedErrorFormat isEqualToString:inputErrorFormat]);
    
    NSError *inputErrorWithoutDomainName = [[NSError alloc] initWithDomain:@"" code:DIGDPRRegConsentError userInfo:@{NSLocalizedDescriptionKey: @"Unsupported Consent Key"}];
    inputErrorFormat = [NSString stringWithFormat:@"errorCode:%ld, errorDomain:%@, userInfo:%@", (long)inputError.code, @"URConsentErrorDomain", inputError.userInfo.description];
    receivedErrorFormat = [RegistrationUtility getURFormattedLogError:inputErrorWithoutDomainName withDomain:@"URConsentErrorDomain"];
    XCTAssertTrue([receivedErrorFormat isEqualToString:inputErrorFormat]);
}

- (void)testConvertURLRequestToString {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.dummyurl.xyz"]];
    NSData *bodyData=[@"dummy-query-parameters" dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:bodyData];
    [request addValue:@"8bit" forHTTPHeaderField:@"Content-Transfer-Encoding"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[bodyData length]] forHTTPHeaderField:@"Content-Length"];
    XCTAssertNotNil([RegistrationUtility convertURLRequestToString:request], @"Received NSURLRequest to string should not be nil");
}

-(void)testSetHsdpUUIDToNotNil {
    NSString *value = @"The user HSDP value";
    [RegistrationUtility setHSDPUserUUID:value];
    XCTAssertEqualObjects(value, self.appInfra.logging.hsdpUserUUID);
    XCTAssertNotNil(self.appInfra.logging.hsdpUserUUID);
}

-(void)testSetHSdpUUIDToNil {
    [RegistrationUtility setHSDPUserUUID:nil];
    XCTAssertNil(self.appInfra.logging.hsdpUserUUID);
}

@end



@interface FakeJRService : JanrainService

@property (nonatomic,assign) BOOL sendSuccess;
@property (nonatomic,assign) int sleepTime;
@property (nonatomic,strong) NSError *jrError;
@end

@implementation FakeJRService

- (void)refreshAccessTokenWithSuccessHandler:(dispatch_block_t)success failureHandler:(JanrainServiceFailureHandler)failure {
    sleep(self.sleepTime);
    if (self.sendSuccess == true) {
        success();
    } else {
        failure(self.jrError);
    }
}

@end

@interface FakeHSDPService : HSDPService

@property (nonatomic,assign) int sleepTime;
@property (nonatomic,assign) BOOL sendSuccess;
@property (nonatomic,strong) NSError *hsdpError;

@end

@implementation FakeHSDPService

-(instancetype)initWithCountryCode:(NSString *)countryCode baseURL:(NSString *)baseURL {
    self = [super initWithCountryCode:countryCode baseURL:baseURL];
       return self;
}


- (void)refreshSessionForUUID:(NSString *)uuid refreshToken:(NSString *)refreshToken completion:(HSDPServiceCompletionHandler)completion {
    sleep(self.sleepTime);
    HSDPUser *user;
    if (self.sendSuccess == true) {
        user = [[HSDPUser alloc] initWithUUID:uuid tokenDictionary:[NSDictionary dictionary]];
    }
    completion(user,self.hsdpError);
}

- (void)refreshSessionForUUID:(NSString *)uuid accessToken:(NSString *)accessToken refreshSecret:(NSString *)refreshSecret
completion:(HSDPServiceCompletionHandler)completion {
    HSDPUser *user;
    if (self.sendSuccess == true) {
        user = [[HSDPUser alloc] initWithUUID:uuid tokenDictionary:[NSDictionary dictionary]];
    }
    completion(user,self.hsdpError);

}

@end

@interface DIUser ()
-(void)initiateRefreshQueuesAndSemaphores;
@end

@interface DIFakeUser : DIUser

@property (nonatomic,strong) FakeJRService *fJRService;
@property (nonatomic,strong) FakeHSDPService *fHSDPService;
@end

@implementation DIFakeUser

-(void)initiateRefreshQueuesAndSemaphores {
    [self setValue:self.fJRService forKey:@"janrainService"];
    [self setValue:self.fHSDPService forKey:@"hsdpService"];
    [super initiateRefreshQueuesAndSemaphores];
}

@end



@interface DIUserRefreshTests : XCTestCase <HSDPRefreshSessionResultDelegate,SessionRefreshDelegate,UserDataDelegate> {
    XCTestExpectation *refreshExpectaion;
    XCTestExpectation *hsdpRefreshExpectaion;
    
    XCTestExpectation *nohsdpErrorRefreshExpectaion;
    XCTestExpectation *hsdpErrorRefreshExpectaion;
    XCTestExpectation *hsdp1151ErrorRefreshExpectaion;
    XCTestExpectation *jrErrorRefreshExpectaion;
    XCTestExpectation *testRefreshHSDPAPIForHSDPErrorExpectation;
    XCTestExpectation *testRefreshAllAPIForJRError2Exepectation;
}

@property (nonatomic, strong) AIAppInfra *appInfra;

@end

@implementation DIUserRefreshTests


- (void)setUp {
    [super setUp];

    self.appInfra = [[AIAppInfra alloc] initWithBuilder:nil];
    URDependencies *dependencies = [[URDependencies alloc] init];
    dependencies.appInfra = self.appInfra;
    [URSettingsWrapper sharedInstance].dependencies = dependencies;
}

//-(void)testRefreshAPIs {
//    DIFakeUser *user = [[DIFakeUser alloc] init];
//    FakeJRService *jrService = [[FakeJRService alloc] init];
//    jrService.sleepTime = 1;
//    jrService.sendSuccess = true;
//    [self.appInfra.appConfig setPropertyForKey:HSDPConfiguration_ApplicationName group:@"UserRegistration" value:@"CDP" error:&error];
//    [self.appInfra.appConfig setPropertyForKey:HSDPConfiguration_Shared group:@"UserRegistration"
//                                           value:@"fe53a854-f9b0-11e6-bc64-92361f002671" error:&error];
//    [self.appInfra.appConfig setPropertyForKey:HSDPConfiguration_Secret group:@"UserRegistration"
//                                           value:@"057b97e0-f9b1-11e6-bc64-92361f002671" error:&error];
//    [self.appInfra.appConfig setPropertyForKey:HSDPConfiguration_BaseURL group:@"UserRegistration"
//                                           value:@"https://user-registration-assembly-hsdpchinadev.cn1.philips-healthsuite.com.cn" error:&error];
//    FakeHSDPService *hsdpService = [[FakeHSDPService alloc] initWithCountryCode:locale baseURL:@"www.google.com"];
//    hsdpService.sleepTime = 2;
//    user.fJRService = jrService;
//    user.fHSDPService = hsdpService;
//    [user refreshLoginSession];
//    [user addHSDPUserDataInterfaceListener:self];
//    refreshExpectaion = [self expectationWithDescription:@"Refresh"];
//    [self waitForExpectations:[NSArray arrayWithObject:refreshExpectaion] timeout:3.0];
//}

//-(void)testRefreshHSDPAPIs {
//    DIFakeUser *user = [[DIFakeUser alloc] init];
//    FakeJRService *jrService = [[FakeJRService alloc] init];
//    jrService.sleepTime = 1;
//    jrService.sendSuccess = true;
//    FakeHSDPService *hsdpService = [[FakeHSDPService alloc] initWithCountryCode:@"en_US" baseURL:@"www.google.com"];
//    hsdpService.sleepTime = 2;
//    user.fJRService = jrService;
//    user.fHSDPService = hsdpService;
//    dispatch_queue_t refreshQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(refreshQueue, ^{
//        [user refreshHSDPSession];
//    });
//    dispatch_async(refreshQueue, ^{
//        [user refreshHSDPSession];
//    });
//    dispatch_async(refreshQueue, ^{
//        [user refreshHSDPSession];
//    });
//    dispatch_async(refreshQueue, ^{
//        [user refreshHSDPSession];
//    });
//    [user addHSDPUserDataInterfaceListener:self];
//    hsdpRefreshExpectaion = [self expectationWithDescription:@"Refresh HSDP APIs"];
//    [self waitForExpectations:[NSArray arrayWithObject:hsdpRefreshExpectaion] timeout:10.0];
//}

//-(void)testRefreshHSDPError {
//    DIFakeUser *user = [[DIFakeUser alloc] init];
//    FakeJRService *jrService = [[FakeJRService alloc] init];
//    jrService.sleepTime = 1;
//    jrService.sendSuccess = true;
//    user.fJRService = jrService;
//    user.fHSDPService = nil;
//    dispatch_queue_t refreshQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(refreshQueue, ^{
//        [user refreshHSDPSession];
//    });
//    dispatch_async(refreshQueue, ^{
//        [user refreshHSDPSession];
//    });
//    dispatch_async(refreshQueue, ^{
//        [user refreshHSDPSession];
//    });
//    dispatch_async(refreshQueue, ^{
//        [user refreshHSDPSession];
//    });
//    [user addHSDPUserDataInterfaceListener:self];
//    nohsdpErrorRefreshExpectaion = [self expectationWithDescription:@"Refresh no HSDP Errors"];
//    [self waitForExpectations:[NSArray arrayWithObject:nohsdpErrorRefreshExpectaion] timeout:10.0];
//}




-(void)refreshHSDPSessionSucceed {
    [refreshExpectaion fulfill];
    [hsdpRefreshExpectaion fulfill];
}

-(void)refreshHSDPSessionFailed:(NSError *)error {
    if ([error code] == DIHsdpStateNotConfiguredForCountry) {
        [nohsdpErrorRefreshExpectaion fulfill];
    }
    
    if ([[error domain] isEqualToString:@"Some error"]) {
        if (testRefreshHSDPAPIForHSDPErrorExpectation != nil) {
            [testRefreshHSDPAPIForHSDPErrorExpectation fulfill];
        }
    }
}

-(void)hsdpUserSessionInvalid:(NSError *)error {
    if ([error.userInfo[@"responseCode"] integerValue] == 1151 ) {
        [hsdp1151ErrorRefreshExpectaion fulfill];
    }
}

-(void)loginSessionRefreshFailedWithError:(NSError *)error {
    if ([[error domain] isEqualToString:@"Some JR error"]) {
        if (testRefreshAllAPIForJRError2Exepectation != nil) {
            [testRefreshAllAPIForJRError2Exepectation fulfill];
        }
        if (jrErrorRefreshExpectaion != nil) {
            [jrErrorRefreshExpectaion fulfill];
        }
    }
}

-(void)refreshSessionFailed:(NSError *)error {
    if ([[error domain] isEqualToString:@"Some JR error"]) {
        if (testRefreshAllAPIForJRError2Exepectation != nil) {
            [testRefreshAllAPIForJRError2Exepectation fulfill];
        }
        
         if (jrErrorRefreshExpectaion != nil) {
             [jrErrorRefreshExpectaion fulfill];
         }
    }
}



//-(void)testRefreshHSDPAPIForHSDPError {
//    DIFakeUser *user = [[DIFakeUser alloc] init];
//    FakeJRService *jrService = [[FakeJRService alloc] init];
//    jrService.sleepTime = 1;
//    jrService.sendSuccess = true;
//    NSString *locale = [self.appInfra.internationalization getBCP47UILocale];
//    NSError *error;
//    [self.appInfra.appConfig setPropertyForKey:HSDPConfiguration_ApplicationName group:@"UserRegistration" value:@"CDP" error:&error];
//    [self.appInfra.appConfig setPropertyForKey:HSDPConfiguration_Shared group:@"UserRegistration"
//                                           value:@"fe53a854-f9b0-11e6-bc64-92361f002671" error:&error];
//    [self.appInfra.appConfig setPropertyForKey:HSDPConfiguration_Secret group:@"UserRegistration"
//                                           value:@"057b97e0-f9b1-11e6-bc64-92361f002671" error:&error];
//    [self.appInfra.appConfig setPropertyForKey:HSDPConfiguration_BaseURL group:@"UserRegistration"
//                                           value:@"https://user-registration-assembly-hsdpchinadev.cn1.philips-healthsuite.com.cn" error:&error];
//    FakeHSDPService *hsdpService = [[FakeHSDPService alloc] initWithCountryCode:locale baseURL:@"www.google.com"];
//
//    hsdpService.sleepTime = 2;
//    hsdpService.sendSuccess = false;
//    hsdpService.hsdpError = [NSError errorWithDomain:@"Some error" code:0 userInfo:nil];
//    user.fJRService = jrService;
//    user.fHSDPService = hsdpService;
//    dispatch_queue_t refreshQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(refreshQueue, ^{
//        [user refreshHSDPSession];
//    });
//    dispatch_async(refreshQueue, ^{
//        [user refreshHSDPSession];
//    });
//    dispatch_async(refreshQueue, ^{
//        [user refreshHSDPSession];
//    });
//    dispatch_async(refreshQueue, ^{
//        [user refreshHSDPSession];
//    });
//    [user addHSDPUserDataInterfaceListener:self];
//    testRefreshHSDPAPIForHSDPErrorExpectation = [self expectationWithDescription:@"testRefreshHSDPAPIForHSDPErrorExpectation"];
//    [self waitForExpectations:[NSArray arrayWithObject:testRefreshHSDPAPIForHSDPErrorExpectation] timeout:10.0];
//}

//-(void)testRefreshHSDPAPIForHSDP1151Error  {
//    DIFakeUser *user = [[DIFakeUser alloc] init];
//    FakeJRService *jrService = [[FakeJRService alloc] init];
//    jrService.sleepTime = 1;
//    jrService.sendSuccess = true;
//    NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObject:@(1151)] forKeys:[NSArray arrayWithObject: @"responseCode"]];
//    NSString *locale = [self.appInfra.internationalization getBCP47UILocale];
//    NSError *error;
//    [self.appInfra.appConfig setPropertyForKey:HSDPConfiguration_ApplicationName group:@"UserRegistration" value:@"CDP" error:&error];
//    [self.appInfra.appConfig setPropertyForKey:HSDPConfiguration_Shared group:@"UserRegistration"
//                                           value:@"fe53a854-f9b0-11e6-bc64-92361f002671" error:&error];
//    [self.appInfra.appConfig setPropertyForKey:HSDPConfiguration_Secret group:@"UserRegistration"
//                                           value:@"057b97e0-f9b1-11e6-bc64-92361f002671" error:&error];
//    [self.appInfra.appConfig setPropertyForKey:HSDPConfiguration_BaseURL group:@"UserRegistration"
//                                           value:@"https://user-registration-assembly-hsdpchinadev.cn1.philips-healthsuite.com.cn" error:&error];
//    FakeHSDPService *hsdpService = [[FakeHSDPService alloc] initWithCountryCode:locale baseURL:@"www.google.com"];
//    hsdpService.sleepTime = 2;
//    hsdpService.sendSuccess = false;
//    hsdpService.hsdpError = [NSError errorWithDomain:@"Some error" code:1151 userInfo:dict];
//    user.fJRService = jrService;
//    user.fHSDPService = hsdpService;
//    dispatch_queue_t refreshQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(refreshQueue, ^{
//        [user refreshHSDPSession];
//    });
//    dispatch_async(refreshQueue, ^{
//        [user refreshHSDPSession];
//    });
//    dispatch_async(refreshQueue, ^{
//        [user refreshHSDPSession];
//    });
//    dispatch_async(refreshQueue, ^{
//        [user refreshHSDPSession];
//    });
//    [user addHSDPUserDataInterfaceListener:self];
//    hsdp1151ErrorRefreshExpectaion = [self expectationWithDescription:@"Refresh HSDP error2"];
//    [self waitForExpectations:[NSArray arrayWithObject:hsdp1151ErrorRefreshExpectaion] timeout:10.0];
//}

//-(void)testRefreshAllAPIForJRError {
//    DIFakeUser *user = [[DIFakeUser alloc] init];
//    FakeJRService *jrService = [[FakeJRService alloc] init];
//    jrService.sleepTime = 3;
//    jrService.sendSuccess = false;
//    jrService.jrError = [NSError errorWithDomain:@"Some JR error" code:0 userInfo:nil];
//    FakeHSDPService *hsdpService = [[FakeHSDPService alloc] initWithCountryCode:@"en_US" baseURL:@""];
//    hsdpService.sleepTime = 5;
//    hsdpService.sendSuccess = true;
//    user.fJRService = jrService;
//    user.fHSDPService = hsdpService;
//    dispatch_queue_t refreshQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(refreshQueue, ^{
//        [user refreshSession];
//    });
//    dispatch_async(refreshQueue, ^{
//        [user refreshSession];
//    });
//    dispatch_async(refreshQueue, ^{
//        [user refreshSession];
//    });
//    dispatch_async(refreshQueue, ^{
//        [user refreshSession];
//    });
//    [user addSessionRefreshListener:self];
//    testRefreshAllAPIForJRError2Exepectation = [self expectationWithDescription:@"testRefreshAllAPIForJRError"];
//    [self waitForExpectations:[NSArray arrayWithObject:testRefreshAllAPIForJRError2Exepectation] timeout:10.0];
//}
//
//-(void)testRefreshAllAPIForJRError2 {
//    DIFakeUser *user = [[DIFakeUser alloc] init];
//    FakeJRService *jrService = [[FakeJRService alloc] init];
//    jrService.sleepTime = 1;
//    jrService.sendSuccess = false;
//    jrService.jrError = [NSError errorWithDomain:@"Some JR error" code:0 userInfo:nil];
//    FakeHSDPService *hsdpService = [[FakeHSDPService alloc] initWithCountryCode:@"en_US" baseURL:@""];
//    hsdpService.sleepTime = 2;
//    hsdpService.sendSuccess = true;
//    user.fJRService = jrService;
//    user.fHSDPService = hsdpService;
//    dispatch_queue_t refreshQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(refreshQueue, ^{
//        [user refreshSession];
//    });
//    dispatch_async(refreshQueue, ^{
//        [user refreshSession];
//    });
//    dispatch_async(refreshQueue, ^{
//        [user refreshSession];
//    });
//    dispatch_async(refreshQueue, ^{
//        [user refreshSession];
//    });
//    [user addUserDataInterfaceListener:self];
//    jrErrorRefreshExpectaion = [self expectationWithDescription:@"testRefreshAllAPIForJRError2"];
//    [self waitForExpectations:[NSArray arrayWithObject:jrErrorRefreshExpectaion] timeout:10.0];
//}



@end


