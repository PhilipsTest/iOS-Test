
//
//  DIUserMock.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import PhilipsRegistration

struct Sta {
    static var onceToken: Int = 0
    static var instance: DIUserMock? = nil
}

class DIUserMock: DIUser {
    private static var __once: () = {
            Sta.instance = DIUserMock()
        }()
    internal var isUserLoggedIn: Bool
    internal var receiveMarketingEmail: Bool
    internal var accessToken: String!
    internal var isAccessTokenRefreshed: Bool
    fileprivate var sessionRefreshListeners: NSHashTable<AnyObject>?
    fileprivate var userRegistrationListeners: NSHashTable<AnyObject>?
    fileprivate var userDataInterfaceListeners: NSHashTable<AnyObject>?

    class var sharedInstance: DIUserMock {

        _ = DIUserMock.__once
        return Sta.instance!
    }
    
    override init() {
        self.isUserLoggedIn = false
        self.accessToken = nil
        self.isAccessTokenRefreshed = false
        self.sessionRefreshListeners = NSHashTable.weakObjects()
        self.userRegistrationListeners = NSHashTable.weakObjects()
        self.userDataInterfaceListeners = NSHashTable.weakObjects()
        self.receiveMarketingEmail = true
    }
    
    override var userLoggedInState: UserLoggedInState{
        get {
            return self.isUserLoggedIn ? UserLoggedInState.userLoggedIn : UserLoggedInState.userNotLoggedIn
        }
    }
    
    override var receiveMarketingEmails: Bool {
        get {
            return self.receiveMarketingEmail
        }
    }
        
    override func addRegistrationListener(_ listener: JanrainFlowDownloadDelegate & UserRegistrationDelegate)
    {
        if (self.userRegistrationListeners!.contains(listener)) {
            return
        }
        self.userRegistrationListeners?.add(listener)
    }
    
    override func addSessionRefreshListener(_ listener: SessionRefreshDelegate) {
        if (self.sessionRefreshListeners!.contains(listener)) {
            return
        }
        self.sessionRefreshListeners?.add(listener)
    }
    
    override func refreshLoginSession() {
        if self.userLoggedInState == UserLoggedInState.userLoggedIn {
            if  self.isAccessTokenRefreshed {
                self.sendMessage(#selector(SessionRefreshDelegate.loginSessionRefreshSucceed), listeners: self.sessionRefreshListeners, object1: nil, object2: nil)

            } else {
                self.sendMessage(#selector(SessionRefreshDelegate.loginSessionRefreshFailedWithError(_:)), listeners:self.sessionRefreshListeners , object1: nil, object2: nil)
            }
        } else {
            self.sendMessage(#selector(SessionRefreshDelegate.loginSessionRefreshFailedAndLoggedout), listeners: self.sessionRefreshListeners, object1: nil, object2: nil)
        }
    }
    
    
    func sendMessage(_ selector: Selector?, listeners: NSHashTable<AnyObject>?, object1: AnyObject?, object2: AnyObject?)
    {
        for listener in (listeners?.allObjects)! {
            let obj = listener
            if (obj.responds(to: selector!)) {
                _ = obj.perform(selector!, with: object1, with: object2)
            }
        }
    }
    
    func invokeJanrainFlowSuccess() {
        self.sendMessage(#selector(JanrainFlowDownloadDelegate.didFinishDownloadingJanrainFlow), listeners: self.userRegistrationListeners, object1: nil, object2: nil)
    }
    
    func invokeJanrainFlowFailure(_ error: NSError) {
        self.sendMessage(#selector(JanrainFlowDownloadDelegate.didFail), listeners: self.userRegistrationListeners, object1: error, object2: nil)
    }
    
    func inovkeRegistrationSucess() {
        self.sendMessage(#selector(UserRegistrationDelegate.didRegisterSuccess(with:)), listeners: self.userRegistrationListeners, object1: self, object2: nil)
    }
    
    func inovkeLoginSucess() {
        self.sendMessage(#selector(UserRegistrationDelegate.didLoginWithSuccess(with:)), listeners: self.userRegistrationListeners, object1: self, object2: nil)
    }
    
   class func mockDIUser(with isUserLoggedIn: Bool, accessToken: String!) -> DIUserMock {
        let userMock = DIUserMock.sharedInstance
        userMock.isUserLoggedIn = isUserLoggedIn
        userMock.accessToken = accessToken
        return userMock
    }
}

class UserDataInterfaceMock: UserDataInterface {
    func isOIDCToken() -> Bool {
        return false
    }
    
    public var isAccessTokenRefreshed: Bool
    public var isUserLogged: Bool
    fileprivate var userDataInterfaceListeners: NSHashTable<AnyObject>?

    func authorizeLoginToHSDP(withCompletion completion: @escaping (Bool, Error?) -> Void) {
        completion(true,nil)
    }
    
    func loggedInState() -> UserLoggedInState {
        return DIUserMock.sharedInstance.userLoggedInState
    }
    
    
    var userDictonary: Dictionary<String, AnyObject>
    
    init() {
        self.userDataInterfaceListeners = NSHashTable.weakObjects()
        isAccessTokenRefreshed = false
        isUserLogged = false
        userDictonary = [UserDetailConstants.GIVEN_NAME: "Thundergod" as AnyObject, UserDetailConstants.EMAIL: "thunderGod.zeus@mailinator.com" as AnyObject, UserDetailConstants.FAMILY_NAME: "Zeus" as AnyObject, UserDetailConstants.GENDER: "Male" as AnyObject, UserDetailConstants.MOBILE_NUMBER: "1234567890" as AnyObject, UserDetailConstants.RECEIVE_MARKETING_EMAIL: true as AnyObject, UserDetailConstants.BIRTHDAY:Date() as AnyObject]
    }
    
    func sendMessage(_ selector: Selector?, listeners: NSHashTable<AnyObject>?, object1: AnyObject?, object2: AnyObject?)
    {
        for listener in (listeners?.allObjects)! {
            let obj = listener
            if (obj.responds(to: selector!)) {
                _ = obj.perform(selector!, with: object1, with: object2)
            }
        }
    }
    
    func logoutSession() {
        return
    }
    
    func refreshSession() {
        if isUserLoggedIn(){
        if  self.isAccessTokenRefreshed {
            self.sendMessage(#selector(RefreshSessionDelegate.refreshSessionSuccess), listeners: self.userDataInterfaceListeners, object1: nil, object2: nil)
            
        } else {
            self.sendMessage(#selector(RefreshSessionDelegate.refreshSessionFailed(_:)), listeners: self.userDataInterfaceListeners, object1: nil, object2: nil)
        }
        }else{
            self.sendMessage(#selector(RefreshSessionDelegate.forcedLogout), listeners: self.userDataInterfaceListeners, object1: nil, object2: nil)
        }
    }
    
    func refetchUserDetails() {
        return
    }
    
    func updateUserDetails(_ fields: Dictionary<String, AnyObject>) {
        return
    }
    
    func updateReceiveMarketingEmail(_ receiveMarketingEmail: Bool) {
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
        return isUserLogged
    }
        
    var hsdpAccessToken: String?
    
    var hsdpUUID: String?
    
    func addUserDataInterfaceListener(_ listener: UserDataDelegate) {
        if (self.userDataInterfaceListeners!.contains(listener)) {
            return
        }
        self.userDataInterfaceListeners?.add(listener)
    }
    
    func removeUserDataInterfaceListener(_ listener: UserDataDelegate) {
        return
    }
}
