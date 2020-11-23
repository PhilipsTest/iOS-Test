/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

@testable import MobileEcommerceDev

class MockPaginationHelper: MECPaginationHelper {
    var nextPage: Int = 0
    var haveMoreProduct: Bool = false
    
    override func getNextPage() -> Int {
        return nextPage
    }
    
    override func haveMoreProductsToLoad() -> Bool {
        return haveMoreProduct
    }
}
