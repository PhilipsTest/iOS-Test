/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

protocol IAPOCCPurchaseHistoryInterfaceBuilderProtocol {
    var purchaseHistorycurrentPage:Int! { set get }
    var purchaseHistory:IAPPurchaseHistoryModel! { set get }

    func withPurchaseHistoryCurrentPage(_ withCurrentPage:Int)->IAPOCCAddressInterfaceBuilder
    func buildPurchaseHistoryInterface()->IAPOCCAddressInterface
    func withPurchaseHistory(_ withPurchaseHistory:IAPPurchaseHistoryModel)->IAPOCCAddressInterfaceBuilder
}

extension IAPOCCPurchaseHistoryInterfaceBuilderProtocol where Self : IAPOCCAddressInterfaceBuilder {
    
    func buildPurchaseHistoryInterface()->IAPOCCAddressInterface {
        let occInterface    = IAPOCCAddressInterface()
        occInterface.userID = self.userID
        
        if let curentPage = self.purchaseHistorycurrentPage  {
            occInterface.purchaseHistoryCurrentPage = curentPage
        }
        
        if let historyObject = self.purchaseHistory {
            occInterface.purchaseHistory = historyObject
        }
        
        return occInterface
    }
    
    func withPurchaseHistoryCurrentPage(_ withCurrentPage:Int)->IAPOCCAddressInterfaceBuilder {
        self.purchaseHistorycurrentPage = withCurrentPage
        return self
    }
    
    func withPurchaseHistory(_ withPurchaseHistory:IAPPurchaseHistoryModel)->IAPOCCAddressInterfaceBuilder {
        self.purchaseHistory = withPurchaseHistory
        return self
    }
    
}

class IAPOCCAddressInterfaceBuilder : IAPOCCPaymentAndAddressBaseInterfaceBuilder, IAPOCCPurchaseHistoryInterfaceBuilderProtocol {
    var purchaseHistorycurrentPage:Int!
    var purchaseHistory:IAPPurchaseHistoryModel!

    // MARK:address related
    // MARK:
    func withDefault(_ inDefault:Bool)->IAPOCCAddressInterfaceBuilder {
        self.isDefault = inDefault
        return self
    }
    
    func withAddressID(_ inID:String)->IAPOCCAddressInterfaceBuilder {
        self.addressID = inID
        return self
    }
    
    func buildInterface()->IAPOCCAddressInterface {
        let occInterface = IAPOCCAddressInterface()
        self.initialiseUserAndCartIDForInterface(occInterface)
        self.initialiseInterfaceforAddress(occInterface)
        return occInterface
    }
    
}
