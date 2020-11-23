//
//  RegistrationBaseViewController.h
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <UIKit/UIKit.h>
#import "DIUser+Authentication.h"
#import "DIUser+DataInterface.h"
#import "RegistrationUIConstants.h"
#import "UIDTextField+ContentValidation.h"
#import "UIViewController+URAdditions.h"
#import "NSString+Validation.h"
#import "RegistrationUtility.h"
#import "RegistrationUIConstants.h"
#import "URSettingsWrapper.h"
#import "RegistrationAnalyticsConstants.h"
#import "DILogger.h"
@import PhilipsUIKitDLS;


@interface RegistrationBaseViewController : UIViewController<UITextFieldDelegate, UserDetailsDelegate, UserRegistrationDelegate, SessionRefreshDelegate, JanrainFlowDownloadDelegate,UIDNotificationBarViewDelegate,UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView            *backgroundImage;
@property (nonatomic, weak) IBOutlet UIScrollView           *scrollView;
@property (nonatomic, weak) IBOutlet UIDLabel               *explanatoryTextLabel;   //Why this label in base controller when used in only one controller
@property (nonatomic, weak) IBOutlet UIDProgressIndicator   *activityIndicatorView;

@property (nonatomic, strong) UIDNotificationBarView        *notificationBarView;
@property (nonatomic, strong) DIUser                        *userRegistrationHandler;
@property (nonatomic, strong) NSString                      *providerName;
@property (nonatomic, assign) BOOL                          connectionAvailable;
@property (nonatomic, assign) RegistrationLoginFlowType     loginFlowType;
@property (nonatomic, assign) EnterCodeFlowType             enterCodeFlowType;

- (void)popOutOfRegistrationViewControllersWithError:(NSError *)error;
- (void)showHiddenView;
- (void)hideHiddenView;
- (void)startActivityIndicator;
- (void)stopActivityIndicator;
- (void)registrationSignout;
- (void)startReachablity;
- (void)removeTextFieldErrors;
- (void)trackingABTesting;
- (void)validateTextField:(UITextField *)textField;
- (void)updateConnectionStatus:(BOOL)connectionAvailable;
- (void)textFieldPressedGo:(UITextField *)textField;
- (void)showNotificationBarErrorViewWithTitle:(NSString *)errorMessage;
- (void)hideNotificationBarErrorView;
- (UIDAlertController *)forgotPasswordSuccessAlert;
- (NSMutableArray *)viewControllersOfUserRegistration;
-(BOOL)isPersonalConsentViewToBeShown;
-(void)storePersonalConsent:(BOOL)consentStatus;
@end
