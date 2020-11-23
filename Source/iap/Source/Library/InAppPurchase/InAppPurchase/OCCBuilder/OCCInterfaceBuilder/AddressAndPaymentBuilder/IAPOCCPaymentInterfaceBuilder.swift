/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPOCCPaymentInterfaceBuilder:IAPOCCPaymentAndAddressBaseInterfaceBuilder {
    
    var orderID:String!
    var paymentID:String!
    var cvv:String!
    
    func withOrderID(_ inOrderID:String)->IAPOCCPaymentInterfaceBuilder {
        self.orderID = inOrderID
        return self
    }
    
    func withPaymentID(_ inPaymentId:String)->IAPOCCPaymentInterfaceBuilder {
        self.paymentID = inPaymentId
        return self
    }
    
    func withCVV(_ inCVV:String)->IAPOCCPaymentInterfaceBuilder {
        self.cvv = inCVV
        return self
    }
    
    @discardableResult
    func initialiseInterfaceforPayment(_ interface:IAPOCCPaymentInterface)->IAPOCCPaymentInterface {
        if let orderIdentifier = self.orderID {
            interface.orderID = orderIdentifier
        }
        
        if let paymentIdentifier = self.paymentID {
            interface.paymentID = paymentIdentifier
        }
        
        if let cvvUsed = self.cvv {
            interface.cvv = cvvUsed
        }
        
        return interface
    }
    
    func buildInterface()->IAPOCCPaymentInterface {
        let occInterface = IAPOCCPaymentInterface()
        self.initialiseUserAndCartIDForInterface(occInterface)
        self.initialiseInterfaceforAddress(occInterface)
        self.initialiseInterfaceforPayment(occInterface)
        return occInterface
    }
    
}
