/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import MobileEcommerceDev
import PhilipsEcommerceSDK

class MockFilterDelegate: NSObject, MECProductFilterDelegate {
    
    var applyFilterCalled = false
    
    func didSelectApplyFilter(filter: ECSPILProductFilter) {
        applyFilterCalled = true
    }
    
    func filterScreenDismissed() {}
}

class MECProductFilterViewControllerTests: XCTestCase {

    var sut: MECProductFilterViewController!
    
    override func setUp() {
        super.setUp()
        sut = MECProductFilterViewController.instantiateFromAppStoryboard(appStoryboard: .productFilter)
    }
    
    override func tearDown()  {
        super.tearDown()
        sut = nil
    }

    func testViewDidload() {
        let filter = ECSPILProductFilter()
        filter.stockLevels = [.inStock, .outOfStock]
        sut.appliedFilter = filter
        
        _ = sut.view
        XCTAssertEqual(sut.temporaryAppliedFilter.stockLevels, filter.stockLevels)
    }
    
    func testisNewFilterApplied() {
        let filter = ECSPILProductFilter()
        filter.stockLevels = [.inStock, .outOfStock]
        filter.sortType = .priceAscending
        sut.appliedFilter = filter
        
        let delegate = MockFilterDelegate()
        sut.filterDelegate = delegate
            
        _ = sut.view
        
        sut.temporaryAppliedFilter.stockLevels = [.inStock, .outOfStock]
        sut.temporaryAppliedFilter.sortType = .priceAscending
        XCTAssertFalse(sut.isNewFilterApplied())
        
        sut.temporaryAppliedFilter.stockLevels = [.outOfStock, .inStock]
        XCTAssertFalse(sut.isNewFilterApplied())
        
        sut.temporaryAppliedFilter.stockLevels = [.inStock, .lowStock]
        XCTAssertTrue(sut.isNewFilterApplied())
        
        sut.temporaryAppliedFilter.stockLevels = [.lowStock, .outOfStock]
        XCTAssertTrue(sut.isNewFilterApplied())
        
        sut.temporaryAppliedFilter.stockLevels = []
        XCTAssertTrue(sut.isNewFilterApplied())
        
        sut.temporaryAppliedFilter.stockLevels = [.inStock, .outOfStock]
        sut.temporaryAppliedFilter.sortType = .priceDescending
        XCTAssertTrue(sut.isNewFilterApplied())
        
        sut.temporaryAppliedFilter.sortType = nil
        XCTAssertTrue(sut.isNewFilterApplied())
        
        sut.temporaryAppliedFilter.stockLevels = nil
        XCTAssertTrue(sut.isNewFilterApplied())
        
        sut.appliedFilter.stockLevels = nil
        XCTAssertTrue(sut.isNewFilterApplied())
        
        sut.appliedFilter.sortType = nil
        XCTAssertFalse(sut.isNewFilterApplied())
    }
    
    func testApplyButtonClicked() {
        let filter = ECSPILProductFilter()
        filter.stockLevels = [.inStock, .outOfStock]
        sut.appliedFilter = filter
        
        let delegate = MockFilterDelegate()
        sut.filterDelegate = delegate
        
        _ = sut.view
        
        sut.temporaryAppliedFilter.stockLevels = [.outOfStock, .inStock]
        XCTAssertFalse(sut.isNewFilterApplied())
        sut.applyButtonClicked(UIButton())
        XCTAssertFalse(delegate.applyFilterCalled)
        
        sut.temporaryAppliedFilter.stockLevels = [.inStock, .lowStock]
        XCTAssertTrue(sut.isNewFilterApplied())
        sut.applyButtonClicked(UIButton())
        XCTAssertTrue(delegate.applyFilterCalled)
    }
    
    
    func testClearButtonClicked() {
        let filter = ECSPILProductFilter()
        filter.stockLevels = [.inStock, .outOfStock]
        sut.appliedFilter = filter
        
        _ = sut.view
        XCTAssertEqual(sut.temporaryAppliedFilter.stockLevels, filter.stockLevels)
        sut.clearButtonClicked(UIButton())
        XCTAssertNotEqual(sut.temporaryAppliedFilter.stockLevels, filter.stockLevels)
    }
}

// MARK: ECSPILProductFilter Extension Test cases

extension MECProductFilterViewControllerTests {
    
    func testIsFilterApplied() {
        let filter = ECSPILProductFilter()
        filter.sortType = .priceAscending
        filter.stockLevels = [.inStock]
        
        XCTAssertTrue(filter.isFilterApplied)
        
        filter.sortType = nil
        filter.stockLevels = []
        XCTAssertFalse(filter.isFilterApplied)
        
        filter.stockLevels = [.inStock]
        XCTAssertTrue(filter.isFilterApplied)
        
        filter.sortType = .topRated
        filter.stockLevels = []
        XCTAssertTrue(filter.isFilterApplied)
        
        filter.stockLevels = nil
        XCTAssertTrue(filter.isFilterApplied)
        
        filter.sortType = nil
        XCTAssertFalse(filter.isFilterApplied)
    }
    
    func testCreateCopy() {
        let filter = ECSPILProductFilter()
        filter.sortType = .topRated
        filter.stockLevels = [.inStock]
        
        let copyFilter = filter.createCopy()
        XCTAssertEqual(filter === copyFilter, false)
        XCTAssertEqual(filter.sortType == copyFilter.sortType, true)
        XCTAssertEqual(filter.stockLevels == copyFilter.stockLevels, true)
        
        filter.sortType = nil
        filter.stockLevels = nil
        let copyFilterSecond = filter.createCopy()
        XCTAssertNil(copyFilterSecond.sortType)
        XCTAssertNotNil(copyFilterSecond.stockLevels)
        XCTAssertEqual(copyFilterSecond.stockLevels?.count, 0)
    }
    
    func testClearAllFilter() {
        let filter = ECSPILProductFilter()
        filter.sortType = .topRated
        filter.stockLevels = [.inStock]
        
        filter.clearAllFilter()
        XCTAssertNil(filter.sortType)
        XCTAssertNotNil(filter.stockLevels)
        XCTAssertEqual(filter.stockLevels?.count, 0)
        XCTAssertNotNil(filter)
        
        filter.stockLevels = nil
        filter.clearAllFilter()
        XCTAssertNil(filter.sortType)
        XCTAssertNil(filter.stockLevels)
        XCTAssertNotNil(filter)
    }
}
