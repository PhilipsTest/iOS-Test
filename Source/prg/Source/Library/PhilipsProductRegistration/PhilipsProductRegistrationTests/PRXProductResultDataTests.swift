//
//  PRXProductListDataTest.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//
import XCTest
import Foundation
@testable import PhilipsProductRegistrationDev

class PRXProductResultDataTests:XCTestCase {
    
    var registeredProductListJsonObj: PPRRegisteredProductListJSONObject?
    
    override func setUp() {
        registeredProductListJsonObj = PPRRegisteredProductListJSONObject()
    }
    
    /*func testWithEmptyList() {
        let productList = PRXProductResultData.modelObjectWithDictionary(NSDictionary())
        verifyEmptyData(productList)
    }
    
    func testWithValidProductInfo() {
        let dictionary = registeredProductListJsonObj!.fakeRegisteredProductList()
        let productList = self.getProductResultData(dictionary)
        verifyValidData(productList)
    }
    
    func verifyEmptyData(_ data:PRXProductResultData!){
        XCTAssertNil(data.contractNumber)
        XCTAssertNil(data.created)
        XCTAssertNil(data.deviceId)
        XCTAssertNil(data.deviceName)
        XCTAssertTrue(data.ID==0)
        XCTAssertFalse(data.isGenerations)
        XCTAssertFalse(data.isPrimaryUser)
        XCTAssertFalse(data.isExtendedWarranty)
        XCTAssertNil(data.lastModified)
        XCTAssertNil(data.lastSolicitDate)
        XCTAssertNil(data.lastUpdated)
        XCTAssertNil(data.productID)
        XCTAssertNil(data.productCatalogLocaleId)
        XCTAssertNil(data.productModelNumber)
        XCTAssertNil(data.productRegistrationID)
        XCTAssertNil(data.productSerialNumber)
        XCTAssertNil(data.purchasePlace)
        XCTAssertNil(data.purchaseDate)
        XCTAssertNil(data.registrationChannel)
        XCTAssertNil(data.registrationDate)
        XCTAssertFalse(data.isSlashWinCompetition)
        XCTAssertNil(data.uuid)
        XCTAssertNil(data.warrantyInMonths)
        XCTAssertNotNil(data.description)
    }
    
    func verifyValidData(_ data:PRXProductResultData!){
        XCTAssertEqual(data.contractNumber, nil)
        XCTAssertEqual(data.created, "2014-02-25 21:31:36.161304 +0000")
        XCTAssertEqual(data.deviceId, nil)
        XCTAssertEqual(data.deviceName, "HX8002/05")
        XCTAssertEqual(data.ID, 139136402)
        XCTAssertEqual(data.isGenerations, false)
        XCTAssertEqual(data.isPrimaryUser, true)
        XCTAssertEqual(data.isExtendedWarranty, false)
        XCTAssertEqual(data.lastModified, "2013-12-03")
        XCTAssertEqual(data.lastSolicitDate, nil)
        XCTAssertEqual(data.lastUpdated, "2014-02-25 21:31:36.161304 +0000")
        XCTAssertEqual(data.productID, "HX8002_05_NL_CONSUMER")
        XCTAssertEqual(data.productCatalogLocaleId, "nl_NL_CONSUMER")
        XCTAssertEqual(data.productModelNumber, "HX8002/05")
        XCTAssertEqual(data.productRegistrationID, "2512000064")
        XCTAssertEqual(data.productSerialNumber, PPRTestConstants.RegistredSerialNum)
        XCTAssertEqual(data.purchasePlace, nil)
        XCTAssertEqual(data.purchaseDate?.description, "2013-03-01 00:00:00 +0000")
        XCTAssertEqual(data.registrationChannel, "web")
        XCTAssertEqual(data.registrationDate?.description, "2013-12-03 00:00:00 +0000")
        XCTAssertEqual(data.isSlashWinCompetition, false)
        XCTAssertEqual(data.uuid, "973bd103-6c38-4899-8716-aade4f632cb6")
        XCTAssertEqual(data.warrantyInMonths, nil)
        XCTAssertNotNil(data.description)
    }
    
    fileprivate func getProductResultData(_ dict:NSDictionary) -> PRXProductResultData {
        return (PRXProductListResponse(withDictonary: dict)?.data![0])!
    }*/
}
