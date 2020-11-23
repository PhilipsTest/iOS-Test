/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPPurchaseHistoryInterfaceTest: XCTestCase {
    
    func testInterfaceCreation() {
        let occInterface = IAPOCCAddressInterfaceBuilder(inUserID: "a@b.com")!.withPurchaseHistoryCurrentPage(0).buildPurchaseHistoryInterface()
        
        let httpInterface = occInterface.getInterfaceForPurchaseHistoryOverview()
        XCTAssertNotNil(occInterface,"OCC Address interface created is nil")
        XCTAssertNotNil(httpInterface,"Http Interface returned is nil for default address")
    }
    
    func testInterfaceCreationForPurchaseHistoryOverview() {
        let occInterface = IAPOCCAddressInterfaceBuilder(inUserID: "a@b.com")!.withPurchaseHistoryCurrentPage(0).buildPurchaseHistoryInterface()
        let dictionary   = self.deserializeData("IAPOrderOverView")
        let orders = IAPPurchaseHistoryCollection(inDictionary: dictionary!)
        let ordersDataArray = (orders?.collection)!
        occInterface.purchaseHistory = ordersDataArray.first
        let httpInterface = occInterface.getInterfaceForPurchaseHistoryOrderDetails()
        XCTAssertNotNil(httpInterface,"Http Interface returned is nil for set address")
    }
    
    func testPurchaseHistoryDetailsSuccess() {
        let dictionary   = self.deserializeData("IAPOrderOverView")
        let orders = IAPPurchaseHistoryCollection(inDictionary: dictionary!)
        let ordersDataArray = (orders?.collection)!
        let firstObject = ordersDataArray.first!
        
        let occInterface = IAPOCCAddressInterfaceBuilder(inUserID: "a@b.com")!.withPurchaseHistoryCurrentPage(0).withPurchaseHistory(firstObject).buildPurchaseHistoryInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPGetOrderDetailResponse"
        
        occInterface.getPurchaseHistoryOrderDetails(httpInterface, completionHandler : { (withDetails) in
            XCTAssertNotNil(withDetails, "Details returned is nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
        
        let trackingID = firstObject.getOrderTrackingId()
        XCTAssertNotNil(trackingID, "Tracking ID is not returned")
        
        let object = IAPPurchaseHistoryModel(inDictionary: [String: AnyObject]())
        XCTAssertNil(object,"Object is initialised despite empty dictionary")
        
        let lastObject = ordersDataArray.last!
        XCTAssertNotEqual(firstObject, lastObject)
    }
    
    func testPurchaseHistoryDetailsFailure() {
        let occInterface = IAPOCCAddressInterfaceBuilder(inUserID: "a@b.com")!.withPurchaseHistoryCurrentPage(0).buildPurchaseHistoryInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPGetOrderDetailResponse"
        httpInterface.isErrorToBeInvoked = true

        occInterface.getPurchaseHistoryOrderDetails(httpInterface, completionHandler : { (withDetails) in
            XCTAssertNotNil(withDetails, "Details returned is nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testPurchaseHistoryOverviewSuccess() {
        let occInterface = IAPOCCAddressInterfaceBuilder(inUserID: "a@b.com")!.withPurchaseHistoryCurrentPage(0).buildPurchaseHistoryInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPGetOrdersResponse"
        
        occInterface.getPurchaseHistoryOverview(httpInterface, completionHandler: { (withOrders, paginationDict) in
            XCTAssertNotNil(withOrders, "Default Address returned is nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
        
    }
    
    func testPurchaseHistoryOverviewFailure() {
        let occInterface = IAPOCCAddressInterfaceBuilder(inUserID: "a@b.com")!.withPurchaseHistoryCurrentPage(0).buildPurchaseHistoryInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPGetOrdersResponse"
        httpInterface.isErrorToBeInvoked = true
        
        occInterface.getPurchaseHistoryOverview(httpInterface, completionHandler: { (withOrders, paginationDict) in
            XCTAssertNotNil(withOrders, "Default Address returned is nil")
        }) { (inError: NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
}
