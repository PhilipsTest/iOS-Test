/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
@testable import MobileEcommerceDev
import PhilipsEcommerceSDK
class PaginationHelperTests: XCTestCase {

    var sut: MECPaginationHelper!
    
    override func setUp() {
        super.setUp()
        sut = MECPaginationHelper()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testhaveMoreProductsToLoadWhileFetchingInProgress() {
        let paginationModel = ECSPagination()
        paginationModel.currentPage = 1
        paginationModel.totalPages = 4
        sut.paginationModel = paginationModel
        sut.isDataFetching = true
        XCTAssertFalse(sut.haveMoreProductsToLoad())
    }
    
    func testhaveMoreProductsToLoadWhileFetchingNotInProgress() {
        let paginationModel = ECSPagination()
        paginationModel.currentPage = 1
        paginationModel.totalPages = 4
        sut.paginationModel = paginationModel
        sut.isDataFetching = false
        XCTAssertTrue(sut.haveMoreProductsToLoad())
    }
    
    func testhaveMoreProductToLoadTrueCase1() {
        let paginationModel = ECSPagination()
        paginationModel.currentPage = 0
        paginationModel.totalPages = 2
        sut.paginationModel = paginationModel
        sut.isDataFetching = false
        XCTAssertTrue(sut.haveMoreProductsToLoad())
    }
    
    func testhaveMoreProductToLoadTrueCase2() {
        let paginationModel = ECSPagination()
        paginationModel.currentPage = 18
        paginationModel.totalPages = 20
        sut.paginationModel = paginationModel
        sut.isDataFetching = false
        XCTAssertTrue(sut.haveMoreProductsToLoad())
    }
    
    func testhaveMoreProductToLoadTrueCase3() {
        let paginationModel = ECSPagination()
        paginationModel.currentPage = 98
        paginationModel.totalPages = 100

        sut.paginationModel = paginationModel
        sut.isDataFetching = false
        XCTAssertTrue(sut.haveMoreProductsToLoad())
    }
    
    func testhaveMoreProductToLoadFalseCase1() {
        let paginationModel = ECSPagination()
        paginationModel.currentPage = 0
        paginationModel.totalPages = 0

        sut.paginationModel = paginationModel
        sut.isDataFetching = false
        XCTAssertFalse(sut.haveMoreProductsToLoad())
    }
    
    func testhaveMoreProductToLoadFalseCase2() {
        let paginationModel = ECSPagination()
        paginationModel.currentPage = 0
        paginationModel.totalPages = 1

        sut.paginationModel = paginationModel
        sut.isDataFetching = false
        XCTAssertFalse(sut.haveMoreProductsToLoad())
    }
    
    func testhaveMoreProductToLoadFalseCase3() {
        let paginationModel = ECSPagination()
        paginationModel.currentPage = 0
        paginationModel.totalPages = -1

        sut.paginationModel = paginationModel
        sut.isDataFetching = false
        XCTAssertFalse(sut.haveMoreProductsToLoad())
    }
    
    func testhaveMoreProductToLoadFalseCase4() {
        sut.isDataFetching = false
        XCTAssertFalse(sut.haveMoreProductsToLoad())
    }
    
    func testGetNextPageWithoutPaginationModel() {
        sut.paginationModel = nil
        XCTAssertEqual(sut.getNextPage(), 0)
    }
    
    func testGetNextPageWithPaginationModel() {
        let paginationModel = ECSPagination()
        paginationModel.currentPage = 0
        paginationModel.totalPages = 1

        sut.paginationModel = paginationModel
        XCTAssertEqual(sut.getNextPage(), 1)
    }
}
