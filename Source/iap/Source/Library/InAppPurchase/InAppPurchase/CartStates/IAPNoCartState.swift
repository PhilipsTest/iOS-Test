/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPNoCartState:IAPCartStateProtocol {
    weak var client: IAPInterface?
    var syncHandler: IAPCartSyncHelper!
    
    init () {
        syncHandler = IAPCartSyncHelper()
    }

    func fetchCartCount(_ success:@escaping (Int)->(),failureHandler:@escaping (NSError)->()) {
        
        guard nil != IAPConfiguration.sharedInstance.oauthInfo else {
            syncHandler.syncShoppingCartWithProducts(nil,success: { (inSuccess:Bool) -> () in
                self.checkAndFetchCartCount(success,failureHandler:failureHandler)
            }) { (inError:NSError) -> () in
                failureHandler(inError)
            }
            return
        }
        self.checkAndFetchCartCount(success,failureHandler:failureHandler)
    }
    
    func buyProduct(_ productCode:String,success:@escaping (Bool)->(),failureHandler:@escaping (NSError)->()) {
        
        guard nil != IAPConfiguration.sharedInstance.oauthInfo else {
            syncHandler.syncShoppingCartWithProducts(nil,success: { (inSuccess:Bool) -> () in
                self.buyProductWithCode(productCode, success:success, failureHandler:failureHandler)
            }) { (inError:NSError) -> () in
                failureHandler(inError)
            }
            return
        }
        self.buyProductWithCode(productCode, success: success, failureHandler: failureHandler)
    }
    
    func addProduct(_ productCode:String,success:@escaping (Bool)->(),failureHandler:@escaping (NSError)->()) {
        
        guard nil != IAPConfiguration.sharedInstance.oauthInfo else {
            syncHandler.syncShoppingCartWithProducts(nil,success: { (inSuccess:Bool) -> () in
                self.syncHandler.checkAndAddProduct(ProductInfo(productCTN: productCode, quantity: 1)!, success: { (inSuccess: Bool, cartCreated: Bool) -> () in
                    self.setCartStateForCartCreation(cartCreated)
                    success(inSuccess)
                }) { (inError:NSError) -> () in failureHandler(inError) }
            }) { (inError:NSError) -> () in
                failureHandler(inError)
            }
            return
        }
        self.syncHandler.checkAndAddProduct(ProductInfo(productCTN: productCode, quantity: 1)!, success: { (inSuccess: Bool, cartCreated: Bool) -> () in
            self.setCartStateForCartCreation(cartCreated)
            success(inSuccess)
        }) { (inError:NSError) -> () in failureHandler(inError) }
        
    }
    
    // MARK:
    // MARK: Private Cart related methods
    // MARK:
    fileprivate func checkAndFetchCartCount(_ success:@escaping (Int)->(),failureHandler:@escaping (NSError)->()){
        syncHandler.getCartsForUser({ (inCount:Int) -> () in
            switch inCount {
                case 0:
                    success(0)
                    break
                    
                case 1:
                    self.client?.setCartState(IAPCartCreatedState())
                    self.client?.getCartState().fetchCartCount(success, failureHandler: failureHandler)
                    break
                    
                default:
                    break
            }
        }) { (inError:NSError) -> () in
                failureHandler(inError)
        }
    }
    
    fileprivate func buyProductWithCode(_ productCode: String,success: @escaping (Bool)->(),failureHandler: @escaping (NSError)->()) {
        syncHandler.checkForCartID({[weak self](cartId: String)-> () in
            guard let weakSelf = self else { return }
            guard cartId.isEmpty else{
                weakSelf.client?.setCartState(IAPCartCreatedState())
                weakSelf.client?.getCartState().buyProduct(productCode, success: success, failureHandler: failureHandler)
                return
            }
            weakSelf.createCartForUser({(inSuccess: Bool)->() in
                weakSelf.setCartStateForCartCreation(true)
                weakSelf.client?.getCartState().addProduct(productCode, success: success, failureHandler: failureHandler)
            }) {(inError: NSError) -> () in failureHandler(inError)}
            }
        ) { (inError: NSError) -> () in failureHandler(inError) }
    }
    
    fileprivate func createCartForUser(_ success:@escaping (Bool)->(),failureHandler:@escaping (NSError)->()) {
        syncHandler.createCart({ (withObject:IAPCartInfo?) -> () in
            success(true)
            }) {(inError:NSError) -> () in failureHandler(inError)
        }
    }
    
    fileprivate func setCartStateForCartCreation(_ inValue: Bool) {
        let cartState = IAPCartCreatedState()
        cartState.wasCartCreated = inValue
        self.client?.setCartState(cartState)
    }
}
