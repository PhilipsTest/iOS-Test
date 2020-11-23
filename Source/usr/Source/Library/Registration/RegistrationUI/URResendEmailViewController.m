//
//  URResendEmailViewController.m
//  Registration
//
//  Created by Abhishek Chatterjee on 25/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URResendEmailViewController.h"


@interface URResendEmailViewController ()

@property(nonatomic, assign) BOOL isValidEmail;

@end

@implementation URResendEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALIZE(@"USR_DLS_Resend_Email_Screen_title");
    self.isValidEmail = YES;
    self.resendSuccessNotificationBarView.titleMessage = [NSString stringWithFormat:@"%@ %@", LOCALIZE(@"USR_DLS_Resend_Email_NotificationBar_Title"), self.userRegistrationHandler.email];
    self.emailOrSmsTextField.text = self.userRegistrationHandler.email;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DIRInfoLog(@"Screen name is %@", kRegistrationResendEmail);
    [DIRegistrationAppTagging trackPageWithInfo:kRegistrationResendEmail paramKey:nil andParamValue:nil];
}


#pragma mark - View Utility methods -

- (void)countDownTimer {
    [super countDownTimer];
    if (!self.resendButton.isActivityIndicatorVisible) {
        [self updateResendButtonTitleTo:[self isEmailEdited] ? LOCALIZE(@"USR_Update_Email_Button_Text") : LOCALIZE(@"USR_DLS_Resend_The_Email_Button_Title")];
        if ([self isEmailEdited]) {
            self.resendButton.enabled = self.isValidEmail && self.connectionAvailable;
        } else {
            self.resendButton.enabled = (self.timerSeconds == 0 && self.connectionAvailable);
        }
    }
    [self updateProgressBarAndProgressLabel];
}


- (void)updateResendButtonAndRestartTimer {
    self.resendButton.enabled = NO;
    if ([self.timerTrackingDelegate respondsToSelector:@selector(restartTimer:)]) {
        self.resendEmailOrSMSDate = [NSDate date];
        [self enableTimer];
        [self.timerTrackingDelegate restartTimer:self.resendEmailOrSMSDate];
    }
}


- (void)validateTextField:(UITextField *)textField {
    [super validateTextField:textField];
    [self validateTextField:textField forcedError:NO];
}


- (void)validateTextField:(UITextField *)textField forcedError:(BOOL)forcedError {
    if(textField == self.emailOrSmsTextField) {
        self.isValidEmail = [self.emailOrSmsTextField validateEmailContentAndDisplayError:forcedError];
    }
    [self toggleResendButton:self.connectionAvailable isValidTextfield:self.isValidEmail];
    [self updateResendButtonTitleTo:[self isEmailEdited] ? LOCALIZE(@"USR_Update_Email_Button_Text") : LOCALIZE(@"USR_DLS_Resend_The_Email_Button_Title")];
}


- (void)updateProgressBarAndProgressLabel {
    [self.timeProgressBar setProgress:1 - self.timerSeconds/60.0];
    self.progressBarLabel.text = (self.timerSeconds == 0) ? @"" : [NSString stringWithFormat:LOCALIZE(@"USR_DLS_ResendSMS_Progress_View_Progress_Text"),self.timerSeconds];
}


- (BOOL)isEmailEdited {
    return ![self.emailOrSmsTextField.text isEqualToString:self.userRegistrationHandler.email];
}


- (void)updateResendButtonTitleTo:(NSString *)newTitle {
    [self.resendButton setTitle:newTitle forState:UIControlStateNormal];
    [self.resendButton setTitle:newTitle forState:UIControlStateDisabled];
}

#pragma mark - UITextFieldDelegate Methods -

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
    [self validateTextField:textField forcedError:YES];
}

#pragma mark - Button Action -

- (IBAction)resendEmailButtonAction:(UIDProgressButton *)sender {
    DIRInfoLog(@"%@.resendEmailButtonAction clicked", kRegistrationResendEmail);
    [self.view endEditing:YES];
    [sender setIsActivityIndicatorVisible:YES];
    sender.progressTitle = sender.titleLabel.text;
    [self startActivityIndicator];
    [self.resendButton setEnabled:NO];
    //Send resend request
    if ([self isEmailEdited]) {
        [self.userRegistrationHandler addRecoveryEmailToMobileNumberAccount:self.emailOrSmsTextField.text];
    } else {
        [self.userRegistrationHandler resendVerificationMail:self.userRegistrationHandler.email];
    }
}


- (IBAction)thanksButtonAction:(id)sender {
    DIRInfoLog(@"%@.thanksButtonAction clicked", kRegistrationResendEmail);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UserRegistrationDelegate -

- (void)didResendEmailverificationSuccess {
    [super didResendEmailverificationSuccess];
    [self.resendButton setIsActivityIndicatorVisible:NO];
    [self updateResendButtonAndRestartTimer];
    [self.resendSuccessNotificationBarView setHidden:NO];
}


- (void)didResendEmailverificationFailedwithError:(NSError *)error {
    //Enable resend button when there is error
    [super didResendEmailverificationFailedwithError:error];
    [self.resendButton setIsActivityIndicatorVisible:NO];
    [self updateResendButtonTitleTo:[self isEmailEdited] ? LOCALIZE(@"USR_Update_Email_Button_Text") : LOCALIZE(@"USR_DLS_Resend_The_Email_Button_Title")];
    [self showNotificationBarErrorViewWithTitle:error.localizedDescription ? error.localizedDescription : [NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), error.code]];
    self.resendButton.enabled = self.connectionAvailable;
}


- (void)didUpdateSuccess {
    [super didUpdateSuccess];
    self.resendSuccessNotificationBarView.titleMessage = [NSString stringWithFormat:@"%@ %@", LOCALIZE(@"USR_DLS_Resend_Email_NotificationBar_Title"), self.emailOrSmsTextField.text];
    [self.resendButton setIsActivityIndicatorVisible:NO];
    [self updateResendButtonTitleTo:[self isEmailEdited] ? LOCALIZE(@"USR_Update_Email_Button_Text") : LOCALIZE(@"USR_DLS_Resend_The_Email_Button_Title")];
    //Add email to list of accepted TnC
    if ([URSettingsWrapper sharedInstance].isTermsAndConditionsRequired) {
        [RegistrationUtility userAcceptedTermsnConditions:self.userRegistrationHandler.email];
    }
    [self updateResendButtonAndRestartTimer];
    [self.resendSuccessNotificationBarView setHidden:NO];
}


- (void)didUpdateFailedWithError:(NSError *)error {
    [super didUpdateFailedWithError:error];
    [self.resendButton setIsActivityIndicatorVisible:NO];
    [self showNotificationBarErrorViewWithTitle:error.localizedDescription ? error.localizedDescription : [NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), error.code]];
    self.resendButton.enabled = self.connectionAvailable;
}

#pragma mark - Reachability Status -

- (void) updateConnectionStatus:(BOOL) connectionAvailable {
    if ([self.resendSuccessNotificationBarView isHidden]) {
        [super updateConnectionStatus:connectionAvailable];
    } else {
        self.resendSuccessNotificationBarView.hidden = YES;
        [super updateConnectionStatus:connectionAvailable];
    }
    [self toggleResendButton:self.connectionAvailable isValidTextfield:self.isValidEmail];
}

@end
