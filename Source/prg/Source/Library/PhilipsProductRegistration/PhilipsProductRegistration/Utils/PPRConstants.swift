//
//  PPRConstants.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation

func LocalizableString(key:String, comment: String = "") -> String {
    let bundle = Bundle(for: PPRProductRegistrationUIHelper.classForCoder())
    return NSLocalizedString(key, tableName: "Localizable", bundle: bundle, value: "key not found", comment: comment)
}

struct PPRLocalStore {
    static let name = "registered_list"
}

struct PPRStoryBoardIDs {
    static let storyBoardName = "PPRMain"
    static let navigationController = "NavigationViewController"
    static let welcomeScreen = "WelcomeViewController"
    static let registerScreen = "ProductRegistrationViewController"
    static let allProductsRegisteredScreen = "AllProductsRegisteredViewController"
    static let successScreen = "SuccessViewController"
    static let webViewScreen = "WebViewController"
    static let findSerialNumberScreen = "FindSerialNumberViewController"
}

struct PPRTagging {
    // Action keys
    static let kPPRSpecialEvents = "specialEvents"
    static let kPPRSendData = "sendData"
    
    // Tagging Values
    static let kPPRAppName = "prg"
    static let kPPRProductModelName = "productModel"
    static let kPPRStart = "startProductRegistration"
    static let kPPRSuccess = "successProductRegistration"
    static let kPPRRequiredPurchaseDate = "purchaseDateRequired"
    static let kPPRProductAlreadyRegistered = "productAlreadyRegistered"
    static let kPPRRequiredSerialNumber = "serialNumberRequired"
    static let kPPRAppNotification = "inAppNotification"
    static let kPPRAppNotificationResponse = "inAppNotificationResponse"

    // PageNames
    static let kPPRBenefitsScreen = "PRG:benefit" // PPRWelcomeViewController in viewWillAppear
    static let kPPRProductsScreen = "PRG:registerProduct" // PPRRegisterProductsViewController in view will appear
    static let kPPRSuccessScreen = "PRG:success" // PPRSuccessViewController in viewWillAppear
    static let kPPRSerialNumber = "PRG:findSerialNumber" //Add tags for PPRFindSerialNumberViewController
    
    // Error
    static let kPPRError = "error"
}

struct PPRStorageProviderConst {
    static let kStorageIndex = "PPRRegisteredProducts"
}

let PPRChinaBaseUrl:String = "philips.com.cn"

struct PPRProvider {
    static let PPRChinaJanrainProvider:String = "JANRAIN-CN"
    static let PPRGlobalJanrainProvider:String = "JANRAIN-EU"
    static let PPRChinaOIDCProvider:String = "OIDC-CN"
    static let PPRGlobalOIDCProvider:String = "OIDC-EU"
}

struct PPRConfigurations {
    static let PPRGroup:String = "ProductRegistration"
    static let PPRApiKey:String = "ApiKey"
}

struct PPRURLConstants {
    static let COUNTERFIET_URL = "https://www.chk.philips.com/gb_en/"
}
