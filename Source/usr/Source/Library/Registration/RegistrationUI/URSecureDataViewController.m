//
//  URSecureDataViewController.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import "URSecureDataViewController.h"
#import "URAlmostDoneViewController.h"

@interface URSecureDataViewController ()

@property (weak, nonatomic) IBOutlet UIDTextField       *recoveryEmailTextField;
@property (weak, nonatomic) IBOutlet UIDProgressButton  *addRecoveryEmailButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackViewWidthConstraint;

@end

@implementation URSecureDataViewController

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = LOCALIZE(@"USR_DLS_URCreateAccount_NavTitle");
    [_recoveryEmailTextField checkAndUpdateTextFieldToRTL];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    DIRInfoLog(@"Screen name is %@", kRegistrationSecureData);
    [DIRegistrationAppTagging trackPageWithInfo:kRegistrationSecureData paramKey:nil andParamValue:nil];
}


-(void)viewWillLayoutSubviews {
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
        self.stackViewWidthConstraint.constant = -([UIApplication sharedApplication].keyWindow.bounds.size.width - 648);
    } else {
        self.stackViewWidthConstraint.constant = -32;
    }
}

#pragma mark - IBActions

- (IBAction)validateTextField:(UIDTextField *)sender {
    [super validateTextField:sender];
    [self.addRecoveryEmailButton setEnabled:[self.recoveryEmailTextField validateEmailContentAndDisplayError:NO]];
}


- (IBAction)addRecoveryEmail:(UIDProgressButton *)sender {
    DIRInfoLog(@"%@.addRecoveryEmail clicked", kRegistrationSecureData);
    [self.recoveryEmailTextField resignFirstResponder];
    [self.addRecoveryEmailButton setEnabled:NO];
    [sender setIsActivityIndicatorVisible:YES];
    sender.progressTitle = LOCALIZE(@"USR_DLS_AddRecovery_AddRecovery_Button_Title");
    [self startActivityIndicator];
    [DIRegistrationAppTagging trackActionWithInfo:kRegSendData paramKey:kRegSpecialEvents andParamValue:kRegSecureDataWithEmail];
    [self.userRegistrationHandler addRecoveryEmailToMobileNumberAccount:self.recoveryEmailTextField.text];
}


- (IBAction)maybeLater:(id)sender {
    DIRInfoLog(@"%@.maybeLater clicked", kRegistrationSecureData);
    [DIRegistrationAppTagging trackActionWithInfo:kRegSendData paramKey:kRegSpecialEvents andParamValue:kRegSkipSecureData];
    //Removed the extra check code to take out almost done screen for china login.
    [self popOutOfRegistrationViewControllersWithError:nil];
}

#pragma mark - UITextFieldDelegate Methods
#pragma mark -

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
    [self.recoveryEmailTextField validateEmailContentAndDisplayError:YES];
}

#pragma mark - UserDetailsDelegate

- (void)didUpdateSuccess {
    [super didUpdateSuccess];
    [self.addRecoveryEmailButton setIsActivityIndicatorVisible:NO];
    [self.addRecoveryEmailButton setEnabled:YES];
    [DIRegistrationAppTagging trackActionWithInfo:kRegSendData paramKey:kRegSpecialEvents andParamValue:kRegSuccessRecoveryEmail];
    [self performSegueWithIdentifier:kVerifyRecoveryEmailSegue sender:nil];
}


- (void)didUpdateFailedWithError:(NSError *)error {
    [super didUpdateFailedWithError:error];
    [self.addRecoveryEmailButton setIsActivityIndicatorVisible:NO];
    [self.addRecoveryEmailButton setEnabled:YES];
    [self showNotificationBarErrorViewWithTitle:error.localizedDescription];
    [DIRegistrationAppTagging trackActionWithInfo:kRegSendData paramKey:kRegUserError andParamValue:kRegFailedRecoveryEmail];
}


#pragma mark - Connection Status

- (void)updateConnectionStatus:(BOOL) connectionAvailable {
    [super updateConnectionStatus:connectionAvailable];
    [self.addRecoveryEmailButton setEnabled:([self.recoveryEmailTextField validateEmailContentAndDisplayError:NO] && connectionAvailable)];
}

@end
