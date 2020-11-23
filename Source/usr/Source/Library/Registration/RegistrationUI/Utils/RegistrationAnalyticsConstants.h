//
//  RegistrationAnalyticsConstants.h
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

//actions
#define kRegSendData                                               @"sendData"
#define kRegSpecialEvents                                          @"specialEvents"
#define kRegTechnicalError                                         @"technicalError"
#define kRegUserError                                              @"userError"
#define kRegStatusNotification                                     @"inAppNotification"
#define kRegStatusNotificationResponse                             @"inAppNotificationResponse"
#define kRegistration1Control                                      @"registration1:control"
#define kRegistration1SplitSignUp                                  @"registration1:splitsign-up"
#define kRegistration1CustomScreen                                 @"registration1:customoptin"
#define kRegistration1SkipScreen                                   @"registration1:skipoptin"
#define kRegistrationUuidKey                                       @"evar2"
#define kCountrySelectedKey                                        @"countrySelected"

//events
#define kRegSuccessLogin                                           @"successLogin"
#define kRegSuccessUserCreation                                    @"successUserCreation"
#define kHandleMergingFailed                                       @"HandleMergingFailed"
#define kRegSuccessUserRegistration                                @"successUserRegistration"
#define kRegSuccessRecoveryEmail                                   @"successRecoveryEmail"
#define kRegSecureDataWithEmail                                    @"secureDataWithEmail"
#define kRegSuccessEmailVerificationResend                         @"successResendEmailVerification"
#define kRegPasswordResetLinkSent                                  @"A link is sent to your email to reset the password of your Philips Account"
#define kRegResendVerificationMailLinkSent                         @"We have sent an email to your email address to reset your password"
#define kRegSuccessSMSVerificationResend                           @"successResendSMSVerification"
#define kRegResendSMSVerificationFailure                           @"failureResendSMSVerification"
#define kABTest                                                    @"abtest"

//errors
#define kRegCreateNetworkError                                     @"registration network error"
#define kRegResendVerificationNetworkError                         @"resend verification network error"
#define kRegEmailIsNotVerified                                     @"email is not verified"
#define kRegMobileNoIsNotVerified                                  @"mobile no is not verified"
#define kRegEmailAlreadyInUse                                      @"email already in use"
#define kRegEmailAlreadyVerified                                   @"email already verified"
#define kRegMobileNoAlreadyInUse                                   @"mobile no already in use"
#define kRegInvalidInputFields                                     @"invalid input fields"
#define kRegIncorrectPassword                                      @"incorrect password"
#define kRegIncorrectEmailOrPassword                               @"incorrect email or password"
#define kRegSMSIsNotVerified                                       @"sms is not verified"
#define kRegFailedRecoveryEmail                                    @"failureRecoveryEmail"
#define kRegRecordNotFound                                         @"recoredNotFound"
#define kRegURXServerError                                         @"urxServerError"
#define kRegInputValidationError                                   @"inputValidationError"
#define kRegCodeNotFound                                           @"codeNotFound"
#define kRegCodeNotAuthorized                                      @"codeNotAuthorized"
#define kRegInvalidPhoneNumber                                     @"invalidPhoneNumber"
#define kRegUnAvailPhoneNumber                                     @"unAvailPhoneNumber"
#define kRegUnSupportedCountry                                     @"unSupportedCountry"
#define kRegLimitReached                                           @"codeLimitReached"
#define kRegInternalServerError                                    @"urxInternalServerError"
#define kRegCodeNoInfo                                             @"codeNoInformation"
#define kRegCodeNotSent                                            @"codeNotSent"
#define kRegCodeAlreadyVerifed                                     @"codeAlreadyVerifed"
#define kRegFailureCode                                            @"failureCode"
#define kRegProviderNotSupported                                   @"providerNotSupported"
#define kRegNoProviderChosen                                       @"noProviderChosen"
#define kRegUnExpectedError                                        @"unExpectedError"
#define kRegJanrainConnectionError                                 @"janarainConnectionError"

#define kRegWeChatNotInstalled                                     @"weChatNotInstalled"
#define kRegSessionExpired                                         @"sessionExpired"
#define kRegAccessTokenNil                                         @"accessTokenNil"
#define kRegSocialSignUpCancelled                                  @"socialSignUpCancelled"
#define kRegServerTimeSyncError                                    @"serverTimeSyncError"

// errors for clear user data(logout) scenario
#define kRegClearUserDataHSDPSocialSignInFailed                    @"hsdpSocialSigninFailed"
#define kRegClearUserDataLoggedinStateNotSatisfied                 @"loggedinStateNotSatisfied"
#define kRegClearUserDataPersonalConsentNotProvided                @"personalConsentRequiredNotProvided"

//page names
#define kRegistrationAlmostDone                                    @"registration:almostdone"
#define kRegistrationAccountsMerge                                 @"registration:mergeaccount"
#define kRegistrationSocialMerge                                   @"registration:mergesocialaccount"
#define kRegistrationCreateaccount                                 @"registration:createaccount"                                    
#define kRegistrationSignin                                        @"registration:signin"
#define kRegistrationSocialProvider(provider)                      [NSString stringWithFormat:@"registration:%@", provider]
#define kRegistrationForgotPassword                                @"registration:forgotpassword"
#define kRegistrationVerifyemail                                   @"registration:accountactivation"
#define kRegistrationResendEmail                                   @"registration:resendemail"
#define kRegistrationMarketingOptIn                                @"registration:marketingoptin"
#define kRegistrationHome                                          @"registration:home"
#define kRegistrationUserProfile                                   @"registration:userprofile"
#define kRegistrationPhilipsNews                                   @"registration:philipsannouncement"
#define kRegistrationVerifyAccountSMS                              @"registration:accountactivationbysms"
#define kRegistrationResendSMS                                     @"registration:resendsmsorupdatephonenumber"
#define kRegistrationSecureData                                    @"registration:securedata"
#define kRegistrationCountrySelection                              @"registration:countryselection"

//buttons and states
#define kRegStartSocialMerge                                       @"startSocialMerge"
#define kRegStartUserRegistration                                  @"startUserRegistration"
#define kRegSkippedUserRegistration                                @"loginRegistartionSkipped"
#define kRegSuccessUserRegistration                                @"successUserRegistration"
#define kRegRemarketingOptOut                                      @"remarketingOptOut"
#define kRegAcceptTermsAndConditionsOptin                          @"termsAndConditionsOptIn"
#define kRegPersonalConsentOptin                                    @"personalConsentOptIn"
#define kRegAcceptTermsAndConditionsOptOut                         @"termsAndConditionsOptOut"
#define kRegPersonalConsentOptOut                                    @"personalConsentOptOut"
#define kRegRemarketingOptIn                                       @"remarketingOptIn"
#define kRegLogoutSuccess                                          @"logoutSuccess"
#define kRegLogoutButtonSelected                                   @"logoutButtonSelected"
#define kRegSkipSecureData                                         @"skipSecureData"
#define kRegTryLoginAgain                                          @"tryLoginAgain"

//tagging channels
#define kForgotPasswordChannel                                     @"forgotPasswordChannel"
#define kRegLoginChannel                                           @"loginChannel"

//dynamic registration states for tagging
#define kRegOK                                                     @"ok"
#define kRegEmail                                                  @"email"
#define kRegPhoneNumber                                            @"phone number"

typedef enum {
    DILoginFailedError = 1,
    DIRegistrationFailedError = 2,
    DIForgotPasswordFailedError = 3,
    DIResendEmailVerificationFailedError = 4,
    DIResendMobileVerificationFailedError = 5,
    DIFetchUserInfoFailedError = 6,
    DILoginSessionRefreshFailedError = 7,
    DIHandleMergingError = 8,
    DIInitializationConfigurationError = 9
} DIRegistrationError;
