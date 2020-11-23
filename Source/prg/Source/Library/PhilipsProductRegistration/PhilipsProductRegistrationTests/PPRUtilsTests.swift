//
//  PPRUtilsTests.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import XCTest
import PhilipsPRXClient
import PhilipsRegistration

@testable import PhilipsProductRegistrationDev

class PPRUtilsTests: XCTestCase{
   
   func testObjectOrNSNull() {
        let product = PPRProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        XCTAssertNotNil(PPRUtils.objectOrNSNull(object: product))
    }

    func testIsObjectDictionary() {
        let dictionaryObject:NSDictionary = ["Data" : "XYZ"]
        XCTAssertTrue(PPRUtils.isDictionary(dictionary: dictionaryObject))
    }

    func testIsObjectArray() {
        let arrayObject:NSArray = ["Data", "Data1"]
        XCTAssertTrue(PPRUtils.isArray(array: arrayObject))
    }

    func testScaleImage() {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 100.0, height: 100.0), false, 0)
        let color = UIColor.red
        color.setFill()
        UIRectFill(CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let productScaleImage = PPRUtils.scaleImage(with: image!, scaledToFill: CGSize(width: 20.0, height: 20.0))
        XCTAssertNotNil(productScaleImage)
    }

    func testRegisterdProduct() {
        let aProduct = PPRProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        let regProducts = PPRUtils.converProductsToRegisteredProducts(products: [aProduct], uuid: nil)
        XCTAssertNotNil(regProducts)
    }
}
