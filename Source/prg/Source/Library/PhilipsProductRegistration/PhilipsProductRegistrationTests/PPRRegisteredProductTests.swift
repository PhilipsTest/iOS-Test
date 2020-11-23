//
//  PPRRegisteredProductTests.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import XCTest
import PhilipsPRXClient
@testable import PhilipsProductRegistrationDev

class PPRRegisteredProductTests: PPRBaseClassTests {

    func testInitialisation() {
        let product = PPRRegisteredProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        XCTAssertNotNil(product)
    }
    
    func testRegisteredProductWithoutSettingError() {
        let product = PPRRegisteredProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        XCTAssertTrue(product.state == .PENDING)
        XCTAssertNil(product.error)
        self.verifyParameters(product)
    }
    
    func testRegisteredProductWithInvalidPurchaseDateError() {
        let product = PPRRegisteredProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        product.error = PPRErrorHelper().createCustomError(error: PPRError.INVALID_PURCHASE_DATE)
        XCTAssertTrue(product.state == .FAILED)
        XCTAssertEqual(product.error?.code, PPRError.INVALID_PURCHASE_DATE.rawValue)
        self.verifyParameters(product)
    }
    
    func testRegisteredProductWithInvalidSerailNumError() {
        let product = PPRRegisteredProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        product.error = PPRErrorHelper().createCustomError(error: PPRError.INVALID_SERIAL_NUMBER)
        XCTAssertTrue(product.state == .FAILED)
        XCTAssertEqual(product.error?.code, PPRError.INVALID_SERIAL_NUMBER.rawValue)
        self.verifyParameters(product)
    }
    
    func testRegisteredProductWithRequiredPurchaseDateError() {
        let product = PPRRegisteredProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        product.error = PPRErrorHelper().createCustomError(error: PPRError.REQUIRED_PURCHASE_DATE)
        XCTAssertTrue(product.state == .FAILED)
        XCTAssertEqual(product.error?.code, PPRError.REQUIRED_PURCHASE_DATE.rawValue)
        self.verifyParameters(product)
    }
    
    func testRegisteredProductWithInvalidSerailNumAndPurchaseDateError() {
        let product = PPRRegisteredProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        product.error = PPRErrorHelper().createCustomError(error: PPRError.INVALID_SERIAL_NUMBER_AND_PURCHASE_DATE)
        XCTAssertTrue(product.state == .FAILED)
        XCTAssertEqual(product.error?.code, PPRError.INVALID_SERIAL_NUMBER_AND_PURCHASE_DATE.rawValue)
        self.verifyParameters(product)
    }
    
    func testRegisteredProductWithNoInternetConnectionError() {
        let product = PPRRegisteredProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        product.error = PPRErrorHelper().createCustomError(domain: "No internetConnection", code: -1009, userInfo: [:])
        XCTAssertTrue(product.state == .FAILED)
        XCTAssertEqual(product.error?.code, PPRError.NO_INTERNET_CONNECTION.rawValue)
        self.verifyParameters(product)
    }
    
    fileprivate func verifyParameters(_ product: PPRRegisteredProduct) {
        XCTAssertEqual(product.ctn, PPRTestConstants.ctn)
        XCTAssertEqual(product.sector, B2C)
        XCTAssertEqual(product.catalog, CONSUMER)
        XCTAssertNil(product.purchaseDate)
        XCTAssertNil(product.serialNumber)
        XCTAssertNil(product.emailStatus)
        XCTAssertNil(product.endWarrantyDate)
        XCTAssertNil(product.purchaseDate)
        XCTAssertNil(product.registeredLocale)
    }

}
            
