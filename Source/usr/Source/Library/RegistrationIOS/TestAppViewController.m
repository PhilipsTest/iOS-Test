//
//  TestAppViewController.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "TestAppViewController.h"
#import <objc/runtime.h>
#import <AppInfra/AppInfra.h>
#import "RegistrationUtility.h"
#import "DIRegistrationVersion.h"
#import "DICOPPAExtension.h"
#import "URLaunchInput.h"
#import "URDependencies.h"
#import "URInterface.h"
#import "ServiceDiscoveryMocked.h"
#import "DIRegistrationConstants.h"
#import "DemoGenderDOBViewController.h"
#import "DILogger.h"
#import "DIUser.h"
#import "DIUser+DataInterface.h"
#import "URExceptionHandler.h"
#import "URConsentProvider.h"

@import PhilipsUIKitDLS;

NSString *currentConfiguration;

@interface TestAppViewController ()<UserDetailsDelegate, SessionRefreshDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UserRegistrationDelegate, JanrainFlowDownloadDelegate, DIRegistrationConfigurationDelegate,HSDPRefreshSessionResultDelegate> {
    URReceiveMarketingFlow marketingFlow;
}
@property (weak, nonatomic) IBOutlet UILabel *lblVersionNumber;
@property (weak, nonatomic) IBOutlet UIDButton *themeButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIDButton *changeConfiguration;
@property (weak, nonatomic) IBOutlet UIDProgressButton *refreshSessionButton;
@property (weak, nonatomic) IBOutlet UIDProgressButton *refreshHSDButton;
@property (weak, nonatomic) IBOutlet UIDProgressButton *logoutButton;
@property (weak, nonatomic) IBOutlet UILabel *refreshSessionStatus;
@property (weak, nonatomic) IBOutlet UIDButton *refetchUserButton;
@property (weak, nonatomic) IBOutlet UILabel *consentStatusLabel;
@property (weak, nonatomic) IBOutlet UIDButton *profileUpdateButton;
@property (weak, nonatomic) IBOutlet UISwitch *serviceDiscoverySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *abTestingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *animateExitSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *presentURSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *hsdpUUIDSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *optinImageSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *personalConsentSwitch;
@property (weak, nonatomic) IBOutlet UILabel *personalConsentLbl;
@property (weak, nonatomic) IBOutlet UIDButton *marketingOptinButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIDButton *personalConsentButton;

@property (strong,nonatomic) URLaunchInput *urLaunchInput;

@property (strong, nonatomic) URDependencies *urDependencies;
@property (strong, nonatomic) URInterface *urInterface;
@property (strong, nonatomic) UINavigationController *presentableNavigation;
@property (weak, nonatomic) IBOutlet UISwitch *darkBGSwitch;

@end

@implementation TestAppViewController{
    BOOL isRegistrationIntialized;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [URExceptionHandler installExceptionHandlers];
    currentConfiguration = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentConfiguration"];
    if (currentConfiguration) {
        [self.changeConfiguration setTitle:[NSString stringWithFormat:@"Configuration : %@", currentConfiguration] forState:UIControlStateNormal];
    }
    self.title = @"Demo App";
    isRegistrationIntialized=NO;
    self.lblVersionNumber.text = [NSString stringWithFormat:@"Version : %@",[DIRegistrationVersion version]];
    self.urDependencies = [[URDependencies alloc] init];
    self.urDependencies.appInfra = [[AIAppInfra alloc]initWithBuilder:nil];

    self.urInterface = [[URInterface alloc]initWithDependencies:self.urDependencies andSettings:nil];
    [self cleanAppInfraConfig];

    [self.abTestingSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"ABTest"]];

    [self.urDependencies.appInfra.abtest updateCacheWithSuccess:^{

        DIRDebugLog(@"Cache Updated Status : Success!");

    } error:^(NSError * _Nullable error) {
        NSString *message=@"Error in updating cache";
        if (error) {
            message = [error localizedDescription];
        }
        DIRDebugLog(@"Cache Updated Status Error : %@",message);
    }];

    [self.serviceDiscoverySwitch setOn:NO];

    [self.urDependencies.appInfra.tagging trackPageWithInfo:@"demoapp:home" paramKey:nil andParamValue:nil];
 
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Flex" style:UIBarButtonItemStyleDone target:self action:@selector(enableFlexDebugging)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self updateUIAfterClosingRegistration:nil];
    
    [self.marketingOptinButton setTitle:@"Marketing: Split flow" forState:UIControlStateNormal];
    marketingFlow = URReceiveMarketingFlowSplitSignUp;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    BOOL isHSDPUploadSet = [[self.urDependencies.appInfra.appConfig getPropertyForKey:HSDPUUIDUpload group:@"UserRegistration" error:nil] boolValue];
    [self.hsdpUUIDSwitch setOn:isHSDPUploadSet];
    [self setPropertyForKey:PersonalConsentRequired value:[NSNumber numberWithBool:false]];
    [self.personalConsentSwitch setOn:false];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[DIUser getInstance] removeUserRegistrationListener:self] ;
}


- (void)enableFlexDebugging {
    if (NSClassFromString(@"FLEXManager") && [NSClassFromString(@"FLEXManager") instancesRespondToSelector:NSSelectorFromString(@"showExplorer")]) {
        [[NSClassFromString(@"FLEXManager") performSelector:NSSelectorFromString(@"sharedManager")] performSelector:NSSelectorFromString(@"showExplorer")];
    }
}

#pragma mark - Utility methods -

- (void)changeConfigurationMethod {
    Method originalMethod = class_getInstanceMethod([NSClassFromString(@"AIAppConfiguration") class], NSSelectorFromString(@"readAppConfigurationFromFile"));
    Method newMethod = class_getInstanceMethod([self class], @selector(loadSpecifiedConfigurationFile));
    method_exchangeImplementations(originalMethod, newMethod);
}

- (NSDictionary*)loadSpecifiedConfigurationFile {
    if (!currentConfiguration) {
        currentConfiguration=@"Standard";
        [[NSUserDefaults standardUserDefaults] setValue:currentConfiguration forKey:@"currentConfiguration"];
    }
    NSString *directoryName = @"Standard Configuration";
    if ([currentConfiguration isEqualToString:@"HSDP"]) {
        directoryName=@"HSDP Configurations";
    }else if ([currentConfiguration isEqualToString:@"Coppa"]) {
        directoryName=@"Coppa Configuration";
    }else if ([currentConfiguration isEqualToString:@"HSDP DELAY"]) {
        directoryName=@"HSDP Configurations";
    }

    NSString *configFilePath = [[NSBundle mainBundle] pathForResource:@"RegistrationConfiguration" ofType:@"json" inDirectory:directoryName];
    if(configFilePath)
    {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:configFilePath] options:NSJSONReadingMutableContainers error:nil];
        return [self uppercaseKeysForDictionary:json];
    }


    return nil;
}
-(NSDictionary*)uppercaseKeysForDictionary:(NSDictionary*)inputDict{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    for (NSString *key in [inputDict allKeys]) {
        id value = inputDict[key];
        [dictionary removeObjectForKey:key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *innerDict = [[NSMutableDictionary alloc]init];
            for (NSString *key in [value allKeys]) {
                id innerValue = value[key];
                [innerDict removeObjectForKey:key];
                [innerDict setObject:innerValue forKey:[key uppercaseString]];
            }
            value = innerDict;
        }
        [dictionary setObject:value forKey:[key uppercaseString]];

    }
    inputDict = dictionary;
    return inputDict;
}


- (void)updateUIAfterClosingRegistration:(NSError *)error {
    [self.urDependencies.appInfra.tagging trackPageWithInfo:@"demoapp:home" paramKey:nil andParamValue:nil];
    BOOL isLoggedIn = [[DIUser getInstance] userLoggedInState] > UserLoggedInStatePendingVerification;
    [self.refreshSessionButton setHidden:!isLoggedIn];
    [self.refreshHSDButton setHidden:!isLoggedIn];
    [self.refetchUserButton setHidden:!isLoggedIn];
    [self.profileUpdateButton setHidden:!isLoggedIn];
    [self.personalConsentButton setHidden:!isLoggedIn];
    if (!isLoggedIn) {
        self.refreshSessionStatus.text = @"";
    }
    if (error != nil && error.code != RegistrationCompletionErrorCodeSkippedRegistration) {
        UIDAlertController *alert = [[UIDAlertController alloc] initWithTitle:error.domain icon:nil message:error.localizedDescription];
        [alert addAction:[[UIDAction alloc] initWithTitle:@"OK" style:UIDActionStylePrimary handler:nil]];
    }
}

- (URLaunchInput*)configurRegistrationInitialisation {
    if (self.serviceDiscoverySwitch.on) {
        [ServiceDiscoveryMocked mockServiceDiscoveryMethod];
    }
    URLaunchInput *launchInput = [[URLaunchInput alloc] init];
    launchInput.delegate = self;

    [self checkAndAddPersonalConsentDetails:launchInput];
//    DIRegistrationContentConfiguration *config = launchInput.registrationContentConfiguration;
//    config.optInTitleText = @"OPtin title text";
//    config.optInBannerText = @"Optin banner text";
//    config.optInDetailDescription = @"OPtin detail description";
//    config.optInQuessionaryText = @"Optin questionary question";
    
    [self setPropertyForKey:Flow_Coppa value:[NSNumber numberWithBool:[currentConfiguration isEqualToString:@"Coppa"]]];
    [[UIDThemeManager sharedInstance] defaultTheme].applicationBackgroundImage = self.backgroundImageView.image;
    isRegistrationIntialized=YES;
    if ([currentConfiguration isEqualToString:@"HSDP"] || [currentConfiguration isEqualToString:@"HSDP DELAY"]) {
        AIAIAppState environment = [self.urDependencies.appInfra.appIdentity getAppState];
        if (environment == AIAIAppStateSTAGING || environment == AIAIAppStateACCEPTANCE) {

            [self setPropertyForKey:HSDPConfiguration_ApplicationName value:@{@"CN":@"OneBackend",@"default":@"CDP"}];
            [self setPropertyForKey:HSDPConfiguration_Shared value:@{@"CN":@"b8d483c4-318e-11e6-ac61-9e71128cae77",@"default":@"b8d483c4-318e-11e6-ac61-9e71128cae77aa"}];
            [self setPropertyForKey:HSDPConfiguration_Secret value:@{@"CN":@"448E597997F34342ACCFDA346C8B024DA399BC22000B59377AD8C7355DF3DFCEB2D3ACA5523B8397B1EFF61CC944E2526B0567A9B50B2864BCA246930DD08267asas",@"default":@"448E597997F34342ACCFDA346C8B024DA399BC22000B59377AD8C7355DF3DFCEB2D3ACA5523B8397B1EFF61CC944E2526B0567A9B50B2864BCA246930DD08267dsdsd"}];
            [self setPropertyForKey:HSDPConfiguration_BaseURL value:@{@"CN":@"https://user-registration-assembly-staging.cn1.philips-healthsuite.com.cn",@"default":@"https://user-registration-assembly-staging.eu-west.philips-healthsuite.com"}];
            if ([currentConfiguration isEqualToString:@"HSDP DELAY"]) {
                [self setPropertyForKey:HSDPConfiguration_Skip_HSDP value:@"1"];
            }else{
                [self setPropertyForKey:HSDPConfiguration_Skip_HSDP value:@"0"];
            }
        }else{
            [self setPropertyForKey:HSDPConfiguration_ApplicationName value:@"CDP"];
            [self setPropertyForKey:HSDPConfiguration_Shared value:@"b8d483c4-318e-11e6-ac61-9e71128cae77"];
            [self setPropertyForKey:HSDPConfiguration_Secret value:@"448E597997F34342ACCFDA346C8B024DA399BC22000B59377AD8C7355DF3DFCEB2D3ACA5523B8397B1EFF61CC944E2526B0567A9B50B2864BCA246930DD08267"];
            [self setPropertyForKey:HSDPConfiguration_BaseURL value:@"https://user-registration-assembly-hsdpchinadev.cn1.philips-healthsuite.com.cn"];
            if ([currentConfiguration isEqualToString:@"HSDP DELAY"]) {
                [self setPropertyForKey:HSDPConfiguration_Skip_HSDP value:@"1"];
            }else{
                [self setPropertyForKey:HSDPConfiguration_Skip_HSDP value:@"0"];
            }
        }
    }else
    {
        [self setPropertyForKey:HSDPConfiguration_ApplicationName value:nil];
        [self setPropertyForKey:HSDPConfiguration_Shared value:nil];
        [self setPropertyForKey:HSDPConfiguration_Secret value:nil];
        [self setPropertyForKey:HSDPConfiguration_BaseURL value:nil];
        [self setPropertyForKey:HSDPConfiguration_Skip_HSDP value:@"1"];
    }


    [[DIUser getInstance] removeSessionRefreshListener:self];
    [[DIUser getInstance] addSessionRefreshListener:self];
    [[DIUser getInstance] removeUserDetailsListener:self];
    [[DIUser getInstance] addUserDetailsListener:self];
    return launchInput;
}

- (void)changeBackgroundImage {
}

- (void)actionSheetWithTitle:(NSString *)title clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (isRegistrationIntialized && ![currentConfiguration isEqualToString:title]) {
        UIDAlertController *alertVC = [[UIDAlertController alloc] initWithTitle:@"Change configuration" icon:nil message:@"Configuration can only be changed at launch time. You need to relaunch the app to change it."];
        UIDAction *alertExitAction = [[UIDAction alloc] initWithTitle:@"Exit" style:UIDActionStylePrimary handler:^(UIDAction * _Nonnull action) {
            exit(0);
        }];
        UIDAction *alertCancelAction = [[UIDAction alloc] initWithTitle:@"Cancel" style:UIDActionStyleSecondary handler:nil];
        [alertVC addAction:alertExitAction];
        [alertVC addAction:alertCancelAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    } else {
        currentConfiguration = title;
        [self.changeConfiguration setTitle:[NSString stringWithFormat:@"Configuration : %@", currentConfiguration] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setValue:currentConfiguration forKey:@"currentConfiguration"];
    }
    [self cleanAppInfraConfig];
}

- (void)cleanAppInfraConfig{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"com.Philips.AppInfra.AppConfig"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.urDependencies.appInfra = [[AIAppInfra alloc]initWithBuilder:nil];
}

#pragma mark - IBAction method -

- (IBAction)initiateOverlay:(id)sender {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [NSClassFromString(@"UIDebuggingInformationOverlay") performSelector:NSSelectorFromString(@"prepareDebuggingOverlay")];
    id overlay = [NSClassFromString(@"UIDebuggingInformationOverlay") performSelector:NSSelectorFromString(@"overlay")];
    [overlay performSelector:NSSelectorFromString(@"toggleVisibility")];
#pragma clang diagnostic pop
}

- (IBAction)initiateRegistration:(id)sender {
    URLaunchInput *launchInput = [self configurRegistrationInitialisation];
    launchInput.registrationFlowConfiguration.enableLastName = YES;
//    launchInput.registrationContentConfiguration.valueForRegistrationTitle = [[NSAttributedString alloc] initWithString:@"Let's get started"];
    launchInput.registrationFlowConfiguration.enableSkipRegistration = false;
    launchInput.registrationFlowConfiguration.animateExit = self.animateExitSwitch.isOn;
    launchInput.registrationFlowConfiguration.loggedInScreen = URLoggedInScreenMyDetails;
    launchInput.registrationFlowConfiguration.receiveMarketingFlow = URReceiveMarketingFlowControl;
    if([self.abTestingSwitch isOn]) {
        launchInput.registrationFlowConfiguration.receiveMarketingFlow = URReceiveMarketingFlowSplitSignUp;
        launchInput.registrationFlowConfiguration.priorityFunction = URPriorityFunctionSignIn;
    }
    [self checkAndAddPersonalConsentDetails:launchInput];
    [self setPropertyForKey:Flow_MigrationRequired value:[NSNumber numberWithBool:YES]];
    UIViewController *viewController = [self.urInterface instantiateViewController:launchInput withErrorHandler:^(NSError * _Nullable error) {
        [self dismissNavigationController];
        if (error.code == RegistrationCompletionErrorCodeSkippedRegistration) {
            DIRDebugLog(@"Skipped registration");
        }
        [self updateUIAfterClosingRegistration:error];
    }];
    if (nil != viewController) {
        if (self.presentURSwitch.isOn) {
            self.presentableNavigation = [[UINavigationController alloc] initWithRootViewController:viewController];
            [self addCloseButtonTo:self.presentableNavigation];
            [self.navigationController presentViewController:self.presentableNavigation animated:YES completion:nil];
        } else {
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    self.urLaunchInput = launchInput;
}

-(void)checkAndAddPersonalConsentDetails:(URLaunchInput *)launchInput {
    if ([self.personalConsentSwitch isOn]) {
        launchInput.registrationContentConfiguration.personalConsent = [URConsentProvider fetchPersonalConsentDefinition];
        launchInput.registrationContentConfiguration.personalConsentErrMssge = [URConsentProvider personalConsentErrorMessage];
        launchInput.registrationFlowConfiguration.userPersonalConsentStatus = ConsentStatesInactive;
    } else {
        launchInput.registrationContentConfiguration.personalConsent = nil;
        launchInput.registrationContentConfiguration.personalConsentErrMssge = nil;
        launchInput.registrationFlowConfiguration.userPersonalConsentStatus = ConsentStatesInactive;
    }

    launchInput.registrationFlowConfiguration.showSocialIconsInDarkTheme =  self.darkBGSwitch.isOn;
}

- (IBAction)launchMarketingOptin:(UIDButton *)sender {    
    URLaunchInput *launchInput = [self configurRegistrationInitialisation];
    launchInput.registrationFlowConfiguration.enableSkipRegistration = false;
    launchInput.registrationFlowConfiguration.loggedInScreen = URLoggedInScreenMarketingOptIn;
    launchInput.registrationFlowConfiguration.animateExit = self.animateExitSwitch.isOn;
    launchInput.registrationFlowConfiguration.receiveMarketingFlow = marketingFlow;
    if([self.abTestingSwitch isOn]) {
        launchInput.registrationFlowConfiguration.receiveMarketingFlow = URReceiveMarketingFlowSplitSignUp;
        launchInput.registrationFlowConfiguration.priorityFunction = URPriorityFunctionSignIn;
    }
    [self checkAndAddPersonalConsentDetails:launchInput];
    if (self.optinImageSwitch.isOn) {
        launchInput.registrationContentConfiguration.optinImage = nil;
    } else {
        launchInput.registrationContentConfiguration.optinImage = [UIImage imageNamed:@"download" inBundle:[NSBundle bundleForClass: [self classForCoder] ]  compatibleWithTraitCollection:nil];
    }
    UIViewController *viewController = [self.urInterface instantiateViewController:launchInput withErrorHandler:^(NSError * _Nullable error) {
        [self dismissNavigationController];
        if (error.code == RegistrationCompletionErrorCodeSkippedRegistration) {
            DIRInfoLog(@"Skipped registration");
        }
        [self updateUIAfterClosingRegistration:error];
    }];
    if (nil != viewController) {
        if (self.presentURSwitch.isOn) {
            self.presentableNavigation = [[UINavigationController alloc] initWithRootViewController:viewController];
            [self addCloseButtonTo:self.presentableNavigation];
            [self.navigationController presentViewController:self.presentableNavigation animated:YES completion:nil];
        } else {
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    self.urLaunchInput = launchInput;
}


- (void)addCloseButtonTo:(UINavigationController *)navigationController {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(dismissNavigationController)];
    navigationController.navigationBar.topItem.leftBarButtonItem = item;
}


- (void)dismissNavigationController {
    if (self.presentableNavigation && self.presentURSwitch.isOn) {
        [self.presentableNavigation dismissViewControllerAnimated:self.animateExitSwitch.isOn completion:^{
            self.presentableNavigation = nil;
        }];
    }
}

- (IBAction)logoutUserAction:(id)sender {
    [self.logoutButton setIsActivityIndicatorVisible:YES];
    [self.logoutButton setProgressTitle:@"Logging out"];

    [self setPropertyForKey:PersonalConsentRequired value:[NSNumber numberWithBool:false]];
    [self.personalConsentSwitch setOn:false];
    
    [[DIUser getInstance] addUserRegistrationListener:self];
    [[DIUser getInstance] logout];
}

- (IBAction)changeTheme:(UIButton *)sender {
    UIViewController *themeSettingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ThemeSettingViewController"];
    [self.navigationController pushViewController:themeSettingViewController animated:YES];
}

- (IBAction)backgroundButtonTapped:(UIButton *)sender {
    [self changeBackgroundImage];
}

- (IBAction)refreshSessionButtonTapped:(UIButton *)sender {
    [self.refreshSessionButton setIsActivityIndicatorVisible:YES];
    self.refreshSessionStatus.text = @"";
    [[DIUser getInstance] addSessionRefreshListener:self];
    [[DIUser getInstance] refreshLoginSession];
}

- (IBAction)refreshHSDPSessionButtonTapped:(UIButton *)sender {
    [self.refreshHSDButton setIsActivityIndicatorVisible:YES];
    self.refreshSessionStatus.text = @"";
    [[DIUser getInstance] addHSDPUserDataInterfaceListener:self];
    [[DIUser getInstance] refreshHSDPSession];
}

- (IBAction)launchCustomOptInViewFlow:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Change marketing flow" message:@"" preferredStyle:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Split flow" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [sender setTitle:@"Marketing: Split flow" forState:UIControlStateNormal];
        marketingFlow = URReceiveMarketingFlowSplitSignUp;
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Custom flow" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [sender setTitle:@"Marketing: Custom flow" forState:UIControlStateNormal];
        marketingFlow = URReceiveMarketingFlowCustomOptin;
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Skip flow" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [sender setTitle:@"Marketing: Skip flow" forState:UIControlStateNormal];
        marketingFlow = URReceiveMarketingFlowSkipOptin;
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}


- (IBAction)launchSecondConsent:(UIDButton *)sender {
    [self performSegueWithIdentifier:@"launchCoppaDemo" sender:sender];
}

- (IBAction)getCoppaConsentStatus:(UIDButton *)sender {
    NSString *exceptionDetails = [URExceptionHandler lastExceptionDetails];
    if (exceptionDetails.length > 0) {
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            [controller setSubject:@"Exception found in UR"];
            [controller setMessageBody:exceptionDetails isHTML:NO];
            [controller setToRecipients:@[@"adarsh.rai@philips.com", @"rakesh.dontha@philips.com"]];
            [self presentViewController:controller animated:YES completion:nil];
        } else {
            NSString *message = [NSString stringWithFormat:@"Exception found but mail not configured to send it. \n\n %@", exceptionDetails];
            UIDAlertController *alertVC = [[UIDAlertController alloc] initWithTitle:@"Exception Found" icon:nil message:message];
            UIDAction *alertCancelAction = [[UIDAction alloc] initWithTitle:@"OK" style:UIDActionStylePrimary handler:nil];
            [alertVC addAction:alertCancelAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    } else {
        UIDAlertController *alertVC = [[UIDAlertController alloc] initWithTitle:@"No Exception Found" icon:nil message:@"We could not find any logged exception."];
        UIDAction *alertCancelAction = [[UIDAction alloc] initWithTitle:@"OK" style:UIDActionStylePrimary handler:nil];
        [alertVC addAction:alertCancelAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

- (IBAction)changeConfigurationFile:(UIDButton *)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Change configuration file" message:@"" preferredStyle:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Standard" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self actionSheetWithTitle:@"Standard" clickedButtonAtIndex:0];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"HSDP" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self actionSheetWithTitle:@"HSDP" clickedButtonAtIndex:1];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"HSDP DELAY" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self actionSheetWithTitle:@"HSDP DELAY" clickedButtonAtIndex:3];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Coppa" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self actionSheetWithTitle:@"Coppa" clickedButtonAtIndex:2];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)fetchPersonalConsent:(UIDButton *)sender {
    URPersonalConsentHandler *consentHandler = [DIUser getInstance].personalConsentHandler;
    [consentHandler fetchConsentTypeStateFor:@"USR_PERSONAL_CONSENT" completion: ^(ConsentStatus *status, NSError *error) {
        if (error != nil) {
            self.refreshSessionStatus.text = [NSString stringWithFormat:@"Consent Error:%@",error.localizedDescription];
        }
        if (status != nil) {
            NSDictionary *states = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Active",@"Reject",@"Inactive",nil] forKeys:[NSArray arrayWithObjects:@"0",@"2",@"1",nil]];
            NSString *userState = [states objectForKey:[NSString stringWithFormat:@"%ld",status.status]];
            self.refreshSessionStatus.text = [NSString stringWithFormat:@"Consent Status:%@",userState];
        }
    }];
}


- (IBAction)refetchUserButtonAction:(UIButton *)sender {
    //    [self.refetchUserButton setActivityIndicatorVisible:YES];
    dispatch_queue_t queue1 = dispatch_queue_create("queue1", NULL);
    dispatch_async(queue1, ^{
        [[DIUser getInstance] refetchUserProfile];
        [[DIUser getInstance] refreshLoginSession];

    });
    
    dispatch_queue_t queue2 = dispatch_queue_create("queue2", NULL);
    dispatch_async(queue2, ^{
        [[DIUser getInstance] refetchUserProfile];
        [[DIUser getInstance] refreshLoginSession];
        
    });
    
    dispatch_queue_t queue3 = dispatch_queue_create("queue3", NULL);
    dispatch_async(queue3, ^{
        [[DIUser getInstance] refetchUserProfile];
        [[DIUser getInstance] refreshLoginSession];
        
    });

    
    dispatch_queue_t queue4 = dispatch_queue_create("queue4", NULL);
    dispatch_async(queue4, ^{
        [[DIUser getInstance] refetchUserProfile];
        [[DIUser getInstance] refreshLoginSession];
        
    });
}

- (IBAction)launchProfileUpdatePage:(id)sender {
    DemoGenderDOBViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DemoGenderDOBViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)updatedServiceDiscovery:(UISwitch *)sender {
    if (isRegistrationIntialized) {
        UIDAlertController *alertVC = [[UIDAlertController alloc] initWithTitle:@"DEMO" icon:nil message:@"Please restart to change the mocking"];
        UIDAction *alertCancelAction = [[UIDAction alloc] initWithTitle:@"OK" style:UIDActionStylePrimary handler:nil];
        [alertVC addAction:alertCancelAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

- (IBAction)setABTesting:(UISwitch*)sender {
}

- (IBAction)setHsdpUUIDSwitch:(UISwitch*)hsdpUUIDSwitch {
    BOOL isHSDPSwitchOn = [hsdpUUIDSwitch isOn];
    [self setPropertyForKey:HSDPUUIDUpload value:[NSNumber numberWithBool:isHSDPSwitchOn]];
}

- (IBAction)personalConsentSwitchValueChanged:(UISwitch*)personalConsentSwich {
    BOOL isPersonalConsentSwitchOn = [personalConsentSwich isOn];
    [self setPropertyForKey:PersonalConsentRequired value:[NSNumber numberWithBool:isPersonalConsentSwitchOn]];
    [self checkAndAddPersonalConsentDetails:self.urLaunchInput];
}




- (IBAction)checkLoginState:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select from below Options" message:@"" preferredStyle:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Login to HSDP" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[DIUser getInstance] authorizeWithHSDPWithCompletion:^(BOOL success, NSError *error) {
            if (error) {
                UIDAlertController *alertVC = [[UIDAlertController alloc] initWithTitle:@"HSDP Status" icon:nil message:[NSString stringWithFormat:@"%@",error.description]];
                UIDAction *alertCancelAction = [[UIDAction alloc] initWithTitle:@"OK" style:UIDActionStylePrimary handler:nil];
                [alertVC addAction:alertCancelAction];
                [self presentViewController:alertVC animated:YES completion:nil];
                return;
            }
            UIDAlertController *alertVC = [[UIDAlertController alloc] initWithTitle:@"HSDP Status" icon:nil message:@"HSDP Login Successful"];
            UIDAction *alertCancelAction = [[UIDAction alloc] initWithTitle:@"OK" style:UIDActionStylePrimary handler:nil];
            [alertVC addAction:alertCancelAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Check Login State" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UserLoggedInState state = [[DIUser getInstance] userLoggedInState];
        UIDAlertController *alertVC = [[UIDAlertController alloc] initWithTitle:@"Login State" icon:nil message:[NSString stringWithFormat:@"Present State is %@",[self stateToString:state]]];
        UIDAction *alertCancelAction = [[UIDAction alloc] initWithTitle:@"OK" style:UIDActionStylePrimary handler:nil];
        [alertVC addAction:alertCancelAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil]];

    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (NSString*)stateToString:(UserLoggedInState) state {
    NSString *result = nil;
    
    switch(state) {
        case UserLoggedInStateUserNotLoggedIn:
            result = @"UserLoggedInStateUserNotLoggedIn";
            break;
        case UserLoggedInStatePendingVerification:
            result = @"UserLoggedInStatePendingVerification";
            break;
        case UserLoggedInStatePendingTnC:
            result = @"UserLoggedInStatePendingTnC";
            break;
        case UserLoggedInStatePendingHSDPLogin:
            result = @"UserLoggedInStatePendingHSDPLogin";
            break;
        case UserLoggedInStateUserLoggedIn:
            result = @"UserLoggedInStateUserLoggedIn";
            break;
        default:
            result = @"unknown";
    }
    
    return result;
}

#pragma mark - MFMailComposeViewControllerDelegate -

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DIRegistrationConfigurationDelegate -

- (void)launchTermsAndConditions {
    UIDAlertController *alertVC = [[UIDAlertController alloc] initWithTitle:@"DEMO" icon:nil message:@"Show Terms and Conditions"];
    UIDAction *alertCancelAction = [[UIDAction alloc] initWithTitle:@"OK" style:UIDActionStylePrimary handler:nil];
    [alertVC addAction:alertCancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)launchPrivacyPolicy {
    UIDAlertController *alertVC = [[UIDAlertController alloc] initWithTitle:@"Show Privacy Policy" icon:nil message:@"show terms and conditions"];
    UIDAction *alertCancelAction = [[UIDAction alloc] initWithTitle:@"OK" style:UIDActionStylePrimary handler:nil];
    [alertVC addAction:alertCancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)launchPersonalConsentDescription {
    UIDAlertController *alertVC = [[UIDAlertController alloc] initWithTitle:@"Show Personal Consent" icon:nil message:@"App must show personal consent description"];
    UIDAction *alertCancelAction = [[UIDAction alloc] initWithTitle:@"OK" style:UIDActionStylePrimary handler:nil];
    [alertVC addAction:alertCancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}


#pragma mark - HSDP Session refresh delegate -


-(void)refreshHSDPSessionSucceed {
    [self.refreshHSDButton setIsActivityIndicatorVisible:NO];
    [[DIUser getInstance] removeHSDPUserDataInterfaceListener:self];
    self.refreshSessionStatus.text = @"Refresh HSDP Success";

}

-(void)refreshHSDPSessionFailed:(NSError *) error {
    [self.refreshHSDButton setIsActivityIndicatorVisible:NO];
    [[DIUser getInstance] removeHSDPUserDataInterfaceListener:self];
    self.refreshSessionStatus.text = [NSString stringWithFormat:@"Refresh HSDP Failed due to %@",error.localizedDescription];
}

-(void)hsdpUserSessionInvalid:(NSError *) error {
    BOOL isLoggedIn = [[DIUser getInstance] userLoggedInState] > UserLoggedInStatePendingTnC;
    [self.refreshSessionButton setHidden:!isLoggedIn];
    [self.refreshSessionButton setIsActivityIndicatorVisible:NO];
    [self.refreshHSDButton setHidden:isLoggedIn];
    [self.refreshHSDButton setIsActivityIndicatorVisible:NO];   
    [[DIUser getInstance] removeSessionRefreshListener:self];
    self.refreshSessionStatus.text = @"Logged out Due to invalid refresh token";
}



#pragma mark - SessionRefreshDelegate -

- (void)loginSessionRefreshSucceed {
    [self.refreshSessionButton setIsActivityIndicatorVisible:NO];
    [[DIUser getInstance] removeSessionRefreshListener:self];
    self.refreshSessionStatus.text = @"Refresh Success";
}

- (void)loginSessionRefreshFailedAndLoggedout{
    BOOL isLoggedIn = [[DIUser getInstance] userLoggedInState] > UserLoggedInStatePendingTnC;
    [self.refreshSessionButton setHidden:!isLoggedIn];
    [self.refreshSessionButton setIsActivityIndicatorVisible:NO];
    [[DIUser getInstance] removeSessionRefreshListener:self];
    self.refreshSessionStatus.text = @"Logged out Due to invalid refresh token";
}

- (void)loginSessionRefreshFailedWithError:(NSError *)error{
    [self.refreshSessionButton setIsActivityIndicatorVisible:NO];
    [[DIUser getInstance] removeSessionRefreshListener:self];
    self.refreshSessionStatus.text = [NSString stringWithFormat:@"Refresh Failed due to %@",error.localizedDescription];
}

- (void)didUserInfoFetchingFailedWithError:(NSError *)error{
    //    [self.refetchUserButton setIsActivityIndicatorVisible:NO];
    self.refreshSessionStatus.text = [NSString stringWithFormat:@"Refetch Failed due to %@",error.localizedDescription];
}

- (void)didUserInfoFetchingSuccessWithUser:(DIUser *)profile{
    //    [self.refetchUserButton setActivityIndicatorVisible:NO];
    self.refreshSessionStatus.text = @"Refetch User Success";
}

- (void)setPropertyForKey:(NSString *)key value:(id)value
{
    NSError *error = nil;
    [self.urDependencies.appInfra.appConfig setPropertyForKey:key group:@"UserRegistration"  value:value error:&error];
}

#pragma mark - UserRegistrationDelegate -

- (void)logoutDidSucceed {
    UIDAlertController *alert = [[UIDAlertController alloc] initWithTitle:@"Logout Success" icon:nil message:@"You are logged out successfully"];
    [alert addAction:[[UIDAction alloc] initWithTitle:@"OK" style:UIDActionStylePrimary handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    [self.logoutButton setIsActivityIndicatorVisible:NO];
    self.urLaunchInput = nil;
}

- (void)logoutFailedWithError:(NSError *)error {
    UIDAlertController *alert = [[UIDAlertController alloc] initWithTitle:@"Logout Failed" icon:nil message:error.localizedDescription];
    [alert addAction:[[UIDAction alloc] initWithTitle:@"OK" style:UIDActionStylePrimary handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    [self.logoutButton setIsActivityIndicatorVisible:NO];
}

@end

