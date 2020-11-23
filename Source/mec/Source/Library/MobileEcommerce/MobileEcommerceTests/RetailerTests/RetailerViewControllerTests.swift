/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import PhilipsEcommerceSDK

@testable import MobileEcommerceDev

class RetailerViewControllerTests: XCTestCase {

    var sut: MECProductRetailersViewController?
    var mockTagger: MECMockTagger?
    
    override func setUp() {
        super.setUp()
        sut = MECProductRetailersViewController.instantiateFromAppStoryboard(appStoryboard: .productRetailers)
        
        let appinfra = MockAppInfra()
        mockTagger = MECMockTagger()
        appinfra.tagging = mockTagger
        MECConfiguration.shared.sharedAppInfra = appinfra
        MECConfiguration.shared.mecTagging = mockTagger
    }

    override func tearDown() {
        sut = nil
        MECConfiguration.shared.sharedAppInfra = nil
        MECConfiguration.shared.mecTagging = nil
        super.tearDown()
    }

    func testTrackRetailer() {
        
        let retailer1 = ECSRetailer()
        retailer1.name = "Retailer1"
        retailer1.availability = "YES"
        
        let retailer2 = ECSRetailer()
        retailer2.name = "Retailer2"
        retailer2.availability = "NO"
        
        let retailer3 = ECSRetailer()
        retailer3.name = "Retailer3"
        retailer3.availability = "YES"
        
        sut?.product = MECProduct(product: ECSPILProduct())
        sut?.fetchedRetailers = [retailer1, retailer2, retailer3]
        _ = sut?.view
        sut?.viewDidLoad()
        
        XCTAssertEqual(mockTagger?.inParamDict?[MECAnalyticsConstants.retailerList] as? String, "Retailer1|Retailer2|Retailer3")
    }
    
    func testTrackRetailerNameNil() {
        
        let retailer1 = ECSRetailer()
        retailer1.name = "Retailer1"
        retailer1.availability = "YES"
        
        let retailer2 = ECSRetailer()
        retailer2.name = nil
        retailer2.availability = "NO"
        
        let retailer3 = ECSRetailer()
        retailer3.name = "Retailer3"
        retailer3.availability = "YES"
        sut?.product = MECProduct(product: ECSPILProduct())
        sut?.fetchedRetailers = [retailer1, retailer2, retailer3]
        _ = sut?.view
        sut?.viewDidLoad()
        
        XCTAssertEqual(mockTagger?.inParamDict?[MECAnalyticsConstants.retailerList] as? String, "Retailer1||Retailer3")
    }

}
