//
//  RegistrationAppConst.h
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "RegistrationUtility.h"


#ifndef Registration_RegistrationAppConst_h
#define Registration_RegistrationAppConst_h


typedef NS_ENUM(NSUInteger, URXHTTPResponseCode) {
    URXHTTPResponseCodeServerError           =      500, /**< Server Error */
    URXHTTPResponseCodeInputValidationError  =      412, /**< Input validation error, e.g. non-existing country code */
    URXHTTPResponseCodeNotFoundError         =      404, /**< Not found */
    URXHTTPResponseCodeNotAuthorized         =      403  /**< Not authorized */
};

typedef NS_ENUM(NSUInteger, URXSMSErrorCode) {
    URXSMSErrorGeneric                    =    100,
    URXSMSErrorCodeInvalidNumber          =    URXSMSErrorGeneric +  10, /**< Invalid phone number provided. In case of validation errors on the phone number */
    URXSMSErrorCodeNumberNotRegistered    =    URXSMSErrorGeneric +  15, /**< A valid phone number was provided but not registered with Philips */
    URXSMSErrorCodeUnAvailNumber          =    URXSMSErrorGeneric +  20, /**< Phone number unavailable for SMS. Permanent error with sending SMS to this phone number, for instance in case of blacklisted, do-not-disturb numbers */
    URXSMSErrorCodeUnSupportedCountry     =    URXSMSErrorGeneric +  30,   /**< Unsupported country for SMS services. The SMS cannot be delivered because the country is not covered by the SMS service */
    URXSMSErrorCodeLimitReached           =    URXSMSErrorGeneric +  40, /**< - SMS limit for phone number reached. Please try again later.
                                                                          Too many messages sent to this phone number within the time limit */
    URXSMSErrorCodeInternalServerError    =    URXSMSErrorGeneric +  50,   /**< Internal server error sending SMS. Please try again later */
    URXSMSErrorCodeNoInfo                 =    URXSMSErrorGeneric +  60,   /**< No information available */
    URXSMSErrorCodeNotSent                =    URXSMSErrorGeneric +  70,   /**< SMS not yet sent */
    URXSMSErrorCodeAlreadyVerifed         =    URXSMSErrorGeneric +  90,  /**< SMS not sent. Account already verified */
    URXSMSErrorCodeFailureCode            =    URXSMSErrorGeneric +  3200, /**< Mobile account failure case */
};


static NSString *const kTermAndConditionsUrl    = @"https://www.philips.com/about/company/businesses/conditionsofcommercialsale/index.page";
static NSString *const kLoadPhilipsNewsURLDummy = @"LoadPhilipsNews";
static NSString *const kPersonalConsentURL = @"PersonalConsentURL";


typedef NS_ENUM(NSInteger, EnterCodeFlowType) {
    EnterCodeFlowTypeVerification = 0,
    EnterCodeFlowTypeReset = 1
};

/**
 *  The flow end point that the user will be displayed when registration component is launched and user is already logged in.
 */
typedef NS_ENUM(NSInteger, URAlmostDoneFlowType) {
    URAlmostDoneFlowTypeSocialRegistration,
    URAlmostDoneFlowTypeSocialLogIn,
    URAlmostDoneFlowTypeTraditionalLogIn
};

#define RESOURCE_BUNDLE [NSBundle bundleForClass:[RegistrationUtility class]]
#define LOCALIZE(key) NSLocalizedStringFromTableInBundle(key,@"RegistrationLocalizable",RESOURCE_BUNDLE,@"Localized string not available")


//Storyboard ViewController id
#define kURVerifyEmailViewController  @"URVerifyEmailViewController"
#define kURSMSViewController  @"verifySMSController"
#define kRegisterSocialSignInViewController @"RegisterSocialSignInViewController"
#define kRegistrationStartViewController  @"RegistrationStartViewController"
#define kParentalAccessViewController           @"parentalAccessController"
#define kRegistrationOptInViewController @"OptInViewController"
#define kMyDetailsViewController @"MyDetailsViewController"


//Segue identifier
#define ksocialFacebookSignInFlowSegue @"socialSignInfacebook"
#define kRegistrationVerifyEmailSegue @"RegistrationVerifyEmailSegue"
#define kRegistrationShowAccountActivationSegue @"showAccountActivationSegue"
#define kRegisterSocialSignInSegue @"RegisterSocialSignInSegue"
#define kRegistrationTraditionalRegisterSegue   @"showMyPhilipsCreateAccount"
#define kRegistrationAccountsMergeSegue @"RegistrationAccountsMerge"
#define kRegistrationSocialMergeSegue @"RegistrationSocialMerge"
#define kRegistrationTraditionalSignInSegue  @"URLogInViewController"
#define KSigninButtonCellIdentifier @"SigninButtonCell"
#define kSocialRegistrationVerifyEmailSegue @"SocialRegistrationVerifyEmailSegue"
#define kOptInViewControllerSegue @"OptInViewControllerSegue"
#define kTermsAndConditionsViewControllerSegue @"TermsAndConditionsVC"
#define kRegistrationForgotPasswordShowActivationSegue @"showForgotPasswordActivationSegue"
#define kRegistrationWebViewSegue @"RegistrationWebViewSegue"
#define kCountrySelectionViewControllerSegue @"CountrySelectionViewControllerSegue"
#define kSwitchToLoginSegue @"SwitchToLoginSegue"
#define kForgotPassowordStoryBoardSegue @"ForgotPasswordStoryboardSegue"
#define kURResendSMSViewControllerSegue @"URResendSMSViewControllerSegue"
#define kSecureDataRecoveryEmailSegue @"showAddRecoveryEmailScreen"
#define kVerifyRecoveryEmailSegue @"verifyRecoveryEmailSegue"
#define kURPhilipsNewsSegue @"URPhilipsNewsSegue"
#define kURPersonalConsentSegue @"PersonalConsentSegue"

#endif
