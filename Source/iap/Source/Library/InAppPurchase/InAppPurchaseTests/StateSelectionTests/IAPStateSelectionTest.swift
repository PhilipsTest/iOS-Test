/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPStateSelectionTest: XCTestCase {

    var states = [["name": "Karnataka"], ["name": "Goa"], ["name": "Maharashtra"], ["name": "Kolkota"],
                  ["name": "Punjab"], ["name": "Bihar"], ["name": "Telangaana"]]
    var viewController: IAPStatesSelectionViewController!

    override func setUp() {
        super.setUp()

        let inViewcontroller = IAPStatesSelectionViewController.instantiateFromAppStoryboard(appStoryboard: .shippingAddress)
        viewController = inViewcontroller
        viewController.states = self.states as NSArray

    }
    
    func testCountReturned() {
        let tableView = IAPTestAddressTableView()
        tableView.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
        
        let sectionCount = viewController.numberOfSections(in: tableView)
        XCTAssert(sectionCount == 1, "Section count is not right")
        let rowCount = viewController.tableView(tableView, numberOfRowsInSection: 0)
        XCTAssert(rowCount == self.states.count, "Row count returned is not correct")
    }
    
    func testCellCreation() {
        let cell = viewController.tableView(viewController.tableView, cellForRowAt: IndexPath(item: 0, section: 0))
        XCTAssertNotNil(cell, "Cell returned is nil")
    }
    
    func testDelegateSelection() {
        let stateSelectionDelegate = IAPTestStateSelection()
        XCTAssert(stateSelectionDelegate.didSelectStateInvoked == false, "Delegate was invoked")

        viewController.delegate = stateSelectionDelegate
        viewController.tableView(viewController.tableView, didSelectRowAt: IndexPath(item: 0, section: 0))
        XCTAssert(stateSelectionDelegate.didSelectStateInvoked == true, "Delegate was not invoked")
    }
}

class IAPTestStateSelection: IAPStatesSelectDelegate {
    
    var didSelectStateInvoked: Bool = false
    
    func didSelectStates(_ stateData: NSDictionary) {
        didSelectStateInvoked = true
    }
}
