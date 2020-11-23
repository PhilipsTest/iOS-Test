//
//  DIRegistrationContentConfiguration.h
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//
//  Note- This class contains all the properties to hold the data that needs to be pre-filled in registration if provided by the app.

#import <Foundation/Foundation.h>
@import PlatformInterfaces;

@interface DIRegistrationContentConfiguration : NSObject

/**
 *  Set the title of 'why the user needs to register'. To be displayed at screen UR-1.(Please refer to the flow document for more info)
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong) NSAttributedString *valueForRegistrationTitle;

/**
 *  Set the description of 'why the user needs to register'. To be displayed at screen UR-1.(Please refer to the flow document for more info)
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong) NSAttributedString *valueForRegistrationDescription;

/**
 *  Set the description why the user needs to verify the account. To be displayed at screen UR-2c.(Please refer to the flow document for more info)
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong) NSString *valueForEmailVerification;

/**
 *  Set the title of the Opt-In Screen
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong) NSString *optInTitleText;

/**
 *  Set the quessionary text of the Opt-In Screen
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong) NSString *optInQuessionaryText;

/**
 *  Set the description text of the Opt-In Screen
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong) NSString *optInDetailDescription;

/**
 *  Set the banner text of the Opt-In Screen
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong) NSString *optInBannerText;

/**
 *  Set the Navigation Bar title of the Opt-In Screen
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong) NSString *optInBarTitleText;

/**
 * Set the image of the opt-In screen
 * If not set then no image will be displayed in the optin screen
 *
 * @since 1803.0.0
 */
@property (nonatomic, strong) UIImage *optinImage;

/**
 * Provide personal consent defnition object
 * If not set then no personal consent will be shown
 *
 * @since 1904.0.0
 */
@property (nonatomic, strong) ConsentDefinition *personalConsent;

/**
 * Provide personal consent not accepted error message
 * If personal consent will not be selected this error message will be shown
 *
 * @since 1904.0.0
 */
@property (nonatomic, strong) NSString *personalConsentErrMssge;


@end
