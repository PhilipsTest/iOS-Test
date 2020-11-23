//
//  UILocalizationTests.swift
//  MyAccountTests
//
//  Created by leslie on 22/11/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
@testable import MyAccountDev

class UILocalizationTests: XCTestCase {
    
   func testLabel() {
        let localized = MYALocalizable(key: "MYA_My_account")
        let label = UILabel()
        label.setValue("MYA_My_account", forKeyPath: "myaText")
        XCTAssertEqual(label.text, localized)
        XCTAssertEqual(label.myaText, localized)
    }
    
    func testButton() {
        let localized = MYALocalizable(key: "MYA_My_account")
        let button = UIButton()
        button.setValue("MYA_My_account", forKeyPath: "myaText")
        XCTAssertEqual(button.title(for: .normal), localized)
        XCTAssertEqual(button.myaText, localized)
    }
    
    func testTextField() {
        let localized = MYALocalizable(key: "MYA_My_account")
        let textField = UITextField()
        textField.setValue("MYA_My_account", forKeyPath: "myaText")
        XCTAssertEqual(textField.text, localized)
        XCTAssertEqual(textField.myaText, localized)
    }
    
    func testPlaceholder() {
        let localized = MYALocalizable(key: "MYA_My_account")
        let textField = UITextField()
        textField.setValue("MYA_My_account", forKeyPath: "myaPlaceholderText")
        XCTAssertEqual(textField.placeholder, localized)
        XCTAssertEqual(textField.myaPlaceholderText, localized)
    }
}
