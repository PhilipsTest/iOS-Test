/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import XCTest
import AppInfra
@testable import InAppPurchaseDev

class IAPRetailerInterfaceTests : XCTestCase {
    
    override class func setUp() {
        super.setUp()
        Bundle.loadSwizzler()
        let appInfra = AIAppInfra(builder: nil)
        IAPConfiguration.setIAPConfiguration("en_US", inAppInfra: appInfra!)
    }
    
    override class func tearDown() {
        super.tearDown()
        Bundle.deSwizzle()
    }
    
    func testInterfaceCreation(){
        
        
        let retInterface = IAPRetailerInterface(inProductCode: "HX8071/10", inLocale: "en_US")
        let httpInterface = retInterface.getInterfaceForRetailers()
        
        XCTAssertNotNil(httpInterface,"Interface created is nil")
    }
    
    func testGetRetailersSuccess() {
        let retInterface = IAPRetailerInterface(inProductCode: "HX8071/10", inLocale: "en_US")
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPRetailerSampleResponse"
        
        retInterface.getRetailersInfoForProduct(httpInterface, completionHandler: { (withRetailers) in
            XCTAssertNotNil(withRetailers, "Get Retailers returned nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testGetRetailersFailure() {
     
     
        let retInterface = IAPRetailerInterface(inProductCode: "HX8071/10", inLocale: "en_US")
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPRetailerSampleResponse"
        httpInterface.isErrorToBeInvoked = true
        
        retInterface.getRetailersInfoForProduct(httpInterface, completionHandler: { (withRetailers) in
            XCTAssertNotNil(withRetailers, "Get Retailers returned nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
}

