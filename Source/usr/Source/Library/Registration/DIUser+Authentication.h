//
//  DIUser+Authentication.h
//  Registration
//
//  Created by Adarsh Kumar Rai on 25/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "DIUser.h"

@interface DIUser (Authentication)


/**
 *  Registers a new user.
 *
 *  @param email                    The email address of the user
 *  @param password                 The password
 *  @param firstname                Given (first) name of the user
 *  @param lastName                 Family (last) name of the user
 *  @param isOlderThanAgeLimit      Set if user is older than given age limit
 *  @param receiveMarketingEmails   Set if user has agreed to receive marketing emails
 *
 *  @since 1.0.0
 */
- (void)registerNewUserUsingTraditional:(nullable NSString *)email withMobileNumber:(nullable NSString *)mobileNumber withFirstName:(nonnull NSString *)firstname withLastName:(nullable NSString *)lastName withOlderThanAgeLimit:(BOOL)isOlderThanAgeLimit withReceiveMarketingMails:(BOOL)receiveMarketingEmails withPassword:(nonnull NSString *)password;


/**
 *  Starts the flow to resend verification email to the user.
 *
 *  @param emailAddress Email address of the user
 *
 *  @since 1.0.0
 */
- (void)resendVerificationMail:(nonnull NSString *)emailAddress;

/**
 *  This method is called when user has forgortten his password and wants to initiate process to reset it.
 *
 *  @param emailAddress The emailAddress of the user
 *
 *  @since 1.0.0
 */
- (void)forgotPasswordForEmail:(nonnull NSString *)emailAddress;

/**
 *  This method is called when user has to verify his account using mobile and wants to initiate process to resend verification code.
 *
 *  @param mobileNumber The mobileNumber of the user
 *
 *  @since 1.0.0
 */
- (void)resendVerificationCodeForMobile:(nonnull NSString *)mobileNumber;

/**
 *  This method is called when user has to verify his account using mobile and wants to initiate process to activate account.
 *
 *  @param verificationCode The verificationCode of the user
 *
 *  @since 1.0.0
 */
- (void)verificationCodeForMobile:(nonnull NSString *)verificationCode;

/**
 *  This method is called when user has to reset his account using mobile and wants to initiate process to send verification code.
 *
 *  @param mobileNumber The mobileNumber of the user
 *
 *  @since 1.0.0
 */
- (void)verificationCodeToResetPassword:(nonnull NSString *)mobileNumber;

/**
 *  Registers the new user using traditional mechanism of email and password combination. Requires that the flow name and Capture app ID be configured.
 *
 *  @param emailAddress The email address of the user
 *  @param password     The password of the user
 *
 *  @since 1.0.0
 */
- (void)loginUsingTraditionalWithEmail:(nonnull NSString *)emailAddress
                              password:(nonnull NSString *)password;

/**
 *  Registers a new user.
 *
 *  @param provider The provider to be used for social login e.g. facebook or twitter etc.
 *
 *  @since 1.0.0
 */
- (void)loginUsingProvider:(nonnull NSString *)provider;

/**
 *  Completes the social provider login. It is called when user record was not found in the database and requires additional mandatory information to be registered.
 *
 *  @param email                    Email of the user
 *  @param mobileNumber             The mobileNumber of the user
 *  @param isOlderThanAgeLimit      Set if user is older than given age limit
 *  @param receiveMarketingEmails   Set if user has agreed to receive marketing emails
 *
 *  @since 1.0.0
 */
-(void)completeSocialProviderLoginWithEmail:(nullable NSString*)email
                           withMobileNumber:(nullable NSString*)mobileNumber
                      withOlderThanAgeLimit:(BOOL)isOlderThanAgeLimit
                  withReceiveMarketingMails:(BOOL)receiveMarketingEmails;


/**
 *  Handles Merging of users
 *
 *  @param email    The email address of the user
 *  @param password The password
 *
 *  @since 1.0.0
 */
- (void)handleMergeRegisterWithEmail:(nonnull NSString *)email withPassword:(nonnull NSString *)password;



/**
 *  Handles Merging of users
 *
 *  @param existingAccountProvider The existing account provider name
 *
 *  @since 1.0.0
 */
-(void)handleMergeRegisterWithProvider:(nonnull NSString *)existingAccountProvider;

@end
