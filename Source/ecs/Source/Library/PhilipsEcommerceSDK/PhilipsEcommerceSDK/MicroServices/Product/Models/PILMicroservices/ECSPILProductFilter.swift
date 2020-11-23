/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

public enum ECSPILSortType: String, CaseIterable {
    case priceAscending             = "price"
    case priceDescending            = "-price"
    case discountPriceAscending     = "discountPercentage"
    case discountPriceDescending    = "-discountPercentage"
    case topRated                   = "topRated"
}

public enum ECSPILStockLevel: String, CaseIterable {
    case inStock            = "IN_STOCK"
    case lowStock           = "LOW_STOCK"
    case outOfStock         = "OUT_OF_STOCK"
}

public class ECSPILProductFilter: NSObject {
    public var sortType: ECSPILSortType?
    public var stockLevels: Set<ECSPILStockLevel>?
}

internal extension ECSPILProductFilter {

    func getStockFilterList() -> String? {
        guard let stockLevels = stockLevels else { return nil }
        var stockFilter: [String] = []
        for stock in stockLevels {
            stockFilter.append(stock.rawValue)
        }
        return stockFilter.joined(separator: ",")
    }

    func getFilterParamerter() -> [String: String] {
        return ["sort": self.sortType?.rawValue,
                "stockLevel": getStockFilterList()].compactMapValues { $0 }
    }
}
