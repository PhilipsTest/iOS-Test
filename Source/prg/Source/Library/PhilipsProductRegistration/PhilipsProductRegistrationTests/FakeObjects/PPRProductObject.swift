//
//  PPRProductRegistrationInfoObject.swift
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

class PPRProductObject: NSObject {
    
    class func fakeProductWith(_ ctn: String, serialNumber: String!) -> PPRProduct {
        let product = PPRProduct(ctn: ctn, sector: DEFAULT, catalog: CONSUMER)
        product.sendEmail = false
        product.purchaseDate = Date()
        product.serialNumber = serialNumber
        return product
    }
    
    class func fakeProductWith(_ ctn: String, serialNumber: String!, purchaseDate: Date!) -> PPRProduct {
        let product = PPRProduct(ctn: ctn, sector: DEFAULT, catalog: CONSUMER)
        product.sendEmail = false
        product.purchaseDate = purchaseDate
        product.serialNumber = serialNumber
        return product
    }
}
