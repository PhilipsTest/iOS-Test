//
//  DIRegistrationConstants.h
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

typedef NS_ENUM(NSUInteger, UserGender) {
    UserGenderNone,
    UserGenderMale,
    UserGenderFemale
};


typedef NS_ENUM(NSUInteger, RegistrationCompletionErrorCode) {
    RegistrationCompletionErrorCodeSkippedRegistration = 5001
};


#define kProviderKey                                       @"provider"


#define kStateTest                                         @"Testing"
#define kStateDevelopment                                  @"Development"
#define kStateStaging                                      @"Staging"
#define kStateProduction                                   @"Production"
#define kStateEvaluation                                   @"Evaluation"

#define JanrainConfig_Registration_ClientID_Dev            @"JanRainConfiguration.RegistrationClientID.Development"
#define JanrainConfig_Registration_ClientID_Tst            @"JanRainConfiguration.RegistrationClientID.Testing"
#define JanrainConfig_Registration_ClientID_Evl            @"JanRainConfiguration.RegistrationClientID.Evaluation"
#define JanrainConfig_Registration_ClientID_Stag           @"JanRainConfiguration.RegistrationClientID.Staging"
#define JanrainConfig_Registration_ClientID_Prod           @"JanRainConfiguration.RegistrationClientID.Production"
#define JanrainConfig_EngageApp_ID                         @"JanRainConfiguration.EngageAppID"
#define JanrainConfig_Registration_ClientID                @"JanRainConfiguration.RegistrationClientID"

#define PILConfig_CampaignID                               @"PILConfiguration.CampaignID"
#define PILConfiguration_MicrositeID                       @"PILConfiguration.MicrositeID"
#define PILConfiguration_RegistrationEnvironment           @"PILConfiguration.RegistrationEnvironment"
#define Flow_EmailVerificationRequired                     @"Flow.EmailVerificationRequired"
#define UserEmail                                          @"User.Email"
#define Flow_TermsAndConditionsAcceptanceRequired          @"Flow.TermsAndConditionsAcceptanceRequired"
#define Flow_MinimumAgeLimit                               @"Flow.MinimumAgeLimit"
#define Flow_Coppa                                         @"Flow.Coppa"
#define Flow_MigrationRequired                             @"Flow.isMigrationRequired"
#define SigninProviders                                    @"SigninProviders"
#define WeChatAppId                                        @"WeChatAppId"
#define WeChatAppSecret                                    @"WeChatAppSecret"
#define GooglePlusClientId                                 @"GooglePlusClientId"
#define GooglePlusRedirectUri                              @"GooglePlusRedirectUri"
#define HideCountrySelction                                @"HideCountrySelction"
#define SupportedHomeCountries                             @"supportedHomeCountries"
#define FallbackHomeCountry                                @"fallbackHomeCountry"
#define PersonalConsentRequired                            @"personalConsentRequired"

#define HSDPConfiguration_ApplicationName                  @"HSDPConfiguration.ApplicationName"
#define HSDPConfiguration_Shared                           @"HSDPConfiguration.Shared"
#define HSDPConfiguration_Secret                           @"HSDPConfiguration.Secret"
#define HSDPConfiguration_BaseURL                          @"HSDPConfiguration.BaseURL"
#define HSDPUUIDUpload                                     @"hsdpUUIDUpload"
#define HSDPConfiguration_Skip_HSDP                        @"HSDPConfiguration.SkipHSDPLogin"

#define DIRegNoProviderErrorCode                    1
#define DIInvalidFieldsErrorCode                    2
#define DINotOlderThanAgeLimitErrorCode             3
#define DIMergeFlowErrorCode                        4
#define DIUnexpectedErrorCode                       5
#define DISessionExpiredErrorCode                   6
#define DINetworkErrorCode                          7
#define DITokenMalformedErrorCode                   8
#define DITokenUnknownErrorCode                     9
#define DINotVerifiedEmailErrorCode                 10
#define DINotVerifiedMobileErrorCode                11
#define DIInvalidCredentials                        12
#define DIEmailAddressAlreadyInUse                  13
#define DIMobileNumberAlreadyInUse                  14
#define DIAcesssTokenIsNil                          15
#define DIRegProviderNotSupported                   16
#define DIRegAuthenticationError                    17
#define DIRegAppleUserCancelError                   1001
#define DIRegNoAppleUserError                       1000


#define DIHTTPSuccessCode                           18
#define DIHTTPServerErrorCode                       19
#define DIHTTPInputValidationErrorCode              20
#define DIHTTPNotFoundErrorCode                     21
#define DIHTTPNotAuthorizedErrorCode                22
#define DISMSSuccessCode                            23
#define DISMSInvalidNumberErrorCode                 24
#define DISMSUnAvailNumberErrorCode                 25
#define DISMSUnSupportedCountryErrorCode            26
#define DISMSLimitReachedErrorCode                  27
#define DISMSInternalServerErrorCode                28
#define DISMSNoInfoErrorCode                        29
#define DISMSNotSentErrorCode                       30
#define DISMSAlreadyVerifiedErrorCode               31
#define DISMSFailureErrorCode                       32

#define DIRegWeChatAccountsError                    33

#define DIRegNetworkSyncError                       34
#define DIRegRecordNotFound                         35

//Clear user data error code constants
#define DIClearUserDataHSDPSocialSigninFailed       36
#define DIClearUserDataLoggedinStateNotSatisfied    37
#define DIClearUserDataPersonalConsentNotProvided   38

//URHsdp error constants
#define DIHsdpStateJanrainNotSignedIn               44
#define DIHsdpStateNotConfiguredForCountry          45
#define DIHsdpStateAlreadySignedIn                  46
#define DIHsdpStateNotSignedIn                      47


#define DIGDPRRegConsentError                       400
