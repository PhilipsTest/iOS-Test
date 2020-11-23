//
//  AIInternationalizationInterface.swift
//  AppInfra
//
//  Created by Philips on 9/19/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import UIKit

@objcMembers public class AIInternationalizationInterface: NSObject,AIInternationalizationProtocol  {
    
    public func getUILocale() -> Locale {
        let locale = NSLocale(localeIdentifier: getUILocaleString())
        return locale as Locale
    }
    
    public func getUILocaleString() -> String {
        var uiLocale = ""
        let locales = Bundle.main.preferredLocalizations
        uiLocale = locales.first ?? ""
        
        //if contains language script remove it
        let countryCode = NSLocale(localeIdentifier: uiLocale).object(forKey: .countryCode) as? String
        let languageCode = NSLocale(localeIdentifier: uiLocale).object(forKey: .languageCode) as? String
        let scriptCode = NSLocale(localeIdentifier: uiLocale).object(forKey: .scriptCode) as? String
        
        /* Return zh_CN for Simplified(script code 'Hans')
         Return zh_TW for Traditional(script code 'Hant')
         Return zh_HK for Chinese Honkong   as per the requirements (tfs Story:22096)
         */
        if (languageCode == "zh") && (scriptCode == "Hant") {
            uiLocale = "zh_TW"
        } else if (languageCode == "zh") && (scriptCode == "Hans") {
            uiLocale = "zh_CN"
        } else {
            if (languageCode != nil) && (countryCode != nil) {
                uiLocale = "\(languageCode ?? "UNKNOWN")_\(countryCode ?? "UNKNOWN")"
            } else if (languageCode != nil) {
                uiLocale = languageCode ?? "UNKNOWN"
            }
        }
        return uiLocale
    }
    
    public func getBCP47UILocale() -> String {
        let ailBundle = Bundle(for: AIInternationalizationInterface.self)
        let locale = NSLocalizedString("ail_fullLocale", tableName: "Localizable", bundle: ailBundle, value:"", comment: "")
        return locale
    }
}
