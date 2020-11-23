/* Copyright (c) Koninklijke Philips N.V., 2016 */

import XCTest

class InAppPurchaseUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
       
    func testAUserIsLoggedIn() {
        
        let app = XCUIApplication()
        app.buttons["iap_demoScreen_register_button"].tap()
        
        if (app.scrollViews.otherElements.buttons["Continue"].exists) {
            
            app.scrollViews.otherElements.buttons["Continue"].tap()
        }else {
                        
            app.buttons["usr_startscreen_country_button"].tap()
            let tablesQuery = app.tables
            tablesQuery.staticTexts["United States"].tap()
            app.buttons["usr_startscreen_login_button"].tap()
            
            let signinEmailTextField = app.textFields["usr_loginScreen_email_textField"]
            signinEmailTextField.typeText("chittaranjan.sahu@philips.com")
            
            let usrLoginscreenPasswordTextfieldSecureTextField = app.scrollViews.otherElements.secureTextFields["usr_loginScreen_password_textField"]
            usrLoginscreenPasswordTextfieldSecureTextField.tap()
            usrLoginscreenPasswordTextfieldSecureTextField.typeText("sahusahu")
            
            app.buttons["usr_loginScreen_login_button"].tap()
            
            let elementsQuery = XCUIApplication().scrollViews.otherElements
            let termsCheckBox = elementsQuery.otherElements["usr_almostDoneScreen_termsAndConditions_checkBox"]
            if (termsCheckBox.exists) {
                termsCheckBox.tap()
            }
            app.scrollViews.otherElements.buttons["Continue"].tap()
            app.scrollViews.otherElements.buttons["Continue"].tap()
        }
        XCTAssert(app.buttons["iap_demoScreen_add_button"].exists, "Demo app screen is not launched after log in")
    }
    
    func testNoProductFoundInProductCatalogue() {
        
        let app = XCUIApplication()
        let iapDemoscreenCtnTextfieldTextField = app.textFields["iap_demoScreen_ctn_textField"]
        iapDemoscreenCtnTextfieldTextField.tap()
        iapDemoscreenCtnTextfieldTextField.typeText("HX0000/64")
        app.buttons["iap_demoScreen_add_button"].tap()
        app.buttons["iap_demoScreen_shopNowCategorized_button"].tap()
        let noProductLabel = app.staticTexts["No product found in your Store."]
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: noProductLabel, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(noProductLabel.exists, "No product found message should be displayed")
    }
    
    func testNoProductFoundInProductDetail() {
        
        let app = XCUIApplication()
        let iapDemoscreenCtnTextfieldTextField = app.textFields["iap_demoScreen_ctn_textField"]
        iapDemoscreenCtnTextfieldTextField.tap()
        iapDemoscreenCtnTextfieldTextField.typeText("HX0000/64")
        app.buttons["iap_demoScreen_add_button"].tap()
        app.buttons["iap_demoScreen_productDetail_button"].tap()
        let noProductLabel = app.staticTexts["No product found in your Store."]
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: noProductLabel, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(noProductLabel.exists, "No product found message should be displayed")
    }
    
    func testProductDetailLaunching() {
        
        let app = XCUIApplication()
        let demopageEnterctnTextField = app.textFields["iap_demoScreen_ctn_textField"]
        demopageEnterctnTextField.tap()
        demopageEnterctnTextField.typeText("HX9042/64")
        app.buttons["iap_demoScreen_add_button"].tap()
        app.buttons["iap_demoScreen_productDetail_button"].tap()
        XCTAssertEqual(app.navigationBars.element.identifier, "Product details")
    }
    
    func testHappyFlowOfDLS() {
        
        let app = XCUIApplication()
        let demopageEnterctnTextField = app.textFields["iap_demoScreen_ctn_textField"]
        demopageEnterctnTextField.tap()
        demopageEnterctnTextField.typeText("")
        demopageEnterctnTextField.typeText("HX9042/64")
        app.buttons["iap_demoScreen_add_button"].tap()
        app.buttons["iap_demoScreen_shopNowCategorized_button"].tap()
        XCTAssertEqual(app.navigationBars.element.identifier, "Products")
        
        XCTAssertTrue(app.tables.element.exists, "Product list table does not exist")
        app.tables.staticTexts["Sonicare AdaptiveClean Standard sonic toothbrush heads"].tap()
        XCTAssertEqual(app.navigationBars.element.identifier, "Product details")
        app.buttons["iap_productDetailScreen_buyFromRetailer_button"].tap()
        
        //check retailer list screen appears
        let retailerNavLabel = app.staticTexts["Select retailer"]
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: retailerNavLabel, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(app.navigationBars.element.identifier, "Select retailer")
        
        //check retailer table exists
        XCTAssertTrue(app.tables.element.exists, "Retailer list table does not exist")
        
        //checking first cell row contains Philips online shop
        let cell = app.tables.element.cells.element(boundBy: 0)
        XCTAssertTrue(cell.exists)
        let indexedText = cell.staticTexts.element
        XCTAssertTrue(indexedText.exists, "cell text is not present")
        XCTAssertTrue(app.tables.staticTexts["Philips Online Shop - US"].exists, "Philips online shop -US does not exist")
        
        //check retailer webview
        app.tables.staticTexts["Philips Online Shop - US"].tap()
        let retailerWebViewNavLabel = app.staticTexts["Philips Online Shop - US"]
        expectation(for: exists, evaluatedWith: retailerWebViewNavLabel, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(app.navigationBars.element.identifier, "Philips Online Shop - US")
    }
    
}
