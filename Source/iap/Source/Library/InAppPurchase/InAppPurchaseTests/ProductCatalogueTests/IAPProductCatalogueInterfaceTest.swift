/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPProductCatalogueInterfaceTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        IAPConfiguration.sharedInstance.locale = "en_US"
        IAPConfiguration.sharedInstance.baseURL = "www.occ.shop.philips.com"
    }
    
    func testInterfaceCreation() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID: "a@b.com")?.withCurrentPage(0).buildInterface()
        var httpInterface = occInterface?.getInterfaceForProductCatalogue(false)
        XCTAssertNil(httpInterface, "interface is not nil")
        httpInterface = occInterface?.getInterfaceForProductCatalogue(true)
        XCTAssertNotNil(httpInterface, "interface is nil")
        
        httpInterface = occInterface?.getInterfaceForFetchAllProducts(false)
        XCTAssertNil(httpInterface, "interface is not nil")
        httpInterface = occInterface?.getInterfaceForFetchAllProducts(true)
        XCTAssertNotNil(httpInterface, "interface is nil")
        
        httpInterface = occInterface?.getInterfaceForFetchInformationForProduct(false)
        XCTAssertNil(httpInterface, "interface is not nil")
        occInterface?.productCode = "HX9042/64"
        httpInterface = occInterface?.getInterfaceForFetchInformationForProduct(true)
        XCTAssertNotNil(httpInterface, "interface is nil")
    }
    
    func testGetProductCatalogueSuccess() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID: "a@b.com")?.withCurrentPage(0).buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPProductSampleResponse"
        
        occInterface?.getProductCatalogue(httpInterface, completionHandler: { (withProducts, paginationDict) in
            XCTAssertNotNil(withProducts, "Get Product Catalogue returned is nil")
        }, failureHandler: { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        })
    }
    
    func testGetProductCatalogueFailure() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID: "a@b.com")?.withCurrentPage(0).buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPProductSampleResponse"
        httpInterface.isErrorToBeInvoked = true
        
        occInterface?.getProductCatalogue(httpInterface, completionHandler: { (withProducts, paginationDict) in
            XCTAssertNotNil(withProducts, "Get Product Catalogue returned is nil")
        }, failureHandler: { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        })
    }
    
    func testGetProductCatalogueForNonHybris() {
        IAPConfiguration.sharedInstance.locale = "en_US"
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID: "a@b.com")?.withCurrentPage(0).buildInterface()
        occInterface?.getProductCatalogue(nil, completionHandler: { (withProducts, paginationDict) in
            XCTAssertNotNil(withProducts, "Get Product Catalogue returned is nil")
        }, failureHandler: { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        })
    }
    
}
