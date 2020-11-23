/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import BVSDK
import AppInfra

class BulkRating: NSObject {
    var averageRating: NSNumber?
    var totalReviewCount: NSNumber?
}

class BazaarVoiceHandler: NSObject, MECAnalyticsTracking {

    static let sharedInstance = BazaarVoiceHandler()

    func configureBazaarVoice(bazaarVoiceEnvironment: MECBazaarVoiceEnvironment?) {
        let environment = bazaarVoiceEnvironment ?? .staging
        let clientID = MECConfiguration.shared.bazaarVoiceClientID ?? "philipsglobal"
        let apiKeyConversations = MECConfiguration.shared.bazaarVoiceConversationAPIKey ??
            (environment == .production ?
                "caAyWvBUz6K3xq4SXedraFDzuFoVK71xMplaDk1oO5P4E" :
                "ca23LB5V0eOKLe0cX6kPTz6LpAEJ7SGnZHe21XiWJcshc")
        let configDict = [MECBazaarVoiceConstants.MECClientIDKey: clientID,
                          MECBazaarVoiceConstants.MECApiKeyConversationsKey: apiKeyConversations]
        BVSDKManager.configure(withConfiguration: configDict, configType: environment == .production ? .prod : .staging)
        BVSDKManager.shared().setLogLevel(.error)
    }

    func fetchAllReviewsFor(productCTN: String,
                            limit: UInt = MECConstants.MECProductReviewsDownloadLimit,
                            offset: UInt,
                            reviewsCompletionHandler: @escaping ([BVReview]?, _ error: [NSError]?) -> Void) {
        let formattedCTN = productCTN.replacingOccurrences(of: "/", with: "_")
        let locale = MECConfiguration.shared.locale ?? ""
        let fetchReviewsRequest = BVReviewsRequest(productId: formattedCTN, limit: limit, offset: offset)
            .sort(by: .reviewSubmissionTime, monotonicSortOrderValue: .descending)
            .filter(on: .contentLocale, relationalFilterOperatorValue: .equalTo, value: locale)
        fetchReviewsRequest.addCustomDisplayParameter(MECBazaarVoiceConstants.MECFilteredStatsKey,
                                                      withValue: MECBazaarVoiceConstants.MECReviews)
        fetchReviewsRequest.addCustomDisplayParameter(MECBazaarVoiceConstants.MECLocaleKey, withValue: locale)
        fetchReviewsRequest.load({ (response) in
            reviewsCompletionHandler(response.results, nil)
        }, failure: { [weak self] errors in
            self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.fetchAllReviewsForCTN,
                                serverName: MECAnalyticServer.bazaarVoice,
                                error: errors.first as NSError?)

            reviewsCompletionHandler(nil, errors as [NSError])
        })
    }

    func fetchBulkRatingsFor(productCTNs: [String], bulkRatingsCompletionHandler: @escaping ([BVProductStatistics]?) -> Void) {
        let formattedCTNs = productCTNs.map { $0.replacingOccurrences(of: "/", with: "_") }
        let locale = MECConfiguration.shared.locale ?? ""
        let fetchBulkRatingsRequest = BVBulkRatingsRequest(productIds: formattedCTNs, statistics: .bulkRatingAll)
            .filter(on: .bulkRatingContentLocale, relationalFilterOperatorValue: .equalTo, value: locale)
        fetchBulkRatingsRequest.addCustomDisplayParameter(MECBazaarVoiceConstants.MECLocaleKey, withValue: locale)
        fetchBulkRatingsRequest.load({ (response) in
            let productRatings = response.results
            if productRatings.count > 0 {
                productRatings.forEach { $0.productId = $0.productId?.replacingOccurrences(of: "_", with: "/") }
            }
            bulkRatingsCompletionHandler(productRatings)
        }, failure: { [weak self] errors in
            self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.fetchBulkRatingsForCTNList,
                                     serverName: MECAnalyticServer.bazaarVoice,
                                     error: errors.first as NSError?)
            bulkRatingsCompletionHandler(nil)
        })
    }
}
