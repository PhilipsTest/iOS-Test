/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPPaginationModel {
    
    fileprivate var currentPage = 0
    fileprivate var totalPages  = 1
    fileprivate var pageSize    = 20
    fileprivate var totalResults = 0
    fileprivate var isFetching:Bool = false
    
    init (inDict: [String: AnyObject]) {
        guard let currentPageValue = inDict[IAPConstants.IAPPaginationKeys.kCurrentPageKey] as? Int,
              let totalPagevalue = inDict[IAPConstants.IAPPaginationKeys.kTotalPagesKey] as? Int,
              let pageSizeValue = inDict[IAPConstants.IAPPaginationKeys.kPageSizeKey] as? Int,
              let totalResultValue = inDict[IAPConstants.IAPPaginationKeys.kTotalResultKey] as? Int else { return }
        
        self.currentPage = currentPageValue
        self.totalPages = totalPagevalue
        self.pageSize = pageSizeValue
        self.totalResults = totalResultValue
    }
    
    func getCurrentPage()->Int {
        return self.currentPage
    }
    
    func getTotalPages()->Int {
        return self.totalPages
    }
    
    func getPageSize()->Int {
        return self.pageSize
    }
    
    func setIsFecthing(_ isFetchingValue:Bool) {
        self.isFetching = isFetchingValue
    }
    
    func isDataPending()->Bool {
        guard false == self.isFetching else { return false }
        return (self.currentPage+1 < self.totalPages)
    }
}
