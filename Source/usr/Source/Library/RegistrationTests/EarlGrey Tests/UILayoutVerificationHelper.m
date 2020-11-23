//
//  UILayoutVerificationHelper.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 23/08/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URSettingsWrapper.h"
#import "UILayoutVerificationHelper.h"
#import "RegistrationUIConstants.h"
#import "ValidationHelper.h"
#import "DIUser.h"


#define kHorizontalMargin [ValidationHelper horizontalMarginForCurrentSizeClass]
#define kVerticalMargin   [ValidationHelper verticalMarginForCurrentSizeClass]


@implementation UILayoutVerificationHelper

+ (void)verifyDemoAppAndLauchUApp {
    /*-------TestAppViewController Verification-------*/
    [ValidationHelper assertThatCurrentScreenHasTitle:@"Demo App"];
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"demoApp.registrationButton"];
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"USR_Account_Setting_Titletxt"];
    if (![ValidationHelper buttonWithId:@"Change_Configuration" hasTitle:@"Configuration : Standard"]) {
        [ValidationHelper scrollToElementWithId:@"Change_Configuration" inDirection:kGREYDirectionDown andPerformAction:grey_tap()];
        [[EarlGrey selectElementWithMatcher:grey_text(@"Change configuration file")] assertWithMatcher:grey_sufficientlyVisible()];
        [ValidationHelper tapElementWithText:@"Standard"];
        //Uncomment below line when demo app buttons are UIDButtons and not PUIButton
        //[ValidationHelper assertThatButtonWithId:@"Change_Configuration" hasTitle:@"Configuration : Standard" andWidth:0];
    }
    
    /*-------Launch Philips Registration uApp-------*/
    if (![ValidationHelper isScrollViewContainingElement:@"demoApp.registrationButton" scrolledToEdge:kGREYContentEdgeTop]) {
        [[EarlGrey selectElementWithMatcher:grey_kindOfClass([UIScrollView class])] performAction:grey_scrollToContentEdge(kGREYContentEdgeTop)];
    }
    [EarlGrey rotateDeviceToOrientation:UIDeviceOrientationLandscapeRight errorOrNil:nil];
    [ValidationHelper assertThatCurrentScreenHasTitle:@"Demo App"];
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"demoApp.registrationButton"];
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"USR_Account_Setting_Titletxt"];
    [EarlGrey rotateDeviceToOrientation:UIDeviceOrientationPortrait errorOrNil:nil];
    [ValidationHelper tapButtonWithId:@"demoApp.registrationButton"];
}


+ (void)verifyCreateAccountScreenLayout {
    
    [ValidationHelper assertThatCurrentScreenHasTitle:LOCALIZE(@"USR_DLS_URCreateAccount_NavTitle")];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_createscreen_firstname_label"];
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_firstname_label" hasText:LOCALIZE(@"USR_DLS_First_Name_Label_Text")];
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_firstname_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_firstname_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_firstname_label" hasMarginOf:kVerticalMargin inDirection:kGREYLayoutDirectionUp];
    
    [ValidationHelper assertThatElementWithIdIsSufficientlyVisible:@"usr_createscreen_firstname_textfield"];
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_firstname_textfield" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_firstname_textfield" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_firstname_textfield" isBelowElementWithId:@"usr_createscreen_firstname_label" byPoints:8];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_firstname_textfield")] performAction:grey_typeText(@"philips")];
    
    NSError *keyboardError;
    [EarlGrey dismissKeyboardWithError:&keyboardError];
    
    if ([URSettingsWrapper sharedInstance].launchInput.registrationFlowConfiguration.enableLastName) {
        if (![ValidationHelper isElementWithIdSufficientlyVisible:@"usr_createscreen_lastname_textfield"]) {
            [ValidationHelper scrollToElementWithId:@"usr_createscreen_lastname_textfield" inDirection:kGREYDirectionDown];
        }
        
        [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_createscreen_lastname_label"];
        [ValidationHelper assertThatElementWithId:@"usr_createscreen_lastname_label" hasText:LOCALIZE(@"USR_DLS_Last_Name_Label_Text")];
        [ValidationHelper assertThatElementWithId:@"usr_createscreen_lastname_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
        [ValidationHelper assertThatElementWithId:@"usr_createscreen_lastname_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
        [ValidationHelper assertThatElementWithId:@"usr_createscreen_lastname_label" isBelowElementWithId:@"usr_createscreen_firstname_textfield" byPoints:16];
        
        [ValidationHelper assertThatElementWithIdIsSufficientlyVisible:@"usr_createscreen_lastname_textfield"];
        [ValidationHelper assertThatElementWithId:@"usr_createscreen_lastname_textfield" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
        [ValidationHelper assertThatElementWithId:@"usr_createscreen_lastname_textfield" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
        [ValidationHelper assertThatElementWithId:@"usr_createscreen_lastname_textfield" isBelowElementWithId:@"usr_createscreen_lastname_label" byPoints:8];
    } else {
        [ValidationHelper assertThatElementWithIdIsInvisible:@"usr_createscreen_lastname_label"];
        [ValidationHelper assertThatElementWithIdIsInvisible:@"usr_createscreen_lastname_textfield"];
    }
    
    if (![ValidationHelper isElementWithIdSufficientlyVisible:@"usr_createscreen_emailormobile_textfield"]) {
        [ValidationHelper scrollToElementWithId:@"usr_createscreen_emailormobile_textfield" inDirection:kGREYDirectionDown];
    }

    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_createscreen_emailormobile_label"];
    if ([URSettingsWrapper sharedInstance].loginFlowType == RegistrationLoginFlowTypeEmail) {
        [ValidationHelper assertThatElementWithId:@"usr_createscreen_emailormobile_label" hasText:LOCALIZE(@"USR_DLS_Email_Label_Text")];
    } else {
        [ValidationHelper assertThatElementWithId:@"usr_createscreen_emailormobile_label" hasText:LOCALIZE(@"USR_DLS_Phonenumber_Label_Text")];
    }
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_emailormobile_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_emailormobile_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    if (([URSettingsWrapper sharedInstance].launchInput.registrationFlowConfiguration.enableLastName)) {
        [ValidationHelper assertThatElementWithId:@"usr_createscreen_emailormobile_label" isBelowElementWithId:@"usr_createscreen_lastname_textfield" byPoints:16];
    } else {
        [ValidationHelper assertThatElementWithId:@"usr_createscreen_emailormobile_label" isBelowElementWithId:@"usr_createscreen_firstname_textfield" byPoints:16];
    }
    
    [ValidationHelper assertThatElementWithIdIsSufficientlyVisible:@"usr_createscreen_emailormobile_textfield"];
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_emailormobile_textfield" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_emailormobile_textfield" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_emailormobile_textfield" isBelowElementWithId:@"usr_createscreen_emailormobile_label" byPoints:8];
    
    if (![ValidationHelper isElementWithIdSufficientlyVisible:@"usr_createscreen_password_textfield"]) {
        [ValidationHelper scrollToElementWithId:@"usr_createscreen_password_textfield" inDirection:kGREYDirectionDown];
    }
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_createscreen_password_label"];
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_password_label" hasText:LOCALIZE(@"USR_DLS_Password_lbltxt")];
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_password_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_password_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_password_label" isBelowElementWithId:@"usr_createscreen_emailormobile_textfield" byPoints:16];
    
    [ValidationHelper assertThatElementWithIdIsSufficientlyVisible:@"usr_createscreen_password_textfield"];
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_password_textfield" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_password_textfield" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_password_textfield" isBelowElementWithId:@"usr_createscreen_password_label" byPoints:8];

    [ValidationHelper assertThatElementWithIdIsInvisible:@"usr_createscreen_passwordstrength_label"];
    [ValidationHelper assertThatElementWithIdIsInvisible:@"usr_createscreen_passwordhint_view"];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_firstname_textfield")] performAction:grey_replaceText(@"")];
}


+ (void)verifyStartScreenLayout {
    [ValidationHelper assertThatCurrentScreenHasTitle:LOCALIZE(@"USR_DLS_StratScreen_Nav_Title_Txt")];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_startscreen_title_label"];
    [ValidationHelper assertThatElementWithId:@"usr_startscreen_title_label" hasText:LOCALIZE(@"USR_DLS_StratView_Title_Txt")];
    [ValidationHelper assertThatElementWithId:@"usr_startscreen_title_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_startscreen_title_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_startscreen_title_label" hasMarginOf:kVerticalMargin inDirection:kGREYLayoutDirectionUp];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_startscreen_detail_label"];
    [ValidationHelper assertThatElementWithId:@"usr_startscreen_detail_label" hasText:LOCALIZE(@"USR_DLS_StratView_Detail_Txt")];
    [ValidationHelper assertThatElementWithId:@"usr_startscreen_detail_label" isBelowElementWithId:@"usr_startscreen_title_label" byPoints:16];
    [ValidationHelper assertThatElementWithId:@"usr_startscreen_detail_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_startscreen_detail_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_startscreen_create_button"];
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_startscreen_login_button"];
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_startscreen_login_label"];
    
    if ([URSettingsWrapper sharedInstance].launchInput.registrationFlowConfiguration.priorityFunction == URPriorityFunctionRegistration) {
        [ValidationHelper assertThatButtonWithId:@"usr_startscreen_create_button" hasTitle:LOCALIZE(@"USR_DLS_Create_Account_CreateMyPhilips_btntxt") andWidth:0];
        [ValidationHelper assertThatElementWithId:@"usr_startscreen_create_button" isBelowElementWithId:@"usr_startscreen_detail_label" byPoints:24];
        [ValidationHelper assertThatElementWithId:@"usr_startscreen_create_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
        [ValidationHelper assertThatElementWithId:@"usr_startscreen_create_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
        
        [ValidationHelper assertThatButtonWithId:@"usr_startscreen_login_button" hasTitle:LOCALIZE(@"USR_DLS_SigIn_TitleTxt") andWidth:0];
        [ValidationHelper assertThatElementWithId:@"usr_startscreen_login_button" isBelowElementWithId:@"usr_startscreen_create_button" byPoints:8];
        [ValidationHelper assertThatElementWithId:@"usr_startscreen_login_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
        [ValidationHelper assertThatElementWithId:@"usr_startscreen_login_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
        
        [ValidationHelper assertThatElementWithId:@"usr_startscreen_login_label" hasText:LOCALIZE(@"USR_DLS_Welcome_Alternate_SignInAccount_lbltxt")];
        [ValidationHelper assertThatElementWithId:@"usr_startscreen_login_label" isBelowElementWithId:@"usr_startscreen_login_button" byPoints:24.0];
        [ValidationHelper assertThatElementWithId:@"usr_startscreen_login_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
        [ValidationHelper assertThatElementWithId:@"usr_startscreen_login_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    }
    
    if ([URSettingsWrapper sharedInstance].loginFlowType == RegistrationLoginFlowTypeMobile) {
        [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_startscreen_wechat_button"];
        [ValidationHelper assertThatButtonWithId:@"usr_startscreen_wechat_button" hasTitle:nil andWidth:32];
        [ValidationHelper assertThatElementWithId:@"usr_startscreen_wechat_button" isBelowElementWithId:@"usr_startscreen_login_label" byPoints:16];
    } else {
        [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_startscreen_facebook_button"];
        [ValidationHelper assertThatButtonWithId:@"usr_startscreen_facebook_button" hasTitle:nil andWidth:32];
        [ValidationHelper assertThatElementWithId:@"usr_startscreen_facebook_button" isOnLeftOfElementWithId:@"usr_startscreen_googleplus_button" byPoints:16];
        [ValidationHelper assertThatElementWithId:@"usr_startscreen_facebook_button" isBelowElementWithId:@"usr_startscreen_login_label" byPoints:16];
        
        [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_startscreen_googleplus_button"];
        [ValidationHelper assertThatButtonWithId:@"usr_startscreen_googleplus_button" hasTitle:nil andWidth:32];
        [ValidationHelper assertThatElementWithId:@"usr_startscreen_googleplus_button" isOnRightOfElementWithId:@"usr_startscreen_facebook_button" byPoints:16];
        [ValidationHelper assertThatElementWithId:@"usr_startscreen_googleplus_button" isBelowElementWithId:@"usr_startscreen_login_label" byPoints:16];
    }
    
    if ([URSettingsWrapper sharedInstance].launchInput.registrationFlowConfiguration.enableSkipRegistration) {
        if (![ValidationHelper isElementWithIdCompletelyVisible:@"usr_startscreen_skipregistration_button"]) {
            [ValidationHelper scrollToElementWithId:@"usr_startscreen_skipregistration_button" inDirection:kGREYDirectionDown];
        }
        if (![ValidationHelper isElementWithIdCompletelyVisible:@"usr_startscreen_skipregistration_button"]) {
            [ValidationHelper scrollToElementWithId:@"usr_startscreen_skipregistration_button" inDirection:kGREYDirectionDown];
        }
        [ValidationHelper assertThatElementWithIdIsSufficientlyVisible:@"usr_startscreen_skipregistration_button"];
        [ValidationHelper assertThatButtonWithId:@"usr_startscreen_skipregistration_button" hasTitle:LOCALIZE(@"USR_DLS_Continue_Without_Account") andWidth:0];
        [ValidationHelper assertThatElementWithId:@"usr_startscreen_skipregistration_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
        [ValidationHelper assertThatElementWithId:@"usr_startscreen_skipregistration_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
        NSString *socialButtonId = @"usr_startscreen_googleplus_button";
        if ([URSettingsWrapper sharedInstance].loginFlowType == RegistrationLoginFlowTypeMobile) {
            socialButtonId = @"usr_startscreen_wechat_button";
        }
        [ValidationHelper assertThatElementWithId:@"usr_startscreen_skipregistration_button" isBelowElementWithId:socialButtonId byPoints:24];
    } else {
        [ValidationHelper assertThatElementWithIdIsInvisible:@"usr_startscreen_skipregistration_button"];
    }
}


+ (void)verifyLogInScreenLayout {
    [ValidationHelper assertThatCurrentScreenHasTitle:LOCALIZE(@"USR_DLS_SigIn_TitleTxt")];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_loginScreen_loginTitle_label"];
    [ValidationHelper assertThatElementWithId:@"usr_loginScreen_loginTitle_label" hasText:LOCALIZE(@"USR_DLS_TraditionalSignIn_SignInWithMyPhilips_lbltxt")];
    [ValidationHelper assertThatElementWithId:@"usr_loginScreen_loginTitle_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_loginScreen_loginTitle_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_loginScreen_loginTitle_label" hasMarginOf:kVerticalMargin inDirection:kGREYLayoutDirectionUp];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_loginScreen_email_label"];
    if ([URSettingsWrapper sharedInstance].loginFlowType == RegistrationLoginFlowTypeMobile) {
        [ValidationHelper assertThatElementWithId:@"usr_loginScreen_email_label" hasText:LOCALIZE(@"USR_DLS_Email_Phone_Label_Text")];
    } else {
        [ValidationHelper assertThatElementWithId:@"usr_loginScreen_email_label" hasText:LOCALIZE(@"USR_DLS_Email_Label_Text")];
    }
    [ValidationHelper assertThatElementWithId:@"usr_loginScreen_email_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_loginScreen_email_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_loginScreen_email_label" isBelowElementWithId:@"usr_loginScreen_loginTitle_label" byPoints:24];
    
    [ValidationHelper assertThatElementWithIdIsSufficientlyVisible:@"usr_loginScreen_email_textField"];
    [ValidationHelper assertThatElementWithId:@"usr_loginScreen_email_textField" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_loginScreen_email_textField" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_loginScreen_email_textField" isBelowElementWithId:@"usr_loginScreen_email_label" byPoints:8];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_loginScreen_password_label"];
    [ValidationHelper assertThatElementWithId:@"usr_loginScreen_password_label" hasText:LOCALIZE(@"USR_DLS_Password_lbltxt")];
    [ValidationHelper assertThatElementWithId:@"usr_loginScreen_password_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_loginScreen_password_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_loginScreen_password_label" isBelowElementWithId:@"usr_loginScreen_email_textField" byPoints:16];
    
    [ValidationHelper assertThatElementWithIdIsSufficientlyVisible:@"usr_loginScreen_password_textField"];
    [ValidationHelper assertThatElementWithId:@"usr_loginScreen_password_textField" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_loginScreen_password_textField" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_loginScreen_password_textField" isBelowElementWithId:@"usr_loginScreen_password_label" byPoints:8];
    
    [ValidationHelper assertThatElementWithIdIsNotEnabled:@"usr_loginScreen_login_button"];
}


+ (void)verifyForgotPasswordScreenLayout:(BOOL)isResetEmail {
    [ValidationHelper assertThatCurrentScreenHasTitle:LOCALIZE(@"USR_DLS_SigIn_TitleTxt")];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_forgotPasswordScreen_resendEmail_label"];
    [ValidationHelper assertThatElementWithId:@"usr_forgotPasswordScreen_resendEmail_label" hasText:LOCALIZE(@"USR_Forgot_Password_Title")];
    [ValidationHelper assertThatElementWithId:@"usr_forgotPasswordScreen_resendEmail_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_forgotPasswordScreen_resendEmail_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_forgotPasswordScreen_resendEmail_label" hasMarginOf:kVerticalMargin inDirection:kGREYLayoutDirectionUp];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_forgotPasswordScreen_passwordDetail_label"];
    [ValidationHelper assertThatElementWithId:@"usr_forgotPasswordScreen_passwordDetail_label" hasText:isResetEmail ? LOCALIZE(@"USR_DLS_Forgot_Password_Body_Without_Phone_No") : LOCALIZE(@"USR_DLS_Forgot_Password_Body_With_Phone_No")];
    [ValidationHelper assertThatElementWithId:@"usr_forgotPasswordScreen_passwordDetail_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_forgotPasswordScreen_passwordDetail_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_forgotPasswordScreen_passwordDetail_label" isBelowElementWithId:@"usr_forgotPasswordScreen_resendEmail_label" byPoints:16];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_forgotPasswordScreen_email_label"];
    [ValidationHelper assertThatElementWithId:@"usr_forgotPasswordScreen_email_label" hasText:isResetEmail ? LOCALIZE(@"USR_DLS_Email_Label_Text") : LOCALIZE(@"USR_DLS_Email_Phone_Label_Text")];
    [ValidationHelper assertThatElementWithId:@"usr_forgotPasswordScreen_email_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_forgotPasswordScreen_email_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_forgotPasswordScreen_email_label" isBelowElementWithId:@"usr_forgotPasswordScreen_passwordDetail_label" byPoints:16];
    
    [ValidationHelper assertThatElementWithIdIsSufficientlyVisible:@"usr_forgotPasswordScreen_email_textField"];
    [ValidationHelper assertThatElementWithId:@"usr_forgotPasswordScreen_email_textField" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_forgotPasswordScreen_email_textField" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_forgotPasswordScreen_email_textField" isBelowElementWithId:@"usr_forgotPasswordScreen_email_label" byPoints:8];
    
    [ValidationHelper assertThatElementWithIdIsPartiallyVisible:@"usr_forgotPasswordScreen_send_button"];
    [ValidationHelper assertThatButtonWithId:@"usr_forgotPasswordScreen_send_button" hasTitle:LOCALIZE(@"USR_DLS_Forgot_Password_Button_Title") andWidth:0];
    [ValidationHelper assertThatElementWithId:@"usr_forgotPasswordScreen_send_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_forgotPasswordScreen_send_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_forgotPasswordScreen_send_button" isBelowElementWithId:@"usr_forgotPasswordScreen_email_textField" byPoints:24];
    
    [ValidationHelper assertThatElementWithIdIsNotEnabled:@"usr_forgotPasswordScreen_send_button"];
}

+ (void)verifyEmailVerificationScreenLayout {
    [ValidationHelper assertThatCurrentScreenHasTitle:LOCALIZE(@"USR_DLS_URCreateAccount_NavTitle")];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_verifyEmailScreen_confirmEmail_title"];
    [ValidationHelper assertThatElementWithId:@"usr_verifyEmailScreen_confirmEmail_title" hasText:LOCALIZE(@"USR_DLS_Verify_Email_Title_Txt")];
    [ValidationHelper assertThatElementWithId:@"usr_verifyEmailScreen_confirmEmail_title" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_verifyEmailScreen_confirmEmail_title" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_verifyEmailScreen_confirmEmail_title" hasMarginOf:kVerticalMargin inDirection:kGREYLayoutDirectionUp];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_verifyEmailScreen_verificationSentTo_label"];
    [ValidationHelper assertThatElementWithId:@"usr_verifyEmailScreen_verificationSentTo_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_verifyEmailScreen_verificationSentTo_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_verifyEmailScreen_verificationSentTo_label" isBelowElementWithId:@"usr_verifyEmailScreen_confirmEmail_title" byPoints:16];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_verifyEmailScreen_checkEmail_label"];
    if ([URSettingsWrapper sharedInstance].launchInput.registrationContentConfiguration.valueForEmailVerification.length == 0) {
        [ValidationHelper assertThatElementWithId:@"usr_verifyEmailScreen_checkEmail_label" hasText:LOCALIZE(@"USR_DLS_Verify_Email_Explainary_Txt")];
    } else {
        [ValidationHelper assertThatElementWithId:@"usr_verifyEmailScreen_checkEmail_label" hasText:[URSettingsWrapper sharedInstance].launchInput.registrationContentConfiguration.valueForEmailVerification];
    }
    [ValidationHelper assertThatElementWithId:@"usr_verifyEmailScreen_checkEmail_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_verifyEmailScreen_checkEmail_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_verifyEmailScreen_checkEmail_label" isBelowElementWithId:@"usr_verifyEmailScreen_verificationSentTo_label" byPoints:12];
    
    [ValidationHelper assertThatElementWithIdIsSufficientlyVisible:@"usr_verifyEmailScreen_security_label"];
    [ValidationHelper assertThatElementWithId:@"usr_verifyEmailScreen_security_label" hasText:LOCALIZE(@"USR_DLS_Verify_Email_Security_Txt")];
    [ValidationHelper assertThatElementWithId:@"usr_verifyEmailScreen_security_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_verifyEmailScreen_security_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_verifyEmailScreen_security_label" isBelowElementWithId:@"usr_verifyEmailScreen_checkEmail_label" byPoints:12];
    
    [ValidationHelper assertThatElementWithIdIsPartiallyVisible:@"usr_verifyEmailScreen_emailVerified_button"];
    [ValidationHelper assertThatButtonWithId:@"usr_verifyEmailScreen_emailVerified_button" hasTitle:LOCALIZE(@"USR_DLS_Verify_Email_Verified_Btn_Title_Txt") andWidth:0];
    [ValidationHelper assertThatElementWithId:@"usr_verifyEmailScreen_emailVerified_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_verifyEmailScreen_emailVerified_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_verifyEmailScreen_emailVerified_button" isBelowElementWithId:@"usr_verifyEmailScreen_security_label" byPoints:24];
    
    [ValidationHelper assertThatElementWithIdIsPartiallyVisible:@"usr_verifyEmailScreen_havenotReceivedEmail_button"];
    [ValidationHelper assertThatButtonWithId:@"usr_verifyEmailScreen_havenotReceivedEmail_button" hasTitle:LOCALIZE(@"USR_DLS_Verify_Email_Resend_Btn_Title_Txt") andWidth:0];
    [ValidationHelper assertThatElementWithId:@"usr_verifyEmailScreen_havenotReceivedEmail_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_verifyEmailScreen_havenotReceivedEmail_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_verifyEmailScreen_havenotReceivedEmail_button" isBelowElementWithId:@"usr_verifyEmailScreen_emailVerified_button" byPoints:8];
}


+ (void)verifyResendEmailScreenLayout {
    [ValidationHelper assertThatCurrentScreenHasTitle:LOCALIZE(@"USR_DLS_Resend_Email_Screen_title")];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_resendEmailScreen_resendEmail_label"];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_resendEmail_label" hasText:LOCALIZE(@"USR_DLS_Resend_Email_Title_Txt")];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_resendEmail_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_resendEmail_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_resendEmail_label" hasMarginOf:kVerticalMargin inDirection:kGREYLayoutDirectionUp];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_resendEmailScreen_line1_label"];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_line1_label" hasText:LOCALIZE(@"USR_DLS_Resend_Email_Body_Line1")];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_line1_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_line1_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_line1_label" isBelowElementWithId:@"usr_resendEmailScreen_resendEmail_label" byPoints:16];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_resendEmailScreen_line2_label"];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_line2_label" hasText:LOCALIZE(@"USR_DLS_Resend_Email_Body_Line2")];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_line2_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_line2_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_line2_label" isBelowElementWithId:@"usr_resendEmailScreen_line1_label" byPoints:12];
    
    [ValidationHelper assertThatElementWithIdIsSufficientlyVisible:@"usr_resendEmailScreen_email_label"];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_email_label" hasText:LOCALIZE(@"USR_DLS_Resend_Email_Textbox_Title")];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_email_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_email_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_email_label" isBelowElementWithId:@"usr_resendEmailScreen_line2_label" byPoints:24];
    
    [ValidationHelper assertThatElementWithIdIsSufficientlyVisible:@"usr_resendEmailScreen_email_field"];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_email_field" hasText:[DIUser getInstance].email];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_email_field" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_email_field" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_email_field" isBelowElementWithId:@"usr_resendEmailScreen_email_label" byPoints:8];

    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_resendEmailScreen_time_progressbar"];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_time_progressbar" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_time_progressbar" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_time_progressbar" isBelowElementWithId:@"usr_resendEmailScreen_email_field" byPoints:8];

    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_resendEmailScreen_password_progress_view_title_label"];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_password_progress_view_title_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_password_progress_view_title_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_password_progress_view_title_label" isBelowElementWithId:@"usr_resendEmailScreen_time_progressbar" byPoints:8];
    
    if (![ValidationHelper isElementWithIdSufficientlyVisible:@"usr_resendEmailScreen_resendEmail_button"]) {
        [ValidationHelper scrollToElementWithId:@"usr_resendEmailScreen_resendEmail_button" inDirection:kGREYDirectionDown];
    }
    [ValidationHelper assertThatElementWithIdIsSufficientlyVisible:@"usr_resendEmailScreen_resendEmail_button"];
    [ValidationHelper assertThatButtonWithId:@"usr_resendEmailScreen_resendEmail_button" hasTitle:LOCALIZE(@"USR_DLS_Resend_The_Email_Button_Title") andWidth:0];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_resendEmail_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_resendEmail_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_resendEmail_button" isBelowElementWithId:@"usr_resendEmailScreen_password_progress_view_title_label" byPoints:24];
    
    if (![ValidationHelper isElementWithIdSufficientlyVisible:@"usr_resendEmailScreen_thanks_button"]) {
        [ValidationHelper scrollToElementWithId:@"usr_resendEmailScreen_thanks_button" inDirection:kGREYDirectionDown];
    }
    [ValidationHelper assertThatElementWithIdIsSufficientlyVisible:@"usr_resendEmailScreen_thanks_button"];
    [ValidationHelper assertThatButtonWithId:@"usr_resendEmailScreen_thanks_button" hasTitle:LOCALIZE(@"USR_DLS_Got_It_Now_Button_Title") andWidth:0];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_thanks_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_thanks_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_resendEmailScreen_thanks_button" isBelowElementWithId:@"usr_resendEmailScreen_resendEmail_button" byPoints:8];
}


+ (void)verifyTraditionalMergeScreenLayout {
    [ValidationHelper assertThatCurrentScreenHasTitle:LOCALIZE(@"USR_DLS_SigIn_TitleTxt")];
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_traditionalMergeScreen_title_label"];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_title_label" hasText:LOCALIZE(@"USR_DLS_Merge_Accounts")];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_title_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_title_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_title_label" hasMarginOf:kVerticalMargin inDirection:kGREYLayoutDirectionUp];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_traditionalMergeScreen_descriptionOne_label"];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_descriptionOne_label" hasText:[NSString stringWithFormat:LOCALIZE(@"USR_DLS_Traditional_Merge_Title"),@"philipstest365@gmail.com"]];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_descriptionOne_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_descriptionOne_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_descriptionOne_label" isBelowElementWithId:@"usr_traditionalMergeScreen_title_label" byPoints:16];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_traditionalMergeScreen_descriptionTwo_label"];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_descriptionTwo_label" hasText:LOCALIZE(@"USR_DLS_Traditional_Merge_Description")];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_descriptionTwo_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_descriptionTwo_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_descriptionTwo_label" isBelowElementWithId:@"usr_traditionalMergeScreen_descriptionOne_label" byPoints:16];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_traditionalMergeScreen_password_label"];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_password_label" hasText:LOCALIZE(@"USR_DLS_Password_lbltxt")];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_password_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_password_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_password_label" isBelowElementWithId:@"usr_traditionalMergeScreen_descriptionTwo_label" byPoints:24];
    
    [ValidationHelper assertThatElementWithIdIsSufficientlyVisible:@"usr_traditionalMergeScreen_password_textField"];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_password_textField" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_password_textField" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_password_textField" isBelowElementWithId:@"usr_traditionalMergeScreen_password_label" byPoints:4];
    
    [ValidationHelper assertThatElementWithIdIsPartiallyVisible:@"usr_traditionalMergeScreen_merge_button"];
    [ValidationHelper assertThatButtonWithId:@"usr_traditionalMergeScreen_merge_button" hasTitle:LOCALIZE(@"USR_Account_Merge_Merge_btntxt") andWidth:0];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_merge_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_merge_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_merge_button" isBelowElementWithId:@"usr_traditionalMergeScreen_password_textField" byPoints:24];
    [ValidationHelper assertThatElementWithIdIsNotEnabled:@"usr_traditionalMergeScreen_merge_button"];
    
    [ValidationHelper assertThatElementWithIdIsPartiallyVisible:@"usr_traditionalMergeScreen_forgotPassword_button"];
    [ValidationHelper assertThatButtonWithId:@"usr_traditionalMergeScreen_forgotPassword_button" hasTitle:LOCALIZE(@"USR_DLS_Traditional_Merge_ForgotPassword") andWidth:0];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_forgotPassword_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_forgotPassword_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_traditionalMergeScreen_forgotPassword_button" isBelowElementWithId:@"usr_traditionalMergeScreen_merge_button" byPoints:10];
    [ValidationHelper assertThatElementWithIdIsEnabled:@"usr_traditionalMergeScreen_forgotPassword_button"];
    
}


+ (void)verifyAddRecoveryEmailScreenLayout {
    [ValidationHelper assertThatCurrentScreenHasTitle:LOCALIZE(@"USR_DLS_URCreateAccount_NavTitle")];
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_addRecoveryEmailScreen_title_label"];
    [ValidationHelper assertThatElementWithId:@"usr_addRecoveryEmailScreen_title_label" hasText:LOCALIZE(@"USR_DLS_AddRecovery_Title_Text")];
    [ValidationHelper assertThatElementWithId:@"usr_addRecoveryEmailScreen_title_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_addRecoveryEmailScreen_title_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_addRecoveryEmailScreen_title_label" hasMarginOf:kVerticalMargin inDirection:kGREYLayoutDirectionUp];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_addRecoveryEmailScreen_description_label"];
    [ValidationHelper assertThatElementWithId:@"usr_addRecoveryEmailScreen_description_label" hasText:LOCALIZE(@"USR_DLS_AddRecovery_Description_Text")];
    [ValidationHelper assertThatElementWithId:@"usr_addRecoveryEmailScreen_description_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_addRecoveryEmailScreen_description_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_addRecoveryEmailScreen_description_label" isBelowElementWithId:@"usr_addRecoveryEmailScreen_title_label" byPoints:16];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_addRecoveryEmailScreen_emailHint_label"];
    [ValidationHelper assertThatElementWithId:@"usr_addRecoveryEmailScreen_emailHint_label" hasText:LOCALIZE(@"USR_DLS_AddRecovery_EnterEmail_Text")];
    [ValidationHelper assertThatElementWithId:@"usr_addRecoveryEmailScreen_emailHint_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_addRecoveryEmailScreen_emailHint_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_addRecoveryEmailScreen_emailHint_label" isBelowElementWithId:@"usr_addRecoveryEmailScreen_description_label" byPoints:16];
    
    [ValidationHelper assertThatElementWithIdIsSufficientlyVisible:@"usr_addRecoveryEmailScreen_recoveryEmail_textField"];
    [ValidationHelper assertThatElementWithId:@"usr_addRecoveryEmailScreen_recoveryEmail_textField" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_addRecoveryEmailScreen_recoveryEmail_textField" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_addRecoveryEmailScreen_recoveryEmail_textField" isBelowElementWithId:@"usr_addRecoveryEmailScreen_emailHint_label" byPoints:8];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_addRecoveryEmailScreen_addRecoveryEmail_button"];
    [ValidationHelper assertThatButtonWithId:@"usr_addRecoveryEmailScreen_addRecoveryEmail_button" hasTitle:LOCALIZE(@"USR_DLS_AddRecovery_AddRecovery_Button_Title") andWidth:0];
    [ValidationHelper assertThatElementWithId:@"usr_addRecoveryEmailScreen_addRecoveryEmail_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_addRecoveryEmailScreen_addRecoveryEmail_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_addRecoveryEmailScreen_addRecoveryEmail_button" isBelowElementWithId:@"usr_addRecoveryEmailScreen_recoveryEmail_textField" byPoints:24];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_addRecoveryEmailScreen_maybeLater_button"];
    [ValidationHelper assertThatButtonWithId:@"usr_addRecoveryEmailScreen_maybeLater_button" hasTitle:LOCALIZE(@"USR_DLS_AddRecovery_MaybeLater_Button_Title") andWidth:0];
    [ValidationHelper assertThatElementWithId:@"usr_addRecoveryEmailScreen_maybeLater_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_addRecoveryEmailScreen_maybeLater_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_addRecoveryEmailScreen_maybeLater_button" isBelowElementWithId:@"usr_addRecoveryEmailScreen_addRecoveryEmail_button" byPoints:8];
}


+ (void)verifySMSVerificationScreenLayoutForActivation {
    //Type dummy but valid text and dismiss keyboard and then test the layout.
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_smsVerificationScreen_smsCode_textField")] performAction:grey_typeText(@"123456")];
    [EarlGrey dismissKeyboardWithError:nil];
    
    [ValidationHelper assertThatCurrentScreenHasTitle:LOCALIZE(@"USR_DLS_URCreateAccount_NavTitle")];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_smsVerificationScreen_title_label"];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_title_label" hasText:LOCALIZE(@"USR_DLS_VerifySMS_Title_Text")];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_title_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_title_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_title_label" hasMarginOf:kVerticalMargin inDirection:kGREYLayoutDirectionUp];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_smsVerificationScreen_description_label"];
    NSString *descriptionString = [NSString stringWithFormat:LOCALIZE(@"USR_DLS_VerifySMS_Description_Text"),[DIUser getInstance].mobileNumber];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_description_label" hasText:descriptionString];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_description_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_description_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_description_label" isBelowElementWithId:@"usr_smsVerificationScreen_title_label" byPoints:16];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_smsVerificationScreen_enterCode_label"];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_enterCode_label" hasText:LOCALIZE(@"USR_DLS_VerifySMS_EnterCode_Text")];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_enterCode_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_enterCode_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_enterCode_label" isBelowElementWithId:@"usr_smsVerificationScreen_description_label" byPoints:16];
    
    [ValidationHelper assertThatElementWithIdIsSufficientlyVisible:@"usr_smsVerificationScreen_smsCode_textField"];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_smsCode_textField" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_smsCode_textField" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_smsCode_textField" isBelowElementWithId:@"usr_smsVerificationScreen_enterCode_label" byPoints:20];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_smsVerificationScreen_verifyCode_button"];
    [ValidationHelper assertThatButtonWithId:@"usr_smsVerificationScreen_verifyCode_button" hasTitle:LOCALIZE(@"USR_DLS_VerifySMS_VerifyCode_Button_Title") andWidth:0];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_verifyCode_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_verifyCode_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_verifyCode_button" isBelowElementWithId:@"usr_smsVerificationScreen_smsCode_textField" byPoints:24];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_smsVerificationScreen_iDidNotReceive_button"];
    [ValidationHelper assertThatButtonWithId:@"usr_smsVerificationScreen_iDidNotReceive_button" hasTitle:LOCALIZE(@"USR_DLS_VerifySMS_DidNotReceieve_Button_Title") andWidth:0];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_iDidNotReceive_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_iDidNotReceive_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_iDidNotReceive_button" isBelowElementWithId:@"usr_smsVerificationScreen_verifyCode_button" byPoints:8];
}


+ (void)verifySMSVerificationScreenLayoutForResetPassword:(NSString *)mobileNumber {
    //Type dummy but valid text and dismiss keyboard and then test the layout.
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_smsVerificationScreen_smsCode_textField")] performAction:grey_typeText(@"123456")];
    [EarlGrey dismissKeyboardWithError:nil];
    
    [ValidationHelper assertThatCurrentScreenHasTitle:LOCALIZE(@"USR_DLS_SigIn_TitleTxt")];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_smsVerificationScreen_title_label"];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_title_label" hasText:LOCALIZE(@"USR_DLS_VerifySMS_Title_Text")];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_title_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_title_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_title_label" hasMarginOf:kVerticalMargin inDirection:kGREYLayoutDirectionUp];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_smsVerificationScreen_description_label"];
    NSString *descriptionString = [NSString stringWithFormat:LOCALIZE(@"USR_DLS_VerifySMS_Description_Text"),mobileNumber];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_description_label" hasText:descriptionString];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_description_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_description_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_description_label" isBelowElementWithId:@"usr_smsVerificationScreen_title_label" byPoints:16];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_smsVerificationScreen_enterCode_label"];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_enterCode_label" hasText:LOCALIZE(@"USR_DLS_ResetAccount_EnterCode_Text")];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_enterCode_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_enterCode_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_enterCode_label" isBelowElementWithId:@"usr_smsVerificationScreen_description_label" byPoints:16];
    
    [ValidationHelper assertThatElementWithIdIsSufficientlyVisible:@"usr_smsVerificationScreen_smsCode_textField"];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_smsCode_textField" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_smsCode_textField" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_smsCode_textField" isBelowElementWithId:@"usr_smsVerificationScreen_enterCode_label" byPoints:20];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_smsVerificationScreen_verifyCode_button"];
    [ValidationHelper assertThatButtonWithId:@"usr_smsVerificationScreen_verifyCode_button" hasTitle:LOCALIZE(@"USR_DLS_VerifySMS_VerifyCode_Button_Title") andWidth:0];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_verifyCode_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_verifyCode_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_verifyCode_button" isBelowElementWithId:@"usr_smsVerificationScreen_smsCode_textField" byPoints:24];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_smsVerificationScreen_iDidNotReceive_button"];
    [ValidationHelper assertThatButtonWithId:@"usr_smsVerificationScreen_iDidNotReceive_button" hasTitle:LOCALIZE(@"USR_DLS_VerifySMS_DidNotReceieve_Button_Title") andWidth:0];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_iDidNotReceive_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_iDidNotReceive_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_smsVerificationScreen_iDidNotReceive_button" isBelowElementWithId:@"usr_smsVerificationScreen_verifyCode_button" byPoints:8];
}


+ (void)verifyResendSmsScreenLayout:(NSString *)mobileNumber {
    [ValidationHelper assertThatCurrentScreenHasTitle:LOCALIZE(@"USR_Resend_SMS_title")];
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_resendSMSScreen_resendSMS_label"];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_resendSMS_label" hasText:LOCALIZE(@"USR_DLS_ResendSMS_title")];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_resendSMS_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_resendSMS_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_resendSMS_label" hasMarginOf:kVerticalMargin inDirection:kGREYLayoutDirectionUp];

    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_resendSMSScreen_line1_label"];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_line1_label" hasText:LOCALIZE(@"USR_DLS_ResendSMS_Body_Line1")];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_line1_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_line1_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_line1_label" isBelowElementWithId:@"usr_resendSMSScreen_resendSMS_label" byPoints:16];

    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_resendSMSScreen_line2_label"];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_line2_label" hasText:LOCALIZE(@"USR_DLS_ResendSMS_Body_Line2")];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_line2_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_line2_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_line2_label" isBelowElementWithId:@"usr_resendSMSScreen_line1_label" byPoints:12];

    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_resendSMSScreen_phone_label"];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_phone_label" hasText:LOCALIZE(@"USR_DLS_Phonenumber_Label_Text")];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_phone_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_phone_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_phone_label" isBelowElementWithId:@"usr_resendSMSScreen_line2_label" byPoints:12];

    [ValidationHelper assertThatElementWithIdIsPartiallyVisible:@"usr_resendSMSScreen_phone_field"];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_phone_field" hasText:mobileNumber];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_phone_field" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_phone_field" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_phone_field" isBelowElementWithId:@"usr_resendSMSScreen_phone_label" byPoints:8];

    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_resendSMSscreen_time_progressbar"];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSscreen_time_progressbar" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSscreen_time_progressbar" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSscreen_time_progressbar" isBelowElementWithId:@"usr_resendSMSScreen_phone_field" byPoints:8];

    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_resendSMSscreen_password_progress_view_title_label"];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSscreen_password_progress_view_title_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSscreen_password_progress_view_title_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSscreen_password_progress_view_title_label" isBelowElementWithId:@"usr_resendSMSscreen_time_progressbar" byPoints:8];
    
    if (![ValidationHelper isElementWithIdSufficientlyVisible:@"usr_resendSMSScreen_resendSMS_button"]) {
        [ValidationHelper scrollToElementWithId:@"usr_resendSMSScreen_resendSMS_button" inDirection:kGREYDirectionDown];
    }
    [ValidationHelper assertThatElementWithIdIsPartiallyVisible:@"usr_resendSMSScreen_resendSMS_button"];
    [ValidationHelper assertThatButtonWithId:@"usr_resendSMSScreen_resendSMS_button" hasTitle:LOCALIZE(@"USR_Resend_SMS_title") andWidth:0];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_resendSMS_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_resendSMS_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_resendSMS_button" isBelowElementWithId:@"usr_resendSMSscreen_password_progress_view_title_label" byPoints:24];
    [ValidationHelper assertThatElementWithIdIsNotEnabled:@"usr_resendSMSScreen_resendSMS_button"];

    if (![ValidationHelper isElementWithIdSufficientlyVisible:@"usr_resendSMSScreen_thanks_button"]) {
        [ValidationHelper scrollToElementWithId:@"usr_resendSMSScreen_thanks_button" inDirection:kGREYDirectionDown];
    }
    [ValidationHelper assertThatElementWithIdIsSufficientlyVisible:@"usr_resendSMSScreen_thanks_button"];
    [ValidationHelper assertThatButtonWithId:@"usr_resendSMSScreen_thanks_button" hasTitle:LOCALIZE(@"USR_Update_MobileNumber_Thanks_Got_It") andWidth:0];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_thanks_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_thanks_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_resendSMSScreen_thanks_button" isBelowElementWithId:@"usr_resendSMSScreen_resendSMS_button" byPoints:8];
    [ValidationHelper assertThatElementWithIdIsEnabled:@"usr_resendSMSScreen_thanks_button"];
}


+ (void)verifyAlmostDoneScreenLayout {
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_almostDoneScreen_title_label"];
    [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_title_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_title_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_title_label" hasMarginOf:kVerticalMargin inDirection:kGREYLayoutDirectionUp];
    [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_title_label" hasText:LOCALIZE(@"USR_Social_SignIn_AlmostDone_lbltxt")];
    
    if (!([DIUser getInstance].receiveMarketingEmails)) {
        [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_almostDoneScreen_detail_label"];
        [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_detail_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
        [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_detail_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
        [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_detail_label" isBelowElementWithId:@"usr_almostDoneScreen_title_label" byPoints:16];
        [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_detail_label" hasText:LOCALIZE(@"USR_DLS_Almost_Done_Marketing_OptIn_Text")];
        
        [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_almostDoneScreen_marketingMails_checkBox"];
        [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_marketingMails_checkBox" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
        [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_marketingMails_checkBox" isBelowElementWithId:@"usr_almostDoneScreen_detail_label" byPoints:16];
        
        [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_almostDoneScreen_marketingMails_textView"];
        [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_marketingMails_textView" isOnRightOfElementWithId:@"usr_almostDoneScreen_marketingMails_checkBox" byPoints:12];
        [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_marketingMails_textView" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
        [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_marketingMails_textView" isBelowElementWithId:@"usr_almostDoneScreen_detail_label" byPoints:16];
        NSString *marketingText = [NSString stringWithFormat: @"%@\n%@   ",LOCALIZE(@"USR_DLS_OptIn_Promotional_Message_Line1"),LOCALIZE(@"USR_Receive_Philips_News_Meaning_lbltxt")];
        [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_marketingMails_textView" hasText:marketingText];
    }
    if (![RegistrationUtility hasUserAcceptedTermsnConditions:[DIUser getInstance].userIdentifier]) {
        [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_almostDoneScreen_termsAndConditions_checkBox"];
        [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_termsAndConditions_checkBox" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
        
        [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_almostDoneScreen_termsAndConditions_textView"];
        [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_termsAndConditions_textView" isOnRightOfElementWithId:@"usr_almostDoneScreen_termsAndConditions_checkBox" byPoints:12];
        [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_termsAndConditions_textView" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
        NSString * termsAndConditionsString = [NSString stringWithFormat:LOCALIZE(@"USR_DLS_TermsAndConditionsAcceptanceText"),LOCALIZE(@"USR_DLS_TermsAndConditionsText")];
        [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_termsAndConditions_textView" hasText:termsAndConditionsString];
        
        if (!([DIUser getInstance].receiveMarketingEmails)) {
            [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_termsAndConditions_checkBox" isBelowElementWithId:@"usr_almostDoneScreen_marketingMails_textView" byPoints:24];
            [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_termsAndConditions_textView" isBelowElementWithId:@"usr_almostDoneScreen_marketingMails_textView" byPoints:24];
        } else {
            [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_termsAndConditions_checkBox" isBelowElementWithId:@"usr_almostDoneScreen_title_label" byPoints:16];
            [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_termsAndConditions_textView" isBelowElementWithId:@"usr_almostDoneScreen_title_label" byPoints:16];
        }
    }
    if (![ValidationHelper isElementWithIdCompletelyVisible:@"usr_almostDoneScreen_continue_button"]) {
        [ValidationHelper scrollToElementWithId:@"usr_almostDoneScreen_continue_button" inDirection:kGREYDirectionDown];
    }
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_almostDoneScreen_continue_button"];
    [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_continue_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_continue_button" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    if (![RegistrationUtility hasUserAcceptedTermsnConditions:[DIUser getInstance].userIdentifier]) {
        [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_continue_button" isBelowElementWithId:@"usr_almostDoneScreen_termsAndConditions_textView" byPoints:24];
    } else {
        [ValidationHelper assertThatElementWithId:@"usr_almostDoneScreen_continue_button" isBelowElementWithId:@"usr_almostDoneScreen_marketingMails_textView" byPoints:24];
    }
}


+ (void)verifyCountrySelectionScreenLayout {
    [ValidationHelper assertThatCurrentScreenHasTitle:LOCALIZE(@"USR_DLS_Country_Selection_Nav_Title_Text")];
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_countrySelectionScreen_explanatory_label"];
    [ValidationHelper assertThatElementWithId:@"usr_countrySelectionScreen_explanatory_label" hasText:LOCALIZE(@"USR_DLS_Country_Selection_Explainary_Text")];
    [ValidationHelper assertThatElementWithId:@"usr_countrySelectionScreen_explanatory_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_countrySelectionScreen_explanatory_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_countrySelectionScreen_explanatory_label" hasMarginOf:16 inDirection:kGREYLayoutDirectionUp]; //This is an exception to top margin
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_startscreen_countryList_tableView"];
    [ValidationHelper assertThatElementWithId:@"usr_startscreen_countryList_tableView" hasMarginOf:0 inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_startscreen_countryList_tableView" hasMarginOf:0 inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_startscreen_countryList_tableView" hasMarginOf:0 inDirection:kGREYLayoutDirectionUp]; //This is an exception to top margin
    [ValidationHelper assertThatElementWithId:@"usr_startscreen_countryList_tableView" hasMarginOf:0 inDirection:kGREYLayoutDirectionDown]; //This is an exception to bottom margin
}


+ (void)verifyPhilipsNewsScreenLayout {
    [ValidationHelper assertThatCurrentScreenHasTitle:LOCALIZE(@"USR_DLS_PhilipsNews_NavigationBar_Title")];
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_philipsNewsScreen_title_label"];
    [ValidationHelper assertThatElementWithId:@"usr_philipsNewsScreen_title_label" hasText:LOCALIZE(@"USR_DLS_OptIn_What_does_This_Mean_Txt")];
    [ValidationHelper assertThatElementWithId:@"usr_philipsNewsScreen_title_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_philipsNewsScreen_title_label" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_philipsNewsScreen_title_label" hasMarginOf:kVerticalMargin inDirection:kGREYLayoutDirectionUp];
    
    NSString *descriptionText = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@",LOCALIZE(@"DLS_PhilipsNews_Description_Text_One"),LOCALIZE(@"DLS_PhilipsNews_Description_Text_Two"),LOCALIZE(@"DLS_PhilipsNews_Description_Text_Three"),LOCALIZE(@"DLS_PhilipsNews_Description_Text_Four")];
    
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_philipsNewsScreen_explanatoryText_textView"];
    [ValidationHelper assertThatElementWithId:@"usr_philipsNewsScreen_explanatoryText_textView" hasText:descriptionText];
    [ValidationHelper assertThatElementWithId:@"usr_philipsNewsScreen_explanatoryText_textView" hasMarginOf:0 inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_philipsNewsScreen_explanatoryText_textView" hasMarginOf:0 inDirection:kGREYLayoutDirectionRight];
    [ValidationHelper assertThatElementWithId:@"usr_philipsNewsScreen_explanatoryText_textView" isBelowElementWithId:@"usr_philipsNewsScreen_title_label" byPoints:16];
}


+ (void)verifyMyDetailsScreenLayout {
    DIUser *user = [DIUser getInstance];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    
    [ValidationHelper assertThatCurrentScreenHasTitle:LOCALIZE(@"USR_MyDetails_TitleTxt")];

    if(user.email != nil) {
        [ValidationHelper assertThatElementWithId:@"usr_myDetailsScreen_title_label_00" hasText:LOCALIZE(@"USR_Email_address_TitleTxt")];
        [ValidationHelper assertThatElementWithId:@"usr_myDetailsScreen_content_label_00" hasText: user.email];
    }
    
    if(user.mobileNumber != nil) {
        [ValidationHelper assertThatElementWithId:@"usr_myDetailsScreen_title_label_01" hasText:LOCALIZE(@"USR_Mobile_number_TitleTxt")];
        [ValidationHelper assertThatElementWithId:@"usr_myDetailsScreen_content_label_01" hasText: user.mobileNumber];
    }
    
    if(user.givenName != nil || user.familyName != nil) {
        [ValidationHelper assertThatElementWithId:@"usr_myDetailsScreen_title_label_10" hasText:LOCALIZE(@"USR_Name_TitleTxt")];
        
        if(user.givenName && user.familyName == nil) {
            [ValidationHelper assertThatElementWithId:@"usr_myDetailsScreen_content_label_10" hasText: user.givenName];
        } else if (user.familyName && user.givenName == nil) {
            [ValidationHelper assertThatElementWithId:@"usr_myDetailsScreen_content_label_10" hasText: user.familyName];
        } else {
            [ValidationHelper assertThatElementWithId:@"usr_myDetailsScreen_content_label_10" hasText: [NSString stringWithFormat:@"%@%@%@", user.givenName, @" ", user.familyName]];
        }
    }
    
    if(user.gender != UserGenderNone) {
        [ValidationHelper assertThatElementWithId:@"usr_myDetailsScreen_title_label_11" hasText:LOCALIZE(@"USR_Gender_TitleTxt")];
        
        if(user.gender == UserGenderMale) {
            [ValidationHelper assertThatElementWithId:@"usr_myDetailsScreen_content_label_11" hasText: @"Male"];
        } else {
            [ValidationHelper assertThatElementWithId:@"usr_myDetailsScreen_content_label_11" hasText: @"Female"];
        }
    }
    
    if(user.birthday != nil) {
        [ValidationHelper assertThatElementWithId:@"usr_myDetailsScreen_title_label_12" hasText:LOCALIZE(@"USR_DateOfBirth_TitleTxt")];
        [ValidationHelper assertThatElementWithId:@"usr_myDetailsScreen_content_label_12" hasText: [dateFormatter stringFromDate:user.birthday]];
    }
    
#warning Code to check section header titles needs to be added here.
}

+ (void)verifyUserOptinScreen {
    [ValidationHelper assertThatCurrentScreenHasTitle:LOCALIZE(@"USR_DLS_OptIn_Navigation_Bar_Title")];
    [ValidationHelper assertThatElementWithId:@"usr_optinScreen_whatItMeans_label" hasText:LOCALIZE(@"USR_DLS_OptIn_What_does_This_Mean_Txt")];
    [ValidationHelper assertThatElementWithId:@"usr_optinScreen_promotionalMsg_label" hasText:LOCALIZE(@"USR_DLS_OptIn_Promotional_Message_Line1")];
    [ValidationHelper assertThatElementWithId:@"usr_optinScreen_specialOffers_label" hasText:LOCALIZE(@"USR_DLS_Optin_Body_Line1")];
    [ValidationHelper assertThatElementWithId:@"usr_optinScreen_join_label" hasText:LOCALIZE(@"USR_DLS_Optin_Body_Line2")];
    [ValidationHelper buttonWithId:@"usr_optinScreen_countMeIn_Button" hasTitle:LOCALIZE(@"USR_DLS_OptIn_Button1_Title")];
    [ValidationHelper buttonWithId:@"usr_optinScreen_mayBeLater_button" hasTitle:LOCALIZE(@"USR_DLS_OptIn_Button2_Title")];
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_optinScreen_optIn_Image"];
}
@end
