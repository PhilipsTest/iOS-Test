//
//  StorageProvider.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import AppInfra

class PPRStorageProvider {
    
    class func storeObject(_ obj: AnyObject!, key: String!) {
        
        let productData = NSKeyedArchiver.archivedData(withRootObject: obj)
        do {
            try PPRInterfaceInput.sharedInstance.appDependency.appInfra.storageProvider.storeValue(forKey: key, value: productData as NSCoding)
        }
        catch _ {
            print("Items not saved error")
        }
    }
    
    class func fetchObject(_ key: String!) -> AnyObject! {
        
        let _: NSError?
        var loadedProduct: AnyObject?
        do {
            let fetchedObject: Data = try PPRInterfaceInput.sharedInstance.appDependency.appInfra.storageProvider.fetchValue(forKey: key) as! Data

            loadedProduct = (NSKeyedUnarchiver.unarchiveObject(with: fetchedObject) as AnyObject?)
        }
        catch _ {
            //Delete the data which cannot be parsed
            PPRStorageProvider.removeFile(key)
            print("Items not fetched error")
        }
        
        return loadedProduct
    }
    
    class func removeFile(_ name: String!) {
        
        PPRInterfaceInput.sharedInstance.appDependency.appInfra.storageProvider.removeValue(forKey: PPRStorageProviderConst.kStorageIndex)
    }
}
