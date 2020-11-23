/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsEcommerceSDK

protocol MECViewControllerDismissDelegate: NSObjectProtocol {
    func viewControllerDidDismiss()
}

protocol MECAnalyticsTracking {
    func trackPage(pageName: String, paramDict: [String: Any])
    func trackAction(parameterData: [String: Any], action: String)
    func trackExitLink(exitURL: URL)
    func prepareProductString(productList: [MECProduct]?) -> String
    func prepareCartEntryListString(entries: [ECSEntry]?, updatedQuantity: Int?) -> String
    func trackTechnicalError(errorCategory: String, serverName: String, error: Error?)
    func trackNotification(message: String, response: String?)
    func preparePILCartEntryListString(entries: [ECSPILItem]?, updatedQuantity: Int?) -> String
}

extension MECAnalyticsTracking {

    func trackNotification(message: String, response: String?) {
        var param = [MECAnalyticsConstants.inappnotification: message]
        if let inAppResponse = response {
            param.updateValue(inAppResponse, forKey: MECAnalyticsConstants.inappnotificationresponse)
        }
        trackAction(parameterData: param)
    }

    func trackInformationalError(errorMessage: String?) {
        guard let message = errorMessage  else { return }
        let errorString = "MEC:\(MECAnalyticErrorCategory.informationalError):\(message)"
        trackAction(parameterData: [MECAnalyticsConstants.informationalError: errorString])
    }

    func trackUserError(errorMessage: String?) {
        guard let message = errorMessage  else { return }
        let errorString = "MEC:\(MECAnalyticErrorCategory.userError):\(message)"
        trackAction(parameterData: [MECAnalyticsConstants.userError: errorString])
    }

    func trackTechnicalError(errorCategory: String, serverName: String, error: Error?) {
        let errorMessage = error?.localizedDescription ?? ""
        let errorCode = error?.code ?? 0
        let errorString = "MEC:\(errorCategory):\(serverName):\(errorMessage):\(errorCode)"
        trackAction(parameterData: [MECAnalyticsConstants.technicalError: errorString])
    }

    func trackPage(pageName: String, paramDict: [String: Any] = [:]) {
        var parameter = paramDict
        for (key, value) in getAdditionalFields() {
            parameter.updateValue(value, forKey: key)
        }
        if let productString = parameter[MECAnalyticsConstants.productListKey] as? String,
        productString.isEmpty {
            parameter.removeValue(forKey: MECAnalyticsConstants.productListKey)
        }
        MECConfiguration.shared.mecTagging?.trackPage(withInfo: pageName, params: parameter)
    }

    func trackAction(parameterData: [String: Any], action: String = MECAnalyticEvents.sendData) {
        var parameter = parameterData
        for (key, value) in getAdditionalFields() {
            parameter.updateValue(value, forKey: key)
        }
        if let productString = parameter[MECAnalyticsConstants.productListKey] as? String,
        productString.isEmpty {
            parameter.removeValue(forKey: MECAnalyticsConstants.productListKey)
        }
        MECConfiguration.shared.mecTagging?.trackAction(withInfo: action, params: parameter)
    }

    func trackExitLink(exitURL: URL) {
        if let taggingURL = appendStatusCodeForExitLink(exitLink: exitURL) {
            var param = getAdditionalFields()
            param[MECAnalyticsConstants.exitLinkNameKey] = taggingURL.absoluteString
            MECConfiguration.shared.mecTagging?.trackAction(withInfo: MECAnalyticEvents.sendData, params: param)
        }
    }

    private func appendStatusCodeForExitLink(exitLink: URL) -> URL? {
        var taggingURL: URL?
        if let appName = MECConfiguration.shared.sharedAppInfra.appIdentity.getAppName(),
            let locale = MECConfiguration.shared.sharedAppInfra.internationalization.getUILocaleString() {
            let exitLinkQueryItem = URLQueryItem(name: "origin", value: "15_global_\(locale)_\(appName)-app_\(appName)-app")
            var retailerURLComponents = URLComponents(url: exitLink, resolvingAgainstBaseURL: false)
            if let retailerQueryComponents = retailerURLComponents?.queryItems, retailerQueryComponents.count > 0 {
                retailerURLComponents?.queryItems?.append(exitLinkQueryItem)
            } else {
                retailerURLComponents?.queryItems = [exitLinkQueryItem]
            }
            taggingURL = retailerURLComponents?.url
        }
        return taggingURL
    }

    func getAdditionalFields() -> [String: Any] {
        var param: [String: Any] = [:]
        if let country = MECConfiguration.shared.sharedAppInfra.serviceDiscovery.getHomeCountry() {
            param[MECAnalyticsConstants.country] = country

            if let currency = Locale.currency[country]?.symbol {
                param[MECAnalyticsConstants.currency] = currency
            }
        }
        return param
    }

    func prepareCartEntryListString(entries: [ECSEntry]?, updatedQuantity: Int? = nil) -> String {
        guard let entryList = entries, entryList.count > 0 else { return "" }

        let category = MECConfiguration.shared.productCategory ?? MECConfiguration.shared.rootCategory ?? MECAnalyticsConstants.retailer
        var productStringList: [String] = []
        for entry in entryList {
            let productCTN = entry.product?.ctn ?? ""
            var priceValue = 0.0
            if let discountedPrice = entry.basePrice, entry.product?.price?.value != discountedPrice.value {
                priceValue = discountedPrice.value ?? 0.0
            } else {
                priceValue = entry.product?.price?.value ?? 0.0
            }
            let quantity = (updatedQuantity ?? entry.quantity) ?? 0
            priceValue *= Double(quantity)
            let price = String(format: "%.2f", priceValue).replacingOccurrences(of: ",", with: ".")
            productStringList.append("\(category);\(productCTN);\(quantity);\(price)")
        }
        return productStringList.joined(separator: ",")
    }

    func prepareProductString(productList: [MECProduct]?) -> String {
        guard let inProductList = productList else { return ""}
        let category = MECConfiguration.shared.productCategory ?? MECConfiguration.shared.rootCategory ?? MECAnalyticsConstants.retailer
        var productStringList: [String] = []
        for product in inProductList {
            let productCTN = product.fetchProductCTN()
            productStringList.append("\(category);\(productCTN)")
        }
        return productStringList.joined(separator: ",")
    }
}

extension MECAnalyticsTracking {

    func preparePILCartEntryListString(entries: [ECSPILItem]?, updatedQuantity: Int? = nil) -> String {
        guard let entryList = entries, entryList.count > 0 else { return "" }

        let category = MECConfiguration.shared.productCategory ?? MECConfiguration.shared.rootCategory ?? MECAnalyticsConstants.retailer
        var productStringList: [String] = []
        for entry in entryList {
            let productCTN = entry.ctn ?? ""
            var priceValue = 0.0
            if let discountedPrice = entry.discountPrice, entry.price?.value != discountedPrice.value {
                priceValue = discountedPrice.value ?? 0.0
            } else {
                priceValue = entry.price?.value ?? 0.0
            }
            let quantity = (updatedQuantity ?? entry.quantity) ?? 0
            priceValue *= Double(quantity)
            let price = String(format: "%.2f", priceValue).replacingOccurrences(of: ",", with: ".")
            productStringList.append("\(category);\(productCTN);\(quantity);\(price)")
        }
        return productStringList.joined(separator: ",")
    }
}
