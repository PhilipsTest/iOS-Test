//
//  MYAError.swift
//  MyAccount
//
//  Created by Hashim MH on 28/11/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import Foundation

/**
 Class to get the type of errors when My Account is launched such as User Not Logged in.
 - Since: 2018.1.0
 */
///
@objc public enum MYAError:Int {
    /**
     error case if user is not logged in
     - Since: 2018.1.0
     */
    case userNotLoggedIn = 1001
    
    static let domain = "com.philips.platform.mya"
    
    var localizedDescription: String {
        switch self {
            case .userNotLoggedIn: return MYALocalizable(key: "MYA_notLoggedIn_error")
        }
    }
    
    func error() -> NSError{
        let userInfo = [NSLocalizedDescriptionKey: self.localizedDescription]
        let error = NSError(domain: MYAError.domain, code: self.rawValue, userInfo: userInfo)
        return error
    }
}
