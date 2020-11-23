//
//  AppInfra.h
//  AppInfra
//
//  Created by Ravi Kiran HR on 4/4/16.
/* Copyright (c) Koninklijke Philips N.V., 2016
* All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
*/  
//

#import <UIKit/UIKit.h>

//! Project version number for AppInfra.
FOUNDATION_EXPORT double AppInfraVersionNumber;

//! Project version string for AppInfra.
FOUNDATION_EXPORT const unsigned char AppInfraVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <AppInfra/PublicHeader.h>

#import <AppInfra/AIAppInfra.h>
#import <AppInfra/AILoggingProtocol.h>
#import <AppInfra/AIAppInfraProtocol.h>
#import <AppInfra/AIAppTaggingProtocol.h>
#import <AppInfra/AIStorageProviderProtocol.h>
#import <AppInfra/AIServiceDiscoveryProtocol.h>
#import <AppInfra/AIAppIdentityProtocol.h>
#import <AppInfra/AIAppInfraBuilder.h>
#import <AppInfra/AITimeProtocol.h>
#import <AppInfra/AIInternationalizationProtocol.h>
#import <AppInfra/AIAppConfigurationProtocol.h>
#import <AppInfra/AIRESTClientProtocol.h>
#import <AppInfra/AIRESTClientURLResponseSerialization.h>
#import <AppInfra/AIABTestProtocol.h>
#import <AppInfra/AIAPISigningProtocol.h>
#import <AppInfra/AIClonableClient.h>
#import <AppInfra/AILanguagePackProtocol.h>
#import <AppInfra/AIComponentVersionInfoProtocol.h>
#import <AppInfra/AIAppUpdateProtocol.h>
#import <AppInfra/AICloudApiSigner.h>
#import <AppInfra/AICloudLoggingProtocol.h>
#import <AppInfra/AITaggingError.h>

#import <AppInfra/AIUtility.h>
#import <AppInfra/AIInternalTaggingUtility.h>
#import <AppInfra/AIInternalLogger.h>
#import <AppInfra/AILogMetaData.h>
#import <AppInfra/AICloudLogMetadata.h>
#import <AppInfra/AILogUtilities.h>
#import <AppInfra/AICloudLogger.h>
