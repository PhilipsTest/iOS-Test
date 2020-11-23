//
//  DIConstants.h
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "RegistrationUtility.h"

#define CAPTURE_STANDARD_FLOWNAME                   @"standard"
#define CAPTURE_FORGOTTEN_PASSWORD_FORMNAME         @"forgotPasswordForm"
#define KJRCaptureUser                              @"registration.captureUser"
#define CAPTURE_TRADITIONAL_MOBILE_UPDATEFORMNAME   @"mobileNumberForm"
#define EDIT_PROFILE_FORM                           @"editProfileForm"

#define ENGAGE_APPID                                @"EngageAppId"
#define CAPTURE_FLOWVERSION                         @"CaptureFlowVersion"
#define CAPTURE_APPID                               @"CaptureAppId"
#define RESETPASSWORD_CLIENTID                      @"ResetPasswordClientId"
#define PRX_URL                                     @"PRXURL"
#define URX_URL                                     @"URXURL"

#define SERVICE_DISCOVERY_DOMAIN                    @"ServiceDiscovery"


#define DEV_CAPTURE_DOMAIN                          @"https://philips.dev.janraincapture.com"
#define TEST_CAPTURE_DOMAIN                         @"https://philips-test.dev.janraincapture.com"
#define EVAL_CAPTURE_DOMAIN                         @"https://philips.eval.janraincapture.com"
#define PROD_CAPTURE_DOMAIN                         @"https://philips.janraincapture.com"

#define DEV_CAPTURE_DOMAIN_CHINA                    @"https://philips-cn-dev.capture.cn.janrain.com"
#define DEV_CAPTURE_DOMAIN_CHINA_EU                 @"https://philips-china-eu.eu-dev.janraincapture.com"
#define TEST_CAPTURE_DOMAIN_CHINA                   @"https://philips-cn-test.capture.cn.janrain.com"
#define TEST_CAPTURE_DOMAIN_CHINA_EU                @"https://philips-china-test.eu-dev.janraincapture.com"
#define EVAL_CAPTURE_DOMAIN_CHINA                   @"https://philips-cn-staging.capture.cn.janrain.com"
#define PROD_CAPTURE_DOMAIN_CHINA                   @"https://philips-cn.capture.cn.janrain.com"

#define DEV_CAPTURE_DOMAIN_RUSSIA                   @"https://dev.philips.ru/localstorage"
#define TEST_CAPTURE_DOMAIN_RUSSIA                  @"https://tst.philips.ru/localstorage"
#define STG_CAPTURE_DOMAIN_RUSSIA                   @"https://stg.philips.ru/localstorage"
#define ACC_CAPTURE_DOMAIN_RUSSIA                   @"https://acc.philips.ru/localstorage"
#define PROD_CAPTURE_DOMAIN_RUSSIA                  @"https://www.philips.ru/localstorage"

#define UIColorFromRGBA(r, g, b, a) [UIColor colorWithRed: r / 255.0 green: g / 255.0 blue: b / 255.0 alpha:a]

static NSString * const kJanRainBaseURLKey          = @"userreg.janrain.api.v2";
static NSString * const kJanRainEngageURLKey        = @"userreg.janrain.engage.v2";
static NSString * const kJanRainEngageURLKeyCN      = @"userreg.janrain.engage.v3";
static NSString * const kJanRainFlowDownloadURLKey  = @"userreg.janrain.cdn.v2";
static NSString * const kEmailVerificationURLKey    = @"userreg.landing.emailverif";
static NSString * const kResetPasswordURLKey        = @"userreg.landing.resetpass";
static NSString * const kMobileFlowSupportedKey     = @"userreg.smssupported";
static NSString * const kMyPhilipsLandingPageURLKey = @"userreg.landing.myphilips";
static NSString * const kURXSMSVerificationURLKey   = @"userreg.urx.verificationsmscode";
static NSString * const kHSDPBaseURLKey             = @"userreg.hsdp.userserv";


//Provider Names
static NSString * const kProviderNameFacebook       = @"facebook";
static NSString * const kProviderNameApple          = @"apple";
static NSString * const kProviderNameGoogle         = @"googleplus";
static NSString * const kProviderNameWeChat         = @"wechat";

//GDPR key for UR
static NSString * const kUSRMarketingConsentKey     = @"USR_MARKETING_CONSENT";
static NSString * const kUSRPersonalConsentKey      = @"USR_PERSONAL_CONSENT";

static NSString *const kHSDPSecurePubKey = @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI2bvVLVYrb4B0raZgFP60VXY\ncvRmk9q56QiTmEm9HXlSPq1zyhyPQHGti5FokYJMzNcKm0bwL1q6ioJuD4EFI56D\na+70XdRz1CjQPQE3yXrXXVvOsmq9LsdxTFWsVBTehdCmrapKZVVx6PKl7myh0cfX\nQmyveT/eqyZK1gYjvQIDAQAB\n-----END PUBLIC KEY-----";

//New error codes added as part of error mapping

#define DIJanrainConnectionErrorCode            36
#define DIJanrainInvalidDateTimeErrorCode       37
#define DIJanrainCodeExpiredErrorCode           38
#define DIJanrainTokenExpiredErrorCode          39
#define DIJanrainApiLimitErrorCode              40
#define DIJanrainErrorInFlowErrorCode           41
#define DIJanrainApiFeatureDisabledErrorCode    42
#define DIEmailOrMobileNumberAlreadyInUse       43

//URXSMS error constants
#define DIURXSMSRetryTimeDuration               60
