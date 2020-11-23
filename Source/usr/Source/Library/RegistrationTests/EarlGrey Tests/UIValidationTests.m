//
//  UIValidationTests.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 18/07/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URSettingsWrapper.h"
#import <XCTest/XCTest.h>
#import <EarlGrey/EarlGrey.h>
#import "RegistrationUtility.h"
#import "RegistrationUIConstants.h"
#import "ValidationHelper.h"
#import "NetworkHelper.h"
#import "UILayoutVerificationHelper.h"
#import "DIUser+DataInterface.h"

#define kHorizontalMargin [ValidationHelper horizontalMarginForCurrentSizeClass]
#define kVerticalMargin   [ValidationHelper verticalMarginForCurrentSizeClass]

@interface AAValidationTests : XCTestCase

@end

@implementation AAValidationTests

- (void)setUp {
    [super setUp];
    [[GREYConfiguration sharedInstance] setValue:@(180.0)
                                    forConfigKey:kGREYConfigKeyInteractionTimeoutDuration];
}

- (void)selectCountry:(NSString *)countryToSelect {
    NSString *countryButtonTitle = [NSString stringWithFormat:@"%@: %@",LOCALIZE(@"USR_Country_Region"),LOCALIZE(countryToSelect)];
    NSError *visibilityError;
    [[EarlGrey selectElementWithMatcher:grey_text(countryButtonTitle)] assertWithMatcher:grey_sufficientlyVisible() error:&visibilityError];
    if (visibilityError) {
        NSString *currnetCountryKey = [NSString stringWithFormat:@"USR_Country_%@", [URSettingsWrapper sharedInstance].countryCode];
        NSString *currentCountry = LOCALIZE(currnetCountryKey);
        NSString *currentCountryTitle = [NSString stringWithFormat:@"%@: %@",LOCALIZE(@"USR_Country_Region"),currentCountry];
        GREYActionBlock *action = [GREYActionBlock actionWithName:@"something" performBlock:^BOOL(id element, NSError *__strong *errorOrNil) {
            CGFloat x = [(UILabel *)element frame].size.width - 100;
            if ([(UILabel *)element textAlignment] == NSTextAlignmentCenter) {
                x = [(UILabel *)element frame].size.width / 2;
            }
            CGFloat y = [(UILabel *)element frame].size.height / 2;
            [[EarlGrey selectElementWithMatcher:grey_accessibilityLabel(currentCountryTitle)] performAction:grey_tapAtPoint(CGPointMake(x, y))];
            return YES;
        }];
        [[EarlGrey selectElementWithMatcher:grey_accessibilityLabel(currentCountryTitle)] performAction:action];
        [UILayoutVerificationHelper verifyCountrySelectionScreenLayout];
        [EarlGrey rotateDeviceToOrientation:UIDeviceOrientationLandscapeRight errorOrNil:nil];
        [UILayoutVerificationHelper verifyCountrySelectionScreenLayout];
        [[[EarlGrey selectElementWithMatcher:grey_allOf(grey_accessibilityLabel(LOCALIZE(countryToSelect)), grey_sufficientlyVisible(), nil)] usingSearchAction:grey_scrollInDirection(kGREYDirectionDown, 150) onElementWithMatcher:grey_kindOfClass([UITableView class])] assertWithMatcher:grey_sufficientlyVisible()];
        [[EarlGrey selectElementWithMatcher:grey_kindOfClass([UITableView class])] performAction:grey_scrollToContentEdge(kGREYContentEdgeTop)];
        [EarlGrey rotateDeviceToOrientation:UIDeviceOrientationPortrait errorOrNil:nil];
        [[[[EarlGrey selectElementWithMatcher:grey_allOf(grey_accessibilityLabel(LOCALIZE(countryToSelect)), grey_sufficientlyVisible(), nil)] usingSearchAction:grey_scrollInDirection(kGREYDirectionDown, 120) onElementWithMatcher:grey_kindOfClass([UITableView class])] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_tap()];
    }
}


- (void)logoutUser {
    [[[EarlGrey selectElementWithMatcher:grey_buttonTitle(LOCALIZE(@"USR_SignOut_btntxt"))] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_tap()];
    [ValidationHelper assertThatDLSAlertIsDisplayedWithTitle:@"Logout Success" message:@"You are logged out successfully" andActionTitles:@[@"OK"]];
    [ValidationHelper tapDLSAlertActionWithTitle:@"OK"];
    [ValidationHelper waitForElementWithName:@"some button" elementMatcher:grey_accessibilityLabel(@"dummy button") timeout:1.0];
}


- (void)createAccountContentValidation {
#warning Write password hint view validations
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_firstname_textfield")] performAction:grey_typeText(@"phi")];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_firstname_textfield")] performAction:grey_clearText()];
    [EarlGrey dismissKeyboardWithError:nil];
    [ValidationHelper assertThatTextFieldWithId:@"usr_createscreen_firstname_textfield" hasErrorMessageDisplayed:LOCALIZE(@"USR_NameField_ErrorText")];
    [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_firstname_textfield")] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_typeText(@"philips")];
    
    if ([URSettingsWrapper sharedInstance].launchInput.registrationFlowConfiguration.enableLastName) {
        if (![ValidationHelper isElementWithIdSufficientlyVisible:@"usr_createscreen_lastname_textfield"]) {
            [ValidationHelper scrollToElementWithId:@"usr_createscreen_lastname_textfield" inDirection:kGREYDirectionDown];
        }
        [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_lastname_textfield")] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_typeText(@"regi")];
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_lastname_textfield")] performAction:grey_clearText()];
        [EarlGrey dismissKeyboardWithError:nil];
        [ValidationHelper assertThatTextFieldWithId:@"usr_createscreen_lastname_textfield" hasErrorMessageDisplayed:LOCALIZE(@"USR_LastNameField_ErrorMsg")];
        [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_lastname_textfield")] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_typeText(@"registration")];
    } else {
        [ValidationHelper assertThatElementWithIdIsInvisible:@"usr_createscreen_lastname_textfield"];
    }
    [ValidationHelper assertThatTextFieldWithIdHasNoErrorMessageDisplayed:@"usr_createscreen_lastname_textfield"];
    
    [ValidationHelper assertThatElementWithIdIsNotEnabled:@"usr_createscreen_create_button"];
    
    if (![ValidationHelper isElementWithIdSufficientlyVisible:@"usr_createscreen_emailormobile_textfield"]) {
        [ValidationHelper scrollToElementWithId:@"usr_createscreen_emailormobile_textfield" inDirection:kGREYDirectionDown];
    }
    if ([URSettingsWrapper sharedInstance].loginFlowType == RegistrationLoginFlowTypeEmail) {
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_emailormobile_textfield")] performAction:grey_typeText(@"v56")];
        [EarlGrey dismissKeyboardWithError:nil];
        [ValidationHelper assertThatTextFieldWithId:@"usr_createscreen_emailormobile_textfield" hasErrorMessageDisplayed:LOCALIZE(@"USR_InvalidOrMissingEmail_ErrorMsg")];
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_emailormobile_textfield")] performAction:grey_clearText()];
        [ValidationHelper assertThatTextFieldWithId:@"usr_createscreen_emailormobile_textfield" hasErrorMessageDisplayed:LOCALIZE(@"USR_InvalidOrMissingEmail_ErrorMsg")];
        
        [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_emailormobile_textfield")] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_typeText(@"sai.pasumarthy@philips.com")];
    } else {
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_emailormobile_textfield")] performAction:grey_typeText(@"86")];
        [EarlGrey dismissKeyboardWithError:nil];
        [ValidationHelper assertThatTextFieldWithId:@"usr_createscreen_emailormobile_textfield" hasErrorMessageDisplayed:LOCALIZE(@"USR_InvalidPhoneNumber_ErrorMsg")];
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_emailormobile_textfield")] performAction:grey_clearText()];
        [ValidationHelper assertThatTextFieldWithId:@"usr_createscreen_emailormobile_textfield" hasErrorMessageDisplayed:LOCALIZE(@"USR_EmptyField_ErrorMsg")];
        
        [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_emailormobile_textfield")] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_typeText(@"8613717320312")];
    }
    [ValidationHelper assertThatTextFieldWithIdHasNoErrorMessageDisplayed:@"usr_createscreen_emailormobile_textfield"];
    
    [ValidationHelper assertThatElementWithIdIsNotEnabled:@"usr_createscreen_create_button"];
    
    [ValidationHelper scrollToElementWithId:@"usr_createscreen_password_textfield" inDirection:kGREYDirectionDown andPerformAction:grey_typeText(@"philips123")];
    NSError *keyboardDismissingError;
    __unused BOOL dismissResult = [EarlGrey dismissKeyboardWithError:&keyboardDismissingError];
    [ValidationHelper scrollToElementWithId:@"usr_createscreen_create_button" inDirection:kGREYDirectionDown];
}


- (void)verifyCreateAccountCommonFlow {
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_firstname_textfield")] assertWithMatcher:grey_firstResponder()];
    
    [EarlGrey rotateDeviceToOrientation:UIDeviceOrientationLandscapeRight errorOrNil:nil];
    [UILayoutVerificationHelper verifyCreateAccountScreenLayout];
    [EarlGrey rotateDeviceToOrientation:UIDeviceOrientationPortrait errorOrNil:nil];
    [UILayoutVerificationHelper verifyCreateAccountScreenLayout];
    
    [EarlGrey rotateDeviceToOrientation:UIDeviceOrientationLandscapeRight errorOrNil:nil];
    [self createAccountContentValidation];
    [EarlGrey rotateDeviceToOrientation:UIDeviceOrientationPortrait errorOrNil:nil];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_firstname_textfield")] performAction:grey_replaceText(@"")];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_lastname_textfield")] performAction:grey_replaceText(@"")];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_emailormobile_textfield")] performAction:grey_replaceText(@"")];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_password_textfield")] performAction:grey_replaceText(@"")];
    [self createAccountContentValidation];
    
    if (![ValidationHelper isScrollViewContainingElement:@"usr_createscreen_create_button" scrolledToEdge:kGREYContentEdgeBottom]) {
        [ValidationHelper scrollToElementWithId:@"usr_createscreen_create_button" inDirection:kGREYDirectionDown];
    }
    
    if ([ValidationHelper isElementWithIdSufficientlyVisible:@"usr_createscreen_marketingmails_checkbox"]) {
        [ValidationHelper assertThatElementWithId:@"usr_createscreen_marketingmails_checkbox" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
        [ValidationHelper assertThatElementWithId:@"usr_createscreen_marketingmails_checkbox" isBelowElementWithId:@"usr_createscreen_passwordhint_view" byPoints:24];
        
        [ValidationHelper assertThatElementWithId:@"usr_createscreen_marketingmails_textview" isBelowElementWithId:@"usr_createscreen_passwordhint_view" byPoints:24];
        [ValidationHelper assertThatElementWithId:@"usr_createscreen_marketingmails_textview" isOnRightOfElementWithId:@"usr_createscreen_marketingmails_checkbox" byPoints:12];
        [ValidationHelper assertThatElementWithId:@"usr_createscreen_marketingmails_textview" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
        
        NSString *marketingOptInString = [NSString stringWithFormat: @"%@\n%@   ",LOCALIZE(@"USR_DLS_OptIn_Promotional_Message_Line1"),LOCALIZE(@"USR_Receive_Philips_News_Meaning_lbltxt")];
        [ValidationHelper assertThatElementWithId:@"usr_createscreen_marketingmails_textview" hasText:marketingOptInString];
        
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_marketingmails_checkbox")] performAction:grey_tap()];
    }
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_termsandconditions_checkbox" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionLeft];
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_termsandconditions_checkbox" isBelowElementWithId:@"usr_createscreen_marketingmails_textview" byPoints:24];
    
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_termsandconditions_textview" isBelowElementWithId:@"usr_createscreen_marketingmails_textview" byPoints:24];
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_termsandconditions_textview" isOnRightOfElementWithId:@"usr_createscreen_termsandconditions_checkbox" byPoints:12];
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_termsandconditions_textview" hasMarginOf:kHorizontalMargin inDirection:kGREYLayoutDirectionRight];
    NSString *termsAndConditionsString = [NSString stringWithFormat:LOCALIZE(@"USR_DLS_TermsAndConditionsAcceptanceText"),LOCALIZE(@"USR_DLS_TermsAndConditionsText")];
    [ValidationHelper assertThatElementWithId:@"usr_createscreen_termsandconditions_textview" hasText:termsAndConditionsString];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_termsandconditions_checkbox")] performAction:grey_tap()];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_termsandconditions_checkbox")] performAction:grey_tap()];
    [ValidationHelper assertThatElementWithIdIsSufficientlyVisible:@"usr_createscreen_termsandconditionsalert_view"];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_termsandconditions_checkbox")] performAction:grey_tap()];
    [ValidationHelper assertThatElementWithIdIsInvisible:@"usr_createscreen_termsandconditionsalert_view"];
    
    if (![ValidationHelper isElementWithIdCompletelyVisible:@"usr_createscreen_create_button"]) {
        [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_create_button")] usingSearchAction:grey_scrollInDirection(kGREYDirectionDown, 20) onElementWithMatcher:grey_allOf(grey_kindOfClass([UIScrollView class]), grey_descendant(grey_accessibilityID(@"usr_createscreen_create_button")), nil)] performAction:grey_tap()];
    } else {
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_create_button")] performAction:grey_tap()];
    }
    if ([URSettingsWrapper sharedInstance].loginFlowType == RegistrationLoginFlowTypeMobile) {
        [ValidationHelper assertThatTextFieldWithId:@"usr_createscreen_emailormobile_textfield" hasErrorMessageDisplayed:[NSString stringWithFormat:LOCALIZE(@"USR_Janrain_EntityAlreadyExists_ErrorMsg"), LOCALIZE(@"USR_DLS_Phonenumber_Label_Text")]];
        [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_emailormobile_textfield")] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_replaceText(@"8613717320319")];
    } else {
        [ValidationHelper assertThatTextFieldWithId:@"usr_createscreen_emailormobile_textfield" hasErrorMessageDisplayed:[NSString stringWithFormat:LOCALIZE(@"USR_Janrain_EntityAlreadyExists_ErrorMsg"), LOCALIZE(@"USR_DLS_Email_Label_Text")]];
        NSString *emailString = [NSString stringWithFormat:@"philips_demo_app_%f@mailinator.com", [NSDate timeIntervalSinceReferenceDate]];
        [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_emailormobile_textfield")] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_replaceText(emailString)];
    }
    [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_password_textfield")] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_replaceText(@"philips123")];
    [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_createscreen_create_button")] usingSearchAction:grey_scrollInDirection(kGREYDirectionDown, 20) onElementWithMatcher:grey_kindOfClass([UIScrollView class])] performAction:grey_tap()];
    
    if ([URSettingsWrapper sharedInstance].loginFlowType == RegistrationLoginFlowTypeEmail) {
        //Verify screen layout check
        [EarlGrey rotateDeviceToOrientation:UIDeviceOrientationLandscapeRight errorOrNil:nil];
        [UILayoutVerificationHelper verifyEmailVerificationScreenLayout];
        [EarlGrey rotateDeviceToOrientation:UIDeviceOrientationPortrait errorOrNil:nil];
        [UILayoutVerificationHelper verifyEmailVerificationScreenLayout];
        
        //Verify resend email alert. Account yet not verified.
        [ValidationHelper tapButtonWithId:@"usr_verifyEmailScreen_emailVerified_button"];
        NSString *messageBody = [NSString stringWithFormat:@"%@\n\n%@", LOCALIZE(@"USR_DLS_Email_Verify_Alert_Body_Line1"), LOCALIZE(@"USR_DLS_Email_Verify_Alert_Body_Line2")];
        [ValidationHelper assertThatDLSAlertIsDisplayedWithTitle:LOCALIZE(@"USR_DLS_Email_Verify_Alert_Title") message:messageBody andActionTitles:@[LOCALIZE(@"USR_DLS_Button_Title_Ok")]];
        [ValidationHelper tapDLSAlertActionWithTitle:LOCALIZE(@"USR_DLS_Button_Title_Ok")];
        //Tap on not verified button
        [ValidationHelper tapButtonWithId:@"usr_verifyEmailScreen_havenotReceivedEmail_button"];
        
        //Resend email screen layout check
        [EarlGrey rotateDeviceToOrientation:UIDeviceOrientationLandscapeRight errorOrNil:nil];
        [UILayoutVerificationHelper verifyResendEmailScreenLayout];
        [EarlGrey rotateDeviceToOrientation:UIDeviceOrientationPortrait errorOrNil:nil];
        [UILayoutVerificationHelper verifyResendEmailScreenLayout];
        
        __block BOOL isVerificationComplete = NO;
        NSDictionary *userDetails = [[DIUser getInstance] userDetails:@[UserDetailConstants.UUID] error:nil];

        [NetworkHelper verifyUserWithUUID:userDetails[UserDetailConstants.UUID] withCompletion:^(NSError *error) {
            if (!error) {
                isVerificationComplete = YES;
            }
        }];
        //Email already verified
        /* [ValidationHelper tapButtonWithId:@"usr_resendEmailScreen_resendEmail_button"];
         //Tap on already verified alert button
         [ValidationHelper tapDLSAlertActionWithTitle:LOCALIZE(@"USR_DLS_Button_Title_Ok")]; */
        [ValidationHelper tapButtonWithId:@"usr_resendEmailScreen_thanks_button"];
        [ValidationHelper tapButtonWithId:@"usr_verifyEmailScreen_emailVerified_button"];
    } else {
        [UILayoutVerificationHelper verifySMSVerificationScreenLayoutForActivation];

        [ValidationHelper tapButtonWithId:@"usr_smsVerificationScreen_iDidNotReceive_button"];

        [EarlGrey rotateDeviceToOrientation:UIDeviceOrientationLandscapeRight errorOrNil:nil];
        [UILayoutVerificationHelper verifyResendSmsScreenLayout:[DIUser getInstance].mobileNumber];
        [EarlGrey rotateDeviceToOrientation:UIDeviceOrientationPortrait errorOrNil:nil];
        [UILayoutVerificationHelper verifyResendSmsScreenLayout:[DIUser getInstance].mobileNumber];

        [ValidationHelper assertThatElementWithIdIsNotEnabled:@"usr_resendSMSScreen_resendSMS_button"];
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_resendSMSScreen_phone_field")] performAction:grey_clearText()];
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_resendSMSScreen_phone_field")] performAction:grey_typeText(@"86")];
        [EarlGrey dismissKeyboardWithError:nil];
        [ValidationHelper assertThatTextFieldWithId:@"usr_resendSMSScreen_phone_field" hasErrorMessageDisplayed:LOCALIZE(@"USR_InvalidPhoneNumber_ErrorMsg")];
        [ValidationHelper assertThatElementWithIdIsNotEnabled:@"usr_resendSMSScreen_resendSMS_button"];
        //Update phone number
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_resendSMSScreen_phone_field")] performAction:grey_clearText()];
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_resendSMSScreen_phone_field")] performAction:grey_typeText(@"8613725353015")];
        [ValidationHelper assertThatElementWithIdIsEnabled:@"usr_resendSMSScreen_resendSMS_button"];
        if (![ValidationHelper isElementWithIdSufficientlyVisible:@"usr_resendSMSScreen_resendSMS_button"]) {
            [ValidationHelper scrollToElementWithId:@"usr_resendSMSScreen_resendSMS_button" inDirection:kGREYDirectionDown];
        }
        [ValidationHelper tapButtonWithId:@"usr_resendSMSScreen_resendSMS_button"];
        if ([ValidationHelper isDLSAlertForErrorIsDisplayed]) {
            [ValidationHelper tapDLSAlertActionWithTitle:LOCALIZE(@"USR_DLS_Button_Title_Ok")];
        }
        //Resend phone number
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_resendSMSScreen_phone_field")] performAction:grey_clearText()];
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_resendSMSScreen_phone_field")] performAction:grey_typeText(@"8613725353019")];
        
        if (![ValidationHelper isElementWithIdSufficientlyVisible:@"usr_resendSMSScreen_resendSMS_button"]) {
            [ValidationHelper scrollToElementWithId:@"usr_resendSMSScreen_resendSMS_button" inDirection:kGREYDirectionDown];
        }
        [ValidationHelper assertThatElementWithIdIsEnabled:@"usr_resendSMSScreen_resendSMS_button"];
        [ValidationHelper tapButtonWithId:@"usr_resendSMSScreen_resendSMS_button"];
        if ([ValidationHelper isDLSAlertForErrorIsDisplayed]) {
            [ValidationHelper tapDLSAlertActionWithTitle:LOCALIZE(@"USR_DLS_Button_Title_Ok")];
        }

        if (![ValidationHelper isElementWithIdSufficientlyVisible:@"usr_resendSMSScreen_thanks_button"]) {
            [ValidationHelper scrollToElementWithId:@"usr_resendSMSScreen_thanks_button" inDirection:kGREYDirectionDown];
        }
        [ValidationHelper tapButtonWithId:@"usr_resendSMSScreen_thanks_button"];

        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_smsVerificationScreen_smsCode_textField")] performAction:grey_typeText(@"456")];
        [ValidationHelper assertThatTextFieldWithId:@"usr_smsVerificationScreen_smsCode_textField" hasErrorMessageDisplayed:LOCALIZE(@"USR_VerificationCode_ErrorText")];
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_smsVerificationScreen_smsCode_textField")] performAction:grey_clearText()];
        [ValidationHelper assertThatTextFieldWithId:@"usr_smsVerificationScreen_smsCode_textField" hasErrorMessageDisplayed:LOCALIZE(@"USR_EmptyField_ErrorMsg")];
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_smsVerificationScreen_smsCode_textField")] performAction:grey_typeText(@"111111")];
        [ValidationHelper assertThatTextFieldWithIdHasNoErrorMessageDisplayed:@"usr_smsVerificationScreen_smsCode_textField"];
        
        [EarlGrey dismissKeyboardWithError:nil];
        [ValidationHelper tapButtonWithId:@"usr_smsVerificationScreen_verifyCode_button"];
        [ValidationHelper assertThatTextFieldWithId:@"usr_smsVerificationScreen_smsCode_textField" hasErrorMessageDisplayed:LOCALIZE(@"USR_VerificationCode_ErrorText")];
        __block NSString *accountVerificationCode;
        NSDictionary *userDetails = [[DIUser getInstance] userDetails:@[UserDetailConstants.UUID] error:nil];

        [NetworkHelper retrieveAccountVerificationCodeForUser:userDetails[UserDetailConstants.UUID] fromChinaStagingWithCompletion:^(NSString *code, NSError *error) {
            if (!error && code.length > 0) {
                accountVerificationCode = code;
            }
        }];
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_smsVerificationScreen_smsCode_textField")] performAction:grey_clearText()];
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_smsVerificationScreen_smsCode_textField")] performAction:grey_typeText(accountVerificationCode)];
        [EarlGrey dismissKeyboardWithError:nil];
        [ValidationHelper tapButtonWithId:@"usr_smsVerificationScreen_verifyCode_button"];
        [UILayoutVerificationHelper verifyAddRecoveryEmailScreenLayout];
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_addRecoveryEmailScreen_recoveryEmail_textField")] performAction:grey_typeText(@"v56")];
        [EarlGrey dismissKeyboardWithError:nil];
        [ValidationHelper assertThatTextFieldWithId:@"usr_addRecoveryEmailScreen_recoveryEmail_textField" hasErrorMessageDisplayed:LOCALIZE(@"USR_InvalidEmailAdddress_ErrorMsg")];
        NSString *emailString = [NSString stringWithFormat:@"philips_demo_app_%f@mailinator.com", [NSDate timeIntervalSinceReferenceDate]];
        [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_addRecoveryEmailScreen_recoveryEmail_textField")] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_replaceText(emailString)];
        [ValidationHelper tapButtonWithId:@"usr_addRecoveryEmailScreen_addRecoveryEmail_button"];
        [UILayoutVerificationHelper verifyEmailVerificationScreenLayout];
        __block BOOL isVerificationComplete = NO;
        NSDictionary *userDetail = [[DIUser getInstance] userDetails:@[UserDetailConstants.UUID] error:nil];

        [NetworkHelper verifyChinaUserWithUUID:userDetail[UserDetailConstants.UUID] withCompletion:^(NSError *error) {
            if (!error) {
                isVerificationComplete = YES;
            }
        }];
        [ValidationHelper tapButtonWithId:@"usr_verifyEmailScreen_emailVerified_button"];
    }
    NSDictionary *userDetails = [[DIUser getInstance] userDetails:@[UserDetailConstants.UUID] error:nil];

    NSString *userId = userDetails[UserDetailConstants.UUID];
    [ValidationHelper assertThatCurrentScreenHasTitle:@"Demo App"];

    [self logoutUser];
    
    if ([URSettingsWrapper sharedInstance].loginFlowType == RegistrationLoginFlowTypeMobile) {
        [NetworkHelper deleteChinaUser:userId fromChinaStagingWithCompletion:^(NSError *error) {
            if (error) {
                NSLog(@"Could not delete User: %@ Error: %@", userId, error);
            }
        }];
    }
}


- (void)testAA_0_CreateAccountTraditionalFlow {
    [UILayoutVerificationHelper verifyDemoAppAndLauchUApp];
    [UILayoutVerificationHelper verifyStartScreenLayout];
    [EarlGrey rotateDeviceToOrientation:UIDeviceOrientationLandscapeRight errorOrNil:nil];
    [UILayoutVerificationHelper verifyStartScreenLayout];
    [EarlGrey rotateDeviceToOrientation:UIDeviceOrientationPortrait errorOrNil:nil];
    [self selectCountry:@"USR_Country_IN"];
    
    [ValidationHelper tapButtonWithId:@"usr_startscreen_create_button"];
    [self verifyCreateAccountCommonFlow];
}


- (void)testAA_0_CreateAccountTraditionalFlow_Russia {
    [UILayoutVerificationHelper verifyDemoAppAndLauchUApp];
    [UILayoutVerificationHelper verifyStartScreenLayout];
    
    [self selectCountry:@"USR_Country_RU"];
    [ValidationHelper tapButtonWithId:@"usr_startscreen_create_button"];
    [self verifyCreateAccountCommonFlow];
}


- (void)loginScreenLocalContentValidation {
    if ([URSettingsWrapper sharedInstance].loginFlowType == RegistrationLoginFlowTypeEmail) {
        [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_email_textField")] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_typeText(@"v56@mailinato")];
        [EarlGrey dismissKeyboardWithError:nil];
        [ValidationHelper assertThatTextFieldWithId:@"usr_loginScreen_email_textField" hasErrorMessageDisplayed:LOCALIZE(@"USR_InvalidOrMissingEmail_ErrorMsg")];
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_email_textField")] performAction:grey_clearText()];
        [ValidationHelper assertThatTextFieldWithId:@"usr_loginScreen_email_textField" hasErrorMessageDisplayed:LOCALIZE(@"USR_InvalidOrMissingEmail_ErrorMsg")];
        [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_email_textField")] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_typeText(@"sai.pasumarthy@philips.com")];
        [ValidationHelper assertThatTextFieldWithIdHasNoErrorMessageDisplayed:@"usr_loginScreen_email_textField"];
    } else {
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_email_textField")] performAction:grey_typeText(@"86")];
        [EarlGrey dismissKeyboardWithError:nil];
        [ValidationHelper assertThatTextFieldWithId:@"usr_loginScreen_email_textField" hasErrorMessageDisplayed:LOCALIZE(@"USR_InvalidEmailOrPhoneNumber_ErrorMsg")];
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_email_textField")] performAction:grey_clearText()];
        [ValidationHelper assertThatTextFieldWithId:@"usr_loginScreen_email_textField" hasErrorMessageDisplayed:LOCALIZE(@"USR_InvalidEmailOrPhoneNumber_ErrorMsg")];
        [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_email_textField")] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_typeText(@"8613717320312")];
    }
    
    [ValidationHelper assertThatElementWithIdIsNotEnabled:@"usr_loginScreen_login_button"];
    
    //If password field is not visible due to keyboard in landscape
    if (![ValidationHelper isElementWithIdSufficientlyVisible:@"usr_loginScreen_password_textField"]) {
        [ValidationHelper scrollToElementWithId:@"usr_loginScreen_password_textField" inDirection:kGREYDirectionDown];
    }
    [ValidationHelper assertThatElementWithIdIsSufficientlyVisible:@"usr_loginScreen_password_textField"];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_password_textField")] performAction:grey_typeText(@"philips")];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_password_textField")] performAction:grey_clearText()];
    [EarlGrey dismissKeyboardWithError:nil];
    [ValidationHelper assertThatTextFieldWithId:@"usr_loginScreen_password_textField" hasErrorMessageDisplayed:LOCALIZE(@"USR_PasswordField_ErrorMsg")];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_password_textField")] performAction:grey_typeText(@"philips")];
    if (![ValidationHelper isElementWithIdCompletelyVisible:@"usr_loginScreen_login_button"]) {
        [ValidationHelper scrollToElementWithId:@"usr_loginScreen_login_button" inDirection:kGREYDirectionDown];
    }
    [ValidationHelper assertThatElementWithIdIsCompletelyVisible:@"usr_loginScreen_login_button"];
    [ValidationHelper assertThatElementWithIdIsEnabled:@"usr_loginScreen_login_button"];
}


- (void)verifyCommonLoginTraditionalFlow {
    [ValidationHelper tapButtonWithId:@"usr_startscreen_login_button"];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_email_textField")] assertWithMatcher:grey_firstResponder()];
    //Dismiss keyboard with valid email to check the layout properly.
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_email_textField")] performAction:grey_typeText(@"dummy@mail.com")];
    [EarlGrey dismissKeyboardWithError:nil];
    
    [UILayoutVerificationHelper verifyLogInScreenLayout];
    [EarlGrey rotateDeviceToOrientation:UIDeviceOrientationLandscapeRight errorOrNil:nil];
    [UILayoutVerificationHelper verifyLogInScreenLayout];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_email_textField")] performAction:grey_replaceText(@"")];
    
    [self loginScreenLocalContentValidation];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_email_textField")] performAction:grey_replaceText(@"")];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_password_textField")] performAction:grey_replaceText(@"")];
    [EarlGrey rotateDeviceToOrientation:UIDeviceOrientationPortrait errorOrNil:nil];
    [self loginScreenLocalContentValidation];
    
    [ValidationHelper tapButtonWithId:@"usr_loginScreen_login_button"];
    
    //Error views are not implemented as per DLS. So can not test error messages for now. But will test that the fields exist to make sure that an error happened that blocked transition to next screen.
    [ValidationHelper assertThatElementWithIdIsSufficientlyVisible:@"usr_loginScreen_email_textField"];
    [ValidationHelper assertThatElementWithIdIsSufficientlyVisible:@"usr_loginScreen_password_textField"];
    [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_password_textField")] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_replaceText(@"philips123")];
    [ValidationHelper assertThatElementWithIdIsEnabled:@"usr_loginScreen_login_button"];
    [ValidationHelper tapButtonWithId:@"usr_loginScreen_login_button"];
    //Next line is only to make EarlGrey wait for login to complete before checking user state. Without any validation, Earlgrey will not wait for network call to finish.
    [ValidationHelper isElementWithIdSufficientlyVisible:@"usr_almostDoneScreen_marketingMails_checkBox"];
    if (!([DIUser getInstance].receiveMarketingEmails) || ![RegistrationUtility hasUserAcceptedTermsnConditions:[DIUser getInstance].userIdentifier]) {
        [UILayoutVerificationHelper verifyAlmostDoneScreenLayout];
        [EarlGrey rotateDeviceToOrientation:UIDeviceOrientationLandscapeRight errorOrNil:nil];
        [UILayoutVerificationHelper verifyAlmostDoneScreenLayout];
        [EarlGrey rotateDeviceToOrientation:UIDeviceOrientationPortrait errorOrNil:nil];
        if (![RegistrationUtility hasUserAcceptedTermsnConditions:[DIUser getInstance].userIdentifier]) {
            [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_almostDoneScreen_termsAndConditions_checkBox")] performAction:grey_tap()];
        }
        [ValidationHelper tapButtonWithId:@"usr_almostDoneScreen_continue_button"];
    }
    [ValidationHelper assertThatCurrentScreenHasTitle:@"Demo App"];    
    [UILayoutVerificationHelper verifyDemoAppAndLauchUApp];
    [UILayoutVerificationHelper verifyMyDetailsScreenLayout];
    [ValidationHelper tapNavigationBackButton];
    [ValidationHelper tapButtonWithId:@"demoApp.MarketingOptin"];
    [UILayoutVerificationHelper verifyUserOptinScreen];
    [ValidationHelper tapNavigationBackButton];
    [self logoutUser];
}


- (void)testAA_1_LoginTraditionalFlow {
    [UILayoutVerificationHelper verifyDemoAppAndLauchUApp];
    [UILayoutVerificationHelper verifyStartScreenLayout];
    [EarlGrey rotateDeviceToOrientation:UIDeviceOrientationLandscapeRight errorOrNil:nil];
    [UILayoutVerificationHelper verifyStartScreenLayout];
    [EarlGrey rotateDeviceToOrientation:UIDeviceOrientationPortrait errorOrNil:nil];
    [self selectCountry:@"USR_Country_IN"];
    [self verifyCommonLoginTraditionalFlow];
}


- (void)testAA_1_LoginTraditionalFlow_Russia {
    [UILayoutVerificationHelper verifyDemoAppAndLauchUApp];
    [UILayoutVerificationHelper verifyStartScreenLayout];
    [self selectCountry:@"USR_Country_RU"];
    [self verifyCommonLoginTraditionalFlow];
}


- (void)verifyCommonForgotPasswordFlow {
    [ValidationHelper tapButtonWithId:@"usr_startscreen_login_button"];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_email_textField")] assertWithMatcher:grey_firstResponder()];
    //Dismiss keyboard with valid email to check the layout properly.
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_email_textField")] performAction:grey_typeText(@"dummy@mail.com")];
    [EarlGrey dismissKeyboardWithError:nil];
    
    [UILayoutVerificationHelper verifyLogInScreenLayout];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_email_textField")] performAction:grey_replaceText(@"")];
    
    [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_email_textField")] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_typeText(@"v2222222.222222@xtoxic.com")];
    [EarlGrey dismissKeyboardWithError:nil];
    [ValidationHelper tapElementWithText:LOCALIZE(@"USR_Forgot_Password_Title")];
#warning Below error message is from Janrain and can not be localized. Will fail if tested in any other language.
    [ValidationHelper assertThatTextFieldWithId:@"usr_loginScreen_email_textField" hasErrorMessageDisplayed:@"No account with that email address."];
    
    [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_email_textField")] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_clearText()];
    [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_email_textField")] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_typeText(@"abhi86@mailinator.com")];
    NSError *newKeyboardDismissError;
    [EarlGrey dismissKeyboardWithError:&newKeyboardDismissError];
    [ValidationHelper tapElementWithText:LOCALIZE(@"USR_Forgot_Password_Title")];
    NSString *messageBody = [NSString stringWithFormat:@"%@\n\n%@", LOCALIZE(@"USR_DLS_Forgot_Password_Alert_Message_Line1"), LOCALIZE(@"USR_DLS_Email_Verify_Alert_Body_Line2")];
    [ValidationHelper assertThatDLSAlertIsDisplayedWithTitle:LOCALIZE(@"USR_DLS_Forgot_Password_Alert_Title") message:messageBody andActionTitles:@[LOCALIZE(@"USR_DLS_Button_Title_Ok")]];
    [ValidationHelper tapDLSAlertActionWithTitle:LOCALIZE(@"USR_DLS_Button_Title_Ok")];
    [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_email_textField")] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_clearText()];
    [EarlGrey dismissKeyboardWithError:&newKeyboardDismissError];
    [ValidationHelper tapElementWithText:LOCALIZE(@"USR_Forgot_Password_Title")];
    
    [UILayoutVerificationHelper verifyForgotPasswordScreenLayout:YES];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_forgotPasswordScreen_email_textField")] performAction:grey_typeText(@"v1@mail")];
    [EarlGrey dismissKeyboardWithError:nil];
    [ValidationHelper assertThatTextFieldWithId:@"usr_forgotPasswordScreen_email_textField" hasErrorMessageDisplayed:LOCALIZE(@"USR_InvalidOrMissingEmail_ErrorMsg")];
    [ValidationHelper assertThatElementWithIdIsNotEnabled:@"usr_forgotPasswordScreen_send_button"];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_forgotPasswordScreen_email_textField")] performAction:grey_clearText()];
    [ValidationHelper assertThatTextFieldWithId:@"usr_forgotPasswordScreen_email_textField" hasErrorMessageDisplayed:LOCALIZE(@"USR_InvalidOrMissingEmail_ErrorMsg")];
    [ValidationHelper assertThatElementWithIdIsNotEnabled:@"usr_forgotPasswordScreen_send_button"];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_forgotPasswordScreen_email_textField")] performAction:grey_typeText(@"abhi86@mailinator.com")];
    [ValidationHelper assertThatTextFieldWithIdHasNoErrorMessageDisplayed:@"usr_forgotPasswordScreen_email_textField"];
    [EarlGrey dismissKeyboardWithError:&newKeyboardDismissError];
    [ValidationHelper assertThatElementWithIdIsEnabled:@"usr_forgotPasswordScreen_send_button"];
    [ValidationHelper tapButtonWithId:@"usr_forgotPasswordScreen_send_button"];
    
    messageBody = [NSString stringWithFormat:@"%@\n\n%@", LOCALIZE(@"USR_DLS_Forgot_Password_Alert_Message_Line1"), LOCALIZE(@"USR_DLS_Email_Verify_Alert_Body_Line2")];
    [ValidationHelper assertThatDLSAlertIsDisplayedWithTitle:LOCALIZE(@"USR_DLS_Forgot_Password_Alert_Title") message:messageBody andActionTitles:@[LOCALIZE(@"USR_DLS_Forgot_Password_Alert_Button_Title")]];
    [ValidationHelper tapDLSAlertActionWithTitle:LOCALIZE(@"USR_DLS_Forgot_Password_Alert_Button_Title")];
    //Extra wait because Alert needs to be displayed before navigation back can be tapped. EarlGrey does not wait for it and tries to tap immediately.
    [ValidationHelper waitForElementWithName:@"Send Button" elementMatcher:grey_accessibilityID(@"usr_forgotPasswordScreen_send_button") timeout:3.0];
    
    [ValidationHelper tapNavigationBackButton];
    [ValidationHelper tapNavigationBackButton];
}


- (void)verifyMobileForgotPasswordFlow {
    [ValidationHelper tapButtonWithId:@"usr_startscreen_login_button"];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_email_textField")] assertWithMatcher:grey_firstResponder()];
    //Dismiss keyboard with valid mobile number to check the layout properly.
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_email_textField")] performAction:grey_typeText(@"8613717320312")];
    [EarlGrey dismissKeyboardWithError:nil];
    
    [UILayoutVerificationHelper verifyLogInScreenLayout];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_email_textField")] performAction:grey_replaceText(@"")];
    
    [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_email_textField")] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_typeText(@"8613767765317")];
    [EarlGrey dismissKeyboardWithError:nil];
    [ValidationHelper tapElementWithText:LOCALIZE(@"USR_Forgot_Password_Title")];
    
//Error views are not implemented as per DLS. So can not test error messages for now. But will test that the fields exist to make sure that an error happened that blocked transition to next screen.
    
    // [ValidationHelper assertThatTextFieldWithId:@"usr_loginScreen_email_textField" hasErrorMessageDisplayed:@"Oops. Something went wrong and I was not able to send an SMS. Please try again later."];
    [ValidationHelper assertThatErrorNotificationIsDisplayedWithMessage:@"Oops. Something went wrong and I was not able to send an SMS. Please try again later."];
    [ValidationHelper tapCloseErrorNotification];
    [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_email_textField")] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_clearText()];
    [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_email_textField")] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_typeText(@"8613717320312")];
    NSError *newKeyboardDismissError;
    [EarlGrey dismissKeyboardWithError:&newKeyboardDismissError];
    [ValidationHelper tapElementWithText:LOCALIZE(@"USR_Forgot_Password_Title")];

    [UILayoutVerificationHelper verifySMSVerificationScreenLayoutForResetPassword:@"8613717320312"];

    [ValidationHelper tapButtonWithId:@"usr_smsVerificationScreen_iDidNotReceive_button"];
    [UILayoutVerificationHelper verifyResendSmsScreenLayout:@"8613717320312"];
    [ValidationHelper assertThatElementWithIdIsNotEnabled:@"usr_resendSMSScreen_resendSMS_button"];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_resendSMSScreen_phone_field")] performAction:grey_clearText()];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_resendSMSScreen_phone_field")] performAction:grey_typeText(@"86")];
    [EarlGrey dismissKeyboardWithError:nil];
    [ValidationHelper assertThatTextFieldWithId:@"usr_resendSMSScreen_phone_field" hasErrorMessageDisplayed:LOCALIZE(@"USR_InvalidPhoneNumber_ErrorMsg")];
    [ValidationHelper assertThatElementWithIdIsNotEnabled:@"usr_resendSMSScreen_resendSMS_button"];
    
    //Change phone number
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_resendSMSScreen_phone_field")] performAction:grey_clearText()];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_resendSMSScreen_phone_field")] performAction:grey_typeText(@"8618512141824")];
    [EarlGrey dismissKeyboardWithError:nil];
    [ValidationHelper assertThatElementWithIdIsEnabled:@"usr_resendSMSScreen_resendSMS_button"];
    [ValidationHelper tapButtonWithId:@"usr_resendSMSScreen_resendSMS_button"];
    [ValidationHelper assertThatElementWithIdIsNotEnabled:@"usr_resendSMSScreen_resendSMS_button"];
    [ValidationHelper waitForElementToBeEnabled:@"Resend SMS" elementId:grey_accessibilityID(@"usr_resendSMSScreen_resendSMS_button") timeout:70.0];
    [ValidationHelper assertThatElementWithIdIsEnabled:@"usr_resendSMSScreen_resendSMS_button"];
    [ValidationHelper tapButtonWithId:@"usr_resendSMSScreen_thanks_button"];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_smsVerificationScreen_smsCode_textField")] performAction:grey_replaceText(@"")];
    [UILayoutVerificationHelper verifySMSVerificationScreenLayoutForResetPassword:@"8618512141824"];

    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_smsVerificationScreen_smsCode_textField")] performAction:grey_typeText(@"456")];
    [ValidationHelper assertThatTextFieldWithId:@"usr_smsVerificationScreen_smsCode_textField" hasErrorMessageDisplayed:LOCALIZE(@"USR_VerificationCode_ErrorText")];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_smsVerificationScreen_smsCode_textField")] performAction:grey_clearText()];
    [ValidationHelper assertThatTextFieldWithId:@"usr_smsVerificationScreen_smsCode_textField" hasErrorMessageDisplayed:LOCALIZE(@"USR_EmptyField_ErrorMsg")];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_smsVerificationScreen_smsCode_textField")] performAction:grey_typeText(@"111111")];
    [ValidationHelper assertThatTextFieldWithIdHasNoErrorMessageDisplayed:@"usr_smsVerificationScreen_smsCode_textField"];
    
    [EarlGrey dismissKeyboardWithError:nil];
    [ValidationHelper tapButtonWithId:@"usr_smsVerificationScreen_verifyCode_button"];
    [ValidationHelper assertThatCurrentScreenHasTitle:LOCALIZE(@"USR_DLS_SigIn_TitleTxt")];
    [ValidationHelper tapNavigationBackButton];
    [ValidationHelper tapNavigationBackButton];
    
    [UILayoutVerificationHelper verifyLogInScreenLayout];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_loginScreen_email_textField")] performAction:grey_replaceText(@"")];
    [EarlGrey dismissKeyboardWithError:nil];
    [ValidationHelper tapElementWithText:LOCALIZE(@"USR_Forgot_Password_Title")];
    
    [UILayoutVerificationHelper verifyForgotPasswordScreenLayout:NO];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_forgotPasswordScreen_email_textField")] performAction:grey_typeText(@"861")];
    [EarlGrey dismissKeyboardWithError:nil];
    [ValidationHelper assertThatTextFieldWithId:@"usr_forgotPasswordScreen_email_textField" hasErrorMessageDisplayed:LOCALIZE(@"USR_InvalidEmailOrPhoneNumber_ErrorMsg")];
    [ValidationHelper assertThatElementWithIdIsNotEnabled:@"usr_forgotPasswordScreen_send_button"];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_forgotPasswordScreen_email_textField")] performAction:grey_clearText()];
    [ValidationHelper assertThatTextFieldWithId:@"usr_forgotPasswordScreen_email_textField" hasErrorMessageDisplayed:LOCALIZE(@"USR_EmptyField_ErrorMsg")];
    [ValidationHelper assertThatElementWithIdIsNotEnabled:@"usr_forgotPasswordScreen_send_button"];
    
    [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_forgotPasswordScreen_email_textField")] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_typeText(@"8613767765317")];
    [ValidationHelper assertThatTextFieldWithIdHasNoErrorMessageDisplayed:@"usr_forgotPasswordScreen_email_textField"];
    [EarlGrey dismissKeyboardWithError:&newKeyboardDismissError];
    [ValidationHelper assertThatElementWithIdIsEnabled:@"usr_forgotPasswordScreen_send_button"];
    [ValidationHelper tapButtonWithId:@"usr_forgotPasswordScreen_send_button"];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_forgotPasswordScreen_email_textField")] performAction:grey_replaceText(@"8613717320312")];
    [ValidationHelper assertThatTextFieldWithIdHasNoErrorMessageDisplayed:@"usr_forgotPasswordScreen_email_textField"];
    [EarlGrey dismissKeyboardWithError:&newKeyboardDismissError];
    [ValidationHelper assertThatElementWithIdIsEnabled:@"usr_forgotPasswordScreen_send_button"];
    [ValidationHelper tapButtonWithId:@"usr_forgotPasswordScreen_send_button"];

    [UILayoutVerificationHelper verifySMSVerificationScreenLayoutForResetPassword:@"8613717320312"];
    
    [ValidationHelper tapButtonWithId:@"usr_smsVerificationScreen_iDidNotReceive_button"];
    [UILayoutVerificationHelper verifyResendSmsScreenLayout:@"8613717320312"];
    [ValidationHelper assertThatElementWithIdIsNotEnabled:@"usr_resendSMSScreen_resendSMS_button"];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_resendSMSScreen_phone_field")] performAction:grey_clearText()];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_resendSMSScreen_phone_field")] performAction:grey_typeText(@"86")];
    [EarlGrey dismissKeyboardWithError:nil];
    [ValidationHelper assertThatTextFieldWithId:@"usr_resendSMSScreen_phone_field" hasErrorMessageDisplayed:LOCALIZE(@"USR_InvalidPhoneNumber_ErrorMsg")];
    [ValidationHelper assertThatElementWithIdIsNotEnabled:@"usr_resendSMSScreen_resendSMS_button"];
    
    //Change phone number
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_resendSMSScreen_phone_field")] performAction:grey_clearText()];
    [EarlGrey dismissKeyboardWithError:&newKeyboardDismissError];
    [ValidationHelper tapButtonWithId:@"usr_resendSMSScreen_thanks_button"];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_smsVerificationScreen_smsCode_textField")] performAction:grey_replaceText(@"")];
    [UILayoutVerificationHelper verifySMSVerificationScreenLayoutForResetPassword:@"8613717320312"];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_smsVerificationScreen_smsCode_textField")] performAction:grey_typeText(@"456")];
    [ValidationHelper assertThatTextFieldWithId:@"usr_smsVerificationScreen_smsCode_textField" hasErrorMessageDisplayed:LOCALIZE(@"USR_VerificationCode_ErrorText")];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_smsVerificationScreen_smsCode_textField")] performAction:grey_clearText()];
    [ValidationHelper assertThatTextFieldWithId:@"usr_smsVerificationScreen_smsCode_textField" hasErrorMessageDisplayed:LOCALIZE(@"USR_EmptyField_ErrorMsg")];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_smsVerificationScreen_smsCode_textField")] performAction:grey_typeText(@"111111")];
    [ValidationHelper assertThatTextFieldWithIdHasNoErrorMessageDisplayed:@"usr_smsVerificationScreen_smsCode_textField"];
    
    [EarlGrey dismissKeyboardWithError:nil];
    [ValidationHelper tapButtonWithId:@"usr_smsVerificationScreen_verifyCode_button"];
    [ValidationHelper assertThatCurrentScreenHasTitle:LOCALIZE(@"USR_DLS_SigIn_TitleTxt")];
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    if ([topController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)topController popToRootViewControllerAnimated:YES];
    }
}


- (void)testAA_2_ForgotPasswordFlow {
    [UILayoutVerificationHelper verifyDemoAppAndLauchUApp];
    [UILayoutVerificationHelper verifyStartScreenLayout];
    [self selectCountry:@"USR_Country_IN"];
    [self verifyCommonForgotPasswordFlow];
}


- (void)testAA_2_ForgotPasswordFlow_Russia {
    [UILayoutVerificationHelper verifyDemoAppAndLauchUApp];
    [UILayoutVerificationHelper verifyStartScreenLayout];
    [self selectCountry:@"USR_Country_RU"];
    [self verifyCommonForgotPasswordFlow];
}

- (void)DISABLED_testAA_3_FacebookLogin {
    [UILayoutVerificationHelper verifyDemoAppAndLauchUApp];
    [UILayoutVerificationHelper verifyStartScreenLayout];
    [ValidationHelper tapButtonWithId:@"usr_startscreen_facebook_button"];
    [ValidationHelper waitForElementWithName:@"Email address or phone number" elementMatcher:grey_accessibilityLabel(@"Email address or phone number") timeout:10.0];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityValue(@"Email address or phone number")] performAction:grey_typeText(@"philipstest365@gmail.com")];
    NSError *visibilityError;
    [[EarlGrey selectElementWithMatcher:grey_accessibilityLabel(@"Log In")] assertWithMatcher:grey_sufficientlyVisible() error:&visibilityError];
    if (visibilityError) {
        [[EarlGrey selectElementWithMatcher:grey_accessibilityLabel(@"Next")] performAction:grey_tap()];
    }
    [[[EarlGrey selectElementWithMatcher:grey_accessibilityValue(@"Facebook password")] performAction:grey_tap()] performAction:grey_typeText(@"TestPhilips123")];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityLabel(@"Log In")] performAction:grey_tap()];
    if ([ValidationHelper isElementWithIdCompletelyVisible:@"usr_almostDoneScreen_marketingMails_checkBox"] || [ValidationHelper isElementWithIdCompletelyVisible:@"usr_almostDoneScreen_termsAndConditions_checkBox"]) {
        if ([ValidationHelper isElementWithIdCompletelyVisible:@"usr_almostDoneScreen_marketingMails_checkBox"]) {
            [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_almostDoneScreen_marketingMails_checkBox")] performAction:grey_tap()];
        }
        if ([ValidationHelper isElementWithIdCompletelyVisible:@"usr_almostDoneScreen_termsAndConditions_checkBox"]) {
            [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_almostDoneScreen_termsAndConditions_checkBox")] performAction:grey_tap()];
        }
        [ValidationHelper tapButtonWithId:@"usr_almostDoneScreen_continue_button"];
    }
    [ValidationHelper assertThatCurrentScreenHasTitle:LOCALIZE(@"USR_SigIn_TitleTxt")];
    [ValidationHelper tapNavigationBackButton];
    [self logoutUser];
}


- (void)DISABLED_testAA_4_TraditionalMerge {
    [UILayoutVerificationHelper verifyDemoAppAndLauchUApp];
    [UILayoutVerificationHelper verifyStartScreenLayout];
    [ValidationHelper tapButtonWithId:@"usr_startscreen_facebook_button"];
    [ValidationHelper waitForElementWithName:@"Email address or phone number" elementMatcher:grey_accessibilityLabel(@"Email address or phone number") timeout:10.0];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityValue(@"Email address or phone number")] performAction:grey_typeText(@"philipstest365@gmail.com")];
    [[[EarlGrey selectElementWithMatcher:grey_accessibilityValue(@"Facebook password")] performAction:grey_tap()] performAction:grey_typeText(@"TestPhilips123")];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityLabel(@"Log In")] performAction:grey_tap()];
    [UILayoutVerificationHelper verifyTraditionalMergeScreenLayout];
    
    [ValidationHelper tapButtonWithId:@"usr_traditionalMergeScreen_forgotPassword_button"];
    NSString *messageBody = [NSString stringWithFormat:@"%@\n\n%@", LOCALIZE(@"USR_DLS_Forgot_Password_Alert_Message_Line1"), LOCALIZE(@"USR_DLS_Email_Verify_Alert_Body_Line2")];
    [ValidationHelper assertThatDLSAlertIsDisplayedWithTitle:LOCALIZE(@"USR_DLS_Forgot_Password_Alert_Title") message:messageBody andActionTitles:@[LOCALIZE(@"USR_DLS_Button_Title_Ok")]];
    [ValidationHelper tapDLSAlertActionWithTitle:LOCALIZE(@"USR_DLS_Button_Title_Ok")];

    [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_traditionalMergeScreen_password_textField")] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_typeText(@"philips123")];
    
    [ValidationHelper assertThatElementWithIdIsEnabled:@"usr_traditionalMergeScreen_merge_button"];
    
    if (![ValidationHelper isElementWithIdCompletelyVisible:@"usr_traditionalMergeScreen_merge_button"]) {
        [ValidationHelper scrollToElementWithId:@"usr_traditionalMergeScreen_merge_button" inDirection:kGREYDirectionDown];
    }
    [ValidationHelper tapButtonWithId:@"usr_traditionalMergeScreen_merge_button"];
    
    if ([ValidationHelper isElementWithIdCompletelyVisible:@"usr_almostDoneScreen_marketingMails_checkBox"] || [ValidationHelper isElementWithIdCompletelyVisible:@"usr_almostDoneScreen_termsAndConditions_checkBox"]) {
        if ([ValidationHelper isElementWithIdCompletelyVisible:@"usr_almostDoneScreen_marketingMails_checkBox"]) {
            [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_almostDoneScreen_marketingMails_checkBox")] performAction:grey_tap()];
        }
        if ([ValidationHelper isElementWithIdCompletelyVisible:@"usr_almostDoneScreen_termsAndConditions_checkBox"]) {
            [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usr_almostDoneScreen_termsAndConditions_checkBox")] performAction:grey_tap()];
        }
        [ValidationHelper tapButtonWithId:@"usr_almostDoneScreen_continue_button"];
    }
    [ValidationHelper tapNavigationBackButton];
    [self logoutUser];
}


- (void)testAA_5_MobileNumberRegisration {
    [UILayoutVerificationHelper verifyDemoAppAndLauchUApp];
    [self selectCountry:@"USR_Country_CN"];
    [UILayoutVerificationHelper verifyStartScreenLayout];
    [ValidationHelper tapButtonWithId:@"usr_startscreen_create_button"];
    [self verifyCreateAccountCommonFlow];
}



- (void)testAA_6_MobileNumberLogin {
    [UILayoutVerificationHelper verifyDemoAppAndLauchUApp];
    [self selectCountry:@"USR_Country_CN"];
    [UILayoutVerificationHelper verifyStartScreenLayout];
    [self verifyCommonLoginTraditionalFlow];
}


- (void)DISABLED_testAA_7_Mobile_ForgotPasswordFlow {
    [UILayoutVerificationHelper verifyDemoAppAndLauchUApp];
    [UILayoutVerificationHelper verifyStartScreenLayout];
    [self selectCountry:@"USR_Country_CN"];
    [self verifyMobileForgotPasswordFlow];
}

@end
