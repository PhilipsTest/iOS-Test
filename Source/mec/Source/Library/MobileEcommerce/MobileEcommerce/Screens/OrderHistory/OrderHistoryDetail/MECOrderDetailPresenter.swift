/* Copyright (c) Koninklijke Philips N.V., 2020
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import UIKit
import PhilipsEcommerceSDK
import PhilipsPRXClient

class MECOrderDetailPresenter: NSObject {

    var orderHistoryDetail: ECSOrderDetail
    var prxManager: MECPRXHandler?
    var cdls: PRXCDLSResponse?

    init(with orderDetail: ECSOrderDetail) {
        orderHistoryDetail = orderDetail
        prxManager = MECPRXHandler()
    }

    func numberOfProductInCart() -> Int {
        return orderHistoryDetail.entries?.count ?? 0
    }

    func totalTax() -> String {
        return orderHistoryDetail.totalTax?.formattedValue ?? ""
    }

    func totalPrice() -> String {
        return orderHistoryDetail.totalPriceWithTax?.formattedValue ?? ""
    }

    func fetchCDLSDetailfor(_ completionHandler: @escaping (_ productFeatures: PRXCDLSResponse?) -> Void) {
        guard let productCategory = orderHistoryDetail.entries?.first?.product?.productPRXSummary?.subcategory else {
            completionHandler(nil)
            return
        }
        prxManager?.fetchCDLSDetailfor(category: productCategory,
                                           requestManager: prxManager?.fetchPRXRequestManager()) {[weak self] (response) in
                                            self?.cdls = response
                                            completionHandler(self?.cdls)
        }
    }

    func trakinURL(at index: Int) -> URL? {
        guard let consignementEntries = orderHistoryDetail.consignments?.first?.entries,
            consignementEntries.count > index,
            let trackingURL = consignementEntries[index].trackAndTraceUrls?.first else {
            return nil
        }
        guard let formattedURL = formatTrackingURL(trackingURL: trackingURL,
                                                   trackingID: consignementEntries[index].trackAndTraceIDs?.first) else {
            return nil
        }
        return formattedURL
    }

    private func formatTrackingURL(trackingURL: String?, trackingID: String?) -> URL? {
        guard let urlString = trackingURL, let trackingID = trackingID else { return nil }
        let trackingURL = urlString.replacingOccurrences(of: "{\(trackingID)=", with: "").replacingOccurrences(of: "}", with: "")
        guard let url = URL(string: trackingURL) else { return nil }

        return url
    }
}
