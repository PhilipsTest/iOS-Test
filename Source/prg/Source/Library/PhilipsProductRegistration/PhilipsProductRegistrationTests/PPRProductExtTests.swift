//
//  PPRProductExtTests.swift
//  PhilipsProductRegistration
//
//  Created by Abhishek Chatterjee on 02/06/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
import PhilipsPRXClient

@testable import PhilipsProductRegistrationDev

class PPRProductExtTests: XCTestCase {
    
    func testIsproductsSame() {
        let productOne = PPRProductObject.fakeProductWith(PPRTestConstants.ctn, serialNumber: PPRTestConstants.serialNum)
        let productTwo = PPRProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        productTwo.serialNumber = PPRTestConstants.serialNum
        XCTAssertTrue(productOne.isSameProduct(product: productTwo))
    }

    func testRegisteredProduct() {
        let aProduct = PPRProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        let registeredproduct = PPRProduct.registeredProduct(product :aProduct, uuid: PPRTestConstants.uuid)
        XCTAssertNotNil(registeredproduct)
    }
}
