/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPOCCCartInterface: IAPOCCBaseInterface {
    
    var productCode: String!
    var quantity: Int!
    var entryNumber: Int!
    var shouldFetchDetail: Bool!
    var currentPage: Int!
    var pageSize: Int = 20
    var voucherCode: String!
    
    fileprivate func getCartCreationParameters(_ oauthModel: IAPOAuthInfo)->(String, [String: String]) {
        let cartBuilder = IAPCartBuilder(userID: userID)
        return (cartBuilder.getCreateCartURL(), getParameterDictForCartDownloads(oauthModel)!)
    }
    
    fileprivate func getCurrentCartParameters(_ oauthModel: IAPOAuthInfo)->(String, [String: String]) {
        let cartBuilder = IAPCartBuilder(userID: userID)
        return (cartBuilder.getCurrentCartURL(), getParameterDictForCartDownloads(oauthModel)!)
    }
    
    //This is to check whether the operation status code in hybris side is success or not
    func handleOCCResponse(_ occResponse: [String: AnyObject], successHandler:(_ isSuccess:Bool)->(),
                           failureHandler: (NSError)-> ()) {
        let statusCode = occResponse[IAPConstants.IAPOCCResponse.kStatusCode] as? String
        if  statusCode == IAPConstants.IAPOCCResponse.kSuccessStatusKey {
            successHandler(true)
        } else {
            var errorDomain = ""
            var errorMessage = ""
            if let errorExplanation = IAPLocalizedString(IAPConstants.IAPOutOfStockError.kProductStockDescriptionKey) {
                errorMessage = errorExplanation
            }
            
            if let domain = IAPLocalizedString(IAPConstants.IAPOutOfStockError.kOutOfStockKey) {
                errorDomain = domain
            }
            
            let error = NSError(domain: errorDomain, code: IAPConstants.IAPOutOfStockError.kProductOutOfStock,
                                userInfo: [NSLocalizedDescriptionKey: errorMessage])
            failureHandler(error)
        }
    }
    
    // MARK: -
    // MARK: Cart related API requests
    // MARK: -
    
    func getInterfaceForCreateCart() -> IAPHttpConnectionInterface {
        let (urlString,parameterDictionary) = self.getCartCreationParameters(IAPOAuthInfo.oAuthInfo())
        let httpInterface = IAPHttpConnectionInterface(request: urlString, httpHeaders: parameterDictionary,
                                                       bodyParameters: nil)
        return httpInterface
    }
     func createNewCart(_ interface: IAPHttpConnectionInterface,
                        completionHandler: @escaping IAPCartTypeAliases.CreateCartCompletionHandler,
                        failureHandler:@escaping IAPCartTypeAliases.CartFailureHandler) {
        interface.setSuccessCompletion{ (inDict: [String: AnyObject]) -> () in
            completionHandler(IAPCartInfo(inDict: inDict as NSDictionary))
        }
        interface.setFailurHandler{ (inError: NSError) -> () in
            failureHandler(inError)
        }
        interface.performPostRequest()
    }

    func getInterfaceForDeleteCart() -> IAPHttpConnectionInterface {
        let urlString = IAPCartBuilder(cartID: self.cartID, userID: self.userID).getCartDeleteURL()
        let parameterDictionary = self.getParameterDictForCartDownloads(IAPOAuthInfo.oAuthInfo())
        let httpInterface = IAPHttpConnectionInterface(request: urlString,
                                                       httpHeaders: parameterDictionary,
                                                       bodyParameters: nil)
        return httpInterface
    }
    
    func deleteCart(_ interface : IAPHttpConnectionInterface,
                    completionHandler: @escaping IAPCartTypeAliases.DeleteCartCompletionHandler,
                    failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        interface.setSuccessCompletion { (inDict: [String: AnyObject]) -> () in
            completionHandler(true)
        }
        interface.setFailurHandler{ (inError: NSError) -> () in
            failureHandler(inError)
        }
        
        interface.performDeleteRequest()
    }
    
    func getInterfaceForGetCarts() -> IAPHttpConnectionInterface {
        let (urlString, parameterDictionary) = self.getCurrentCartParameters(IAPOAuthInfo.oAuthInfo())
        let httpInterface = IAPHttpConnectionInterface(request: urlString,
                                                       httpHeaders: parameterDictionary, bodyParameters: nil)
        return httpInterface
    }
    
    func getCartsForUser(_ interface : IAPHttpConnectionInterface,
                         completionHandler: @escaping IAPCartTypeAliases.GetCartsCompletionHandler,
                         failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        
        interface.setSuccessCompletion{ (inDict: [String: AnyObject]) -> () in
            var arrayOfCarts = [IAPCartInfo]()
            if let carts = inDict[IAPConstants.IAPShoppingCartInfoKeys.kDeliveryOrderGroupsKey] as? [[String: AnyObject]] {
                arrayOfCarts = carts.map {(IAPCartInfo(inDict: $0 as NSDictionary))}
            }
            completionHandler(arrayOfCarts)
        }
        interface.setFailurHandler{ (inError:NSError) -> () in
            failureHandler(inError)
        }
        interface.performGetRequest()
    }
    
    func getInterfaceForGetCartDetails() -> IAPHttpConnectionInterface {
        let cartBuilder = IAPCartBuilder(cartID: self.cartID, userID: self.userID)
        var urlString = cartBuilder.getCartEntryDetailURL()
        if shouldFetchDetail == false {
            urlString = String(cartBuilder.getCartEntryURL().dropLast())
        }
        let parameterDictionary = self.getParameterDictForCartDownloads(IAPOAuthInfo.oAuthInfo())
        let httpInterface = IAPHttpConnectionInterface(request: urlString,
                                                       httpHeaders: parameterDictionary, bodyParameters: nil)
        return httpInterface
    }

    func getCartDetails(_ interface : IAPHttpConnectionInterface,
                        completionHandler: @escaping IAPCartTypeAliases.CartDetailsCompletionHandler,
                        failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        interface.setSuccessCompletion{ (inDict: [String: AnyObject]) -> () in
            completionHandler(true,IAPCartInfo(inDict: inDict as NSDictionary))
        }
        interface.setFailurHandler{ (inError:NSError) -> () in
            failureHandler(inError)
        }
        interface.performGetRequest()
    }
    
    func getInterfaceForAddProduct() -> IAPHttpConnectionInterface {
        let cartBuilder = IAPCartBuilder(cartID: self.cartID, userID: self.userID)
        let urlString = cartBuilder.getAddProductURL()
        let headerParameterDictionary = self.getParameterDictForCartDownloads(IAPOAuthInfo.oAuthInfo())
        let bodyParameterDictionary = [IAPConstants.IAPOCCHeader.kAddProductKey:self.productCode!,
                                       IAPConstants.IAPOCCHeader.kQuantityKey:"\(self.quantity!)"]
        let httpConnectionInterface = IAPHttpConnectionInterface(request: urlString,
                                                                 httpHeaders: headerParameterDictionary,
                                                                 bodyParameters: bodyParameterDictionary)
        return httpConnectionInterface
    }
    
    func addProductToCart (_ interface: IAPHttpConnectionInterface,
                           completionHandler: @escaping IAPCartTypeAliases.AddProductCompletionHandler,
                           failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        interface.setSuccessCompletion({ (inDict: [String: AnyObject]) -> () in
            self.handleOCCResponse(inDict, successHandler: { (isSuccess) -> () in
                completionHandler(isSuccess)
            }, failureHandler: failureHandler)
        })

        interface.setFailurHandler ({ (inError:NSError) -> () in
            failureHandler(inError)
        })
        
        interface.performPostRequest()
    }
    
    func getInterfaceForUpdateCart() -> IAPHttpConnectionInterface {
        let cartBuilder = IAPUpdateCartBuilder(inCartID: self.cartID,
                                               inUserID: self.userID,
                                               inEntryNumber: self.entryNumber)
        let urlString = cartBuilder.getUpdateCartURL()
        let headerParameterDictionary = self.getParameterDictForCartDownloads(IAPOAuthInfo.oAuthInfo())
        let bodyParameterDictionary = [IAPConstants.IAPOCCHeader.kAddProductKey:self.productCode!,
                                       IAPConstants.IAPOCCHeader.kQuantityKey:"\(self.quantity!)"]
        let httpConnectionInterface = IAPHttpConnectionInterface(request: urlString,
                                                                 httpHeaders: headerParameterDictionary!,
                                                                 bodyParameters: bodyParameterDictionary)
        
        return httpConnectionInterface
    }
    
    func updateCart(_ interface: IAPHttpConnectionInterface,
                    completionHandler: @escaping IAPCartTypeAliases.AddProductCompletionHandler,
                    failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        
        interface.setSuccessCompletion({ (inDict:[String: AnyObject]) -> () in
            self.handleOCCResponse(inDict, successHandler: { (isSuccess) -> () in
                completionHandler(isSuccess)
            }, failureHandler: failureHandler)
        })
        
        interface.setFailurHandler ({ (inError:NSError) -> () in
            failureHandler(inError)
        })
        
        interface.performPutRequest()
    }
    
    func getInterfaceForProductCatalogue(_ isDataLoadedFromHybris : Bool) -> IAPHttpConnectionInterface?{
        guard true == isDataLoadedFromHybris else {return nil}
        let productBuilder = IAPProductBuilder()
        let urlString = productBuilder.getProductCatalogueURL(self.currentPage)
        let httpConnectionInterface = IAPHttpConnectionInterface(request: urlString, httpHeaders: nil, bodyParameters: nil)
        
        return httpConnectionInterface
    }
    
    func getProductCatalogue(_ interface : IAPHttpConnectionInterface?,
                             completionHandler: @escaping IAPCartTypeAliases.ProductCatalogueCompletioHandler,
                             failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        
        guard let httpInterface = interface else { return }
        httpInterface.setSuccessCompletion {(inDict: [String: AnyObject]) -> Void in
            if let dict = inDict[IAPConstants.IAPOCCResponse.kPaginationKey] as? [String: AnyObject] {
                completionHandler(IAPProductModelCollection(inDict: inDict).getProducts(), dict)
            } else {
                completionHandler([], nil)
            }
        }
        httpInterface.setFailurHandler{ (inError: NSError)-> Void in
            failureHandler(inError)
        }
        httpInterface.performGetRequest()
    }

    func getInterfaceForFetchAllProducts(_ isDataLoadedFromHybris: Bool) -> IAPHttpConnectionInterface?{
        guard true == isDataLoadedFromHybris else {return nil}
        let productBuilder = IAPProductBuilder()
        let urlString = productBuilder.provideAllProductCatalogueURL(self.pageSize)
        let httpConnectionInterface = IAPHttpConnectionInterface(request: urlString,
                                                                 httpHeaders: nil,
                                                                 bodyParameters: nil)
        return httpConnectionInterface
    }
    
    func fetchAllProducts(_ interface: IAPHttpConnectionInterface?,
                          completionHandler: @escaping IAPCartTypeAliases.ProductCatalogueCompletioHandler,
                          failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        self.getProductCatalogue(interface, completionHandler: completionHandler, failureHandler: failureHandler)
    }

    func getInterfaceForFetchInformationForProduct(_ isDataLoadedFromHybris: Bool) -> IAPHttpConnectionInterface? {
        guard true == isDataLoadedFromHybris else {return nil}
        /*for product detail search directly, hybris supported ctn is CA6700_47*/
        let hybrisSupportedProductCode = self.productCode.replaceCharacter("/", withCharacter: "_")
        let productBuilder = IAPProductBuilder(inProductCode: hybrisSupportedProductCode)
        let urlString = productBuilder.getProductSearchURL()
        let httpConnectionInterface = IAPHttpConnectionInterface(request: urlString,
                                                                 httpHeaders: nil,
                                                                 bodyParameters: nil)
        return httpConnectionInterface
    }

    func fetchInformationForProduct(_ interface: IAPHttpConnectionInterface?,
                                    completionHandler: @escaping IAPCartTypeAliases.ProductSearchCompletionHandler,
                                    failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        guard let httpInterface = interface else {
            let productCode = self.productCode.replaceCharacter("_", withCharacter: "/")
            let product = IAPProductModel(withCTN: productCode)
            completionHandler(product)
            return
        }
        self.productCode = self.productCode.replaceCharacter("/", withCharacter: "_")
        httpInterface.setSuccessCompletion{(inDict: [String: AnyObject]) -> Void in
            let product = IAPProductModel(inDict: inDict)
            product.setProductCTN(self.productCode.replaceCharacter("_", withCharacter: "/"))
            product.updateValue(inDict)
            completionHandler(product)
        }
        httpInterface.setFailurHandler{ (inError: NSError) -> Void in
            failureHandler(inError)
        }
        httpInterface.performGetRequest()
    }
    
    // MARK: -
    // MARK: Voucher related API requests
    // MARK: -
    
   // Apply voucher
    func getInterfaceForApplyVoucher() -> IAPHttpConnectionInterface{
        let voucherBuilder = IAPVoucherBuilder(cartID: cartID, userID: userID, voucherCode: voucherCode)
        let urlString = voucherBuilder.getApplyVoucherCodeURL()
        let headerParameterInfo = getParameterDictForCartDownloads(IAPOAuthInfo.oAuthInfo())
        let bodyParameterInfo = [IAPConstants.IAPOCCHeader.kVoucherCodeKey: voucherCode!]
        let httpConnectionInterface = IAPHttpConnectionInterface(request: urlString,
                                                                 httpHeaders: headerParameterInfo,
                                                                 bodyParameters: bodyParameterInfo)
        return httpConnectionInterface
    }
    
    func applyVoucher (_ interface: IAPHttpConnectionInterface,
                       completionHandler: @escaping IAPCartTypeAliases.AddProductCompletionHandler,
                       failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        interface.setSuccessCompletion { (inDict: [String: AnyObject]) -> () in
            completionHandler(true)
        }
        interface.setFailurHandler{ (inError:NSError) -> () in
            failureHandler(inError)
        }
        interface.performPostRequest()
    }
    
    // Get Voucher List
    func getInterfaceForAppliedVoucherList() -> IAPHttpConnectionInterface {
        let voucherListBuilder = IAPVoucherBuilder(cartID: cartID, userID: userID)
        let urlString = voucherListBuilder.getApplyVoucherCodeURL()
        let headerParameterInfo = getParameterDictForCartDownloads(IAPOAuthInfo.oAuthInfo())
        let httpConnectionInterface = IAPHttpConnectionInterface(request: urlString,
                                                       httpHeaders: headerParameterInfo, bodyParameters: nil)
        return httpConnectionInterface
    }
    
    func getAppliedVoucherList(_ interface: IAPHttpConnectionInterface,
                               completionHandler: @escaping IAPCartTypeAliases.GetVoucherListCompletionHandler,
                               failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        interface.setSuccessCompletion ({ (inDict: [String: AnyObject]) -> () in
            completionHandler( IAPVoucherList(inDict: inDict))
        })
        interface.setFailurHandler { (inError: NSError) -> () in
            failureHandler(inError)
        }
        interface.performGetRequest()
    }
    
    //Release Voucher
    func getInterfaceForRemoveVoucher() -> IAPHttpConnectionInterface{
        let voucherBuilder = IAPVoucherBuilder(cartID: cartID, userID: userID, voucherCode: voucherCode)
        let urlString = voucherBuilder.getReleaseVoucherCodeURL()
        let headerParameterInfo = getParameterDictForCartDownloads(IAPOAuthInfo.oAuthInfo())
        let httpConnectionInterface = IAPHttpConnectionInterface(request: urlString,
                                                                 httpHeaders: headerParameterInfo,
                                                                 bodyParameters: nil)
        return httpConnectionInterface
    }
    
    func removeVoucher (_ interface: IAPHttpConnectionInterface,
                       completionHandler: @escaping IAPCartTypeAliases.AddProductCompletionHandler,
                       failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        interface.setSuccessCompletion { _ -> () in
            completionHandler(true)
        }
        interface.setFailurHandler{ (inError: NSError) -> () in
            failureHandler(inError)
        }
        interface.performDeleteRequest()
    }
}
