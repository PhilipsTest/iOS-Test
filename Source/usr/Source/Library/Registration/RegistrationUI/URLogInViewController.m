//
//  URLogInViewController.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "URLogInViewController.h"
#import "URAlmostDoneViewController.h"
#import "URCreateAccountViewController.h"
#import "URForgotPasswordViewController.h"
#import "URVerifySMSViewController.h"

@import PlatformInterfaces;

@interface URLogInViewController()<UITextFieldDelegate>

@property (nonatomic, weak)   IBOutlet UIDLabel             *emailOrMobileNumberLabel;
@property (nonatomic, weak)   IBOutlet UIDProgressButton    *loginButton;
@property (weak, nonatomic)   IBOutlet UIDHyperLinkLabel    *forgotPasswordLinkTextLabel;
@property (weak, nonatomic)   IBOutlet UIDHyperLinkLabel    *createAccountLinkTextLabel;
@property (nonatomic, weak)   IBOutlet UIDTextField         *emailOrMobileNumberField;
@property (nonatomic, weak)   IBOutlet UIDPasswordField     *passwordField;
@property (nonatomic, weak)   IBOutlet UIView               *backgroundView;
@property (nonatomic, weak)   IBOutlet UIStackView          *bottomStackView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint   *placeholderConstraint;
@property (nonatomic, weak)   IBOutlet UIDProgressIndicator *loadingIndicator;

@property (nonatomic, strong) NSString *mobileResetToken;
@property (nonatomic, assign) BOOL      validEmail;
@property (nonatomic, assign) BOOL      validPassword;

@end

@implementation URLogInViewController

#pragma mark - UIViewController LifyCycle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALIZE(@"USR_DLS_SigIn_TitleTxt");
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, MAXFLOAT);
    [self.emailOrMobileNumberField addTarget:self action:@selector(validateTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordField addTarget:self action:@selector(validateTextField:) forControlEvents:UIControlEventEditingChanged];
    if (self.loginFlowType == RegistrationLoginFlowTypeMobile) {
        self.emailOrMobileNumberLabel.text = LOCALIZE(@"USR_DLS_Email_Phone_Label_Text");
    } else {
        self.emailOrMobileNumberLabel.text = LOCALIZE(@"USR_DLS_Email_Label_Text");
    }
    [self loadForgotPasswordAndCreateAccountLinks];
    //Workaround below to hide create account and still be able to tap on forgot password via automation. Change the automation with custom action and then hide it.
    self.createAccountLinkTextLabel.alpha = 0.0;
    [self.emailOrMobileNumberField checkAndUpdateTextFieldToRTL];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.loadingIndicator stopAnimating];
    [self initialize];
    [self removeTextFieldErrors];
    [DIRegistrationAppTagging trackPageWithInfo:kRegistrationSignin paramKey:nil andParamValue:nil];
    DIRInfoLog(@"Screen name is %@", kRegistrationSignin);
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateBottomViewConstraints];
    [self.bottomStackView setHidden:NO];
    [self.emailOrMobileNumberField becomeFirstResponder];
}


#pragma mark Custom Methods

- (void)initialize {
    self.validEmail = NO;
    self.validPassword = NO;
    self.emailOrMobileNumberField.text = @"";
    self.passwordField.text = @"";
    self.loginButton.enabled = ([self inputFieldsValid] && self.connectionAvailable);
}

    
- (void)loadForgotPasswordAndCreateAccountLinks {
    UIDHyperLinkModel *hyperLinkModel = [[UIDHyperLinkModel alloc] init];
    [self.forgotPasswordLinkTextLabel addLink:hyperLinkModel handler:^(NSRange range) {
        [self userForgotPassword];
    }];
    [self.createAccountLinkTextLabel addLink:hyperLinkModel handler:^(NSRange range) {
        [self createMyPhilipsAccount];
    }];
   
}
    

- (void)userForgotPassword {
    DIRInfoLog(@"%@.userForgotPassword clicked", kRegistrationSignin);
    [self removeTextFieldErrors];
    NSString *email = [self.emailOrMobileNumberField.text isValidEmail] ? self.emailOrMobileNumberField.text : nil;
    NSString *mobileNumber = [self.emailOrMobileNumberField.text isValidMobileNumber] ? [self.emailOrMobileNumberField.text validatedMobileNumber] : nil;
    if (email) {
        [self startActivityIndicator];
        [self.loadingIndicator startAnimating];
        [self.userRegistrationHandler forgotPasswordForEmail:email];
    } else if(mobileNumber) {
        [self startActivityIndicator];
        [self.loadingIndicator startAnimating];
        [self.userRegistrationHandler verificationCodeToResetPassword:mobileNumber];
    } else {
        [self performSegueWithIdentifier:kForgotPassowordStoryBoardSegue sender:nil];
    }
}
    
    
- (void)createMyPhilipsAccount {
    DIRInfoLog(@"%@.createMyPhilipsAccount clicked", kRegistrationSignin);
    URCreateAccountViewController *createAccountViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationCreateAccountViewController"];
    
    if ([self navigationControllerContainsClass:[createAccountViewController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self.navigationController pushViewController:createAccountViewController animated:YES];
}
    
    
- (BOOL)inputFieldsValid {
    return (self.validEmail && self.validPassword);
}


- (void)validateTextField:(UITextField*)textField {
    [super validateTextField:textField];
    [self validateTextField:textField forceError:NO];
}


- (void)validateTextField:(UITextField *)textField forceError:(BOOL)forceError {
    if(textField == self.emailOrMobileNumberField) {
        self.validEmail = (self.loginFlowType == RegistrationLoginFlowTypeMobile) ? [self.emailOrMobileNumberField validateEmailOrMobileNumberContentAndDisplayError:forceError]:[self.emailOrMobileNumberField validateEmailContentAndDisplayError:forceError];
    } else if(textField == self.passwordField) {
        self.validPassword = [self.passwordField validateSignInPasswordAndDisplayError:YES];
    }
    self.loginButton.enabled = ([self inputFieldsValid] && self.connectionAvailable);
}


- (void)textFieldPressedGo:(UITextField *)textField {
    if([self inputFieldsValid]) [self userLogIn:nil];
}


- (void)toggleBtn:(BOOL)enable {
    self.loginButton.enabled = [self inputFieldsValid] && enable;
    self.forgotPasswordLinkTextLabel.enabled = enable;
    self.createAccountLinkTextLabel.enabled = enable;
}

- (void)loginFailedErroHandler:(NSError*) error {
    if (error.code == DINotVerifiedEmailErrorCode) {
        [self performSegueWithIdentifier:kRegistrationVerifyEmailSegue sender:nil];
    } else if (error.code == DINotVerifiedMobileErrorCode) {
        URVerifySMSViewController *urVerifySMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"verifySMSController"];
        urVerifySMSViewController.enterCodeFlowType = EnterCodeFlowTypeVerification;
        [self.navigationController pushViewController:urVerifySMSViewController animated:YES];
    } else {
        [self showNotificationBarErrorViewWithTitle:error.localizedDescription];
    }
}


- (void)updateBottomViewConstraints {
    CGFloat viewHeight = self.view.frame.size.height;
    CGFloat bottomViewHeight = self.backgroundView.frame.size.height;
    if (viewHeight >= bottomViewHeight) {
        [NSLayoutConstraint activateConstraints:@[self.placeholderConstraint]];
    } else {
        [NSLayoutConstraint deactivateConstraints:@[self.placeholderConstraint]];
    }
}

-(BOOL)isPersonalConsentViewToBeShown {
    URLaunchInput *launchInput = URSettingsWrapper.sharedInstance.launchInput;
    if ([launchInput isPersonalConsentToBeShown] != true) {
        return false;
    }
    return (launchInput.registrationFlowConfiguration.userPersonalConsentStatus == ConsentStatesInactive);
}


- (void)verifyConditionsAndNavigateToNextScreen:(DIUser *)profile {
    URReceiveMarketingFlow flow = [URSettingsWrapper sharedInstance].experience;
     BOOL isReceiveMarketingReqd = (((flow == URReceiveMarketingFlowCustomOptin) || (flow == URReceiveMarketingFlowSkipOptin)) == true) ?
     false : !profile.receiveMarketingEmails;
    if (self.loginFlowType == RegistrationLoginFlowTypeMobile && self.userRegistrationHandler.email && !self.userRegistrationHandler.isEmailVerified) {
        [self performSegueWithIdentifier:kRegistrationVerifyEmailSegue sender:nil];
    } else if (([URSettingsWrapper sharedInstance].isTermsAndConditionsRequired && ![RegistrationUtility hasUserAcceptedTermsnConditions:profile.userIdentifier]) || isReceiveMarketingReqd || [self isPersonalConsentViewToBeShown]) {
        [self performSegueWithIdentifier:kTermsAndConditionsViewControllerSegue sender:nil];
    }  else {
        [self popOutOfRegistrationViewControllersWithError:nil];
    }
}


- (void)handleForgotPasswordOrResendEmailFailed:(nonnull NSError *)error {
    self.emailOrMobileNumberField.enabled = YES;
    if (error.code == DIInvalidFieldsErrorCode) {
        [self.emailOrMobileNumberField setValidationMessage:error.localizedDescription];
        [self.emailOrMobileNumberField setValidationView:YES];
    } else {
        [self showNotificationBarErrorViewWithTitle:error.localizedDescription];
    }
}

#pragma mark - UITextFieldDelegate Methods
#pragma mark -

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
    [self validateTextField:textField forceError:YES];
}

#pragma mark IBActions

- (IBAction)userLogIn:(UIDProgressButton *)sender {
    DIRInfoLog(@"%@.userLogIn clicked", kRegistrationSignin);
    [self tapGestureAction:nil];
    [self removeTextFieldErrors];
    self.emailOrMobileNumberField.text = [self.emailOrMobileNumberField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(self.userRegistrationHandler) {
        [self hideNotificationBarErrorView];
        [self startActivityIndicator];
        [sender setIsActivityIndicatorVisible:YES];
        sender.progressTitle = LOCALIZE(@"USR_DLS_SigIn_TitleTxt");
        NSString *email = [self.emailOrMobileNumberField.text isValidEmail] ? self.emailOrMobileNumberField.text : nil;
        NSString *mobileNumber = [self.emailOrMobileNumberField.text isValidMobileNumber] ? [self.emailOrMobileNumberField.text validatedMobileNumber] : nil;
        [self.userRegistrationHandler loginUsingTraditionalWithEmail:(mobileNumber == nil ? email : mobileNumber) password:self.passwordField.text];
    }
}


#pragma mark Gesture Action

- (IBAction)tapGestureAction:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - UserRegistrationDelegate

- (void)didLoginWithSuccessWithUser:(DIUser *)profile {
    [super didLoginWithSuccessWithUser:profile];
    [self.loginButton setIsActivityIndicatorVisible:NO];
    [self verifyConditionsAndNavigateToNextScreen:profile];
}


- (void)didLoginFailedwithError:(NSError *)error {
    [super didLoginFailedwithError:error];
    [self.loginButton setIsActivityIndicatorVisible:NO];
    [self loginFailedErroHandler:error];
}


#pragma mark Navigation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self updateBottomViewConstraints];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {}];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:kTermsAndConditionsViewControllerSegue]) {
        URAlmostDoneViewController *registrationVerificationVC= segue.destinationViewController;
        registrationVerificationVC.almostDoneFlowType = URAlmostDoneFlowTypeTraditionalLogIn;
    } else if ([segue.identifier isEqualToString:kForgotPassowordStoryBoardSegue]) {
        URForgotPasswordViewController *forgotPasswordVC = segue.destinationViewController;
        BOOL isValidEmail = (self.loginFlowType == RegistrationLoginFlowTypeMobile)?[self.emailOrMobileNumberField validateEmailOrMobileNumberContentAndDisplayError:YES]:[self.emailOrMobileNumberField validateEmailContentAndDisplayError:YES];
        if (isValidEmail) {
            forgotPasswordVC.emailAddress = self.emailOrMobileNumberField.text;
        }
    } else if ([segue.identifier isEqualToString:kRegistrationForgotPasswordShowActivationSegue]) {
        NSString *mobileNumber = [self.emailOrMobileNumberField.text validatedMobileNumber];
        URVerifySMSViewController *urVerifySMSViewController = segue.destinationViewController;
        urVerifySMSViewController.mobileNumber = mobileNumber;
        urVerifySMSViewController.enterCodeFlowType = EnterCodeFlowTypeReset;
        urVerifySMSViewController.mobileResetToken = self.mobileResetToken;
    }
}


#pragma mark - Connection Status

- (void)updateConnectionStatus:(BOOL) connectionAvailable {
    [super updateConnectionStatus:connectionAvailable];
    [self toggleBtn:connectionAvailable];
}

#pragma mark -
#pragma mark - UserRegistrationDelegate

- (void)didSendForgotPasswordSuccess {
    [super didSendForgotPasswordSuccess];
    UIDAlertController *alertVC = [self forgotPasswordSuccessAlert];
    UIDAction *okAction = [[UIDAction alloc] initWithTitle:LOCALIZE(@"USR_DLS_Button_Title_Ok") style:UIDActionStylePrimary handler:^(UIDAction * _Nonnull action) {
        [DIRegistrationAppTagging trackActionWithInfo:kRegSendData params:@{kRegStatusNotificationResponse:kRegOK}];
    }];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    [self.loadingIndicator stopAnimating];
    self.forgotPasswordLinkTextLabel.enabled = YES;
}


- (void)didSendForgotPasswordFailedwithError:(NSError *)error {
    [super didSendForgotPasswordFailedwithError:error];
    [self.loadingIndicator stopAnimating];
    [self handleForgotPasswordOrResendEmailFailed: error];
}


- (void)didVerificationForMobileToResetPasswordSuccessWithToken:(NSString *)resetToken {
    [super didVerificationForMobileToResetPasswordSuccessWithToken:resetToken];
    [self.loadingIndicator stopAnimating];
    self.emailOrMobileNumberField.enabled = YES;
    self.mobileResetToken = resetToken;
    [self performSegueWithIdentifier:kRegistrationForgotPasswordShowActivationSegue sender:nil];
}

- (void)didVerificationForMobileToResetPasswordFailedwithError:(nonnull NSError *)error {
    [super didVerificationForMobileToResetPasswordFailedwithError:error];
    [self.loadingIndicator stopAnimating];
    [self handleForgotPasswordOrResendEmailFailed: error];
}

@end
