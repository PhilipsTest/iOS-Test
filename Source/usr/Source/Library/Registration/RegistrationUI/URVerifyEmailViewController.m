//
//  URVerifyEmailViewController.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "URVerifyEmailViewController.h"
#import "URAlmostDoneViewController.h"
#import "URResendEmailViewController.h"
#import "URCreateAccountViewController.h"
#import "NSAttributedString+URAdditions.h"
#import "DIUser+PrivateData.h"

@interface URVerifyEmailViewController ()<TimerTrackingDelegate>

@property(nonatomic, weak)  IBOutlet UIDButton         *resendEMailButtonOutlet;
@property(nonatomic, weak)  IBOutlet UIDProgressButton *emailVerifiedButtonOutlet;
@property(nonatomic, weak)  IBOutlet UIDLabel          *verificationSentToEMailLabel;
@property(nonatomic, weak)  IBOutlet UIDLabel          *valueForEmailVerificationLabel;

@property (nonatomic, strong)  NSDate  *timerTrackingDate;
@property (nonatomic)  BOOL  isHSDPRequestOngoing;

@end

@implementation URVerifyEmailViewController

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHSDPRequestOngoing = false;
    self.title = LOCALIZE(@"USR_DLS_URCreateAccount_NavTitle");
    [self.navigationItem setHidesBackButton:YES];
    [self initialize];
    self.timerTrackingDate = [NSDate date];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *verificationSentToEMailLabelText = [NSString stringWithFormat:LOCALIZE(@"USR_DLS_Verify_Email_Sent_Txt"),self.userRegistrationHandler.email];
    self.verificationSentToEMailLabel.attributedText = [NSAttributedString attributedStringWithBoldSubstring:self.userRegistrationHandler.email originalString:verificationSentToEMailLabelText withFont:[UIFont fontWithName:@"CentraleSansBold" size:16.0]];
    DIRInfoLog(@"Screen name is %@", kRegistrationVerifyemail);
    [DIRegistrationAppTagging trackPageWithInfo:kRegistrationVerifyemail paramKey:nil andParamValue:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ResendEmailViewController"]) {
        // Get destination view controller and don't forget
        // to cast it to the right class
        URResendEmailViewController *resendViewController = [segue destinationViewController];
        // Pass data
        resendViewController.timerTrackingDelegate = self;
        resendViewController.resendEmailOrSMSDate = self.timerTrackingDate;
    } else if ([segue.identifier isEqualToString:kTermsAndConditionsViewControllerSegue]) {
        URAlmostDoneViewController *registrationVerificationVC= segue.destinationViewController;
        registrationVerificationVC.almostDoneFlowType = URAlmostDoneFlowTypeTraditionalLogIn;
    }
}

#pragma mark - ResendTimerDelegate -

- (void)restartTimer:(NSDate *)date {
    self.timerTrackingDate = date;
}

#pragma mark - IBActions -

- (IBAction)emailVerifiedButtonAction:(UIDProgressButton *)sender {
    DIRInfoLog(@"%@.emailVerifiedButtonAction clicked", kRegistrationVerifyemail);
    [self startActivityIndicator];
    [sender setIsActivityIndicatorVisible:YES];
    sender.progressTitle = LOCALIZE(@"USR_DLS_Verify_Email_Verified_Btn_Title_Txt");
    self.emailVerifiedButtonOutlet.enabled = NO;
    [self.userRegistrationHandler refetchUserProfile];
    [self checkEmailVerificationStatus];
}

- (IBAction)resendEMailButtonAction:(id)sender {
    DIRInfoLog(@"%@.resendEMailButtonAction clicked", kRegistrationVerifyemail);
    [self performSegueWithIdentifier:@"ResendEmailViewController" sender:nil];
}

#pragma mark - Custom Methods -

- (void)initialize {
    
    [self stopActivityIndicator];

    self.explanatoryTextLabel.text = LOCALIZE(@"USR_DLS_Verify_Email_Security_Txt");

    DIRegistrationContentConfiguration *registrationContentConfiguration = [URSettingsWrapper sharedInstance].launchInput.registrationContentConfiguration;
    if (registrationContentConfiguration.valueForEmailVerification.length == 0) {
        self.valueForEmailVerificationLabel.text = LOCALIZE(@"USR_DLS_Verify_Email_Explainary_Txt");
    } else {
        self.valueForEmailVerificationLabel.text = registrationContentConfiguration.valueForEmailVerification;
    }
}

- (void)showLoggedInWelcomeScreen {
    [self popOutOfRegistrationViewControllersWithError:nil];
}

- (void)showTermsAndConditionsScreen {
    [self performSegueWithIdentifier:kTermsAndConditionsViewControllerSegue sender:nil];
}

- (void)checkEmailVerificationStatus {
    [self startActivityIndicator];
    self.emailVerifiedButtonOutlet.isActivityIndicatorVisible = TRUE;
    self.emailVerifiedButtonOutlet.progressTitle = LOCALIZE(@"USR_DLS_Verify_Email_Verified_Btn_Title_Txt");
    self.emailVerifiedButtonOutlet.enabled = NO;
    [self.userRegistrationHandler refetchUserProfile];
}


-(void)updateEmailVerificationStatus:(DIUser *)profile {
   [self.emailVerifiedButtonOutlet setIsActivityIndicatorVisible:NO];
    __block NSInteger isFromTraditionalRegistrationScreen = NSNotFound;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[URCreateAccountViewController class]]) {
            *stop = true;
            isFromTraditionalRegistrationScreen = idx;
        }
    } ];
    URReceiveMarketingFlow flow = [URSettingsWrapper sharedInstance].experience;
    BOOL isTCAccepted = [RegistrationUtility hasUserAcceptedTermsnConditions:profile.userIdentifier];
    if ((isFromTraditionalRegistrationScreen != NSNotFound) || ((flow == URReceiveMarketingFlowCustomOptin && isTCAccepted) || (flow == URReceiveMarketingFlowSkipOptin && isTCAccepted))) { //TODO: This check should be imrpopved to use enum.
        [self showLoggedInWelcomeScreen];
    } else if (([URSettingsWrapper sharedInstance].isTermsAndConditionsRequired && !isTCAccepted)) {
        [self showTermsAndConditionsScreen];
    } else {
        [self showLoggedInWelcomeScreen];
    }
    NSString *country = [URSettingsWrapper sharedInstance].countryCode;
    [DIRegistrationAppTagging trackActionWithInfo:kRegSendData params:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:kRegSuccessUserRegistration,country, nil] forKeys:[NSArray arrayWithObjects:kRegSpecialEvents,kCountrySelectedKey,nil]]];
    self.emailVerifiedButtonOutlet.enabled = YES;
}

-(void)performHSDPSignInForUser:(DIUser *)profile {
    __weak URVerifyEmailViewController *weakSelf = self;
    if (true == self.isHSDPRequestOngoing) {
        return;
    }

    [[DIUser getInstance] performHSDPSignIn: ^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            weakSelf.isHSDPRequestOngoing = false;
            if (true == success) {
                [weakSelf stopActivityIndicator];
                [weakSelf updateEmailVerificationStatus:profile];
            } else {
                [weakSelf didUserInfoFetchingFailedWithError:error];
            }
        });
    }];
}

-(BOOL)isHSDPLoginRequired {
    return ((true == [HSDPService isHSDPConfigurationAvailableForCountry:[URSettingsWrapper sharedInstance].countryCode]) &&
             (false == [HSDPService isHSDPSkipLoadingEnabled]));
}

-(BOOL)isCountryChina {
    return ([[URSettingsWrapper sharedInstance].countryCode isEqualToString:@"CN"]);
}


#pragma mark -
#pragma mark - UserDetailsDelegate

- (void)didUserInfoFetchingSuccessWithUser:(DIUser *)profile {
    if (true == self.userRegistrationHandler.isEmailVerified) {
        if ((true == [self isCountryChina]) && (true == [self isHSDPLoginRequired])) {
            [self performHSDPSignInForUser:profile];
            self.isHSDPRequestOngoing = true;
            return;
        }
         [self.emailVerifiedButtonOutlet setIsActivityIndicatorVisible:NO];
         [self updateEmailVerificationStatus:profile];
        self.emailVerifiedButtonOutlet.enabled = YES;
    } else {
        [super didUserInfoFetchingSuccessWithUser:profile];
        [self.emailVerifiedButtonOutlet setIsActivityIndicatorVisible:NO];
        [self showEmailVerificationError];
        [self.emailVerifiedButtonOutlet setEnabled:YES];
        [DIRegistrationAppTagging trackActionWithInfo:kRegSendData paramKey:kRegUserError andParamValue:kRegEmailIsNotVerified];
    }
}

- (void)didUserInfoFetchingFailedWithError:(NSError *)error {
    [super didUserInfoFetchingFailedWithError:error];
    [self.emailVerifiedButtonOutlet setIsActivityIndicatorVisible:NO];
    [self showNotificationBarErrorViewWithTitle:error.localizedDescription ? error.localizedDescription : [NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), error.code]];
    [self.emailVerifiedButtonOutlet setEnabled:YES];
}

#pragma mark - Alert methods -

- (void)showEmailVerificationError {
    NSString *messageBody = [NSString stringWithFormat:@"%@\n\n%@", LOCALIZE(@"USR_DLS_Email_Verify_Alert_Body_Line1"), LOCALIZE(@"USR_DLS_Email_Verify_Alert_Body_Line2")];

    UIDAlertController *alertVC = [[UIDAlertController alloc] initWithTitle:LOCALIZE(@"USR_DLS_Email_Verify_Alert_Title") icon:nil message:messageBody];
    UIDAction *alertAction = [[UIDAction alloc] initWithTitle:LOCALIZE(@"USR_DLS_Button_Title_Ok") style:UIDActionStylePrimary handler:nil];
    [alertVC addAction:alertAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - Reachability Status -

- (void)updateConnectionStatus:(BOOL) connectionAvailable {
    [super updateConnectionStatus:connectionAvailable];
    [self.resendEMailButtonOutlet setEnabled:connectionAvailable];
    [self.emailVerifiedButtonOutlet setEnabled:connectionAvailable];
}

@end
