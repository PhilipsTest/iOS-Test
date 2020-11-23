//
//  NSString+Validation.h
//  Registration
//
//  Created by Adarsh Kumar Rai on 10/06/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validation)

- (BOOL)isValidEmail;
- (BOOL)isValidMobileNumber;
- (BOOL)isValidPassword;
- (BOOL)isValidSignInPassword;
- (BOOL)isValidAccountVerificationCode;
- (BOOL)hasCorrectLengthForPassword;
- (BOOL)containsAlphabets;
- (BOOL)containsAllowedSpecialCharacters;
- (BOOL)containsNumbers;
- (BOOL)isValidName;

- (NSString *)validatedMobileNumber;

@end
