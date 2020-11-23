//
//  AddressFieldValidationTests.swift
//  InAppPurchaseTests
//
//  Created by Prasad Devadiga on 08/02/19.
//  Copyright © 2019 Rakesh R. All rights reserved.
//

import XCTest
@testable import InAppPurchaseDev
import PhilipsUIKitDLS

class AddressFieldValidationTests: XCTestCase {
    var validator: IAPAddressValidator!
    override func setUp() {
        validator = IAPAddressValidator()
    }

    override func tearDown() {
        validator = nil
    }

    func testPhoneNumberValidation() {
        let textField = UIDTextField(frame: .zero)
        textField.text = "0491234"
        validator.showPhoneNumberFieldError(textField, country: "US")
        XCTAssert(textField.isValidationVisible == true)

        textField.text = "(213)999-9999"
        validator.showPhoneNumberFieldError(textField, country: "US")
        XCTAssert(textField.isValidationVisible == false)

        textField.text = "0491234"
        validator.showPhoneNumberFieldError(textField, country: "DE")
        XCTAssert(textField.isValidationVisible == false)

        textField.text = "213"
        validator.showPhoneNumberFieldError(textField, country: "DE")
        XCTAssert(textField.isValidationVisible == true)
    }

    func testshowTextFieldError() {
        let textField = UIDTextField(frame: .zero)
        textField.tag = 1
        textField.text = ""
        validator.showTextFieldError(textField)
        XCTAssert(textField.isValidationVisible == true)
        XCTAssert(textField.validationMessage == IAPLocalizedString("iap_first_name_error"))
    }
}
