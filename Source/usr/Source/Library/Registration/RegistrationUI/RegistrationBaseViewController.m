
//
//  RegistrationBaseViewController.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "RegistrationBaseViewController.h"
#import "RegistrationUIView+Helper.h"
#import "URPhilipsNewsViewController.h"

@interface RegistrationBaseViewController ()

@property (nonatomic, weak) IBOutlet UIDView            *activityIndicatorHidingView;
@property (nonatomic, strong) UIView                    *activityTransparentView;
@property (nonatomic, strong) UIToolbar                 *keyboardToolbar;

@end

@implementation RegistrationBaseViewController


#pragma mark - Life cycle methods
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userRegistrationHandler = [DIUser getInstance];
    [self initialSetup];
    [self startReachablity];
    
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [toolbarItems addObject:flexSpace];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
    [doneButton setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"CentraleSansBook" size:18.0]} forState:UIControlStateNormal];
    [toolbarItems addObject:doneButton];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar sizeToFit];
    toolbar.items = toolbarItems;
    self.keyboardToolbar = toolbar;
    
    /** Set Exclusive-Touch for buttons */
    [self.view setExclusiveTouchForButtons];/** Disable the Multiple Touch for Buttons */
    [self.backgroundImage setBackgroundColor:[[[UIDThemeManager sharedInstance] defaultTheme] contentPrimary]];
    
    [self initializeNotificationBar];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.userRegistrationHandler addUserRegistrationListener:self];
    [self.userRegistrationHandler addUserDetailsListener:self];
    [self.userRegistrationHandler addSessionRefreshListener:self];
    [self registerForKeyboardNotifications];
    [self updateConnectionStatus:self.connectionAvailable];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //Below if case is only not to remove the listener when we are presenting the social sign in screen.
    if (![self isPresentingJanrianWebView]) {
        [self.userRegistrationHandler removeUserRegistrationListener:self];
        [self.userRegistrationHandler removeUserDetailsListener:self];
        [self.userRegistrationHandler removeSessionRefreshListener:self];
    }
    [self removeKeyboardNotifications];
}


- (void)dealloc {
    [URSettingsWrapper.sharedInstance.dependencies.appInfra.RESTClient stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAILReachabilityChangedNotification object:nil];
}

#pragma mark - Custom Methods
#pragma mark -

- (void)trackingABTesting {
    switch ([URSettingsWrapper sharedInstance].experience) {
        case URReceiveMarketingFlowSplitSignUp:
            [DIRegistrationAppTagging trackActionWithInfo:kRegSendData paramKey:kABTest andParamValue:kRegistration1SplitSignUp];
            break;
        case URReceiveMarketingFlowCustomOptin:
            [DIRegistrationAppTagging trackActionWithInfo:kRegSendData paramKey:kABTest andParamValue:kRegistration1CustomScreen];
            break;
        case URReceiveMarketingFlowSkipOptin:
            [DIRegistrationAppTagging trackActionWithInfo:kRegSendData paramKey:kABTest andParamValue:kRegistration1SkipScreen];
            break;
        case URReceiveMarketingFlowControl:
        default:
            [DIRegistrationAppTagging trackActionWithInfo:kRegSendData paramKey:kABTest andParamValue:kRegistration1Control];
            break;
    }
}


- (void)doneButtonTapped:(id)sender {
    [self.view endEditing:YES];
}


- (void)initialSetup {
    self.activityTransparentView = [[UIView alloc]init];
    self.activityTransparentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.activityTransparentView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[activityTransparentView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"activityTransparentView":self.activityTransparentView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[activityTransparentView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"activityTransparentView":self.activityTransparentView}]];
    self.activityTransparentView.backgroundColor = [UIColor clearColor];
    self.activityTransparentView.hidden = YES;
    self.backgroundImage.image = [[UIDThemeManager sharedInstance] defaultTheme].applicationBackgroundImage;
}

- (void)initializeNotificationBar {
    self.notificationBarView = [[UIDNotificationBarView alloc] init];
    self.notificationBarView.notificationBarType = UIDNotificationBarTypeTextOnly;
    self.notificationBarView.delegate = self;
    self.notificationBarView.backgroundColor = [[[UIDThemeManager sharedInstance] defaultTheme] trackWarningOnBackground];
    self.notificationBarView.titleMessage = LOCALIZE(@"USR_Network_ErrorMsg");
    self.notificationBarView.hidden = YES;
    [self.view addSubview:self.notificationBarView];
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.notificationBarView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.notificationBarView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *top;
    top = [NSLayoutConstraint constraintWithItem:self.notificationBarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view.safeAreaLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.view addConstraints:@[left, right, top]];
}

- (void)startActivityIndicator {
    [self.activityIndicatorView startAnimating];
    [self.view bringSubviewToFront:self.activityTransparentView];
    [UIView animateWithDuration:0.5 animations:^{
        self.activityTransparentView.hidden = NO;
    }];
}


- (void)stopActivityIndicator {
    [self.activityIndicatorView stopAnimating];
    [UIView animateWithDuration:0.5 animations:^{
        self.activityTransparentView.hidden = YES;
        self.activityIndicatorHidingView.hidden = YES;
    }];
}


- (void)showHiddenView {
    self.activityIndicatorHidingView.hidden = NO;
}


- (void)hideHiddenView {
    self.activityIndicatorHidingView.hidden = YES;
}


- (BOOL)isPresentingJanrianWebView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    UIViewController *vcToPresentFrom = window.rootViewController;
    while (vcToPresentFrom.presentedViewController) {
        vcToPresentFrom = vcToPresentFrom.presentedViewController;
    }
    BOOL isPresentingWebVC = NO;
    if ([vcToPresentFrom isKindOfClass:[UINavigationController class]]) {
        UINavigationController *vcToPresentFromNavi = (UINavigationController *)vcToPresentFrom;
        isPresentingWebVC = [vcToPresentFromNavi.topViewController isKindOfClass:NSClassFromString(@"JRWebViewController")];
    } else if ([vcToPresentFrom isKindOfClass:[NSClassFromString(@"SFSafariViewController") class]] || [vcToPresentFrom isKindOfClass:NSClassFromString(@"FBSDKContainerViewController")]) {
        isPresentingWebVC = YES;
    }
    return isPresentingWebVC;
}


- (void)registrationSignout {
    [self.userRegistrationHandler logout];
}


- (RegistrationLoginFlowType)loginFlowType {
    return [[URSettingsWrapper sharedInstance] loginFlowType];
}

- (void)showWeChatErrorAlert {
    UIDAlertController *alertVC = [[UIDAlertController alloc] initWithTitle:LOCALIZE(@"USR_AppNotInstalled_Alert_Title") icon:nil message:[NSString stringWithFormat: LOCALIZE(@"USR_App_NotInstalled_AlertMessage"),LOCALIZE(@"wechat")]];
    UIDAction *installWeChatAction = [[UIDAction alloc] initWithTitle:LOCALIZE(@"USR_DLS_Button_Title_Ok") style:UIDActionStylePrimary handler:nil];
    [alertVC addAction:installWeChatAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}


- (void)removeTextFieldErrors {
    [self.view removeTextFieldErrors];
}


- (void)showNotificationBarErrorViewWithTitle:(NSString *)errorMessage {
    if ([errorMessage length] > 0) {
        [self.notificationBarView setDescriptionMessage:@""];
        [self.notificationBarView setHidden:NO];
        [self.notificationBarView setTitleMessage:errorMessage];
    }
}


- (void)hideNotificationBarErrorView {
    [self.notificationBarView setHidden:YES];
}

-(BOOL)isPersonalConsentViewToBeShown {
    URLaunchInput *launchInput = URSettingsWrapper.sharedInstance.launchInput;
    if ([launchInput isPersonalConsentToBeShown] != true) {
        return false;
    }
    return (launchInput.registrationFlowConfiguration.userPersonalConsentStatus == ConsentStatesInactive);
}

#pragma mark - Registration delegates
#pragma mark -

- (void)didLoginWithSuccessWithUser:(DIUser *)profile {
    [self stopActivityIndicator];
    [DIRegistrationAppTagging trackActionWithInfo:kRegSendData paramKey:kRegSpecialEvents andParamValue:kRegSuccessLogin];
    [DIRegistrationABTest tageventWithInfo:@"successful_registration_done" params:nil];
}


- (void)didLoginFailedwithError:(NSError *)error {
    [self stopActivityIndicator];
}


- (void)didSocialRegistrationReachedSecoundStepWithUser:(DIUser *)profile withProvide:(NSString *)providerName {
    [self stopActivityIndicator];
}


- (void)didAuthenticationCompleteForLogin:(NSString *)email {
    [self startActivityIndicator];
}

- (void)socialLoginCannotLaunch:(NSError *)error {
    if (error.code == DIRegWeChatAccountsError) {
        [self showWeChatErrorAlert];
    }
    [self stopActivityIndicator];
}


- (void)socialAuthenticationCanceled {
    [self stopActivityIndicator];
}


- (void)socialAuthenticationDidFailedWithError:(NSError *)error withProvider:(NSString *)provider {
    [self stopActivityIndicator];
}


- (void)didRegisterSuccessWithUser:(DIUser *)profile {
    [self stopActivityIndicator];
    [DIRegistrationAppTagging trackActionWithInfo:kRegSendData paramKey:kRegSpecialEvents andParamValue:kRegSuccessUserCreation];
    [DIRegistrationABTest tageventWithInfo:@"successful_registration_done" params:nil];
}


- (void)didRegisterFailedwithError:(NSError *)error {
    [self stopActivityIndicator];
}


- (UIDAlertController *)forgotPasswordSuccessAlert {
    NSString *messageBody = [NSString stringWithFormat:@"%@\n\n%@", LOCALIZE(@"USR_DLS_Forgot_Password_Alert_Message_Line1"), LOCALIZE(@"USR_DLS_Email_Verify_Alert_Body_Line2")];
    return [[UIDAlertController alloc] initWithTitle:LOCALIZE(@"USR_DLS_Forgot_Password_Alert_Title") icon:nil message:messageBody];
}


- (void)didSendForgotPasswordSuccess {
    [self stopActivityIndicator];
    [DIRegistrationAppTagging trackActionWithInfo:kRegSendData paramKey:kRegStatusNotification andParamValue:kRegPasswordResetLinkSent];
}


-(void)didSendForgotPasswordFailedwithError:(NSError *)error {
    [self stopActivityIndicator];
}


-(void)didVerificationForMobileToResetPasswordSuccessWithToken:(NSString *)resetToken {
    [self stopActivityIndicator];
}


-(void)didVerificationForMobileToResetPasswordFailedwithError:(NSError *)error {
    [self stopActivityIndicator];
}


- (void)didResendEmailverificationSuccess {
    [self stopActivityIndicator];
    [DIRegistrationAppTagging trackActionWithInfo:kRegSendData params:@{kRegSpecialEvents:kRegSuccessEmailVerificationResend ,
                                                                        kRegStatusNotification:kRegResendVerificationMailLinkSent}];
}


- (void)didResendEmailverificationFailedwithError:(NSError *)error {
    [self stopActivityIndicator];
}


- (void)didResendMobileverificationSuccess {
    [self stopActivityIndicator];
    [DIRegistrationAppTagging trackActionWithInfo:kRegSendData params:@{kRegSpecialEvents:kRegSuccessSMSVerificationResend,
                                                                        kRegStatusNotification:kRegSuccessSMSVerificationResend}];
}


- (void)didResendMobileverificationFailedwithError:(NSError *)error {
    [self stopActivityIndicator];
}


- (void)didHandleMergingSuccess {
    [self stopActivityIndicator];
}


- (void)didFailHandleMerging:(NSError *)error {
    [self stopActivityIndicator];
}


- (void)handleAccountSocailMergeWithExistingAccountProvider:(NSString *)existingAccountProvider provider:(NSString *)provider{
    [self stopActivityIndicator];
}


- (void)didUpdateSuccess {
    [self stopActivityIndicator];
}


- (void)didUpdateFailedWithError:(NSError *)error {
    [self stopActivityIndicator];
}


- (void)didUserInfoFetchingSuccessWithUser:(DIUser *)profile {
    [self stopActivityIndicator];
}


- (void)didUserInfoFetchingFailedWithError:(NSError *)error {
    [self stopActivityIndicator];
}


- (void)loginSessionRefreshSucceed {
    [self stopActivityIndicator];
}


- (void)loginSessionRefreshFailedWithError:(NSError *)error {
    [self stopActivityIndicator];
}


- (void)loginSessionRefreshFailedAndLoggedout {
    [self stopActivityIndicator];
    [self logoutDidSucceed];
}


- (void)logoutDidSucceed {
    [DIRegistrationAppTagging trackActionWithInfo:kRegSendData paramKey:kRegSpecialEvents andParamValue:kRegLogoutSuccess];
    [self stopActivityIndicator];
}


- (void)logoutFailedWithError:(NSError *)error {
    [self stopActivityIndicator];
}

#pragma mark - JanrainFlowDownloadDelegate Methods
#pragma mark -

- (void)didFailToDownloadJanrainFlow:(NSError *)error {
    [self stopActivityIndicator];
}


- (void)didFinishDownloadingJanrainFlow {
    [self stopActivityIndicator];
}

#pragma mark - Keyboard show/hide notification methods
#pragma mark -

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}


- (void)removeKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWasShown:(NSNotification *)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.scrollView.contentInset.top, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.scrollView.contentInset.top, 0.0, 0.0, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


#pragma mark - UITextField delegate/private methods
#pragma mark -

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField setInputAccessoryView:self.keyboardToolbar];
}


- (void)textFieldDidEndEditing:(UITextField *)textField {}


- (IBAction)validateTextField:(UITextField *)textField {
    if (textField.secureTextEntry && textField.text.length <= 0) { //Do we need this?
        [textField setFont:nil];
        [textField setFont:[UIFont fontWithName:@"CentraleSansBook" size:14.0]];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    switch (textField.returnKeyType) {
        case UIReturnKeyDefault: {
            [textField resignFirstResponder];
            break;
        }
        case UIReturnKeyGo: {
            [self textFieldPressedGo:textField];
            break;
        }
        case UIReturnKeyNext: {
            UIView *next = [[textField superview] viewWithTag:textField.tag+1];
            [next becomeFirstResponder];
            break;
        }
        default:
            break;
    }
    return YES;
}


- (void)textFieldPressedGo:(UITextField *)textField {}

#pragma mark - UITextViewDelegate Method
#pragma mark -

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    URLaunchInput *launchInput = [URSettingsWrapper sharedInstance].launchInput;
    id<DIRegistrationConfigurationDelegate> delegate = launchInput.delegate;
    BOOL shouldInteract = YES;
    NSString *absoluteURL = [URL absoluteString];
    if ([absoluteURL isEqualToString:kTermAndConditionsUrl]) {
        if ([delegate respondsToSelector:@selector(launchTermsAndConditions)]) {
            [delegate launchTermsAndConditions];
            shouldInteract = NO;
        }
    } else if ([absoluteURL isEqualToString:kLoadPhilipsNewsURLDummy]) {
        [self performSegueWithIdentifier:kURPhilipsNewsSegue sender:nil];
        shouldInteract = NO;
    } else if ([absoluteURL isEqualToString:kPersonalConsentURL]) {
//        [self performSegueWithIdentifier:kURPersonalConsentSegue sender:nil];
        if ([delegate respondsToSelector:@selector(launchPersonalConsentDescription)]) {
            [delegate launchPersonalConsentDescription];
            shouldInteract = NO;
        }
        shouldInteract = NO;
    }
    return shouldInteract;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kURPersonalConsentSegue]) {
        URLaunchInput *launchInput = [URSettingsWrapper sharedInstance].launchInput;
        URPhilipsNewsViewController *newsVC = segue.destinationViewController;
        newsVC.consent = launchInput.registrationContentConfiguration.personalConsent;
    }
}


//This method POPs out of UR only if there are controllers other than URs, on current navigation stack.
//If there are no controllers other than URs, it is assumed that UR is added to a fresh navigation controller
//and that navigation controller is presented. In such case, no controller will be removed. Only completion block will be called
//to allow applications gracefully dismiss the navigation controller.
- (void)popOutOfRegistrationViewControllersWithError:(NSError *)error {
    NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
    NSArray *registrationViewControllers = [self viewControllersOfUserRegistration];
    [registrationViewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[DIUser getInstance] removeUserRegistrationListener:obj];
        [[DIUser getInstance] removeUserDetailsListener:obj];
        [[DIUser getInstance] removeSessionRefreshListener:obj];
    }];
    [viewControllers removeObjectsInArray:registrationViewControllers];
    if (viewControllers.count > 0) {
        BOOL animated = URSettingsWrapper.sharedInstance.launchInput.registrationFlowConfiguration.animateExit;
        [self.navigationController setViewControllers:viewControllers animated:animated];
    }
    [[URSettingsWrapper sharedInstance] executeCompletionHandlerWithError:error];
}


- (NSArray<RegistrationBaseViewController *> *)viewControllersOfUserRegistration {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@", [RegistrationBaseViewController class]];
    NSArray *registrationViewControllers = [self.navigationController.viewControllers filteredArrayUsingPredicate:predicate];
    return registrationViewControllers;
}

#pragma mark - Reachability Methods
#pragma mark -

- (void)startReachablity {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kAILReachabilityChangedNotification object:nil];
    [URSettingsWrapper.sharedInstance.dependencies.appInfra.RESTClient startNotifier];
    self.connectionAvailable = [URSettingsWrapper.sharedInstance.dependencies.appInfra.RESTClient getNetworkReachabilityStatus] != AIRESTClientReachabilityStatusNotReachable;;
    [self updateConnectionStatus:self.connectionAvailable];
}


- (void)reachabilityChanged:(NSNotification *)note {
    self.connectionAvailable = [URSettingsWrapper.sharedInstance.dependencies.appInfra.RESTClient getNetworkReachabilityStatus] != AIRESTClientReachabilityStatusNotReachable;
    [self updateConnectionStatus:self.connectionAvailable];
}


- (void)updateConnectionStatus:(BOOL)connectionAvailable {
    if (!connectionAvailable) {
        [self showNotificationBarErrorViewWithTitle:LOCALIZE(@"USR_Title_NoInternetConnection_Txt")];
        [self.notificationBarView setDescriptionMessage:LOCALIZE(@"USR_Network_ErrorMsg")];
    } else {
        [self hideNotificationBarErrorView];
    }
}

-(void)storePersonalConsent:(BOOL)consentStatus {
    ConsentStates state = (true == consentStatus) ? ConsentStatesActive : ConsentStatesRejected;
    [RegistrationUtility userProvidedPersonalConsent:@"" andStatus:state];
}

#pragma mark - UIDNotificationBarViewDelegate
#pragma mark -

- (void)notificationBar:(UIDNotificationBarView * _Nonnull)notificationBar forTapped:(enum UIDActionButtonType)buttonType {
    [self.notificationBarView setHidden:YES];
}

@end
