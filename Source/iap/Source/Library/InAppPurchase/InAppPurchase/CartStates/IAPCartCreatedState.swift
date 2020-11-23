/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPCartCreatedState: IAPCartStateProtocol {
    var syncHandler: IAPCartSyncHelper!
    weak var client: IAPInterface?
    var wasCartCreated = false
    
    init () {
        syncHandler = IAPCartSyncHelper()
    }
    
    func fetchCartCount(_ success:@escaping (Int)->(),failureHandler:@escaping (NSError)->()) {
        guard nil != IAPConfiguration.sharedInstance.oauthInfo else {
            syncHandler.syncShoppingCartWithProducts(nil,success: { (inSuccess:Bool) -> () in
                self.getNumberOfCartsAndFetchCount(success, failureHandler: failureHandler)
            }) { (inError:NSError) -> () in failureHandler(inError) }
            return
        }
        
        self.getNumberOfCartsAndFetchCount(success, failureHandler: failureHandler)
    }
    
    func addProduct(_ productCode: String, success: @escaping (Bool) -> (), failureHandler: @escaping (NSError) -> ()) {
        guard nil != IAPConfiguration.sharedInstance.oauthInfo else {
            syncHandler.syncShoppingCartWithProducts(nil,success: { (inSuccess:Bool) -> () in
                self.syncHandler.addProduct(ProductInfo(productCTN: productCode, quantity: 1)!, success: { (inSuccess: Bool) in
                    self.client?.getCartDelegate()?.didUpdateCartCount()
                    guard self.wasCartCreated == true else { success(inSuccess); return }
                    self.wasCartCreated = false
                    let cartStateHelper = IAPCartCreatedStateHelper(withSuccess:success)
                    cartStateHelper.setAddressAndDeliveryMode()
                    }, failure: failureHandler)
            }) { (inError:NSError) -> () in failureHandler(inError) }
            return
        }
        
        self.syncHandler.addProduct(ProductInfo(productCTN: productCode, quantity: 1)!, success: { (inSuccess: Bool) in
            self.client?.getCartDelegate()?.didUpdateCartCount()
            guard self.wasCartCreated == true else { success(inSuccess); return }
            self.wasCartCreated = false
            let cartStateHelper = IAPCartCreatedStateHelper(withSuccess:success)
            cartStateHelper.setAddressAndDeliveryMode()
            }, failure: failureHandler)
    }
    
    func buyProduct(_ productCode: String, success: @escaping (Bool) -> (), failureHandler: @escaping (NSError) -> ()) {
        guard nil != IAPConfiguration.sharedInstance.oauthInfo else {
            self.checkAndAddProduct(productCode, success: success, failureHandler: failureHandler)
            return
        }
        self.checkAndAddProduct(productCode, success: success, failureHandler: failureHandler)
    }
    
    fileprivate func checkAndAddProduct (_ productCode: String, success: @escaping (Bool) -> (), failureHandler: @escaping (NSError) -> ()) {
        syncHandler.checkForProduct(productCode,success:{(shouldAdd:Bool) -> () in
            guard true == shouldAdd else {
                self.addProduct(productCode, success: { (inSuccess:Bool) -> () in
                    self.client?.getCartDelegate()?.didUpdateCartCount()
                    success(inSuccess)
                }) { (inError:NSError) -> () in
                    failureHandler(inError)
                }
                return
            }
            success(true)
        }) { (inError:NSError) -> () in
            failureHandler(inError)
        }
    }
    
    fileprivate func checkForNoCartError(_ inError:NSError,success:(Int)->(),failureHandler:(NSError)->()) {
        if inError.localizedDescription == IAPConstants.IAPCartError.kNoCartError {
            success(0)
            self.client?.getCartDelegate()?.didUpdateCartCount()
            self.client?.setCartState(IAPNoCartState())
        } else {
            failureHandler(inError)
        }
    }
    
    fileprivate func getNumberOfCartsAndFetchCount(_ success:@escaping (Int)->(),failureHandler:@escaping (NSError)->()) {
        self.syncHandler.getCartsForUser({ (inCount) in
            switch inCount {
            case 0:
                success(0)
                self.client?.setCartState(IAPNoCartState())
                break
                
            case 1:
                self.getCountOfCart(success, failureHandler: failureHandler)
                break
                
            default:
                break
            }
            
        }) { (inError) in
            failureHandler(inError)
        }
    }
    
    fileprivate func deleteCurrentCart(_ success:@escaping (Int)->(),failureHandler:@escaping (NSError)->()) {
        self.syncHandler.deleteCurrentCart(success: { (inSuccess) in
            self.getCountOfCart(success, failureHandler: failureHandler)
        }) { (inError) in
            failureHandler(inError)
        }
    }
    
    fileprivate func getCountOfCart(_ success:@escaping (Int)->(),failureHandler:@escaping (NSError)->()) {
        self.syncHandler.getCartCount(success: { (count:Int) -> () in
            success(count)
        }) {(inError:NSError) -> () in
            self.checkForNoCartError(inError,success:success,failureHandler:failureHandler)
        }
    }
}
