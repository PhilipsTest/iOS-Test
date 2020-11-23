/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class IAPOrderDiscountList: NSObject {
    
    var orderDiscountList = [IAPOrderDiscount]()
    
    convenience init(inDict: [[String: AnyObject]]) {
        self.init()
        self.orderDiscountList = inDict.map{ (IAPOrderDiscount(inDict: $0)) }
    }
}
