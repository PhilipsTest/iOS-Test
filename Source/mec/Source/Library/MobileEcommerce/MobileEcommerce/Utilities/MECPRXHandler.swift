/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsPRXClient

class MECPRXHandler: NSObject {

    func fetchPRXRequestManager() -> PRXRequestManager? {
        let sharedAppInfra = MECConfiguration.shared.sharedAppInfra
        let prxDependencies = PRXDependencies(appInfra: sharedAppInfra, parentTLA: MECConstants.MECTLA)
        let requestManager = PRXRequestManager(dependencies: prxDependencies)
        return requestManager
    }

    func fetchProductSpecsFor(CTN: String,
                              requestManager: PRXRequestManager?,
                              completionHandler: @escaping (_ productSpecs: PRXSpecificationsResponse?) -> Void) {
        let productSpecRequest = PRXSpecificationsRequest(sector: B2C, ctnNumber: CTN, catalog: CONSUMER)
        requestManager?.execute(productSpecRequest, completion: { (specResponse) in
            guard let specs = specResponse as? PRXSpecificationsResponse, specs.success else {
                completionHandler(nil)
                return
            }
            completionHandler(specs)
        }, failure: { (_) in
            completionHandler(nil)
        })
    }

    func fetchProductFeaturesFor(CTN: String,
                                 requestManager: PRXRequestManager?,
                                 completionHandler: @escaping (_ productFeatures: PRXFeaturesResponse?) -> Void) {
        let productFeaturesRequest = PRXFeaturesRequest(sector: B2C, ctnNumber: CTN, catalog: CONSUMER)
        requestManager?.execute(productFeaturesRequest, completion: { (featuresResponse) in
            guard let features = featuresResponse as? PRXFeaturesResponse, features.success else {
                completionHandler(nil)
                return
            }
            completionHandler(features)
        }, failure: { (_) in
            completionHandler(nil)
        })
    }

    func fetchCDLSDetailfor(category: String,
                            requestManager: PRXRequestManager?,
                            completionHandler: @escaping (_ productFeatures: PRXCDLSResponse?) -> Void) {

        let cdlsRequest = PRXCDLSRequest(sector: B2C, category: category, catalog: CARE)
        requestManager?.execute(cdlsRequest, completion: { (cdlsResponse) in
            guard let cdlsDetails = cdlsResponse as? PRXCDLSResponse, cdlsDetails.success else {
                completionHandler(nil)
                return
            }
            completionHandler(cdlsDetails)
        }, failure: { (_) in
            completionHandler(nil)
        })
    }
}
