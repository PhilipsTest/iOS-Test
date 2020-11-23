//
//  PRXProductMetadataSerialContentDataTests.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import XCTest
@testable import PhilipsProductRegistrationDev

class PRXProductMetadataSerialContentDataTests: XCTestCase {

    var metaDataJsonObject:PPRProductMetaDataJSONObject?
    override func setUp() {
        super.setUp()
        metaDataJsonObject = PPRProductMetaDataJSONObject()
    }
    
    func testWithEmptyDictionary() {
        let serialContentData = PRXProductMetadataSerialContentData.modelObjectWithDictionary(dict: NSDictionary())
        verifyEmptyData(serialContentData)
    }

    func testWithValidProductInfo() {
        let dictionary = metaDataJsonObject?.fakeValidResponse(with: true, isSerialNumberRequired: true)
        let serialContentDict = getSerialContentDict(dictionary!)
        let serialContentData = PRXProductMetadataSerialContentData.modelObjectWithDictionary(dict: serialContentDict)
        verifyValidData(serialContentData)
    }
    
    func testWithValidKeysWithDifferentValues() {
        let dictionary = metaDataJsonObject?.fakeValidStructureWithDifferenValues()
        let serialContentDict = getSerialContentDict(dictionary!)
        let serialContentData = PRXProductMetadataSerialContentData.modelObjectWithDictionary(dict: serialContentDict)
        verifyInValidData(serialContentData)
    }
    
    func verifyEmptyData(_ serialContentData:PRXProductMetadataSerialContentData){
        XCTAssertTrue(serialContentData.snExample == nil)
        XCTAssertTrue(serialContentData.title == nil)
        XCTAssertTrue(serialContentData.serialNumberSampleContentDescription == nil)
        XCTAssertTrue(serialContentData.snFormat == nil)
        XCTAssertTrue(serialContentData.asset == nil)
        XCTAssertNotNil(serialContentData.description)
    }
    
    func verifyValidData(_ serialContentData:PRXProductMetadataSerialContentData){
        XCTAssertEqual(serialContentData.title, "Het serienummer vinden")
        XCTAssertEqual(serialContentData.snExample, "voorbeeld: TU901022000001")
        XCTAssertEqual(serialContentData.snFormat, "Het serienummer vindt u op het identificatielabel op uw Philips-apparaat.")
        XCTAssertEqual(serialContentData.asset, "/consumerfiles/assets/img/registerproducts/HD8.jpg")
        XCTAssertEqual(serialContentData.serialNumberSampleContentDescription, "You can find the serial number on inside of the door. The serial number starts with two characters (TU, TV, TW or TX) and is followed by 12 digits.")
        XCTAssertNotNil(serialContentData.description)
    }
    
    func verifyInValidData(_ serialContentData:PRXProductMetadataSerialContentData){
        XCTAssertEqual(serialContentData.title, "Het serienummer vinden")
        XCTAssertTrue(serialContentData.snExample == nil)
        XCTAssertTrue(serialContentData.snFormat == nil)
        XCTAssertEqual(serialContentData.asset, "/consumerfiles/assets/img/registerproducts/HD8.jpg")
        XCTAssertEqual(serialContentData.serialNumberSampleContentDescription, "You can find the serial number on inside of the door. The serial number starts with two characters (TU, TV, TW or TX) and is followed by 12 digits.")
        XCTAssertNotNil(serialContentData.description)
    }

    
    fileprivate func getSerialContentDict(_ dict:NSDictionary)->NSDictionary {
        let dataDictionary = dict["data"] as! NSDictionary
        return dataDictionary["serialNumberSampleContent"] as! NSDictionary
    }
}
