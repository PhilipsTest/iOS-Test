/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PlatformInterfaces

class MECMockUserDataInterface: NSObject, UserDataInterface {
    
    var details: [String: String] = [:]
    var delegate: UserDataDelegate?
    var shouldCallSuccess = true
    var refreshError: Error?
    var loginState: UserLoggedInState = UserLoggedInState.userNotLoggedIn
    func isOIDCToken() -> Bool {
        return false
    }
    
    func logoutSession() {}
    
    func refreshSession() {
        if shouldCallSuccess {
            delegate?.refreshSessionSuccess?()
        } else {
            delegate?.refreshSessionFailed?(refreshError ?? NSError(domain: "", code: 0, userInfo: nil))
        }
    }
    
    func refetchUserDetails() {}
    
    func updateUserDetails(_ fields: Dictionary<String, AnyObject>) {}
    
    func updateReceiveMarketingEmail(_ receiveMarketingEmail: Bool) {}
    
    func userDetails(_ fields: Array<String>?) throws -> Dictionary<String, AnyObject> {
        return details as Dictionary<String, AnyObject>
    }
    
    func authorizeLoginToHSDP(withCompletion completion: @escaping (Bool, Error?) -> Void) {}
    
    func loggedInState() -> UserLoggedInState {
        return loginState
    }
    
    var hsdpAccessToken: String?
    
    var hsdpUUID: String?
    
    func addUserDataInterfaceListener(_ listener: UserDataDelegate) {
        delegate = listener
    }
    
    func removeUserDataInterfaceListener(_ listener: UserDataDelegate) {
        delegate = nil
    }
}
