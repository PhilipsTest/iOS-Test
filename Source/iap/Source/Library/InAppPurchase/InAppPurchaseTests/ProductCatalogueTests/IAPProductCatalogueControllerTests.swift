/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
//import UIKit

@testable import InAppPurchaseDev

class IAPProductCatalogueControllerTests: XCTestCase {
    
    var productModel: IAPProductModelCollection?
    var paginationModel: IAPPaginationModel?
    var categorizedCTNList = [String]()
    var productInfoHelper = IAPProductInfoHelper()
    var productCatalogueController: IAPProductCatalogueController!
    
    override func setUp() {
        super.setUp()
        IAPConfiguration.sharedInstance.locale = "en_US"
        let dictionary = self.deserializeData("IAPProductSampleResponse")
        productModel = IAPProductModelCollection(inDict: dictionary!)

        if let paginationDict = dictionary!["pagination"] as? [String: AnyObject] {
            paginationModel = IAPPaginationModel(inDict: paginationDict)
            categorizedCTNList = ["54321", "12345"]

            productCatalogueController = IAPProductCatalogueController.instantiateFromAppStoryboard(appStoryboard: .productCatalogue)
            productCatalogueController.setDataArray(categorizedCTNList)
            productCatalogueController.dataArray = (productModel?.getProducts())!
            productCatalogueController.viewDidLoad()
            productCatalogueController.viewWillAppear(false)
        } else {
            assertionFailure("Failed")
        }
    }
    
    override func tearDown() {
        super.tearDown()
        IAPConfiguration.sharedInstance.bannerConfigDelegate = nil
    }
       
    func testShoppingCartDecoratorConformsToDatasource() {
        XCTAssertTrue((productCatalogueController!.conforms(to: UITableViewDataSource.self)), "payment decorator tableview does not conform to UITableViewDataSource")
    }
    
    func testShoppingCartDecoratorConformsToDelegate() {
        XCTAssertTrue((productCatalogueController!.conforms(to: UITableViewDelegate.self)), "payment decorator tableview does not conform to UITableViewDelegate")
    }
    
    func testTableViewDataSource() {
        XCTAssertNotNil(productCatalogueController!.productTableView.dataSource, "tableview datasource can't be nil")
    }
    
    func testTableViewDelegate() {
        XCTAssertNotNil(productCatalogueController!.productTableView.delegate, "tableview delegate can't be nil")
    }
    
    func testTableViewNumberOfRowsInSection() {
        let expectedRows = 3
        
        let actualRows = productCatalogueController?.tableView((productCatalogueController?.productTableView)!, numberOfRowsInSection: 0)        
        XCTAssertTrue(actualRows == expectedRows, "actual rows should be 0")
    }
    
    func testTableViewCellCreateCellsWithReuseIdentifier() {
        productCatalogueController?.dataArray = (productModel?.getProducts())!
        let indexPath = NSIndexPath(row: 1, section: 0)
        let cell = productCatalogueController?.tableView((productCatalogueController?.productTableView)!, cellForRowAt: indexPath as IndexPath)
        XCTAssertNotNil(cell, "cell returned is nil")
    }
    
    func testTableViewDidSelectRowAtIndexPath() {
        let indexPath = IndexPath(row: 0, section: 0)
        productCatalogueController?.tableView((productCatalogueController?.productTableView)!, didSelectRowAt: indexPath)
    }
    
    func testTableViewWillDisplayCell() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = productCatalogueController?.tableView((productCatalogueController?.productTableView)!, cellForRowAt: indexPath)
        productCatalogueController?.tableView((productCatalogueController?.productTableView)!, willDisplay: cell!, forRowAt: indexPath)
    }
    
    func testGetProductCell() {
        let indexPath = IndexPath(row: 0, section: 0)
        let productCell: IAPProductCatalogueCell = (productCatalogueController?.getProductCell((productCatalogueController?.productTableView)!, indexPath: indexPath))!
        XCTAssertTrue(productCell is IAPProductCatalogueCell, "IAPProductCatalogueCell type tableview cell is not returned")
    }
    
    func testGetcatalogueWithoutProductCell() {
        let indexPath = IndexPath(row: 0, section: 0)
        let productCell = (productCatalogueController?.getcatalogueWithoutProductCell((productCatalogueController?.productTableView)!, indexPath: indexPath))!
        XCTAssertNotNil((productCell as? IAPCatalogueWithoutProductsCell),
                        "IAPCatalogueWithoutProductsCell type tableview cell is not returned")
    }
    
    func testGetValidProductOfPRX() {
        let validProductModel = (productCatalogueController?.getValidProductsOfPRX((productModel?.getProducts())!))!
        XCTAssertNotNil(validProductModel, "product model returned is nil")
    }
    
    func testGetPRXInformationOfProducts() {
        productCatalogueController?.getPRXInformationForProducts((productModel?.getProducts())!)
    }
    
    func testUpdateUIAfterPRXDownload() {
        productCatalogueController?.updateUIAfterPRXDownload(inputProducts: (productModel?.getProducts())!)
        let firstProductModel:IAPProductModel = (productModel?.getProducts().first)!
        firstProductModel.setProductTitle("Shaver")
        XCTAssertNotNil(firstProductModel, "product model is empty")
        
        productCatalogueController?.updateUIAfterPRXDownload(inputProducts: ([firstProductModel]))
        XCTAssertNotNil(firstProductModel.getProductTitle(), "product title is empty")
    }
    
    func testGetCategorizedProductModel() {
        productCatalogueController?.setDataArray(["HX9042/64"])
        let outputProductModel:[IAPProductModel] = (productCatalogueController?.getCategorizedProductModel((productModel?.getProducts())!))!
        XCTAssertNotNil(outputProductModel, "Returned product model is nil")
        XCTAssertTrue(outputProductModel.count > 0, "Returned product model is empty")
    }
    
    func testUpdateSearchResults() {
        let searchBarController = UISearchController()
        productCatalogueController?.updateSearchResults(for: searchBarController)
        XCTAssertNotNil(productCatalogueController?.dataArray, "Result data is nil")
        searchBarController.searchBar.text = "Shaver"
        productCatalogueController?.updateSearchResults(for: searchBarController)
        XCTAssertNotNil(productCatalogueController?.dataArray, "Result data is nil")
    }
    
    func testFetchDataForPage() {
        productCatalogueController?.fetchDataForPage(1)
    }
    
    func testProcessOutputResponseFromHybris() {
        productCatalogueController?.setDataArray(["HX9042/64"]) //for setting categorized ctn list
        productCatalogueController?.processOutputResponseFromHybris(hybrisProductResponse: (productModel?.getProducts())!, paginationDict: nil)
        XCTAssertTrue(productCatalogueController?.catalogueStackView.isHidden == false, "product table view is hidden")
        productCatalogueController?.processOutputResponseFromHybris(hybrisProductResponse: [], paginationDict: nil)
        XCTAssertTrue(productCatalogueController?.catalogueStackView.isHidden == true, "product table view is not hidden")
    }
    
    func testDefaultBannerView() {
        XCTAssertEqual(productCatalogueController.catalogueStackView.arrangedSubviews.count, 2)
        XCTAssertEqual(productCatalogueController.catalogueStackView.arrangedSubviews.first, productCatalogueController.productTableView)
    }
    
    func testCustomBannerView() {
        let bannerDelegate = MockBannerDelegate()
        IAPConfiguration.sharedInstance.bannerConfigDelegate = bannerDelegate
        productCatalogueController.viewDidLoad()
        XCTAssertEqual(productCatalogueController.catalogueStackView.arrangedSubviews.count, 3)
        if let bannerView = productCatalogueController.catalogueStackView.arrangedSubviews.first {
            XCTAssertEqual(bannerView.subviews.first, bannerDelegate.customView)
            XCTAssertEqual(bannerView, productCatalogueController.bannerView)
        }
    }
    
    func testWithNilCustomView() {
        let bannerDelegate = MockBannerDelegate()
        bannerDelegate.shouldReturnView = false
        IAPConfiguration.sharedInstance.bannerConfigDelegate = bannerDelegate
        productCatalogueController.viewDidLoad()
        XCTAssertEqual(productCatalogueController.catalogueStackView.arrangedSubviews.count, 2)
        XCTAssertEqual(productCatalogueController.catalogueStackView.arrangedSubviews.first, productCatalogueController.productTableView)
    }
}

class MockBannerDelegate: NSObject, IAPBannerConfigurationProtocol {
    
    var shouldReturnView = true
    var customView = UIView()
    
    func viewForBannerInCatalogueScreen() -> UIView? {
        return shouldReturnView ? customView : nil
    }
}
