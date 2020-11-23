//
//  PPRProductRegistrationHelperMock.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation

@testable import PhilipsProductRegistrationDev

class PPRProductRegistrationHelperMock: PPRProductRegistrationHelper {
    var userWithProducts: PPRUserWithProducts?
    
    override func getSignedInUserWithProudcts() -> PPRUserWithProducts {
        self.userWithProducts?.user = self.user
        self.userWithProducts?.delegate = self.delegate
        return self.userWithProducts!
    }
}
