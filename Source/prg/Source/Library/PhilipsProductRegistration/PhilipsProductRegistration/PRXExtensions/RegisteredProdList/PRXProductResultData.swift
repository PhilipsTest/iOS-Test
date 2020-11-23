//
//  PRXProductListData.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation

class PRXProductResultData:NSObject {
    fileprivate struct DataKeys{
        static let kContractNumber = "contractNumber"
        static let kCreated = "created"
        static let kDeviceId = "deviceId"
        static let kDeviceName = "deviceName"
        static let kExtendedWarranty = "extendedWarrantyMonths"
        static let kId = "id"
        static let kIsGenerations = "isGenerations"
        static let kIsPrimaryUser = "isPrimaryUser"
        static let kLastModified = "lastModified"
        static let kLastSolicitDate = "lastSolicitDate"
        static let kLastUpdated = "lastUpdated"
        static let kProductCatalogLocaleId = "productCatalogLocaleId"
        static let kProductID = "productID"
        static let kProductModelNumber = "productId"
        static let kProductRegistrationID = "productRegistrationID"
        static let kProductSerialNumber = "serialNumber"
        static let kPurchaseDate = "purchased"
        static let kPurchasePlace = "purchasePlace"
        static let kRegistrationChannel = "registrationChannel"
        static let kRegistrationDate = "created"
        static let kSlashWinCompetition = "slashWinCompetition"
        static let kUuid = "id"
        static let kWarrantyInMonths = "extendedWarrantyMonths"
        static let kExtendedWarrantyExpires = "extendedWarrantyExpires"
        static let kData = "data"
        static let kAttributes = "attributes"
    }
    
    fileprivate (set) var contractNumber: String?
    fileprivate (set) var created: String?
    fileprivate (set) var deviceId: String?
    fileprivate (set) var deviceName: String?
    fileprivate (set) var isExtendedWarranty: Bool = false
    fileprivate (set) var ID: Int = 0
    fileprivate (set) var isGenerations: Bool = false
    fileprivate (set) var isPrimaryUser: Bool = false
    fileprivate (set) var lastModified: String?
    fileprivate (set) var lastSolicitDate: Date?
    fileprivate (set) var lastUpdated: String?
    fileprivate (set) var productCatalogLocaleId: String?
    fileprivate (set) var productID: String?
    fileprivate (set) var productModelNumber: String?
    fileprivate (set) var productRegistrationID: String?
    fileprivate (set) var productSerialNumber: String?
    fileprivate (set) var purchaseDate: Date?
    fileprivate (set) var purchasePlace: String?
    fileprivate (set) var registrationChannel: String?
    fileprivate (set) var registrationDate: Date?
    fileprivate (set) var isSlashWinCompetition: Bool = false
    fileprivate (set) var uuid: String?
    fileprivate (set) var warrantyInMonths: String?
    fileprivate (set) var warrantyExpires: Date?

    class func modelObjectWithDictionary(_ dict: NSDictionary) -> PRXProductResultData{
        return PRXProductResultData(withDictonary: dict)
    }
    
    fileprivate init(withDictonary dict:NSDictionary) {
        if PPRUtils.isDictionary(dictionary: dict) {
            
            guard let dataDict = PPRUtils.objectOrNSNull(object: dict[DataKeys.kData] as AnyObject?) else {
                return
            }
            guard let attributeDict = PPRUtils.objectOrNSNull(object: dataDict[DataKeys.kAttributes] as AnyObject?) else {
                return
            }
            
            if let uuid = PPRUtils.objectOrNSNull(object: dataDict[DataKeys.kUuid] as AnyObject?) {
                self.uuid = uuid as? String
            }
            if let productModelNumber = PPRUtils.objectOrNSNull(object: attributeDict[DataKeys.kProductModelNumber] as AnyObject?) {
                self.productModelNumber = productModelNumber as? String
            }
            if let contractNumber = PPRUtils.objectOrNSNull(object: attributeDict[DataKeys.kContractNumber] as AnyObject?)  {
                self.contractNumber = contractNumber as? String
            }
            if let productSerialNumber = PPRUtils.objectOrNSNull(object: attributeDict[DataKeys.kProductSerialNumber] as AnyObject?) {
                self.productSerialNumber = productSerialNumber as? String
            }
            if let extendedWarrantyExpires = PPRUtils.objectOrNSNull(object: attributeDict[DataKeys.kExtendedWarrantyExpires] as AnyObject?) {
                self.warrantyExpires = Date.registrationShortDateFrom(extendedWarrantyExpires as! String) as Date?
            }
            if let purchaseDate = PPRUtils.objectOrNSNull(object: attributeDict[DataKeys.kPurchaseDate] as AnyObject?) {
                self.purchaseDate = Date.registrationShortDateFrom(purchaseDate as! String) as Date?
            }
            if  let created = PPRUtils.objectOrNSNull(object: attributeDict[DataKeys.kCreated] as AnyObject?) {
                self.created = created as? String
            }
            if let extendedWarranty = PPRUtils.objectOrNSNull(object: attributeDict[DataKeys.kExtendedWarranty] as AnyObject?) {
                self.isExtendedWarranty = extendedWarranty.boolValue
            }
            if let productID = PPRUtils.objectOrNSNull(object: attributeDict[DataKeys.kProductID] as AnyObject?) {
                self.productID = productID as? String
            }
            if let warrantyInMonths = PPRUtils.objectOrNSNull(object: attributeDict[DataKeys.kWarrantyInMonths] as AnyObject?) {
                self.warrantyInMonths = warrantyInMonths as? String
            }
        }
    }
    
    fileprivate func dictionaryRepresentation() -> NSDictionary{
        let mutableDict = NSMutableDictionary(capacity: 0)
        
        mutableDict.setValue(self.contractNumber, forKey: DataKeys.kContractNumber)
        mutableDict.setValue(self.created, forKey:DataKeys.kCreated)
        mutableDict.setValue(self.deviceId, forKey:DataKeys.kDeviceId)
        mutableDict.setValue(self.deviceName, forKey:DataKeys.kDeviceName)
        mutableDict.setValue(self.isExtendedWarranty, forKey:DataKeys.kExtendedWarranty)
        mutableDict.setValue(self.ID, forKey:DataKeys.kId)
        mutableDict.setValue(self.isGenerations, forKey:DataKeys.kIsGenerations)
        mutableDict.setValue(self.isPrimaryUser, forKey:DataKeys.kIsPrimaryUser)
        mutableDict.setValue(self.lastModified, forKey:DataKeys.kLastModified)
        mutableDict.setValue(self.lastSolicitDate, forKey:DataKeys.kLastSolicitDate)
        mutableDict.setValue(self.lastUpdated, forKey:DataKeys.kLastUpdated)
        mutableDict.setValue(self.productCatalogLocaleId, forKey: DataKeys.kProductCatalogLocaleId)
        mutableDict.setValue(self.productID, forKey:DataKeys.kProductID)
        mutableDict.setValue(self.productModelNumber, forKey:DataKeys.kProductModelNumber)
        mutableDict.setValue(self.productRegistrationID, forKey:DataKeys.kProductRegistrationID)
        mutableDict.setValue(self.productSerialNumber, forKey:DataKeys.kProductSerialNumber)
        mutableDict.setValue(self.purchaseDate, forKey:DataKeys.kPurchaseDate)
        mutableDict.setValue(self.purchasePlace, forKey:DataKeys.kPurchasePlace)
        mutableDict.setValue(self.registrationChannel, forKey:DataKeys.kRegistrationChannel)
        mutableDict.setValue(self.registrationDate, forKey:DataKeys.kRegistrationDate)
        mutableDict.setValue(self.isSlashWinCompetition, forKey:DataKeys.kSlashWinCompetition)
        mutableDict.setValue(self.uuid, forKey:DataKeys.kUuid)
        mutableDict.setValue(self.warrantyInMonths, forKey:DataKeys.kWarrantyInMonths)
        mutableDict.setValue(self.warrantyExpires, forKey: DataKeys.kExtendedWarrantyExpires)
        return mutableDict
    }
    
    override var description : String{
        return String(format: "%@", arguments: [self.dictionaryRepresentation()])
    }

}
