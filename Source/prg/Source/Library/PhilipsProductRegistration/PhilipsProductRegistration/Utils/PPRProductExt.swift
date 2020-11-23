//
//  PPRProduct.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation

extension PPRProduct {
    func isSameProduct(product: PPRProduct?) -> Bool {
        guard let aProduct = product else {
            return false
        }
        return (self.ctn == aProduct.ctn && self.serialNumber == aProduct.serialNumber)
    }
    
    class func registeredProduct(product :PPRProduct, uuid: String?) -> PPRRegisteredProduct {
        let regProduct = PPRRegisteredProduct(ctn: product.ctn,
                                              sector: product.sector,
                                              catalog: product.catalog)
        regProduct.purchaseDate = product.purchaseDate
        regProduct.serialNumber = product.serialNumber
        regProduct.friendlyName = product.friendlyName
        regProduct.sendEmail = product.sendEmail
        regProduct.requestManager = product.requestManager
        regProduct.userUuid = uuid
        regProduct.registrationDate = product.registrationDate
        
        return regProduct
    }
}


