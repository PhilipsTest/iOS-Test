//
//  URLaunchInput.h
//  Registration
//
//  Created by Adarsh Kumar Rai on 11/08/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <UAPPFramework/UAPPFramework.h>
#import "DIRegistrationFlowConfiguration.h"
#import "DIRegistrationContentConfiguration.h"
@import PlatformInterfaces;

/**
 *  Implement this protocol to receive callbacks and display appropriate content when user's tap on TnC or PrivacyPolicy inside `PhilipsRegistration`.
 *
 *  @since 1.0.0
 */
@protocol DIRegistrationConfigurationDelegate <NSObject>

/**
 *  Called when user taps on Terms & conditions link on registration screen. App should display terms and conditions in this method.
 *
 *  @since 1.0.0
 */
- (void)launchTermsAndConditions;

/**
 *  Called when user taps on Privacy policy link on registration screen. App should display privacy policy in this method.
 *
 *  @since 1.0.0
 */
- (void)launchPrivacyPolicy;

/**
 *  Called when user taps on personal consent what does this mean hyper link on any registration screen. App should display description of the propostion personal consent  in this method. This is required only if user has enabled personal consent in AppConfig file.
 *
 *  @since 19.0.5
 */
@optional
- (void)launchPersonalConsentDescription;

@end



/**
 *  This class defines properties that can be used by applications to inform the kind of flow and content they would like to display to users when `PhilipsRegistration` is launched.
 *
 *  @since 1.0.0
 */
@interface URLaunchInput : UAPPLaunchInput

/**
 *  Set this delegate to handle callbacks for TnC and Privacy policy defined above.
 *
 *  @since 1.0.0
 */
@property (nonatomic, weak) id<DIRegistrationConfigurationDelegate> delegate;

/**
 *  Use the attributes of this property to inform `PhilipsRegistration` which flow to display.
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong) DIRegistrationFlowConfiguration *registrationFlowConfiguration;

/**
 *  Use the attributes of this property to inform `PhilipsRegistration` what content to display.
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong) DIRegistrationContentConfiguration *registrationContentConfiguration;

-(BOOL)isPersonalConsentToBeShown;

@end
