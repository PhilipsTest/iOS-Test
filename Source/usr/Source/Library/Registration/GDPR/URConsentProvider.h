//
// URConsentProvider.h
// PhilipsRegistration
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

@import PlatformInterfaces;

/**
 *  This class defines methods that can be used by applications to query marketing consent definition of user.
 *
 *  @since 2018.1.0
 */
@interface URConsentProvider : NSObject

/**
 *  Gets the marketing consent of user.
 *
 *  @param  locale  Locale parameter needs to be passed as to fetch the consent of particular country.
 *
 *  @return consentDefinition ConsentDefinition object is returned.
 *
 *  @since 2018.1.0
 */
+ (ConsentDefinition * _Nonnull)fetchMarketingConsentDefinition:(NSString * _Nonnull)locale;

/**
 *  Gets the Personal consent of user.
 *
 *  @return consentDefinition ConsentDefinition object is returned.
 *
 *  @since 1904.0.0
 */


+ (ConsentDefinition * _Nonnull)fetchPersonalConsentDefinition;

+ (NSString * _Nonnull)personalConsentErrorMessage;

@end
