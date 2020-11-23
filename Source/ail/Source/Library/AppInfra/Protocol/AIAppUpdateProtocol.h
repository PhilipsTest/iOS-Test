//
//  AIAppUpdateProtocol.h
//  AppInfra
//
//  Created by Hashim MH on 10/05/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 protocol for defining app update methods
 */
@protocol AIAppUpdateProtocol <NSObject>

/**
 * - AIAppUpdateRefreshSuccess:   App Update info Downloaded from server
 * - AIAppUpdateRefreshFailed:    Refresh Failed
 */
typedef NS_ENUM(NSUInteger,AIAppUpdateRefreshStatus)
{
    AIAppUpdateRefreshStatusSuccess,
    AIAppUpdateRefreshStatusFailed
};

/**
 * Refreshes the appupdate info available in the server.
 * Refresh will fail if appUpdate.serviceId is missing in appconfig
 * or service discovery is not configured for appupdate
 * or the content of the appupdate file is not in the specified format
 * @param completionHandler completionHandler with refresh status and error if refresh failed
 * @since 2.2.0
 */
-(void)refresh:(nullable void(^)(AIAppUpdateRefreshStatus refreshResult,
                                 NSError * _Nullable error))completionHandler;

/**
 * This will return true if  applicationVersion < minimumVersion.
 * true when current application version is less than the minimumVersion, 
 * true when deprecatedVersion is greater than current application version and deprecationDate is crossed
 * @return Bool indicating app is deprecated or not
 * @since 2.2.0
 */
-(BOOL)isDeprecated;

/**
 * minimumVersion  <= application version <= toBeDeprecated
 * true if application is not already deprecated and current version is lessthan equal to deprecatedVersion
 * @return Bool indicating app is going to be deprecated or not
 * @since 2.2.0
 */
-(BOOL)isToBeDeprecated;

/**
 * applicationversion < currentVersion
 * true if current version is less than the latest version available in the appstore
 * @return Bool indicating update for the app is available or not
 * @since 2.2.0
 */
-(BOOL)isUpdateAvailable;

/**
 * Deprecated Version message string
 * @return String deprecated message
 * @since 2.2.0
 */
-(nullable NSString*)getDeprecateMessage;

/**
 * To be deprecated message string
 * @return String to be deprecated message
 * @since 2.2.0
 */
-(nullable NSString*)getToBeDeprecatedMessage;

/**
 * To be deprecated Date
 * @return Date to be deprecated date
 * @since 2.2.0
 */
-(nullable NSDate*)getToBeDeprecatedDate;

/**
 * currentVersionMessage
 * @return String update message
 * @since 2.2.0
 */
-(nullable NSString*)getUpdateMessage;


/**
 * minimumVersion
 * @return String minimum version
 * @since 2.2.0
 */
-(nullable NSString*)getMinimumVersion;

/**
 * minimum Os Version
 * @return String minimum OS version
 * @since 2.2.0
 */
-(nullable NSString*)getMinimumOsVersion;

/**
 *  minimum Os message
 * @return String minimum OS message
 * @since 1802
 */
-(nullable NSString*)getMinimumOsMessage;

@end
NS_ASSUME_NONNULL_END

