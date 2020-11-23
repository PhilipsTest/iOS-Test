//
//  PPRRegisteredProductListStore.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation

class PPRRegisteredProductListStore {
    
    func isProductAlreadyRegistered(product: PPRRegisteredProduct,
                                    list: [PPRRegisteredProduct]) -> (isReigistered :Bool,index: Int)
    {
        for (index, aProduct) in list.enumerated() {
            if self.isSameRegistredProduct(product: product, savedProduct: aProduct) {
                return (true, index)
            }
        }
        return (false,-1)
    }
    
    func isSameRegistredProduct(product: PPRRegisteredProduct, savedProduct: PPRRegisteredProduct) -> Bool {
        if savedProduct.userUuid == nil || product.userUuid == nil {
            return self.isSameProduct(product: product, savedProduct: savedProduct)
        }
    
        return (product.userUuid == savedProduct.userUuid && self.isSameProduct(product: product, savedProduct: savedProduct))
    }
    
    func isSameProduct(product: PPRProduct, savedProduct: PPRProduct) -> Bool {
        if (product.serialNumber?.length == 0 && savedProduct.serialNumber == nil){
            return (product.ctn == savedProduct.ctn)
        } else if (product.serialNumber?.length == 0 && savedProduct.serialNumber != nil) {
            return false
        } else if (product.serialNumber?.length != 0 && savedProduct.serialNumber == nil) {
            return false
        } else {
            return (product.ctn == savedProduct.ctn && product.serialNumber == savedProduct.serialNumber)
        }
    }
    
}
