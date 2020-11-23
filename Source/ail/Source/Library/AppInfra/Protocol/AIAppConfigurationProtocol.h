//
//  AIAppConfigurationProtocol.h
//  AppInfra
//
//  Created by leslie on 01/08/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const AppConfigCloudRefreshCompletedNotification;


/**
 protocol for defining app configuration methods
 */
@protocol AIAppConfigurationProtocol <NSObject>

//Error enums
typedef NS_ENUM(NSUInteger,AIACError)
{
    AIACErrorNoError             = 0,
    AIACErrorFatalError          = 1,
    AIACErrorInvalidParameter    = 2,
    AIACErrorNoDataFoundForKey   = 3,
    AIACErrorGroupNotExists      = 4,
    AIACErrorKeyNotExists        = 5,
    AIACErrorDeviceStoreError    = 6,
    AIACErrorServerError         = 7,
    AIACErrorDownloadInProgress  = 8
};

/**
 - AIACRefreshResultRefreshedFromServer:   Downloaded from server
 - AIACRefreshResultNoRefreshRequired:     No refresh required
 - AIACRefreshResultRefreshFailed:         Refresh Failed
 */
typedef NS_ENUM(NSUInteger,AIACRefreshResult)
{
    AIACRefreshResultRefreshedFromServer =1,
    AIACRefreshResultNoRefreshRequired,
    AIACRefreshResultRefreshFailed,
};

/**
 *  Gets property for key
 *
 *  @param key the key
 *  @param group the group name
 *  @param error the configError as OUT parameter; errorCode is null in case of success, or contains error value on failure
 *  @throws IllegalArgumentException if group or key are null, empty string, or contain other characters than [a-zA-Z0-9_.-]
 *  @return the value for key mapped by name, or null if no such mapping exists
 *  @note if value is literal then 'String' Object is returned
 *  if value is number then 'Integer' Object is returned
 *  if value is array of literal then 'array of String' Object is returned
 *  if value is array of number then 'array of Integer' Object is returned
 *  @since 1.0.0
 */
-(id)getPropertyForKey: (NSString *)key group:(NSString *)group error:(NSError **)error;

/**
 *  Sets property for key
 *
 *  @param key the key
 *  @param group the group name
 *  @param value new value that needs to be set for the key. Value can be String, Number, Array of Strings, Array of Numbers and Dictionary
 *  @param error the configError as OUT parameter; errorCode is null in case of success, or contains error value on failure
 *  @throws IllegalArgumentException if group or key or value are null, empty string, or contain other characters than [a-zA-Z0-9_.-]
 *  @returns Bool indicating whether value is set correctly
 *  @since 1.0.0
 */
-(BOOL)setPropertyForKey: (NSString *)key group:(NSString *)group value:(id)value error:(NSError **)error;

/**
 *  Gets property for key from the static file
 *
 *  @param key the key
 *  @param group the group name
 *  @param error the configError as OUT parameter; errorCode is null in case of success, or contains error value on failure
 *  @throws IllegalArgumentException if group or key are null, empty string, or contain other characters than [a-zA-Z0-9_.-]
 *  @return the value for key mapped by name, or null if no such mapping exists
 *  @note if value is literal then 'String' Object is returned
 *  if value is number then 'Integer' Object is returned
 *  if value is array of literal then 'array of String' Object is returned
 *  if value is array of number then 'array of Integer' Object is returned
 *  @since 1.0.0
 */

-(id)getDefaultPropertyForKey: (NSString *)key group:(NSString *)group error:(NSError **)error;


/**
 * Refresh cloud config.
 * It will be downloaded if the URL of the config in Service Discovery has changed compared to last time the config was downloaded
 * @param completionHandler asynchronous callback reporting result of refresh. This block has no return value and takes two arguments:refreshResult and error
 * completionHandler will be called on main thread.
 * @since 2.1.0
 */
-(void)refreshCloudConfig :(void(^)(AIACRefreshResult refreshResult,NSError * error))completionHandler;

/**
 used to reset the dynamic config as well as cloud config

 @param error error description
 @returns returns bool status
 @since 2.2.0
 */
-(BOOL)resetConfig:(NSError **)error;

@end
