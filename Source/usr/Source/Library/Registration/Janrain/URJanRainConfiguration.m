//
//  URJanRainConfiguration.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 11/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URJanRainConfiguration.h"
#import "JRCapture.h"
#import "JREngage.h"
#import "DIConstants.h"
#import "JRCaptureConfig.h"
#import "URSettingsWrapper.h"
#import "RegistrationUtility.h"
#import "URJanrainErrorParser.h"

NSString *const RESEND_VERIFICATION_FORMNAME                = @"resendVerificationForm";
NSString *const CAPTURE_EDITPROFILE_FORMNAME                = @"editform";
NSString *const CAPTURE_SOCIALREGISTRATION_FORMNAME         = @"socialRegistrationForm";
NSString *const CAPTURE_TRADITIONALREGISTRATION_FORMNAME    = @"registrationForm";
NSString *const CAPTURE_TRADITIONAL_SIGNINFORMNAME          = @"userInformationForm";
NSString *const CAPTURE_TRADITIONAL_MOBILE_SIGNINFORMNAME   = @"userInformationMobileForm";

@interface URJanRainConfiguration()

@property (nonatomic, strong, readwrite) NSString *campaignID;
@property (nonatomic, strong, readwrite) NSString *micrositeID;
@property (nonatomic, strong, readwrite) NSString *resetPasswordURL;
@property (nonatomic, strong, readwrite) NSString *resetPasswordClientId;
@property (nonatomic, strong, readwrite) NSString *urxBaseURL;
@property (nonatomic, strong, readwrite) NSError  *flowDownloadError;
@property (nonatomic, strong, readwrite) dispatch_group_t flowDownloadGroup;

@end


@implementation URJanRainConfiguration

- (instancetype)initWithCountry:(NSString *)countryCode locale:(NSString *)locale serviceURLs:(NSDictionary *)serviceURLs flowDownloadCompletion:(void(^)(NSError *error))completion {
    self = [super init];
    if (self) {
        _campaignID = [RegistrationUtility configValueForKey:PILConfig_CampaignID countryCode:nil error:nil];
        _micrositeID = [DIRegistrationAppIdentity getMicrositeId];
        _resetPasswordURL = serviceURLs[kResetPasswordURLKey];
        _resetPasswordClientId = [URJanRainConfiguration resetPasswordClientIdForCountry:countryCode];
        _urxBaseURL = [[NSURL URLWithString:@"/" relativeToURL:[NSURL URLWithString:serviceURLs[kURXSMSVerificationURLKey]]] absoluteString];
        [JRCapture setRedirectUri:serviceURLs[kEmailVerificationURLKey]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onJanRainEnggageDownloadResult:)
                                                     name:JRFinishedUpdatingEngageConfigurationNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onJanRainEnggageDownloadResult:)
                                                     name:JRFailedToUpdateEngageConfigurationNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onJanRainFlowDownloadResult:)
                                                     name:JRDownloadFlowResult object:nil];
        DIRDebugLog(@"Janrain configurations: campaignID-%@, micrositeID-%@, resetPasswordURL-%@, resetPasswordClientId-%@, urxBaseURL-%@, serviceURLS-%@", _campaignID, _micrositeID, _resetPasswordURL, _resetPasswordClientId, _urxBaseURL, serviceURLs);
        
        _flowDownloadGroup = dispatch_group_create();
        dispatch_group_enter(_flowDownloadGroup);
        dispatch_group_enter(_flowDownloadGroup);
        [JRCapture setCaptureConfig:[self captureConfigForCountry:countryCode locale:locale serviceURLs:serviceURLs]];
        dispatch_group_notify(_flowDownloadGroup, dispatch_get_main_queue(), ^{
            if (self.flowDownloadError) {
                completion([URJanrainErrorParser mappedErrorForJanrainError:self.flowDownloadError]);
            } else {
                completion(nil);
            }
        });
    }
    return self;
}


- (JRCaptureConfig *)captureConfigForCountry:(NSString*)countryCode locale:(NSString *)locale serviceURLs:(NSDictionary *)serviceURLs {
    JRCaptureConfig *captureConfig = [JRCaptureConfig emptyCaptureConfig];
    captureConfig.captureTraditionalRegistrationFormName = CAPTURE_TRADITIONALREGISTRATION_FORMNAME;
    captureConfig.captureFlowName                        = CAPTURE_STANDARD_FLOWNAME;
    captureConfig.captureSocialRegistrationFormName      = CAPTURE_SOCIALREGISTRATION_FORMNAME;
    captureConfig.forgottenPasswordFormName              = CAPTURE_FORGOTTEN_PASSWORD_FORMNAME;
    captureConfig.editProfileFormName                    = CAPTURE_EDITPROFILE_FORMNAME;
    captureConfig.resendEmailVerificationFormName        = RESEND_VERIFICATION_FORMNAME;
    captureConfig.captureSignInFormName                  = CAPTURE_TRADITIONAL_SIGNINFORMNAME;
    captureConfig.enableThinRegistration                 = NO;
    captureConfig.customProviders                        = nil;
    captureConfig.captureTraditionalSignInType           = JRTraditionalSignInEmailPassword;
    
    if (serviceURLs[kMobileFlowSupportedKey] != nil) {
        captureConfig.captureSignInFormName = CAPTURE_TRADITIONAL_MOBILE_SIGNINFORMNAME;
    }
    captureConfig.captureDomain = serviceURLs[kJanRainBaseURLKey];
    captureConfig.downloadFlowUrl = serviceURLs[kJanRainFlowDownloadURLKey];
    captureConfig.downloadEnageUrl = [URJanRainConfiguration getEngageAppURL:countryCode withSDURLs:serviceURLs]; //serviceURLs[kJanRainEngageURLKey];
    captureConfig.captureLocale = locale;
    captureConfig.captureFlowVersion = @"HEAD";
    NSString *currentAppState = [RegistrationUtility getAppStateString:[DIRegistrationAppIdentity getAppState]];
    NSString *registrationClientIDKey = [NSString stringWithFormat:@"%@.%@",JanrainConfig_Registration_ClientID,currentAppState];
    captureConfig.captureClientId = [RegistrationUtility configValueForKey:registrationClientIDKey countryCode:countryCode error:nil];
    NSString *engageAppIDKey = [NSString stringWithFormat:@"%@.%@",JanrainConfig_EngageApp_ID,currentAppState];
    captureConfig.engageAppId = [RegistrationUtility configValueForKey:engageAppIDKey countryCode:countryCode error:nil];
    captureConfig.captureAppId = [URJanRainConfiguration captureAppIdForCountry:countryCode];
    captureConfig.engageAppUrl = captureConfig.downloadEnageUrl.pathComponents.lastObject;
    captureConfig.weChatAppId = [RegistrationUtility configValueForKey:WeChatAppId countryCode:nil error:nil];
    captureConfig.weChatAppSecret = [RegistrationUtility configValueForKey:WeChatAppSecret countryCode:nil error:nil];
    captureConfig.googlePlusClientId = [RegistrationUtility configValueForKey:GooglePlusClientId countryCode:nil error:nil];
    captureConfig.googlePlusRedirectUri = [RegistrationUtility configValueForKey:GooglePlusRedirectUri countryCode:nil error:nil];
    return captureConfig;
}


- (void)onJanRainFlowDownloadResult:(NSNotification *)notification {
    if ([notification object] != nil) {
        self.flowDownloadError = notification.object;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JRDownloadFlowResult object:nil];
    dispatch_group_leave(self.flowDownloadGroup);
}


- (void)onJanRainEnggageDownloadResult:(NSNotification *)notification {
    if ([notification userInfo] != nil) {
        self.flowDownloadError = notification.userInfo[@"error"];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JRFinishedUpdatingEngageConfigurationNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JRFailedToUpdateEngageConfigurationNotification object:nil];
    dispatch_group_leave(self.flowDownloadGroup);
}


//New URL required for the engage apps for Apple Sign In. 
+(NSString *)getEngageAppURL:(NSString *)country withSDURLs:(NSDictionary *)serviceURLs {
    NSString *serviceURL = serviceURLs[kJanRainEngageURLKey];
    if ([country isEqualToString:@"CN"] == true) {
        serviceURL = serviceURLs[kJanRainEngageURLKeyCN];
    }
    return serviceURL;
}


//+(NSString *)engageAppIdForCountry:(NSString *)country {
//    AIAIAppState state = [DIRegistrationAppIdentity getAppState];
//    NSArray *stateStrings = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",nil];
//    NSString *stateString;
//
//    if ([country isEqualToString:@"RU"] == true) {
//         NSDictionary *allDomainStrings = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"jgehpoggnhbagolnihge",@"jgehpoggnhbagolnihge",@"jgehpoggnhbagolnihge",@"jgehpoggnhbagolnihge",@"ddjbpmgpeifijdlibdio", nil] forKeys:stateStrings];
//        stateString = [allDomainStrings objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)state]];
//    } else if ([country isEqualToString:@"CN"] == true) {
//        NSDictionary *allDomainStrings = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"uyfpympodtnesxejzuic",@"uyfpympodtnesxejzuic",@"uyfpympodtnesxejzuic",@"uyfpympodtnesxejzuic",@"cfwaqwuwcwzlcozyyjpa", nil] forKeys:stateStrings];
//        stateString = [allDomainStrings objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)state]];
//    } else {
//       NSDictionary *allDomainStrings = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"jgehpoggnhbagolnihge",@"jgehpoggnhbagolnihge",@"jgehpoggnhbagolnihge",@"jgehpoggnhbagolnihge",@"ddjbpmgpeifijdlibdio", nil] forKeys:stateStrings];
//        stateString = [allDomainStrings objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)state]];
//    }
//    return stateString;
//}

+ (NSString *)captureAppIdForCountry:(NSString *)country {
    
        AIAIAppState state = [DIRegistrationAppIdentity getAppState];
        NSArray *stateStrings = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",nil];
        NSString *stateString;
        if ([country isEqualToString:@"RU"] == true) {
             NSDictionary *allDomainStrings = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"nt5dqhp6uck5mcu57snuy8uk6c",@"nt5dqhp6uck5mcu57snuy8uk6c",@"nt5dqhp6uck5mcu57snuy8uk6c",@"nt5dqhp6uck5mcu57snuy8uk6c",@"hffxcm638rna8wrxxggx2gykhc", nil] forKeys:stateStrings];
            stateString = [allDomainStrings objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)state]];
        } else if ([country isEqualToString:@"CN"] == true) {
            NSDictionary *allDomainStrings = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"czwfzs7xh23ukmpf4fzhnksjmd",@"czwfzs7xh23ukmpf4fzhnksjmd",@"czwfzs7xh23ukmpf4fzhnksjmd",@"czwfzs7xh23ukmpf4fzhnksjmd",@"zkr6yg4mdsnt7f8mvucx7qkja3", nil] forKeys:stateStrings];
            stateString = [allDomainStrings objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)state]];
        } else {
           NSDictionary *allDomainStrings = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"nt5dqhp6uck5mcu57snuy8uk6c",@"nt5dqhp6uck5mcu57snuy8uk6c",@"nt5dqhp6uck5mcu57snuy8uk6c",@"nt5dqhp6uck5mcu57snuy8uk6c",@"hffxcm638rna8wrxxggx2gykhc", nil] forKeys:stateStrings];
            stateString = [allDomainStrings objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)state]];
        }
        return stateString;
    
}

+ (NSString *)resetPasswordClientIdForCountry:(NSString *)country {
        AIAIAppState state = [DIRegistrationAppIdentity getAppState];
        NSArray *stateStrings = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",nil];
        NSString *stateString;
        if ([country isEqualToString:@"RU"] == true) {
             NSDictionary *allDomainStrings = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"h27n93rjva8xuvzgpeb7jf9jxq6dnnzr",@"h27n93rjva8xuvzgpeb7jf9jxq6dnnzr",@"h27n93rjva8xuvzgpeb7jf9jxq6dnnzr",@"h27n93rjva8xuvzgpeb7jf9jxq6dnnzr",@"h27n93rjva8xuvzgpeb7jf9jxq6dnnzr", nil] forKeys:stateStrings];
            stateString = [allDomainStrings objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)state]];
        } else if ([country isEqualToString:@"CN"] == true) {
            NSDictionary *allDomainStrings = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"mfvjprjmgbrhfbtn6cq6q2yupzhxn977",@"mfvjprjmgbrhfbtn6cq6q2yupzhxn977",@"mfvjprjmgbrhfbtn6cq6q2yupzhxn977",@"mfvjprjmgbrhfbtn6cq6q2yupzhxn977",@"65dzkyh48ux4vcguhvwsgvtk4bzyh2va", nil] forKeys:stateStrings];
            stateString = [allDomainStrings objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)state]];
        } else {
           NSDictionary *allDomainStrings = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"h27n93rjva8xuvzgpeb7jf9jxq6dnnzr",@"h27n93rjva8xuvzgpeb7jf9jxq6dnnzr",@"h27n93rjva8xuvzgpeb7jf9jxq6dnnzr",@"h27n93rjva8xuvzgpeb7jf9jxq6dnnzr",@"h27n93rjva8xuvzgpeb7jf9jxq6dnnzr", nil] forKeys:stateStrings];
            stateString = [allDomainStrings objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)state]];
        }
        return stateString;
}


@end
