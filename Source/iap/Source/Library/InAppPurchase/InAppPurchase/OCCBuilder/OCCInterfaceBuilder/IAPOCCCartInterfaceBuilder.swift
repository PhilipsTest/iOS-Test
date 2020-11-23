/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPOCCCartInterfaceBuilder: IAPOCCBaseInterfaceBuilder {
    var productCode:String!
    var quantity:Int = 1
    var entryNumber:Int!
    var fetchDetail:Bool = true
    var currentPage:Int = 0
    var pageSize:Int = 20
    var voucherCode:String?
    
    // MARK:
    // MARK:Cart related
    
    func withProductCode(_ inProductCode:String)->IAPOCCCartInterfaceBuilder {
        self.productCode = inProductCode
        return self
    }
    
    func withCartID(_ inCartID:String)->IAPOCCCartInterfaceBuilder {
        self.cartID = inCartID
        return self
    }
    
    func withQuantity(_ inQuantity:Int)->IAPOCCCartInterfaceBuilder {
        self.quantity = inQuantity
        return self
    }
    
    func withEntryNumber(_ inEntryNumber:Int)->IAPOCCCartInterfaceBuilder {
        self.entryNumber = inEntryNumber
        return self
    }
    
    func withFetchDetail(_ inFetchDetail:Bool)->IAPOCCCartInterfaceBuilder {
        self.fetchDetail = inFetchDetail
        return self
    }
    
    func withCurrentPage(_ inCurrentPage:Int)->IAPOCCCartInterfaceBuilder {
        self.currentPage = inCurrentPage
        return self
    }
    
    func buildInterface()->IAPOCCCartInterface {
        let occInterface = IAPOCCCartInterface()
        occInterface.cartID = self.cartID
        occInterface.quantity = self.quantity
        occInterface.shouldFetchDetail = self.fetchDetail
        occInterface.userID = self.userID
        occInterface.pageSize = self.pageSize
        occInterface.currentPage = self.currentPage
        
        if let entry = entryNumber {
            occInterface.entryNumber = entry
        }
        if let code = productCode {
            occInterface.productCode = code
        }
        return occInterface
    }
    
    // MARK:
    // MARK:Voucher related
    func withVoucherCode(_ inVoucherCode:String)->IAPOCCCartInterfaceBuilder {
        self.voucherCode = inVoucherCode
        return self
    }
    
    func buildVoucherInterface()->IAPOCCCartInterface {
        let occInterface = IAPOCCCartInterface()
        occInterface.cartID = self.cartID
        occInterface.userID = self.userID
        if let voucherId = voucherCode {
            occInterface.voucherCode = voucherId
        }
        return occInterface
    }
}
