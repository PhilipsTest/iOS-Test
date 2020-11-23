/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class IAPOrderDiscount: NSObject {
    
    var orderDiscountDescription : String?
    var orderDiscountValue : String?
    
    convenience init(inDict : [String: AnyObject]) {
        self.init()
        
        if let appliedValueDict = inDict[IAPConstants.IAPOrderDiscountKeys.kPromotionKey] as? [String:AnyObject] {
            
            if let description = appliedValueDict[IAPConstants.IAPOrderDiscountKeys.kDescriptionKey] as? String {
                orderDiscountDescription = description
            }
            
            if let discountDetails = appliedValueDict[IAPConstants.IAPOrderDiscountKeys.kPromotionDiscountKey] as? [String:AnyObject] {
                
                if let formattedValue = discountDetails[IAPConstants.IAPOrderDiscountKeys.kFormattedValueKey] as? String {
                    orderDiscountValue = formattedValue
                }
            }
        }
    }
}
