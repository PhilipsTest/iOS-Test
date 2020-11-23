//
//  PRXProductMetaDataInfoData.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation


class PRXProductMetaDataInfoData:NSObject {
    private struct DataKeys {
        static let kDataIsConnectedDevice = "isConnectedDevice"
        static let kDataExtendedWarrantyMonths = "extendedWarrantyMonths"
        static let kDataCtn = "ctn"
        static let kDataHasGiftPack = "hasGiftPack"
        static let kDataIsLicensekeyRequired = "isLicensekeyRequired"
        static let kDataRequiresSerialNumber = "requiresSerialNumber"
        static let kDataMessage = "message"
        static let kDataSerialNumberFormat = "serialNumberFormat"
        static let kDataRequiresDateOfPurchase = "requiresDateOfPurchase"
        static let kDataHasExtendedWarranty = "hasExtendedWarranty"
        static let kDataSerialNumberSampleContent = "serialNumberSampleContent"
    }
    
    private (set) var isConnectedDevice : Bool = false
    private (set) var extendedWarrantyMonths : Double = 0
    private (set) var ctn : String?
    private (set) var hasGiftPack : Bool = false
    private (set) var isLicensekeyRequired : Bool = false
    private (set) var isRequiresSerialNumber : Bool = false
    private (set) var message : String?
    private (set) var serialNumberFormat : String?
    private (set) var isRequiresDateOfPurchase : Bool = false
    private (set) var hasExtendedWarranty : Bool = false
    var serialNumberData : PRXProductMetadataSerialContentData?
    
    class func modelObjectWithDictionary(dict: NSDictionary) -> PRXProductMetaDataInfoData{
        return PRXProductMetaDataInfoData(withDictonary: dict)
    }
    
    private init(withDictonary dict:NSDictionary) {
        super.init()
        if  PPRUtils.isDictionary(dictionary: dict) {
            if let connectedDevice = PPRUtils.objectOrNSNull(object: dict[DataKeys.kDataIsConnectedDevice] as AnyObject?) {
                self.isConnectedDevice = connectedDevice.boolValue
            }
            if let extendedWarrantyMonths = PPRUtils.objectOrNSNull(object: dict[DataKeys.kDataExtendedWarrantyMonths] as AnyObject?) {
                self.extendedWarrantyMonths = extendedWarrantyMonths.doubleValue
            }
            if let ctn = PPRUtils.objectOrNSNull(object: dict[DataKeys.kDataCtn] as AnyObject?) {
                self.ctn = ctn as? String
            }
            if let hasGiftPack = PPRUtils.objectOrNSNull(object: dict[DataKeys.kDataHasGiftPack] as AnyObject?) {
                self.hasGiftPack = hasGiftPack.boolValue
            }
            if let licensekeyRequired = PPRUtils.objectOrNSNull(object: dict[DataKeys.kDataIsLicensekeyRequired] as AnyObject?) {
                self.isLicensekeyRequired = licensekeyRequired.boolValue
            }
            if let requiresSerialNumber = PPRUtils.objectOrNSNull(object: dict[DataKeys.kDataRequiresSerialNumber] as AnyObject?) {
                self.isRequiresSerialNumber = requiresSerialNumber.boolValue
            }
            if let message = PPRUtils.objectOrNSNull(object: dict[DataKeys.kDataMessage] as AnyObject?) {
                self.message = message as? String
            }
            if let serialNumberFormat = PPRUtils.objectOrNSNull(object: dict[DataKeys.kDataSerialNumberFormat] as AnyObject?) {
                self.serialNumberFormat = serialNumberFormat as? String
            }
            if let requiresDateOfPurchase = PPRUtils.objectOrNSNull(object: dict[DataKeys.kDataRequiresDateOfPurchase] as AnyObject?) {
                self.isRequiresDateOfPurchase = requiresDateOfPurchase.boolValue
            }
            if let extendedWarranty = PPRUtils.objectOrNSNull(object: dict[DataKeys.kDataHasExtendedWarranty] as AnyObject?) {
                self.hasExtendedWarranty = extendedWarranty.boolValue
            }
            if let serialData = PPRUtils.objectOrNSNull(object: dict[DataKeys.kDataSerialNumberSampleContent] as AnyObject?) {
                if PPRUtils.isDictionary(dictionary: serialData) {
                    self.serialNumberData = PRXProductMetadataSerialContentData.modelObjectWithDictionary(dict: serialData as! NSDictionary)
                }
            }
        }
    }
    
    private func dictionaryRepresentation() -> NSDictionary{
        let mutableDict = NSMutableDictionary(capacity: 0)
        mutableDict.setValue(self.isConnectedDevice, forKey: DataKeys.kDataIsConnectedDevice)
        mutableDict.setValue(self.extendedWarrantyMonths, forKey:DataKeys.kDataExtendedWarrantyMonths)
        mutableDict.setValue(self.ctn, forKey:DataKeys.kDataCtn)
        mutableDict.setValue(self.hasGiftPack, forKey:DataKeys.kDataHasGiftPack)
        mutableDict.setValue(self.isLicensekeyRequired, forKey:DataKeys.kDataIsLicensekeyRequired)
        mutableDict.setValue(self.isRequiresSerialNumber, forKey:DataKeys.kDataRequiresSerialNumber)
        mutableDict.setValue(self.message, forKey:DataKeys.kDataMessage)
        mutableDict.setValue(self.serialNumberFormat, forKey:DataKeys.kDataSerialNumberFormat)
        mutableDict.setValue(self.isRequiresDateOfPurchase, forKey:DataKeys.kDataRequiresDateOfPurchase)
        mutableDict.setValue(self.hasExtendedWarranty, forKey:DataKeys.kDataHasExtendedWarranty)
        return mutableDict
    }
    
    override var description : String{
        return String(format: "%@", arguments: [self.dictionaryRepresentation()])
    }
}
