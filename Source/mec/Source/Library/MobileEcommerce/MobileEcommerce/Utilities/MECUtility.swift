/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra
import UIKit
import PhilipsEcommerceSDK

class MECUtility: NSObject {

    @objc dynamic class func createECSService() -> ECSServices? {
        return ECSServices(appInfra: MECConfiguration.shared.sharedAppInfra)
    }

    class func getBundle() -> Bundle {
        return Bundle(for: self)
    }

    class func isPILStockAvailable(stockLevelStatus: String?, stockAmount: Int) -> Bool {
        if let stockLevelStatus = stockLevelStatus {
            return (stockLevelStatus.caseInsensitiveCompare(MECConstants.MECPILInStockKey) == .orderedSame ||
            stockLevelStatus.caseInsensitiveCompare(MECConstants.MECPILLowStockKey) == .orderedSame) && stockAmount > 0
        }
        return false
    }

    class var isRightToLeft: Bool {
        return UIView.userInterfaceLayoutDirection(for: .unspecified) == .rightToLeft
    }

    class func getComponentInfo() -> [String: AnyObject] {
        let bundle: Bundle = MECUtility.getBundle()
        let componentInfoDict: Dictionary = bundle.infoDictionary!
        return componentInfoDict as [String: AnyObject]
    }

    class func configureTaggingAndLogging(_ appInfraInstance: AIAppInfra) {
        let componentInfoDict: Dictionary = MECUtility.getComponentInfo()
        let bundleVersion = componentInfoDict["CFBundleShortVersionString"] as? String ?? ""

        MECConfiguration.shared.mecTagging = appInfraInstance.tagging.createInstance(forComponent: MECConstants.MECComponentId,
                                                                                     componentVersion: bundleVersion)
        MECConfiguration.shared.mecLogging = appInfraInstance.logging.createInstance(forComponent: MECConstants.MECComponentId,
                                                                                     componentVersion: bundleVersion)
    }

    class func fetchConfigValueForKey(_ key: String) -> Any? {
        do {
            let value = try MECConfiguration.shared.sharedAppInfra?.appConfig.getPropertyForKey(key, group: MECConstants.MECTLA)
            if let result = value {
                return result
            } else {
                return nil
            }
        } catch let error as NSError {
            MECUtility.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.appError,
                                           serverName: MECAnalyticServer.other, error: error)
            MECConfiguration.shared.mecLogging?.log(.error, eventId: MECConstants.MECTLA, message: error.localizedDescription)
        }
        return nil
    }

    class func saveUserEmailInformation() {
        if let userEmailData = constructEmailDataToSave() {
            saveDataToSecureStorageFor(key: MECConstants.MECUSEROAUTHDATASAVEKEY, value: userEmailData)
        }
    }

    class func shouldAuthenticateWithHybris() -> Bool {
        guard MECConfiguration.shared.isUserLoggedIn else {
            return false
        }
        guard let storedUserData = fetchDataFromSecureStorageFor(key: MECConstants.MECUSEROAUTHDATASAVEKEY),
            let savedEmailAddress = storedUserData.value(forKey: MECConstants.MECUSEROAUTHEMAILDATASAVEKEY) as? String,
            savedEmailAddress.count > 0  else {
            return true
        }
        guard let currentUserEmailID = MECConfiguration.shared.getUserEmailID(), currentUserEmailID.count > 0 else {
            return true
        }
        if currentUserEmailID.caseInsensitiveCompare(savedEmailAddress) == .orderedSame {
            return false
        }
        return true
    }

    class func getPhoneNumberURL(inPhoneNumber: String?) -> URL? {
        guard let formattedPhoneNumber = inPhoneNumber?.replacingOccurrences(of: " ", with: "") else {return nil}
        let telURL = "tel://\(formattedPhoneNumber)"
        guard let url = URL(string: telURL) else {return nil}
        return url
    }

    @objc dynamic class func convertOrderPlacedDateToDisplayFormat(placedDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        if let orderPlacedDisplayDate = dateFormatter.date(from: placedDate) {
            dateFormatter.dateFormat = "EEEE MMMM dd, yyyy"
            let displayDate = dateFormatter.string(from: orderPlacedDisplayDate)
            return displayDate.replacingOccurrences(of: "-", with: "/")
        }
        return ""
    }

    class func shouldShowSRP(for cartEntry: ECSPILItem, completionHandler: @escaping (_ shouldShow: Bool) -> Void) {
        isCountrySupportedToShowSRP { (shouldShow) in
            guard shouldShow == true else {
                completionHandler(shouldShow)
                return
            }
            if let discountedPrice = cartEntry.discountPrice, cartEntry.price?.value ?? 0 > discountedPrice.value ?? 0 {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }

    class func shouldShowSRP(for product: MECProduct?, completionHandler: @escaping (_ shouldShow: Bool) -> Void) {
        guard let mecProduct = product else {
            completionHandler(false)
            return
        }
        isCountrySupportedToShowSRP { (shouldShow) in
            guard shouldShow == true else {
                completionHandler(shouldShow)
                return
            }
            if let discountedPrice = mecProduct.product?.attributes?.discountPrice,
               mecProduct.product?.attributes?.price?.value ?? 0 > discountedPrice.value ?? 0 {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }

    private class func isCountrySupportedToShowSRP(completionHandler: @escaping (_ shouldShow: Bool) -> Void) {
        MECServiceDiscoveryUtility().getMECServiceURL(serviceKey: MECServiceKeys.MECSRP) { (serviceURL, _) in
            DispatchQueue.main.async {
                if serviceURL != nil {
                    completionHandler(true)
                } else if MECConfiguration.shared.locale == "en_GB" {    // hardcoded country check has to be removed once the
                    completionHandler(true)                              // service discovery is up
                } else {
                    completionHandler(false)
                }
            }
        }
    }
}

// MARK: Helper methods

extension MECUtility {
    private class func constructEmailDataToSave() -> NSDictionary? {
        if let userEmailID = MECConfiguration.shared.getUserEmailID(), userEmailID.count > 0 {
            let userData: NSDictionary = [MECConstants.MECUSEROAUTHEMAILDATASAVEKEY: userEmailID]
            return userData
        }
        return nil
    }

    private class func fetchDataFromSecureStorageFor(key: String) -> NSDictionary? {
        do {
            return try MECConfiguration.shared.sharedAppInfra.storageProvider
                .fetchValue(forKey: MECConstants.MECUSEROAUTHDATASAVEKEY) as? NSDictionary
        } catch {
            MECUtility.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.appError,
                                           serverName: MECAnalyticServer.other, error: error)
            MECConfiguration.shared.mecLogging?.log(.error, eventId: MECConstants.MECTLA, message: error.localizedDescription)
            return nil
        }
    }

    private class func saveDataToSecureStorageFor(key: String, value: NSCoding) {
        do {
            try MECConfiguration.shared.sharedAppInfra.storageProvider.storeValue(forKey: key, value: value)
        } catch {
            MECUtility.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.appError,
                                           serverName: MECAnalyticServer.other, error: error)
            MECConfiguration.shared.mecLogging?.log(.error, eventId: MECConstants.MECTLA, message: error.localizedDescription)
        }
    }

    // track user error methods
    private class func trackTechnicalError(errorCategory: String, serverName: String, error: Error?) {
        let errorMessage = error?.localizedDescription ?? ""
        let errorCode = error?.code ?? 0
        let errorString = "\(MECConstants.MECTLA):\(errorCategory):\(serverName):\(errorMessage):\(errorCode)"
        trackAction(parameterData: [MECAnalyticsConstants.technicalError: errorString])
    }

    private class func trackAction(parameterData: [String: Any], action: String = MECAnalyticEvents.sendData) {
        var parameter = parameterData
        for (key, value) in MECUtility.getAdditionalFields() {
            parameter.updateValue(value, forKey: key)
        }

        MECConfiguration.shared.mecTagging?.trackAction(withInfo: action, params: parameter)
    }

    private class func getAdditionalFields() -> [String: Any] {
        var param: [String: Any] = [:]
        if let country = MECConfiguration.shared.sharedAppInfra.serviceDiscovery.getHomeCountry() {
            param[MECAnalyticsConstants.country] = country

            if let currency = Locale.currency[country]?.symbol {
                param[MECAnalyticsConstants.currency] = currency
            }
        }
        return param
    }
}
