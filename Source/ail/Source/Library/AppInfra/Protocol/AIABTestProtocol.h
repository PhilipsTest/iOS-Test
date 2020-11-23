/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import <Foundation/Foundation.h>

/**
 * Protocol for defining A/B testing methods.
 * @since: 1804.0
 */
@protocol AIABTestProtocol <NSObject>

/**
 * AIABTestUpdateType enum is used to configure test name. A test name can be any of the following types.
 * @since: 1804.0
 */
typedef NS_ENUM(NSUInteger,AIABTestUpdateType)
{
    /**
     * These tests will be refreshed if you update cache after app-restart.
     * @since: 1804.0
     */
    AIABTestUpdateTypeAppStart = 1 ,
    /*
     * These tests will be refreshed if you update cache after app-update.
     * @since: 1804.0
     */
    AIABTestUpdateTypeAppUpdate = 2
};

/**
 * AIABTestCacheStatus enum is to indicate the different state of cache.
 * @since: 1804.0
 */
typedef NS_ENUM(NSUInteger,AIABTestCacheStatus)
{
    /**
     * All the experiences are not updated in AI cache.
     * @since: 1804.0
     */
    AIABTestCacheStatusExperiencesNotUpdated = 0,
    /**
     * All the experiences are updated in AI cache. Need not be from server, it can be default value also.
     * @since: 1804.0
     */
    AIABTestCacheStatusExperiencesUpdated,
};

/**
 * AIABTestErrorCode enum is used to map the error code
 * @since: 1804.0
 */
typedef NS_ENUM(NSUInteger,AIABTestErrorCode)
{   /**
     * This error will happen if try to update cache without internet
     * @since: 1804.0
     */
    AIABTestErrorCodeNoNetwork = 3600
};

/**
 * Download experience values from the server and map the configuration into AI in-memory cache
 * @param successBlock success block will be called once all experiences are mapped from server and updated in cache
 * @param errorBlock error block will be called on error
 * @since 1804.0
 */
-(void)updateCacheWithSuccess:(nullable void(^)(void))successBlock
                        error:(nullable void(^)( NSError* _Nullable error))errorBlock;

/**
 * Processes a target service request to return the experience value.
 * @param testName a string parameter refers to key name
 * @param defaultValue a string parameter which is returned as a default value on failure
 * @param updateType this is of AIABTestUpdateType enum to indicate the test name type
 * @return experience value for the testName.
 * @since 1804.0
 */
-(nonnull NSString*)getTestValue:(nonnull NSString*)testName
                   defaultContent:(nonnull NSString*)defaultValue
                       updateType:(AIABTestUpdateType)updateType;

/**
 * Returns the state of the cached experiences as AIABTestCacheStatus enum type
 * @return status of the experience cache.
 * @since 1804.0
 */
-(AIABTestCacheStatus)getCacheStatus;

/**
 * Enable or disable developer mode of Firebase. On enabling, latest firebase values will be fetched and mapped.
 * @param enable it sets true/false to configSettings of firebase.
 * @since 1804.0
 */
-(void)enableDeveloperMode:(BOOL)enable;

/**
* This gives the AbTest Consent key for DeviceStorageConsentHandle.
* @note Only Consent Definitions containing this key will be considered for ABTest Handling.
* If no such key is found then the app will crash.
* @return a NSString value which should be used as Identifier for ABTest Consent
* @since 1804
*/
- (nonnull NSString*)getABTestConsentIdentifier;

/**
 * Tags to firebase
 * @note Use this api to tag to firebase inorder to set as a goal metric
 * @param eventName Tag event
 * @param paramDict extra dictionary parameters
 * @since 1805
 */
-(void)tageventWithInfo:(nonnull NSString*)eventName
                 params:(nullable NSDictionary<NSString *,id>*)paramDict;


@end
