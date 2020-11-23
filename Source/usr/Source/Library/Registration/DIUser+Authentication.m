//
//  DIUser+Authentication.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 25/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "DIUser+Authentication.h"
#import "DIUser+PrivateData.h"
#import "URSettingsWrapper.h"
#import "URJanrainErrorParser.h"
#import "URErrorAppTaggingUtility.h"

@implementation DIUser (Authentication)

- (void)registerNewUserUsingTraditional:(NSString *)email withMobileNumber:(NSString *)mobileNumber withFirstName:(NSString *)firstname withLastName:(NSString *)lastName withOlderThanAgeLimit:(BOOL)isOlderThanAgeLimit withReceiveMarketingMails:(BOOL)receiveMarketingEmails withPassword:(NSString *)password {
    [self.janrainService registerNewUserUsingEmail:email orMobileNumber:mobileNumber password:password firstName:firstname lastName:lastName ageLimitPassed:isOlderThanAgeLimit
                                    marketingOptIn:receiveMarketingEmails withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
                                        [self storeUserProfile:user];
                                        if (isUpdated) {return;}
                                        [self sendMessage:@selector(didRegisterSuccessWithUser:) toListeners:self.userRegistrationListeners withObject:self andObject:nil];
                                    } failureHandler:^(NSError *error) {
                                        [self sendMessage:@selector(didRegisterFailedwithError:) toListeners:self.userRegistrationListeners withObject:error andObject:nil];
                                    }];
}




- (void)resendVerificationMail:(NSString *)emailAddress {
    [self.janrainService resendVerificationMailForEmail:emailAddress withSuccessHandler:^{
        [self sendMessage:@selector(didResendEmailverificationSuccess) toListeners:self.userRegistrationListeners withObject:nil andObject:nil];
    } failureHandler:^(NSError *error) {
        [self sendMessage:@selector(didResendEmailverificationFailedwithError:) toListeners:self.userRegistrationListeners withObject:error andObject:nil];
    }];
}


- (void)forgotPasswordForEmail:(NSString *)emailAddress {
    [self.janrainService resetPasswordForEmail:emailAddress withSuccessHandler:^{
        [self sendMessage:@selector(didSendForgotPasswordSuccess) toListeners:self.userRegistrationListeners withObject:nil andObject:nil];
    } failureHandler:^(NSError *error) {
        [self sendMessage:@selector(didSendForgotPasswordFailedwithError:) toListeners:self.userRegistrationListeners withObject:error andObject:nil];
    }];
}


- (void)resendVerificationCodeForMobile:(nonnull NSString *)mobileNumber {
    [self.janrainService resendVerificationCodeForMobileNumber:mobileNumber withSuccessHandler:^{
        [self sendMessage:@selector(didResendMobileverificationSuccess) toListeners:self.userRegistrationListeners withObject:nil andObject:nil];
    } failureHandler:^(NSError *error) {
        [self sendMessage:@selector(didResendMobileverificationFailedwithError:) toListeners:self.userRegistrationListeners withObject:error andObject:nil];
    }];
}


- (void)verificationCodeForMobile:(nonnull NSString *)verificationCode {
    [self.janrainService activateAccountWithVerificationCode:verificationCode forUUID:self.userProfile.uuid withSuccessHandler:^{
        [self sendMessage:@selector(didVerificationForMobileSuccess) toListeners:self.userRegistrationListeners withObject:nil andObject:nil];
    } failureHandler:^(NSError *error) {
        NSError *mobileVerificationError = [URJanrainErrorParser errorForErrorCode:DISMSFailureErrorCode];
        [self sendMessage:@selector(didVerificationForMobileFailedwithError:) toListeners:self.userRegistrationListeners withObject:mobileVerificationError andObject:nil];
    }];
}


- (void)verificationCodeToResetPassword:(nonnull NSString *)mobileNumber {
    [self.janrainService resetPasswordForMobileNumber:mobileNumber withSuccessHandler:^(NSString *token) {
        [self sendMessage:@selector(didVerificationForMobileToResetPasswordSuccessWithToken:) toListeners:self.userRegistrationListeners withObject:token andObject:nil];
    } failureHandler:^(NSError *error) {
        [self sendMessage:@selector(didVerificationForMobileToResetPasswordFailedwithError:) toListeners:self.userRegistrationListeners withObject:error andObject:nil];
    }];
}


- (void)loginUsingTraditionalWithEmail:(NSString *)emailAddress password:(NSString *)password {
    [self.janrainService loginToTraditionalUsingEmail:emailAddress password:password withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
        [self storeUserProfile:user];
        if (isUpdated) {
            return;
        }
        [self storeUserProfile:user];
        [self checkIsEmailORMobileVerified:user];
    } failureHandler:^(NSError *error) {
        NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:error];
        [self sendMessage:@selector(didLoginFailedwithError:) toListeners:self.userRegistrationListeners withObject:mappedError andObject:nil];
    }];
}


- (void)checkIsEmailORMobileVerified:(JRCaptureUser *)user {
    NSError *verificationError = [self emailOrMobileNumberVerificationErrorForUser:user];
    if (verificationError) {
        [self sendMessage:@selector(didLoginFailedwithError:) toListeners:self.userRegistrationListeners withObject:verificationError andObject:nil];
    }else {
        [self completeSocialLoginAfterJanrainSocialLoginWithUser:user andSelectors:@[NSStringFromSelector(@selector(didLoginWithSuccessWithUser:)),
                                                                                     NSStringFromSelector(@selector(didLoginFailedwithError:))]];
    }
}


- (NSError *)emailOrMobileNumberVerificationErrorForUser:(JRCaptureUser *)user {
    if (user.email == nil && user.mobileNumber == nil) {
        return [URJanrainErrorParser errorForErrorCode:DIInvalidFieldsErrorCode];
    } else if (user.mobileNumberVerified == nil && user.mobileNumber != nil) {
        return [URJanrainErrorParser errorForErrorCode:DINotVerifiedMobileErrorCode];
    } else if ((user.email != nil) && user.emailVerified == nil && user.mobileNumber == nil) {
        return [URJanrainErrorParser errorForErrorCode:DINotVerifiedEmailErrorCode];
    }
    return nil;
}

//selectors array should have exactly two values first one NSString representation of success selector and second one of failure selector.
- (void)completeSocialLoginAfterJanrainSocialLoginWithUser:(JRCaptureUser*)janrainUser andSelectors:(nonnull NSArray<NSString *> *)selectors {

    if (janrainUser.isVerified && self.hsdpService && ![HSDPService isHSDPSkipLoadingEnabled]) {
        //FIXME: Change the below line back to what it was before 17.5 platform release
        NSString *userIdentifierForHSDP = janrainUser.email.length > 0 ? janrainUser.email : janrainUser.mobileNumber;
        [self.hsdpService loginWithSocialUsingEmail:userIdentifierForHSDP accessToken:[JRCapture getAccessToken] refreshSecret:[JRCaptureData sharedCaptureData].refreshSecret
                                         completion:^(HSDPUser *user, NSError *error) {
                                             if (error) {
                                                 [self clearUserData];
                                                 [URErrorAppTaggingUtility tagClearUserData:DIClearUserDataHSDPSocialSigninFailed errorMessage:kRegClearUserDataHSDPSocialSignInFailed errorType:kRegTechnicalError];
                                                 [self sendMessage:NSSelectorFromString(selectors[1]) toListeners:self.userRegistrationListeners withObject:error andObject:nil];
                                             } else {
                                                     [self storeUserProfile:janrainUser];
                                                     [self storeHSDPUser:user];
                                                     [self sendMessage:NSSelectorFromString(selectors[0]) toListeners:self.userRegistrationListeners withObject:self andObject:nil];
                                             }
                                         }];
    }else {
        [self storeUserProfile:janrainUser];
        [self sendMessage:NSSelectorFromString(selectors[0]) toListeners:self.userRegistrationListeners withObject:self andObject:nil];
    }
}

- (void)socialAuthenticationwith:(NSDictionary *)userInfo error:(NSError *)error {
    if (error) {
        if ((error.code == DIRegAuthenticationError)) {
            [self sendMessage:@selector(socialAuthenticationCanceled) toListeners:self.userRegistrationListeners withObject:nil andObject:nil];
        }else {
            [self sendMessage:@selector(socialLoginCannotLaunch:) toListeners:self.userRegistrationListeners withObject:error andObject:nil];
        }
    }else {
        [self sendMessage:@selector(didAuthenticationCompleteForLogin:) toListeners:self.userRegistrationListeners withObject:userInfo[@"email"] andObject:nil];
    }
}

-(void)updateNameToJRUserFromAppleUser:(AppleUser *)user {
    //If no apple/JR user return and also no first name and last name
    if ((user == nil || self.userProfile == nil) || (user.firstName == nil && user.lastName == nil))  {
        return;
    }
    self.userProfile.givenName = (user.firstName == nil) ? @" " : user.firstName;
    self.userProfile.familyName = (user.lastName == nil) ? @" " : user.lastName;
    self.userProfile.displayName = [NSString stringWithFormat:@"%@ %@",(self.userProfile.givenName), self.userProfile.familyName];
}

- (void)loginUsingProvider:(NSString *)provider {
    __block NSString *userEmail = nil;
    __block AppleUser *appleUser = nil;
    void(^authHandler)(NSDictionary *, NSError *) = ^(NSDictionary *userInfo, NSError *error) {
        NSMutableDictionary *mutableUserInfo = [userInfo mutableCopy];
        if ([userInfo[@"email"] length] <= 0 && userEmail.length > 0) {
            mutableUserInfo[@"email"] = userEmail;
        }
        [self socialAuthenticationwith:mutableUserInfo error:error];
    };
    
    void(^successHandler)(JRCaptureUser *, BOOL) = ^(JRCaptureUser *user, BOOL isUpdated) {
        [self storeUserProfile:user];
        [self updateNameToJRUserFromAppleUser:appleUser];
        if (isUpdated) {
            return;
        }
        NSError *verificationError = [self emailOrMobileNumberVerificationErrorForUser:user];
        if (verificationError) {
            [self sendMessage:@selector(didLoginFailedwithError:) toListeners:self.userRegistrationListeners withObject:verificationError andObject:nil];
        }else {
            [self completeSocialLoginAfterJanrainSocialLoginWithUser:user andSelectors:@[NSStringFromSelector(@selector(didLoginWithSuccessWithUser:)),
                                                                                         NSStringFromSelector(@selector(didLoginFailedwithError:))]];
        }
    };
    
    void(^failureHandler)(NSError *) = ^(NSError *error) {
        if([error isJRTwoStepRegFlowError]) {
            JRCaptureUser *user = [error JRPreregistrationRecord];
            self.userProfile = user;
            self.userProfile.givenName = (user.givenName.length != 0) ? user.givenName : user.displayName;//Work around for twitter since only display name is avalible
            [self updateNameToJRUserFromAppleUser:appleUser];
            [self setUserProfile:user];
            self->socialRegistrationToken = [error JRSocialRegistrationToken];
            [self sendMessage:@selector(didSocialRegistrationReachedSecoundStepWithUser:withProvide:) toListeners:self.userRegistrationListeners
                   withObject:self andObject:error.userInfo[kProviderKey]];
        }else if ([error isJRMergeFlowError]) {
            [self handleMergeFlowError:error];
        }else if(error.code == DIRegAuthenticationError) {
            [self sendMessage:@selector(socialAuthenticationCanceled) toListeners:self.userRegistrationListeners withObject:nil andObject:nil];
        } else if ([provider isEqualToString:kProviderNameApple] && ((error.code == DIRegAppleUserCancelError) || (error.code == DIRegNoAppleUserError))) {
            [self sendMessage:@selector(socialAuthenticationCanceled) toListeners:self.userRegistrationListeners withObject:nil andObject:nil];
        } else {
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:error];
            [self sendMessage:@selector(didLoginFailedwithError:) toListeners:self.userRegistrationListeners withObject:mappedError andObject:nil];
        }
    };
    if ([provider isEqualToString:kProviderNameGoogle]) {
        [self.googleLoginHandler startGoogleLoginFrom:[self topViewControllerForWindow:[UIApplication sharedApplication].keyWindow] completion:^(NSString * _Nullable token, NSString * _Nullable email, NSError * _Nullable error) {
            if ([token length] > 0 && error == nil) {
                userEmail = email;
                [self.janrainService loginUsingProvider:provider nativeToken:token mergeToken:nil withAuthenticationHandler:authHandler successHandler:successHandler failureHandler:failureHandler];
            } else {
                failureHandler(error);
            }
        }];
    } else if ([provider isEqualToString:kProviderNameFacebook] && [FBSDKLoginHandler isNativeFBLoginAvailable]) {
        [self.fbLoginHandler startFacebookLoginFrom:[self topViewControllerForWindow:[UIApplication sharedApplication].keyWindow] completion:^(NSString * _Nullable token, NSString * _Nullable email, NSError * _Nullable error) {
            if ([token length] > 0 && error == nil) {
                userEmail = email;
                [self.janrainService loginUsingProvider:provider nativeToken:token mergeToken:nil withAuthenticationHandler:authHandler successHandler:successHandler failureHandler:failureHandler];
            } else {
                failureHandler(error);
            }
        }];
    } else  if ([provider isEqualToString:kProviderNameApple]) {
        if (@available(iOS 13.0, *)) {
        [self.appleSignInHandler startAppleLoginFrom:[UIApplication sharedApplication].keyWindow completion: ^ (AppleUser *user, NSError *error) {
               if ([user.appleToken length] > 0 && error == nil) {
                   userEmail = user.emailID;
                   appleUser = user;
                   [self.janrainService loginUsingProvider:provider nativeToken:user.appleToken mergeToken:nil withAuthenticationHandler:authHandler successHandler:successHandler failureHandler:failureHandler];
               } else {
                   failureHandler(error);
               }
           }];
        }
       } else {
           [self.janrainService loginUsingProvider:provider nativeToken:nil mergeToken:nil withAuthenticationHandler:authHandler successHandler:successHandler failureHandler:failureHandler];
    }
}


- (void)completeSocialProviderLoginWithEmail:(NSString*)email
                            withMobileNumber:(NSString*)mobileNumber
                       withOlderThanAgeLimit:(BOOL)isOlderThanAgeLimit
                   withReceiveMarketingMails:(BOOL)receiveMarketingEmails {
    JRCaptureUser *updatedUser = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.userProfile]];
    if(email) {
        updatedUser.email = email;
    }
    if (mobileNumber) {
        updatedUser.mobileNumber = mobileNumber;
    }
    [updatedUser setOlderThanAgeLimitWithBool:isOlderThanAgeLimit];
    [updatedUser setReceiveMarketingEmailWithBool:receiveMarketingEmails];
    [self.janrainService completeSocialLoginForProfile:updatedUser registrationToken:socialRegistrationToken withSuccessHandler:^(JRCaptureUser *user, BOOL isUpdated) {
        [self storeUserProfile:user];
        if (isUpdated) {
            return;
        }
        NSError *verificationError = [self emailOrMobileNumberVerificationErrorForUser:user];
        if (verificationError) {
            [self sendMessage:@selector(didRegisterFailedwithError:) toListeners:self.userRegistrationListeners withObject:verificationError andObject:nil];
        }else {
            [self completeSocialLoginAfterJanrainSocialLoginWithUser:user andSelectors:@[NSStringFromSelector(@selector(didRegisterSuccessWithUser:)),
                                                                                         NSStringFromSelector(@selector(didRegisterFailedwithError:))]];
        }
    } failureHandler:^(NSError *error) {
        [self sendMessage:@selector(didRegisterFailedwithError:) toListeners:self.userRegistrationListeners withObject:error andObject:nil];
    }];
}


- (void)handleMergeRegisterWithProvider:(NSString *)existingAccountProvider {
    void(^authHandler)(NSDictionary *, NSError *) = ^(NSDictionary *userInfo, NSError *error) {
        [self socialAuthenticationwith:userInfo error:error];
    };
    void(^successHandler)(JRCaptureUser *, BOOL) = ^(JRCaptureUser *user, BOOL isUpdated) {
        [self parseResponseAndStoreUser:user isUpadted:isUpdated];
    };
    void(^failureHandler)(NSError *) = ^(NSError *error) {
        if (error.code == DIRegAuthenticationError) {
            [self sendMessage:@selector(socialAuthenticationCanceled) toListeners:self.userRegistrationListeners withObject:nil andObject:nil];
        } else {
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:error];
            [self sendMessage:@selector(didFailHandleMerging:) toListeners:self.userRegistrationListeners withObject:mappedError andObject:nil];
        }
    };
    if ([existingAccountProvider isEqualToString:kProviderNameFacebook] && [FBSDKLoginHandler isNativeFBLoginAvailable]) {
        [self.fbLoginHandler startFacebookLoginFrom:[self topViewControllerForWindow:[UIApplication sharedApplication].keyWindow] completion:^(NSString *token, NSString *email, NSError *error) {
            if (!error && token.length > 0) {
                [self.janrainService loginUsingProvider:existingAccountProvider nativeToken:token mergeToken:self->mergeRegistrationToken withAuthenticationHandler:authHandler successHandler:successHandler failureHandler:failureHandler];
            } else {
                failureHandler(error);
            }
        }];
    } else if ([existingAccountProvider isEqualToString:kProviderNameGoogle]) {
        [self.googleLoginHandler startGoogleLoginFrom:[self topViewControllerForWindow:[UIApplication sharedApplication].keyWindow] completion:^(NSString * _Nullable token, NSString * _Nullable email, NSError * _Nullable error) {
            if ([token length] > 0 && error == nil) {
                [self.janrainService loginUsingProvider:existingAccountProvider nativeToken:token mergeToken:self->mergeRegistrationToken withAuthenticationHandler:authHandler successHandler:successHandler failureHandler:failureHandler];
            } else {
                failureHandler(error);
            }
        }];
    }  else  if ([existingAccountProvider isEqualToString:kProviderNameApple]) {
           if (@available(iOS 13.0, *)) {
           [self.appleSignInHandler startAppleLoginFrom:[UIApplication sharedApplication].keyWindow completion: ^ (AppleUser *user, NSError *error) {
                  if ([user.appleToken length] > 0 && error == nil) {
                      [self.janrainService loginUsingProvider:existingAccountProvider nativeToken:user.appleToken mergeToken:self->mergeRegistrationToken withAuthenticationHandler:authHandler successHandler:successHandler failureHandler:failureHandler];
                  } else {
                      failureHandler(error);
                  }
              }];
           }
          }else {
        [self.janrainService loginUsingProvider:existingAccountProvider nativeToken:nil mergeToken:mergeRegistrationToken withAuthenticationHandler:authHandler successHandler:successHandler failureHandler:failureHandler];
    }
}


- (void)parseResponseAndStoreUser:(JRCaptureUser *)user isUpadted:(BOOL)isUpdated {
    [self storeUserProfile:user];
    if (isUpdated) {
        return;
    }
    NSError *verificationError = [self emailOrMobileNumberVerificationErrorForUser:user];
    if (verificationError) {
        [self sendMessage:@selector(didLoginFailedwithError:) toListeners:self.userRegistrationListeners withObject:verificationError andObject:nil];
    }else {
        [self completeSocialLoginAfterJanrainSocialLoginWithUser:user andSelectors:@[NSStringFromSelector(@selector(didLoginWithSuccessWithUser:)),
                                                                                     NSStringFromSelector(@selector(didFailHandleMerging:))]];
    }
}


- (void)handleMergeRegisterWithEmail:(NSString *)email withPassword:(NSString *)password {
    [self.janrainService handleTraditionalToSocialMergeWithEmail:email password:password mergeToken:mergeRegistrationToken successHandler:^(JRCaptureUser *user, BOOL isUpdated) {
        [self parseResponseAndStoreUser:user isUpadted:isUpdated];
    } failureHandler:^(NSError *error) {
        [self sendMessage:@selector(didFailHandleMerging:) toListeners:self.userRegistrationListeners withObject:[URJanrainErrorParser mappedErrorForJanrainError:error] andObject:nil];
    }];
}


- (void)handleMergeFlowError:(NSError *)error {
    NSString *existingAccountProvider = [error JRMergeFlowExistingProvider];
    NSString *provider = [error JRMergeFlowConflictedProvider];
    mergeRegistrationToken = [error JRMergeToken];
    
    if ([existingAccountProvider isEqualToString:@"capture"]) {
        [self handleTradMerge:error];
    }else {
        [self sendMessage:@selector(handleAccountSocailMergeWithExistingAccountProvider:provider:) toListeners:self.userRegistrationListeners
               withObject:existingAccountProvider andObject:provider];
    }
}


- (void)handleTradMerge:(NSError *)error {
    NSError *mergeError = [URJanrainErrorParser errorForErrorCode:DIMergeFlowErrorCode];
    [self sendMessage:@selector(didRegisterFailedwithError:) toListeners:self.userRegistrationListeners withObject:mergeError andObject:nil];
}


- (UIViewController *)topViewControllerForWindow:(UIWindow *)window {
    UIViewController *topViewController = window.rootViewController;
    while (topViewController.presentedViewController) {
        topViewController = topViewController.presentedViewController;
    }
    return topViewController;
}

@end
