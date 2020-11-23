//
//  AICloudLoggingProtocol.h
//  AppInfra
//
//  Created by Philips on 1/22/19.
//  Copyright © 2019 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol AICloudLoggingProtocol <AILoggingProtocol>

/**
 This gives the Cloud Logging key for DeviceStorageConsentHandle.
 @note Only Consent Definitions containing this key will be considered for Cloud Logging Handling.
 If no such key is found then the app will crash.
 @return a NSString value which should be used as Identifier for Cloud Logging Consent
 @since 1901
 */
-(NSString*)getCloudLoggingConsentIdentifier;

/**
 *  To identify log originated from which user
 *  set/reset when user login/logout
 *  can be empty (will not be able to track based on user)
 *
 *  userHSDPUUID HSDP ID of originatingUser
 *  @since 1901
 */
@property(nonatomic,strong)NSString* hsdpUserUUID;


@end
