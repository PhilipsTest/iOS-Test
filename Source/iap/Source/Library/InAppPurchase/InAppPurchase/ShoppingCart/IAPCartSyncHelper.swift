/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPCartSyncHelper {
    
    // MARK:
    // MARK: Cart related methods
    // MARK:
    func syncShoppingCartWithProducts(_ product: ProductInfo?,
                                      success: @escaping (Bool) -> (),
                                      failure: @escaping (NSError) -> ()) {
        
        if let accessToken = IAPConfiguration.sharedInstance.getJanrinAccessToken(){
        let oauthManager = IAPOAuthDownloadManager(janRainAccessToken: accessToken)
        let httpInterface = oauthManager?.getInterfaceForOAuth()
        oauthManager?.getOAuthTokenWithInterface(httpInterface!, successCompletion: { (oauthInfo:IAPOAuthInfo) -> () in
            if let productToAdd = product {
                self.checkAndAddProduct(productToAdd, success: { (inSuccess: Bool, cartCreated: Bool) -> () in success(inSuccess) },
                                        failure: { (inError: NSError) -> () in failure(inError) })
            }
            else {
                success(true)
            }
        }) { (inError:NSError) -> () in
            failure(inError)
        }
        }else{
            let userInfo = [NSLocalizedDescriptionKey: IAPLocalizedString("iap_access_token_notfound") ?? ""]
            let customError = NSError(domain: "IAPCartSync", code: 0, userInfo: userInfo)
            failure(customError)
        }
    }
    
    func createCart(_ success:@escaping (IAPCartInfo?)->(),failure:@escaping (NSError)->()) {
        let cartInterfaceBuilder = IAPUtility.getCartInterfaceBuilder()
        let occInteface = cartInterfaceBuilder.buildInterface()
        let httpInterface = occInteface.getInterfaceForCreateCart()
        occInteface.createNewCart(httpInterface, completionHandler : { (withObject) -> () in
            success(withObject)
        }) { (inError:NSError) -> () in
            failure(inError)
        }
    }
    
    func updateCart(_ cartID:String = "current", inQuantity:Int=0, inProductCode:String, inEntryNumber:Int,  success:@escaping (Bool)->(), failure:@escaping (NSError)->()) {
        let cartInterfaceBuilder = IAPUtility.getCartInterfaceBuilder()
        let occInterface            = cartInterfaceBuilder.withCartID(cartID).withProductCode(inProductCode).withEntryNumber(inEntryNumber).withQuantity(inQuantity).buildInterface()
        
        let httpInteface = occInterface.getInterfaceForUpdateCart()
        occInterface.updateCart(httpInteface, completionHandler: { (inSuccess) in
            success(inSuccess)
        }, failureHandler: { (addProductError:NSError) -> () in
            failure(addProductError)
        })
    }

    func deleteCurrentCart(_ cartID: String = "current", success:@escaping (Bool)->(), failure:@escaping (NSError)->()) {
        let cartInterfaceBuilder = IAPUtility.getCartInterfaceBuilder()
        let occInterface            = cartInterfaceBuilder.withCartID(cartID).buildInterface()
        let httpInterface = occInterface.getInterfaceForDeleteCart()
        
        occInterface.deleteCart(httpInterface, completionHandler : { (inSuccess) in
            success(inSuccess)
        }) { (inError) in
            failure(inError)
        }
    }
    
    func getCartsForUser(_ success:@escaping (Int)->(),failure:@escaping (NSError)->()) {
        let cartInterfaceBuilder = IAPUtility.getCartInterfaceBuilder()
        let occInteface = cartInterfaceBuilder.buildInterface()
        let httpInterface = occInteface.getInterfaceForGetCarts()
        occInteface.getCartsForUser(httpInterface, completionHandler: { (withObjects:[IAPCartInfo]) -> () in
            success(withObjects.count)
        }) { (inError:NSError) -> () in
            failure(inError)
        }
    }
    
    func checkForCartID(_ success: @escaping (String)->(),failure: @escaping (NSError)->()){
        let cartInterfaceBuilder = IAPUtility.getCartInterfaceBuilder()
        let occInteface = cartInterfaceBuilder.withCartID(IAPConstants.IAPAddressBuilderKeys.kCartsValue).withFetchDetail(false).buildInterface()
        let httpInterface = occInteface.getInterfaceForGetCartDetails()
        occInteface.getCartDetails(httpInterface,completionHandler:  { (_, withObject) -> () in
            if let cartId = withObject?.cartID{
                success(cartId)
            }
        }) { (inError: NSError) -> () in
            failure(inError)
        }
    }
    
    func getCartCount(_ cartID: String = "current",success:@escaping (Int)->(), failure: @escaping (NSError)->()) {
        let cartInterfaceBuilder = IAPUtility.getCartInterfaceBuilder()
        let occInteface = cartInterfaceBuilder.withCartID(cartID).withFetchDetail(false).buildInterface()
        let httpInterface = occInteface.getInterfaceForGetCartDetails()
        occInteface.getCartDetails(httpInterface, completionHandler:  { (_, withObject) -> () in
            if nil != withObject?.totalItems {
                success(self.getProductQuantitesCount(withObject!))
            }
            else {
                success(0)
            }
        }) { (inError:NSError) -> () in
            failure(inError)
        }
    }
    
    func checkForProduct(_ productCode: String, success: @escaping (Bool)->(), failure: @escaping (NSError)->()) {
        let cartInterfaceBuilder = IAPUtility.getCartInterfaceBuilder()
        let occInteface = cartInterfaceBuilder.withCartID("current").withFetchDetail(false).buildInterface()
        let httpInterface = occInteface.getInterfaceForGetCartDetails()
        occInteface.getCartDetails(httpInterface,completionHandler:  { (_, withObject) -> () in
            if nil != withObject?.totalItems {
                success(self.isProductAlreadyAdded(productCode, cartInfo:withObject!))
            }
            else {
                success(false)
            }
        }) { (inError:NSError) -> () in
            failure(inError)
        }
    }
    
    func getCartDetails(_ success:@escaping (Bool,IAPCartInfo?)->(),failure:@escaping (NSError)->()){
        let cartInterfaceBuilder = IAPUtility.getCartInterfaceBuilder()
        let occInterface       = cartInterfaceBuilder.withFetchDetail(true).buildInterface()
        let httpInterface = occInterface.getInterfaceForGetCartDetails()
        occInterface.getCartDetails(httpInterface, completionHandler: { (inSuccess, withObject) -> () in
            let cartEntriesList = withObject?.entries
            if (cartEntriesList?.count)! > 0 {
                success(inSuccess,withObject)
            }
            else {
                success(inSuccess,nil)
            }
        }) {(inError:NSError) in
            failure(inError)
        }
    }
    
    // MARK:
    // MARK: Voucher related methods
    // MARK:
    
    func applyVoucher(_ cartID:String = "current", voucherID:String,  success:@escaping (Bool)->(), failure:@escaping (NSError)->()){
        let cartInterfaceBuilder = IAPUtility.getCartInterfaceBuilder()
        let occInterface = cartInterfaceBuilder.withCartID(cartID).withVoucherCode(voucherID).buildVoucherInterface()
        let httpInteface = occInterface.getInterfaceForApplyVoucher()
        occInterface.applyVoucher(httpInteface, completionHandler:{ (inSuccess) in
            success(inSuccess)
        }) { (inError:NSError) in
            failure(inError)
        }
    }

    func getAppliedVoucherList(_ success:@escaping (IAPVoucherList)->(),failure:@escaping (NSError)->()){
        let voucherInterfaceBuilder = IAPUtility.getCartInterfaceBuilder()
        let occInterface  = voucherInterfaceBuilder.buildVoucherInterface()
        let httpInterface = occInterface.getInterfaceForAppliedVoucherList()
        occInterface.getAppliedVoucherList(httpInterface, completionHandler: {(voucherList:IAPVoucherList)->() in
            success(voucherList)
        }) {(inError:NSError)->() in
            failure(inError)
        }
    }
    
    func removeVoucher(_ cartID:String = "current", voucherID:String,  success:@escaping (Bool)->(), failure:@escaping (NSError)->()){
        let cartInterfaceBuilder = IAPUtility.getCartInterfaceBuilder()
        let occInterface = cartInterfaceBuilder.withCartID(cartID).withVoucherCode(voucherID).buildVoucherInterface()
        let httpInteface = occInterface.getInterfaceForRemoveVoucher()
        occInterface.removeVoucher(httpInteface, completionHandler:{ (inSuccess) in
            success(inSuccess)
        }) { (inError:NSError) in
            failure(inError)
        }
    }

    func addProduct(_ product:ProductInfo, success : @escaping (Bool) -> (), failure : @escaping (NSError) -> ()) {
        self.addProductToCart(product, success: success, failure: failure)
    }
    
    // MARK:
    // MARK: Private methods
    // MARK:
    func checkAndAddProduct(_ product: ProductInfo,
                            success: @escaping (Bool, Bool) -> (),
                            failure: @escaping (NSError) -> ()) {
        let cartInterfaceBuilder = IAPUtility.getCartInterfaceBuilder()
        let occInteface = cartInterfaceBuilder.buildInterface()
        let httpInterface = occInteface.getInterfaceForGetCarts()
        occInteface.getCartsForUser(httpInterface, completionHandler: { (withObjects:[IAPCartInfo]) -> () in
            if withObjects.count > 0 {
                self.addProductToCart(product,
                                      success: { (inSuccess:Bool) -> () in
                                        success(inSuccess, false)
                }, failure: { (inError:NSError) -> () in
                    failure(inError)
                })
            } else {
                self.createCartWithProduct(product,
                                           success: { (inSuccess: Bool) -> () in
                                            success(inSuccess, true)
                }, failure: { (wasCartCreated: Bool, inError:NSError) -> () in
                    failure(inError)
                })
            }
        }, failureHandler: { (cartFetchError:NSError) -> () in
            failure(cartFetchError)
        })
    }

    fileprivate func addProductToCart(_ product:ProductInfo, success : @escaping (Bool) -> (), failure : @escaping (NSError) -> ()) {
        let cartInterfaceBuilder = IAPUtility.getCartInterfaceBuilder()
        let occInterface = cartInterfaceBuilder.withProductCode(product.productCTN).withQuantity(product.productQuanity).buildInterface()
        let httpInteface = occInterface.getInterfaceForAddProduct()
        occInterface.addProductToCart(httpInteface, completionHandler: { (inSuccess) in
            success(inSuccess)
        }, failureHandler: { (addProductError:NSError) -> () in
            failure(addProductError)
        })
    }
    
    func createCartWithProduct(_ product:ProductInfo, success: @escaping (Bool) -> (), failure : @escaping (Bool, NSError) -> ()) {
        let cartInterfaceBuilder = IAPUtility.getCartInterfaceBuilder()
        let occInteface = cartInterfaceBuilder.buildInterface()
        let httpInterface = occInteface.getInterfaceForCreateCart()
        occInteface.createNewCart(httpInterface, completionHandler : { (withObject) -> () in
            self.addProductToCart(product, success: { (inSuccess:Bool) -> () in
                success(inSuccess)
            }, failure: { (inError:NSError) -> () in
                failure(true, inError)
            })
        }, failureHandler: { (inError:NSError) -> () in
            failure(false, inError)
        })
    }
    
    fileprivate func getProductQuantitesCount(_ inCartObject:IAPCartInfo)->Int {
        return inCartObject.totalUnitCount
    }
    
    fileprivate func isProductAlreadyAdded(_ productCode: String, cartInfo: IAPCartInfo)->Bool {
        let products = cartInfo.entries
        let filteredProduct = products.filter{ $0.getProductCTN()==productCode }
        return (0 != filteredProduct.count)
    }
    
    func getPaymentDetails(_ success: @escaping (IAPPaymentDetailsInfo)->(), failure: @escaping (NSError)->()) {
        let paymentInterfaceBuilder = IAPUtility.getPaymentInterfaceBuilder()
        let occInterface = paymentInterfaceBuilder.buildInterface()
        let httpInterface = occInterface.getInterfaceForPaymentDetails()
        occInterface.getPaymentDetailsForUserUsingInterface(httpInterface,
                                                            completionHandler: {(withPayments: IAPPaymentDetailsInfo) -> () in
                                                                success(withPayments)
        }) { (inError:NSError) -> () in
            failure(inError)
        }
    }
    
    func makePaymentForUser(_ orderId: String,
                            inAddress: IAPUserAddress,
                            success: @escaping (IAPMakePaymentInfo)->(), failure:@escaping (NSError)->()) {
        let paymentInterfaceBuilder = IAPUtility.getPaymentInterfaceBuilder()
        paymentInterfaceBuilder.initialiseBuilder(with: inAddress)
        let occInterface = paymentInterfaceBuilder.withOrderID(orderId).buildInterface()
        occInterface.addressID = inAddress.addressId
        let httpInterface = occInterface.getInterfaceForMakePayment()
        occInterface.makePaymentDetailsForUserUsingInterface(httpInterface, completionHandler: { (withPayments:IAPMakePaymentInfo) -> () in
            success(withPayments)
        }) { (inError:NSError) -> () in
            failure(inError)
        }
    }
    
    func submitOrderForUser(_ inCVV: String, success: @escaping (IAPOrderInfo)->(), failure: @escaping (NSError)->()) {
        let paymentInterfaceBuilder = IAPUtility.getPaymentInterfaceBuilder()
        let occInterface = paymentInterfaceBuilder.withCVV(inCVV).buildInterface()
        let httpInterface = occInterface.getInterfaceForPlacingOrder()
        occInterface.placeOrderForUserUsingInterface(httpInterface, completionHandler: { (withOrder:IAPOrderInfo) -> () in
            success(withOrder)
        }) { (inError:NSError) -> () in
            failure(inError)
        }
    }
    
    func setReauthPaymentForUser(_ paymentId: String, success: @escaping (Bool)->(), failure: @escaping (NSError)->()) {
        let paymentInterfaceBuilder = IAPUtility.getPaymentInterfaceBuilder()
        let occInterface = paymentInterfaceBuilder.withPaymentID(paymentId).buildInterface()
        let httpInterface = occInterface.getInterfaceForPaymentReauth()
        occInterface.setReauthPaymentDetailsForUserUsingInterface(httpInterface, completionHandler: { (inSuccess) -> () in
            success(inSuccess)
        }) { (inError:NSError) -> () in
            failure(inError)
        }
    }
}
