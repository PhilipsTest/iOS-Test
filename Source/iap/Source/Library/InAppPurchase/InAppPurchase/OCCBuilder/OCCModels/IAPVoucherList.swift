/* Copyright (c) Koninklijke Philips N.V., 2018
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

 class IAPVoucherList {
    var voucherList = [IAPVoucher]()

    convenience init(inDict: [String: AnyObject], isFromCart: Bool = false) {
        self.init()
        let voucherKey = isFromCart ? IAPConstants.IAPVoucherKeys.kAppliedVouchersKey : IAPConstants.IAPVoucherKeys.kVoucherKey
        if let voucherDictionary = inDict[voucherKey] as? [[String: AnyObject]] {
            self.voucherList = voucherDictionary.map{ (IAPVoucher(inDict: $0)) }
        }
    }
}
