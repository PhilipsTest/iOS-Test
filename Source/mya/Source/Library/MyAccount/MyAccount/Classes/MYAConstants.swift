//
//  MYAConstants.swift
//  MyAccount
//
//  Created by Hashim MH on 09/10/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import Foundation

struct MYAstoryBoardIDs {
    static let storyBoardName = "MYA"
    static let navigationController = "NavigationViewController"
    static let settingsScreen = "MYASettings"
    static let profileScreen = "MYAProfile"
}

struct MYA {
    static let tla = "mya"
    static let version = "2018.1.0"
    
    static let profileItemKey = "profile.menuItems"
    static let settingsItemKey = "settings.menuItems"
    
    static let myDetailsKey = "MYA_My_details"
    static let countryItemKey = "MYA_Country"
    static let privacyItemKey = "MYA_Privacy_Settings"
    
    static let philipsLinkSericeId = "userreg.landing.myphilips"
}

struct MYATagging {
//Keys
    static let sendData = "sendData"

//Actions

    
//Pages
    static let profilePageName = "MYA_01_01_profile_page"
    static let profilePageInfo = "My Account Profile page"
    static let settingsPageName = "MYA_01_06_settings_page"
    static let settingsPageInfo = "My Account Settings page"


//Notifications
    static let inAppNotificationKey = "inAppNotification"
    static let inAppNotificationResponse = "inAppNotificationResponse"
    static let logoutNotificationTitle = "Are you sure you want to log out?"

    
}


func MYALocalizable(key:String, comment: String = "") -> String {
    let bundle = Bundle(for: MYAInterface.classForCoder())
    let mainBundleString = NSLocalizedString(key, comment: comment)
    let value = (mainBundleString == key) ? NSLocalizedString(key, tableName: "Localizable", bundle: bundle, value: "", comment: comment) : mainBundleString
    return value
}


