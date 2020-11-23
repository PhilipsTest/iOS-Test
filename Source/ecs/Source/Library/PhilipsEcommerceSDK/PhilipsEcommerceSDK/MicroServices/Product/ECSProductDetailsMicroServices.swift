/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsPRXClient

class ECSProductDetailsMicroServices: NSObject, ECSServiceDiscoveryURLDownloader {

    func fetchECSProductDetailsFor(product: ECSPILProduct,
                                   completionHandler: @escaping ECSPILProductDetailsFetchCompletion) {
        guard let ctn = product.productPRXSummary?.ctn else {
            completionHandler(product, ECSPILHybrisErrors(errorType: .ECSCtnNotProvided).hybrisPILError)
            return
        }
        let groupCall = DispatchGroup()
        var fetchError: Error?

        groupCall.enter()
        fetchProductAssetsFor(CTN: ctn) { (assets, error) in
            product.productAssets = assets
            fetchError = error
            groupCall.leave()
        }

        groupCall.enter()
        fetchProductDiscaimersFor(CTN: ctn) { (disclaimers, _) in
            product.productDisclaimers = disclaimers
            groupCall.leave()
        }

        groupCall.notify(queue: .main) {
            completionHandler(product, fetchError)
        }
    }

    func fetchProductAssetsFor(CTN: String,
                               completionHandler: @escaping (_ data: PRXAssetData?, _ error: Error?) -> Void) {
        guard ECSConfiguration.shared.appInfra != nil else {
            completionHandler(nil, ECSHybrisError(with: .ECSAppInfraNotFound).hybrisError)
            return
        }
        let assetRequest = PRXAssetRequest(sector: B2C, ctnNumber: CTN, catalog: CONSUMER)
        ECSUtility.getPRXRequestManager().execute(assetRequest, completion: { (assetList) in
            guard let passedInData = assetList as? PRXAssetResponse, passedInData.success else {
                completionHandler(nil, nil)
                return
            }
            self.filterAssetType(for: passedInData.data)
            completionHandler(passedInData.data, nil)
        }, failure: { (error) in
            completionHandler(nil, error)
        })
    }

    func fetchProductDiscaimersFor(CTN: String,
                                   completionHandler: @escaping (_ data: PRXDisclaimerData?, _ error: Error?) -> Void) {
        guard ECSConfiguration.shared.appInfra != nil else {
            completionHandler(nil, ECSHybrisError(with: .ECSAppInfraNotFound).hybrisError)
            return
        }
        let disclaimerRequest = PRXDisclaimerRequest(sector: B2C, ctnNumber: CTN, catalog: CONSUMER)
        ECSUtility.getPRXRequestManager().execute(disclaimerRequest, completion: { (disclaimerData) in
            guard let passedInData = disclaimerData as? PRXDisclaimerResponse, passedInData.success else {
                completionHandler(nil, nil)
                return
            }
            completionHandler(passedInData.data, nil)
        }, failure: { (error) in
            completionHandler(nil, error)
        })
    }

    func fetchProductSummaryFor(ctns: [String],
                                completionHandler: @escaping (_ data: PRXSummaryListResponse?, _ error: Error?) -> Void) {
        guard ECSConfiguration.shared.appInfra != nil else {
            completionHandler(nil, ECSHybrisError(with: .ECSAppInfraNotFound).hybrisError)
            return
        }
        let trimmedCTNs = ctns.filter({ $0.count > 0 })
        guard trimmedCTNs.count > 0 else {
            completionHandler(nil, ECSHybrisError().hybrisError)
            return
        }

        let summaryRequest = PRXSummaryListRequest(sector: B2C, ctnNumbers: ctns, catalog: CONSUMER)
        ECSUtility.getPRXRequestManager().execute(summaryRequest, completion: { (summaryList) in
            guard let passedInData = summaryList as? PRXSummaryListResponse, passedInData.success else {
                completionHandler(nil, nil)
                return
            }
            let commaSeparatedInvalidCtns = self.commaSeparatedInvalidCTNs(invalidCTNs: passedInData.invalidCTNs)
            if commaSeparatedInvalidCtns.count > 0 {
                // swiftlint:disable line_length
                ECSConfiguration.shared.ecsLogger?.log(.verbose,
                                                       eventId: "ECSPRXSummaryResponse",
                                                       message: "\(commaSeparatedInvalidCtns) CTN(s) are not valid for the locale \(ECSConfiguration.shared.locale ?? "")")
                // swiftlint:enable line_length
            }
            completionHandler(passedInData, nil)
        }, failure: { (error) in
            completionHandler(nil, error)
        })
    }
}

extension ECSProductDetailsMicroServices {

    func filterAssetType(for assets: PRXAssetData?) {
        let permittedAssetTypes = [ECSPermittedAssetType.RTP.rawValue, ECSPermittedAssetType.APP.rawValue,
                                   ECSPermittedAssetType.DPP.rawValue, ECSPermittedAssetType.MI1.rawValue,
                                   ECSPermittedAssetType.PID.rawValue]
        assets?.assets?.asset?.removeAll { !permittedAssetTypes.contains(($0 as? PRXAssetAsset)?.type ?? "") }
    }

    func commaSeparatedInvalidCTNs(invalidCTNs: [Any]) -> String {
        guard let invalidCTNs = invalidCTNs as? [String] else {
            return ""
        }
        let formattedCTNs = invalidCTNs.filter({ $0.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 })
        guard formattedCTNs.count > 0 else {
            return ""
        }
        return formattedCTNs.joined(separator: ",")
    }
}
