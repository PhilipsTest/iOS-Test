//
//  AccessRefreshToken.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import PlatformInterfaces

typealias Success = (_ isRefreshed: Bool) -> Void

class AccessTokenRefresh:NSObject, UserDataDelegate {
    var _success: Success?
    var userDataInterface: UserDataInterface?
    
    func refresh(user: UserDataInterface,success: @escaping Success) {
        _success = success
        self.userDataInterface = user
        self.userDataInterface?.addUserDataInterfaceListener(self)
        self.userDataInterface?.refreshSession()
    }
    
    func refreshSessionSuccess() {
        self._success!(true)
        self.userDataInterface?.removeUserDataInterfaceListener(self)
    }
    
    func refreshSessionFailed(_ error: Error) {
        self._success!(false)
        self.userDataInterface?.removeUserDataInterfaceListener(self)
    }
    
    func forcedLogout() {
        self._success!(false)
        self.userDataInterface?.removeUserDataInterfaceListener(self)
    }
}
