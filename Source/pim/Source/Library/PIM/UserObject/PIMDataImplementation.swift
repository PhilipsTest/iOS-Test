/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import UIKit
import PlatformInterfaces

class PIMDataImplementation: UserDataInterface {
    
    private var userManager:PIMUserManager
    var userDataInterfaceListener: NSHashTable<UserDataDelegate>
    
    init(_ pimUserManager:PIMUserManager) {
        userManager = pimUserManager
        userDataInterfaceListener = NSHashTable.weakObjects()
    }
    
    func logoutSession() {
        userManager.logoutSession { (inError) in
            guard let logOutError = inError else {
                self.sendMessage(#selector(UserDataDelegate.logoutSessionSuccess), listeners: self.userDataInterfaceListener, error: nil)
                return
            }
            self.sendMessage(#selector(UserDataDelegate.logoutSessionFailed(_:)), listeners: self.userDataInterfaceListener, error: logOutError)
        }
    }
    
    func refreshSession() {
        // TODO: need to handle force logout
        userManager.refreshAccessToken { (isRefreshed, error) in
            guard let refreshError = error else {
                if (isRefreshed) {
                   self.sendMessage(#selector(UserDataDelegate.refreshSessionSuccess), listeners: self.userDataInterfaceListener, error: nil)
                    return
                }
                self.sendMessage(#selector(UserDataDelegate.refreshSessionFailed(_:)), listeners: self.userDataInterfaceListener, error: nil)
                return
            }
            self.sendMessage(#selector(UserDataDelegate.refreshSessionFailed(_:)), listeners: self.userDataInterfaceListener, error: refreshError)
        }
    }
    
    func refetchUserDetails() {
        if let authState = userManager.authState {
            userManager.requestUserProfile(authState) { (userProfile, error) in
                guard let _ = userProfile else {
                    self.sendMessage(#selector(UserDataDelegate.refetchUserDetailsFailed(_:)), listeners: self.userDataInterfaceListener, error: error)
                    return
                }
                self.sendMessage(#selector(UserDataDelegate.refetchUserDetailsSuccess), listeners: self.userDataInterfaceListener, error: nil)
            }
        }
    }
    
    func userDetails(_ fields: Array<String>?) throws -> Dictionary<String, AnyObject> {
        guard loggedInState() == .userLoggedIn else {
            let error = PIMErrorBuilder.buildPIMError(code: .PIMUserNotLoggedIn, message: "User not logged in", domain: "com.PIM.NoUserError")
            throw error
        }
        let allowedFields: Array<String> = allowedUserDetailsFields()
        guard let inputFields = fields else {
            return userManager.oidcUser?.mapUserDetails(allowedFields) ?? [:]
        }
        if Set<AnyHashable>(inputFields).isSubset(of: Set<AnyHashable>(allowedFields)) {
            let filteredFields: Array<String> = (inputFields.count == 0) ? allowedFields : inputFields
            let userDetailsDict = userManager.oidcUser?.mapUserDetails(filteredFields)
            return userDetailsDict ?? [:]
        }else {
            let invalidKeyError = PIMErrorBuilder.buildPIMError(code: .PIMInvalidFields, message: "User details keys are invalid", domain: "com.PIM.InavlidKeyError")
            throw invalidKeyError
        }
    }
    
    func updateReceiveMarketingEmail(_ receiveMarketingEmail: Bool) {
        userManager.updateMarketingOptinConsent(receiveMarketingEmail) { (isUpdated, inError) in
            guard let updateError = inError else {
                if (isUpdated) {
                   self.sendMessage(#selector(UserDataDelegate.updateUserDetailsSuccess), listeners: self.userDataInterfaceListener, error: nil)
                    return
                }
                self.sendMessage(#selector(UserDataDelegate.updateUserDetailsFailed(_:)), listeners: self.userDataInterfaceListener, error: nil)
                return
            }
            self.sendMessage(#selector(UserDataDelegate.updateUserDetailsFailed(_:)), listeners: self.userDataInterfaceListener, error: updateError)
        }
    }
    
    func loggedInState() -> UserLoggedInState {
        return userManager.getUserLoggedInState()
    }
    
    func isOIDCToken() -> Bool {
        return (userManager.authState != nil) ? true:false
    }
    
    func addUserDataInterfaceListener(_ listener: UserDataDelegate) {
        guard !userDataInterfaceListener.contains(listener) else {
            return
        }
        userDataInterfaceListener.add(listener)
    }
    
    func removeUserDataInterfaceListener(_ listener: UserDataDelegate) {
        guard userDataInterfaceListener.contains(listener) else {
            return
        }
        userDataInterfaceListener.remove(listener)
    }
    
    func instantiateWithGuestUser(_ sourceID: String) -> UIViewController? {
        let guestUserViewController = PIMUtilities.getUDIViewController(storyboard: .udiGuestUserScene) as? PIMGuestUserViewController
        guestUserViewController?.sourceID = sourceID
        return guestUserViewController
    }
    
}

extension PIMDataImplementation {
    
    func allowedUserDetailsFields() -> Array<String> {
        return [UserDetailConstants.GIVEN_NAME, UserDetailConstants.FAMILY_NAME, UserDetailConstants.MOBILE_NUMBER, UserDetailConstants.GENDER, UserDetailConstants.EMAIL, UserDetailConstants.BIRTHDAY, UserDetailConstants.RECEIVE_MARKETING_EMAIL, UserDetailConstants.ACCESS_TOKEN, UserDetailConstants.UUID, UserDetailConstants.ID_TOKEN, UserDetailConstants.TOKEN_TYPE, UserDetailConstants.ACCESS_TOKEN_EXPIRATION_TIME]
    }
    
    func sendMessage(_ selector: Selector, listeners: NSHashTable<UserDataDelegate>, error: Error?) {
        let listenersList = listeners.objectEnumerator()
        while let listener: AnyObject = listenersList.nextObject() as AnyObject? {
            if listener.responds(to: selector) {
                DispatchQueue.main.async {
                    _ = listener.perform(selector, with: error)
                }
            }
        }
    }
}

// These methods have dummy implementation only to support deprecated methods of UserDataInterface
extension PIMDataImplementation {
    
    var hsdpAccessToken: String? {
        get { return nil }
    }
    
    var hsdpUUID: String? {
        get { return nil }
    }
    
    func updateUserDetails(_ fields: Dictionary<String, AnyObject>) {}
    
    func authorizeLoginToHSDP(withCompletion completion: @escaping (Bool, Error?) -> Void) {
        completion(false, nil)
    }
}
