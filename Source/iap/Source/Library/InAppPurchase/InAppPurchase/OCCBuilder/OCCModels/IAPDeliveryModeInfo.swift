/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPDeliveryModeInfo: Equatable {
    var deliveryCodeType:String! = ""
    var deliveryCost:String! = ""
    var deliveryModeName:String! = ""
    var deliveryModeDescription:String! = ""

    init (inDict: [String: AnyObject]) {
        
        self.deliveryCodeType = inDict[IAPConstants.IAPDeliveryModeKeys.kDeliveryCodeKey] as? String
        if let modeName = inDict[IAPConstants.IAPDeliveryModeKeys.kNameKey] as? String {
            self.deliveryModeName = modeName
        }
        
        if let deliveryDescription = inDict[IAPConstants.IAPDeliveryModeKeys.kDescriptionKey] as? String {
            self.deliveryModeDescription = deliveryDescription
        }
        
        if let deliveryCostDict = inDict[IAPConstants.IAPDeliveryModeKeys.kDeliveryCostKey] as? [String: AnyObject] {
            self.deliveryCost = deliveryCostDict[IAPConstants.IAPDeliveryModeKeys.kFormattedValueKey] as? String
        }
    }
    
    func getdeliveryCodeType()-> String {
        return self.deliveryCodeType
    }
    
    func getdeliveryCost()-> String {
        return self.deliveryCost
    }
    
    func getdeliveryModeName()-> String {
        return self.deliveryModeName
    }
    
    func getDeliveryModeDescription() -> String{
        return self.deliveryModeDescription
    }
}

func ==(lhs: IAPDeliveryModeInfo, rhs: IAPDeliveryModeInfo) -> Bool
{
    return lhs.getdeliveryModeName() == rhs.getdeliveryModeName()
}

class IAPDeliveryModeDetails {
    var deliveryModeDetails:[IAPDeliveryModeInfo] = [IAPDeliveryModeInfo]()
    
    init(inDict: [String: AnyObject]) {
        if let deliveryModeDictionaries = inDict[IAPConstants.IAPDeliveryModeKeys.kDeliveryModesKey] as? [[String: AnyObject]] {
            deliveryModeDetails = deliveryModeDictionaries.map { (IAPDeliveryModeInfo(inDict: $0)) }
        }
    }
}
