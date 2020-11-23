//
//  URResendSMSViewController.m
//  Registration
//
//  Created by Sai Pasumarthy on 03/06/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URResendSMSViewController.h"

@interface URResendSMSViewController()
@property(nonatomic, assign) BOOL isValidEmailOrPhoneNumber;
@end

@implementation URResendSMSViewController

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = LOCALIZE(@"USR_Resend_SMS_title");
    self.isValidEmailOrPhoneNumber = YES;
    self.emailOrSmsTextField.text = self.editMobileNumber;
    [self.emailOrSmsTextField checkAndUpdateTextFieldToRTL];
    self.resendSuccessNotificationBarView.titleMessage = [NSString stringWithFormat:@"%@ %@", LOCALIZE(@"USR_DLS_ResendSMS_NotificationBar_Title"), self.editMobileNumber];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DIRInfoLog(@"Screen name is %@", kRegistrationResendSMS);
    [DIRegistrationAppTagging trackPageWithInfo:kRegistrationResendSMS paramKey:nil andParamValue:nil];
}


#pragma mark - 
#pragma mark - Custom Methods

- (void)countDownTimer {
    [super countDownTimer];
    if ([self isMobileNumberEdited]) {
        if (self.enterCodeFlowType == EnterCodeFlowTypeVerification) {
            [self updateResendSMSOrUpdateMobileButtonTitle:LOCALIZE(@"USR_Update_MobileNumber_Button_Text")];
        } else {
            [self updateResendSMSOrUpdateMobileButtonTitle:LOCALIZE(@"USR_Resend_SMS_title")];
        }
    } else {
        [self updateResendSMSOrUpdateMobileButtonTitle:LOCALIZE(@"USR_Resend_SMS_title")];
        self.resendButton.enabled = (self.timerSeconds == 0 && self.connectionAvailable);
    }
    [self updateProgressBarAndProgressLabel];
}


- (void)updateProgressBarAndProgressLabel {
    [self.timeProgressBar setProgress:1 - self.timerSeconds/60.0];
    self.progressBarLabel.text = (self.timerSeconds == 0) ? @"" : [NSString stringWithFormat:LOCALIZE(@"USR_DLS_ResendSMS_Progress_View_Progress_Text"),self.timerSeconds];
}


- (void)updateResetToken:(NSString *)resetToken andMobileNumber:(NSString *)mobileNumber {
    if ([self.delegate respondsToSelector:@selector(resetTokenForMobileResetPassword:andUpdatedMobile:)]) {
        [self.delegate resetTokenForMobileResetPassword:resetToken andUpdatedMobile:mobileNumber];
    }
    [self updateResendButtonAndRestartTimer];
}


- (BOOL)isMobileNumberEdited {
    NSString *mobileNumber = [self.editMobileNumber validatedMobileNumber];
    NSString *updatedMobileNumber = [[self.emailOrSmsTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] validatedMobileNumber];
    return ![mobileNumber isEqualToString:updatedMobileNumber];
}


- (void)updateResendSMSOrUpdateMobileButtonTitle:(NSString *)buttonTitle {
    [self.resendButton setTitle:buttonTitle forState:UIControlStateNormal];
    [self.resendButton setTitle:buttonTitle forState:UIControlStateDisabled];
}


- (void)updateResendButtonAndRestartTimer {
    self.resendButton.enabled = NO;
    if ([self.timerTrackingDelegate respondsToSelector:@selector(restartTimer:)]) {
        self.resendEmailOrSMSDate = [NSDate date];
        [self enableTimer];
        [self.timerTrackingDelegate restartTimer:self.resendEmailOrSMSDate];
    }
    self.resendSuccessNotificationBarView.titleMessage = [NSString stringWithFormat:@"%@ %@", LOCALIZE(@"USR_DLS_ResendSMS_NotificationBar_Title"), self.editMobileNumber];
    [self.resendSuccessNotificationBarView setHidden:NO];
}


- (void)updateTermsAndConditionsForUpdatedMobileNumber {
    if ([URSettingsWrapper sharedInstance].isTermsAndConditionsRequired) {
        [RegistrationUtility userAcceptedTermsnConditions:self.userRegistrationHandler.mobileNumber];
    }
}


- (void)handleMobileResetPasswordError:(nonnull NSError *)error {
    if (error.code == DIInvalidFieldsErrorCode) {
        [self.emailOrSmsTextField setValidationMessage:error.localizedDescription];
        [self.emailOrSmsTextField setValidationView:YES];
    } else {
        [self showNotificationBarErrorViewWithTitle:error.localizedDescription];
    }
}

#pragma mark - IBActions
#pragma mark -

- (IBAction)resendSMSOrUpdateMobileNumber:(UIDProgressButton *)sender {
    DIRInfoLog(@"%@.resendSMSOrUpdateMobileNumber clicked", kRegistrationResendSMS);
    [self.view endEditing:YES];
    NSString *validatedMobileNumber = [[self.emailOrSmsTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] validatedMobileNumber];
    if ([self.resendButton.titleLabel.text isEqualToString:LOCALIZE(@"USR_Resend_SMS_title")]) {
        sender.progressTitle = LOCALIZE(@"USR_Resend_SMS_title");
        if (self.enterCodeFlowType == EnterCodeFlowTypeReset) {
            [self.userRegistrationHandler verificationCodeToResetPassword:validatedMobileNumber];
        } else {
            [self.userRegistrationHandler resendVerificationCodeForMobile:validatedMobileNumber];
        }
    } else {
        sender.progressTitle = LOCALIZE(@"USR_Update_MobileNumber_Button_Text");
        [self.userRegistrationHandler updateMobileNumber:validatedMobileNumber];
    }
    self.resendButton.enabled = NO;
    [sender setIsActivityIndicatorVisible:YES];
    [self startActivityIndicator];
    [self hideNotificationBarErrorView];
}


- (IBAction)thanksIGotIt:(id)sender {
    DIRInfoLog(@"%@.thanksIGotIt clicked", kRegistrationResendSMS);
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)validateTextField:(UIDTextField *)textField forceError:(BOOL)forceError {
    [super validateTextField:textField];
    self.isValidEmailOrPhoneNumber = [textField validatePhoneNumberContentAndDisplayError:forceError];
    if ([self isMobileNumberEdited]) {
        if (self.enterCodeFlowType == EnterCodeFlowTypeVerification) {
            [self updateResendSMSOrUpdateMobileButtonTitle:LOCALIZE(@"USR_Update_MobileNumber_Button_Text")];
        } else {
            [self updateResendSMSOrUpdateMobileButtonTitle:LOCALIZE(@"USR_Resend_SMS_title")];
        }
        self.resendButton.enabled = self.isValidEmailOrPhoneNumber && self.connectionAvailable;
    } else {
        [self updateResendSMSOrUpdateMobileButtonTitle:LOCALIZE(@"USR_Resend_SMS_title")];
        [self toggleResendButton:self.connectionAvailable isValidTextfield:self.isValidEmailOrPhoneNumber];
    }    
}


#pragma mark - UITextFieldDelegate
#pragma mark -

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
    [self validateTextField:(UIDTextField *)textField forceError:YES];
}

#pragma mark - UserDetailsDelegate
#pragma mark -

- (void)didUpdateSuccess {
    [self.userRegistrationHandler refetchUserProfile];
}


- (void)didUpdateFailedWithError:(NSError *)error {
    [super didUpdateFailedWithError:error];
    [self.resendButton setIsActivityIndicatorVisible:NO];
    [self showNotificationBarErrorViewWithTitle:error.localizedDescription];
}


- (void)didUserInfoFetchingSuccessWithUser:(DIUser *)profile{
    self.editMobileNumber = self.userRegistrationHandler.mobileNumber;
    [self updateResendSMSOrUpdateMobileButtonTitle:LOCALIZE(@"USR_Resend_SMS_title")];
    [self updateTermsAndConditionsForUpdatedMobileNumber];
    self.resendButton.progressTitle = LOCALIZE(@"USR_Resend_SMS_title");
    //Resend verification code again
    [self.userRegistrationHandler resendVerificationCodeForMobile:[self.editMobileNumber validatedMobileNumber]];

    if ([self.resendTimeTracker isValid]) {
        [self.resendTimeTracker invalidate];
    }
}


- (void)didUserInfoFetchingFailedWithError:(NSError *)error {
    [super didUserInfoFetchingFailedWithError:error];
    [self.resendButton setIsActivityIndicatorVisible:NO];
    [self showNotificationBarErrorViewWithTitle:error.localizedDescription ? error.localizedDescription : [NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), error.code]];
}

#pragma mark - UserRegistrationDelegate
#pragma mark -

- (void)didResendMobileverificationSuccess {
    [super didResendMobileverificationSuccess];
    [self.resendButton setIsActivityIndicatorVisible:NO];
    NSString *validatedMobileNumber = [[self.emailOrSmsTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] validatedMobileNumber];
    self.editMobileNumber = validatedMobileNumber;
    [self updateResetToken:nil andMobileNumber:[DIUser getInstance].mobileNumber];
}


- (void)didResendMobileverificationFailedwithError:(nonnull NSError *)error {
    [super didResendMobileverificationFailedwithError:error];
    [self.resendButton setIsActivityIndicatorVisible:NO];
    [self showNotificationBarErrorViewWithTitle:error.localizedDescription];
}


- (void)didVerificationForMobileToResetPasswordSuccessWithToken:(NSString *)resetToken {
    [super didVerificationForMobileToResetPasswordSuccessWithToken:resetToken];
    [self.resendButton setIsActivityIndicatorVisible:NO];
    NSString *validatedMobileNumber = [[self.emailOrSmsTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] validatedMobileNumber];
    self.editMobileNumber = validatedMobileNumber;
    [self updateResetToken:resetToken andMobileNumber:self.editMobileNumber];
}


- (void)didVerificationForMobileToResetPasswordFailedwithError:(nonnull NSError *)error {
    [super didVerificationForMobileToResetPasswordFailedwithError:error];
    [self.resendButton setIsActivityIndicatorVisible:NO];
    [self handleMobileResetPasswordError:error];
}

#pragma mark - Reachability Status

- (void)updateConnectionStatus:(BOOL) connectionAvailable {
    if ([self.resendSuccessNotificationBarView isHidden]) {
        [super updateConnectionStatus:connectionAvailable];
    } else {
        self.resendSuccessNotificationBarView.hidden = YES;
        [super updateConnectionStatus:connectionAvailable];
    }
    [self toggleResendButton:connectionAvailable isValidTextfield:self.isValidEmailOrPhoneNumber];
}

@end
