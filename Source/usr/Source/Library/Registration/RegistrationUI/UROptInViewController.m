//
//  UROptInViewController.m
//  Registration
//
//  Created by Sai Pasumarthy on 10/24/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "UROptInViewController.h"

@interface UROptInViewController ()<UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UIDLabel           *optInTitleLabel;
@property (nonatomic, weak) IBOutlet UIDLabel           *specialOffersLabel;
@property (nonatomic, weak) IBOutlet UIDLabel           *joinNowLabel;
@property (nonatomic, weak) IBOutlet UIView             *promotionMessageBackGroundView;
@property (nonatomic, weak) IBOutlet UIDLabel           *promotionalMessageTitleLabel;
@property (nonatomic, weak) IBOutlet UIDHyperLinkLabel  *whatDoesThisMeanLabel;
@property (nonatomic, weak) IBOutlet UIDProgressButton  *countMeInButton;
@property (nonatomic, weak) IBOutlet UIDProgressButton  *maybeLaterButton;
@property (weak, nonatomic) IBOutlet UIImageView        *optInScreenImage;

@property (nonatomic, strong) URLaunchInput             *launchInput;
@property (nonatomic, assign) BOOL                       selectedButtonTracker;

@end

@implementation UROptInViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.launchInput = [URSettingsWrapper sharedInstance].launchInput;

    [self.navigationItem setHidesBackButton:[self viewControllersOfUserRegistration].count != 1];
    self.title = LOCALIZE(@"USR_DLS_OptIn_Navigation_Bar_Title");
    [self loadTitleText];
    [self loadSpecialOffersView];
    [self loadHyperLinkToPhilipsNews];
    [self loadOptinImage];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [DIRegistrationAppTagging trackPageWithInfo:kRegistrationMarketingOptIn paramKey:nil andParamValue:nil];
    DIRInfoLog(@"Screen name is %@", kRegistrationMarketingOptIn);
    BOOL showNavBar = [URSettingsWrapper sharedInstance].launchInput.registrationFlowConfiguration.hideNavigationBar;
    [self.navigationController setNavigationBarHidden:showNavBar animated:true];
}


#pragma mark Custom Methods


- (void)loadOptinImage {
    if (self.launchInput.registrationContentConfiguration.optinImage != nil) {
        self.optInScreenImage.image = self.launchInput.registrationContentConfiguration.optinImage;
    } else {
        self.optInScreenImage.hidden = true;
    }
}


- (void)loadHyperLinkToPhilipsNews {
    UIDHyperLinkModel *hyperLinkModel = [[UIDHyperLinkModel alloc] init];
    [self.whatDoesThisMeanLabel addLink:hyperLinkModel handler:^(NSRange range) {
        [self performSegueWithIdentifier:kURPhilipsNewsSegue sender:nil];
    }];
}


- (void)loadTitleText {
    if (self.launchInput.registrationContentConfiguration.optInQuessionaryText != nil) {
        [self.optInTitleLabel setText:self.launchInput.registrationContentConfiguration.optInQuessionaryText];
    }
}

- (void)loadSpecialOffersView {

    UIDTheme *theme = [[UIDThemeManager sharedInstance] defaultTheme];
    self.promotionalMessageTitleLabel.textColor = [theme contentItemTertiaryText];
    self.promotionMessageBackGroundView.backgroundColor = [theme contentTertiaryBackground];
    NSString *specialOffersTitle = self.launchInput.registrationContentConfiguration.optInDetailDescription == nil ? LOCALIZE(@"USR_DLS_Optin_Body_Line1") : self.launchInput.registrationContentConfiguration.optInDetailDescription;
    NSString *specialOffersDetailText = self.launchInput.registrationContentConfiguration.optInBannerText == nil ? LOCALIZE(@"USR_DLS_Optin_Body_Line2") : self.launchInput.registrationContentConfiguration.optInBannerText;
    [self.specialOffersLabel setText:specialOffersTitle];
    [self.joinNowLabel setText:specialOffersDetailText];

}


- (void)navigateToScreen {
    if (self.userRegistrationHandler.userLoggedInState <= UserLoggedInStatePendingVerification && !self.userRegistrationHandler.isEmailVerified) {
        if ([self.userRegistrationHandler.userIdentifier isValidEmail]) {
            [self performSegueWithIdentifier:kRegistrationVerifyEmailSegue sender:nil];
        } else {
            [self performSegueWithIdentifier:kRegistrationShowAccountActivationSegue sender:nil];
        }
    } else {
        [self popOutOfRegistrationViewControllersWithError:nil];
    }
}

#pragma mark -
#pragma mark - Action Methods

- (IBAction)optInCountMeIn:(UIDProgressButton *)sender {
    [self.userRegistrationHandler updateReciveMarketingEmail:YES];
    self.selectedButtonTracker = YES;
    [sender setIsActivityIndicatorVisible:YES];
    sender.progressTitle = LOCALIZE(@"USR_DLS_OptIn_Button1_Title");
    [self startActivityIndicator];
    [DIRegistrationAppTagging trackActionWithInfo:kRegRemarketingOptIn paramKey:nil andParamValue:nil];
    DIRInfoLog(@"%@.optInCountMeIn clicked", kRegRemarketingOptIn);
}


- (IBAction)optInNoThanks:(UIDProgressButton *)sender {
    [self.userRegistrationHandler updateReciveMarketingEmail:NO];
    self.selectedButtonTracker = NO;
    [self startActivityIndicator];
    [sender setIsActivityIndicatorVisible:YES];
    sender.progressTitle = LOCALIZE(@"USR_DLS_OptIn_Button2_Title");
    [DIRegistrationAppTagging trackActionWithInfo:kRegRemarketingOptOut paramKey:nil andParamValue:nil];
    DIRInfoLog(@"%@.optInNoThanks clicked", kRegRemarketingOptIn);
}

#pragma mark - 
#pragma mark - UserDetailsDelegate

- (void)didUpdateSuccess {
    [super didUpdateSuccess];
    self.selectedButtonTracker ? [self.countMeInButton setIsActivityIndicatorVisible:NO] : [self.maybeLaterButton setIsActivityIndicatorVisible:NO];
    [self navigateToScreen];
}


- (void)didUpdateFailedWithError:(NSError *)error {
    [super didUpdateFailedWithError:error];
    self.selectedButtonTracker ? [self.countMeInButton setIsActivityIndicatorVisible:NO] : [self.maybeLaterButton setIsActivityIndicatorVisible:NO];
    [self showNotificationBarErrorViewWithTitle:error.localizedDescription];
}

#pragma mark -
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:kRegistrationVerifyEmailSegue] || [segue.identifier isEqualToString:kRegistrationShowAccountActivationSegue]){
        RegistrationBaseViewController *registrationVerificationVC= segue.destinationViewController;
        registrationVerificationVC.title = LOCALIZE(@"USR_DLS_URCreateAccount_NavTitle");;
    }
}

#pragma mark - Reachability Status

- (void) updateConnectionStatus:(BOOL) connectionAvailable {
    [super updateConnectionStatus:connectionAvailable];
    [self.countMeInButton setEnabled:connectionAvailable];
    [self.maybeLaterButton setEnabled:connectionAvailable];
}

@end
