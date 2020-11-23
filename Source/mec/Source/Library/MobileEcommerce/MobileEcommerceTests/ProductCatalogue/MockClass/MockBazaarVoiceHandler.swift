/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

@testable import MobileEcommerceDev
import BVSDK

class MockBazaarVoiceHandler: BazaarVoiceHandler {
    var reviewAndRatingStatistics: [BVProductStatistics]?
    var reviews: [BVReview]?
    var reviewsError: [NSError]?
    
    override func fetchBulkRatingsFor(productCTNs: [String], bulkRatingsCompletionHandler: @escaping ([BVProductStatistics]?) -> Void) {
        bulkRatingsCompletionHandler(reviewAndRatingStatistics)
    }
    
    override func fetchAllReviewsFor(productCTN: String, limit: UInt = MECConstants.MECProductReviewsDownloadLimit,
                                     offset: UInt,
                                     reviewsCompletionHandler: @escaping ([BVReview]?, [NSError]?) -> Void) {
        reviewsCompletionHandler(reviews, reviewsError)
    }
}
