//
//  PRXProductMetaDataInfoDataTests.swift
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

class PRXProductMetaDataInfoDataTests: XCTestCase {

    var metaDataJsonObject:PPRProductMetaDataJSONObject?
    var serialContentTests:PRXProductMetadataSerialContentDataTests?
    
    override func setUp() {
        super.setUp()
        metaDataJsonObject = PPRProductMetaDataJSONObject()
        serialContentTests = PRXProductMetadataSerialContentDataTests()
    }
    
   func testWithEmptyDictionary() {
        let metaData = PRXProductMetaDataInfoData.modelObjectWithDictionary(dict: NSDictionary())
        verifyEmptyData(metaData)
    }
    
    
    func testWithValidProductInfo() {
        let dictionary = metaDataJsonObject?.fakeValidResponse(with: true, isSerialNumberRequired: true)
        let metaDataDict = getDatDict(dictionary!)
        let metaData =  PRXProductMetaDataInfoData.modelObjectWithDictionary(dict: metaDataDict)
        verifyValidData(metaData)
    }
    
    
    func testWithValidKeysWithDifferentValues() {
        let dictionary = metaDataJsonObject?.fakeValidStructureWithDifferenValues()
        let metaDataDict = getDatDict(dictionary!)
        let metaData =  PRXProductMetaDataInfoData.modelObjectWithDictionary(dict: metaDataDict)
        verifyInValidData(metaData)
    }
    
    func verifyEmptyData(_ metaData:PRXProductMetaDataInfoData){
        XCTAssertFalse(metaData.isConnectedDevice)
        XCTAssertTrue(metaData.extendedWarrantyMonths == 0)
        XCTAssertNil(metaData.serialNumberFormat)
        XCTAssertNil(metaData.ctn)
        XCTAssertFalse(metaData.hasGiftPack)
        XCTAssertFalse(metaData.isLicensekeyRequired)
        XCTAssertFalse(metaData.isRequiresSerialNumber)
        XCTAssertNil(metaData.message)
        XCTAssertNotNil(metaData.description)
        XCTAssertFalse(metaData.isRequiresDateOfPurchase)
        XCTAssertFalse(metaData.hasExtendedWarranty)
        XCTAssertNil(metaData.serialNumberData)
    }
    
    func verifyValidData(_ metaData:PRXProductMetaDataInfoData){
        XCTAssertFalse(metaData.isConnectedDevice)
        XCTAssertTrue(metaData.extendedWarrantyMonths == 36)
        XCTAssertEqual(metaData.ctn, "HD8967/01")
        XCTAssertFalse(metaData.hasGiftPack)
        XCTAssertFalse(metaData.isLicensekeyRequired)
        XCTAssertTrue(metaData.isRequiresSerialNumber)
        XCTAssertEqual(metaData.message,"Als u uw product binnen drie maanden na de aankoopdatum registreert, komt u in aanmerking voor uitgebreide garantie.<br><br>Controleer of de aankoopdatum en het serienummer correct zijn ingevuld.<br><br>Om het serienummer te vinden, raadpleegt u de tekst naast het veld voor het invoeren van het serienummer.<br><br>Houd er rekening mee dat u het aankoopbewijs bij de hand moet hebben voor het geval u uw garantie moet activeren. Daarom bieden we u bij de productregistratie de mogelijkheid om het aankoopbewijs te uploaden.")
        XCTAssertEqual(metaData.serialNumberFormat, "^[0-9a-zA-Z]{14}$")
        XCTAssertNotNil(metaData.description)
        XCTAssertTrue(metaData.isRequiresDateOfPurchase)
        XCTAssertTrue(metaData.hasExtendedWarranty)
        XCTAssertNotNil(metaData.serialNumberData)
        XCTAssertNotNil(metaData.description)
        serialContentTests?.verifyValidData(metaData.serialNumberData!)
    }
    
    func verifyInValidData(_ metaData:PRXProductMetaDataInfoData){
        XCTAssertFalse(metaData.isConnectedDevice)
        XCTAssertTrue(metaData.extendedWarrantyMonths == 39)
        XCTAssertNil(metaData.serialNumberFormat)
        XCTAssertEqual(metaData.ctn, "HD8967/01")
        XCTAssertFalse(metaData.hasGiftPack)
        XCTAssertFalse(metaData.isLicensekeyRequired)
        XCTAssertTrue(metaData.isRequiresSerialNumber)
        XCTAssertEqual(metaData.message, "Als u uw product binnen drie maanden na de aankoopdatum registreert, komt u in aanmerking voor uitgebreide garantie.<br><br>Controleer of de aankoopdatum en het serienummer correct zijn ingevuld.<br><br>Om het serienummer te vinden, raadpleegt u de tekst naast het veld voor het invoeren van het serienummer.<br><br>Houd er rekening mee dat u het aankoopbewijs bij de hand moet hebben voor het geval u uw garantie moet activeren. Daarom bieden we u bij de productregistratie de mogelijkheid om het aankoopbewijs te uploaden.")
        XCTAssertNil(metaData.serialNumberFormat)
        XCTAssertNotNil(metaData.description)
        XCTAssertTrue(metaData.isRequiresDateOfPurchase)
        XCTAssertTrue(metaData.hasExtendedWarranty)
        XCTAssertNotNil(metaData.serialNumberData)
        XCTAssertNotNil(metaData.description)
        serialContentTests?.verifyInValidData(metaData.serialNumberData!)
    }

    fileprivate func getDatDict(_ dict:NSDictionary)->NSDictionary {
        return dict["data"] as! NSDictionary
    }

}
