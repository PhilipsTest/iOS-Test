/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev
import PhilipsUIKitDLS

class IAPTextFieldInputValidationTests: XCTestCase {
    
    var textField: UIDTextField!
    var button: UIDButton!
    var label: UIDLabel!
    
    override func setUp() {
        super.setUp()

        textField = UIDTextField(frame: CGRect.zero)
        button = UIDButton(frame: CGRect.zero)
        label = UIDLabel(frame: CGRect.zero)
    }
    
    func testTextFieldRegularExpression() {
        let regularExpression = "^[a-zA-Z\\s]{1,17}$"
        textField.validationRegExp = regularExpression
        XCTAssert(textField.validationRegExp != "ABC", "Regular expression is not right")
        XCTAssert(textField.validationRegExp == regularExpression, "Regular expression is not the same as it was set")
    }
    
    func testTextFieldErrorMessage() {
        let validityErrorMessage = "Please enter a valid name"
        textField.validityErrorMessage = validityErrorMessage
        XCTAssert(textField.validityErrorMessage != "Please enter a valid number", "Validity error message is not right")
        XCTAssert(textField.validityErrorMessage == validityErrorMessage, "Validity error message is not the same as it was set")
    }
    
    func testTextFieldMaximumCharacters() {
        let maximumCharacters:NSNumber = 20
        textField.maximumCharacters = maximumCharacters as NSNumber?
        XCTAssert(textField.maximumCharacters == maximumCharacters, "Maximum characters are not the same")
        XCTAssert(textField.maximumCharacters != 120, "Maximum characters are not the same")
    }
    
//    func testValidation() {
//        let regularExpression = "^[a-zA-Z\\s]{1,17}$"        
//        textField.text = "Rayan Godwin Sequeira"
//        var value = textField.validate(true)
//        XCTAssert(value == false, "Value returned is not right")
//        
//        textField.validationRegExp = regularExpression
//        textField.text = "Rayan Godwin Sequeira"
//        value = textField.validate(true)
//        XCTAssert(value == false, "Value returned is not right")
//        
//        textField.text = "Rayan"
//        value = textField.validate(true)
//        XCTAssert(value == true, "Value returned is not right")
//    }
    
    func testLimitMaxCharacter() {
        let string = "Rayan Godwin Sequeira"
        textField.text = string
        
        var value = textField.limitMaxCharacter(NSMakeRange(0, 21), string: string)
        XCTAssert(value == true, "Value returned is not right")
        
        var maxCharacterCount = 30
        textField.maximumCharacters = maxCharacterCount as NSNumber?
        value = textField.limitMaxCharacter(NSMakeRange(0, 21), string: string)
        XCTAssert(value == true, "Value returned is not right")
        
        maxCharacterCount = 20
        textField.maximumCharacters = maxCharacterCount as NSNumber?
        value = textField.limitMaxCharacter(NSMakeRange(0, 21), string: string)
        XCTAssert(value == false, "Value returned is not right")
        
        value = textField.limitMaxCharacter(NSMakeRange(0, 25), string: string)
        XCTAssert(value == false, "Value returned is not right")
        
        textField.text = nil
        value = textField.limitMaxCharacter(NSMakeRange(0, 25), string: string)
        XCTAssert(value == false, "Value returned is not right")
    }
    
    func testLocalisationExtensions() {
        XCTAssert(textField.IAPlocalizedTitleForPlaceHolder == "", "String returned is not same")
        
        let localisedString = "Please Enter the key"
        textField.IAPlocalizedTitleForPlaceHolder = localisedString
        XCTAssert(textField.IAPlocalizedTitleForPlaceHolder == localisedString, "String returned is not same")
        
        button.setTitle("123", for: UIControl.State())
        XCTAssert(button.IAPlocalizedTitleForNormal == "123", "String returned is not same")
        
        button.IAPlocalizedTitleForNormal = localisedString
        XCTAssert(button.IAPlocalizedTitleForNormal == localisedString, "String returned is not same")
        
        label.text = "12345"
        XCTAssert(label.IAPlocalizedText == "12345", "String returned is not the same")
        label.IAPlocalizedText = localisedString
        XCTAssert(label.IAPlocalizedText == localisedString, "String returned is not the same")
    }
}
