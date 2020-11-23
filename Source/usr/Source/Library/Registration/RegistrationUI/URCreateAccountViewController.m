//
//  URCreateAccountViewController.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "URCreateAccountViewController.h"
#import "UITextView+HighlightText.h"
#import "URLogInViewController.h"
#import "URVerifySMSViewController.h"

static NSString *const kTermAndConditionsAcceptanceErrorText = @"USR_DLS_TermsAndConditionsAcceptanceText_Error";
static NSInteger const PasswordStrengthMedium = 3;
static NSInteger const PasswordStrengthStrong = 4;

@interface URCreateAccountViewController ()<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UIDLabel                    *emailOrMobileNumberLabel;
@property (nonatomic, weak) IBOutlet UIDLabel                    *passwordHintLabel;
@property (nonatomic, weak) IBOutlet UIDLabel                    *passwordStrengthLabel;
@property (nonatomic, weak) IBOutlet UIDProgressButton           *createAccountButton;
@property (nonatomic, weak) IBOutlet UIDTextField                *firstNameField;
@property (nonatomic, weak) IBOutlet UIDTextField                *lastNameField;
@property (nonatomic, weak) IBOutlet UIDTextField                *emailOrMobileNumberField;
@property (nonatomic, weak) IBOutlet UIDPasswordField            *passwordField;
@property (nonatomic, weak) IBOutlet UITextView                  *termsAndConditionsTextView;
@property (nonatomic, weak) IBOutlet UITextView                  *marketingOptInDetailsTextView;
@property (nonatomic, weak) IBOutlet UITextView                  *urConsentTextView;
@property (nonatomic, weak) IBOutlet UIDCheckBox                 *marketingOptInCheckBox;
@property (nonatomic, weak) IBOutlet UIDCheckBox                 *termsAndConditionsCheckBox;
@property (nonatomic, weak) IBOutlet UIDCheckBox                 *urConsentCheckBox;
@property (nonatomic, weak) IBOutlet UIStackView                 *marketingStackView;
@property (nonatomic, weak) IBOutlet UIStackView                 *urConsentStackView;
@property (nonatomic, weak) IBOutlet UIStackView                 *termsAndConditionsStackView;
@property (nonatomic, weak) IBOutlet UIStackView                 *passwordStrengthStackView;
@property (nonatomic, weak) IBOutlet UIStackView                 *lastNameStackView;
@property (nonatomic, weak) IBOutlet UIView                      *passwordHintBGView;
@property (nonatomic, weak) IBOutlet UIDProgressIndicator        *passwordStrengthProgressBar;
@property (nonatomic, weak) IBOutlet UIDInlineDataValidationView *termsAndConditionsAlert;
@property (nonatomic, weak) IBOutlet UIDInlineDataValidationView *userConsentAlert;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint          *passwordHintTopConstraint;

@property (nonatomic, strong) NSDate *creationStartedAt;
@property (nonatomic, assign) BOOL   validFirstName;
@property (nonatomic, assign) BOOL   validLastName;
@property (nonatomic, assign) BOOL   validEmailORMobileNumber;
@property (nonatomic, assign) BOOL   validPassword;

@end

@implementation URCreateAccountViewController

#pragma mark - UIViewController LifyCycle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALIZE(@"USR_DLS_URCreateAccount_NavTitle");
    [self loadLastNameStackView];
    [self loadTermsAndConditionsView];
    [self loadMarketingOptInView];
    [self checkAndUpdateRTLTextFields];
    [self loadURConsentView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [DIRegistrationAppTagging trackPageWithInfo:kRegistrationCreateaccount paramKey:nil andParamValue:nil];
    DIRInfoLog(@"Screen name is %@", kRegistrationCreateaccount);
    [self trackingABTesting];
    [self.createAccountButton setEnabled:[self shouldEnableCreateButton]];
    self.creationStartedAt = [NSDate date];
    if (self.loginFlowType == RegistrationLoginFlowTypeMobile) {
        self.emailOrMobileNumberLabel.text = LOCALIZE(@"USR_DLS_Phonenumber_Label_Text");
    } else {
        self.emailOrMobileNumberLabel.text = LOCALIZE(@"USR_DLS_Email_Label_Text");
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.firstNameField becomeFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.passwordField isFirstResponder]) {
        [self.passwordField resignFirstResponder];
    }
    [self.termsAndConditionsAlert setHidden:YES];
    [self.userConsentAlert setHidden:YES];
}

#pragma mark - Custom Methods
#pragma mark -

- (void)updatePasswordStrengthView:(NSInteger)strength {
    [self.passwordField validatePasswordContentAndDisplayError];
    [self.passwordStrengthProgressBar setHidden:NO];
    CGFloat progressLength =  (CGFloat)strength/4.0;
    [self.passwordStrengthProgressBar setProgress:progressLength];
    if (strength >= PasswordStrengthStrong) {
        [self.passwordHintLabel setText:@""];
        self.passwordHintTopConstraint.constant = 0;
        [self.passwordStrengthStackView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self.passwordStrengthStackView setLayoutMarginsRelativeArrangement:NO];
        [self.passwordStrengthLabel setText:LOCALIZE(@"USR_Password_Strength_Strong")];
        self.passwordStrengthLabel.textColor = [[self passwordStrongTheme] trackDetailOnBackground];
        self.passwordStrengthProgressBar.theme = [self passwordStrongTheme];
    } else {
        [self.passwordHintLabel setText:LOCALIZE(@"USR_Password_Guidelines")];
        self.passwordHintTopConstraint.constant = 16;
        [self.passwordStrengthStackView setLayoutMargins:UIEdgeInsetsMake(16, 0, 16, 0)];
        [self.passwordStrengthStackView setLayoutMarginsRelativeArrangement:YES];
        [self.passwordStrengthLabel setText: strength == PasswordStrengthMedium ? LOCALIZE(@"USR_Password_Strength_Medium") : LOCALIZE(@"USR_Password_Strength_Weak")];
        [self.passwordHintBGView setBackgroundColor: strength == PasswordStrengthMedium ? [[self passwordMediumTheme] trackDetailOffBackground] : [[self passwordWeakTheme] trackDetailOffBackground]];
        self.passwordStrengthProgressBar.theme = strength == PasswordStrengthMedium ? [self passwordMediumTheme] : [self passwordWeakTheme];
        self.passwordStrengthLabel.textColor = strength == PasswordStrengthMedium ? [[self passwordMediumTheme] trackDetailOnBackground] : [[self passwordWeakTheme] trackDetailOnBackground];
    }
    [self.passwordStrengthStackView arrangedSubviews];
    [self.scrollView layoutIfNeeded];
}


- (UIDTheme *)passwordWeakTheme {
    UIDThemeConfiguration *themeConfig = [[UIDThemeConfiguration alloc]initWithColorRange:UIDColorRangeSignalRed tonalRange:UIDTonalRangeUltraLight];
    UIDTheme *theme = [[UIDTheme alloc] initWithThemeConfiguration:themeConfig];
    return theme;
}


- (UIDTheme *)passwordMediumTheme {
    UIDThemeConfiguration *themeConfig = [[UIDThemeConfiguration alloc]initWithColorRange:UIDColorRangeSignalYellow tonalRange:UIDTonalRangeUltraLight];
    UIDTheme *theme = [[UIDTheme alloc] initWithThemeConfiguration:themeConfig];
    return theme;
}


- (UIDTheme *)passwordStrongTheme {
    UIDThemeConfiguration *themeConfig = [[UIDThemeConfiguration alloc]initWithColorRange:UIDColorRangeSignalLime tonalRange:UIDTonalRangeVeryLight];
    UIDTheme *theme = [[UIDTheme alloc] initWithThemeConfiguration:themeConfig];
    return theme;
}

- (void)checkAndUpdateRTLTextFields {
    [_emailOrMobileNumberField checkAndUpdateTextFieldToRTL];
    [_firstNameField checkAndUpdateTextFieldToRTL];
    [_lastNameField checkAndUpdateTextFieldToRTL];
}


- (void)loadMarketingOptInView {
    URReceiveMarketingFlow flow = [URSettingsWrapper sharedInstance].experience;
    if ((flow == URReceiveMarketingFlowSplitSignUp) || (flow == URReceiveMarketingFlowCustomOptin) || (flow == URReceiveMarketingFlowSkipOptin)){
        self.marketingStackView.hidden = YES;
    } else {
        self.marketingStackView.hidden = NO;
        [self.marketingOptInDetailsTextView setContentInset:UIEdgeInsetsMake(-7, 0, 0, 0)];
        [self.marketingOptInDetailsTextView setAttributedText:[NSString stringWithFormat: @"%@\n%@   ",LOCALIZE(@"USR_DLS_OptIn_Promotional_Message_Line1"),LOCALIZE(@"USR_Receive_Philips_News_Meaning_lbltxt")] highlitedKeyWords:@{LOCALIZE(@"USR_Receive_Philips_News_Meaning_lbltxt") : kLoadPhilipsNewsURLDummy} color:[UIDThemeManager sharedInstance].defaultTheme.labelValueText];
        [self.scrollView layoutIfNeeded];
    }
}

- (void)loadURConsentView {
        // Configuration has to be true and user consent state has to be inactive.
    if ([self isPersonalConsentShown] == false) {
        self.urConsentStackView.hidden = true;
        return;
    }
    URLaunchInput *launchInput = URSettingsWrapper.sharedInstance.launchInput;
    NSString *consentText = launchInput.registrationContentConfiguration.personalConsent.text;
    [self.urConsentTextView setContentInset:UIEdgeInsetsMake(-7, 0, 0, 0)];
    [self.urConsentTextView setAttributedText:[NSString stringWithFormat: @"%@\n%@   ",consentText,LOCALIZE(@"USR_Receive_Philips_News_Meaning_lbltxt")] highlitedKeyWords:@{LOCALIZE(@"USR_Receive_Philips_News_Meaning_lbltxt") : kPersonalConsentURL} color:[UIDThemeManager sharedInstance].defaultTheme.labelValueText];
    [self.scrollView layoutIfNeeded];
}


- (void)loadLastNameStackView {
    if ([URSettingsWrapper sharedInstance].launchInput.registrationFlowConfiguration.enableLastName) {
        self.lastNameStackView.hidden = NO;
    } else {
        self.validLastName = YES;
    }
    [self.scrollView layoutIfNeeded];
}


- (void)loadTermsAndConditionsView {
    if (([URSettingsWrapper sharedInstance].isTermsAndConditionsRequired)) {
        self.termsAndConditionsStackView.hidden = NO;
        NSString *termsAndConditionsString = [NSString stringWithFormat:LOCALIZE(@"USR_DLS_TermsAndConditionsAcceptanceText"),LOCALIZE(@"USR_DLS_TermsAndConditionsText")];
        [self.termsAndConditionsTextView setAttributedText:termsAndConditionsString highlitedKeyWords:@{LOCALIZE(@"USR_DLS_TermsAndConditionsText") : kTermAndConditionsUrl} color:[UIDThemeManager sharedInstance].defaultTheme.labelValueText];
    } else {
        self.termsAndConditionsStackView.hidden = YES;
    }
    [self.termsAndConditionsTextView setContentInset:UIEdgeInsetsMake(-7, 0, 0, 0)];
    [self.scrollView layoutIfNeeded];
}


- (void)showTextFieldErrorForUsedEmailORMobile:(BOOL)isMobileNumber {
    NSString *errorDescription = isMobileNumber ? [NSString stringWithFormat:LOCALIZE(@"USR_Janrain_EntityAlreadyExists_ErrorMsg"), LOCALIZE(@"USR_DLS_Phonenumber_Label_Text")] : [NSString stringWithFormat:LOCALIZE(@"USR_Janrain_EntityAlreadyExists_ErrorMsg"), LOCALIZE(@"USR_DLS_Email_Label_Text")];
    [self.emailOrMobileNumberField setValidationMessage:errorDescription];
    [self.emailOrMobileNumberField setValidationView:YES animated:YES];
}


- (void)navigateToScreenOnRegisterSuccess {
    URReceiveMarketingFlow flow = [URSettingsWrapper sharedInstance].experience;
    if (flow == URReceiveMarketingFlowSplitSignUp) {
        DIRInfoLog(@"Screen navigation to %@", kOptInViewControllerSegue);
        [self performSegueWithIdentifier:kOptInViewControllerSegue sender:nil];
    }else if (flow == URReceiveMarketingFlowCustomOptin) { // If custom optin flow call back to proposition to show custom screen
        [self popOutOfRegistrationViewControllersWithError:nil];
    }else {
        [self verifyAndNavigateToScreen];
    }
}


- (void)verifyAndNavigateToScreen {
    if ([self.emailOrMobileNumberField.text isValidEmail]) {
        DIRInfoLog(@"Screen navigation to %@", kRegistrationVerifyEmailSegue);
        [self performSegueWithIdentifier:kRegistrationVerifyEmailSegue sender:nil];
    } else {
        DIRInfoLog(@"Screen navigation to %@", kRegistrationShowAccountActivationSegue);
        [self performSegueWithIdentifier:kRegistrationShowAccountActivationSegue sender:nil];
    }
}


- (BOOL)isAcceptedTermsAndConditionsIfApplicable {
    if ([URSettingsWrapper sharedInstance].isTermsAndConditionsRequired) {
        return [self layoutTermsAndConditionsValidationView];
    }
    [self.scrollView layoutIfNeeded];
    return YES;
}


-(BOOL)isPersonalConsentShown {
    URLaunchInput *launchInput = [URSettingsWrapper sharedInstance].launchInput;
    BOOL usrConsentStatus = [launchInput isPersonalConsentToBeShown];
    if (usrConsentStatus == false) {
        self.urConsentStackView.hidden = true;
        return false;
    }
    return true;
}

-(void)updatePersonalConsentTag {
    if ([self isPersonalConsentShown] != true) {
        return;
    }
    NSString *consentTagAction = (self.urConsentCheckBox.isChecked) ? kRegPersonalConsentOptin : kRegPersonalConsentOptOut;
    [DIRegistrationAppTagging trackActionWithInfo:consentTagAction paramKey:nil andParamValue:nil];
}

- (BOOL)isUserDataConsentIsGiven {
    if ([self isPersonalConsentShown] == true) {
        return [self layoutUserDataConsentView];
    }
    [self.scrollView layoutIfNeeded];
    return YES;
}


- (BOOL)inputFieldsValid {
    return (self.validFirstName && self.validLastName && self.validEmailORMobileNumber && self.validPassword);
}


- (void)textFieldPressedGo:(UITextField *)textField {
    if([self inputFieldsValid]) {
        [self createMyPhilipsAccount:nil];   
    }
}


- (void)toggleBtn:(BOOL)enable {
    [self.createAccountButton setEnabled:[self shouldEnableCreateButton]];
}

- (BOOL)layoutTermsAndConditionsValidationView {
    if (self.termsAndConditionsCheckBox.isChecked) {
        [self.termsAndConditionsAlert setHidden:YES];
    } else {
        [self.termsAndConditionsAlert setHidden:NO];
        [self.termsAndConditionsAlert setValidationMessage:LOCALIZE(kTermAndConditionsAcceptanceErrorText)];;
    }
    return self.termsAndConditionsCheckBox.isChecked;
}

- (BOOL)layoutUserDataConsentView {
    if (self.urConsentCheckBox.isChecked) {
        [self.userConsentAlert setHidden:YES];
    } else {
        [self.userConsentAlert setHidden:NO];
        NSString *errorMssg = URSettingsWrapper.sharedInstance.launchInput.registrationContentConfiguration.personalConsentErrMssge;
        [self.userConsentAlert setValidationMessage:errorMssg];
    }
    return self.urConsentCheckBox.isChecked;
}


#pragma mark - User Registration Delegates
#pragma mark -

- (void)didRegisterSuccessWithUser:(DIUser *)profile {
    [super didRegisterSuccessWithUser:profile];
    [self.createAccountButton setIsActivityIndicatorVisible:NO];
    URReceiveMarketingFlow flow = [URSettingsWrapper sharedInstance].experience;
    if ((flow == URReceiveMarketingFlowFromServer) || (flow == URReceiveMarketingFlowControl)) {
        [[URSettingsWrapper sharedInstance] tagMarketingConsentStatus:self.marketingOptInCheckBox.isChecked];
    }
    if (([URSettingsWrapper sharedInstance].isTermsAndConditionsRequired)) {
        [RegistrationUtility userAcceptedTermsnConditions:profile.userIdentifier];
        [self updatePersonalConsentTag];
        [DIRegistrationAppTagging trackActionWithInfo:kRegAcceptTermsAndConditionsOptin paramKey:nil andParamValue:nil];
    }
    if ([self isPersonalConsentShown] == true) {
        [self storePersonalConsent:self.urConsentCheckBox.isChecked];
    }
    [self navigateToScreenOnRegisterSuccess];
}


- (void)didRegisterFailedwithError:(NSError *)error {
    [super didRegisterFailedwithError:error];
    [self.createAccountButton setIsActivityIndicatorVisible:NO];
    switch (error.code) {
        case DIEmailAddressAlreadyInUse: {
            [self showTextFieldErrorForUsedEmailORMobile:NO];
            break;
        }
        case DIMobileNumberAlreadyInUse: {
            [self showTextFieldErrorForUsedEmailORMobile:YES];
            break;
        }
        case DIInvalidFieldsErrorCode: {
            [self showNotificationBarErrorViewWithTitle:error.localizedDescription ? error.localizedDescription : [NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), error.code]];
            break;
        }
        default: {
            [self showNotificationBarErrorViewWithTitle:LOCALIZE(@"USR_JanRain_Error_Check_Internet")];
            [self.createAccountButton setEnabled:[self shouldEnableCreateButton]];
            break;
        }
    }
    
}

#pragma mark - IBActions
#pragma mark -

- (IBAction)createMyPhilipsAccount:(UIDProgressButton *)sender {
    DIRInfoLog(@"%@.createMyPhilipsAccount clicked", kRegistrationCreateaccount);
    
    if (![self isAcceptedTermsAndConditionsIfApplicable]) {
        //Check to show the message if personal consent is present.
        [self isUserDataConsentIsGiven];
        return;
    }

    //If Personal consent not given
    if (![self isUserDataConsentIsGiven]) {
        return;
    }
    
    [self tapOutsideTextFields:nil];
    [self removeTextFieldErrors];
    self.createAccountButton.enabled = NO;
    
    [self startActivityIndicator];
    [sender setIsActivityIndicatorVisible:YES];
    sender.progressTitle = LOCALIZE(@"USR_DLS_Create_Account_CreateMyPhilips_btntxt");
    self.emailOrMobileNumberField.text = [self.emailOrMobileNumberField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *email = [self.emailOrMobileNumberField.text isValidEmail] ? self.emailOrMobileNumberField.text : nil;
    NSString *mobileNumber = [self.emailOrMobileNumberField.text isValidMobileNumber] ? [self.emailOrMobileNumberField.text validatedMobileNumber] : nil;
    [self updatePersonalConsentTag];
    [self.userRegistrationHandler registerNewUserUsingTraditional:email withMobileNumber:mobileNumber withFirstName:self.firstNameField.text withLastName:self.lastNameField.text withOlderThanAgeLimit:YES withReceiveMarketingMails:self.marketingOptInCheckBox.isChecked withPassword:self.passwordField.text];
}


- (IBAction)switchToLogin:(id)sender {
    DIRInfoLog(@"navigate to screen WelcomeViewController");
    URLogInViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    if ([self navigationControllerContainsClass:[loginViewController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self.navigationController pushViewController:loginViewController animated:YES];
}


- (IBAction)tapOutsideTextFields:(id)sender {
    [self.view endEditing:YES];
}


- (IBAction)acceptTermsAndConditions:(id)sender {
    DIRInfoLog(@"%@.acceptTermsAndConditions clicked", kRegistrationCreateaccount);
    [self layoutTermsAndConditionsValidationView];
    [self.createAccountButton setEnabled:[self shouldEnableCreateButton]];
    [self.scrollView layoutIfNeeded];
}

- (IBAction)userConsentCheckBoxClicked:(id)sender {
    DIRInfoLog(@"%@.userConsentCheckBoxClicked clicked", kRegistrationCreateaccount);
    [self layoutUserDataConsentView];
    [self.createAccountButton setEnabled:[self shouldEnableCreateButton]];
    [self.scrollView layoutIfNeeded];
}


- (IBAction)validateTextField:(UIDTextField*)textField {
    [super validateTextField:textField];
    [self validateTextField:textField forceError:NO];
}


- (void)validateTextField:(UITextField *)textField forceError:(BOOL)forceError {
    if (textField == self.firstNameField) {
        self.validFirstName = [self.firstNameField validateNameContent:@"firstName" displayError:forceError];
    } else if (textField == self.lastNameField) {
        self.validLastName = [self.lastNameField validateNameContent:@"lastName" displayError:forceError];
    } else if (textField == self.emailOrMobileNumberField) {
        self.validEmailORMobileNumber= (self.loginFlowType == RegistrationLoginFlowTypeMobile) ? [self.emailOrMobileNumberField validatePhoneNumberContentAndDisplayError:forceError] : [self.emailOrMobileNumberField validateEmailContentAndDisplayError:forceError];
    } else if (textField == self.passwordField) {
        NSInteger strength = [RegistrationUtility passwordStrength:textField.text];
        self.validPassword = (strength >= PasswordStrengthStrong);
        [self updatePasswordStrengthView:strength];
    }
    [self.createAccountButton setEnabled:[self shouldEnableCreateButton]];
}

-(BOOL)shouldEnableCreateButton {
    return [self inputFieldsValid];
}

#pragma mark - UITextFieldDelegate Methods
#pragma mark -

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
    [self validateTextField:textField forceError:YES];
}

#pragma mark - Navigation
#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:kRegistrationShowAccountActivationSegue]) {
        URVerifySMSViewController *urVerifySMSViewController = segue.destinationViewController;
        urVerifySMSViewController.enterCodeFlowType = EnterCodeFlowTypeVerification;
    }
}

#pragma mark - Reachability Status
#pragma mark -

- (void)updateConnectionStatus:(BOOL)connectionAvailable {
    [super updateConnectionStatus:connectionAvailable];
    [self toggleBtn:connectionAvailable];
}

@end
