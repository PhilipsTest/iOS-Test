//
//  PRXProductMetadataSerialData.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation

class PRXProductMetadataSerialContentData : NSObject {
    private struct DataKeys {
        static let kSerialNumberSampleContentSnExample = "snExample"
        static let kSerialNumberSampleContentTitle = "title"
        static let kSerialNumberSampleContentDescription = "description"
        static let kSerialNumberSampleContentSnFormat = "snFormat"
        static let kSerialNumberSampleContentAsset = "asset"
    }
    
    internal var snExample : String?
    internal var title : String?
    internal var serialNumberSampleContentDescription : String?
    internal var snFormat : String?
    internal var asset : String?
   
    class func modelObjectWithDictionary(dict: NSDictionary) -> PRXProductMetadataSerialContentData{
        return PRXProductMetadataSerialContentData(withDictonary: dict)
    }
    
    private init(withDictonary dict:NSDictionary) {
        super.init()
        if PPRUtils.isDictionary(dictionary: dict) {
            if  let snExample = PPRUtils.objectOrNSNull(object: dict[DataKeys.kSerialNumberSampleContentSnExample] as AnyObject?) {
                self.snExample = snExample as? String
            }
            if let title = PPRUtils.objectOrNSNull(object: dict[DataKeys.kSerialNumberSampleContentTitle] as AnyObject?) {
                self.title = title as? String
            }
            if let serialNumberSampleContentDescription = PPRUtils.objectOrNSNull(object: dict[DataKeys.kSerialNumberSampleContentDescription] as AnyObject?)
            {
                self.serialNumberSampleContentDescription = serialNumberSampleContentDescription as? String
            }
            if let snFormat = PPRUtils.objectOrNSNull(object: dict[DataKeys.kSerialNumberSampleContentSnFormat] as AnyObject?) {
                self.snFormat = snFormat as? String
            }
            if let asset = PPRUtils.objectOrNSNull(object: dict[DataKeys.kSerialNumberSampleContentAsset] as AnyObject?)  {
                self.asset = asset as? String
            }
        }
    }
    
    private func dictionaryRepresentation() -> NSDictionary{
        let mutableDict = NSMutableDictionary(capacity: 0)
        mutableDict.setValue(self.snExample, forKey: DataKeys.kSerialNumberSampleContentSnExample)
        mutableDict.setValue(self.title, forKey:DataKeys.kSerialNumberSampleContentTitle)
        mutableDict.setValue(self.serialNumberSampleContentDescription, forKey:DataKeys.kSerialNumberSampleContentDescription)
        mutableDict.setValue(self.snFormat, forKey:DataKeys.kSerialNumberSampleContentSnFormat)
        mutableDict.setValue(self.asset, forKey:DataKeys.kSerialNumberSampleContentAsset)
        return mutableDict
    }
    
    override var description : String{
        return String(format: "%@", arguments: [self.dictionaryRepresentation()])
    }
    
}
