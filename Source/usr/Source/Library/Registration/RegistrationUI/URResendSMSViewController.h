//
//  URResendSMSViewController.h
//  Registration
//
//  Created by Sai Pasumarthy on 03/06/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URResendBaseViewController.h"

/**
 *  ResetTokenDelegate will send the Reset token from Resend SMS screen to Verification Screen.
 */

@protocol ResetTokenDelegate <NSObject>
- (void)resetTokenForMobileResetPassword:(NSString *)resetToken andUpdatedMobile:(NSString *)mobileNumber;
@end

@interface URResendSMSViewController : URResendBaseViewController
@property(nonatomic, weak) id<ResetTokenDelegate> delegate;
@end
