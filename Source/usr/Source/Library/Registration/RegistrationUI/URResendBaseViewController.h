//
//  URResendBaseViewController.h
//  Registration
//
//  Created by Abhishek Chatterjee on 16/08/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "RegistrationBaseViewController.h"

@protocol TimerTrackingDelegate <NSObject>
- (void)restartTimer:(NSDate *)date;
@end

@interface URResendBaseViewController : RegistrationBaseViewController <UIDNotificationBarViewDelegate>

@property(nonatomic, weak) IBOutlet UIDProgressButton       *resendButton;
@property(nonatomic, weak) IBOutlet UIDButton               *thanksButton;
@property(nonatomic, weak) IBOutlet UIDTextField            *emailOrSmsTextField;
@property(nonatomic, weak) IBOutlet UIDNotificationBarView  *resendSuccessNotificationBarView;
@property(nonatomic, weak) IBOutlet UIDLabel                *progressBarLabel;
@property(nonatomic, weak) IBOutlet UIDProgressIndicator    *timeProgressBar;

@property(nonatomic, strong) NSDate     *resendEmailOrSMSDate;
@property(nonatomic, strong) NSTimer    *resendTimeTracker;
@property(nonatomic, strong) NSString   *editMobileNumber;
@property(nonatomic, assign) NSUInteger timerSeconds;

@property(nonatomic, weak) id<TimerTrackingDelegate>  timerTrackingDelegate;

- (void)enableTimer;
- (void)countDownTimer;
- (void)toggleResendButton:(BOOL)connectionAvailable isValidTextfield:(BOOL)isValidEmailOrPhoneNumber;

@end
