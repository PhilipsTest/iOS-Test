//
//  DCHandler.m
//  DigitalCareLibrary
//
//  Created by sameer sulaiman on 28/05/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "DCHandler.h"
#import "DCPluginManager.h"

id consumerInfo;
static NSString* appSpecificConfigFilePath;
static NSString* appSpecificChatURL;
static ConsentDefinition *locationConsent;
static DCContentConfiguration *contentConfiguration;

@implementation DCHandler

+(void) setConsumerProductInfo :(id) productInfo
{
    consumerInfo=productInfo;
}

+(id)getConsumerProductInfo
{
    return consumerInfo;
}

+ (NSString*)getAppSpecificConfigFilePath
{
    return appSpecificConfigFilePath;
}

+ (void)setAppSpecificConfigFilePath:(NSString*)configFilePath
{
    appSpecificConfigFilePath = configFilePath;
}

+ (NSString*)getAppSpecificLiveChatURL
{
    return appSpecificChatURL;
}

+ (void)setAppSpecificLiveChatURL:(NSString*)chatURL
{
    appSpecificChatURL = chatURL;
}

+ (ConsentDefinition *)getLocationConsentDefinition {
    return locationConsent;
}

+ (void)setLocationConsentDefinition:(ConsentDefinition *)locationConsentDefinition {
    locationConsent = locationConsentDefinition;
}

+ (void)setContentConfiguration:(DCContentConfiguration *)contentConfig {
    contentConfiguration = contentConfig;
}

+ (DCContentConfiguration *)getContentConfiguration {
    return contentConfiguration;
}

@end
