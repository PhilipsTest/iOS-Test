/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
@testable import InAppPurchaseDev

class IAPTestCartSyncHelper: IAPCartSyncHelper {
    var shouldInvokeFailureForSyncing = false
    var shouldInvokeFailureForDeletion = false
    var shouldInvokeFailureForCartCreation = false
    var shouldInvokeFailureForAddProduct = false
    var cartCountToReturn = 0
    var productCount = 0
    var createNoCartError = false
    var shouldInvokeErrorForCheckProduct = false
    var returnFalseForProductCheck = false
    var shouldInvokeFailureForGetDefaultaddress = false
    var shouldReturnNilDefaultAddress = false
    var shouldInvokeFailureForSetDeliveryAddress = false
    var shouldReturnFalseForSetDefaultAddress = false
    var shouldInvokeFailureForGetDeliveryMode = false
    var shouldReturnEmptyForGetDeliveryMode = false
    var shouldInvokeFailureForSetDeliveryMode = false
    var shouldReturnFalseForSetDeliveryMode = false

    
    override func syncShoppingCartWithProducts(_ product: ProductInfo?,
                                               success: @escaping (Bool) -> Void,
                                               failure: @escaping (NSError) -> Void) {
        guard false == shouldInvokeFailureForSyncing else {
            let error = NSError(domain: "Test Generated Error", code: 11111, userInfo: nil)
            failure(error)
            return
        }
        success(true)
    }
    
    override func getCartsForUser(_ success:@escaping (Int) -> Void, failure:@escaping (NSError) -> Void) {
        guard cartCountToReturn >= 0 else {
            let error = NSError(domain: "Test Generated Error", code: 11111, userInfo: nil)
            failure(error)
            return
        }
        success(cartCountToReturn)
    }

    override func deleteCurrentCart(_ cartID: String = "current",
                                    success:@escaping (Bool)->(),
                                    failure:@escaping (NSError)->()) {
        guard false == shouldInvokeFailureForDeletion else {
            let error = NSError(domain: "Test Generated Error", code: 11111, userInfo: nil)
            failure(error)
            return
        }
        
        success(true)
    }
    
    override func createCart(_ success:@escaping (IAPCartInfo?)->(),failure:@escaping (NSError)->()) {
        guard false == shouldInvokeFailureForCartCreation else {
            let error = NSError(domain: "Test Generated Error", code: 11111, userInfo: nil)
            failure(error)
            return
        }
        
        let dict = self.deserializeData("IAPOCCCreateCart")!
        success(IAPCartInfo(inDict: dict as NSDictionary))
    }
    
    override func checkAndAddProduct(_ product:ProductInfo, success : @escaping (Bool,Bool) -> (), failure : @escaping (NSError) -> ()) {
        guard false == shouldInvokeFailureForAddProduct else {
            let error = NSError(domain: "Test Generated Error", code: 11111, userInfo: nil)
            failure(error)
            return
        }
        success(true,true)
    }

    override func getCartCount(_ cartID: String = "current",
                               success:@escaping (Int)->(),
                               failure: @escaping (NSError)->()) {
        guard productCount >= 0 else {
            var error = NSError(domain: "Test Generated Error", code: 11111, userInfo: nil)
            if createNoCartError {
                error = NSError(domain: "Test Generated Error", code: 11111,
                                userInfo: [NSLocalizedDescriptionKey: IAPConstants.IAPCartError.kNoCartError])
            }
            failure(error)
            return
        }
        
        success(productCount)
    }
    
    override func addProduct(_ product: ProductInfo,
                             success: @escaping (Bool) -> (), failure: @escaping (NSError) -> ()) {
        guard false == shouldInvokeFailureForAddProduct else {
            let error = NSError(domain: "Test Generated Error", code: 11111, userInfo: nil)
            failure(error)
            return
        }
        
        success(true)
    }
    
    override func checkForProduct(_ productCode: String,
                                  success: @escaping (Bool)->(),
                                  failure: @escaping (NSError)->()) {
        guard false == shouldInvokeErrorForCheckProduct else {
            let error = NSError(domain: "Test Generated Error", code: 11111, userInfo: nil)
            failure(error)
            return
        }
        
        guard returnFalseForProductCheck == false else {
            success(false)
            return
        }
        success(true)
    }
    
    var shouldInvokeErrorForPaymentDetails = false
    var didInvokeGetPAymentDetails = false
    override func getPaymentDetails(_ success:@escaping (IAPPaymentDetailsInfo)->(),failure:@escaping (NSError)->()) {
        didInvokeGetPAymentDetails = true
        guard false == shouldInvokeErrorForPaymentDetails else {
            let error = NSError(domain: "Test Generated Error", code: 11111, userInfo: nil)
            failure(error)
            return
        }
        
        let dict = self.deserializeData("IAPPaymentDetailsInfo")!
        success(IAPPaymentDetailsInfo(inDict: dict))
    }
}

extension IAPTestCartSyncHelper {
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
