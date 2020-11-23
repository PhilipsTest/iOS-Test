//
// URMarketingConsentHandler.h
// PhilipsRegistration
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

@import PlatformInterfaces;

/**
 *  This class conforms ConsentHandlerProtocol which helps applications to query or store marketing consents of user. ConsentHandlerProtocol has group of methods to fetch or store marketing consents.
 *
 *  @since 2018.1.0
 */
@interface URMarketingConsentHandler : NSObject<ConsentHandlerProtocol>

@end


/**
 *  This class conforms ConsentHandlerProtocol which helps applications to query or store marketing consents of user. ConsentHandlerProtocol has group of methods to fetch or store marketing consents.
 *
 *  @since 2001.1.0
 */
@interface URPersonalConsentHandler : NSObject<ConsentHandlerProtocol>

@end


