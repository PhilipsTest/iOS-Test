/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
@testable import PhilipsRegistration
import PlatformInterfaces
class MockUserDataInterface: UserDataInterface {
    
    var isLoggedIn: Bool = false
    
    func isOIDCToken() -> Bool { return true }
    
    func logoutSession() {}
    
    func refreshSession() {}
    
    func refetchUserDetails() {}
    
    func updateUserDetails(_ fields: Dictionary<String, AnyObject>) {}
    
    func updateReceiveMarketingEmail(_ receiveMarketingEmail: Bool) {}
    
    func userDetails(_ fields: Array<String>?) throws -> Dictionary<String, AnyObject> { return [:] }
    
    func authorizeLoginToHSDP(withCompletion completion: @escaping (Bool, Error?) -> Void) {}
    
    var hsdpAccessToken: String? { return "" }
    
    var hsdpUUID: String? { return "" }
    
    func addUserDataInterfaceListener(_ listener: UserDataDelegate) {}
    
    func removeUserDataInterfaceListener(_ listener: UserDataDelegate) {}
    
    func loggedInState() -> UserLoggedInState {
        return isLoggedIn ? .userLoggedIn : .userNotLoggedIn
    }
}
