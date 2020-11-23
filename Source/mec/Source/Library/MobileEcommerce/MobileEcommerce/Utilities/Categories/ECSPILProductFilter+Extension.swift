/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsEcommerceSDK

extension ECSPILProductFilter {
    var isFilterApplied: Bool {
        return ((stockLevels?.count ?? 0) > 0 || sortType != nil)
    }

    func createCopy() -> ECSPILProductFilter {
        let copy = ECSPILProductFilter()
        copy.stockLevels = self.stockLevels ?? []
        copy.sortType = self.sortType
        return copy
    }

    func clearAllFilter() {
        self.stockLevels?.removeAll()
        self.sortType = nil
    }
}
