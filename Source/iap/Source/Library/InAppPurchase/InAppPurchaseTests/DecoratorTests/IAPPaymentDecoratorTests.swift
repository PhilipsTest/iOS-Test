/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev
import PhilipsUIKitDLS

class IAPPaymentDecoratorTests: XCTestCase {

    var paymentDecorator: IAPPaymentDecorator?
    var arrayOfPaymentDetails: [IAPPaymentInfo]?
    var paymentDecoratorTableView: UITableView?
    
    override func setUp() {

        let configuration = UIDThemeConfiguration(colorRange: .groupBlue,
                                                  tonalRange: .ultraLight,
                                                  navigationTonalRange: .bright)
        let theme = UIDTheme(themeConfiguration: configuration)
        UIDThemeManager.sharedInstance.setDefaultTheme(theme: theme, applyNavigationBarStyling: true)

        let paymentDict = self.deserializeData("IAPPaymentDetailsInfo")
        XCTAssertNotNil(paymentDict, "JSON has not been deserialsed")
        
        let paymentDetails = IAPPaymentDetailsInfo(inDict: paymentDict!)
        XCTAssert (paymentDetails.arrayOfPaymentDetails.count > 0, "Payment details are not of right count")
        self.arrayOfPaymentDetails = paymentDetails.arrayOfPaymentDetails
        paymentDecoratorTableView = UITableView()
        paymentDecoratorTableView?.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
        self.paymentDecorator = IAPPaymentDecorator(withTableView: paymentDecoratorTableView!,
                                                    withPayments: self.arrayOfPaymentDetails!)
    }
    
    func testPaymentDecoratorConformsToDatasource() {
        XCTAssertTrue((paymentDecorator?.conforms(to: UITableViewDataSource.self))!,
                      "payment decorator tableview does not conform to UITableViewDataSource")
    }
    
    func testPaymentDecoratorConformsToDelegate() {
        XCTAssertTrue((paymentDecorator?.conforms(to: UITableViewDelegate.self))!,
                      "payment decorator tableview does not conform to UITableViewDataSource")
    }
    
    func testTableViewDataSource() {
        XCTAssertNotNil(paymentDecoratorTableView?.dataSource, "tableview datasource can't be nil")
    }
    
    func testTableViewDelegate() {
        XCTAssertNotNil(paymentDecoratorTableView?.delegate, "tableview delegate can't be nil")
    }
    
    func testTableViewNumberOfRowsInSection() {
        let expectedRows = 5
        let actualRows = paymentDecorator?.tableView(paymentDecoratorTableView!, numberOfRowsInSection: 0)
        XCTAssertTrue(actualRows == (expectedRows+1), "actual rows should be 6")
    }
    
    func testTableViewCellCreateCellsWithReuseIdentifier() {
        var indexPath = IndexPath(row: 0, section: 0)
        var cell = paymentDecorator?.tableView(paymentDecoratorTableView!, cellForRowAt: indexPath)
        XCTAssertTrue(cell?.reuseIdentifier == "IAPPaymentSelectionCell", "Table view does not create reusable cells")
        
        indexPath = IndexPath(row: (arrayOfPaymentDetails?.count)!, section: 0)
        cell = paymentDecorator?.tableView(paymentDecoratorTableView!, cellForRowAt: indexPath)
        XCTAssertTrue(cell?.reuseIdentifier == IAPCellIdentifier.IAPSingleListItemCell, "Table view does not create reusable cells")
    }
    
    func testGetDisplayTextWithPaymentInfo() {
        let paymentInfo = arrayOfPaymentDetails![0]
        let paymentFormattedString = paymentDecorator?.getDisplayTextWithPaymentInfo(paymentInfo)
        XCTAssertNotNil(paymentFormattedString, "payment formatted string should not be nil")
    }
    
    func testuserSelectedRadioButton() {
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = paymentDecorator?.tableView(paymentDecoratorTableView!,
                                                  cellForRowAt: indexPath) as? IAPPaymentSelectionCell {
            paymentDecorator?.radioButtonSelected(cell)
        }
    }
    
    func testUserSelectedUseThisOption() {
        let indexPath = IndexPath(row: 1, section: 0)
        if let cell = paymentDecorator?.tableView(paymentDecoratorTableView!,
                                                  cellForRowAt: indexPath) as? IAPPaymentSelectionCell {
            paymentDecorator?.useThisPaymentSelected(cell)
        }
    }
    
    func testDidSelectRowAtIndexPath() {
        var indexPath = IndexPath(row: 0, section: 0)
        paymentDecorator?.tableView(paymentDecoratorTableView!, didSelectRowAt: indexPath)
        
        indexPath = IndexPath(row:(arrayOfPaymentDetails?.count)!, section:0)
        paymentDecorator?.tableView(paymentDecoratorTableView!, didSelectRowAt: indexPath)
    }
    
    func testHeightForRow() {
        var indexPath = IndexPath(row:(arrayOfPaymentDetails?.count)!, section: 0)
        var cell = paymentDecorator?.tableView(self.paymentDecoratorTableView!, heightForRowAt: indexPath)
        XCTAssertTrue(cell == IAPConstants.IAPPaymentSelectionDecoratorConstants.kHeaderHeightConstant,
                      "Height returned was not correct")
        indexPath = IndexPath(row: 0, section: 0)
        cell = paymentDecorator?.tableView(self.paymentDecoratorTableView!, heightForRowAt: indexPath)
        XCTAssertTrue(cell == UITableView.automaticDimension, "Height returned was not correct")
    }
    
    /*func testUserSelectedAddNewOption() {
        let indexPath = IndexPath(row: 2, section: 0)
        let cell = paymentDecorator?.tableView(paymentDecoratorTableView!, cellForRowAt: indexPath) as! IAPAddressCell
        paymentDecorator?.userSelectedAddNewOption(cell)
    }*/

}
