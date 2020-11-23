/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

protocol IAPPurchaseHistoryInterfaceProtocol {
    var purchaseHistoryCurrentPage: Int! { set get }
    var purchaseHistory: IAPPurchaseHistoryModel! { set get }
    
    func getPurchaseHistoryOverview(_ interface: IAPHttpConnectionInterface,
                                    completionHandler: @escaping IAPCartTypeAliases.GetPurchaseHistoryCompletionHandler,
                                    failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler)
    func getPurchaseHistoryOrderDetails(_ interface: IAPHttpConnectionInterface,
                        completionHandler: @escaping IAPCartTypeAliases.GetPurchaseHistoryOrderDetailsCompletionHandler,
                        failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler)
}

extension IAPPurchaseHistoryInterfaceProtocol where Self: IAPOCCAddressInterface {
    func getInterfaceForPurchaseHistoryOverview() -> IAPHttpConnectionInterface {
        let orderURL  = IAPUserBuilder( inUserId: self.userID ).getPurchaseHistoryOverViewURLWithCurrentPage(
            self.purchaseHistoryCurrentPage, withSortField: IAPConstants.IAPPurchaseHistoryModelKeys.kSortKey)
        let headerParameterDictionary = self.getParameterDictForCartDownloads(IAPOAuthInfo.oAuthInfo())
        let httpConnectionInterface = IAPHttpConnectionInterface(request: orderURL,
                                                                 httpHeaders: headerParameterDictionary,
                                                                 bodyParameters: nil)
        return httpConnectionInterface
    }
    
    func getPurchaseHistoryOverview(_ interface: IAPHttpConnectionInterface,
                                    completionHandler: @escaping IAPCartTypeAliases.GetPurchaseHistoryCompletionHandler,
                                    failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        
        interface.setSuccessCompletion{(inDict: [String: AnyObject]) -> () in
            let dict = inDict[IAPConstants.IAPOCCResponse.kPaginationKey] as? [String: AnyObject] ?? [:]
            completionHandler(IAPPurchaseHistoryCollection(inDictionary: inDict), dict)
        }
        interface.setFailurHandler{ (inError: NSError) -> () in
            failureHandler(inError)
        }
        interface.performGetRequest()
    }
    
    func getPurchaseHistoryOrderDetails(_ interface: IAPHttpConnectionInterface,
                        completionHandler: @escaping IAPCartTypeAliases.GetPurchaseHistoryOrderDetailsCompletionHandler,
                                        failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        
        interface.setSuccessCompletion{(inDict: [String: AnyObject]) -> () in
            self.purchaseHistory.initialiseOrderDetails(inDict)
            completionHandler(self.purchaseHistory)
        }
        interface.setFailurHandler{ (inError: NSError) -> () in
            failureHandler(inError)
        }
        interface.performGetRequest()
    }
    
    func getInterfaceForPurchaseHistoryOrderDetails() -> IAPHttpConnectionInterface {
        let orderDetailsURL = IAPUserBuilder(inUserId: self.userID).getPurchaseHistoryOrderDetailURL(self.purchaseHistory.getOrderID())
        let headerParameterDictionary = self.getParameterDictForCartDownloads(IAPOAuthInfo.oAuthInfo())
        let httpConnectionInterface = IAPHttpConnectionInterface(request: orderDetailsURL,
                                                                 httpHeaders: headerParameterDictionary,
                                                                 bodyParameters: nil)
        return httpConnectionInterface
    }
}

class IAPOCCAddressInterface: IAPOCCPaymentAddressBaseInterface, IAPPurchaseHistoryInterfaceProtocol {
    
    var purchaseHistoryCurrentPage: Int!
    var purchaseHistory: IAPPurchaseHistoryModel!
    
    // MARK: -
    // MARK: Address related methods
    // MARK: -
    func getInterfaceForGetAddress() -> IAPHttpConnectionInterface {
        let addressBuilder  = IAPAddressBuilder(inUserID: self.userID)
        let urlString       = addressBuilder.getUserAddressesURL()
        let headerParameterDictionary = self.getParameterDictForCartDownloads(IAPOAuthInfo.oAuthInfo())
        let httpConnectionInterface = IAPHttpConnectionInterface(request: urlString, httpHeaders: headerParameterDictionary, bodyParameters: nil)
        return httpConnectionInterface
    }

    func getAddressesForUser(_ interface: IAPHttpConnectionInterface,
                             completionHandler: @escaping IAPCartTypeAliases.GetAddressCompletionHandler,
                             failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        interface.setSuccessCompletion ({ (inDict: [String: AnyObject]) -> () in
            completionHandler(IAPUserAddressInfo(inDict: inDict))
        })
        interface.setFailurHandler { (inError: NSError) -> () in
            failureHandler(inError)
        }
        interface.performGetRequest()
    }
    
    func getInterfaceForAddDeliveryAddress() -> IAPHttpConnectionInterface {
        //        let addressBuilder  = IAPAddressBuilder(inUserID: self.userID)
        //        let urlString       = addressBuilder.getUserAddressesURL()
        let addressBuilder = IAPAddressBuilder(inUserID: self.userID)
        let urlString = addressBuilder.getAddDeliveryAddressURL()
        let headerParameterDictionary = self.getParameterDictForCartDownloads(IAPOAuthInfo.oAuthInfo())
        let bodyParameterDictionary = self.getAddressDictionary()
        let httpConnectionInterface = IAPHttpConnectionInterface(request: urlString,
                                                                 httpHeaders: headerParameterDictionary,
                                                                 bodyParameters: bodyParameterDictionary)
        return httpConnectionInterface
    }
    
    func addDeliveryAddressForUser(_ interface: IAPHttpConnectionInterface,
                                   completionHandler: @escaping IAPCartTypeAliases.SetAddressCompletionHandler,
                                   failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        interface.setSuccessCompletion({ (inDict: [String: AnyObject]) -> () in
            completionHandler(IAPUserAddress(inDict: inDict))
        })
        interface.setFailurHandler ({ (inError: NSError) -> () in
            failureHandler(inError)
        })
        interface.performPostRequest()
    }

    func getInterfaceForDefaultAddress() -> IAPHttpConnectionInterface {
        let userBuilder  = IAPUserBuilder(inUserId: self.userID)
        let urlString       = userBuilder.getUserDefaultAddressURL()
        let headerParameterDictionary = self.getParameterDictForCartDownloads(IAPOAuthInfo.oAuthInfo())
        let httpConnectionInterface = IAPHttpConnectionInterface(request: urlString,
                                                                 httpHeaders: headerParameterDictionary,
                                                                 bodyParameters: nil)
        return httpConnectionInterface
    }
    
    func getDefaultAddressForUserUsingInterface(_ interface: IAPHttpConnectionInterface,
                                                completionHandler: @escaping IAPCartTypeAliases.DefaultAddressCompletionHandler,
                                                failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        interface.setSuccessCompletion ({ (inDict: [String: AnyObject]) -> () in
            if let defaultAddressDict = inDict[IAPConstants.IAPOCCResponse.kDefaultAddressKey] as? [String: AnyObject] {
                let address = IAPUserAddress(inDict: defaultAddressDict)
                address.defaultAddress = true
                completionHandler(address)
            } else {
                completionHandler(nil)
            }
        })
        interface.setFailurHandler({ (inError: NSError) -> Void in
            failureHandler(inError)
        })
        interface.performGetRequest()
    }
    
    func getInterfaceForUpdateAddress() -> IAPHttpConnectionInterface {
        let addressBuilder  = IAPAddressBuilder(inUserID: self.userID, inAddressID: self.addressID ?? "")
        let urlString       = addressBuilder.getUpdateAddressURL()
        let headerParameterDictionary = self.getParameterDictForCartDownloads(IAPOAuthInfo.oAuthInfo())
        var bodyParameterDictionary = self.getAddressDictionary()
        bodyParameterDictionary[IAPConstants.IAPOCCHeader.kDefaultAddressKey] = "false"
        if self.defaultAddress == true {
            bodyParameterDictionary[IAPConstants.IAPOCCHeader.kDefaultAddressKey] = "true"
        }
        let httpInterface = IAPHttpConnectionInterface(request: urlString,
                                                       httpHeaders: headerParameterDictionary!,
                                                       bodyParameters: bodyParameterDictionary)
        return httpInterface
    }

    func updateDeliveryAddressForUser(_ interface: IAPHttpConnectionInterface,
                                      completionHandler: @escaping IAPCartTypeAliases.UpdateAddressCompletionHandler,
                                      failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        interface.setSuccessCompletion{ (inDict: [String: AnyObject]) -> () in
            completionHandler(true)
        }
        interface.setFailurHandler { (inError:NSError) -> () in
            failureHandler(inError)
        }
        interface.performPutRequest()
    }
    
    func getInterfaceForSetDeliveryAddressID() -> IAPHttpConnectionInterface {
        let addressBuilder  = IAPAddressBuilder(inUserID: self.userID)
        let urlString       = addressBuilder.getDeliveryAddressURL()
        let headerParameterDictionary = self.getParameterDictForCartDownloads(IAPOAuthInfo.oAuthInfo())
        let bodyParameterDictionary = [IAPConstants.IAPOCCHeader.kAddressID: self.addressID!]
        let httpConnectionInterface = IAPHttpConnectionInterface(request: urlString,
                                                                 httpHeaders: headerParameterDictionary!,
                                                                 bodyParameters: bodyParameterDictionary)
        
        return httpConnectionInterface
    }

    func setDeliveryAddressIDForUser(_ interface: IAPHttpConnectionInterface,
                                     completionHandler: @escaping IAPCartTypeAliases.UpdateAddressCompletionHandler,
                                     failureHandler:@ escaping IAPCartTypeAliases.CartFailureHandler) {
        interface.setSuccessCompletion { (inDict: [String: AnyObject]) -> () in
            completionHandler(true)
        }
        interface.setFailurHandler{ (inError: NSError) -> () in
            failureHandler(inError)
        }
        interface.performPutRequest()
    }
    
    func getInterfaceForDeleteAddress() -> IAPHttpConnectionInterface {
        let addressBuilder  = IAPAddressBuilder(inUserID: self.userID, inAddressID: self.addressID ?? "")
        let urlString       = addressBuilder.getUpdateAddressURL()
        let headerParameterDictionary = self.getParameterDictForCartDownloads(IAPOAuthInfo.oAuthInfo())
        let httpConnectionInterface = IAPHttpConnectionInterface(request: urlString,
                                                                 httpHeaders: headerParameterDictionary!,
                                                                 bodyParameters: nil)
        
        return httpConnectionInterface
    }
    
    func deleteAdress(_ interface: IAPHttpConnectionInterface,
                      completionHandler: @escaping IAPCartTypeAliases.UpdateAddressCompletionHandler,
                      failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        interface.setSuccessCompletion{ (indict: [String: AnyObject]) -> () in
            completionHandler(true)
        }
        interface.setFailurHandler{ (inError: NSError) -> () in
            failureHandler(inError)
        }
        interface.performDeleteRequest()
    }
    
    func getInterfaceForRegions(_ countryCode: String) -> IAPHttpConnectionInterface {
        let addressBuilder  = IAPAddressBuilder(inUserID: self.userID)
        let regionURL = addressBuilder.getRegionsURL(countryCode)
        let headerParameterDictionary = self.getParameterDictForCartDownloads(IAPOAuthInfo.oAuthInfo())
        let httpConnectionInterface = IAPHttpConnectionInterface(request: regionURL,
                                                                 httpHeaders: headerParameterDictionary!,
                                                                 bodyParameters: nil)
        return httpConnectionInterface
    }
    
    func getRegionsForCountryCode(_ interface: IAPHttpConnectionInterface,
                                  completionHandler: @escaping IAPCartTypeAliases.GetRegionCompletionHandler,
                                  failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        interface.setSuccessCompletion{(inDict: [String: AnyObject]) -> () in
            completionHandler(inDict)
        }
        interface.setFailurHandler { (inError: NSError) -> () in
            failureHandler(inError)
        }
        interface.performGetRequest()
    }
}
