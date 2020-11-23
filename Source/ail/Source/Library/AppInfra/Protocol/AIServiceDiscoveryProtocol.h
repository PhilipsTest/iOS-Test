//
//  AIServiceDiscoveryProtocol.h
//  AppInfra
//
//  Created by Ravi Kiran HR on 6/20/16.
/*  Copyright ©  Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/
//

#import <Foundation/Foundation.h>
#import "AISDService.h"

FOUNDATION_EXPORT NSString * const AILServiceDiscoveryHomeCountryChangedNotification;
FOUNDATION_EXPORT NSString * const ServiceDiscoveryDataDownloadCompletedNotification;

/**
 Service discovery errors
 @since 2018.1.0
 */
typedef NS_ENUM (NSUInteger, AISDError)
{
    ///error when service discovery does not have the url for the service id
    AISDCannotFindURLError = 3500,
    ///unable to create url
    AISDMalformedURLError,
    ///error when service discovery does not have the locale for the service id
    AISDCannotFindLocaleError,
    ///server is not reachable
    AISDServerNotReachableError,
    ///error from server
    AISDServerError,
    ///error when internet is not reachable
    AISDNoNetworkError
};

/**
 protocol for defining service discovery methods
 */
@protocol AIServiceDiscoveryProtocol <NSObject>

// Service Discovery uses current locale from InternationalizationInterface and microsite + sector + state from AppIdentityInterface

/**
 * Returns a two character country code (ISO 3166-1)
 * When not yet set, the country code is automatically determined from the SIM card's country of registration.
 * If no SIM card is available/accessible; then geo-IP is used to determine the country.
 * Once determined the country is stored persistently and the stored country will be returned.
 * Using setHomeCountry() it is possible to change the stored home country.
 * @param completionHandler asynchronously returns in main queue the home country code according to ISO 3166-1, source indicates how the returned country code was determined or returns onError the error code when retrieval failed.
 * @since 1.0.0
 */
-(void)getHomeCountry:(void(^)(NSString *countryCode, NSString *sourceType, NSError *error))completionHandler;

/**
 * synchronous method to return the home country.
 * If the home country is not set the function returns null
 * @return the saved home country
 * @since 1.0.0
 */
-(NSString *)getHomeCountry;

/**
 * Persistently store Home country, overwrites any existing country value.
 * Changing the country automatically clears the cached service list and triggers a refresh.
 * @param countryCode country code to persistently store, code must be according to ISO 3166-1
 * @since 1.0.0
 */
-(void)setHomeCountry:(NSString *)countryCode;

/**
 * Returns the URLs + locales for a set of services with a preference for the current language.
 * @param serviceIds list of service names for which the URL + locale are to be retrieved
 * @param completionHandler A block object to be executed when it fetches urls successfully. This block has no return value and has two arguments: the services object, and the error object. The services object is a dictionary with service id as key and AISDService object will be value. It will contain the service discovery urls and key map values(if key indexes are available for that service id, see key manager module for more information)
 * @param replacement lookup table to be use to replace placeholders (key) with the given value, see {@link #applyURLParameters(URL, Map)}
 * @since 1.0.0
 */
-(void)getServicesWithLanguagePreference:(NSArray *)serviceIds
                   withCompletionHandler:(void(^)(NSDictionary<NSString*,AISDService*> *services,NSError *error))completionHandler
                             replacement:(NSDictionary *)replacement;

/**
 * Returns the URLs + locales for a set of services with a preference for the current home country.
 * @param serviceIds list of service names for which the URL + locale are to be retrieved
 * @param completionHandler A block object to be executed when it fetches urls successfully. This block has no return value and has two arguments: the services object, and the error object. The services object is a dictionary with service id as key and AISDService object will be value. It will contain the service discovery urls and key map values(if key indexes are available for that service id, see key manager module for more information)
 * @param replacement lookup table to be use to replace placeholders (key) with the given value, see {@link #applyURLParameters(URL, Map)}
 * @since 1.0.0
 */
-(void)getServicesWithCountryPreference:(NSArray *)serviceIds
                  withCompletionHandler:(void(^)(NSDictionary<NSString*,AISDService*> *services,NSError *error))completionHandler
                            replacement:(NSDictionary *)replacement;

/**
 * Start negotiation with cloud service for the list of service for this application. List is based on sector, microsite, home country, and language.
 * The retrieved list is cached internally (not persistently).
 * The cached list is automatically refreshed every 24hours.
 * A refresh is only required, to ensure the very first service request after app start can be processed from the cache quickly, or when a previous sync failed.
 * @param completionHandler is a block which asynchronously returns in main queue using onSuccess when retrieval was successful or returns onError the error code when retrieval failed.
 * @since 1.0.0
 */
-(void)refresh:(void(^)(NSError *error))completionHandler;

/**
 * Replaces all '%key%' placeholders in the given URL, where the key is the key in the replacement table and the placeholder is replaced with the value of the entry in the replacement table
 * @param URLString url in which to search for the key strings given by replacement
 * @param map mapping of placeholder string (key) to the replacement string (value)
 * @return input url with all placeholders keys replaced with the respective value in the replacement table
 * @since 1.0.0
 * @deprecated 1901
 */
-(NSString *)applyURLParameters:(NSString *)URLString parameters:(NSDictionary *)map __attribute__((deprecated("internal method not to be used publically")));

@end
