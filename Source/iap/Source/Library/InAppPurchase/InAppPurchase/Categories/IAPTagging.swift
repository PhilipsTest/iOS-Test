/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import Foundation

protocol IAPAnalyticsTracking: NSObjectProtocol {
    func trackPage(pageName: String)
    func trackAction(parameterData: [String: Any], action: String)
}

extension IAPAnalyticsTracking {
    func fetchAdditionalFields() -> [String: Any] {
        var params: [String: Any] = [:]
        if let country = IAPConfiguration.sharedInstance.sharedAppInfra.serviceDiscovery.getHomeCountry() {
            params[IAPAnalyticsConstants.country] = country

            if let currency = Locale.currency[country]?.symbol {
                params[IAPAnalyticsConstants.currency] = currency
            }
        }
        return params
    }
    
    func trackPage(pageName: String) {
        let params = fetchAdditionalFields()
        IAPConfiguration.sharedInstance.iapAppTagging?.trackPage(withInfo: pageName, params: params)
    }
    
    func trackAction(parameterData: [String: Any], action: String) {
        var parameters = parameterData
        let params = fetchAdditionalFields()
        for (key, value) in params {
            parameters.updateValue(value, forKey: key)
        }
        IAPConfiguration.sharedInstance.iapAppTagging?.trackAction(withInfo: action, params: parameters)
    }
}
