//
//  DIHSDPConfiguration.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "DIHSDPConfiguration.h"
#import "RegistrationUtility.h"
#import "DIRegistrationConstants.h"
#import "DILogger.h"

@interface DIHSDPConfiguration()

@property (nonatomic, strong, readwrite) NSString *applicationName;
@property (nonatomic, strong, readwrite) NSString *sharedKey;
@property (nonatomic, strong, readwrite) NSString *secretKey;
@property (nonatomic, strong, readwrite) NSString *baseURL;

@end


@implementation DIHSDPConfiguration

+ (BOOL)isHSDPConfigurationAvailableForCountry:(NSString *)countryCode {
    NSString *appName = [RegistrationUtility configValueForKey:HSDPConfiguration_ApplicationName countryCode:countryCode error:nil];
    NSString *sharedKey = [RegistrationUtility configValueForKey:HSDPConfiguration_Shared countryCode:countryCode error:nil];
    NSString *secretKey = [RegistrationUtility configValueForKey:HSDPConfiguration_Secret countryCode:countryCode error:nil];
    if (appName.length <= 0 || sharedKey.length <= 0 || secretKey.length <= 0) {
        return NO;
    }
    return YES;
}

+ (BOOL)isHSDPSkipLoginConfigurationAvailable{
    return [[RegistrationUtility configValueForKey:HSDPConfiguration_Skip_HSDP countryCode:nil error:nil] boolValue];
}

- (instancetype)initWithCountryCode:(NSString *)countryCode baseURL:(NSString *)baseURL {
    self = [super init];
    if (self) {
        _applicationName = [RegistrationUtility configValueForKey:HSDPConfiguration_ApplicationName countryCode:countryCode error:nil];
        _sharedKey = [RegistrationUtility configValueForKey:HSDPConfiguration_Shared countryCode:countryCode error:nil];
        _secretKey = [RegistrationUtility configValueForKey:HSDPConfiguration_Secret countryCode:countryCode error:nil];
        if (baseURL.length > 0) {
            _baseURL = baseURL;
        }else {
            _baseURL = [RegistrationUtility configValueForKey:HSDPConfiguration_BaseURL countryCode:countryCode error:nil];
        }
        DIRDebugLog(@"HSDP configurations: appName-%@, sharedKey-%@, secretKey-%@, baseURL-%@", _applicationName, _sharedKey, _secretKey, _baseURL);
        if (_applicationName.length <= 0 || _sharedKey.length <= 0 || _secretKey.length <= 0 || _baseURL.length <= 0) {
            return nil;
        }
    }
    return self;
}

@end
