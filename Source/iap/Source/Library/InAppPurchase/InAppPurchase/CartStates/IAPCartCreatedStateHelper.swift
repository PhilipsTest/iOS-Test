/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPCartCreatedStateHelper {
    fileprivate var successClosure: (Bool)->() = { arg in }
    var iapCartHelper: IAPCartSyncHelper!
    
    init (withSuccess: @escaping (Bool)->()) {
        successClosure = withSuccess
        iapCartHelper = IAPCartSyncHelper()
    }
    
    func setAddressAndDeliveryMode() {
        IAPAddressSyncHelper().getDefaultAddress({ (inAddress:IAPUserAddress?) in
            guard let defaultAddress = inAddress else { self.successClosure(true); return }
            self.setCartDefaultAddress(defaultAddress)
        }) { (inError:NSError) in
            self.successClosure(true)
        }
    }
    
    func setCartDefaultAddress(_ inAddress:IAPUserAddress) {
        IAPAddressSyncHelper().setDeliveryAddressID(inAddress.addressId, success: { (inResult: Bool) in
            guard true == inResult else { self.successClosure(true); return }
            self.getAndSetDeliveryModes()
        }) { (inError: NSError) in
            self.successClosure(true)
        }
    }
    
    func getAndSetDeliveryModes() {
        IAPDeliveryModeSyncHelper().deliveryMode({ (withDeliveryModeDetails: IAPDeliveryModeDetails) in
            guard withDeliveryModeDetails.deliveryModeDetails.count > 0 else { self.successClosure(true); return }
            self.setDeliveryMode(withDeliveryModeDetails.deliveryModeDetails[0].getdeliveryCodeType())
        }) { (inError: NSError) in
            self.successClosure(true)
        }
    }
    
    func setDeliveryMode(_ inDeliveryModeCode: String) {
        IAPDeliveryModeSyncHelper().updateDeliveryMode(inDeliveryModeCode, success: { (inResult:Bool) in
            self.successClosure(true)
        }) { (inError: NSError) in
            self.successClosure(true)
        }
    }
}
