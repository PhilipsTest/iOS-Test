//
//  URRegistrationProtocols.h
//  Registration
//
//  Created by Adarsh Kumar Rai on 25/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DIUser;


/**
 *  Implement this protocol to be informed about success or failure of `PhilipsRegistration` URLs, configurations and flow download.
 *
 *  @since 1.0.0
 */
@protocol JanrainFlowDownloadDelegate <NSObject>
@optional

/**
 *  Called when failed to download URLs, configurations and flow data from janrain server.
 *
 *  @param error Error that occurred during download.
 *
 *  @since 1.0.0
 */
- (void)didFailToDownloadJanrainFlow:(nonnull NSError *)error;

/**
 *  Called when URLs, configurations and flow data has been downloaded successfully.
 *
 *  @since 1.0.0
 */
- (void)didFinishDownloadingJanrainFlow;
@end



/**
 *  Use this delegate to receive callbacks about user registration, login, forgot passowrd, resend verfication, account merging and logout events.
 *
 *  @since 1.0.0
 */
@protocol UserRegistrationDelegate <NSObject>

@optional

/**
 *  Called when user has been authenticated successfully.
 *
 *  @param profile DIUser object that wraps the logged in user's profile.
 *
 *  @discussion This callback does not gaurantee that user login process has completed. User might not have accepted TnC of application. This callback merely indicates that user's authentication with backend was successful.
 *  @since 1.0.0
 */
- (void)didLoginWithSuccessWithUser:(nonnull DIUser *)profile;

/**
 *  Called when user's authentication with backend has failed.
 *
 *  @param error Contains description of error that occurred during authentication.
 *
 *  @since 1.0.0
 */
- (void)didLoginFailedwithError:(nonnull NSError *)error;

/**
 *  Called when user has been authenticated with social provider and user profile has been received from social provider. Typically used to add any more info to registration for e.g. marketing opt-in etc. before account is created in Janrain.
 *
 *  @param profile      DIUser object that wraps the logged in user's profile.
 *  @param providerName Name of the provider with user has been authenticated.
 *
 *  @since 1.0.0
 */
- (void)didSocialRegistrationReachedSecoundStepWithUser:(nonnull DIUser *)profile withProvide:(nonnull NSString *)providerName;

/**
 *  Called when user has succesfully authenticated with social provider or user account has been merged successfully.
 *
 *  @param email Email of the authenticated user.
 *
 *  @discussion This callback does not gaurantee that user login process has completed. User might not have accepted TnC of application. This callback merely indicates that user's authentication with social provider was successful.
 *  @since 1.0.0
 */
- (void)didAuthenticationCompleteForLogin:(nonnull NSString *)email;

/**
 *  Called when social login cannot be launched.
 *
 *  @param error Description of the error that occurred during social launch.
 *
 *  @since 1.0.0
 */
- (void)socialLoginCannotLaunch:(nonnull NSError *)error;

/**
 *  Called when user has cancelled the social login.
 *
 *  @since 1.0.0
 */
- (void)socialAuthenticationCanceled;

/**
 *  Called when social authentication has failed. Typically when user has denied the permission.
 *
 *  @param error    Description of error that occurred during social authentication.
 *  @param provider Name of provider with which authentication was tried.
 *
 *  @since 1.0.0
 */
- (void)socialAuthenticationDidFailedWithError:(nonnull NSError *)error withProvider:(nonnull NSString *)provider;

/**
 *  Called when user has been registered successfully either via traditional or social method.
 *
 *  @param profile DIUser object that wraps the created user's profile.
 *
 *  @discussion This callback does not gaurantee that user creation process has completed. User might not have accepted TnC of application. This callback merely indicates that user creation in backend was successful
 *  @since 1.0.0
 */
- (void)didRegisterSuccessWithUser:(nonnull DIUser *)profile;

/**
 *  Called when user registration has failed.
 *
 *  @param error Contains decription of error occurred.
 *
 *  @since 1.0.0
 */
- (void)didRegisterFailedwithError:(nonnull NSError *)error;

/**
 *  Called when an email to reset password was sent successfully.
 *
 *  @since 1.0.0
 */
- (void)didSendForgotPasswordSuccess;

/**
 *   Called when failed to send email to reset password.
 *
 *  @param error Description of error that occurred.
 *
 *  @since 1.0.0
 */
- (void)didSendForgotPasswordFailedwithError:(nonnull NSError *)error;

/**
 *  Called when an email was resent with a link for account verification.
 *
 *  @since 1.0.0
 */
- (void)didResendEmailverificationSuccess;

/**
 *  Called when failed to resend account verification email.
 *
 *  @param error Description of error that occurred.
 *
 *  @since 1.0.0
 */
- (void)didResendEmailverificationFailedwithError:(nonnull NSError *)error;

/**
 *  Called when account OTP verification code has been resent successfully to user's mobile number.
 *
 *  @since 1.0.0
 */
- (void)didResendMobileverificationSuccess;

/**
 *  Called when failed to resend OTP verification code for account verification.
 *
 *  @param error Description of error that occurred.
 *
 *  @since 1.0.0
 */
- (void)didResendMobileverificationFailedwithError:(nonnull NSError *)error;

/**
 *  Called when user account was verified successfully via SMS OTP.
 *
 *  @since 1.0.0
 */
- (void)didVerificationForMobileSuccess;

/**
 *  Called when user account could not be verfied for the entered SMS OTP.
 *
 *  @param error Description of error that occurred.
 *
 *  @since 1.0.0
 */
- (void)didVerificationForMobileFailedwithError:(nonnull NSError *)error;

/**
 *  Called when an SMS OTP was successfully sent to user's mobile number and a resepective reset token was generated for password reset.
 *
 *  @param resetToken Reset token to be used with OTP for password reset.
 *
 *  @since 1.0.0
 */
- (void)didVerificationForMobileToResetPasswordSuccessWithToken:(nonnull NSString *)resetToken;

/**
 *  Called when an SMS OTP could not be sent to user's mobile number for password reset.
 *
 *  @param error Description of error that occurred.
 *
 *  @since 1.0.0
 */
- (void)didVerificationForMobileToResetPasswordFailedwithError:(nonnull NSError *)error;

/**
 *  Called when user accounts have been merged successfully.
 *
 *  @since 1.0.0
 */
- (void)didHandleMergingSuccess;

/**
 *  Called when merging user accounts has failed.
 *
 *  @param error Description of error that occurred.
 *
 *  @since 1.0.0
 */
- (void)didFailHandleMerging:(nonnull NSError *)error;

/**
 *  Called when user was successfully logged out and all their data was purged from device.
 *
 *  @since 1.0.0
 */
- (void)logoutDidSucceed;

/**
 *  Called when logout has failed.
 *
 *  @param error Description of error that occurred.
 *
 *  @since 1.0.0
 */
- (void)logoutFailedWithError:(nonnull NSError *)error;

/**
 *  Called when user is trying to login with one provider while user's account already exists with different provider. In such case, user need to merge the accounts to be able to login with both providers or go back to provider with which the account was originally created.
 *
 *  @param existingAccountProvider  Name of the provider with which user is already registered.
 *  @param provider                 Name of the provider with which user is trying to login.
 *
 *  @since 1.0.0
 */
- (void)handleAccountSocailMergeWithExistingAccountProvider:(nonnull NSString *)existingAccountProvider provider:(nonnull NSString *)provider;
@end


/**
 Implement this protocol to receive callbacks about fetching and updation to user details.
 */
@protocol UserDetailsDelegate <NSObject>
@optional

/**
 *  Called when user's profile information has been updated successfully in backend. Typically called in response to update marketing opt-in, replace consumer interests, update DOB and gender, update mobile number and add recovery email requests.
 *
 *  @since 1.0.0
 */
- (void)didUpdateSuccess;

/**
 *  Called when failed to update user profile info in backend. Typically called in response to update marketing opt-in, replace consumer interests, update DOB and gender, update mobile number and add recovery email requests.
 *
 *  @param error Description of error that occurred.
 *
 *  @since 1.0.0
 */
- (void)didUpdateFailedWithError:(nonnull NSError *)error;

/**
 *  Called when latest user profile was fetched successfully from backend.
 *
 *  @param profile "DIUser object that wraps the logged in user's profile.
 *
 *  @since 1.0.0
 */
- (void)didUserInfoFetchingSuccessWithUser:(nonnull DIUser *)profile;

/**
 *  Called when failed to fetch latest user profile from backend.
 *
 *  @param error Description of error that occurred.
 *
 *  @since 1.0.0
 */
- (void)didUserInfoFetchingFailedWithError:(nonnull NSError *)error;
@end


/**
 Implement this protocol to receive callbacks about user session refresh.
 */
@protocol SessionRefreshDelegate <NSObject>

@optional

/**
 *  Called when user's login session has been refreshed successfully.
 *
 *  @since 1.0.0
 */
- (void)loginSessionRefreshSucceed;

/**
 *  Called when failed to refresh login session.
 *
 *  @param error Description of error that occurred.
 *
 *  @since 1.0.0
 */
-(void)loginSessionRefreshFailedWithError:(nonnull NSError*)error;

/**
 *  Called when failed to refresh login session because user's current session was invalidated by the backend. User needs to login again to continue in such cases.
 *
 *  @since 1.0.0
 */
- (void)loginSessionRefreshFailedAndLoggedout;

@end
