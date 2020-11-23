//
//  DIRegistrationFlowConfiguration.h
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>
@import PlatformInterfaces;

/**
 An enum that defines different priority functions that can be used to inform `PhilipsRegistration` which function is more likely to be opted by user and help organize UI in that fashion.

 - URPriorityFunctionRegistration:  Informs that user is more likely to go for registration than sign in and `PhilipsRegistration` will organize UI to display registration options prominently.
 - URPriorityFunctionSignIn:        Informs that user is more likely to go for sign in that registration and `PhilipsRegistration` will organize UI to display sign in options prominently.
 */
typedef NS_ENUM(NSInteger, URPriorityFunction) {
    URPriorityFunctionRegistration,
    URPriorityFunctionSignIn
};


/**
 An enum that allows applications to choose from different ways in which `PhilipsRegistration` can display Marketing Opt-In content to users.

 - URReceiveMarketingFlowFromServer:    Informs `PhilipsRegistration` to use the experience from A/B test server.
 - URReceiveMarketingFlowControl:       Informs `PhilipsRegistration` to display Opt-in in create account screen along with other fields.
 - URReceiveMarketingFlowSplitSignUp:   Informs `PhilipsRegistration` to display Opt-in in separate screen after account creation.
 - URReceiveMarketingDefault:           Same as URReceiveMarketingFlowFromServer. Deprecated.
 */
typedef NS_ENUM(NSInteger, URReceiveMarketingFlow) {
    URReceiveMarketingFlowFromServer,  //Use this value if you want UR to read the experience from A/B test server. Use other values to override the experience received from server.
    URReceiveMarketingFlowControl,
    URReceiveMarketingFlowCustomOptin,
    URReceiveMarketingFlowSkipOptin,
    URReceiveMarketingFlowSplitSignUp
};

/**
 An enum that allows applications to display either the Martketing Optin screen or My Details screen when the user is logged in.
 
 - URLoggedInScreenMarketingOptIn:      Informs `PhilipsRegistration` to launch Marketing Optin screen.
 - URLoggedInScreenMyDetails:           Informs `PhilipsRegistration` to launch My Details screen.
 */
typedef NS_ENUM(NSInteger, URLoggedInScreen) {
    URLoggedInScreenMarketingOptIn,
    URLoggedInScreenMyDetails
};


/**
 *  A class that lets application inform `PhilipsRegistration` which flow to launch.
 *
 *  @since 1.0.0
 */
@interface DIRegistrationFlowConfiguration : NSObject

/**
 *  Set this variable if the app need Create button on top or bottom in Registration Welcome page. Default is Create on top.
 *
 *  @since 1.0.0
 */
@property (nonatomic, assign) URPriorityFunction priorityFunction;

/**
 *  Set the property will override the A/B Testing flow.
 *
 *  @since 1.0.0
 */
@property (nonatomic, assign) URReceiveMarketingFlow receiveMarketingFlow;

/**
 *  LoggedInScreen will tell whether the Marketing Optin or My Details screen is to be displayed.
 *
 *  @since 2018.1.0
 */
@property (nonatomic, assign) URLoggedInScreen loggedInScreen;

/**
 * Allows applications to set if UR should do pop animation when exiting from UR. Default value is true.
 *
 * @since 2018.2.0
 */
@property (nonatomic, assign) BOOL animateExit;

/**
 *  Get if terms and conditions are required to be accepted. Default value is false.(Optional)
 *
 *  @since 1.0.0
 */
@property (nonatomic, assign, readonly) BOOL isTermsAndConditionsAcceptanceRequired;

/**
 *  Get minimum age limit to be allowed for the user to register.(Optional)
 *
 *  @since 1.0.0
 */
@property (nonatomic, assign, readonly) int minimumAgeLimit;

/**
 *  Set the list of sign-in providers to be displayed for the current locale.
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong, readonly) NSArray *signInProviders;

/**
 *  Get this variable if the app need to use Country Selection with in app. Default value is NO.
 *
 *  @since 1.0.0
 */
@property (nonatomic, assign) BOOL hideCountrySelection;

/**
 *  URL to be used for email verification landing page. Will be downloaded from ServiceDiscovery.
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong, readonly) NSString *loginPageURL;

/**
 *  URL to be used for reset password landing page. Will be downloaded from ServiceDiscovery.
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong, readonly) NSString *resetPasswordURL;

/**
 *  Set the value to enable users to be able to skip registration. Default is False. To be displayed at screen UR-1.(Please refer to the flow document for more info)
 *
 *  @since 1.0.0
 */
@property (nonatomic, assign) BOOL enableSkipRegistration;

/**
 *  Set the value to enable users to add their last name. Default is False. To be displayed at Create account screen.(Please refer to the flow document for more info)
 *
 *  @since 1.0.0
 */
@property (nonatomic, assign) BOOL enableLastName;

/**
 *  Set the value to if user personal consent is provided which decides enable or
 *  disable the consent screen.
 *  If unassigned it will be inactive
 *  @since 1904.0.0
 */
@property (nonatomic, assign) ConsentStates userPersonalConsentStatus;

/**
 *  Value set from AppConfig JSON which decides whether personal consent is given or not.
 *  @since 1904.0.0
 */
@property (nonatomic, assign,readonly) BOOL isPersonalConsentToBeShown;

/**
 *  Set the value to enable users to hide or unhide the navigation bar. Default value will be false.
 *
 *  @since 1906.0.0
 */
@property (nonatomic, assign) BOOL hideNavigationBar;

/**
 *  Set the value to to show social icons in dark theme background. Default value will be false which shows for the ligh theme.
 *
 *  @since 2003.0.0
 */
@property (nonatomic, assign) BOOL showSocialIconsInDarkTheme;


/**
 *  Loads contry specific configurations upon country change.
 *
 *  @param countryCode The country for which the configuration is to be loaded.
 *
 *  @since 1.0.0
 */
- (void)loadCountrySpecificConfigurationsForCountryCode:(NSString *)countryCode serviceURLs:(NSDictionary *)serviceURLs;

@end
