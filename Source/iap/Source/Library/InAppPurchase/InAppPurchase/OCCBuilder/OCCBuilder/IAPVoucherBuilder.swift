/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class IAPVoucherBuilder: IAPCartBuilder {

    private var voucherCode:String!
    
    init(cartID:String, userID:String, voucherCode:String = ""){
        self.voucherCode = voucherCode
        super.init(cartID: cartID, userID: userID)
    }
    
    func getVoucherCode() -> String {
        return self.voucherCode
    }
    
    // Builder used for apply voucher and Listing applied vouchers
    func getApplyVoucherCodeURL() -> String {
        return super.getCartEntryURL() + IAPConstants.IAPVoucherKeys.kVoucherKey + "?lang="
    }
    
    func getReleaseVoucherCodeURL() -> String {
        return super.getCartEntryURL() + IAPConstants.IAPVoucherKeys.kVoucherKey + "/" + self.voucherCode + "?lang="
    }
}

