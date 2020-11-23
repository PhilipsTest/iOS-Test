//
//  AILogUtilities.h
//  AppInfra
//
//  Created by Hashim MH on 30/04/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
@protocol AIRESTClientProtocol;

@interface AILogUtilities : NSObject
typedef NS_ENUM(NSUInteger, AIAIAppState);
typedef NS_ENUM(NSInteger, AILogLevel);
/**
 *  "method will give the network Type"
 *
 *  @param restClient networkType should be fetched from this restClient
 *
 *  @return network type as string like WIFI, MOBILE_DATA, NO_NETWORK
 *  @since 1802.0.0
 */
+(NSString *)networkTypeFromRESTClient:(id<AIRESTClientProtocol>)restClient;

/**
 *  "method converts appstate enum to string"
 *
 *  @return appState as string
 *  @since 1802.0.0
 */
+(NSString*)stateString:(AIAIAppState)state;

/**
 *  "method will return the device model"
 *  @return device model as string
 *  @since 1802.0.0
 */
+(NSString *)deviceName;

/**
 *  "method will return 32 byte unique string"
 *  @return unique uuid
 *  @since 1802.0.0
 */
+(NSString *)generateLogId;

/**
 *  "method will convert DDLogFlag enum to string"
 *  @return log flag as string eg: ERROR, WARNING . . .
 *  @since 1802.0.0
 */
+(NSString *)logLevel:(DDLogFlag)flag;

+(NSString *)systemInfo;
+(DDLogFlag)aiFlagtoDDLogFlag:(AILogLevel)aiLogLevelFlag;
@end
