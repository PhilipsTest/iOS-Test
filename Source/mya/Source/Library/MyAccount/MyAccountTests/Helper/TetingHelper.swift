//
//  TetingHelper.swift
//  MyAccountTests
//
//  Created by leslie on 21/11/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import UIKit
@testable import MyAccountDev
import PlatformInterfaces

class DelegateMock:NSObject, MYADelegate{
    
    var settingsDelegateCalled = false
    var ProfileDelegatesCalled = false
    
    func settingsMenuItemSelected(onItem item: String) -> Bool {
        switch item {
        case "test1":
            settingsDelegateCalled = true
            return true
        default:
            settingsDelegateCalled = false
            return false
        }
    }
    
    func profileMenuItemSelected(onItem item: String) -> Bool {
        switch item {
        case "test1":
            ProfileDelegatesCalled = true
            return true
        default:
            ProfileDelegatesCalled = false
            return false
        }
    }
    
    func valueForSettingsItem(key: String) -> String? {
        if key == "key" {
            return "test"
        }
        return nil
    }
    
    func logoutClicked() {
    }
}

class UserDataInterfaceMock: UserDataInterface {
    
    var userDictonary: Dictionary<String, AnyObject>
    
    init() {
        
        userDictonary = [UserDetailConstants.GIVEN_NAME: "Thundergod" as AnyObject, UserDetailConstants.EMAIL: "thunderGod.zeus@mailinator.com" as AnyObject, UserDetailConstants.FAMILY_NAME: "Zeus" as AnyObject, UserDetailConstants.GENDER: "Male" as AnyObject, UserDetailConstants.MOBILE_NUMBER: "1234567890" as AnyObject, UserDetailConstants.RECEIVE_MARKETING_EMAIL: true as AnyObject, UserDetailConstants.BIRTHDAY:Date() as AnyObject]
    }
    
    func logoutSession() {
        return
    }
    
    func refreshSession() {
        return
    }
    
    func refetchUserDetails() {
        return
    }
    
    func updateUserDetails(_ fields: Dictionary<String, AnyObject>) {
        return
    }
    
    func userDetails(_ fields: Array<String>?) throws -> Dictionary<String, AnyObject> {
        var usrData : [String : AnyObject]
        usrData = [:]
        for key in fields! {
            usrData[key] = userDictonary[key]
        }
        return usrData
    }
    
    func isUserLoggedIn() -> Bool {
        return true
    }
    
    func isOIDCToken() -> Bool {
        return false
    }
    
    func updateReceiveMarketingEmail(_ receiveMarketingEmail: Bool) {
        return
    }
    
    func authorizeLoginToHSDP(withCompletion completion: @escaping (Bool, Error?) -> Void) {
        completion(true,nil)
    }
    
    func loggedInState() -> UserLoggedInState {
        return UserLoggedInState.userLoggedIn
    }
    
    var hsdpAccessToken: String?
    
    var hsdpUUID: String?
    
    func addUserDataInterfaceListener(_ listener: UserDataDelegate) {
        return
    }
    
    func removeUserDataInterfaceListener(_ listener: UserDataDelegate) {
        return
    }
}

class UserDataInterfaceMockNotLoggindIn: UserDataInterface {
    func authorizeLoginToHSDP(withCompletion completion: @escaping (Bool, Error?) -> Void) {
        completion(false,nil)
    }
    
    func loggedInState() -> UserLoggedInState {
        return UserLoggedInState.userNotLoggedIn
    }
    
    enum UserError: Error {
        case NotLoggedIn
    }
    
    func logoutSession() {
        return
    }
    
    func refreshSession() {
        return
    }
    
    func refetchUserDetails() {
        return
    }
    
    func updateUserDetails(_ fields: Dictionary<String, AnyObject>) {
        return
    }
    
    func userDetails(_ fields: Array<String>?) throws -> Dictionary<String, AnyObject> {
       throw UserError.NotLoggedIn
    }
    
    var hsdpAccessToken: String?
        
    var hsdpUUID: String?
    
    func addUserDataInterfaceListener(_ listener: UserDataDelegate) {
        return
    }
    
    func removeUserDataInterfaceListener(_ listener: UserDataDelegate) {
        return
    }
    
    func isUserLoggedIn() -> Bool {
        return false
    }
    
    func isOIDCToken() -> Bool {
        return false
    }
    
    func updateReceiveMarketingEmail(_ receiveMarketingEmail: Bool) {
        return
    }
}

