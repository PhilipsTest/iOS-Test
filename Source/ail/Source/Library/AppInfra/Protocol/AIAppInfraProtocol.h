//
//  AIAppInfraProtocol.h
//  AppInfra
//
//  Created by Senthil on 22/06/16.
/*  Copyright ©  Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/
//

#import <Foundation/Foundation.h>
FOUNDATION_EXPORT NSString * const InfraComponentsInitialisationCompleteNotification;

@protocol AILoggingProtocol, AIAppTaggingProtocol, AIStorageProviderProtocol,AIServiceDiscoveryProtocol,AIAppIdentityProtocol,AITimeProtocol,AIInternationalizationProtocol,AIAppConfigurationProtocol,AIRESTClientProtocol,AIABTestProtocol,AILanguagePackProtocol,AIAppUpdateProtocol, AIConsentManagerProtocol,ConsentHandlerProtocol,AICloudLoggingProtocol;

/**
 AppInfra protocol contains all the properties for appinfra modules
 @since 1.0.0
 */
@protocol AIAppInfraProtocol <NSObject>


/**
 consent protocol object
 @since 1803.0.0
 */
@property (nonatomic, strong) id<ConsentHandlerProtocol> deviceHandler;

/**
 logging protocol object
 @since 1.0.0
 */
@property (nonatomic, strong) id<AILoggingProtocol> logging;

/**
 cloud logging protocol object
 @since 1901.0.0
 */
@property (nonatomic, strong) id<AICloudLoggingProtocol> cloudLogging;

/**
 tagging protocol object
 @since 1.0.0
 */
@property (nonatomic, strong) id<AIAppTaggingProtocol> tagging;

/**
 secure storage protocol object
 @since 1.0.0
 */
@property (nonatomic, strong) id<AIStorageProviderProtocol> storageProvider;

/**
 app identity protocol object
 @since 1.0.0
 */
@property (nonatomic, strong) id<AIAppIdentityProtocol> appIdentity;

/**
 time sync protocol object
 @since 1.0.0
 */
@property (nonatomic, strong) id<AITimeProtocol>time;

/**
 service discovery protocol object
 @since 1.0.0
 */
@property (nonatomic, strong) id<AIServiceDiscoveryProtocol> serviceDiscovery;

/**
 internationalization protocol object
 @since 1.1.0
 */
@property (nonatomic, strong) id<AIInternationalizationProtocol> internationalization;

/**
 appconfig protocol object
 @since 1.0.0
 */
@property (nonatomic, strong) id<AIAppConfigurationProtocol> appConfig;

/**
 rest client protocol object
 @since 1.1.0
 */
@property (nonatomic, strong) id<AIRESTClientProtocol> RESTClient;

/**
 abtest protocol object
 @since 1.0.0
 */
@property (nonatomic, strong) id<AIABTestProtocol> abtest;

/**
 language pack protocol object
 @since 2.1.0
 */
@property (nonatomic, strong) id<AILanguagePackProtocol> languagePack;

/**
 app update protocol object
 @since 2.2.0
 */
@property (nonatomic, strong) id<AIAppUpdateProtocol> appUpdate;

/**
 consent manager protocol object
 @since 2018.1.0
 */
@property (nonatomic, strong) id<AIConsentManagerProtocol> consentManager;

@end
