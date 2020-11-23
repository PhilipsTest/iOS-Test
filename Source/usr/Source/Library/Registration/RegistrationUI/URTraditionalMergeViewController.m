//
//  URTraditionalMergeViewController.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import "URTraditionalMergeViewController.h"
#import "URAlmostDoneViewController.h"

@interface URTraditionalMergeViewController ()
@property (nonatomic, weak) IBOutlet UIDLabel           *traditionalMergeTitleLabel;
@property (nonatomic, weak) IBOutlet UIDProgressButton  *traditionalMergeButton;
@property (nonatomic, weak) IBOutlet UIDProgressButton  *traditionalMergeForgotPasswordButton;
@property (nonatomic, weak) IBOutlet UIDPasswordField   *passwordField;
@property (weak, nonatomic) IBOutlet UIDLabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIDTextField *emailDLSTextField;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (assign) BOOL validEmail;

@end

@implementation URTraditionalMergeViewController

#pragma mark UIViewController LifyCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateSocialProviderVariable];
    [self checkAndShowEmailFields];
    self.validEmail = true;
    self.title = LOCALIZE(@"USR_DLS_SigIn_TitleTxt");
    [self.navigationItem setHidesBackButton:NO];
    NSString *descriptionString = [NSString stringWithFormat:LOCALIZE(@"USR_DLS_Traditional_Merge_Title"),self.socialProviderAuthorizedEmail];
    NSMutableAttributedString *attributedDescription = [[NSMutableAttributedString alloc] initWithString:descriptionString attributes:@{NSFontAttributeName:[[UIFont alloc] initWithUidFont:UIDFontBook size:16]}];
    NSRange range = [descriptionString rangeOfString:self.socialProviderAuthorizedEmail];
    //Check range before attribution.
    if (range.location != NSNotFound) {
        [attributedDescription setAttributes:@{NSFontAttributeName:[[UIFont alloc] initWithUidFont:UIDFontBold size:16]} range:range];
    }
    
    [self.traditionalMergeTitleLabel setAttributedText:attributedDescription];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.traditionalMergeButton setEnabled:NO];
    [DIRegistrationAppTagging trackPageWithInfo:kRegistrationAccountsMerge paramKey:nil andParamValue:nil];
    DIRInfoLog(@"Screen name is %@", kRegistrationAccountsMerge);
}


-(void)checkAndShowEmailFields {
    if (self.socialProviderAuthorizedEmail != nil) {
        return;
    }
    NSString *localisedText = LOCALIZE(@"USR_DLS_Email_Label_Text");;
    if (self.loginFlowType == RegistrationLoginFlowTypeMobile) {
        localisedText =  LOCALIZE(@"USR_DLS_Email_Phone_Label_Text");
    }
    self.socialProviderAuthorizedEmail = localisedText;
    self.emailLabel.text = localisedText;
    [self.emailView setHidden:false];
    self.validEmail = false;
    [self.emailDLSTextField setHidden:false];
    [self.emailLabel setHidden:false];
}


#pragma mark IBActions

- (IBAction)mergeAccounts:(UIDProgressButton *)sender {
    DIRInfoLog(@"%@.mergeAccounts clicked", kRegistrationAccountsMerge);
    [self.view endEditing:YES];
    [self startActivityIndicator];
    [sender setIsActivityIndicatorVisible:YES];
    sender.progressTitle = LOCALIZE(@"USR_Account_Merge_Merge_btntxt");
    [self hideNotificationBarErrorView];
    [DIRegistrationAppTagging trackActionWithInfo:kRegSendData paramKey:kRegSpecialEvents andParamValue:kRegStartSocialMerge];
    NSString *emailID = (self.emailDLSTextField.isHidden == false) ? self.emailDLSTextField.text : self.socialProviderAuthorizedEmail;
    [self.userRegistrationHandler handleMergeRegisterWithEmail:emailID withPassword:self.passwordField.text];
}


- (IBAction)forgotPassword:(UIDProgressButton *)sender {
    DIRInfoLog(@"%@.forgotPassword clicked", kRegistrationAccountsMerge);
    [self.view endEditing:YES];
    [self startActivityIndicator];
    [sender setIsActivityIndicatorVisible:YES];
    sender.progressTitle = LOCALIZE(@"USR_DLS_Traditional_Merge_ForgotPassword");
    NSString *emailID = (self.emailDLSTextField.isHidden == false) ? self.emailDLSTextField.text : self.socialProviderAuthorizedEmail;
    [self.userRegistrationHandler forgotPasswordForEmail:emailID];
}



#pragma mark Custom Methods

- (IBAction)validateTextField:(UIDTextField *)textField {
    [super validateTextField:textField];
    BOOL validPassword = [self.passwordField validateSignInPasswordAndDisplayError:YES];
    [self hideNotificationBarErrorView];
    [self.traditionalMergeButton setEnabled:(self.validEmail && validPassword && self.connectionAvailable)];
}

-(IBAction)validateEmailText:(UIDTextField *)textField {
    self.validEmail = [self.emailDLSTextField validateEmailContentAndDisplayError:true];
}


//If email is not present then we need to take mobile number.
-(void)updateSocialProviderVariable {
    if ((self.socialProviderAuthorizedEmail == nil) || [self.socialProviderAuthorizedEmail isEqualToString:@""]) {
        NSString *userEmail = [DIUser getInstance].email;
        self.socialProviderAuthorizedEmail = (userEmail == nil || [userEmail isEqualToString:@""]) ? [DIUser getInstance].mobileNumber : userEmail;
    }
}

#pragma mark UserRegistration delegates

- (void)didLoginWithSuccessWithUser:(DIUser *)profile {
    [super didLoginWithSuccessWithUser:profile];
    [self.traditionalMergeButton setIsActivityIndicatorVisible:NO];
    BOOL personalConsentReqd = [self isPersonalConsentViewToBeShown];
    URReceiveMarketingFlow flow = [URSettingsWrapper sharedInstance].experience;
    BOOL isReceiveMarketingReqd = (((flow == URReceiveMarketingFlowCustomOptin) || (flow == URReceiveMarketingFlowSkipOptin)) == true) ?
    false : !profile.receiveMarketingEmails;
    if (([URSettingsWrapper sharedInstance].isTermsAndConditionsRequired && ![RegistrationUtility hasUserAcceptedTermsnConditions:profile.userIdentifier]) || isReceiveMarketingReqd || personalConsentReqd) {
        [self performSegueWithIdentifier:kTermsAndConditionsViewControllerSegue sender:nil];
    } else {
        [self popOutOfRegistrationViewControllersWithError:nil];
    }
}


- (void)didLoginFailedwithError:(NSError *)error {
    [super didLoginFailedwithError:error];
    [self.traditionalMergeButton setIsActivityIndicatorVisible:NO];
    [self showNotificationBarErrorViewWithTitle:error.localizedDescription];
}


- (void)didFailHandleMerging:(NSError *)error {
    [self stopActivityIndicator];
    [self.traditionalMergeButton setIsActivityIndicatorVisible:NO];
    [self showNotificationBarErrorViewWithTitle:error.localizedDescription];
    [DIRegistrationAppTagging trackActionWithInfo:kRegSendData paramKey:kRegUserError andParamValue:kRegIncorrectPassword];
}


- (void)didSendForgotPasswordSuccess {
    [super didSendForgotPasswordSuccess];
    UIDAlertController *alertVC = [self forgotPasswordSuccessAlert];
    UIDAction *okAction = [[UIDAction alloc] initWithTitle:LOCALIZE(@"USR_DLS_Button_Title_Ok") style:UIDActionStylePrimary handler:nil];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    [self.traditionalMergeForgotPasswordButton setIsActivityIndicatorVisible:NO];
}


- (void)didSendForgotPasswordFailedwithError:(NSError *)error {
    [super didSendForgotPasswordFailedwithError:error];
    [self.traditionalMergeForgotPasswordButton setIsActivityIndicatorVisible:NO];
    [self showNotificationBarErrorViewWithTitle:error.localizedDescription];
}


#pragma mark - Reachability Status

- (void)updateConnectionStatus:(BOOL)connectionAvailable {
    [super updateConnectionStatus:connectionAvailable];
    [self.traditionalMergeButton setEnabled:connectionAvailable];
    [self.traditionalMergeForgotPasswordButton setEnabled:connectionAvailable];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kTermsAndConditionsViewControllerSegue]) {
        URAlmostDoneViewController *almostDoneVC = segue.destinationViewController;
        almostDoneVC.almostDoneFlowType = URAlmostDoneFlowTypeSocialLogIn;
    }
}
@end
