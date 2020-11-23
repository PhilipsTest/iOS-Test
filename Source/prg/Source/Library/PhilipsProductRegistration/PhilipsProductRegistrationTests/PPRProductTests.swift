//
//  PPRProductTests.swift
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

class PPRProductTests: XCTestCase {

   func testWithEmptyInfoObject() {
        let productInfo = PPRProduct(ctn: "", sector: B2C, catalog: CONSUMER)
        XCTAssertTrue(productInfo.isValidDate)
        XCTAssertEqual(productInfo.ctn, "")
        XCTAssertEqual(productInfo.serialNumber,nil)
        XCTAssertEqual(productInfo.purchaseDate, nil)
        XCTAssertFalse(productInfo.isCTNNotNil)
    }
    
    func testIsSame()  {
        let productOne = PPRProduct(ctn: "", sector: B2C, catalog: CONSUMER)
        let productTwo = PPRProduct(ctn: "", sector: B2C, catalog: CONSUMER)
        XCTAssertTrue(productOne.isSameProduct(product: productTwo))
        XCTAssertTrue(productTwo.isSameProduct(product: productOne))
        productTwo.serialNumber = "123"
        XCTAssertFalse(productOne.isSameProduct(product: productTwo))
        productOne.serialNumber = ""
        XCTAssertFalse(productOne.isSameProduct(product: productTwo))
        productOne.serialNumber = nil
        productTwo.serialNumber = nil
        XCTAssertTrue(productOne.isSameProduct(product: productTwo))
        XCTAssertTrue(productTwo.isSameProduct(product: productOne))
        productOne.serialNumber = "456"
        productTwo.serialNumber = "456"
        XCTAssertTrue(productOne.isSameProduct(product: productTwo))
        XCTAssertTrue(productTwo.isSameProduct(product: productOne))
    }
    
    func testWithEmptyString() {
        let productInfo = PPRProductObject.fakeProductWith("", serialNumber: "")
        XCTAssertEqual(productInfo.ctn, "")
        XCTAssertEqual(productInfo.serialNumber,"")
        XCTAssertNotNil(productInfo.purchaseDate)
        XCTAssertFalse(productInfo.isCTNNotNil)
        XCTAssertTrue(productInfo.isValidDate)
    }
    
    func testWithSpaceAtBegining() {
        let productInfo = PPRProductObject.fakeProductWith("  HC5410/83", serialNumber: "  ")
        XCTAssertEqual(productInfo.ctn, "HC5410/83")
        XCTAssertEqual(productInfo.serialNumber,"  ")
        XCTAssertNotNil(productInfo.purchaseDate)
        XCTAssertTrue(productInfo.isCTNNotNil)
        XCTAssertTrue(productInfo.isValidDate)
    }
    
    func testWithSpaceAtEnd() {
        let product = PPRProductObject.fakeProductWith("HC5410/83  ", serialNumber: "  ")
        XCTAssertEqual(product.ctn, "HC5410/83")
        XCTAssertEqual(product.serialNumber,"  ")
        XCTAssertNotNil(product.purchaseDate)
        XCTAssertTrue(product.isCTNNotNil)
        XCTAssertTrue(product.isValidDate)
    }
    
    func testWithSpaceAtMiddle() {
        let product = PPRProductObject.fakeProductWith("HC 5410/83", serialNumber: "  ")
        XCTAssertEqual(product.ctn, "HC 5410/83")
        XCTAssertEqual(product.serialNumber,"  ")
        XCTAssertNotNil(product.purchaseDate)
        XCTAssertTrue(product.isCTNNotNil)
        XCTAssertTrue(product.isValidDate)
    }
    
    func testInvalidPurchaseDateWithLessThan2000() {
        let purchaseDate = self.dateFrom(1999, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        let product = PPRProductObject.fakeProductWith(PPRTestConstants.ctn,
                                                                             serialNumber: PPRTestConstants.serialNum,
                                                                             purchaseDate: purchaseDate!)
        XCTAssertFalse(product.isValidDate)
        XCTAssertEqual(product.ctn, PPRTestConstants.ctn)
        XCTAssertEqual(product.serialNumber, PPRTestConstants.serialNum)
        XCTAssertEqual(product.purchaseDate, purchaseDate)
        XCTAssertTrue(product.isCTNNotNil)
    }
    
    func testInvalidPurchaseDateWithGreaterThanCurrentDate() {
        let purchaseDate = Date().addingTimeInterval(60)
        let product = PPRProductObject.fakeProductWith(PPRTestConstants.ctn,
                                                                             serialNumber: PPRTestConstants.serialNum,
                                                                             purchaseDate: purchaseDate)
        XCTAssertFalse(product.isValidDate)
        XCTAssertEqual(product.ctn, PPRTestConstants.ctn)
        XCTAssertEqual(product.serialNumber, PPRTestConstants.serialNum)
        XCTAssertEqual(product.purchaseDate, purchaseDate)
        XCTAssertTrue(product.isCTNNotNil)
    }
    
    func testValidPurchaseDate() {
        // Creating a random date between 2000/1/1 to currentdate
        let minDate = self.dateFrom(2000, month: 1, day: 1, hour: 0, minute: 0, second: 59)
        let maxDate = Date()
        let timeInterval = uint(maxDate.timeIntervalSince(minDate!))
        let randomInterval = TimeInterval(arc4random_uniform(timeInterval))
        let purchaseDate = minDate?.addingTimeInterval(randomInterval)
        let product = PPRProductObject.fakeProductWith(PPRTestConstants.ctn,
                                                                             serialNumber: PPRTestConstants.serialNum,
                                                                             purchaseDate: purchaseDate)
        //XCTAssertTrue(product.isValidDate)
        XCTAssertEqual(product.ctn, PPRTestConstants.ctn)
        XCTAssertEqual(product.serialNumber, PPRTestConstants.serialNum)
        XCTAssertEqual(product.purchaseDate, purchaseDate)
        XCTAssertTrue(product.isCTNNotNil)
    }
    
    func testGetProductMetadataWithCTNNotEnteredFailure() {
        let product = PPRProduct(ctn: "", sector: B2C, catalog: CONSUMER)
        product.purchaseDate = Date()
        product.serialNumber = PPRTestConstants.serialNum
        let expect = self.expectation(description: "Metadata")
        product.getProductMetaData(success: { (data) in
            XCTFail("Expecting to get failure callback")
            expect.fulfill()
        }) { (error) in
            XCTAssert(error!.code == PPRError.CTN_NOT_ENTERED.rawValue)
            expect.fulfill()
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetProductMetadataError() {
        let mockRequestWrapper = PRXRequestManagerMock()
        mockRequestWrapper.error = PPRErrorHelper().createCustomError(error: .CTN_NOT_EXIST)
        let product = PPRProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        product.purchaseDate = Date()
        product.serialNumber = PPRTestConstants.serialNum
        product.requestManager.requestManager = mockRequestWrapper
        let expect = self.expectation(description: "Metadata")
        product.getProductMetaData(success: { (data) in
            XCTFail("Expecting to get failure callback")
            expect.fulfill()
        }) { (error) in
            XCTAssertNotNil(error!)
            expect.fulfill()
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetProductMetadataWithUnkownError() {
        let mockRequestWrapper = PRXRequestManagerMock()
        mockRequestWrapper.error = PPRErrorHelper().createCustomError(domain: "Error", code: 1000, userInfo: [:])
        let product = PPRProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        product.purchaseDate = Date()
        product.serialNumber = PPRTestConstants.serialNum
        product.requestManager.requestManager = mockRequestWrapper
        let expect = self.expectation(description: "Metadata")
        product.getProductMetaData(success: { (data) in
            XCTFail("Expecting to get failure callback")
            expect.fulfill()
        }) { (error) in
            XCTAssert(error!.code == PPRError.UNKNOWN.rawValue)
            expect.fulfill()
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testSameProductTrue() {
        let product = PPRProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        let productOne = PPRProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        XCTAssertTrue(product.isSameProduct(product: productOne))
        let serialNum = "12345"
        product.serialNumber = serialNum
        productOne.serialNumber = serialNum
        XCTAssertTrue(product.isSameProduct(product: productOne))
    }
    
    func testSameProductFalse() {
        let product = PPRProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        let productOne = PPRProduct(ctn: PPRTestConstants.RegistredCtn, sector: B2C, catalog: CONSUMER)
        XCTAssertFalse(product.isSameProduct(product: productOne))
        product.serialNumber = "12345"
        productOne.serialNumber = "1234589"
        XCTAssertFalse(product.isSameProduct(product: productOne))
    }
    
    func testGetProductMetadataSuccess() {
        let mockRequestWrapper = PRXRequestManagerMock()
        let product = PPRProduct(ctn: PPRTestConstants.ctn, sector: B2C, catalog: CONSUMER)
        product.purchaseDate = Date()
        product.serialNumber = PPRTestConstants.serialNum
        product.requestManager.requestManager = mockRequestWrapper
        let expect = self.expectation(description: "Metadata")
        product.getProductMetaData(success: { (data) in
            XCTAssert(true)
            expect.fulfill()
        }) { (error) in
            XCTFail("Expecting to get failure callback")
            expect.fulfill()
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    fileprivate func dateFrom(_ yera: Int,month: Int, day: Int,hour: Int,minute: Int,second: Int) -> Date! {
        var dateComponnets = DateComponents()
        dateComponnets.year = yera
        dateComponnets.month = month
        dateComponnets.day = day
        dateComponnets.hour = hour
        dateComponnets.minute = minute
        dateComponnets.second = second
        return Date().dateWith(dateComponnets)
    }
}
