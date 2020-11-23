//
//  URForgotPasswordViewController.m
//  Registration
//
//  Created by Abhishek Chatterjee on 30/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URForgotPasswordViewController.h"
#import "URVerifySMSViewController.h"

@interface URForgotPasswordViewController ()

@property (weak, nonatomic) IBOutlet UIDLabel          *forgotPasswordDetailLabel;
@property (weak, nonatomic) IBOutlet UIDLabel          *emailAddressTextFieldHeaderLabel;
@property (weak, nonatomic) IBOutlet UIDTextField      *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UIDProgressButton *sendButton;

@property (nonatomic, strong) NSString *mobileResetToken;
@property (nonatomic, assign) BOOL      isValidTextField;

@end

@implementation URForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.title = LOCALIZE(@"USR_DLS_SigIn_TitleTxt");

    [self.emailAddressTextField addTarget:self action:@selector(validateTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.emailAddressTextField setText:self.emailAddress];
    [self.emailAddressTextField checkAndUpdateTextFieldToRTL];
    
    if (self.loginFlowType == RegistrationLoginFlowTypeMobile) {
        [self.forgotPasswordDetailLabel setText:LOCALIZE(@"USR_DLS_Forgot_Password_Body_With_Phone_No")];
        [self.emailAddressTextFieldHeaderLabel setText:LOCALIZE(@"USR_DLS_Email_Phone_Label_Text")];
    } else {
        [self.forgotPasswordDetailLabel setText:LOCALIZE(@"USR_DLS_Forgot_Password_Body_Without_Phone_No")];
        [self.emailAddressTextFieldHeaderLabel setText:LOCALIZE(@"USR_DLS_Email_Label_Text")];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [DIRegistrationAppTagging trackPageWithInfo:kRegistrationForgotPassword paramKey:nil andParamValue:nil];
    DIRInfoLog(@"Screen name is %@", kRegistrationForgotPassword);
    self.sendButton.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.emailAddressTextField becomeFirstResponder];
}


#pragma mark - View Utility methods
#pragma mark -

- (void)validateTextField:(UITextField *)textField {
    [super validateTextField:textField];
    [self validateTextField:textField forcedError:NO];
}


- (void)validateTextField:(UITextField *)textField forcedError:(BOOL)forcedError {
    if(textField == self.emailAddressTextField) {
        self.isValidTextField = (self.loginFlowType == RegistrationLoginFlowTypeMobile) ? [self.emailAddressTextField validateEmailOrMobileNumberContentAndDisplayError:forcedError] : [self.emailAddressTextField validateEmailContentAndDisplayError:forcedError];
    }
    [self.sendButton setEnabled:self.isValidTextField && self.connectionAvailable];
}

#pragma mark - UITextFieldDelegate Methods
#pragma mark -

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
    [self validateTextField:textField forcedError:YES];
}

#pragma mark - Action methods
#pragma mark -

- (IBAction)sendBtnPressed:(UIDProgressButton *)sender {
    DIRInfoLog(@"%@.sendBtnPressed clicked", kRegistrationForgotPassword);
    self.sendButton.enabled = NO;
    [self removeTextFieldErrors];
    [sender setIsActivityIndicatorVisible:YES];
    sender.progressTitle = LOCALIZE(@"USR_DLS_Forgot_Password_Button_Title");
    [self startActivityIndicator];
    NSString *email = [self.emailAddressTextField.text isValidEmail] ? self.emailAddressTextField.text : nil;
    NSString *mobileNumber = [self.emailAddressTextField.text isValidMobileNumber] ? [self.emailAddressTextField.text validatedMobileNumber] : nil;
    if (email) {
        [self.userRegistrationHandler forgotPasswordForEmail:email];
        [DIRegistrationAppTagging trackActionWithInfo:kRegSendData params:@{kForgotPasswordChannel:kRegEmail}];
    } else if(mobileNumber) {
        [self.userRegistrationHandler verificationCodeToResetPassword:mobileNumber];
        [DIRegistrationAppTagging trackActionWithInfo:kRegSendData params:@{kForgotPasswordChannel:kRegPhoneNumber}];
    }
}

#pragma mark - UserRegistrationDelegate
#pragma mark -

- (void)didSendForgotPasswordSuccess {
    [super didSendForgotPasswordSuccess];
    UIDAlertController *alertVC = [self forgotPasswordSuccessAlert];
    UIDAction *backToLoginAction = [[UIDAction alloc] initWithTitle:LOCALIZE(@"USR_DLS_Forgot_Password_Alert_Button_Title") style:UIDActionStylePrimary handler:^(UIDAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
        [DIRegistrationAppTagging trackActionWithInfo:kRegSendData params:@{kRegStatusNotificationResponse:kRegOK}];
    }];
    [alertVC addAction:backToLoginAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    [self.sendButton setIsActivityIndicatorVisible:NO];
    self.sendButton.enabled = YES;
}

- (void)didSendForgotPasswordFailedwithError:(NSError *)error {
    [super didSendForgotPasswordFailedwithError:error];
    [self.sendButton setIsActivityIndicatorVisible:NO];
    self.emailAddressTextField.enabled = YES;
    if (error.code == DIInvalidFieldsErrorCode) {
        [DIRegistrationAppTagging trackActionWithInfo:kRegSendData paramKey:kRegSpecialEvents andParamValue:kRegTryLoginAgain];
        [self.emailAddressTextField setValidationMessage:error.localizedDescription];
        [self.emailAddressTextField setValidationView:YES];
    } else {
        [self showNotificationBarErrorViewWithTitle:error.localizedDescription];
    }
}

- (void)didVerificationForMobileToResetPasswordSuccessWithToken:(NSString *)resetToken {
    [super didVerificationForMobileToResetPasswordSuccessWithToken:resetToken];
    [self.sendButton setIsActivityIndicatorVisible:NO];
    self.emailAddressTextField.enabled = YES;
    self.mobileResetToken = resetToken;
    [self performSegueWithIdentifier:kRegistrationForgotPasswordShowActivationSegue sender:nil];
}

- (void)didVerificationForMobileToResetPasswordFailedwithError:(nonnull NSError *)error {
    [super didVerificationForMobileToResetPasswordFailedwithError:error];
    [self.sendButton setIsActivityIndicatorVisible:NO];
    self.sendButton.enabled = YES;
    if (error.code == DIInvalidFieldsErrorCode) {
        [DIRegistrationAppTagging trackActionWithInfo:kRegSendData paramKey:kRegSpecialEvents andParamValue:kRegTryLoginAgain];
        [self.emailAddressTextField setValidationMessage:error.localizedDescription];
        [self.emailAddressTextField setValidationView:YES];
    } else {
        [self showNotificationBarErrorViewWithTitle:error.localizedDescription];
    }
}

#pragma mark - Navigation 
#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:kRegistrationForgotPasswordShowActivationSegue]) {
        NSString *mobileNumber = [self.emailAddressTextField.text validatedMobileNumber];
        URVerifySMSViewController *urVerifySMSViewController = segue.destinationViewController;
        urVerifySMSViewController.mobileNumber = mobileNumber;
        urVerifySMSViewController.enterCodeFlowType = EnterCodeFlowTypeReset;
        urVerifySMSViewController.mobileResetToken = self.mobileResetToken;
    }
}

#pragma mark - Reachability Status
#pragma mark -

- (void) updateConnectionStatus:(BOOL) connectionAvailable {
    [super updateConnectionStatus:connectionAvailable];
    [self.sendButton setEnabled:self.isValidTextField && connectionAvailable];
}

@end
