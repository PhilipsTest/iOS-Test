//
//  UIDTextField+ContentValidation.h
//  Registration
//
//  Created by Adarsh Kumar Rai on 30/06/17.
//  Copyright © 2017 Philips. All rights reserved.
//

@import PhilipsUIKitDLS;

@interface UIDTextField (ContentValidation)

- (BOOL)validateEmailContentAndDisplayError:(BOOL)force;
- (BOOL)validateNameContent:(NSString *)nameContent displayError:(BOOL)force;
- (BOOL)validatePhoneNumberContentAndDisplayError:(BOOL)force;
- (BOOL)validateEmailOrMobileNumberContentAndDisplayError:(BOOL)force;
- (BOOL)validatePasswordContentAndDisplayError;
- (BOOL)validateSignInPasswordAndDisplayError:(BOOL)force;
- (BOOL)validateAccountVerificationCodeAndDisplayError;
- (void)checkAndUpdateTextFieldToRTL;

@end
