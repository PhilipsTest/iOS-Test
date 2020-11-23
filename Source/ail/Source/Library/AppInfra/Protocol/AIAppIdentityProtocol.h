//
//  AIAppIdentityProtocol.h
//  AppInfra
//
//  Created by Ravi Kiran HR on 6/20/16.
//  Copyright © Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/
//

#import <Foundation/Foundation.h>

/**
 protocol for defining app identity methods
 */
@protocol AIAppIdentityProtocol <NSObject>

/**
 *  Description: Enum to select privacy status
 */
typedef NS_ENUM(NSUInteger,AIAIAppState)
{
    AIAIAppStateTEST = 1,
    AIAIAppStateDEVELOPMENT = 2,
    AIAIAppStateSTAGING = 3,
    AIAIAppStateACCEPTANCE =4,
    AIAIAppStatePRODUCTION =5
    
};

/**
 *  Method to get microsite ID
 *
 * @return microsite ID
 * @since 1.0.0
 */
-(NSString *)getMicrositeId;

/**
 *  Method to get AppState
 *
 *  @return AppState
 *  @since 1.0.0
 */
-(AIAIAppState)getAppState;

/**
 * Method to get Sector
 *
 * @return Sector
 * @since 1.0.0
 */
-(NSString *)getSector;

/**
 *  Method to get AppName
 *
 *  @return AppName
 *  @since 1.0.0
 */
-(NSString *)getAppName;

/**
 *  Method to get LocalizedAppName
 *
 *  @return LocalizedAppName
 *  @since 1.0.0
 */
-(NSString *)getLocalizedAppName;

/**
 * Method to get AppVersion
 *
 * @return AppVersion
 * @since 1.0.0
 */
-(NSString *)getAppVersion;

/**
 *  Method to getServiceDiscoveryEnvironment
 *
 *  @return getServiceDiscoveryEnvironment
 *  @since 1.0.0
 */
-(NSString *)getServiceDiscoveryEnvironment;

@end
