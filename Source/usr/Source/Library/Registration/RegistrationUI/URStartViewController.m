//  URStartViewController.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "URStartViewController.h"
#import "URAlmostDoneViewController.h"
#import "JRCapture.h"
#import "CountrySelectionViewController.h"
#import "URSocialMergeViewController.h"
#import "URTraditionalMergeViewController.h"
#import "URVerifySMSViewController.h"
#import "RegistrationUtility.h"

@import PhilipsIconFontDLS;


static NSString *const kMyPhilips = @"myphilips";

@interface URStartViewController () 

@property (nonatomic, weak)   IBOutlet UIDLabel           *startViewTitleText;
@property (nonatomic, weak)   IBOutlet UIDLabel           *startViewDetailText;
@property (weak, nonatomic)   IBOutlet UIDHyperLinkLabel  *privacyPolicyLinkTextLabel;
@property (weak, nonatomic)   IBOutlet UIDHyperLinkLabel  *countryLinkTextLabel;
@property (nonatomic, weak)   IBOutlet UIDButton          *skipRegistrationButton;
@property (nonatomic, weak)   IBOutlet UIDButton          *createButton;
@property (nonatomic, weak)   IBOutlet UIDButton          *loginButton;
@property (nonatomic, weak)   IBOutlet UIView             *backgroundView;
@property (nonatomic, weak)   IBOutlet UIStackView        *socialButtonsStackView;
@property (nonatomic, weak)   IBOutlet UIStackView        *topStackView;
@property (nonatomic, weak)   IBOutlet UIStackView        *bottomStackView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *placeholderConstraint;

@property (nonatomic, strong) NSDictionary                *socialProvidersDic;
@property (nonatomic, strong) NSArray                     *signInProviders;
@property (nonatomic, strong) NSString                    *socialProviderAuthorizedEmail;
@property (nonatomic, strong) NSString                    *existingProviderName;
@property (nonatomic, assign) BOOL                         shouldTrackPage;
@property (nonatomic, assign) BOOL                         isSocialRegistration;

@end

@implementation URStartViewController


#pragma mark UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldTrackPage = YES;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, MAXFLOAT);
    // Do any additional setup after loading the view.
    [self initialUISetup];
    self.title = LOCALIZE(@"USR_DLS_StratScreen_Nav_Title_Txt");
    [self arrangeTopView];
    [self loadSocialButtonsStackView];
    self.countryLinkTextLabel.text = @"";
    [self loadPrivacyPolicyLinkText];
    [self updateCountryLinkText];
    DIRDebugLog(@"%@", [RegistrationUtility getURConfigurationLog]);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.shouldTrackPage) {
        [DIRegistrationAppTagging trackPageWithInfo:kRegistrationHome paramKey:nil andParamValue:nil];
        DIRInfoLog(@"Screen name is %@", kRegistrationHome);
    }
    [self updateCountryText];
     BOOL showNavBar = [URSettingsWrapper sharedInstance].launchInput.registrationFlowConfiguration.hideNavigationBar;
    [self.navigationController setNavigationBarHidden:showNavBar animated:true];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateBottomStackView];
    [self updateBottomViewConstraints];
}

    
#pragma mark - Custom Methods
#pragma mark -

- (void)loadPrivacyPolicyLinkText {
    UIDHyperLinkModel *hyperLinkModel = [[UIDHyperLinkModel alloc] init];
    [self.privacyPolicyLinkTextLabel addLink:hyperLinkModel handler:^(NSRange range) {
        id<DIRegistrationConfigurationDelegate> delegate = [URSettingsWrapper sharedInstance].launchInput.delegate;
        if ([delegate respondsToSelector:@selector(launchPrivacyPolicy)]) {
            [delegate launchPrivacyPolicy];
        }
    }];
}
    
    
- (void)updateCountryLinkText {
    UIDHyperLinkModel *hyperLinkModel = [[UIDHyperLinkModel alloc] init];
    [self.countryLinkTextLabel addLink:hyperLinkModel handler:^(NSRange range) {
        [self performSegueWithIdentifier:kCountrySelectionViewControllerSegue sender:nil];
    }];
}


- (void)updateCountryText {
    NSString *localizedCountryName = [self localizedCountryNameForCountryCode:[URSettingsWrapper sharedInstance].countryCode];
    if (![self.countryLinkTextLabel.text isEqualToString:localizedCountryName]) {
        [self startActivityIndicator];
        [self.userRegistrationHandler countryCodeWithCompletion:^(NSString * _Nullable countryCode, NSError * _Nullable error) {
            [self stopActivityIndicator];
            if (error) {
                [self showNotificationBarErrorViewWithTitle:error.localizedDescription];
            } else {
                NSString *countryButtonTitleText = [self localizedCountryNameForCountryCode:countryCode];
                self.countryLinkTextLabel.text = countryButtonTitleText;
                [self updateCountryLinkText];
                [self updateUIToMatchCountry];
                [self removeSubviewsFromSocialButtonStackView];
                [self loadSocialButtonsStackView];
                [NSLayoutConstraint deactivateConstraints:@[self.placeholderConstraint]];
                [self updateBottomViewConstraints];
                if (self.connectionAvailable == true) {
                    [self.bottomStackView setHidden:NO];
                }
            }
        }];
    }
}


- (NSString *)localizedCountryNameForCountryCode:(NSString *)countryCode {
    NSString *countryCodeKey = [NSString stringWithFormat:@"USR_Country_%@", countryCode];
    NSString *localizedCountry = [[URSettingsWrapper sharedInstance].dependencies.appInfra.languagePack localizedStringForKey:countryCodeKey];
    if (localizedCountry.length <= 0 || [localizedCountry isEqualToString:countryCodeKey]) {
        localizedCountry = LOCALIZE(countryCodeKey);
        if (localizedCountry.length <= 0 || [localizedCountry isEqualToString:countryCodeKey]) {
            localizedCountry = [[NSLocale localeWithLocaleIdentifier:[NSBundle mainBundle].preferredLocalizations.firstObject] displayNameForKey:NSLocaleCountryCode value:countryCode];
        }
    }
    NSString *localizedCountryName = [NSString stringWithFormat:@"%@: %@",LOCALIZE(@"USR_Country_Region"),localizedCountry];
    return localizedCountryName;
}


- (void)initialUISetup {
    URLaunchInput *launchInput = [URSettingsWrapper sharedInstance].launchInput;
    NSAttributedString *valueForRegistration = launchInput.registrationContentConfiguration.valueForRegistrationTitle;
    if (valueForRegistration.length != 0) {
        self.startViewTitleText.attributedText = valueForRegistration;
    }
    NSAttributedString *detailDescForRegistration = launchInput.registrationContentConfiguration.valueForRegistrationDescription;
    if (detailDescForRegistration.length != 0) {
        self.startViewDetailText.attributedText = detailDescForRegistration;
    }
    [self.skipRegistrationButton setHidden:!launchInput.registrationFlowConfiguration.enableSkipRegistration];
}


- (void)updateUIToMatchCountry {
    [self stopActivityIndicator];
    [self updateBottomStackView];
    DIRegistrationFlowConfiguration *flowConfiguration = [URSettingsWrapper sharedInstance].launchInput.registrationFlowConfiguration;
    self.signInProviders = [NSArray arrayWithArray:flowConfiguration.signInProviders];
    [RegistrationUtility checkForUnsupportedSigninProviders:self.signInProviders];
    [self.scrollView layoutIfNeeded];
}
    
    
- (void)updateBottomStackView {
    NSString *countryText = self.countryLinkTextLabel.text;
    NSString *privacyText = self.privacyPolicyLinkTextLabel.text;
    CGSize countryTextSize = [countryText sizeWithAttributes:@{NSFontAttributeName: self.countryLinkTextLabel.font}];
    CGSize privacyTextSize = [privacyText sizeWithAttributes:@{NSFontAttributeName: self.privacyPolicyLinkTextLabel.font}];
    CGFloat textWidth = MAX(countryTextSize.width, privacyTextSize.width);
    if (textWidth <= (self.bottomStackView.frame.size.width/2)) {
        [self.bottomStackView setAxis:UILayoutConstraintAxisHorizontal];
        [self.bottomStackView setSpacing:0.0];
        [self.privacyPolicyLinkTextLabel setTextAlignment:NSTextAlignmentLeft];
        [self.countryLinkTextLabel setTextAlignment:NSTextAlignmentRight];
    } else {
        [self.bottomStackView setAxis:UILayoutConstraintAxisVertical];
        [self.bottomStackView setSpacing:16.0];
        [self.privacyPolicyLinkTextLabel setTextAlignment:NSTextAlignmentCenter];
        [self.countryLinkTextLabel setTextAlignment:NSTextAlignmentCenter];
    }
    //Block privacy link label click
    DIRegistrationFlowConfiguration *flowConfiguration = [URSettingsWrapper sharedInstance].launchInput.registrationFlowConfiguration;
    if (flowConfiguration.hideCountrySelection == true) {
        [self.countryLinkTextLabel setText:@""];
        [self.bottomStackView setDistribution:UIStackViewDistributionFill];
        [[self.privacyPolicyLinkTextLabel.widthAnchor  constraintEqualToConstant:150.0] setActive:true];
    }
}


- (void)arrangeTopView {
    URLaunchInput *launchInput =[URSettingsWrapper sharedInstance].launchInput;
    if (launchInput.registrationFlowConfiguration.priorityFunction == URPriorityFunctionSignIn) {
        UIStackView *buttonsStackView = self.topStackView.arrangedSubviews[0];
        UIView *createButtonView = buttonsStackView.arrangedSubviews[0];
        UIView *loginButtonView =  buttonsStackView.arrangedSubviews[1];
        [buttonsStackView insertArrangedSubview:loginButtonView atIndex:0];
        [buttonsStackView insertArrangedSubview:createButtonView atIndex:1];
        UIStackView *socialButtonStackView = self.topStackView.arrangedSubviews[1];
        UILabel *orLoginWithLabel = socialButtonStackView.arrangedSubviews[0];
        [orLoginWithLabel setText:LOCALIZE(@"USR_DLS_OR_With_Label_Text")];
        UILabel *orLabel = socialButtonStackView.arrangedSubviews[2];
        [orLabel setHidden:NO];
        UIView *continueWithoutAccountButton = self.topStackView.arrangedSubviews[2];
        [self.topStackView insertArrangedSubview:socialButtonStackView atIndex:0];
        [self.topStackView insertArrangedSubview:buttonsStackView atIndex:1];
        [self.topStackView insertArrangedSubview:continueWithoutAccountButton atIndex:2];
    }
}


- (void)loadSocialButtonsStackView {
    [self checkSocialProvidersExistance];
    for (NSUInteger i = 0; i < self.signInProviders.count; i++) {
        NSString *provider = self.signInProviders[i];
        UIDSocialButton *socialButton = [UIDSocialButton buttonWithType:UIButtonTypeCustom];
        NSArray *socialProviders = [NSArray arrayWithObjects:kProviderNameApple,kProviderNameGoogle,kProviderNameFacebook,nil];
        NSDictionary *socialProviderIcons = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"AppleLogo",@"Google",@"FaceBook", nil] forKeys:socialProviders];
        NSDictionary *socialProviderDarkIcons = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"AppleLogoDark",@"GoogleDark",@"FaceBookDark", nil] forKeys:socialProviders];
        if ([socialProviders containsObject:provider]) {
            URLaunchInput *launchInput =[URSettingsWrapper sharedInstance].launchInput;
            NSString *imageName = (launchInput.registrationFlowConfiguration.showSocialIconsInDarkTheme == false) ? [socialProviderIcons objectForKey:provider] : [socialProviderDarkIcons objectForKey:provider];
            UIImage *socailImage = [UIImage imageNamed:imageName inBundle:RESOURCE_BUNDLE  compatibleWithTraitCollection:nil];
            [socialButton setTitle:nil forState:UIControlStateNormal];
            [socialButton setBackgroundImage:socailImage forState:UIControlStateNormal];
        } else if ([provider isEqualToString:kProviderNameWeChat]) {
            socialButton.titleLabel.font = [UIFont iconFontWithSize:32];
            [socialButton setSocialMediaType:SocialMediaTypeWeChat];
        } else {
            continue;
        }
        [socialButton setTag:(NSInteger)i];
        socialButton.accessibilityIdentifier = [NSString stringWithFormat:@"%@%@%@", @"usr_startscreen_",provider, @"_button"];
        [socialButton addTarget:self action:@selector(loginThroughSocialProvider:) forControlEvents:UIControlEventTouchUpInside];
        [socialButton setEnabled:self.connectionAvailable];
        [self.socialButtonsStackView addArrangedSubview:socialButton];
        if (i == 3) {
            break;
        }
    }
    [self.view layoutIfNeeded];
}


- (void)removeSubviewsFromSocialButtonStackView {
    [self.socialButtonsStackView.arrangedSubviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


- (void)checkSocialProvidersExistance {
    UIStackView *socialButtonStack;
    URLaunchInput *launchInput =[URSettingsWrapper sharedInstance].launchInput;
    if (launchInput.registrationFlowConfiguration.priorityFunction == URPriorityFunctionSignIn) {
        socialButtonStack = self.topStackView.arrangedSubviews[0];
    } else {
        socialButtonStack = self.topStackView.arrangedSubviews[1];
    }
    if (self.connectionAvailable == true) {
        [socialButtonStack setHidden:![self.signInProviders count]];
    }
}


- (void)loginThroughSocialProvider:(UIDButton *)sender {
    
    if (self.connectionAvailable == false) {
        return;
    }
    
    __weak typeof(self) weakObj = self;
    [weakObj startActivityIndicator];
    [[DIUser getInstance] checkIfJanrainFlowDownloadedWithCompletion:^(NSError * flowDownloadError) {
        if (!flowDownloadError) {
            [self showHiddenView];
            weakObj.shouldTrackPage = NO;
            NSString *providerName = (sender == nil) ? kProviderNameApple : self.signInProviders[(NSUInteger)sender.tag];
            [weakObj.userRegistrationHandler loginUsingProvider:providerName];
            if (weakObj) {
                [DIRegistrationAppTagging trackActionWithInfo:kRegSendData params:@{kRegLoginChannel:providerName}];
            }
            [weakObj trackSocialProviderAsPage:providerName];
            [weakObj hideNotificationBarErrorView];
        } else {
            [weakObj stopActivityIndicator];
            [self showNotificationBarErrorViewWithTitle:flowDownloadError.localizedDescription];
        }
    }];
}


- (void)trackSocialProviderAsPage:(NSString *)providerName {
    if ([providerName isEqual:kMyPhilips]) {
        return;
    }
    [DIRegistrationAppTagging trackPageWithInfo:kRegistrationSocialProvider(providerName) paramKey:nil andParamValue:nil];
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


- (void)verifyConditionsAndNavigateToNextScreen {
    if (self.loginFlowType == RegistrationLoginFlowTypeMobile && self.userRegistrationHandler.email && !self.userRegistrationHandler.isEmailVerified) {
        [self performSegueWithIdentifierForSocialProvider:kRegistrationVerifyEmailSegue withSender:nil];
    } else {
        [self popOutOfRegistrationViewControllersWithError:nil];
    }
}


#pragma mark - Registration delegates

- (void)didSocialRegistrationReachedSecoundStepWithUser:(DIUser *)profile withProvide:(NSString *)providerName {
    self.isSocialRegistration = YES;
    self.providerName = providerName;
    [self performSegueWithIdentifierForSocialProvider:kRegisterSocialSignInSegue withSender:nil];
}


- (void)didRegisterFailedwithError:(NSError *)error {
    [super didRegisterFailedwithError:error];
    self.providerName = error.userInfo[kProviderKey];
    
    switch (error.code) {
        case DIMergeFlowErrorCode: {
            [self performSegueWithIdentifierForSocialProvider:kRegistrationAccountsMergeSegue withSender:self];
            break;
        }
        default: {
            [self showNotificationBarErrorViewWithTitle:error.localizedDescription ? error.localizedDescription : [NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), error.code]];
            break;
        }
    }
}


- (void)socialLoginCannotLaunch:(NSError *)error {
    [super socialLoginCannotLaunch:error];
    if (error.code != DIRegWeChatAccountsError) {
        [self showNotificationBarErrorViewWithTitle:error.localizedDescription];
    }
    [DIRegistrationAppTagging trackPageWithInfo:kRegistrationHome paramKey:nil andParamValue:nil];
}


- (void)socialAuthenticationCanceled {
    [super socialAuthenticationCanceled];
    [DIRegistrationAppTagging trackPageWithInfo:kRegistrationHome paramKey:nil andParamValue:nil];
}


- (void)socialAuthenticationDidFailedWithError:(NSError*)error withProvider:(NSString *)provider {
    [super socialAuthenticationDidFailedWithError:error withProvider:provider];
    [self showNotificationBarErrorViewWithTitle:error.localizedDescription];
    [DIRegistrationAppTagging trackPageWithInfo:kRegistrationHome paramKey:nil andParamValue:nil];
}


- (void)didLoginWithSuccessWithUser:(DIUser *)profile {
    [super didLoginWithSuccessWithUser:profile];
    [self showHiddenView];
    BOOL personalConsentReqd = [self isPersonalConsentViewToBeShown];
    URReceiveMarketingFlow flow = [URSettingsWrapper sharedInstance].experience;
    BOOL isReceiveMarketingReqd = (((flow == URReceiveMarketingFlowCustomOptin) || (flow == URReceiveMarketingFlowSkipOptin)) == true) ?
    false : !profile.receiveMarketingEmails;
    if ((![RegistrationUtility hasUserAcceptedTermsnConditions:profile.userIdentifier]) || isReceiveMarketingReqd || personalConsentReqd ) {
        self.isSocialRegistration = NO;
        [self performSegueWithIdentifierForSocialProvider:kRegisterSocialSignInSegue withSender:nil];
    } else {
        [self verifyConditionsAndNavigateToNextScreen];
    }
}


- (void)didAuthenticationCompleteForLogin:(NSString *)email {
    [super didAuthenticationCompleteForLogin:email];
    self.socialProviderAuthorizedEmail = email;
}


- (void)didLoginFailedwithError:(NSError *)error {
    [super didLoginFailedwithError:error];
    if (error.code == DINotVerifiedEmailErrorCode) {
        [self performSegueWithIdentifierForSocialProvider:kRegistrationVerifyEmailSegue withSender:nil];
    } else if (error.code == DINotVerifiedMobileErrorCode) {
        [self performSegueWithIdentifierForSocialProvider:kRegistrationShowAccountActivationSegue withSender:nil];
    } else {
        [self showNotificationBarErrorViewWithTitle:error.localizedDescription ? error.localizedDescription : [NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), error.code]];
    }
}


- (void)handleAccountSocailMergeWithExistingAccountProvider:(NSString *)existingAccountProvider provider:(NSString *)provider {
    self.providerName = provider;
    self.existingProviderName = existingAccountProvider;
    [self performSegueWithIdentifierForSocialProvider:kRegistrationSocialMergeSegue withSender:nil];
}


#pragma mark - JanrainFlowDelegate Method

- (void)didFailToDownloadJanrainFlow:(NSError *)error {
    [super didFailToDownloadJanrainFlow:error];
    [self showNotificationBarErrorViewWithTitle:[NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), error.code]];
}


#pragma mark - Navigation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self updateBottomStackView];
        [self updateBottomViewConstraints];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {}];
}


- (void)performSegueWithIdentifierForSocialProvider:(NSString *)segue withSender:(nullable id)sender {
    [self performSegueWithIdentifier:segue sender:sender];
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    self.shouldTrackPage = YES;
    if ([segue.identifier isEqualToString:kRegistrationAccountsMergeSegue]) {
        URTraditionalMergeViewController *registrationAccountsMergeVC = segue.destinationViewController;
        registrationAccountsMergeVC.providerName = self.providerName;
        registrationAccountsMergeVC.socialProviderAuthorizedEmail = self.socialProviderAuthorizedEmail;
    } else if ([segue.identifier isEqualToString:kRegisterSocialSignInSegue]) {
        URAlmostDoneViewController *regisSocialSignInVC = segue.destinationViewController;
        regisSocialSignInVC.providerName = self.providerName;
        if (self.isSocialRegistration) {
            regisSocialSignInVC.almostDoneFlowType = URAlmostDoneFlowTypeSocialRegistration;
            regisSocialSignInVC.title = LOCALIZE(@"USR_SigIn_TitleTxt");
        } else {
            regisSocialSignInVC.almostDoneFlowType = URAlmostDoneFlowTypeSocialLogIn;
        }
    } else if ([segue.identifier isEqualToString:kRegistrationSocialMergeSegue]) {
        URSocialMergeViewController *registrationSocialMergeVC = segue.destinationViewController;
        registrationSocialMergeVC.providerName = self.providerName;
        registrationSocialMergeVC.socialProviderAuthorizedEmail = self.socialProviderAuthorizedEmail;
        registrationSocialMergeVC.existingProviderName = self.existingProviderName;
    } else if ([segue.identifier isEqualToString:kRegistrationVerifyEmailSegue]) {
        RegistrationBaseViewController *registrationVerificationVC= segue.destinationViewController;
        registrationVerificationVC.title = LOCALIZE(@"USR_SigIn_TitleTxt");
    } else if ([segue.identifier isEqualToString:kRegistrationShowAccountActivationSegue]) {
        URVerifySMSViewController *urVerifySMSViewController = segue.destinationViewController;
        urVerifySMSViewController.enterCodeFlowType = EnterCodeFlowTypeVerification;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{ // This needs to be added to main queue otherwise completion will not execute
        [self.transitionCoordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
         {
             [self stopActivityIndicator];
         }];
        
    });
}


#pragma mark - Connection Status

- (void)updateConnectionStatus:(BOOL) connectionAvailable {
    [super updateConnectionStatus:connectionAvailable];
    if (connectionAvailable) {
        [self updateCountryText];
    }
    [self toggleBtn:connectionAvailable];
    [self.bottomStackView setHidden:!connectionAvailable];
}


- (void)toggleBtn:(BOOL)enable {
    self.createButton.enabled = enable;
    self.loginButton.enabled = enable;
    [self toggleTheSocialButtons:enable];
}


- (void)toggleTheSocialButtons:(BOOL)enable {
    for (UIButton *button in self.socialButtonsStackView.arrangedSubviews) {
        [button setEnabled:enable];
    }
}


#pragma mark IBActions

- (IBAction)createMyPhilipsAccountBtn:(id)sender {
    DIRInfoLog(@"%@.createMyPhilipsAccountBtn clicked", kRegistrationHome);
    __weak typeof(self) weakObj = self;
    [self startActivityIndicator];
    [[DIUser getInstance] checkIfJanrainFlowDownloadedWithCompletion:^(NSError * flowDownloadError) {
        [weakObj stopActivityIndicator];
        if (!flowDownloadError) {
            [weakObj performSegueWithIdentifier:kRegistrationTraditionalRegisterSegue sender:nil];
            if (weakObj) {
                [DIRegistrationAppTagging trackActionWithInfo:kRegSendData params:@{kRegSpecialEvents:kRegStartUserRegistration}];
            }
        } else {
            [weakObj showNotificationBarErrorViewWithTitle:flowDownloadError.localizedDescription];
        }
    }];
}


- (IBAction)loginUsingPhilipsAccount:(id)sender {
    DIRInfoLog(@"%@.loginUsingPhilipsAccount clicked", kRegistrationHome);
    __weak typeof(self) weakObj = self;
    [self startActivityIndicator];
    [[DIUser getInstance] checkIfJanrainFlowDownloadedWithCompletion:^(NSError * flowDownloadError) {
        [weakObj stopActivityIndicator];
        if (!flowDownloadError) {
            [weakObj performSegueWithIdentifier:kRegistrationTraditionalSignInSegue sender:nil];
            if (weakObj) {
                [DIRegistrationAppTagging trackActionWithInfo:kRegSendData params:@{kRegLoginChannel:kMyPhilips}];
            }
            [weakObj hideNotificationBarErrorView];
        } else {
            [weakObj showNotificationBarErrorViewWithTitle:flowDownloadError.localizedDescription];
        }

    }];
}


- (IBAction)skipRegistration:(id)sender {
    DIRInfoLog(@"%@.skipRegistration clicked", kRegistrationHome);
    NSError *error = [NSError errorWithDomain:@"PhilipsRegistration" code:RegistrationCompletionErrorCodeSkippedRegistration userInfo:nil];
    [DIRegistrationAppTagging trackActionWithInfo:kRegSendData params:@{kRegSpecialEvents:kRegSkippedUserRegistration}];
    [DIRegistrationAppTagging trackActionWithInfo:kRegSendData params:@{kRegLoginChannel:kRegSkippedUserRegistration}];
    [self popOutOfRegistrationViewControllersWithError:error];
}


@end
