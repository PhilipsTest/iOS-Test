//
//  DCHandler.h
//  DigitalCareLibrary
//
//  Created by sameer sulaiman on 28/05/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DCContentConfiguration.h"
@import PlatformInterfaces;

@interface DCHandler : NSObject

+ (id)getConsumerProductInfo;
+ (void)setConsumerProductInfo :(id) productInfo;
+ (NSString*)getAppSpecificConfigFilePath;
+ (void)setAppSpecificConfigFilePath:(NSString*)configFilePath;
+ (NSString*)getAppSpecificLiveChatURL;
+ (void)setAppSpecificLiveChatURL:(NSString*)chatURL;
+ (ConsentDefinition *)getLocationConsentDefinition;
+ (void)setLocationConsentDefinition:(ConsentDefinition *)locationConsentDefinition;
+ (void)setContentConfiguration:(DCContentConfiguration *)contentConfig;
+ (DCContentConfiguration *)getContentConfiguration;

@end
