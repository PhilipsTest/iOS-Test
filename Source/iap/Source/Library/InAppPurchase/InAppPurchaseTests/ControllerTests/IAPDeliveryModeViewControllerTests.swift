/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPDeliveryModeViewControllerTests: XCTestCase {
    
    var deliveryModes: [IAPDeliveryModeInfo]!
    var deliveryModeViewController = IAPDeliveryModeViewController()
    var deliveryModeTableView: UITableView!
    
    override func setUp() {
        super.setUp()
        let deliveryModeDict = self.deserializeData("IAPDeliveryModes")
        self.deliveryModes = IAPDeliveryModeDetails(inDict: deliveryModeDict!).deliveryModeDetails

        let deliveryVC = IAPDeliveryModeViewController.instantiateFromAppStoryboard(appStoryboard: .order)
        deliveryVC.loadView()
        self.deliveryModeTableView = deliveryVC.deliveryModeTableView
        self.deliveryModeViewController = deliveryVC
        self.deliveryModeViewController.deliveryModes = self.deliveryModes
        self.deliveryModeViewController.viewDidLoad()
        self.deliveryModeViewController.viewWillAppear(false)

        let navController = IAPTestNavigationController()
        navController.pushViewController(self.deliveryModeViewController, animated: false)
    }
    
    func testShouldPopOnBackButton(){
        let bool = self.deliveryModeViewController.viewControllerShouldPopOnBackButton()
        XCTAssertFalse(bool, "Should return false")
    }
    
    func testTableViewDataSource() {
        XCTAssertNotNil(self.deliveryModeViewController.deliveryModeTableView.dataSource, "tableview datasource can't be nil")
    }
    
    func testTableViewDelegate() {
        XCTAssertNotNil(self.deliveryModeViewController.deliveryModeTableView?.delegate, "tableview delegate can't be nil")
    }
    
    func testTableViewNumberOfRowsInSection() {
        let actualRows = self.deliveryModeViewController.tableView(self.deliveryModeTableView, numberOfRowsInSection: 0)
        XCTAssertTrue(actualRows == self.deliveryModes.count, "actual rows should match the delivery mode count")
    }

    func testCellForRowAtIndexPath() {
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = self.deliveryModeViewController.tableView(self.deliveryModeTableView,
                                                                cellForRowAt: indexPath) as? IAPDeliveryModeCell {
            XCTAssertTrue(cell.reuseIdentifier == "deliveryModeCell", "Table view does not create reusable cells")
            self.deliveryModeViewController.deliveryModeTableView = self.deliveryModeTableView
            self.deliveryModeViewController.userSelectedRadioButton(cell)
        } else {
            assertionFailure("Cell creation failed")
        }
    }
}
