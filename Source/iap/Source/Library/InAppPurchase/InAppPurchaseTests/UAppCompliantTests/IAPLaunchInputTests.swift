/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest

@testable import InAppPurchaseDev

class IAPLaunchInputTests: XCTestCase {
    
    func testInit() {
        let launchInput = IAPLaunchInput()
        XCTAssertNotNil(launchInput,"IAPLaunchInput is not initialized properly")
    }
    
    func testSetIAPFlowForShoppingCart() {
        
        let launchInput = IAPLaunchInput()
        
        let flowInput = IAPFlowInput()
        launchInput!.setIAPFlow(.iapShoppingCartView, withSettings: flowInput)
        
        XCTAssert(launchInput?.getLandingView() == .iapShoppingCartView,"landing view is not set equally")
        XCTAssertNotNil(launchInput?.getProductCTNList(),"ctn list is nil and not initialized properly")
    }
    
    func testSetIAPFlowForProductCatalogue() {
        
        let launchInput = IAPLaunchInput()
        
        let flowInput = IAPFlowInput()
        launchInput!.setIAPFlow(.iapProductCatalogueView, withSettings: flowInput)
        
        XCTAssert(launchInput?.getLandingView() == .iapProductCatalogueView,"landing view is not set equally")
        XCTAssertNil(launchInput?.getProductCTNList(),"ctn list should be nil")
    }
    
    func testSetIAPFlowForPurchaseHistory() {
        
        let launchInput = IAPLaunchInput()
        
        let flowInput = IAPFlowInput()
        launchInput!.setIAPFlow(.iapPurchaseHistoryView, withSettings: flowInput)
        
        XCTAssert(launchInput?.getLandingView() == .iapPurchaseHistoryView,"landing view is not set equally")
        XCTAssertNotNil(launchInput?.getProductCTNList(),"ctn list is nil and not initialized properly")
    }
    
    func testSetIAPFlowForCategorizedView() {
        
        let launchInput = IAPLaunchInput()
        
        let flowInput = IAPFlowInput(inCTNList: ["12345","54321"])
        launchInput!.setIAPFlow(.iapProductCatalogueView, withSettings: flowInput)
        
        XCTAssert(launchInput?.getLandingView() == .iapProductCatalogueView,"landing view is not set equally")
        XCTAssertNotNil(launchInput?.getProductCTNList(),"ctn list is nil and not initialized properly")
    }
    
    func testSetIAPFlowForProductDetailView() {
        
        let launchInput = IAPLaunchInput()
        
        let flowInput = IAPFlowInput(inCTN: "12345")
        launchInput!.setIAPFlow(.iapProductDetailView, withSettings: flowInput)
        
        XCTAssert(launchInput?.getLandingView() == .iapProductDetailView,"landing view is not set equally")
        XCTAssertNotNil(launchInput?.getProductCTNList(),"ctn list is nil and not initialized properly")
    }
    
    func testSetIAPFlowForBuyDirectView() {
        
        let launchInput = IAPLaunchInput()
        
        let flowInput = IAPFlowInput(inCTN: "12345")
        launchInput!.setIAPFlow(.iapBuyDirectView, withSettings: flowInput)
        
        XCTAssert(launchInput?.getLandingView() == .iapBuyDirectView,"landing view is not set equally")
        XCTAssertNotNil(launchInput?.getProductCTNList(),"ctn list is nil and not initialized properly")
    }
}
