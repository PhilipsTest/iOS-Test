//
//  PRXProductSummaryDataInfoDataTests.swift
//  PhilipsProductRegistration
//
//  Created by Abhishek on 25/01/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
import PhilipsPRXClient

@testable import PhilipsProductRegistrationDev

class PRXProductSummaryDataInfoDataTests: XCTestCase {
    
    var summaryDataJsonObject:PPRProductSummaryDataJSONObject?
    var serialContentTests:PRXProductMetadataSerialContentDataTests?
    
    override func setUp() {
        super.setUp()
        summaryDataJsonObject = PPRProductSummaryDataJSONObject()
    }
    
   func testWithEmptyDictionary() {
        let summaryData = PRXSummaryData.modelObject(with: NSDictionary() as! [AnyHashable: Any])
        verifyEmptyData(summaryData!)
    }

    func testWithValidProductInfo() {
        let dictionary = summaryDataJsonObject?.fakeValidSummaryResponse()
        let summaryDataDict = getDatDict(dictionary!)
        let summaryData =  PRXSummaryData.modelObject(with: summaryDataDict as! [AnyHashable: Any])
        verifyValidData(summaryData!)
    }

    func testWithValidKeysWithDifferentValues() {
        let dictionary = summaryDataJsonObject?.fakeValidStructureWithDifferenValues()
        let summaryDataDict = getDatDict(dictionary!)
        let summaryData =  PRXSummaryData.modelObject(with: summaryDataDict as! [AnyHashable: Any])
        verifyInValidData(summaryData!)
    }

    func verifyEmptyData(_ summaryData:PRXSummaryData){
        XCTAssertNil(summaryData.productStatus)
        XCTAssertFalse(summaryData.isDeleted)
        XCTAssertNil(summaryData.leafletUrl)
        XCTAssertNil(summaryData.familyName)
        XCTAssertNil(summaryData.alphanumeric)
        XCTAssertNil(summaryData.productPagePath)
        XCTAssertNil(summaryData.descriptor)
        //XCTAssertNil(summaryData.brand)
        XCTAssertNil(summaryData.ctn)
        XCTAssertNil(summaryData.productTitle)
        XCTAssertNil(summaryData.subWOW)
        XCTAssertNil(summaryData.locale)
        XCTAssertNil(summaryData.imageURL)
        XCTAssertNil(summaryData.brandName)
        XCTAssertNil(summaryData.domain)
        //XCTAssertEqual(summaryData.priority == 0)
        XCTAssertNil(summaryData.subcategory)
        XCTAssertNil(summaryData.productURL)
        XCTAssertNil(summaryData.versions)
        XCTAssertNil(summaryData.sop)
        XCTAssertNil(summaryData.careSop)
        XCTAssertNil(summaryData.marketingTextHeader)
        XCTAssertNil(summaryData.somp)
        XCTAssertNil(summaryData.eop)
        XCTAssertNil(summaryData.dtn)
        //XCTAssertNil(summaryData.price)
        XCTAssertNil(summaryData.filterKeys)
    }
    
    func verifyValidData(_ summaryData:PRXSummaryData){
        XCTAssertEqual(summaryData.productStatus, "NORMAL")
        XCTAssertFalse(summaryData.isDeleted)
        XCTAssertEqual(summaryData.leafletUrl, "https://www.download.p4c.philips.com/files/h/hd7546_20/hd7546_20_pss_nldnl.pdf")
        XCTAssertEqual(summaryData.familyName, "Café Gaia")
        XCTAssertEqual(summaryData.alphanumeric, "HD7546/20")
        XCTAssertEqual(summaryData.productPagePath, "/content/B2C/nl_NL/product-catalog/HD7546_20")
        XCTAssertEqual(summaryData.descriptor, "Koffiezetapparaat")
        //XCTAssertEqual(summaryData.brand == 36)
        XCTAssertEqual(summaryData.ctn, "HD7546/20")
        XCTAssertEqual(summaryData.productTitle, "Café Gaia Koffiezetapparaat")
        XCTAssertEqual(summaryData.subWOW, "Thermische kan houdt koffie meer dan 2 uur warm*")
        XCTAssertEqual(summaryData.locale, "nl_NL")
        XCTAssertEqual(summaryData.imageURL, "http://images.philips.com/is/image/PhilipsConsumer/HD7546_20-IMS-nl_NL")
        XCTAssertEqual(summaryData.brandName, "Philips")
        XCTAssertEqual(summaryData.domain, "http://www.philips.nl")
        XCTAssertEqual(summaryData.priority, 701605)
        XCTAssertEqual(summaryData.subcategory, "DRIP_FILTER_COFFEE_MACHINES_SU")
        XCTAssertEqual(summaryData.productURL, "/c-p/HD7546_20/cafe-gaia-koffiezetapparaat")
        //XCTAssertEqual(summaryData.versions, )
        XCTAssertEqual(summaryData.sop, "2014-08-18T00:00:00.000+02:00")
        XCTAssertEqual(summaryData.careSop, "2007-03-09T00:00:00.000+01:00")
        XCTAssertEqual(summaryData.marketingTextHeader, "Het Café Gaia-koffiezetapparaat zet uitstekende koffie en heeft een iconisch design. De thermische kan houdt het volledige aroma en de temperatuur ruim 2 uur* vast.")
        XCTAssertEqual(summaryData.somp, "2014-08-18T00:00:00.000+02:00")
        XCTAssertEqual(summaryData.eop, "2020-12-31T00:00:00.000+01:00")
        XCTAssertEqual(summaryData.dtn, "HD7546/20")
        //XCTAssertEqual(summaryData.price == 36)
        //XCTAssertEqual(summaryData.filterKeys == 36)
    }
    
    func verifyInValidData(_ summaryData:PRXSummaryData){
        XCTAssertEqual(summaryData.productStatus, "NORMAL")
        XCTAssertFalse(summaryData.isDeleted)
        XCTAssertEqual(summaryData.leafletUrl, "https://www.download.p4c.philips.com/files/h/hd7546_20/hd7546_20_pss_nldnl.pdf")
        XCTAssertEqual(summaryData.familyName, "Café Gaia")
        XCTAssertEqual(summaryData.alphanumeric, "HD7546/20")
        XCTAssertEqual(summaryData.productPagePath, "/content/B2C/nl_NL/product-catalog/HD7546_20")
        XCTAssertEqual(summaryData.descriptor, "Koffiezetapparaat")
        //XCTAssertEqual(summaryData.brand == 36)
        XCTAssertEqual(summaryData.ctn, "HD7546/20")
        XCTAssertEqual(summaryData.productTitle, "Café Gaia Koffiezetapparaat")
        XCTAssertEqual(summaryData.subWOW, "Thermische kan houdt koffie meer dan 2 uur warm*")
        XCTAssertEqual(summaryData.locale, "nl_NL")
        XCTAssertEqual(summaryData.imageURL, "http://images.philips.com/is/image/PhilipsConsumer/HD7546_20-IMS-nl_NL")
        XCTAssertEqual(summaryData.brandName, "Philips")
        XCTAssertEqual(summaryData.domain, "http://www.philips.nl")
        XCTAssertEqual(summaryData.priority, 701605)
        XCTAssertEqual(summaryData.subcategory, "DRIP_FILTER_COFFEE_MACHINES_SU")
        XCTAssertEqual(summaryData.productURL, "/c-p/HD7546_20/cafe-gaia-koffiezetapparaat")
        //XCTAssertEqual(summaryData.versions, )
        XCTAssertEqual(summaryData.sop, "2014-08-18T00:00:00.000+02:00")
        XCTAssertEqual(summaryData.careSop, "2007-03-09T00:00:00.000+01:00")
        XCTAssertEqual(summaryData.marketingTextHeader, "Het Café Gaia-koffiezetapparaat zet uitstekende koffie en heeft een iconisch design. De thermische kan houdt het volledige aroma en de temperatuur ruim 2 uur* vast.")
        XCTAssertEqual(summaryData.somp, "2014-08-18T00:00:00.000+02:00")
        XCTAssertEqual(summaryData.eop, "2020-12-31T00:00:00.000+01:00")
        XCTAssertEqual(summaryData.dtn, "HD7546/20")
        //XCTAssertEqual(summaryData.price == 36)
        //XCTAssertEqual(summaryData.filterKeys == 36)
    }
    
    fileprivate func getDatDict(_ dict:NSDictionary)->NSDictionary {
        return dict["data"] as! NSDictionary
    }
    
}
