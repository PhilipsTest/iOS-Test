//
//  PPRRegisteredProductListStoreMock.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import PhilipsPRXClient

@testable import PhilipsProductRegistrationDev

class PPRRegisteredProductListStoreMock: PPRRegisteredProductListStore {
    var productList: [PPRRegisteredProduct]!
    
    class func mockListStoreWith(_ list: [PPRRegisteredProduct]!) -> PPRRegisteredProductListStoreMock {
        let mock = PPRRegisteredProductListStoreMock()
        mock.productList = list
        return mock
    }

}
