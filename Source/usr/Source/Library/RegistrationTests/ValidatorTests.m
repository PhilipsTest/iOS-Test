//
//  ValidatorTests.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
@import PhilipsUIKitDLS;
#import "NSString+Validation.h"
#import "UIDTextField+ContentValidation.h"
#import "URSettingsWrapper.h"


@interface ValidatorTests : XCTestCase
@property (nonatomic, strong) UIDTextField *textfield;

@end

@implementation ValidatorTests

- (void)setUp {
    [super setUp];
    self.textfield = [UIDTextField new];
}

- (void)tearDown {
    [super tearDown];
    self.textfield = nil;
}

#pragma mark - Email

- (void)testValidateEmail {
    
    XCTAssertTrue([@"email@example.com" isValidEmail]);
    XCTAssertTrue([@"firstname.lastname@example.com" isValidEmail]);
    XCTAssertTrue([@"email@subdomain.example.com" isValidEmail]);
    XCTAssertTrue([@"firstname+lastname@example.com" isValidEmail]);
    XCTAssertTrue([@"email@123.123.123.123" isValidEmail]);
    XCTAssertTrue([@"1234567890@example.com" isValidEmail]);
    XCTAssertTrue([@"email@example-one.com" isValidEmail]);
    XCTAssertTrue([@"_______@example.com" isValidEmail]);
    XCTAssertTrue([@"email@example.name" isValidEmail]);
    XCTAssertTrue([@"email@example.museum" isValidEmail]);
    XCTAssertTrue([@"firstname-lastname@example.com" isValidEmail]);
    XCTAssertTrue([@"email@example.co.jp" isValidEmail]);
    XCTAssertTrue([@"email@111.222.333.44444" isValidEmail]);
    XCTAssertTrue([@"Galileo123456789@mailinator.com" isValidEmail]);
    XCTAssertTrue([@"Data@mailinator.com" isValidEmail]);
    XCTAssertTrue([@"DataValidation@mailinator.com" isValidEmail]);
    XCTAssertTrue([@"Data_Validation@mailinator.com" isValidEmail]);
    XCTAssertTrue([@"Data1Validation@mailinator.com" isValidEmail]);
    XCTAssertTrue([@"Data_1_Validation@mailinator.com" isValidEmail]);
    
    XCTAssertFalse([@"plainaddress" isValidEmail]);
    XCTAssertFalse([@"#@%^%#$@#$@#.com" isValidEmail]);
    XCTAssertFalse([@"@example.com" isValidEmail]);
    XCTAssertFalse([@"Joe Smith <email@example.com>" isValidEmail]);
    XCTAssertFalse([@"email.example.com" isValidEmail]);
    XCTAssertFalse([@"email@example@example.com" isValidEmail]);
    XCTAssertFalse([@".email@example.com" isValidEmail]);
    XCTAssertFalse([@"email.@example.com" isValidEmail]);
    XCTAssertFalse([@"email..email@example.com" isValidEmail]);
    XCTAssertFalse([@"あいうえお@example.com" isValidEmail]);
    XCTAssertFalse([@"email@example.com (Joe Smith)" isValidEmail]);
    XCTAssertFalse([@"email@example" isValidEmail]);
    XCTAssertFalse([@"email@-example.com" isValidEmail]);
    XCTAssertFalse([@"email@example..com" isValidEmail]);
    XCTAssertFalse([@"Abc..123@example.com" isValidEmail]);
    XCTAssertFalse([@"“(),:;<>[\\]@example.com" isValidEmail]);
    XCTAssertFalse([@"just\"not\"right@example.com" isValidEmail]);
    XCTAssertFalse([@"this\\ is\"really\"not\\allowed@example.com" isValidEmail]);
}

#pragma mark - Mobile Number

- (void)testValidateMobileNumber {
    XCTAssertFalse([@"abc" isValidMobileNumber]);
    XCTAssertFalse([@"123456" isValidMobileNumber]);
    [URSettingsWrapper sharedInstance].countryCode = @"IN";
    NSString *nilString;
    XCTAssertFalse([nilString isValidMobileNumber]);
    XCTAssertFalse([@"" isValidMobileNumber]);
    XCTAssertTrue([@"9876543210" isValidMobileNumber]);
    XCTAssertNil([@"98765" validatedMobileNumber]);
    XCTAssertNotNil([@"9876543210" validatedMobileNumber]);
}

#pragma mark - Password

- (void)testValidateCheckPasswordText {
    XCTAssertTrue([@"abcd1234" isValidPassword]);
    XCTAssertTrue([@"ABCD1234" isValidPassword]);
    XCTAssertTrue([@"abcdef.$" isValidPassword]);
    XCTAssertTrue([@"123456_@" isValidPassword]);
    XCTAssertFalse([@"abcd" isValidPassword]);
}


- (void)testValidateCheckPasswordTextForCharacterLength {
    XCTAssertFalse([@"abcd123" hasCorrectLengthForPassword]);
    XCTAssertTrue([@"aabcd12345" hasCorrectLengthForPassword]);
    XCTAssertTrue([@"abcd1234" hasCorrectLengthForPassword]);
}


- (void)testValidateCheckPasswordTextForAlphabets {
    XCTAssertFalse([@"1234!@#$" containsAlphabets]);
    XCTAssertTrue([@"abcd12345" containsAlphabets]);
    XCTAssertTrue([@"ABCD12345" containsAlphabets]);
}


- (void)testValidateCheckPasswordTextForSpecialCharacters {
    XCTAssertTrue([@"1234!@#$" containsAllowedSpecialCharacters]);
    XCTAssertFalse([@"abcd12345" containsAllowedSpecialCharacters]);
}


- (void)testValidateCheckPasswordTextForNumbers {
    XCTAssertFalse([@"abcd!@#$" containsNumbers]);
    XCTAssertTrue([@"abcd12345" containsNumbers]);
}


- (void)testValidateCheckSiginPassword {
    XCTAssertFalse([@"" isValidSignInPassword]);
    XCTAssertTrue([@"a" isValidSignInPassword]);
    XCTAssertTrue([@"abcd1234" isValidSignInPassword]);
    XCTAssertTrue([@"abcdef.$" isValidSignInPassword]);
}

- (void)testValidateAccountVerificationCode {
    XCTAssertFalse([@"abs" isValidAccountVerificationCode]);
    XCTAssertFalse([@"abcdef" isValidAccountVerificationCode]);
    XCTAssertFalse([@"1234" isValidAccountVerificationCode]);
    XCTAssertTrue([@"123456" isValidAccountVerificationCode]);
}

#pragma mark - UIDTextField+ContentValidation

-(void)testValidateCheckFirstNameContent {
    [self.textfield setText:@""];
    XCTAssertFalse([self.textfield validateNameContent:@"lastName" displayError:NO]);
    
    [self.textfield setText:@"a"];
    XCTAssertTrue([self.textfield validateNameContent:@"lastName" displayError:NO]);
    [self.textfield setText:@"123456789012"];
    XCTAssertTrue([self.textfield validateNameContent:@"lastName" displayError:YES]);
    
    [self.textfield setText:@"www.google.com"];
    XCTAssertFalse([self.textfield validateNameContent:@"lastName" displayError:NO]);
    
    
    [self.textfield setText:@".com"];
    XCTAssertFalse([self.textfield validateNameContent:@"lastName" displayError:NO]);
    [self.textfield setText:@".co."];
    XCTAssertFalse([self.textfield validateNameContent:@"lastName" displayError:NO]);
    [self.textfield setText:@".ru"];
    XCTAssertFalse([self.textfield validateNameContent:@"lastName" displayError:NO]);
    [self.textfield setText:@".do"];
    XCTAssertFalse([self.textfield validateNameContent:@"lastName" displayError:NO]);
    [self.textfield setText:@".nl"];
    XCTAssertFalse([self.textfield validateNameContent:@"lastName" displayError:NO]);
    [self.textfield setText:@".be"];
    XCTAssertFalse([self.textfield validateNameContent:@"lastName" displayError:NO]);
    [self.textfield setText:@".fr"];
    XCTAssertFalse([self.textfield validateNameContent:@"lastName" displayError:NO]);
    [self.textfield setText:@".org"];
    XCTAssertFalse([self.textfield validateNameContent:@"lastName" displayError:NO]);
    [self.textfield setText:@"www."];
    XCTAssertFalse([self.textfield validateNameContent:@"lastName" displayError:NO]);
    [self.textfield setText:@">"];
    XCTAssertFalse([self.textfield validateNameContent:@"lastName" displayError:NO]);
    [self.textfield setText:@"<"];
    XCTAssertFalse([self.textfield validateNameContent:@"lastName" displayError:NO]);
    
    
    
    [self.textfield setText:@".cOm"];
    XCTAssertFalse([self.textfield validateNameContent:@"lastName" displayError:NO]);
    [self.textfield setText:@".Co."];
    XCTAssertFalse([self.textfield validateNameContent:@"lastName" displayError:NO]);
    [self.textfield setText:@".rU"];
    XCTAssertFalse([self.textfield validateNameContent:@"lastName" displayError:NO]);
    [self.textfield setText:@".Do"];
    XCTAssertFalse([self.textfield validateNameContent:@"lastName" displayError:NO]);
    [self.textfield setText:@".nL"];
    XCTAssertFalse([self.textfield validateNameContent:@"lastName" displayError:NO]);
    [self.textfield setText:@".Be"];
    XCTAssertFalse([self.textfield validateNameContent:@"lastName" displayError:NO]);
    [self.textfield setText:@".Fr"];
    XCTAssertFalse([self.textfield validateNameContent:@"lastName" displayError:NO]);
    [self.textfield setText:@".oRg"];
    XCTAssertFalse([self.textfield validateNameContent:@"lastName" displayError:NO]);
    [self.textfield setText:@"Www."];
    XCTAssertFalse([self.textfield validateNameContent:@"lastName" displayError:NO]);
    
    [self.textfield setText:@"In order for you, as a business customer of Philips, to be able to find out which set of terms and conditions apply to a commercial transaction between you and Philips, we have made available an overview of all the various General Terms and Conditions of commercial sale per the respective Philips legal entities. These General Terms and Conditions of commercial sale apply to all sales transactions made by the Philips’ Consumer Lifestyle and Lighting sectors with its professional or business customers, unless deviating agreements have been made in writing. For the avoidance of any doubt, these General Terms and Conditions of commercial sale do not apply to consumers."];
    XCTAssertFalse([self.textfield validateNameContent:@"lastName" displayError:YES]);
    //80 chars
    [self.textfield setText:@"01234567890123456789012345678901234567890123456789012345678901234567890123456789"];
    XCTAssertFalse([self.textfield validateNameContent:@"lastName" displayError:YES]);
    //79 chars
    [self.textfield setText:@"0123456789012345678901234567890123456789012345678901234567890123456789012345678"];
    XCTAssertTrue([self.textfield validateNameContent:@"lastName" displayError:YES]);
}


- (void)testValidateEmailAddressContent {
    [self.textfield setText:@""];
    XCTAssertFalse([self.textfield validateEmailContentAndDisplayError:NO]);
    [self.textfield setText:@"plainaddress"];
    XCTAssertFalse([self.textfield validateEmailContentAndDisplayError:YES]);
    [self.textfield setText:@"1234567890@domain.com"];
    XCTAssertTrue([self.textfield validateEmailContentAndDisplayError:YES]);
    
    [self.textfield setText:@""];
    XCTAssertFalse([self.textfield validateEmailContentAndDisplayError:NO]);
    [self.textfield setText:@"plainaddress"];
    XCTAssertFalse([self.textfield validateEmailContentAndDisplayError:YES]);
    [self.textfield setText:@"1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678900123@1.c"];
    XCTAssertFalse([self.textfield validateEmailContentAndDisplayError:YES]);
    [self.textfield setText:@"123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890012@1.c"];
    XCTAssertTrue([self.textfield validateEmailContentAndDisplayError:YES]);
}


- (void)testValidatePhoneNumberContent {
    [self.textfield setText:@""];
    XCTAssertFalse([self.textfield validatePhoneNumberContentAndDisplayError:NO]);
    [self.textfield setText:@"abcdefghij"];
    XCTAssertFalse([self.textfield validatePhoneNumberContentAndDisplayError:NO]);
    [self.textfield setText:@"123456"];
    XCTAssertFalse([self.textfield validatePhoneNumberContentAndDisplayError:YES]);
    [URSettingsWrapper sharedInstance].countryCode = @"IN";
    [self.textfield setText:@"9876543210"];
    XCTAssertTrue([self.textfield validatePhoneNumberContentAndDisplayError:YES]);
}


- (void)testValidateEmailOrPhoneNumberContent {
    [self.textfield setText:@""];
    XCTAssertFalse([self.textfield validateEmailOrMobileNumberContentAndDisplayError:NO]);
    [self.textfield setText:@"abcdefghij"];
    XCTAssertFalse([self.textfield validateEmailOrMobileNumberContentAndDisplayError:NO]);
    [self.textfield setText:@"123456"];
    XCTAssertFalse([self.textfield validateEmailOrMobileNumberContentAndDisplayError:YES]);
    [self.textfield setText:@"1234567890@domain.com"];
    XCTAssertTrue([self.textfield validateEmailOrMobileNumberContentAndDisplayError:YES]);
    [URSettingsWrapper sharedInstance].countryCode = @"IN";
    [self.textfield setText:@"9876543210"];
    XCTAssertTrue([self.textfield validateEmailOrMobileNumberContentAndDisplayError:YES]);
}


- (void)testValidatePasswordContent {
    [self.textfield setText:@""];
    XCTAssertFalse([self.textfield validatePasswordContentAndDisplayError]);
    [self.textfield setText:@"abcdefghij"];
    XCTAssertFalse([self.textfield validatePasswordContentAndDisplayError]);
    [self.textfield setText:@"123456"];
    XCTAssertFalse([self.textfield validatePasswordContentAndDisplayError]);
    [self.textfield setText:@"123@a"];
    XCTAssertFalse([self.textfield validatePasswordContentAndDisplayError]);
    [self.textfield setText:@"9876abcd"];
    XCTAssertTrue([self.textfield validatePasswordContentAndDisplayError]);
}


- (void)testValidateSignInPasswordContent {
    [self.textfield setText:@""];
    XCTAssertFalse([self.textfield validateSignInPasswordAndDisplayError:NO]);
    [self.textfield setText:@"abcdefghij"];
    XCTAssertTrue([self.textfield validateSignInPasswordAndDisplayError:YES]);
}


- (void)testValidateAccountVerificationCodeContent {
    [self.textfield setText:@""];
    XCTAssertFalse([self.textfield validateAccountVerificationCodeAndDisplayError]);
    [self.textfield setText:@"abcdefghij"];
    XCTAssertFalse([self.textfield validateAccountVerificationCodeAndDisplayError]);
    [self.textfield setText:@"123456"];
    XCTAssertTrue([self.textfield validateAccountVerificationCodeAndDisplayError]);
    [self.textfield setText:@"123@a"];
    XCTAssertFalse([self.textfield validateAccountVerificationCodeAndDisplayError]);
    [self.textfield setText:@"9876abcd"];
    XCTAssertFalse([self.textfield validateAccountVerificationCodeAndDisplayError]);
}
@end
