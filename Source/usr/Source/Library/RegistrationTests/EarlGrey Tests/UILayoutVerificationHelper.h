//
//  UILayoutVerificationHelper.h
//  Registration
//
//  Created by Adarsh Kumar Rai on 23/08/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILayoutVerificationHelper : NSObject

+ (void)verifyDemoAppAndLauchUApp;
+ (void)verifyCreateAccountScreenLayout;
+ (void)verifyStartScreenLayout;
+ (void)verifyLogInScreenLayout;
+ (void)verifyForgotPasswordScreenLayout:(BOOL)isResetEmail;
+ (void)verifyEmailVerificationScreenLayout;
+ (void)verifyResendEmailScreenLayout;
+ (void)verifyTraditionalMergeScreenLayout;
+ (void)verifyAddRecoveryEmailScreenLayout;
+ (void)verifySMSVerificationScreenLayoutForActivation;
+ (void)verifyResendSmsScreenLayout:(NSString *)mobileNumber;
+ (void)verifyAlmostDoneScreenLayout;
+ (void)verifyCountrySelectionScreenLayout;
+ (void)verifyPhilipsNewsScreenLayout;
+ (void)verifyMyDetailsScreenLayout;
+ (void)verifySMSVerificationScreenLayoutForResetPassword:(NSString *)mobileNumber;
+ (void)verifyUserOptinScreen;

@end
