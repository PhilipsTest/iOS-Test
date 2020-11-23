//
//  UIDTextField+ContentValidation.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 30/06/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "UIDTextField+ContentValidation.h"
#import "RegistrationUIConstants.h"
#import "RegistrationAnalyticsConstants.h"
#import "URSettingsWrapper.h"
#import "NSString+Validation.h"


@implementation UIDTextField (ContentValidation)

- (BOOL)validateEmailContentAndDisplayError:(BOOL)force {
    if (![self isTextFieldContentValid:force localizedErrorMessage:LOCALIZE(@"USR_InvalidOrMissingEmail_ErrorMsg")]) {
        return NO;
    }
    NSString *text = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    BOOL validEmail = [text isValidEmail];
    if (validEmail) {
        [self setValidationView:NO animated:YES];
    } else if (force || self.isValidationVisible) {
        [self setValidationMessage:LOCALIZE(@"USR_InvalidOrMissingEmail_ErrorMsg")];
        [self setValidationView:YES animated:YES];
    }
    return validEmail;
}


- (BOOL)validateNameContent:(NSString *)nameContent displayError:(BOOL)force {
    
    if ([self checkIfEmpty]) {
        if (force || self.isValidationVisible) {
                NSString *message = [self getEmptyMessageForName:nameContent];
                [self setValidationMessage:message];
                [self setValidationView:YES animated:YES];
            }
        return NO;
    } else if ([self isContentOverMaxLength:80]) {
        return NO;
    }
    NSString *text = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    BOOL validName = [text isValidName];
       if (validName == false) {
           NSString *message = [self getInvalidMessageForName:nameContent];
           [self setValidationMessage:message];
           [self setValidationView:YES animated:YES];
           return NO;
       }
    [self setValidationView:NO animated:YES];
    return validName;
}

-(NSString *)getEmptyMessageForName:(NSString *)name {
    return ([name isEqualToString:@"firstName"]) ? LOCALIZE(@"USR_NameField_ErrorText") : LOCALIZE(@"USR_LastNameField_ErrorMsg");
}
-(NSString *)getInvalidMessageForName:(NSString *)name {
    return LOCALIZE(@"USR_InvalidOrMissingName_ErrorMsg");
}


- (BOOL)validatePhoneNumberContentAndDisplayError:(BOOL)force {
    if (![self isTextFieldContentValid:force localizedErrorMessage:LOCALIZE(@"USR_EmptyField_ErrorMsg")]) {
        return NO;
    }
    NSString *text = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    BOOL validMobile =[text isValidMobileNumber];
    if (validMobile) {
        [self setValidationView:NO animated:YES];
    } else if (force || self.isValidationVisible) {
        [self setValidationMessage:LOCALIZE(@"USR_InvalidPhoneNumber_ErrorMsg")];
        [self setValidationView:YES animated:YES];
    }
    return validMobile;
}


- (BOOL)validateEmailOrMobileNumberContentAndDisplayError:(BOOL)force {
    if (![self isTextFieldContentValid:force localizedErrorMessage:LOCALIZE(@"USR_InvalidEmailOrPhoneNumber_ErrorMsg")]) {
        return NO;
    }
    NSString *text = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    BOOL validEmailOrMobile = [text isValidEmail] || [text isValidMobileNumber];
    if (validEmailOrMobile) {
        [self setValidationView:NO animated:YES];
    } else if (force || self.isValidationVisible) {
        [self setValidationMessage:LOCALIZE(@"USR_InvalidEmailOrPhoneNumber_ErrorMsg")];
        [self setValidationView:YES animated:YES];
    }
    return validEmailOrMobile;
}


- (BOOL)validatePasswordContentAndDisplayError {
    if (![self isTextFieldContentValid:YES localizedErrorMessage:LOCALIZE(@"USR_PasswordField_ErrorMsg")]) {
        return NO;
    }
    BOOL validPassword = [self.text isValidPassword];
    if (validPassword) {
        [self setValidationView:NO animated:YES];
    }else {
        [self setValidationMessage:LOCALIZE(@"USR_InValid_PwdErrorMsg")];
        [self setValidationView:YES animated:YES];
    }
    return validPassword;
}


- (BOOL)validateSignInPasswordAndDisplayError:(BOOL)force {
    if (![self isTextFieldContentValid:force localizedErrorMessage:LOCALIZE(@"USR_PasswordField_ErrorMsg")]) {
        return NO;
    }
    BOOL validSignInPassword = [self.text isValidSignInPassword];
    if (validSignInPassword) {
        [self setValidationView:NO animated:YES];
    } else if (force || self.isValidationVisible) {
        [self setValidationMessage:LOCALIZE(@"USR_InValid_PwdErrorMsg")];
        [self setValidationView:YES animated:YES];
    }
    return validSignInPassword;
}

- (BOOL)validateAccountVerificationCodeAndDisplayError {
    if (![self isTextFieldContentValid:YES localizedErrorMessage:LOCALIZE(@"USR_EmptyField_ErrorMsg")]) {
        return NO;
    }
    BOOL validActivationCode = [self.text isValidAccountVerificationCode];
    if (validActivationCode) {
        [self setValidationView:NO animated:YES];
    }else {
        [self setValidationMessage:LOCALIZE(@"USR_VerificationCode_ErrorText")];
        [self setValidationView:YES animated:YES];
    }
    return validActivationCode;
}

#pragma mark - Vaild Text Checks
#pragma mark -

- (BOOL)checkIfEmpty {
    return self.text.length == 0;
}



- (BOOL)isContentOverMaxLength:(int)length {
    BOOL isOverMaxLength = (self.text.length >= length);
    return isOverMaxLength;
}


- (BOOL)isTextFieldContentValid:(BOOL)forceError localizedErrorMessage:(NSString *)message {
    NSString *errorMessage;
    if ([self checkIfEmpty] || [self isContentOverMaxLength:128]) {
        errorMessage = [self checkIfEmpty] ? message : LOCALIZE(@"USR_MaxiumCharacters_ErrorMsg");
    }
    if (errorMessage) {
        if (forceError || self.isValidationVisible) {
            [self setValidationMessage:errorMessage];
            [self setValidationView:YES animated:YES];
        }
        return NO;
    }
    return YES;
}

- (void)checkAndUpdateTextFieldToRTL {
    if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight) {
        return;
    }
    self.superview.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    self.textAlignment = NSTextAlignmentRight;
}

@end
