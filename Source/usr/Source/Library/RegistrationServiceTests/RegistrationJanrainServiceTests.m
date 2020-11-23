//
//  RegistrationJanrainServiceTests.m
//  RegistrationJanrainServiceTests
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "JanrainService.h"
#import "DIRegistrationVersionMock.h"
#import "DIRegistrationJsonMock.h"
#import "DIRegistrationConfigurationMock.h"
#import "DIJanrainConfigurationSettings.h"

#define TIMEOUT 10.0

typedef enum : NSUInteger {
    ServiceStatusSuccess=0,
    ServiceStatusFailed=2,
    ServiceStatusTimedOut=3,
} ServiceStatus;

@interface RegistrationJanrainServiceTests : XCTestCase
@property (assign, nonatomic) BOOL shouldWaitForService;
@end

@implementation RegistrationJanrainServiceTests

- (void)setUp {
    [super setUp];
    [DIRegistrationJsonMock mockJsonConfigurationForEnvironment:@"Staging" forFlow:StandardFlow];
    [DIRegistrationVersionMock mockRegistrationVersion:@"1.2.44"];
    [DIRegistrationConfigurationMock mockPUIKitFonts];
    [DIJanrainConfigurationSettings janrainSettingsWithLocale:@"en_US" andCompletion:^{}];
    self.shouldWaitForService=YES;
}

- (void)testLoginUsingTraditionalEmail {
    __block ServiceStatus serviceStatus=ServiceStatusTimedOut;
    [JanrainService loginUsingTraditionalWithEmail:@"philips993@mailinator.com" password:@"123456a#" success:^(JRCaptureUser *user, BOOL isUpdated) {
        serviceStatus=ServiceStatusSuccess;
        self.shouldWaitForService=NO;
    } failed:^(NSError *error) {
        serviceStatus=ServiceStatusFailed;
        self.shouldWaitForService=NO;
    }];
    [self waitForResponseWithTimeout];
    [self checkServiceStatus:serviceStatus];
}

- (void)testRegisterTraditionalWithEmail {
    __block ServiceStatus serviceStatus=ServiceStatusTimedOut;
    [JanrainService registerNewUserUsingEmail:[self generateNewEmail] withMobileNumber:nil withName:@"philips" withOlderThanAgeLimit:YES withReceiveMarketingMails:YES success:^(JRCaptureUser *user, BOOL isUpdated)
    {
        serviceStatus = ServiceStatusSuccess;
        self.shouldWaitForService = NO;
    }                                 failure:^(NSError *error)
    {
        serviceStatus = ServiceStatusFailed;
        self.shouldWaitForService = NO;
    }                            withPassword:@"123456a#"];
    [self waitForResponseWithTimeout];
    [self checkServiceStatus:serviceStatus];
}

- (void)testForgotPassword {
    __block ServiceStatus serviceStatus=ServiceStatusTimedOut;
    [JanrainService forgotPasswordForEmail:@"mail_467630575.734455@mail.com" andLocale:@"en-US" success:^{
        serviceStatus=ServiceStatusSuccess;
        self.shouldWaitForService=NO;
    } failure:^(NSError *error) {
        serviceStatus=ServiceStatusFailed;
        self.shouldWaitForService=NO;
    }];
    [self waitForResponseWithTimeout];
    [self checkServiceStatus:serviceStatus];
}

- (void)testRefetchUser {
    __block ServiceStatus serviceStatus=ServiceStatusTimedOut;
    [JanrainService loginUsingTraditionalWithEmail:@"mail_467639208.756324@mail.com" password:@"123456a#" success:^(JRCaptureUser *user, BOOL isUpdated) {
       [JanrainService refetchUserProfileWithSuccess:^(JRCaptureUser *user, BOOL isUpdated) {
           serviceStatus=ServiceStatusSuccess;
           self.shouldWaitForService=NO;
       } failure:^(NSError *error) {
           serviceStatus=ServiceStatusFailed;
           self.shouldWaitForService=NO;
       }];
    } failed:^(NSError *error) {
        serviceStatus=ServiceStatusFailed;
        self.shouldWaitForService=NO;
    }];
    [self waitForResponseWithTimeout];
    [self checkServiceStatus:serviceStatus];
}

- (void)testRefreshLoginSession {
    __block ServiceStatus serviceStatus=ServiceStatusTimedOut;
    [JanrainService loginUsingTraditionalWithEmail:@"mail_467639243.403072@mail.com" password:@"123456a#" success:^(JRCaptureUser *user, BOOL isUpdated) {
        [JanrainService refreshAccessTokenWithSuccess:^{
            serviceStatus=ServiceStatusSuccess;
            self.shouldWaitForService=NO;
        } failure:^(NSError *error) {
            serviceStatus=ServiceStatusFailed;
            self.shouldWaitForService=NO;
        }];
    } failed:^(NSError *error) {
        serviceStatus=ServiceStatusFailed;
        self.shouldWaitForService=NO;
    }];
    [self waitForResponseWithTimeout];
    [self checkServiceStatus:serviceStatus];
}

#pragma mark - Helper Methods
- (void)waitForResponseWithTimeout {
    NSDate* giveUpDate = [NSDate dateWithTimeIntervalSinceNow:TIMEOUT];
    while (self.shouldWaitForService && [giveUpDate timeIntervalSinceNow] > 0) {
        NSDate *stopDate = [NSDate dateWithTimeIntervalSinceNow:2.0];
        [[NSRunLoop currentRunLoop] runUntilDate:stopDate];
    }
}

- (void)checkServiceStatus:(ServiceStatus)status {
    switch (status) {
        case ServiceStatusFailed:
            XCTFail(@"Service failed");
            break;
        case ServiceStatusTimedOut:
            XCTFail(@"Service timed out");
            break;
        case ServiceStatusSuccess:
            NSLog(@"Service successfull");
            break;
    }
}

- (NSString*)generateNewEmail {
    NSTimeInterval timeInterval=[NSDate timeIntervalSinceReferenceDate];
    return [NSString stringWithFormat:@"mail_%f@mail.com", timeInterval];
}
@end
