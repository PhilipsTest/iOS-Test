//
//  DemoAppTests.swift
//  DemoAppTests
//
//  Created by Abhishek Chatterjee on 28/06/17.
//  Copyright © 2017 Abhishek. All rights reserved.
//


import XCTest
import EarlGrey
import PhilipsRegistration
import PhilipsUIKitDLS
import PhilipsProductRegistration
import PlatformInterfaces
@testable import PRGDemoApp

class DemoAppTests: XCTestCase {
    
    var EarlGreyI = EarlGreyImpl.invoked(fromFile: "DemoAppTests", lineNumber: 15)
    
    
    override func setUp() {
        super.setUp()

        GREYConfiguration.sharedInstance().setValue(180, forConfigKey: kGREYConfigKeyInteractionTimeoutDuration)
        GREYConfiguration.sharedInstance().setValue(false, forConfigKey: kGREYConfigKeyAnalyticsEnabled)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testExample() {
        EarlGrey.selectElement(with: grey_keyWindow()).assert(grey_sufficientlyVisible())
        EarlGrey.selectElement(with: grey_buttonTitle("Launch PR")).assert(grey_sufficientlyVisible()).perform(grey_tap())
        ValidationHelper.assertCurrentScreenHasTitle("Registration")
        EarlGrey.selectElement(with: grey_text("Current configuration: Staging")).assert(grey_sufficientlyVisible())
        EarlGrey.selectElement(with: grey_buttonTitle("User registration")).assert(grey_sufficientlyVisible()).perform(grey_tap())
        ValidationHelper.isScreenTitleEqualTo("Getting Started") //Dummy check to make EarlGrey synchronize with network requests
        if DIUser.getInstance().userLoggedInState.rawValue == UserLoggedInState.userLoggedIn.rawValue {
            EarlGrey.selectElement(with: grey_text("OK, count me in")).assert(grey_sufficientlyVisible()).perform(grey_tap())
        } else {
            ValidationHelper.assertCurrentScreenHasTitle("Getting Started")
            EarlGrey.selectElement(with: grey_text("Log in")).assert(grey_sufficientlyVisible()).perform(grey_tap())
            EarlGrey.selectElement(with: grey_accessibilityID("usr_loginScreen_email_textField")).assert(grey_sufficientlyVisible()).perform(grey_typeText("pr_automation@mailinator.com"))
            EarlGrey.selectElement(with: grey_accessibilityID("usr_loginScreen_password_textField")).assert(grey_sufficientlyVisible()).perform(grey_typeText("philips123"))
            EarlGreyI.dismissKeyboardWithError(nil)
            EarlGrey.selectElement(with: grey_accessibilityID("usr_loginScreen_login_button")).assert(grey_sufficientlyVisible()).perform(grey_tap())
        }
        if ValidationHelper.isScreenTitleEqualTo("Log in") { //We need to accept terms and conditions
            EarlGrey.selectElement(with: grey_accessibilityID("usr_almostDoneScreen_termsAndConditions_checkBox")).assert(grey_sufficientlyVisible()).perform(grey_tap())
            EarlGrey.selectElement(with: grey_accessibilityID("usr_almostDoneScreen_continue_button")).assert(grey_sufficientlyVisible()).perform(grey_tap())
            
        }
        ValidationHelper.assertCurrentScreenHasTitle("Registration")
        EarlGrey.selectElement(with: grey_buttonTitle("ProductRegistration with UI")).assert(grey_sufficientlyVisible()).perform(grey_tap())
        
        //MARK: - Try with invalid CTN and DLS alert should be displayed -
        ValidationHelper.assertCurrentScreenHasTitle("Product registration")
        EarlGrey.selectElement(with: grey_accessibilityID("pr_demo_ctn_field")).assert(grey_sufficientlyVisible()).perform(grey_typeText("S0452/02"))
        EarlGreyI.dismissKeyboardWithError(nil)
        EarlGrey.selectElement(with: grey_buttonTitle("Register")).assert(grey_sufficientlyVisible()).perform(grey_tap())
        ValidationHelper.assertCurrentScreenHasTitle("Register your product")
        EarlGrey.selectElement(with: grey_text("No thanks, register later")).assert(grey_sufficientlyVisible()).perform(grey_tap())
        ValidationHelper.assertCurrentScreenHasTitle("Product registration")
        EarlGrey.selectElement(with: grey_text("Register")).assert(grey_sufficientlyVisible()).perform(grey_tap())
        ValidationHelper.assertCurrentScreenHasTitle("Register your product")
        EarlGrey.selectElement(with: grey_text("Yes, extend my warranty")).assert(grey_sufficientlyVisible()).perform(grey_tap())
        ValidationHelper.assertCurrentScreenHasTitle("Register your product")
        EarlGrey.selectElement(with: grey_text("Product not found!")).assert(grey_sufficientlyVisible())
        EarlGrey.selectElement(with: grey_text("Product not supported in this region, please contact consumer care.")).assert(grey_sufficientlyVisible())
        EarlGrey.selectElement(with: grey_buttonTitle("OK ")).assert(grey_sufficientlyVisible()).perform(grey_tap())
        ValidationHelper.assertCurrentScreenHasTitle("Register your product")
        ValidationHelper.tapNavigationBackButton()
        
        //MARK: - Try with product without serial number -
        ValidationHelper.assertCurrentScreenHasTitle("Product registration")
        EarlGrey.selectElement(with: grey_accessibilityID("pr_demo_ctn_field")).assert(grey_sufficientlyVisible()).perform(grey_clearText()).perform(grey_typeText("HX6311/07"))
        EarlGreyI.dismissKeyboardWithError(nil)
        EarlGrey.selectElement(with: grey_text("Register")).assert(grey_sufficientlyVisible()).perform(grey_tap())
        ValidationHelper.assertCurrentScreenHasTitle("Register your product")
        EarlGrey.selectElement(with: grey_text("Yes, extend my warranty")).assert(grey_sufficientlyVisible()).perform(grey_tap())
        ValidationHelper.assertCurrentScreenHasTitle("Register your product")
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_productTitle_label")).assert(grey_sufficientlyVisible()).assert(grey_text("Sonicare For Kids Sonic electric toothbrush"))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_ctn_label")).assert(grey_sufficientlyVisible()).assert(grey_text("HX6311/07"))
        validateProductImageIsDisplayed()
        EarlGrey.selectElement(with: grey_allOf([grey_kindOfClass(UIScrollView.self), grey_sufficientlyVisible()])).perform(grey_scrollToContentEdge(.bottom))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_serialNumber_label")).assert(grey_notVisible())
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_serialNumber_validationEditText")).assert(grey_notVisible())
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_findSerialNumber_Label")).assert(grey_notVisible())
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_dateOfPurchase_label")).assert(grey_sufficientlyVisible()).assert(grey_text("Date of purchase"))
        validateDateTextField()
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_register_button")).assert(grey_sufficientlyVisible()).assert(grey_buttonTitle("Register"))
        EarlGrey.selectElement(with: grey_allOf([grey_kindOfClass(UIImageView.self), grey_ancestor(grey_accessibilityID("prg_registerScreen_dateOfPurchase_validationEditText"))])).assert(grey_sufficientlyVisible()).perform(grey_tap())
        EarlGrey.selectElement(with: grey_kindOfClass(UIDDatePicker.self)).assert(grey_sufficientlyVisible()).perform(grey_setDate(Date(timeInterval: -86400, since: Date())))
        EarlGrey.selectElement(with: grey_allOf([grey_kindOfClass(UIImageView.self), grey_ancestor(grey_accessibilityID("prg_registerScreen_dateOfPurchase_validationEditText"))])).assert(grey_sufficientlyVisible()).perform(grey_tap())
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_register_button")).perform(grey_tap())

        ValidationHelper.assertCurrentScreenHasTitle("Register your product")
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_header_label")).assert(grey_sufficientlyVisible()).assert(grey_text("Successfully registered"))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_product_image")).assert(grey_sufficientlyVisible()).assert(GREYAssertionBlock.init(name: "Image Assertion", assertionBlockWithError: { (imageView, error) -> Bool in
            error?.pointee = NSError.init(domain: "EarlGreyErrorDomain", code: 1004, userInfo: [kGREYAssertionUserInfoKey: "Product Image not displayed"])
            if let imageView = imageView as? UIImageView {
                if imageView.image != nil {
                    return true
                }
            }
            return false
        }))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_model_label")).assert(grey_sufficientlyVisible()).assert(grey_text("Sonicare For Kids Sonic electric toothbrush"))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_ctn_label")).assert(grey_sufficientlyVisible()).assert(grey_text("HX6311/07"))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_success_image")).assert(grey_sufficientlyVisible())
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_registered_label")).assert(grey_sufficientlyVisible()).assert(grey_text("Registered"))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_warranty_label")).assert(grey_notVisible())
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_email_label")).assert(grey_notVisible())
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_continue_button")).assert(grey_sufficientlyVisible()).assert(grey_buttonTitle("Continue ")).perform(grey_tap())
        
        
        //Mark: - Now test same product to see if already registered alert is displayed
        EarlGrey.selectElement(with: grey_text("Register")).assert(grey_sufficientlyVisible()).perform(grey_tap())
        ValidationHelper.assertCurrentScreenHasTitle("Register your product")
        EarlGrey.selectElement(with: grey_text("Yes, extend my warranty")).assert(grey_sufficientlyVisible()).perform(grey_tap())
        ValidationHelper.assertCurrentScreenHasTitle("Register your product")
        EarlGrey.selectElement(with: grey_text("Product already registered")).assert(grey_sufficientlyVisible())
        EarlGrey.selectElement(with: grey_buttonTitle("Continue ")).assert(grey_sufficientlyVisible())
        EarlGrey.selectElement(with: grey_buttonTitle("Close")).assert(grey_sufficientlyVisible()).perform(grey_tap())
        EarlGrey.selectElement(with: grey_allOf([grey_kindOfClass(UIScrollView.self), grey_sufficientlyVisible()])).perform(grey_scrollToContentEdge(.bottom))
        EarlGrey.selectElement(with: grey_allOf([grey_kindOfClass(UIImageView.self), grey_ancestor(grey_accessibilityID("prg_registerScreen_dateOfPurchase_validationEditText"))])).assert(grey_sufficientlyVisible()).perform(grey_tap())
        EarlGrey.selectElement(with: grey_kindOfClass(UIDDatePicker.self)).assert(grey_sufficientlyVisible()).perform(grey_setDate(Date(timeInterval: -86400, since: Date())))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_register_button")).assert(grey_sufficientlyVisible()).assert(grey_buttonTitle("Register")).perform(grey_tap())
        EarlGrey.selectElement(with: grey_text("Product already registered")).assert(grey_sufficientlyVisible())
        EarlGrey.selectElement(with: grey_buttonTitle("Close")).assert(grey_sufficientlyVisible())
        EarlGrey.selectElement(with: grey_buttonTitle("Continue ")).assert(grey_sufficientlyVisible()).perform(grey_tap())
        
        
        validateProductWithExplicitSerialNumber()
        validateProductWithImplicitSerialNumber()
        ValidationHelper.assertCurrentScreenHasTitle("Product registration")
        ValidationHelper.tapNavigationBackButton()
        ValidationHelper.assertCurrentScreenHasTitle("Registration")
        EarlGrey.selectElement(with: grey_buttonTitle("Product list")).assert(grey_sufficientlyVisible()).perform(grey_tap())
        ValidationHelper.isScreenTitleEqualTo("Dummy title")
        ValidationHelper.tapNavigationBackButton()
    }
    
    
    func validateProductWithExplicitSerialNumber() {
        ValidationHelper.assertCurrentScreenHasTitle("Product registration")
        EarlGrey.selectElement(with: grey_accessibilityID("pr_demo_ctn_field")).assert(grey_sufficientlyVisible()).perform(grey_clearText()).perform(grey_typeText("S5420/06"))
        EarlGreyI.dismissKeyboardWithError(nil)
        EarlGrey.selectElement(with: grey_text("Register")).assert(grey_sufficientlyVisible()).perform(grey_tap())
        ValidationHelper.assertCurrentScreenHasTitle("Register your product")
        EarlGrey.selectElement(with: grey_text("Yes, extend my warranty")).assert(grey_sufficientlyVisible()).perform(grey_tap())
        ValidationHelper.assertCurrentScreenHasTitle("Register your product")
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_productTitle_label")).assert(grey_sufficientlyVisible()).assert(grey_text("AquaTouch Wet and dry electric shaver"))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_ctn_label")).assert(grey_sufficientlyVisible()).assert(grey_text("S5420/06"))
        validateProductImageIsDisplayed()
        EarlGrey.selectElement(with: grey_allOf([grey_kindOfClass(UIScrollView.self), grey_sufficientlyVisible()])).perform(grey_scrollToContentEdge(.bottom))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_serialNumber_label")).assert(grey_sufficientlyVisible()).assert(grey_text("Serial number"))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_serialNumber_validationEditText")).assert(grey_sufficientlyVisible())
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_findSerialNumber_Label")).assert(grey_sufficientlyVisible()).assert(grey_text("Where can I find my serial number?")).perform(grey_tap())
        
        
        //Verify Serial number screen
        ValidationHelper.assertCurrentScreenHasTitle("Register your product")
//        EarlGreyI.selectElement(with: grey_accessibilityLabel("prg_findSerialNo_image")).assert(grey_sufficientlyVisible()).assert(GREYAssertionBlock.init(name: "Help image assertions", assertionBlockWithError: { (element, error) -> Bool in
//            error?.pointee = NSError.init(domain: "EarlGreyErrorDomain", code: 1005, userInfo: [kGREYActionErrorUserInfoKey: "Help image not displayed"])
//            if let imageView = element as? UIImageView, imageView.image != nil {
//                return true
//            }
//            return false
//        }))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_findSerialNo_title_label")).assert(grey_sufficientlyVisible()).assert(grey_text("Where can I find my serial number?"))
        EarlGrey.selectElement(with: grey_accessibilityLabel("prg_findSerialNo_desc_label")).assert(grey_sufficientlyVisible()).assert(grey_text("The serial number consists of 9 numbers, starting with 5 .E.g. 515171001"))
        EarlGrey.selectElement(with: grey_accessibilityLabel("prg_findSerialNo_done_button")).assert(grey_sufficientlyVisible()).assert(grey_buttonTitle("OK, I found it")).perform(grey_tap())

        
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_dateOfPurchase_label")).assert(grey_sufficientlyVisible()).assert(grey_text("Date of purchase"))
        validateDateTextField()
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_register_button")).assert(grey_sufficientlyVisible()).assert(grey_buttonTitle("Register"))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_serialNumber_validationEditText")).perform(grey_typeText("7537263"))
        EarlGreyI.dismissKeyboardWithError(nil)
        
        EarlGrey.selectElement(with: grey_allOf([grey_kindOfClass(UIImageView.self), grey_ancestor(grey_accessibilityID("prg_registerScreen_dateOfPurchase_validationEditText"))])).assert(grey_sufficientlyVisible()).perform(grey_tap())
        EarlGrey.selectElement(with: grey_kindOfClass(UIDDatePicker.self)).assert(grey_sufficientlyVisible()).perform(grey_setDate(createDate()))
        EarlGrey.selectElement(with: grey_allOf([grey_kindOfClass(UIImageView.self), grey_ancestor(grey_accessibilityID("prg_registerScreen_dateOfPurchase_validationEditText"))])).assert(grey_sufficientlyVisible()).perform(grey_tap())
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_register_button")).perform(grey_tap())
        
        ValidationHelper.assertCurrentScreenHasTitle("Register your product")
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_header_label")).assert(grey_sufficientlyVisible()).assert(grey_text("Successfully registered"))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_product_image")).assert(grey_sufficientlyVisible()).assert(GREYAssertionBlock.init(name: "Image Assertion", assertionBlockWithError: { (imageView, error) -> Bool in
            error?.pointee = NSError.init(domain: "EarlGreyErrorDomain", code: 1004, userInfo: [kGREYAssertionUserInfoKey: "Product Image not displayed"])
            if let imageView = imageView as? UIImageView {
                if imageView.image != nil {
                    return true
                }
            }
            return false
        }))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_model_label")).assert(grey_sufficientlyVisible()).assert(grey_text("AquaTouch Wet and dry electric shaver"))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_ctn_label")).assert(grey_sufficientlyVisible()).assert(grey_text("S5420/06"))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_success_image")).assert(grey_sufficientlyVisible())
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_registered_label")).assert(grey_sufficientlyVisible()).assert(grey_text("Registered"))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_warranty_label")).assert(grey_sufficientlyVisible()).assert(grey_text("Your warranty period has been extended untill 3/3/21"))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_email_label")).assert(grey_sufficientlyVisible()).assert(grey_text("An email with extended warranty contact has been sent to your email address"))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_continue_button")).assert(grey_sufficientlyVisible()).assert(grey_buttonTitle("Continue ")).perform(grey_tap())
    }
    
    
    func validateProductWithImplicitSerialNumber() {
        ValidationHelper.assertCurrentScreenHasTitle("Product registration")
        EarlGrey.selectElement(with: grey_accessibilityID("pr_demo_ctn_field")).assert(grey_sufficientlyVisible()).perform(grey_clearText()).perform(grey_typeText("AT620/14"))
        EarlGrey.selectElement(with: grey_accessibilityID("pr_demo_serial_number_field")).assert(grey_sufficientlyVisible()).perform(grey_clearText()).perform(grey_typeText("13332"))
        EarlGreyI.dismissKeyboardWithError(nil)
        EarlGrey.selectElement(with: grey_text("Register")).assert(grey_sufficientlyVisible()).perform(grey_tap())
        ValidationHelper.assertCurrentScreenHasTitle("Register your product")
        EarlGrey.selectElement(with: grey_text("Yes, extend my warranty")).assert(grey_sufficientlyVisible()).perform(grey_tap())
        ValidationHelper.assertCurrentScreenHasTitle("Register your product")
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_productTitle_label")).assert(grey_sufficientlyVisible()).assert(grey_text("AquaTouch Electric Shaver Wet & Dry"))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_ctn_label")).assert(grey_sufficientlyVisible()).assert(grey_text("AT620/14"))
        validateProductImageIsDisplayed()
        
        EarlGrey.selectElement(with: grey_allOf([grey_kindOfClass(UIScrollView.self), grey_sufficientlyVisible()])).perform(grey_scrollToContentEdge(.bottom))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_serialNumber_label")).assert(grey_notVisible())
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_serialNumber_validationEditText")).assert(grey_notVisible())
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_findSerialNumber_Label")).assert(grey_notVisible())
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_dateOfPurchase_label")).assert(grey_sufficientlyVisible()).assert(grey_text("Date of purchase"))
        validateDateTextField()
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_register_button")).assert(grey_sufficientlyVisible()).assert(grey_buttonTitle("Register"))
        EarlGrey.selectElement(with: grey_allOf([grey_kindOfClass(UIImageView.self), grey_ancestor(grey_accessibilityID("prg_registerScreen_dateOfPurchase_validationEditText"))])).assert(grey_sufficientlyVisible()).perform(grey_tap())
        EarlGrey.selectElement(with: grey_kindOfClass(UIDDatePicker.self)).assert(grey_sufficientlyVisible()).perform(grey_setDate(createDate()))
        EarlGrey.selectElement(with: grey_allOf([grey_kindOfClass(UIImageView.self), grey_ancestor(grey_accessibilityID("prg_registerScreen_dateOfPurchase_validationEditText"))])).assert(grey_sufficientlyVisible()).perform(grey_tap())
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_register_button")).perform(grey_tap())
        
        
        ValidationHelper.assertCurrentScreenHasTitle("Register your product")
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_header_label")).assert(grey_sufficientlyVisible()).assert(grey_text("Successfully registered"))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_product_image")).assert(grey_sufficientlyVisible()).assert(GREYAssertionBlock.init(name: "Image Assertion", assertionBlockWithError: { (imageView, error) -> Bool in
            error?.pointee = NSError.init(domain: "EarlGreyErrorDomain", code: 1004, userInfo: [kGREYAssertionUserInfoKey: "Product Image not displayed"])
            if let imageView = imageView as? UIImageView {
                if imageView.image != nil {
                    return true
                }
            }
            return false
        }))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_model_label")).assert(grey_sufficientlyVisible()).assert(grey_text("AquaTouch Electric Shaver Wet & Dry"))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_ctn_label")).assert(grey_sufficientlyVisible()).assert(grey_text("AT620/14"))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_success_image")).assert(grey_sufficientlyVisible())
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_registered_label")).assert(grey_sufficientlyVisible()).assert(grey_text("Registered"))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_warranty_label")).assert(grey_sufficientlyVisible()).assert(grey_text("Your warranty period has been extended untill 3/3/21"))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_email_label")).assert(grey_sufficientlyVisible()).assert(grey_text("An email with extended warranty contact has been sent to your email address"))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_successScreen_continue_button")).assert(grey_sufficientlyVisible()).assert(grey_buttonTitle("Continue ")).perform(grey_tap())
        
        //Mark: - Now test same product to see if already registered alert is displayed
        EarlGrey.selectElement(with: grey_text("Register")).assert(grey_sufficientlyVisible()).perform(grey_tap())
        ValidationHelper.assertCurrentScreenHasTitle("Register your product")
        EarlGrey.selectElement(with: grey_text("Yes, extend my warranty")).assert(grey_sufficientlyVisible()).perform(grey_tap())
        ValidationHelper.assertCurrentScreenHasTitle("Register your product")
        EarlGrey.selectElement(with: grey_text("This serial number 13332 is already registered")).assert(grey_sufficientlyVisible())
        EarlGrey.selectElement(with: grey_buttonTitle("Continue ")).assert(grey_sufficientlyVisible())
        EarlGrey.selectElement(with: grey_buttonTitle("Close")).assert(grey_sufficientlyVisible()).perform(grey_tap())
        EarlGrey.selectElement(with: grey_allOf([grey_kindOfClass(UIScrollView.self), grey_sufficientlyVisible()])).perform(grey_scrollToContentEdge(.bottom))
        EarlGrey.selectElement(with: grey_allOf([grey_kindOfClass(UIImageView.self), grey_ancestor(grey_accessibilityID("prg_registerScreen_dateOfPurchase_validationEditText"))])).assert(grey_sufficientlyVisible()).perform(grey_tap())
        EarlGrey.selectElement(with: grey_kindOfClass(UIDDatePicker.self)).assert(grey_sufficientlyVisible()).perform(grey_setDate(Date(timeInterval: -86400, since: Date())))
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_register_button")).assert(grey_sufficientlyVisible()).assert(grey_buttonTitle("Register")).perform(grey_tap())
        EarlGrey.selectElement(with: grey_text("This serial number 13332 is already registered")).assert(grey_sufficientlyVisible())
        EarlGrey.selectElement(with: grey_buttonTitle("Close")).assert(grey_sufficientlyVisible())
        EarlGrey.selectElement(with: grey_buttonTitle("Continue ")).assert(grey_sufficientlyVisible()).perform(grey_tap())
    }
    
    
    func createDate() -> Date {
        let components = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, year: 2018, month: 3, day: 4)
        return Calendar.current.date(from: components)!
    }
    
    
    func validateDateTextField() {
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_dateOfPurchase_validationEditText")).assert(grey_sufficientlyVisible()).assert(GREYAssertionBlock.init(name: "", assertionBlockWithError: { (textField, error) -> Bool in
            error?.pointee = NSError.init(domain: "", code: 1003, userInfo: [kGREYActionErrorUserInfoKey: "Date text field not as expected"])
            guard let textField = textField as? UITextField else {//Textfield exists
                return false
            }
            guard textField.text?.count  ?? 0 <= 0 else {//TextField has no text
                return false
            }
            guard let calendarImageView = textField.rightView as? UIImageView else {//Calendar image is displayed
                return false
            }
            let calendarImage = UIImage(named: "calendar", in: Bundle.init(for: PPRInterface.self), compatibleWith: nil)
            if let image = calendarImageView.image, image == calendarImage {//Image is same as in PR bundle
                return true
            }
            return false
        }))
    }
    
    
    func validateProductImageIsDisplayed() {
        EarlGrey.selectElement(with: grey_accessibilityID("prg_registerScreen_product_image")).assert(grey_sufficientlyVisible()).assert(GREYAssertionBlock.init(name: "Image assertion", assertionBlockWithError: { (imageView, error) -> Bool in
            if let imageView = imageView as? UIImageView {
                if let _ = imageView.image {
                    return true
                }
            }
            error?.pointee = NSError.init(domain: "EarlGreyDomain", code: 1002, userInfo: [kGREYAssertionErrorUserInfoKey: "Product image not displayed"])
            return false
        }))
    }
    
}
