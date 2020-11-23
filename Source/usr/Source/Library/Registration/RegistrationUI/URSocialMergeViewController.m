//
//  URSocialMergeViewController.h
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import "URSocialMergeViewController.h"
#import "URAlmostDoneViewController.h"

@interface URSocialMergeViewController ()
@property (nonatomic, weak) IBOutlet UIDLabel   *socialMergeTitleLabel;
@property (nonatomic, weak) IBOutlet UIDLabel   *socialMergeDescriptionLabel;
@property (nonatomic, weak) IBOutlet UIDButton  *socialMergeLogInButton;
@property (nonatomic, weak) IBOutlet UIDButton  *socialMergeLogoutButton;

@property (nonatomic, assign) BOOL shouldTrackPage;

@end

@implementation URSocialMergeViewController

#pragma mark UIViewController LifyCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = LOCALIZE(@"USR_DLS_SigIn_TitleTxt");
    [self.navigationItem setHidesBackButton:YES];
    self.shouldTrackPage = YES;
    NSString *descriptionString = [NSString stringWithFormat:LOCALIZE(@"USR_DLS_Social_Merge_Title"),self.existingProviderName];
    NSMutableAttributedString *attributedDescription = [[NSMutableAttributedString alloc] initWithString:descriptionString attributes:@{NSFontAttributeName:[[UIFont alloc] initWithUidFont:UIDFontBook size:16]}];
    [attributedDescription setAttributes:@{NSFontAttributeName:[[UIFont alloc] initWithUidFont:UIDFontBold size:16]} range:[descriptionString rangeOfString:self.existingProviderName]];
    [self.socialMergeTitleLabel setAttributedText:attributedDescription];
    
    if (self.socialProviderAuthorizedEmail == nil) {
        self.socialProviderAuthorizedEmail = LOCALIZE(@"USR_DLS_Email_Label_Text");
    }
    descriptionString = [NSString stringWithFormat:LOCALIZE(@"USR_DLS_Social_Merge_Description"),self.socialProviderAuthorizedEmail];
    [attributedDescription setAttributedString:[[NSMutableAttributedString alloc] initWithString:descriptionString attributes:@{NSFontAttributeName:[[UIFont alloc] initWithUidFont:UIDFontBook size:16]}]];
    [attributedDescription setAttributes:@{NSFontAttributeName:[[UIFont alloc] initWithUidFont:UIDFontBold size:16]} range:[descriptionString rangeOfString:self.socialProviderAuthorizedEmail]];
    [self.socialMergeDescriptionLabel setAttributedText:attributedDescription];

    [self.socialMergeLogInButton setTitle:[NSString stringWithFormat:LOCALIZE(@"USR_DLS_Social_Merge_Enabled_Button_Title"),self.existingProviderName] forState:UIControlStateNormal];
    [DIRegistrationAppTagging trackActionWithInfo:kRegSendData paramKey:kRegSpecialEvents andParamValue:kRegStartSocialMerge];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.shouldTrackPage) {
        [DIRegistrationAppTagging trackPageWithInfo:kRegistrationSocialMerge paramKey:nil andParamValue:nil];
        DIRInfoLog(@"Screen name is %@", kRegistrationSocialMerge);
    }
}


#pragma mark IBActions

- (IBAction)mergeAccounts:(id)sender {
    [self showHiddenView];
    [self startActivityIndicator];
    [self.userRegistrationHandler handleMergeRegisterWithProvider:self.existingProviderName];
    self.shouldTrackPage = NO;
    [DIRegistrationAppTagging trackPageWithInfo:kRegistrationSocialProvider(self.existingProviderName) paramKey:nil andParamValue:nil];
    DIRInfoLog(@"%@.mergeAccounts clicked", kRegistrationSocialMerge);
}


- (IBAction)logoutTheUser:(id)sender {
    [DIRegistrationAppTagging trackActionWithInfo:kRegSendData paramKey:kRegSpecialEvents andParamValue:kRegLogoutButtonSelected];
    DIRInfoLog(@"%@.logoutTheUser clicked", kRegistrationSocialMerge);
    UIDAlertController *alertVC = [[UIDAlertController alloc] initWithTitle:LOCALIZE(@"USR_DLS_Merge_Accounts_Logout_Dialog_Title") icon:nil message:LOCALIZE(@"USR_DLS_Merge_Accounts_Logout_Dialog_Message")];
    
    UIDAction *alertAction = [[UIDAction alloc] initWithTitle:LOCALIZE(@"USR_DLS_Merge_Accounts_Logout_Dialog__Button_Title") style:UIDActionStylePrimary handler:^(UIDAction * _Nonnull action) {
        [self registrationSignout];
    }];
    [alertVC addAction:alertAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}


#pragma mark - UserRegistrationDelegate Methods

- (void)didLoginWithSuccessWithUser:(DIUser *)profile {
    BOOL personalConsentReqd = [self isPersonalConsentViewToBeShown];
    URReceiveMarketingFlow flow = [URSettingsWrapper sharedInstance].experience;
    BOOL isReceiveMarketingReqd = (((flow == URReceiveMarketingFlowCustomOptin) || (flow == URReceiveMarketingFlowSkipOptin)) == true) ?
    false : !profile.receiveMarketingEmails;
    if (([URSettingsWrapper sharedInstance].isTermsAndConditionsRequired && ![RegistrationUtility hasUserAcceptedTermsnConditions:profile.userIdentifier]) || isReceiveMarketingReqd || personalConsentReqd) {
        [self performSegueWithIdentifier:kTermsAndConditionsViewControllerSegue sender:nil];
        [self stopActivityIndicator];
    }else {
        [self popOutOfRegistrationViewControllersWithError:nil];
    }
}


- (void)didLoginFailedwithError:(NSError *)error {
    [super didLoginFailedwithError:error];
    if (error.code == DINotVerifiedEmailErrorCode) {
        [self performSegueWithIdentifier:kRegistrationVerifyEmailSegue sender:nil];
    } else {
        [self showNotificationBarErrorViewWithTitle:error.localizedDescription];
    }
}


- (void)socialLoginCannotLaunch:(NSError *)error {
    [super socialLoginCannotLaunch:error];
    [self showNotificationBarErrorViewWithTitle:error.localizedDescription];
    [DIRegistrationAppTagging trackPageWithInfo:kRegistrationSocialMerge paramKey:nil andParamValue:nil];
}


- (void)socialAuthenticationCanceled {
    [super socialAuthenticationCanceled];
    [DIRegistrationAppTagging trackPageWithInfo:kRegistrationSocialMerge paramKey:nil andParamValue:nil];
}


- (void)didFailHandleMerging:(NSError *)error {
    [self stopActivityIndicator];
    [self showNotificationBarErrorViewWithTitle:error.localizedDescription];
}

#pragma mark - UserRegistrationDelegate Methods

- (void)logoutDidSucceed {
    [super logoutDidSucceed];
    dispatch_async(dispatch_get_main_queue(), ^{
          [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)logoutFailedWithError:(NSError *)error {
    [super logoutFailedWithError:error];
}

#pragma mark - Reachability Status

- (void)updateConnectionStatus:(BOOL)connectionAvailable {
    [super updateConnectionStatus:connectionAvailable];
    [self.socialMergeLogInButton setEnabled:connectionAvailable];
    [self.socialMergeLogoutButton setEnabled:connectionAvailable];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.shouldTrackPage = YES;
    if ([segue.identifier isEqualToString:kTermsAndConditionsViewControllerSegue]) {
        URAlmostDoneViewController *almostDoneVC = segue.destinationViewController;
        almostDoneVC.almostDoneFlowType = URAlmostDoneFlowTypeSocialLogIn;
    }
}
@end
