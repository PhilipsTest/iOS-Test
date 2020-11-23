//
//  URAlmostDoneViewController.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "URAlmostDoneViewController.h"
#import "UITextView+HighlightText.h"
#import "DIUser+PrivateData.h"

@interface URAlmostDoneViewController ()<UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UIDLabel                    *emailOrMobileNumberLabel;
@property (nonatomic, weak) IBOutlet UIDLabel                    *descriptionLabel;
@property (nonatomic, weak) IBOutlet UIDProgressButton           *continueButton;
@property (nonatomic, weak) IBOutlet UIDTextField                *emailOrMobileNumberField;
@property (nonatomic, weak) IBOutlet UITextView                  *marketingOptInDetailsTextView;
@property (nonatomic, weak) IBOutlet UITextView                  *urConsentOptInDetailsTextView;
@property (nonatomic, weak) IBOutlet UITextView                  *termsAndConditionsTextView;
@property (nonatomic, weak) IBOutlet UIDCheckBox                 *marketingOptInCheckBox;
@property (nonatomic, weak) IBOutlet UIDCheckBox                 *urConsentOptInCheckBox;
@property (nonatomic, weak) IBOutlet UIDCheckBox                 *termsAndConditionsCheckBox;
@property (nonatomic, weak) IBOutlet UIStackView                 *marketingStackView;
@property (nonatomic, weak) IBOutlet UIStackView                 *urConsentStackView;
@property (nonatomic, weak) IBOutlet UIStackView                 *emailOrMobileNumberFieldStackView;
@property (nonatomic, weak) IBOutlet UIStackView                 *termsAndConditionsStackView;
@property (nonatomic, weak) IBOutlet UIDInlineDataValidationView *termsAndConditionsAlert;
@property (weak, nonatomic) IBOutlet UIDInlineDataValidationView *consentAlert;

@property (nonatomic, assign) BOOL validEmailORPhoneNumber;
@property (nonatomic, assign) BOOL isScreenNavigationNoClearData;

@end

@implementation URAlmostDoneViewController

#pragma mark - UIViewController LifyCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALIZE(@"USR_DLS_SigIn_TitleTxt");
    [_emailOrMobileNumberField checkAndUpdateTextFieldToRTL];
    self.continueButton.enabled = false;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self trackingABTesting];
    self.isScreenNavigationNoClearData = false;
    [self initializeWithUserInfo];
    [DIRegistrationAppTagging trackPageWithInfo:kRegistrationAlmostDone paramKey:nil andParamValue:nil];
    DIRInfoLog(@"Screen name is %@", kRegistrationAlmostDone);
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //Hide alerts if its visible
    [self.termsAndConditionsAlert setHidden:YES];
    [self.consentAlert setHidden:YES];
}



#pragma mark IBActions

- (IBAction)acceptTermsAndConditions:(id)sender {
    DIRInfoLog(@"%@.acceptTermsAndConditions clicked", kRegistrationAlmostDone);
    [self layoutTermsAndConditionsValidationView];
    [self.scrollView layoutIfNeeded];
}

- (IBAction)consentBoxChecked:(id)sender {
    DIRInfoLog(@"%@.consent box clicked", kRegistrationAlmostDone);
    [self layoutPersonalConsentView];
    [self.scrollView layoutIfNeeded];
}


- (IBAction)continueAction:(UIDProgressButton *)sender {
    DIRInfoLog(@"%@.continueAction clicked", kRegistrationAlmostDone);
    if (![self isAcceptedTermsAndConditionsIfApplicable]) {
        [self isPersonalConsentAccepted];
        [DIRegistrationAppTagging trackActionWithInfo:kRegAcceptTermsAndConditionsOptOut paramKey:nil andParamValue:nil];
        return;
    }
    
    if (![self isPersonalConsentAccepted]) {
        [self updatePersonalConsentTag];
        return;
    }

    [self tapGestureAction:nil];
    [self removeTextFieldErrors];
    [self updatePersonalConsentTag];
    [self updatePersonalConsent];
    if (self.almostDoneFlowType == URAlmostDoneFlowTypeSocialRegistration) {
        NSString *email;
        NSString *mobileNumber;
        if (self.userRegistrationHandler.userIdentifier.length > 0) {
            email = self.userRegistrationHandler.email;
            mobileNumber = [self.userRegistrationHandler.mobileNumber validatedMobileNumber];
        } else {
            self.emailOrMobileNumberField.text = [self.emailOrMobileNumberField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([self.emailOrMobileNumberField.text isValidEmail]) {
                email = self.emailOrMobileNumberField.text;
            }
            if ([self.emailOrMobileNumberField.text isValidMobileNumber]) {
                mobileNumber = [self.emailOrMobileNumberField.text validatedMobileNumber];
            }
        }
        [RegistrationUtility userAcceptedTermsnConditions:(mobileNumber.length > 0) ? mobileNumber : email];
        [DIRegistrationAppTagging trackActionWithInfo:kRegAcceptTermsAndConditionsOptin paramKey:nil andParamValue:nil];
        [sender setIsActivityIndicatorVisible:YES];
        sender.progressTitle = LOCALIZE(@"USR_Continue_Btntxt");
        [self startActivityIndicator];
        [self.userRegistrationHandler completeSocialProviderLoginWithEmail:email withMobileNumber:mobileNumber withOlderThanAgeLimit:YES withReceiveMarketingMails:self.marketingOptInCheckBox.isChecked];
        [self sendTagForReceivingMarketingMails];
    } else {
        if ([self shouldShowTermsAndConditions]) {
            [RegistrationUtility userAcceptedTermsnConditions:self.userRegistrationHandler.userIdentifier];
            [DIRegistrationAppTagging trackActionWithInfo:kRegAcceptTermsAndConditionsOptin paramKey:nil andParamValue:nil];
        }
        if (!self.userRegistrationHandler.receiveMarketingEmails) {
            [sender setIsActivityIndicatorVisible:YES];
            sender.progressTitle = LOCALIZE(@"USR_Continue_Btntxt");
            [self startActivityIndicator];
            [self.userRegistrationHandler updateReciveMarketingEmail:self.marketingOptInCheckBox.isChecked];
            [self sendTagForReceivingMarketingMails];
        } else {
            self.isScreenNavigationNoClearData = true;
            [self popOutOfRegistrationViewControllersWithError:nil];
        }
    }
}

-(void)updatePersonalConsent {
        if ([self isPersonalConsentShown] != true) {
        return;
    }
    [self storePersonalConsent:self.urConsentOptInCheckBox.isChecked];
}

-(void)updatePersonalConsentTag {
    if ([self isPersonalConsentShown] != true) {
        return;
    }
    NSString *tagAction = (self.urConsentOptInCheckBox.isChecked) ? kRegPersonalConsentOptin : kRegPersonalConsentOptOut;
    [DIRegistrationAppTagging trackActionWithInfo:tagAction paramKey:nil andParamValue:nil];
}


- (IBAction)tapGestureAction:(id)sender {
    [self.emailOrMobileNumberField resignFirstResponder];
}


#pragma mark - Custom Methods

- (void)initializeWithUserInfo {
    [self updateEmailOrMobileNumberFieldStackView];
    [self updateTermsAndConditions];
    [self updateURConsentView];
    [self updateMarketingOptView];
    [self updateDescriptionLabelText];
    [self.scrollView layoutIfNeeded];
}


- (void)loadMarketingOptView:(BOOL)isABTestEnabled {
    NSString *marketingOptString = [NSString stringWithFormat: @"%@\n%@  ",LOCALIZE(@"USR_DLS_OptIn_Promotional_Message_Line1"),LOCALIZE(@"USR_Receive_Philips_News_Meaning_lbltxt")];
    [self.marketingOptInDetailsTextView setAttributedText:marketingOptString highlitedKeyWords:@{LOCALIZE(@"USR_Receive_Philips_News_Meaning_lbltxt") : kLoadPhilipsNewsURLDummy} color:[UIDThemeManager sharedInstance].defaultTheme.labelValueText];
    [self.marketingOptInDetailsTextView setContentInset:UIEdgeInsetsMake(-7, 0, 0, 0)];
    self.marketingOptInDetailsTextView.delegate = self;
    [self.scrollView layoutIfNeeded];
}


- (void)loadTermsAndConditionsView {
    NSString * termsAndConditionsString = [NSString stringWithFormat:LOCALIZE(@"USR_DLS_TermsAndConditionsAcceptanceText"),LOCALIZE(@"USR_DLS_TermsAndConditionsText")];
    [self.termsAndConditionsTextView setAttributedText:termsAndConditionsString highlitedKeyWords:@{LOCALIZE(@"USR_DLS_TermsAndConditionsText") : kTermAndConditionsUrl} color:[UIDThemeManager sharedInstance].defaultTheme.labelValueText];
    [self.termsAndConditionsTextView setContentInset:UIEdgeInsetsMake(-7, 0, 0, 0)];
    self.termsAndConditionsTextView.delegate = self;
    [self.scrollView layoutIfNeeded];
}


- (void)navigateToScreen:(BOOL)isMobileFlow {
    URReceiveMarketingFlow flow = [URSettingsWrapper sharedInstance].experience;
    if (flow == URReceiveMarketingFlowSplitSignUp) {
        [self performSegueWithIdentifier:kOptInViewControllerSegue sender:nil];
    } else if (flow == URReceiveMarketingFlowCustomOptin) {
            [self popOutOfRegistrationViewControllersWithError:nil];
    } else {
        isMobileFlow ? [self performSegueWithIdentifier:kRegistrationShowAccountActivationSegue sender:nil] : [self performSegueWithIdentifier:kRegistrationVerifyEmailSegue sender:nil];
    }
}


- (void)sendTagForReceivingMarketingMails {
    URReceiveMarketingFlow flow = [URSettingsWrapper sharedInstance].experience;
    if ((flow == URReceiveMarketingFlowSplitSignUp) || (flow == URReceiveMarketingFlowCustomOptin)) {
        return;
    }
    [[URSettingsWrapper sharedInstance] tagMarketingConsentStatus:self.marketingOptInCheckBox.isChecked];
}


- (BOOL)shouldShowMarketingOptView {
    URReceiveMarketingFlow flow = [URSettingsWrapper sharedInstance].experience;
    return !((flow == URReceiveMarketingFlowSplitSignUp) || (flow == URReceiveMarketingFlowCustomOptin) || (flow == URReceiveMarketingFlowSkipOptin));
}


- (BOOL)shouldShowTermsAndConditions {
    if (_almostDoneFlowType == URAlmostDoneFlowTypeSocialRegistration) {
        return true;
    }
    
    return [URSettingsWrapper sharedInstance].isTermsAndConditionsRequired && ![RegistrationUtility hasUserAcceptedTermsnConditions:self.userRegistrationHandler.userIdentifier];
}


- (void)updateEmailOrMobileNumberFieldStackView {
    if ((self.almostDoneFlowType == URAlmostDoneFlowTypeSocialRegistration) && !([self.userRegistrationHandler.userIdentifier isValidEmail]  || [self.userRegistrationHandler.userIdentifier isValidMobileNumber]) && !([self.providerName isEqualToString:kProviderNameApple])) {
        if (self.loginFlowType == RegistrationLoginFlowTypeMobile) {
            self.emailOrMobileNumberLabel.text = LOCALIZE(@"USR_DLS_Phonenumber_Label_Text");
        } else {
            self.emailOrMobileNumberLabel.text = LOCALIZE(@"USR_DLS_Email_Label_Text");
        }
        [self.emailOrMobileNumberFieldStackView setHidden:NO];
        [self.emailOrMobileNumberField addTarget:self action:@selector(validateTextField:) forControlEvents:UIControlEventEditingChanged];
        self.continueButton.enabled = NO;
        [self validateTextField:self.emailOrMobileNumberField];
    } else {
        [self.emailOrMobileNumberFieldStackView setHidden:YES];
        self.continueButton.enabled = YES;
    }
}

-(void)handleMarketingOptInViewShow {
    if ([self shouldShowMarketingOptView]) {
        [self.marketingStackView setHidden:NO];
        [self loadMarketingOptView:YES];
    } else {
        [self.marketingStackView setHidden:YES];
    }
}

-(void)handleNormalMarketingStack {
   
    if (self.userRegistrationHandler.receiveMarketingEmails || ([self isNoShowOptinFlow] == true)) {
        [self.marketingStackView setHidden:YES];
    } else {
        [self.marketingStackView setHidden:NO];
        [self loadMarketingOptView:NO];
    }
}

- (BOOL)isNoShowOptinFlow {
    URReceiveMarketingFlow flow = [URSettingsWrapper sharedInstance].experience;
    return ((flow == URReceiveMarketingFlowCustomOptin) || (flow == URReceiveMarketingFlowSkipOptin));
}

- (void)updateMarketingOptView {
    switch (self.almostDoneFlowType) {
        case URAlmostDoneFlowTypeSocialRegistration: {
            [self handleMarketingOptInViewShow];
            break;
        }
        case URAlmostDoneFlowTypeSocialLogIn: {
            if ([self isNoShowOptinFlow] == true) {
                [self handleMarketingOptInViewShow];
            } else {
                [self handleNormalMarketingStack];
            }
            break;
        }
        case URAlmostDoneFlowTypeTraditionalLogIn:
        default: {
            [self handleNormalMarketingStack];
            break;
        }
    }
}


- (void)updateDescriptionLabelText {
    [self.descriptionLabel setHidden:NO];
    if ((self.almostDoneFlowType == URAlmostDoneFlowTypeSocialRegistration) && !([self.userRegistrationHandler.userIdentifier isValidEmail]  || [self.userRegistrationHandler.userIdentifier isValidMobileNumber])) {
        NSString *emailOrMobileText = (self.loginFlowType == RegistrationLoginFlowTypeMobile) ? LOCALIZE(@"USR_DLS_Almost_Done_TextField_Mobile_Text") : LOCALIZE(@"USR_Email_address_TitleTxt");
        [self.descriptionLabel setText: [NSString stringWithFormat:LOCALIZE(@"USR_DLS_Almost_Done_TextField_Base_Text"), emailOrMobileText]];
    } else if (self.userRegistrationHandler.receiveMarketingEmails || ([self isNoShowOptinFlow] == true)) {
        [self.descriptionLabel setHidden:YES];
    } else {
        [self.descriptionLabel setText:LOCALIZE(@"USR_DLS_Almost_Done_Marketing_OptIn_Text")];
    }
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

- (void)updateURConsentView {
    
    if ([self isPersonalConsentShown] != true) {
        return;
    }
    
    URLaunchInput *launchInput = [URSettingsWrapper sharedInstance].launchInput;
    NSString *consentText = launchInput.registrationContentConfiguration.personalConsent.text;
    [self.urConsentStackView setHidden:NO];
    [self.urConsentOptInDetailsTextView setContentInset:UIEdgeInsetsMake(-7, 0, 0, 0)];
    [self.urConsentOptInDetailsTextView setAttributedText:[NSString stringWithFormat: @"%@\n%@   ",consentText,LOCALIZE(@"USR_Receive_Philips_News_Meaning_lbltxt")] highlitedKeyWords:@{LOCALIZE(@"USR_Receive_Philips_News_Meaning_lbltxt") : kPersonalConsentURL} color:[UIDThemeManager sharedInstance].defaultTheme.labelValueText];
    [self.scrollView layoutIfNeeded];
    
}

- (void)updateTermsAndConditions {
    if ([self shouldShowTermsAndConditions]) {
        [self.termsAndConditionsStackView setHidden:NO];
        [self loadTermsAndConditionsView];
    } else {
        [self.termsAndConditionsStackView setHidden:YES];
    }
}


- (void)validateTextField:(UITextField*)textField {
    [super validateTextField:textField];
    [self validateTextField:textField forcedError:NO];
}


- (void)validateTextField:(UITextField *)textField forcedError:(BOOL)forcedError {
    if (textField == self.emailOrMobileNumberField) {
        self.validEmailORPhoneNumber = (self.loginFlowType == RegistrationLoginFlowTypeMobile) ? [self.emailOrMobileNumberField validatePhoneNumberContentAndDisplayError:forcedError] : [self.emailOrMobileNumberField validateEmailContentAndDisplayError:forcedError];
    }
    self.continueButton.enabled = (self.validEmailORPhoneNumber && self.connectionAvailable);
}


- (BOOL)isAcceptedTermsAndConditionsIfApplicable {
    if ([self shouldShowTermsAndConditions]) {
        return [self layoutTermsAndConditionsValidationView];
    }
    return YES;
}

- (BOOL)isPersonalConsentAccepted {
    if ([self isPersonalConsentShown]) {
        return [self layoutPersonalConsentView];
    }
    return YES;
}

- (BOOL)layoutPersonalConsentView {
    if (self.urConsentOptInCheckBox.isChecked) {
        [self.consentAlert setHidden:YES];
    } else {
        URLaunchInput *launchInput = URSettingsWrapper.sharedInstance.launchInput;
        [self.consentAlert setHidden:NO];
        [self.consentAlert setValidationMessage:launchInput.registrationContentConfiguration.personalConsentErrMssge];
    }
    return self.urConsentOptInCheckBox.isChecked;
}


- (BOOL)layoutTermsAndConditionsValidationView {
    if (self.termsAndConditionsCheckBox.isChecked) {
        [self.termsAndConditionsAlert setHidden:YES];
    } else {
        [self.termsAndConditionsAlert setHidden:NO];
        [self.termsAndConditionsAlert setValidationMessage:LOCALIZE(@"USR_DLS_TermsAndConditionsAcceptanceText_Error")];
    }
    return self.termsAndConditionsCheckBox.isChecked;
}

#pragma mark - UITextViewDelegate Methods
#pragma mark -

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    self.isScreenNavigationNoClearData = true;
    BOOL shouldInteract = [super textView:textView shouldInteractWithURL:URL inRange:characterRange interaction:interaction];
    return shouldInteract;
}


#pragma mark - UITextFieldDelegate Methods
#pragma mark -

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
    [self validateTextField:textField forcedError:YES];
}


#pragma mark - UserRegistrationDelegate

- (void)didRegisterSuccessWithUser:(DIUser *)profile {
    [super didRegisterSuccessWithUser:profile];
    [self.continueButton setIsActivityIndicatorVisible:NO];
    self.isScreenNavigationNoClearData = true;
    if ([URSettingsWrapper sharedInstance].experience == URReceiveMarketingFlowSplitSignUp) {
        [self performSegueWithIdentifier:kOptInViewControllerSegue sender:nil];
    } else {
        [self popOutOfRegistrationViewControllersWithError:nil];
    }
    NSString *country = [URSettingsWrapper sharedInstance].countryCode;
    [DIRegistrationAppTagging trackActionWithInfo:kRegSendData params:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:kRegSuccessUserRegistration,country, nil] forKeys:[NSArray arrayWithObjects:kRegSpecialEvents,kCountrySelectedKey,nil]]];
}


- (void)didRegisterFailedwithError:(NSError *)error {
    [super didRegisterFailedwithError:error];
    [self.continueButton setIsActivityIndicatorVisible:NO];
    self.providerName = error.userInfo[kProviderKey];
    switch (error.code) {
        case DIEmailAddressAlreadyInUse:
            [self showTextFieldErrorForUsedEmailORMobile:NO];
            break;
        case DIMobileNumberAlreadyInUse:
            [self showTextFieldErrorForUsedEmailORMobile:YES];
            break;
        case DINotVerifiedMobileErrorCode:
            [self navigateToScreen:YES];
            break;
        case DINotVerifiedEmailErrorCode:
            [self navigateToScreen:NO];
            break;
        default:
            [self showNotificationBarErrorViewWithTitle:error.localizedDescription];
            break;
    }
}

- (void)showTextFieldErrorForUsedEmailORMobile:(BOOL)isMobileNumber {
    NSString *errorDescription = isMobileNumber ? [NSString stringWithFormat:LOCALIZE(@"USR_Janrain_EntityAlreadyExists_ErrorMsg"), LOCALIZE(@"USR_DLS_Phonenumber_Label_Text")] : [NSString stringWithFormat:LOCALIZE(@"USR_Janrain_EntityAlreadyExists_ErrorMsg"), LOCALIZE(@"USR_DLS_Email_Label_Text")];
    [self.emailOrMobileNumberField setValidationMessage:errorDescription];
    [self.emailOrMobileNumberField setValidationView:YES animated:YES];
}

- (void)didUpdateSuccess {
    [super didUpdateSuccess];
    [self.continueButton setIsActivityIndicatorVisible:NO];
    self.isScreenNavigationNoClearData = true;
    [self popOutOfRegistrationViewControllersWithError:nil];
}


- (void)didUpdateFailedWithError:(NSError *)error {
    [super didUpdateFailedWithError:error];
    [self.continueButton setIsActivityIndicatorVisible:NO];
    [self showNotificationBarErrorViewWithTitle:error.localizedDescription];
}


#pragma mark - Reachability Status

- (void)updateConnectionStatus:(BOOL) connectionAvailable {
    [super updateConnectionStatus:connectionAvailable];
    if ((self.almostDoneFlowType == URAlmostDoneFlowTypeSocialRegistration) && !([self.userRegistrationHandler.userIdentifier isValidEmail]  || [self.userRegistrationHandler.userIdentifier isValidMobileNumber])) {
        self.continueButton.enabled = (self.validEmailORPhoneNumber && connectionAvailable);
    } else if(![self.marketingStackView isHidden]){
        self.continueButton.enabled = connectionAvailable;
    }
}


@end
