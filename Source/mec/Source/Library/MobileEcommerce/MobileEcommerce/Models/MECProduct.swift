/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsEcommerceSDK
import BVSDK
import PhilipsPRXClient

class MECProduct: NSObject {

    fileprivate(set) var product: ECSPILProduct?
    var productReviews: [BVReview]? = []
    var totalNumberOfReviews: NSNumber?
    var averageRating: NSNumber?
    var isAllReviewsDownloaded: Bool = false
    var isDownloadingReviews: Bool = false
    var retailers: ECSRetailerList?
    var productSpecs: PRXSpecificationsChapter?
    var productFeatures: PRXFeaturesData?

    init(product: ECSPILProduct) {
        super.init()
        self.product = product
    }
}

// MARK: Utility methods for MECProduct

extension MECProduct {

    func fetchProductCTN() -> String {
        return (product?.ctn ?? product?.productPRXSummary?.ctn) ?? ""
    }
}
