//
//  TestDIUser.swift
//  AppFrameworkTests
//
//  Created by Ravi Kiran HR on 05/07/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import Foundation
import PhilipsRegistration

class TestDIUser : DIUser{
    var shouldHSDPNil = false
    var shouldHSDPAccessTokenNil = false
    
    override var hsdpUUID: String?{
        guard shouldHSDPNil == false else {
            return nil
        }
        return "20086e31-4088-4f29-9892-eec37f984ca3"
    }

    override var hsdpAccessToken: String?{
        guard shouldHSDPAccessTokenNil == false else {
            return nil
        }
        return "7e2m8t87798muyhv"
    }
    
    override var userLoggedInState: UserLoggedInState {
            return UserLoggedInState.userLoggedIn
    }
}
