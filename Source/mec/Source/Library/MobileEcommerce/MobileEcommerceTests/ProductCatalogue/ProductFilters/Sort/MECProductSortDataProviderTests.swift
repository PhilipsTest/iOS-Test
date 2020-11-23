/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import PhilipsUIKitDLS
import PhilipsEcommerceSDK
@testable import MobileEcommerceDev

class MECProductSortDataProviderTests: XCTestCase {
    
    var productSortProvider: MECProductSortDataProvider!

    override func setUp() {
        super.setUp()
        let filter = ECSPILProductFilter()
        productSortProvider = MECProductSortDataProvider(appliedFilter: filter)
        let tableView = UITableView()
        productSortProvider.registerCell(for: tableView)
    }

    override func tearDown() {
        super.tearDown()
        productSortProvider = nil
    }
    
    func testInit() {
        let filter = ECSPILProductFilter()
        let mockProvider = MECProductSortDataProvider(appliedFilter: filter)
        
        XCTAssertNotNil(mockProvider.appliedFilter)
        XCTAssertEqual(mockProvider.appliedFilter, filter)
    }
    
    func testRegisterCell() {
        let tableView = UITableView()
        productSortProvider.registerCell(for: tableView)
        
        XCTAssertNotNil(productSortProvider.sortTableView)
        XCTAssertEqual(productSortProvider.sortTableView, tableView)
        XCTAssertNotNil(productSortProvider.sortTableView?.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECProductSortCell))
        XCTAssertNil(productSortProvider.sortTableView?.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECStockFilterCell))
    }
    
    func testViewForHeaderInSection() {
        let headerView = productSortProvider.tableView(productSortProvider.sortTableView ?? UITableView(), viewForHeaderInSection: 0)
        
        XCTAssertNotNil(headerView)
        XCTAssertTrue(headerView is UIDHeaderView)
        XCTAssertNotEqual((headerView as? UIDHeaderView)?.headerLabel.text?.count, 0)
    }
    
    func testHeightForHeaderInSection() {
        XCTAssertEqual(productSortProvider.tableView(productSortProvider.sortTableView ?? UITableView(), heightForHeaderInSection: 0), 40)
    }
    
    func testSortNumberOfRows() {
        XCTAssertEqual(productSortProvider.tableView(productSortProvider.sortTableView ?? UITableView(), numberOfRowsInSection: 0), ECSPILSortType.allCases.count)
    }
    
    func testCellForRowAtIndexPath() {
        let tableView = UITableView()
        productSortProvider.registerCell(for: tableView)
        var mockIndexPath = IndexPath(row: 0, section: 0)
        var sortCell = productSortProvider.tableView(productSortProvider.sortTableView ?? UITableView(), cellForRowAt: mockIndexPath)
        
        XCTAssertNotNil(sortCell)
        XCTAssertTrue(sortCell is MECProductSortCell)
        XCTAssertEqual((sortCell as? MECProductSortCell)?.sortLabel.accessibilityIdentifier, "mec_\(ECSPILSortType.allCases[mockIndexPath.row])_label")
        XCTAssertEqual((sortCell as? MECProductSortCell)?.sortRadioButton.isSelected, false)
        
        mockIndexPath.row = 3
        let filter = ECSPILProductFilter()
        filter.sortType = ECSPILSortType.allCases[mockIndexPath.row]
        productSortProvider.appliedFilter = filter
        sortCell = productSortProvider.tableView(productSortProvider.sortTableView ?? UITableView(), cellForRowAt: mockIndexPath)
        XCTAssertNotNil(sortCell)
        XCTAssertTrue(sortCell is MECProductSortCell)
        XCTAssertEqual((sortCell as? MECProductSortCell)?.sortRadioButton.accessibilityIdentifier, "mec_\(ECSPILSortType.allCases[mockIndexPath.row])_radio_button")
        XCTAssertEqual((sortCell as? MECProductSortCell)?.sortRadioButton.isSelected, true)
        
        sortCell = productSortProvider.tableView(productSortProvider.sortTableView ?? UITableView(), cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual((sortCell as? MECProductSortCell)?.sortRadioButton.isSelected, false)
        
        filter.sortType = nil
        filter.stockLevels = [.inStock]
        sortCell = productSortProvider.tableView(productSortProvider.sortTableView ?? UITableView(), cellForRowAt: mockIndexPath)
        XCTAssertNotNil(sortCell)
        XCTAssertTrue(sortCell is MECProductSortCell)
        XCTAssertEqual((sortCell as? MECProductSortCell)?.sortRadioButton.accessibilityIdentifier, "mec_\(ECSPILSortType.allCases[mockIndexPath.row])_radio_button")
        XCTAssertEqual((sortCell as? MECProductSortCell)?.sortRadioButton.isSelected, false)
    }
    
    func testCellForRowAtIndexPathWithRowOutOfBounds() {
        let tableView = UITableView()
        productSortProvider.registerCell(for: tableView)
        
        var mockIndexPath = IndexPath(row: 0, section: 2)
        var sortCell = productSortProvider.tableView(productSortProvider.sortTableView ?? UITableView(), cellForRowAt: mockIndexPath)
        
        XCTAssertNotNil(sortCell)
        XCTAssertTrue(sortCell is MECProductSortCell)
        XCTAssertEqual((sortCell as? MECProductSortCell)?.sortLabel.accessibilityIdentifier, "mec_\(ECSPILSortType.allCases[mockIndexPath.row])_label")
        
        mockIndexPath = IndexPath(row: 5, section: 0)
        sortCell = productSortProvider.tableView(productSortProvider.sortTableView ?? UITableView(), cellForRowAt: mockIndexPath)
        XCTAssertNotNil(sortCell)
        XCTAssertFalse(sortCell is MECProductSortCell)
    }
    
    func testDidSelectRowAtIndexPath() {
        let mockIndexPath = IndexPath(row: 2, section: 0)
        productSortProvider.tableView(productSortProvider.sortTableView ?? UITableView(), didSelectRowAt: mockIndexPath)
        
        XCTAssertEqual(productSortProvider.appliedFilter.sortType, ECSPILSortType.allCases[mockIndexPath.row])
    }
    
    func testDidSelectRowAtIndexPathWithRowOutOfBounds() {
        let mockIndexPath = IndexPath(row: 5, section: 0)
        productSortProvider.tableView(productSortProvider.sortTableView ?? UITableView(), didSelectRowAt: mockIndexPath)
        
        XCTAssertNil(productSortProvider.appliedFilter.sortType)
    }
    
    func testDidSelectSortOption() {
        let mockFilter = ECSPILProductFilter()
        mockFilter.sortType = .discountPriceAscending
        var mockIndex = 2
        
        productSortProvider.didSelectSortOption(index: mockIndex)
        XCTAssertEqual(productSortProvider.appliedFilter.sortType, ECSPILSortType.allCases[mockIndex])
        
        mockIndex = 5
        productSortProvider.didSelectSortOption(index: mockIndex)
        XCTAssertEqual(productSortProvider.appliedFilter.sortType, ECSPILSortType.allCases[2])
        
        mockIndex = 2
        productSortProvider.didSelectSortOption(index: mockIndex)
        XCTAssertEqual(productSortProvider.appliedFilter.sortType, ECSPILSortType.allCases[mockIndex])
        
        mockIndex = 3
        productSortProvider.didSelectSortOption(index: mockIndex)
        XCTAssertEqual(productSortProvider.appliedFilter.sortType, ECSPILSortType.allCases[mockIndex])
    }
}
