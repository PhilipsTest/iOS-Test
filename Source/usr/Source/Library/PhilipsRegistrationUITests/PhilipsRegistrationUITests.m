//
//  PhilipsRegistrationUITests.m
//  PhilipsRegistrationUITests
//
//  Created by Abhishek on 02/08/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface PhilipsRegistrationUITests : XCTestCase

@end

@implementation PhilipsRegistrationUITests

- (void)setUp {
    [super setUp];

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    sleep(1);
    // starting infinite loop which can be stopped by changing the shouldKeepRunning's
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

-(void)changeflow:(XCUIApplication *)app flow:(NSString *)flow
{
    if ([app.buttons[@"Change_Configuration"] exists]) {
        [app.buttons[@"Change_Configuration"] tap];
        [app.sheets[@"Change configuration file"].buttons[flow] tap];
    }
    
    [app.buttons[@"demoApp.registrationButton"] tap];
    
    //Log out user if already logged in
    if (app.buttons[@"Log Out"].exists) {
        [app.buttons[@"Log Out"] tap];
    }
}


- (void)testCreateAccount {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [self changeflow:app flow:@"Standard"];
    
    [[app.scrollViews.otherElements containingType:XCUIElementTypeStaticText identifier:@"Or create an account"].buttons[@"registration.creataccount.button"] tap];
    
    [self waitForElementToAppear:app.textFields[@"Enter first name"] withTimeout:10];

    NSString *userName = [NSString stringWithFormat:@"UserRegistrationUI%d",(int)[[NSDate date] timeIntervalSince1970]];
    XCUIElement *enterUserNameTextField = app.textFields[@"Enter first name"];
    [enterUserNameTextField tap];
    [enterUserNameTextField typeText:userName];
    
    [app.buttons[@"Next:"] tap];
    
    NSString *emailId = [NSString stringWithFormat:@"%@@mailinator.com", userName];
    XCUIElement *enterEmailAddressTextField = app.textFields[@"Enter email address"];
    [enterEmailAddressTextField tap];
    [enterEmailAddressTextField typeText:emailId];
    
    [app.buttons[@"Next:"] tap];
    
    XCUIElement *chooseAPasswordSecureTextField = app.secureTextFields[@"Choose a password"];
    [chooseAPasswordSecureTextField tap];
    [chooseAPasswordSecureTextField typeText:@"Password@123"];
    
    [[[[app.scrollViews containingType:XCUIElementTypeTextField identifier:@"Enter first name"] childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1].otherElements[@"Control Switch"] tap];
    
    XCUIElement *createPhilipsAccountButton = app.buttons[@"Create Philips account"];
    [createPhilipsAccountButton tap];
    
    
    [self waitForElementToAppear:app.buttons[@"I have activated my account"] withTimeout:10];
    [app.buttons[@"I have activated my account"] tap];
    sleep(5);
    
}

- (void) testUserLogin {
    
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [self changeflow:app flow:@"Standard"];
    
    [app.tables[@"registration.loginOptions.tableview"].buttons[@"Philips account"] tap];
    
    NSString *emailId = [NSString stringWithFormat:@"abhishek.chatterjee@philips.com"];
    [self waitForElementToAppear:app.textFields[@"signIn.email.textfield"] withTimeout:10];

    XCUIElement *usernameField = app.textFields[@"signIn.email.textfield"];
    [usernameField tap];
    [usernameField typeText:emailId];
    
    [app.buttons[@"Next:"] tap];
    
    XCUIElement *passwordField = app.secureTextFields[@"signIn.password.textfield"];
    [passwordField typeText:@"Password@123"];
    [passwordField tap];
    
    [app.buttons[@"signIn.signIn.button"] tap];
    
    [self waitForElementToAppear:app.scrollViews.otherElements.otherElements[@"almostDone.termsAndConditions.switch"] withTimeout:10];
    
    if (app.scrollViews.otherElements.otherElements[@"almostDone.termsAndConditions.switch"].exists) {
        [app.scrollViews.otherElements.otherElements[@"almostDone.termsAndConditions.switch"] tap];
        [app.buttons[@"almostDone.continue.button"] tap];
    }
    [self waitForElementToAppear:app.buttons[@"signInSuccess.continue.button"] withTimeout:20];
    
    [app.buttons[@"signInSuccess.continue.button"] tap];
}

- (void) testGoogleLogin {

    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [self changeflow:app flow:@"Standard"];
    
    [self waitForElementToAppear:app.tables[@"registration.loginOptions.tableview"].buttons[@"Google+"] withTimeout:15];
    
    [app.tables[@"registration.loginOptions.tableview"].buttons[@"Google+"] tap];
    [self waitForElementToAppear:app.textFields[@"Email or phone"] withTimeout:30];
    //Enter email
    [app.textFields[@"Email or phone"] tap];
    NSString *emailId = [NSString stringWithFormat:@"philipstest786"];
    [app.textFields[@"Email or phone"] typeText:emailId];
    
    //Tap next
    [app.buttons[@"NEXT"] tap];
    [self waitForElementToAppear:app.secureTextFields[@"Enter your password"] withTimeout:15];
    
    //Enter password
    [app.secureTextFields[@"Enter your password"] tap];
    NSString *password = [NSString stringWithFormat:@"TestPhilips123"];
    [app.secureTextFields[@"Enter your password"] typeText:password];
    
    //Tap sign in button
    [app.buttons[@"NEXT"] tap];
    [NSThread sleepForTimeInterval:10];
    
    [self waitForElementToAppear:app.navigationBars[@"Log In"] withTimeout:20];
    
    /* //In case if Facebook and Google account to connect
     
     
     if (app.buttons[@"Connect"].exists) {
     [app.buttons[@"Connect"] tap];
     
     [self waitForElementToAppear:app.textFields[@"Email address or phone number"] withTimeout:10];
     
     if (app.textFields[@"Email address or phone number"].exists) {
     [app.textFields[@"Email address or phone number"] tap];
     [app.textFields[@"Email address or phone number"] typeText:@"philipstest365@gmail.com"];
     
     [app.secureTextFields[@"Facebook password"] tap];
     [app.secureTextFields[@"Facebook password"] typeText:@"TestPhilips123"];
     
     [app.buttons[@"Log In"] tap];
     }
     } */
    
    [self waitForElementToAppear:app.scrollViews.otherElements.otherElements[@"almostDone.termsAndConditions.switch"] withTimeout:10];
    
    if (app.scrollViews.otherElements.otherElements[@"almostDone.termsAndConditions.switch"].exists) {
        [app.scrollViews.otherElements.otherElements[@"almostDone.termsAndConditions.switch"] tap];
        [app.buttons[@"almostDone.continue.button"] tap];
    }
    
    [self waitForElementToAppear:app.buttons[@"signInSuccess.continue.button"] withTimeout:10];
    [app.buttons[@"signInSuccess.continue.button"] tap];
}

- (void)testFacebookLogin {
    
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [self changeflow:app flow:@"Standard"];
    
    [self waitForElementToAppear:app.tables[@"registration.loginOptions.tableview"].buttons[@"Facebook"] withTimeout:10];
    
    [app.tables[@"registration.loginOptions.tableview"].buttons[@"Facebook"] tap];
    

    XCUIElementQuery *webViewsQuery = app.webViews;
    [self waitForElementToAppear:webViewsQuery.textFields[@"Email address or phone number"] withTimeout:15];
    XCUIElement *emailAddressOrPhoneNumberTextField = webViewsQuery.textFields[@"Email address or phone number"];
    [emailAddressOrPhoneNumberTextField tap];
    [emailAddressOrPhoneNumberTextField typeText:@"philipstest365@gmail.com"];
    
    XCUIElement *facebookPasswordSecureTextField = webViewsQuery.secureTextFields[@"Facebook password"];
    [facebookPasswordSecureTextField tap];
    [facebookPasswordSecureTextField typeText:@"TestPhilips123"];
    [webViewsQuery.buttons[@"Log In"] tap];
    
    [self waitForElementToAppear:app.scrollViews.otherElements.otherElements[@"almostDone.termsAndConditions.switch"] withTimeout:10];
    
    if (app.scrollViews.otherElements.otherElements[@"almostDone.termsAndConditions.switch"].exists) {
        [app.scrollViews.otherElements.otherElements[@"almostDone.termsAndConditions.switch"] tap];
        [app.buttons[@"almostDone.continue.button"] tap];
    }
    
    [self waitForElementToAppear:app.buttons[@"signInSuccess.continue.button"] withTimeout:20];
    [app.buttons[@"signInSuccess.continue.button"] tap];
}

-(void)testCoppaLogin {
    
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [self changeflow:app flow:@"Coppa"];
    
    [app.buttons[@"I am over 16"] tap];
    [app.tables.staticTexts[@"How old are you?"] tap];
    [app.tables.pickerWheels.element adjustToPickerWheelValue:@"16"];
    [app.tables.staticTexts[@"How old are you?"] tap];

    [app.tables.staticTexts[@"Year of birth"] tap];
    [app.tables.pickerWheels.element adjustToPickerWheelValue:@"2000"];
    [app.tables.staticTexts[@"Year of birth"] tap];
   
    [app.buttons[@"Continue"] tap];
    
    [app.tables[@"registration.loginOptions.tableview"].buttons[@"Philips account"] tap];
    
    NSString *emailId = [NSString stringWithFormat:@"abhishek.chatterjee@philips.com"];
    
    XCUIElement *usernameField = app.textFields[@"signIn.email.textfield"];
    [usernameField tap];
    [usernameField typeText:emailId];
    
    [app.buttons[@"Next:"] tap];
    
    XCUIElement *passwordField = app.secureTextFields[@"signIn.password.textfield"];
    [passwordField typeText:@"Password@123"];
    [passwordField tap];
    
    [app.buttons[@"signIn.signIn.button"] tap];
    
    [self waitForElementToAppear:app.scrollViews.otherElements.otherElements[@"almostDone.termsAndConditions.switch"] withTimeout:10];
    
    if (app.scrollViews.otherElements.otherElements[@"almostDone.termsAndConditions.switch"].exists) {
        [app.scrollViews.otherElements.otherElements[@"almostDone.termsAndConditions.switch"] tap];
        [app.buttons[@"almostDone.continue.button"] tap];
    }
    [self waitForElementToAppear:app.buttons[@"signInSuccess.continue.button"] withTimeout:20];
    
    [app.buttons[@"signInSuccess.continue.button"] tap];
    
    XCUIElement *denyConsentButton = app.scrollViews.otherElements.buttons[@"No, I deny consent"];

    if ([denyConsentButton exists]) {
        [denyConsentButton tap];
    } else {
        [app.buttons[@"Launch Consent Flow"] tap];
        [denyConsentButton tap];
    }
}

-(void)testForgotPassword {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [self changeflow:app flow:@"Standard"];

    [app.tables[@"registration.loginOptions.tableview"].buttons[@"Philips account"] tap];
    [app.buttons[@"Forgot Password"] tap];
    
    XCUIElement *continueButton = app.buttons[@"Continue"];
    NSString *emailId = [NSString stringWithFormat:@"mailtestphilips@mailinator.com"];
    
    XCUIElement *forgotPassowordField = app.textFields[@"signIn.password.textfield"];
    [forgotPassowordField tap];
    [forgotPassowordField typeText:emailId];
    
    [app.buttons[@"signInSuccess.continue.button"] tap];
    sleep(2);
    [self waitForElementToAppear:app.buttons[@"Continue"] withTimeout:20];
//    [continueButton tap];
}
#pragma mark -
#pragma mark - Private Methods

- (void)waitForElementToAppear:(XCUIElement *)element withTimeout:(NSTimeInterval)timeout
{
    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
    while (!element.exists) {
        if ([NSDate timeIntervalSinceReferenceDate] - startTime > timeout) {
            // XCTFail(@"Timed out waiting for element to exist");
            return;
        }
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.1, false);
    }
}



@end
