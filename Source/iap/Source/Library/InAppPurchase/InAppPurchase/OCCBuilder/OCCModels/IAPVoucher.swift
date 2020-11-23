//
//  IAPVoucher.swift
//  InAppPurchase
//
//  Created by sameer sulaiman on 10/12/18.
//  Copyright © 2018 Rakesh R. All rights reserved.
//

import Foundation
import CoreGraphics

class IAPVoucher {
    
    var discountAmount : String?
    var discountedValue : CGFloat?
    var discountPercentage : String?
    var voucherCode : String?
    var voucherName : String?
    
    convenience init(inDict : [String: AnyObject]) {
        self.init()
        
        if let appliedValueDict  = inDict[IAPConstants.IAPVoucherKeys.kVoucherAppliedValueKey] as? Dictionary <String, AnyObject>{
            
            if let formattedValue = appliedValueDict[IAPConstants.IAPVoucherKeys.kVoucherFormattedValueKey] as? String{
                self.discountAmount = formattedValue
            }
            if let priceValue = appliedValueDict[IAPConstants.IAPVoucherKeys.kVoucherPriceValueKey] as? CGFloat{
                self.discountedValue = priceValue
            }
        }
        
        if let discountPercent = inDict[IAPConstants.IAPVoucherKeys.kVoucherDiscPercentKey] as? String{
            self.discountPercentage = discountPercent
        }
        if let voucherCode = inDict[IAPConstants.IAPVoucherKeys.kVoucherCodeKey] as? String{
            self.voucherCode = voucherCode
        }
        if let voucherCodeName = inDict[IAPConstants.IAPVoucherKeys.kVoucherNameKey] as? String{
            self.voucherName = voucherCodeName
        }
    }
}
