//
//  URResendBaseViewController.m
//  Registration
//
//  Created by Abhishek Chatterjee on 16/08/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URResendBaseViewController.h"

NSUInteger const ResendTimeLimit = 60;

@implementation URResendBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.resendSuccessNotificationBarView.notificationBarType = UIDNotificationBarTypeTextOnly;
    self.resendSuccessNotificationBarView.delegate = self;
    self.resendSuccessNotificationBarView.backgroundColor = [[[UIDThemeManager sharedInstance] defaultTheme] contentTertiaryBackground];
    self.progressBarLabel.textColor = [[[UIDThemeManager sharedInstance] defaultTheme] hyperlinkDefaultText];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.resendButton.enabled = NO;
    [self enableTimer];
}


#pragma mark - Public methods
#pragma mark -

- (void)enableTimer {
    self.timerSeconds = ResendTimeLimit - [[NSDate date] timeIntervalSinceDate:self.resendEmailOrSMSDate];
    if (self.timerSeconds > 0 && self.timerSeconds <= ResendTimeLimit && self.resendEmailOrSMSDate != nil) {
        [self.resendTimeTracker invalidate];
        self.resendTimeTracker = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownTimer) userInfo:nil repeats:YES];
    } else {
        self.resendButton.enabled = self.connectionAvailable;
    }
}


- (void)countDownTimer {
    self.timerSeconds -= 1;
    if (self.timerSeconds <= 0) {
        [self.resendTimeTracker invalidate];
    }
}


#pragma mark - Reachability Status
#pragma mark -

- (void)toggleResendButton:(BOOL)connectionAvailable isValidTextfield:(BOOL)isValidEmailOrPhoneNumber {
    [self.resendButton setEnabled:isValidEmailOrPhoneNumber && (![self.resendTimeTracker isValid]) && connectionAvailable];
}


#pragma mark - UIDNotificationBarViewDelegate
#pragma mark -

- (void)notificationBar:(UIDNotificationBarView * _Nonnull)notificationBar forTapped:(enum UIDActionButtonType)buttonType {
    [super notificationBar:notificationBar forTapped:buttonType];
    [self.resendSuccessNotificationBarView setHidden:YES];
}

@end
