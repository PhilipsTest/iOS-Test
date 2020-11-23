/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
@testable import InAppPurchaseDev

class IAPTestAddressSyncHelper: IAPAddressSyncHelper {

    var shouldInvokeFailureForGetDefaultaddress = false
    var shouldReturnNilDefaultAddress = false
    var shouldReturnFalseForSetDefaultAddress = false
    var shouldInvokeFailureForSetDeliveryAddress = false

    override func getDefaultAddress(_ success: @escaping (IAPUserAddress?)-> Void, failure: @escaping (NSError)->()) {
        guard false == shouldInvokeFailureForGetDefaultaddress else {
            let error = NSError(domain: "Test Generated Error", code: 11111, userInfo: nil)
            failure(error)
            return
        }

        guard false == shouldReturnNilDefaultAddress else {
            success(nil)
            return
        }

        let dict = self.deserializeData("IAPOCCGetUser")!

        if let valDict = dict["defaultAddress"] as? [String: AnyObject] {
            success(IAPUserAddress(inDict: valDict))
        } else {
            success(nil)
        }
    }
    var shouldInvokeErrorForAddAddress = false
    var didInvokeAddDeliveryAddress = false
    override func addDeliveryAddress(_ inAddress:IAPUserAddress, success:@escaping (IAPUserAddress)->(),
                                     failure:@escaping (NSError)->()) {
        didInvokeAddDeliveryAddress = true
        guard false == shouldInvokeErrorForAddAddress else {
            let error = NSError(domain: "Test Generated Error", code: 11111, userInfo: nil)
            failure(error)
            return
        }

        if let dict = self.deserializeData("IAPOCCGetUser"), let data = dict["defaultAddress"] as? [String: AnyObject] {
            success(IAPUserAddress(inDict: data))
        } else  {
            failure(NSError(domain: "Test Generated Error", code: 11111, userInfo: nil))
        }
    }
    override func setDeliveryAddressID(_ addressID: String, success: @escaping (Bool)->(), failure: @escaping (NSError)->()) {
        guard false == shouldInvokeFailureForSetDeliveryAddress else {
            let error = NSError(domain: "Test Generated Error", code: 11111, userInfo: nil)
            failure(error)
            return
        }
        guard false == shouldReturnFalseForSetDefaultAddress else {
            success(false)
            return
        }
        success(true)
    }

    var shouldInvokeErrorForUpdateDeliveryAddress = false
    var shouldReturnFalseForUpdateDeliveryAddress = false
    var didInvokeUpdateDeliveryAddress = false
    override func updateDeliveryAddress(_ inAddress:IAPUserAddress, isDefaultAddress:Bool = false, success:@escaping (Bool)->(), failure:@escaping (NSError)->()) {
        didInvokeUpdateDeliveryAddress = true
        guard false == shouldInvokeErrorForUpdateDeliveryAddress else {
            let error = NSError(domain: "Test Generated Error", code: 11111, userInfo: nil)
            failure(error)
            return
        }

        guard false == shouldReturnFalseForUpdateDeliveryAddress else {
            success(false)
            return
        }

        success(true)
    }
}

extension IAPTestAddressSyncHelper {
    func deserializeData (_ withJSONName:String) -> [String: AnyObject]? {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: withJSONName, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                return nil
        }
        var jsonDict: [String: AnyObject]?
        do {
            jsonDict = try JSONSerialization.jsonObject(with: data,
                                                        options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String:  AnyObject]
        } catch let inError as NSError {
            print("\(inError) is the error while converting JSON")
        }
        return jsonDict
    }
}

