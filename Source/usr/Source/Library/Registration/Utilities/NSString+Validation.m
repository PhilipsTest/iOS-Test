//
//  NSString+Validation.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 10/06/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "NSString+Validation.h"
#import "NBPhoneNumberUtil.h"
#import "URSettingsWrapper.h"

@implementation NSString (Validation)

#pragma mark - Email Validation
#pragma mark -

- (BOOL)isValidEmail {
   NSString *pattern = @"^[A-Za-z0-9!#$%&'*+\\/=?^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%&'*+\\/=?^_`{|}~-]+)*@(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [predicate evaluateWithObject:[self lowercaseString]];
}

#pragma mark - Mobile Number Validation
#pragma mark -

- (BOOL)isValidMobileNumber {
    NBPhoneNumberUtil *phoneUtil = [[NBPhoneNumberUtil alloc] init];
    NSError *anError = nil;
    NBPhoneNumber *myNumber = [phoneUtil parse:self defaultRegion:[URSettingsWrapper sharedInstance].countryCode error:&anError];
    if (!anError) {
        return [phoneUtil isValidNumber:myNumber];
    } else {
        return NO;
    }
}


- (NSString *)validatedMobileNumber {
    if (![self isValidMobileNumber]) {
        return nil;
    }
    NBPhoneNumberUtil *phoneUtil = [[NBPhoneNumberUtil alloc] init];
    NSError *anError = nil;
    NBPhoneNumber *myNumber = [phoneUtil parse:self defaultRegion:[URSettingsWrapper sharedInstance].countryCode error:&anError];
    NSString *phoneNumber = [phoneUtil format:myNumber numberFormat:NBEPhoneNumberFormatE164 error:&anError];
    phoneNumber = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"+"]];
    return phoneNumber;
}

#pragma mark - Password Validation
#pragma mark -

- (BOOL)isValidPassword {
    NSUInteger passwordStrength = 0;
    if ([self hasCorrectLengthForPassword]) {
        passwordStrength += 2;
    }
    passwordStrength += ([self containsAlphabets] + [self containsNumbers] + [self containsAllowedSpecialCharacters]);
    return passwordStrength >= 4;
}

- (BOOL)isValidSignInPassword {
    return self.length >= 1;
}


- (BOOL)hasCorrectLengthForPassword {
    BOOL correctLength = (self.length >= 8 && self.length <= 32 );
    return correctLength;
}


- (BOOL)containsAlphabets {
    NSCharacterSet *alfa = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    return ([self rangeOfCharacterFromSet:alfa].length > 0);
}


- (BOOL)containsAllowedSpecialCharacters {
    NSCharacterSet *allowedSpecialCharacters = [NSCharacterSet characterSetWithCharactersInString:@"_.@$"];
    return [self rangeOfCharacterFromSet:allowedSpecialCharacters].length > 0;
}


- (BOOL)containsNumbers {
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    return ([self rangeOfCharacterFromSet:numbers].length > 0);
}

#pragma mark - OTP Validation
#pragma mark -

- (BOOL)isValidAccountVerificationCode {
    NSString *pattern = @"^([0-9]{6})$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    return [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])]>0;
}

-(BOOL)isValidName {
    NSString *pattern = @"^(?!.*(?i)(\\p{C}|<|>|\\.com|\\.co\\.|\\.do|\\.ru|\\.it|\\.de|\\.at|\\.ch|\\.nl|\\.be|\\.fr|\\.org|\\.to|\\.do|:\\/\\/|www\\.)(?-i)).*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [predicate evaluateWithObject:self];
}


@end
