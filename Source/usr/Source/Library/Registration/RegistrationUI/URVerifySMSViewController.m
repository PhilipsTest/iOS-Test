//
//  URVerifySMSViewController.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.


#import "URVerifySMSViewController.h"
#import "URResendSMSViewController.h"
#import "URStartViewController.h"
@import SafariServices;

@interface URVerifySMSViewController ()<UserRegistrationDelegate, TimerTrackingDelegate, ResetTokenDelegate, SFSafariViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIDLabel           *smsCodeDescriptionLabel;
@property (nonatomic, weak) IBOutlet UIDLabel           *enterCodeDescriptionLabel;
@property (nonatomic, weak) IBOutlet UIDTextField       *smsCodeTextField;
@property (nonatomic, weak) IBOutlet UIDProgressButton  *verifyCodeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackViewWidthConstraint;

@property (nonatomic, strong) NSDate   *smsSentDate;
@property (nonatomic, strong) NSString *mobileNumberString;
@property (nonatomic, strong) SFSafariViewController *safariController;

@end

@implementation URVerifySMSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.enterCodeFlowType == EnterCodeFlowTypeVerification) {
        self.title = LOCALIZE(@"USR_DLS_URCreateAccount_NavTitle");
        [self.enterCodeDescriptionLabel setText:LOCALIZE(@"USR_DLS_VerifySMS_EnterCode_Text")];
        self.mobileNumberString = [DIUser getInstance].mobileNumber;
        [self.navigationItem setHidesBackButton:YES];
    } else {
        self.title = LOCALIZE(@"USR_DLS_SigIn_TitleTxt");
        [self.enterCodeDescriptionLabel setText:LOCALIZE(@"USR_DLS_ResetAccount_EnterCode_Text")];
        self.mobileNumberString = self.mobileNumber;
    }
    self.smsSentDate = [NSDate date];
    [_smsCodeTextField checkAndUpdateTextFieldToRTL];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *descriptionString = [NSString stringWithFormat:LOCALIZE(@"USR_DLS_VerifySMS_Description_Text"),self.mobileNumberString];
    NSMutableAttributedString *attributedDescription = [[NSMutableAttributedString alloc] initWithString:descriptionString];
    [attributedDescription setAttributes:@{NSFontAttributeName:[[UIFont alloc] initWithUidFont:UIDFontBold size:16]} range:[descriptionString rangeOfString:self.mobileNumberString]];
    [self.smsCodeDescriptionLabel setAttributedText:attributedDescription];
    DIRInfoLog(@"Screen name is %@", kRegistrationVerifyAccountSMS);
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [DIRegistrationAppTagging trackPageWithInfo:kRegistrationVerifyAccountSMS paramKey:nil andParamValue:nil];
    [self.smsCodeTextField becomeFirstResponder];
}


-(void)viewWillLayoutSubviews {
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
        self.stackViewWidthConstraint.constant = -([UIApplication sharedApplication].keyWindow.bounds.size.width - 648);
    } else {
        self.stackViewWidthConstraint.constant = -32;
    }
}

#pragma mark - IBActions
#pragma mark -

- (IBAction)verifyAccountWithActivationCode:(UIDProgressButton *)sender {
    DIRInfoLog(@"%@.verifyAccountWithActivationCode clicked", kRegistrationVerifyAccountSMS);
    [self.smsCodeTextField resignFirstResponder];
    [self.verifyCodeButton setEnabled:NO];
    if (self.enterCodeFlowType == EnterCodeFlowTypeVerification) {
        [self startActivityIndicator];
        [sender setIsActivityIndicatorVisible:YES];
        sender.progressTitle = LOCALIZE(@"USR_DLS_VerifySMS_VerifyCode_Button_Title");
        [self.userRegistrationHandler verificationCodeForMobile:self.smsCodeTextField.text];
    } else {
        [self loadForgotPasswordRequest];
    }
}


- (IBAction)didNotReceiveAnSMS:(id)sender {
    DIRInfoLog(@"%@.didNotReceiveAnSMS clicked", kRegistrationVerifyAccountSMS);
    [self performSegueWithIdentifier:kURResendSMSViewControllerSegue sender:nil];
}


- (IBAction)validateTextField:(UIDTextField *)sender {
    [super validateTextField:sender];
    BOOL result = [self.smsCodeTextField validateAccountVerificationCodeAndDisplayError];
    [self.verifyCodeButton setEnabled:(result && self.connectionAvailable)];
}

#pragma mark - Custom Methods
#pragma mark -

- (void)verificationFailedErroHandler:(NSError *) error {
    switch (error.code) {
        case DISMSFailureErrorCode:
            [self.smsCodeTextField setValidationMessage:LOCALIZE(@"USR_VerificationCode_ErrorText")];
            [self.smsCodeTextField setValidationView:YES animated:YES];
            break;
        default:
            [self showNotificationBarErrorViewWithTitle:error.localizedDescription];
            break;
    }
}


- (void)loadForgotPasswordRequest {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:[URSettingsWrapper sharedInstance].launchInput.registrationFlowConfiguration.resetPasswordURL];
    [urlComponents setQuery:[NSString stringWithFormat:@"code=%@&token=%@", self.smsCodeTextField.text, self.mobileResetToken]];
    
    SFSafariViewControllerConfiguration *configuration = [[SFSafariViewControllerConfiguration alloc] init];
    configuration.entersReaderIfAvailable = NO;
    configuration.barCollapsingEnabled = YES;
    self.safariController = [[SFSafariViewController alloc] initWithURL:[urlComponents URL] configuration:configuration];
    self.safariController.delegate = self;
    self.safariController.dismissButtonStyle = SFSafariViewControllerDismissButtonStyleClose;
    self.safariController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.safariController.preferredBarTintColor = [[UINavigationBar appearance] barTintColor];
    self.safariController.preferredControlTintColor = [[UINavigationBar appearance] tintColor];
    [self presentViewController:self.safariController animated:YES completion:nil];
}


- (void)adjustNavigationStackForLoginFlow {
    NSMutableArray *vcs = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
    NSInteger index = [vcs indexOfObject:[vcs lastObject]];
    index -= 1; // remove previous screen to navigate user into login screen
    [vcs removeObjectAtIndex:index];
    [self.navigationController setViewControllers:vcs];
}

#pragma mark - ResendTimerDelegate
#pragma mark -

- (void)restartTimer:(NSDate *)date {
    self.smsSentDate = date;
}

#pragma mark - UserDetailsDelegate Methods
#pragma mark -

- (void)didVerificationForMobileSuccess {
    [self.userRegistrationHandler refetchUserProfile];
}


- (void)didVerificationForMobileFailedwithError:(nonnull NSError *)error {
    [self verificationFailedErroHandler:error];
    [self.verifyCodeButton setIsActivityIndicatorVisible:NO];
    [super stopActivityIndicator];
    [DIRegistrationAppTagging trackActionWithInfo:kRegSendData paramKey:kRegUserError andParamValue:kRegSMSIsNotVerified];
}


- (void)didUserInfoFetchingSuccessWithUser:(DIUser *)profile {
    [super didUserInfoFetchingSuccessWithUser:profile];
    [self.verifyCodeButton setIsActivityIndicatorVisible:NO];
    [self.verifyCodeButton setEnabled:YES];
    [super stopActivityIndicator];
    if (self.userRegistrationHandler.isMobileNumberVerified) {
        NSString *country = [URSettingsWrapper sharedInstance].countryCode;
        [DIRegistrationAppTagging trackActionWithInfo:kRegSendData params:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:kRegSuccessUserRegistration,country, nil] forKeys:[NSArray arrayWithObjects:kRegSpecialEvents,kCountrySelectedKey,nil]]];
        [self performSegueWithIdentifier:kSecureDataRecoveryEmailSegue sender:nil];
    }
}


- (void)didUserInfoFetchingFailedWithError:(NSError *)error {
    [super didUserInfoFetchingFailedWithError:error];
    [super stopActivityIndicator];
    [self.verifyCodeButton setIsActivityIndicatorVisible:NO];
    [self.verifyCodeButton setEnabled:YES];
    [self showNotificationBarErrorViewWithTitle:error.localizedDescription ? error.localizedDescription : [NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), error.code]];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:kURResendSMSViewControllerSegue]) {
        URResendSMSViewController *urResendSMSViewController = segue.destinationViewController;
        urResendSMSViewController.editMobileNumber = self.mobileNumberString;
        urResendSMSViewController.timerTrackingDelegate = self;
        urResendSMSViewController.resendEmailOrSMSDate = self.smsSentDate;
        urResendSMSViewController.enterCodeFlowType = self.enterCodeFlowType;
        urResendSMSViewController.delegate = self;
    }
}

#pragma mark - ResetTokenDelegate

- (void)resetTokenForMobileResetPassword:(NSString *)resetToken andUpdatedMobile:(NSString *)mobileNumber{
    self.mobileResetToken = resetToken;
    self.mobileNumberString = mobileNumber;
}

#pragma mark - SFSafariViewControllerDelegate

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    [self startActivityIndicator];
    [self adjustNavigationStackForLoginFlow];
    [self stopActivityIndicator];
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - Connection Status
#pragma mark -

- (void)updateConnectionStatus:(BOOL) connectionAvailable {
    [super updateConnectionStatus:connectionAvailable];
    [self.verifyCodeButton setEnabled:([self.smsCodeTextField.text isValidAccountVerificationCode] && connectionAvailable)];
}

@end
