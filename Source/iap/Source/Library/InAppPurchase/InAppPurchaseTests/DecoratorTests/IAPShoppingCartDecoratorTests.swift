/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPShoppingCartDecoratorTests: XCTestCase {

    var shoppingCartDecorator: IAPShoppingCartDecorator?
    var shoppingCartInfo: IAPCartInfo?
    var productList: [IAPProductModel]?
    var shoppingCartDecoratorTableView: UITableView?
    var decoratorDelegate: IAPShoppingCartTestDecorator!
    var quantityDelegate: IAPUpdateQuantityTableDelegate!
    
    override func setUp() {
        let cartInfoDict = self.deserializeData("IAPOCCCartInfoSampleResponse")
        XCTAssertNotNil(cartInfoDict, "JSON has not been deserialsed")
        self.shoppingCartInfo = IAPCartInfo(inDict: cartInfoDict! as NSDictionary)
        
        let productDict = self.deserializeData("IAPProductSampleResponse")
        XCTAssertNotNil(productDict, "JSON has not been deserialsed")
        self.productList = IAPProductModelCollection(inDict: productDict!).getProducts()
        
        decoratorDelegate = IAPShoppingCartTestDecorator()
        XCTAssert (productList!.count > 0, "product details are not of right count")

        let vc = IAPShoppingCartViewController.instantiateFromAppStoryboard(appStoryboard: .shoppingCart)
        vc.loadView()
        
        shoppingCartDecoratorTableView = vc.shoppingCartTblView
        
        shoppingCartDecorator = IAPShoppingCartDecorator(withTableView: shoppingCartDecoratorTableView!)
        shoppingCartDecorator?.productList = self.productList!
        shoppingCartDecorator?.shoppingCartInfo = self.shoppingCartInfo
    }
    
    func testShoppingCartDecoratorConformsToDatasource() {
        XCTAssertTrue((shoppingCartDecorator?.conforms(to: UITableViewDataSource.self))!,
                      "payment decorator tableview does not conform to UITableViewDataSource")
    }
    
    func testShoppingCartDecoratorConformsToDelegate() {
        XCTAssertTrue((shoppingCartDecorator?.conforms(to: UITableViewDelegate.self))!,
                      "payment decorator tableview does not conform to UITableViewDelegate")
    }
    
    func testTableViewDataSource() {
        XCTAssertNotNil(shoppingCartDecoratorTableView?.dataSource, "tableview datasource can't be nil")
    }
    
    func testTableViewDelegate() {
        XCTAssertNotNil(shoppingCartDecoratorTableView?.delegate, "tableview delegate can't be nil")
    }
    
    func testTableViewNumberOfRowsInSection() {
        var expectedRows = 1
        var actualRows = shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!, numberOfRowsInSection: 1)
        //XCTAssertTrue(actualRows == expectedRows, "actual rows should be 3")
        
        expectedRows = (productList?.count)!
        actualRows = shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!, numberOfRowsInSection: 0)
        XCTAssertTrue(actualRows == expectedRows, "actual rows should be \((productList?.count)!)")
        
        actualRows = shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!, numberOfRowsInSection: 2)
        XCTAssertTrue(actualRows == expectedRows, "actual rows should be \((productList?.count)!)")
    }
    
    func testTableViewCellCreateCellsWithReuseIdentifier() {
        let lastRowIndex = (shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!, numberOfRowsInSection: 0))! - 1
        var indexPath = IndexPath(row: lastRowIndex, section: 0)
        var cell = shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!, cellForRowAt: indexPath)
        XCTAssertTrue(cell?.reuseIdentifier == IAPCellIdentifier.productCell, "Table view does not create reusable cells")
        
        if ((IAPOAuthConfigurationData.getInAppConfigValueForKey(IAPConstants.IAPConfigurationKeys.kvoucherCodeEnable)) as? Bool) != nil {
            indexPath = IndexPath(row: 0, section: 1)
            cell = shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!, cellForRowAt: indexPath)
            // commented for now need to fix
            XCTAssertTrue(cell?.reuseIdentifier == "voucherCell", "Table view does not create reusable cells")
            
            indexPath = IndexPath(row: 1, section: 1)
            cell = shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!, cellForRowAt: indexPath)
            XCTAssertTrue(cell?.reuseIdentifier == "shippingCostCell", "Table view does not create reusable cells")
            
        }
        else{
            indexPath = IndexPath(row: 0, section: 1)
            cell = shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!, cellForRowAt: indexPath)
            XCTAssertTrue(cell?.reuseIdentifier == "shippingCostCell", "Table view does not create reusable cells")
        }
        
        indexPath = IndexPath(row: 0, section: 2)
        cell = shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!, cellForRowAt: indexPath)
        XCTAssertTrue(cell?.reuseIdentifier == IAPCellIdentifier.summaryCustomCell, "Table view does not create reusable cells")
        
        indexPath = IndexPath(row: 0, section: 6)
        cell = shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!, cellForRowAt: indexPath)
        XCTAssertTrue(cell?.reuseIdentifier == IAPCellIdentifier.purchaseHistoryPriceCell,
                      "Table view does not create reusable cells")
 
        indexPath = IndexPath(row: 0, section: 8)
        cell = shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!, cellForRowAt: indexPath)
        XCTAssertTrue(cell?.reuseIdentifier == IAPCellIdentifier.totalCell, "Table view does not create reusable cells")
    }
    
    func testTableViewSelection() {
        var indexPath = IndexPath(row: 0, section: 0)
        shoppingCartDecorator?.delegate = decoratorDelegate
        shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!, didSelectRowAt: indexPath)
        XCTAssert(decoratorDelegate.pushDetailViewMethodInvoked == true, "push detail method is not selected")
        if ((IAPOAuthConfigurationData.getInAppConfigValueForKey(IAPConstants.IAPConfigurationKeys.kvoucherCodeEnable)) as? Bool) != nil {
             indexPath = IndexPath(row: 0, section: 1)
            shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!, didSelectRowAt: indexPath)
            XCTAssert(decoratorDelegate.displayVoucherViewInvoked == true,
                      "display Voucher view method is not selected")
        }
        else{
        indexPath = IndexPath(row: 0, section: 1)
        shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!, didSelectRowAt: indexPath)
        XCTAssert(decoratorDelegate.displayDeliveryModeViewMethodInvoked == true,
                  "display delivery detail method is not selected")
        }
        
        /*indexPath = IndexPath(row: 3, section: 0)
        cell = shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!, cellForRowAt: indexPath)
        XCTAssertTrue(cell?.reuseIdentifier == "shippingCostCell", "Table view does not create reusable cells")
        
        shoppingCartDecorator?.delegate = decoratorDelegate
        shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!, didSelectRowAt: indexPath)
        XCTAssert(decoratorDelegate.displayDeliveryModeViewMethodInvoked == true, "display delivery mode method is not selected")*/
    }
    
    func testNumberOfSection() {
        let indexPath = productList?.count
        var numberOfRows: Int
        if (indexPath)! > 0 {
            numberOfRows = (shoppingCartDecorator?.numberOfSections(in: shoppingCartDecoratorTableView!))!
            XCTAssertTrue(numberOfRows == 7, "Table view have incorrect sections")
        } else {
            numberOfRows = (shoppingCartDecorator?.numberOfSections(in: shoppingCartDecoratorTableView!))!
            XCTAssertTrue(numberOfRows == 0, "Table view have incorrect sections")
        }
    }
    
    func testHeightForRow() {
        let tableViewRow = (productList?.count)! + IAPShoppingCartCells.kShippingCostCellNumber
        let indexPath = IndexPath(row: tableViewRow, section: 0)
        let height = shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!, heightForRowAt: indexPath)
        XCTAssertTrue(height == UITableView.automaticDimension, "Table view row height is not correct")
    }

    func testHeightForHeaderInSection() {
        var indexPathSection = 0
        var height = shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!,
                                                      heightForHeaderInSection: indexPathSection)
        XCTAssertTrue(height == 48, "Table view header height is 48")
        indexPathSection = 3
        height = shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!,
                                                  heightForHeaderInSection: indexPathSection)
        XCTAssertTrue(height == 0, "Table view header height is zero")
    }

    func testViewForHeaderInSection() {
        var view = shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!, viewForHeaderInSection: 0)
        XCTAssertNotNil(view, "View returned was not nil")
        view = shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!, viewForHeaderInSection: 1)
        XCTAssertNotNil(view, "View returned was not nil")
        view = shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!, viewForHeaderInSection: 2)
        XCTAssertNotNil(view, "View returned was not nil")
        view = shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!, viewForHeaderInSection: 3)
        XCTAssertNil(view, "View returned was not nil")
    }

    func testHandleOutOfStockQuantity() {
        let lastRowIndex = (shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!,
                                                             numberOfRowsInSection: 0))! - 1
        let indexPath = IndexPath(row: lastRowIndex, section: 0)
        if let cell = shoppingCartDecorator?.tableView(shoppingCartDecoratorTableView!,
                                                       cellForRowAt: indexPath) as? IAPCartProductCell {
            let productModel = self.productList?[indexPath.row]
            var stockQuantity = productModel?.getStockAmount()
            let productQuantity = productModel?.getQuantity()
            shoppingCartDecorator?.delegate = decoratorDelegate
            shoppingCartDecorator?.handleOutOfStockQuantity(cell,
                                                            quantityAdded: productQuantity!,
                                                            stockAvailable: stockQuantity!)
            XCTAssertTrue(cell.reuseIdentifier == IAPCellIdentifier.productCell, "Table view does not create reusable cells")
            stockQuantity = 1
            shoppingCartDecorator?.handleOutOfStockQuantity(cell,
                                                            quantityAdded: productQuantity!,
                                                            stockAvailable: stockQuantity!)
            XCTAssertTrue(cell.reuseIdentifier == IAPCellIdentifier.productCell, "Table view does not create reusable cells")
        }
    }
    
    /*func testControllerDidSelectQuantity() {
        
        let tableViewController: UITableViewController = IAPQuantityTableViewController()
        let indexPath = IndexPath(row: 0, section: 0)
        //let presentedViewController: UIViewController = shoppingCartDecoratorTableView!.presentationController!.presentingViewController
        shoppingCartDecorator?.delegate = quantityDelegate as? IAPShoppingDecoratorProtocol
        shoppingCartDecorator?.controllerDidSelectQuantity(1, selectedProductIndexPath: indexPath, tableViewController: shoppingCartDecorator?.ta)
        XCTAssert(decoratorDelegate.updateQuantityMethodInvoked == true, "update quantity method is not selected")
    }*/
    
    func testQuantityViewClicked() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        let popoverController = IAPCustomPopoverController()
        shoppingCartDecorator?.quantityViewClicked(tap)
        XCTAssertNotNil(popoverController, "Custom Pop Over Controller is nil")
    }

    func handleTap(_ sender: UITapGestureRecognizer) {
        print("Hello World")
    }
}

class IAPShoppingCartTestDecorator: IAPShoppingDecoratorProtocol {

    var pushDetailViewMethodInvoked = false
    var displayDeliveryModeViewMethodInvoked = false
    var updateQuantityMethodInvoked = false
    var displayVoucherViewInvoked = false

    func adjsutView(_ shouldEnable: Bool) {
    }
    
    func displayVoucherView(){
        displayVoucherViewInvoked = true
    }
    func pushDetailView(_ withObject: IAPProductModel) {
        pushDetailViewMethodInvoked = true
    }

    func displayDeliveryModeView() {
        displayDeliveryModeViewMethodInvoked = true
    }

    func updateQuantity(_ objectToBeUpdated: IAPProductModel, withCartInfo: IAPCartInfo, quantityValue: Int) {
        updateQuantityMethodInvoked = true
    }
}
