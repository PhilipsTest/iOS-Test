/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import AppInfra
import AdobeMobileSDK
import SafariServices
@testable import InAppPurchaseDev
@testable import PhilipsRegistration

class IAPRetailerViewControllerTests: XCTestCase {
    
    var retailerTableView: UITableView!
    var retailers: [IAPRetailerModel]!
    var retailerViewController = IAPRetailerViewController()
    
    override func setUp() {
        super.setUp()

        let vc = IAPRetailerViewController.instantiateFromAppStoryboard(appStoryboard: .retailer)
        vc.loadView()
        self.retailerTableView = vc.retailerTableView
        self.retailerViewController = vc

        self.retailerViewController.viewWillAppear(false)
        self.retailerViewController.didTapTryAgain()
        let retailerDict = self.deserializeData("IAPRetailerSampleResponse")
        self.retailers = IAPRetailerModelCollection(inDict: retailerDict!).getRetailers()
        retailerViewController.retailers = self.retailers
        
        Bundle.loadSwizzler()
        ADBMobile.overrideConfigPath(Bundle.main.path(forResource: "ADBMobileConfig", ofType: "json")!)
        let appInfra = AIAppInfra(builder: nil)
        IAPConfiguration.setIAPConfiguration("en_US", inAppInfra: appInfra!)
        IAPConfiguration.sharedInstance.setUserDataInterface(setUserDataInterface(appInfra))
        let componentInfoDict = Bundle.main.infoDictionary!
        IAPConfiguration.sharedInstance.sharedAppInfra.tagging.createInstance(
            forComponent: componentInfoDict["CFBundleName"] as? String ?? "",
            componentVersion: componentInfoDict["CFBundleShortVersionString"] as? String ?? "")
        self.retailerViewController.viewDidLoad()
    }
    
    override func tearDown() {
        Bundle.deSwizzle()
        super.tearDown()
    }
    
    func setUserDataInterface(_ appInfra:AIAppInfra!) -> UserDataInterface!{
        let UserRegistrationDependencies = URDependencies()
        UserRegistrationDependencies.appInfra = appInfra
        let urInterface = URInterface(dependencies: UserRegistrationDependencies, andSettings: nil)
        return urInterface.userDataInterface()
    }
    
    func testTableViewDataSource() {
        XCTAssertNotNil(self.retailerViewController.retailerTableView.dataSource, "tableview datasource can't be nil")
    }
    
    func testTableViewDelegate() {
        XCTAssertNotNil(self.retailerViewController.retailerTableView?.delegate, "tableview delegate can't be nil")
    }
    
    func testTableViewNumberOfRowsInSection() {
        let expectedRows = self.retailers.count
        let actualRows = self.retailerViewController.tableView(self.retailerTableView, numberOfRowsInSection: 0)
        XCTAssertTrue(actualRows == expectedRows, "actual rows should be equal to retailer count")
    }
    
    func testCellForRowAtIndexPath(){
        var indexPath = IndexPath(row: 0, section: 0)
        var cell = self.retailerViewController.tableView(self.retailerTableView, cellForRowAt: indexPath)
        XCTAssertTrue(cell.reuseIdentifier == "retailerCell", "Table view does not create reusable cells")
        
        indexPath = IndexPath(row: 1, section: 0)
        cell = self.retailerViewController.tableView(self.retailerTableView, cellForRowAt: indexPath)
        XCTAssertTrue(cell.reuseIdentifier == "retailerCell", "Table view does not create reusable cells")
    }
    
    func testNumberOfRowsInSection() {
        let noOfsection = 1
        let actuaNoOfSection = self.retailerViewController.numberOfSections(in: self.retailerTableView)
        XCTAssertTrue(noOfsection == actuaNoOfSection, "Total no of section should be 1")
    }
}

class IAPTestNavigationController: UINavigationController {
    var pushedViewController: UIViewController!
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.pushedViewController = viewController
        super.pushViewController(viewController, animated: animated)
    }
}
