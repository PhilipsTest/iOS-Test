//
//  AILanguagePackProtocol.h
//  AppInfra
//
//  Created by Hashim MH on 13/03/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 protocol for defining language pack methods
 */
@protocol AILanguagePackProtocol <NSObject>
/**
 * - AILPRefreshStatusRefreshedFromServer:   Downloaded from server
 * - AILPRefreshStatusNoRefreshRequired:     No refresh required
 * - AILPRefreshStatusRefreshFailed:         Refresh Failed
 */
typedef NS_ENUM(NSUInteger,AILPRefreshStatus)
{
    AILPRefreshStatusRefreshedFromServer,
    AILPRefreshStatusNoRefreshRequired,
    AILPRefreshStatusRefreshFailed
};

/**Error enums
 * - AILPErrorFatalError: Not able to find the url for language pack
 * - AILPErrorServiceIdError: Invalid ServiceID
 * - AILPErrorInvalidJson: Downloaded json is invalid
 */
typedef NS_ENUM(NSUInteger,AILPError)
{
    AILPErrorFatalError          = 1,
    AILPErrorServiceIdError      = 3,
    AILPErrorInvalidJson         = 4
};

/**LanguagePack Activate status enums
 * - AILPActivateStatusUpdateActivated: Language Pack successfully activated
 * - AILPActivateStatusNoUpdateStored: intial value given to ActivateStatus
 * - AILPActivateStatusFailed: Failed to activate Language Pack
 */
typedef NS_ENUM(NSUInteger,AILPActivateStatus)
{   AILPActivateStatusUpdateActivated =1,
    AILPActivateStatusNoUpdateStored,
    AILPActivateStatusFailed
};

/**
 * refreshes the overview file containing the list of languages available in the server
 * and also downloads the language pack based on the user preferred ui locale
 * @param completionHandler with refresh status and error if refresh failed
 * @since 2.1.0
 */
-(void)refresh:(nullable void(^)(AILPRefreshStatus refreshResult,NSError * _Nullable error))completionHandler;

/**
 * activates the Language Pack downloaded for the preferred ui locale
 * @param completionHandler with activate status and error if activate failed
 * @since 2.1.0
 */
-(void)activate:(nullable void(^)(AILPActivateStatus activatedStatus,NSError * _Nullable error))completionHandler;

/**
 * returns the localized string from cloud bundle
 * if it not there in cloud will look in main bundle
 * if not found will return the key
 * @param key localization key
 * @return localised string value
 * @since 2.1.0
 */
- (nullable NSString *)localizedStringForKey:(NSString *_Nonnull)key;
@end
