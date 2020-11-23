//
//  PRXRegisterProductInfoData.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation

class PRXRegisterProductInfoData : NSObject{
    fileprivate struct DataKeys {
        static let kAttributes = "attributes"
        static let kContractNumber = "contractNumber"
        static let kDateOfPurchase = "purchased"
        static let kEmailStatus = "emailStatus"
        static let kExtendedWarranty = "extendedWarranty"
        static let kIsConnectedDevice = "isConnectedDevice"
        static let kLocale = "locale"
        static let kModelNumber = "productId"
        static let kProductRegistrationID = "id"
        static let kProductRegistrationUuid = "id"
        static let kRegistrationDate = "created"
        static let kWarrantyEndDate = "extendedWarrantyExpires"
        static let kWarrantyInMonths = "extendedWarrantyMonths"
    }

    private (set) var contractNumber : String?
    private (set) var dateOfPurchase : Date?
    private (set) var emailStatus : String?
    private (set) var extendedWarranty : Bool = false
    private (set) var isConnectedDevice : Bool = false
    private (set) var locale : String?
    private (set) var modelNumber : String?
    private (set) var productRegistrationID : String?
    private (set) var productRegistrationUuid : String?
    private (set) var registrationDate : Date?
    private (set) var warrantyEndDate : Date?
    
    class func modelObjectWithDictionary(_ dict: NSDictionary) -> PRXRegisterProductInfoData{
        return PRXRegisterProductInfoData(withDictonary: dict)
    }
    
    fileprivate init(withDictonary dict:NSDictionary) {
        super.init()
        if PPRUtils.isDictionary(dictionary: dict) {
            
            if let productRegistrationID =  PPRUtils.objectOrNSNull(object: dict[DataKeys.kProductRegistrationID] as AnyObject?) {
                self.productRegistrationID = productRegistrationID as? String
            }
            if let productRegistrationUuid =  PPRUtils.objectOrNSNull(object: dict[DataKeys.kProductRegistrationUuid] as AnyObject?) {
                self.productRegistrationUuid = productRegistrationUuid as? String
            }
            guard let attributeDict = PPRUtils.objectOrNSNull(object: dict[DataKeys.kAttributes] as AnyObject?) else {
                return
            }
            if let contractNumber = PPRUtils.objectOrNSNull(object: attributeDict[DataKeys.kContractNumber] as AnyObject?) {
                self.contractNumber = contractNumber as? String
            }
            if let dateOfPurchase = PPRUtils.objectOrNSNull(object: attributeDict[DataKeys.kDateOfPurchase] as AnyObject?) {
                self.dateOfPurchase = Date.registrationShortDateFrom(dateOfPurchase as! String) as Date?
            }
            if let emailStatus = PPRUtils.objectOrNSNull(object: attributeDict[DataKeys.kEmailStatus] as AnyObject?) {
                self.emailStatus = emailStatus as? String
            }
            if let extendedWarranty = PPRUtils.objectOrNSNull(object: attributeDict[DataKeys.kExtendedWarranty] as AnyObject?) {
                self.extendedWarranty = extendedWarranty.boolValue
            }
            if let modelNumber =  PPRUtils.objectOrNSNull(object: attributeDict[DataKeys.kModelNumber] as AnyObject?) {
                self.modelNumber = modelNumber as? String
            }
            
            if let registrationDate =  PPRUtils.objectOrNSNull(object: attributeDict[DataKeys.kRegistrationDate] as AnyObject?) {
                self.registrationDate = Date.registrationShortDateFrom(registrationDate as! String) as Date?
            }
            if let warrantyEndDate =  PPRUtils.objectOrNSNull(object: attributeDict[DataKeys.kWarrantyEndDate] as AnyObject?) {
                self.warrantyEndDate = Date.registrationShortDateFrom(warrantyEndDate as! String) as Date?
            }
            self.locale = PPRInterfaceInput.sharedInstance.getAppLocale()
        }
    }
    
    fileprivate func dictionaryRepresentation() -> NSDictionary{
        let mutableDict = NSMutableDictionary(capacity: 0)
        mutableDict.setValue(self.contractNumber, forKey: DataKeys.kContractNumber)
        mutableDict.setValue(self.dateOfPurchase, forKey:DataKeys.kDateOfPurchase)
        mutableDict.setValue(self.emailStatus, forKey:DataKeys.kEmailStatus)
        mutableDict.setValue(self.extendedWarranty, forKey:DataKeys.kExtendedWarranty)
        mutableDict.setValue(self.locale, forKey:DataKeys.kLocale)
        mutableDict.setValue(self.isConnectedDevice, forKey:DataKeys.kIsConnectedDevice)
        mutableDict.setValue(self.modelNumber, forKey:DataKeys.kModelNumber)
        mutableDict.setValue(self.productRegistrationID, forKey:DataKeys.kProductRegistrationID)
        mutableDict.setValue(self.productRegistrationUuid, forKey:DataKeys.kProductRegistrationUuid)
        mutableDict.setValue(self.registrationDate, forKey:DataKeys.kRegistrationDate)
        mutableDict.setValue(self.warrantyEndDate, forKey:DataKeys.kWarrantyEndDate)
        return mutableDict
    }
    
    override var description : String{
        return String(format: "%@", arguments: [self.dictionaryRepresentation()])
    }

}
