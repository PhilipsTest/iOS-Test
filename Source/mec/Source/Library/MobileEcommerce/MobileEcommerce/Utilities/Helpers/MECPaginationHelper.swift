/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsEcommerceSDK

class MECPaginationHelper: NSObject {

    var paginationModel: ECSPagination?
    var isDataFetching: Bool = false

    func getNextPage() -> Int {
        guard let currentPage = paginationModel?.currentPage else { return 0 }
        return currentPage + 1
    }

    func haveMoreProductsToLoad() -> Bool {

        guard false == self.isDataFetching else { return false }

        if let pagination = paginationModel, let currentPage = pagination.currentPage, let totalPages = pagination.totalPages {
            return (currentPage + 1 < totalPages)
        }
        return false
    }
}
