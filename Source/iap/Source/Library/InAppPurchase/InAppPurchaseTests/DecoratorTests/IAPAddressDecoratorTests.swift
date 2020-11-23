/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPAddressDecoratorTests: XCTestCase {

    var addressDecorator : IAPAddressDecorator?
    var addressList: [IAPUserAddress]?
    var addressDecoratorTableView: UITableView?
    var decoratorDelegate: IAPTestDecorator!
    
    override func setUp() {
        let addressDict = self.deserializeData("IAPOCCGetAddress")
        XCTAssertNotNil(addressDict, "JSON has not been deserialsed")
        let userAddresses = IAPUserAddressInfo(inDict: addressDict!)
        addressList = userAddresses.address
        
        decoratorDelegate = IAPTestDecorator()
        XCTAssert (addressList!.count > 0, "address details are not of right count")
        
        addressDecoratorTableView = IAPTestAddressTableView()
        addressDecoratorTableView?.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
        
        addressDecorator = IAPAddressDecorator(withTableView: addressDecoratorTableView!)
        addressDecorator?.address = addressList!
    }
    
    func testAddressDecoratorConformsToDatasource() {
        XCTAssertTrue((addressDecorator?.conforms(to: UITableViewDataSource.self))!,
                      "payment decorator tableview does not conform to UITableViewDataSource")
    }
    
    func testAddressDecoratorConformsToDelegate() {
        XCTAssertTrue((addressDecorator?.conforms(to: UITableViewDelegate.self))!,
                      "payment decorator tableview does not conform to UITableViewDelegate")
    }
    
    func testTableViewDataSource() {
        XCTAssertNotNil(addressDecoratorTableView?.dataSource, "tableview datasource can't be nil")
    }
    
    func testTableViewDelegate() {
        XCTAssertNotNil(addressDecoratorTableView?.delegate, "tableview delegate can't be nil")
    }
    
    func testTableViewNumberOfRowsInSection() {
        let expectedRows = 6
        let actualRows = addressDecorator?.tableView(addressDecoratorTableView!, numberOfRowsInSection: 0)
        XCTAssertTrue(actualRows == expectedRows, "actual rows should be 6")
    }
    
    func testHeightForRow() {
        var indexPath = IndexPath(row: 0, section:0)
        var height = addressDecorator?.tableView(addressDecoratorTableView!, heightForRowAt: indexPath)
        XCTAssertTrue(height == UITableView.automaticDimension, "Row height is incorrect")
        
        indexPath = IndexPath(row: (addressList?.count)!, section:0)
        height = addressDecorator?.tableView(addressDecoratorTableView!, heightForRowAt: indexPath)
        XCTAssertTrue(height == 48.0, "Row height is incorrect")
    }
    
    func testTableViewCellCreateCellsWithReuseIdentifier() {
        var indexPath = IndexPath(row: 0, section: 0)
//        let cell2 = addressDecorator?.tableView(addressDecoratorTableView!, cellForRowAt: indexPath) as? IAPAddressCell
        if let cell2 = addressDecorator?.tableView(addressDecoratorTableView!, cellForRowAt: indexPath) as? IAPAddressCell {
            XCTAssertTrue(cell2.reuseIdentifier == "AddressCell", "Table view does not create reusable cells")
        }

        //for default address true
        let addressInfo = addressList![0]
        addressInfo.defaultAddress = true
        if let cell = addressDecorator?.tableView(addressDecoratorTableView!, cellForRowAt: indexPath) as? IAPAddressCell {
            XCTAssertTrue(cell.reuseIdentifier == "AddressCell", "Table view does not create reusable cells")
        }
        
        indexPath = IndexPath(row: 5, section: 0)
        if let cell1 = addressDecorator?.tableView(addressDecoratorTableView!, cellForRowAt: indexPath) as? IAPSingleListItemCell {
            XCTAssertTrue(cell1.reuseIdentifier == IAPCellIdentifier.IAPSingleListItemCell, "Table view does not create reusable cells")
        }
    }
    
    func testDidSelectRow() {
        var indexPath = IndexPath(row: 5, section: 0)
        addressDecorator?.delegate = decoratorDelegate
        addressDecorator?.tableView(addressDecoratorTableView!, didSelectRowAt: indexPath)
        XCTAssertTrue(decoratorDelegate.didSelectAddMethodInvoked == true, "Table view does not create reusable cells")
        
        indexPath = IndexPath(row: 1, section: 0)
        addressDecorator?.tableView(addressDecoratorTableView!, didSelectRowAt: indexPath)
    }
    
    /*func testCanEditRowAtIndexPath() {
        var indexPath = IndexPath(row: 0, section: 0)
        var canEditFlag = addressDecorator?.tableView(addressDecoratorTableView!, canEditRowAt: indexPath)
        XCTAssertTrue(canEditFlag!, "user should be able to edit row")
        
        indexPath = IndexPath(row: 6, section: 0)
        canEditFlag = addressDecorator?.tableView(addressDecoratorTableView!, canEditRowAt: indexPath)
        XCTAssertFalse(canEditFlag!, "user should not be able to edit row")
    }
    
    func testTableViewSelection() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = addressDecorator?.tableView(addressDecoratorTableView!, cellForRowAt: indexPath) as! IAPAddressCell
        XCTAssertTrue(cell.reuseIdentifier == "AddressCell", "Table view does not create reusable cells")
        
        addressDecorator?.delegate = decoratorDelegate
        addressDecorator?.tableView(addressDecoratorTableView!, didSelectRowAt: indexPath)
        XCTAssert(decoratorDelegate.didSelectMethodInvoked == true, "Did select method is not selected")
    }
    
    func testAddressSelectionOptions() {
        let indexPath = IndexPath(row: 0, section: 0)
        var cell = addressDecorator?.tableView(addressDecoratorTableView!, cellForRowAt: indexPath) as! IAPAddressCell
        XCTAssertTrue(cell.reuseIdentifier == "AddressCell", "Table view does not create reusable cells")
        
        //for default address true
        let addressInfo = addressList![0]
        addressInfo.defaultAddress = true
        cell = addressDecorator?.tableView(addressDecoratorTableView!, cellForRowAt: indexPath) as! IAPAddressCell
        XCTAssertNotNil(cell.delegate, "Delegate is empty")
        XCTAssertTrue(cell.reuseIdentifier == "AddressCell", "Table view does not create reusable cells")
        
        addressDecorator?.delegate = decoratorDelegate
        cell.addAddressClicked(UIButton(frame: CGRect.zero))
        XCTAssert(decoratorDelegate.didSelectAddMethodInvoked == true, "Add method did not get called on delegate")
        
        cell.deliverToAddressClicked(UIButton(frame: CGRect.zero))
        XCTAssert(decoratorDelegate.didSelectDeliveryMethodInvoked == true, "Deliver to address method did not get called on delegate")
    }
    
    func testCommitEditingStyle() {
        var indexPath = IndexPath(row: 0, section: 0)
        addressDecorator?.tableView(addressDecoratorTableView!, commit: .none, forRowAt: indexPath)
        XCTAssertTrue(addressList?.count == 5, "no of user address should be 5")
        
        indexPath = IndexPath(row: 1, section: 0)
        addressDecorator?.tableView(addressDecoratorTableView!, commit: .delete, forRowAt: indexPath)
        XCTAssertTrue(addressList?.count == 5, "no of user address should be 4")
    }*/

    func testUserSelectedRadioButton() {
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = addressDecorator?.tableView(addressDecoratorTableView!,
                                                  cellForRowAt: indexPath) as? IAPAddressCell {
            addressDecorator?.userSelectedRadioButton(cell)
        }
    }

    func testUserSelectedEdit() {
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = addressDecorator?.tableView(addressDecoratorTableView!,
                                                  cellForRowAt: indexPath) as? IAPAddressCell {
            addressDecorator?.userSelectedEdit(cell)
        }
    }

    func testUserSelectedDelete() {
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = addressDecorator?.tableView(addressDecoratorTableView!,
                                                  cellForRowAt: indexPath) as? IAPAddressCell {
            addressDecorator?.userSelectedDelete(cell)
        }
    }

    func testUserSelectedUseThisOption() {
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = addressDecorator?.tableView(addressDecoratorTableView!, cellForRowAt: indexPath) as? IAPAddressCell {
            addressDecorator?.userSelectedUseThisOption(cell)
        }
    }
    
    func testUserSelectedAddNewOption() {
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = addressDecorator?.tableView(addressDecoratorTableView!,
                                                  cellForRowAt: indexPath) as? IAPAddressCell {
            addressDecorator?.userSelectedAddNewOption(cell)
        }
    }
}

class IAPTestAddressTableView: UITableView {
    override internal func indexPath(for cell: UITableViewCell) -> IndexPath? {
        return IndexPath(item: 0, section: 0)
    }
}

class IAPTestDecorator: IAPAddressDecoratorProtocol {

    var didSelectMethodInvoked: Bool = false
    var didSelectAddMethodInvoked: Bool = false
    var didSelectDeliveryMethodInvoked: Bool = false
    var didSelectDeleteMethodInvoked: Bool = false

    func didSelectEditAddress(_ inAddress: IAPUserAddress) {
        didSelectMethodInvoked = true
    }

    func didSelectAddAddress(_ inAddress: IAPUserAddress?) {
        didSelectAddMethodInvoked = true
    }

    func didSelectDeliverToAddress(_ inAddress: IAPUserAddress) {
        didSelectDeliveryMethodInvoked = true
    }

    func didSelectDeleteAddress(_ inAddress: IAPUserAddress) {
        didSelectDeleteMethodInvoked = true
    }
}
