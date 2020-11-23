//
//  IAPPurchaseHistoryProductCellTests.swift
//  InAppPurchaseTests
//
//  Created by Prasad on 25/04/19.
//  Copyright © 2019 Rakesh R. All rights reserved.
//

import XCTest
@testable import InAppPurchaseDev

class MockTrackOrderDelegate: NSObject, IAPOrderTrackingProtocol {
    var trackingOrderMethodCalled = false
    func didSelectTrackOrder(trackingURL: String) {
        trackingOrderMethodCalled = true
    }
}

class IAPPurchaseHistoryProductCellTests: XCTestCase {

    var productCell: IAPPurchaseHistoryProductCell?
    var mockDelegate = MockTrackOrderDelegate()
    
    override func setUp() {
        super.setUp()
        productCell = IAPPurchaseHistoryProductCell(frame: .zero)
        productCell?.orderTrackDelegate = mockDelegate
    }

    func testTrackOrderButtonTapped() {
        productCell?.orderTrackingURL = "www.test.com"
        productCell?.trackOrderButtonTapped(self)
        XCTAssertTrue(mockDelegate.trackingOrderMethodCalled)
    }
    override func tearDown() {
        productCell?.orderTrackDelegate = nil
        super.tearDown()
    }
}
