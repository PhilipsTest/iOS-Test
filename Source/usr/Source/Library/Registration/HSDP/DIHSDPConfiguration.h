//
//  DIHSDPConfiguration.h
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>

@interface DIHSDPConfiguration : NSObject

/**
 Method to check if HSDP Configurations are available to connect to HSDP server. It checks for each of the configurations except for BaseURL which is downloaded from ServiceDiscovery and might take time to appear.

 @param countryCode for which configurations are to be retrieved.
 @return True if configurations are available for given country. False, otherwise.
 */
+ (BOOL)isHSDPConfigurationAvailableForCountry:(NSString *)countryCode;

/**
 Method to check if HSDP Skip loading are available to connect to HSDP. It checks for the true and false to enable skip hsdp login
 
 @return True if hsdp skip loading is available. False, otherwise.
 */
+ (BOOL)isHSDPSkipLoginConfigurationAvailable;

- (instancetype)init NS_UNAVAILABLE;

/**
 Method to initialize HSDPConfiguration.
 
 @param countryCode countryCode for which the configuration has to be loaded.
 @param baseURL baseURL of the HSDP instance that is to be used. This value should be provided from ServiceDiscovery and if not provided, initializer will try to read it from AIAppConfig.
 @return an instance of HSDPConfiguration if all the attributes are available, nil if one or more attributes are missing.
 */
- (instancetype)initWithCountryCode:(NSString *)countryCode baseURL:(NSString *)baseURL NS_DESIGNATED_INITIALIZER;

/**
 *  Get the application name as used in HSDP server.
 */
@property (nonatomic, strong, readonly) NSString *applicationName;

/**
 *  Get the shared key to be used in HSDP communications.
 */
@property (nonatomic, strong, readonly) NSString *sharedKey;

/**
 *  Get the secret key to be used in HSDP communications.
 */
@property (nonatomic, strong, readonly) NSString *secretKey;

/**
 *  Get the base URL to be used in HSDP communications.
 */
@property (nonatomic, strong, readonly) NSString *baseURL;

@end
