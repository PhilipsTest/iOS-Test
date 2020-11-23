//
//  PRXRegisterProductInfoDataTests.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import XCTest
@testable import PhilipsProductRegistrationDev

class PRXRegisterProductInfoDataTests: XCTestCase {

    var registerProductJSONObject:PPRRegisterProductJSONObject?
    
    override func setUp() {
        super.setUp()
        registerProductJSONObject = PPRRegisterProductJSONObject()
    }
    
    func testWithEmptyDictionary() {
        let productInfo = PRXRegisterProductInfoData.modelObjectWithDictionary(NSDictionary())
        verifyEmptyData(productInfo)
    }
    
    /*func testWithValidProductInfo() {
        let dictionary = registerProductJSONObject?.fakeValidResponse()
        let dataDictionary = dictionary!["data"] as! NSDictionary
        let productInfo = PRXRegisterProductInfoData.modelObjectWithDictionary(dataDictionary)
        verifyValidData(productInfo)
    }
    
    func testWithValidKeysWithDifferentValues() {
        let dictionary = registerProductJSONObject?.fakeValidStructureWithDifferenValues()
        let dataDictionary = dictionary!["data"] as! NSDictionary
        let productInfo = PRXRegisterProductInfoData.modelObjectWithDictionary(dataDictionary)
        verifyInValidData(productInfo)
    }*/
    
    func verifyEmptyData(_ productInfo:PRXRegisterProductInfoData){
        XCTAssertNil(productInfo.contractNumber)
        XCTAssertNil(productInfo.dateOfPurchase)
        XCTAssertNil(productInfo.emailStatus)
        XCTAssertFalse(productInfo.extendedWarranty)
        XCTAssertFalse(productInfo.isConnectedDevice)
        XCTAssertNil(productInfo.modelNumber)
        XCTAssertNil(productInfo.productRegistrationID)
        XCTAssertNil(productInfo.productRegistrationUuid)
        XCTAssertNil(productInfo.registrationDate)
        XCTAssertNil(productInfo.warrantyEndDate)
        XCTAssertNotNil(productInfo.description)
    }
    
    func verifyValidData(_ productInfo:PRXRegisterProductInfoData){
        XCTAssertEqual(productInfo.contractNumber, "CQ5B00lt3")
//        TODO: Need to check short "yyyy-MM-dd" is giving Time(00:00:00 +000)
        XCTAssertEqual(productInfo.dateOfPurchase?.description, "2016-02-15 00:00:00 +0000")
        XCTAssertEqual(productInfo.emailStatus,"success")
        XCTAssertTrue(productInfo.extendedWarranty)
        XCTAssertFalse(productInfo.isConnectedDevice)
        XCTAssertEqual(productInfo.modelNumber,"HD8969/09")
        XCTAssertEqual(productInfo.productRegistrationID,
            "CQ-28333599-2e61-4b5d-9822-133a28bd83f1HD8969/091455606043477")
        XCTAssertEqual(productInfo.productRegistrationUuid,"3f4ed7d5-a584-4cb7-b890-8c4f0c0ded84")
        XCTAssertEqual(productInfo.registrationDate?.description,"2016-02-16 00:00:00 +0000")
        XCTAssertEqual(productInfo.warrantyEndDate?.description,"2019-02-15 00:00:00 +0000")
        XCTAssertNotNil(productInfo.description)
    }
    
    func verifyInValidData(_ productInfo:PRXRegisterProductInfoData){
        XCTAssertEqual(productInfo.contractNumber, "CQ5B00lt3")
        XCTAssertEqual(productInfo.dateOfPurchase?.description, "2016-02-15 00:00:00 +0000")
        XCTAssertEqual(productInfo.emailStatus,"success")
        XCTAssertTrue(productInfo.extendedWarranty)
        XCTAssertFalse(productInfo.isConnectedDevice)
        XCTAssertEqual(productInfo.modelNumber,"HD8969/09")
        XCTAssertEqual(productInfo.productRegistrationID,
            "CQ-28333599-2e61-4b5d-9822-133a28bd83f1HD8969/091455606043477")
        XCTAssertEqual(productInfo.productRegistrationUuid,"3f4ed7d5-a584-4cb7-b890-8c4f0c0ded84")
        XCTAssertEqual(productInfo.registrationDate?.description,"2016-02-16 00:00:00 +0000")
        XCTAssertEqual(productInfo.warrantyEndDate?.description,"2019-02-15 00:00:00 +0000")
        XCTAssertNotNil(productInfo.description)
    }    
}
