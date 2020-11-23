/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPOCCPaymentInterface: IAPOCCPaymentAddressBaseInterface {

    var orderID: String!
    var paymentID: String!
    var cvv: String!

    // MARK:
    // MARK:Payment related methods
    func getInterfaceForPaymentDetails() -> IAPHttpConnectionInterface {
        let cartBuilder = IAPUserBuilder(inUserId: self.userID)
        let urlString   = cartBuilder.getUserPaymentDetailsURL()
        let headerParameterDictionary = self.getParameterDictForCartDownloads(IAPOAuthInfo.oAuthInfo())
        let httpConnectionInterface = IAPHttpConnectionInterface(request: urlString,
                                                                 httpHeaders: headerParameterDictionary!,
                                                                 bodyParameters: nil)
        return httpConnectionInterface
    }
    
    func getPaymentDetailsForUserUsingInterface(_ interface: IAPHttpConnectionInterface,
                                            completionHandler: @escaping IAPCartTypeAliases.GetPaymentCompletionHandler,
                                                failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        
        interface.setSuccessCompletion ({ (inDict:[String: AnyObject]) -> () in
            completionHandler(IAPPaymentDetailsInfo(inDict: inDict))
        })
        
        interface.setFailurHandler ({ (inError:NSError) -> () in
                failureHandler(inError)
        })
        
        interface.performGetRequest()
    }
    
    func getInterfaceForMakePayment() -> IAPHttpConnectionInterface {
        let paymentBuilder = IAPPaymentBuilder(inOrderId: self.orderID, userID: self.userID)
        let urlString   = paymentBuilder.getMakePaymentURL()
        let headerParameterDictionary = self.getParameterDictForCartDownloads(IAPOAuthInfo.oAuthInfo())
        var addressDictionary = self.getAddressDictionary()
        if self.addressID != nil {
            addressDictionary.updateValue(self.addressID ?? "", forKey: IAPConstants.IAPOCCHeader.kAddressID)
        }
        
        let bodyParameterDictionary = addressDictionary
        let httpConnectionInterface = IAPHttpConnectionInterface(request: urlString,
                                                                 httpHeaders: headerParameterDictionary!,
                                                                 bodyParameters: bodyParameterDictionary)
        return httpConnectionInterface
    }
    
    func makePaymentDetailsForUserUsingInterface(_ interface: IAPHttpConnectionInterface,
                                        completionHandler: @escaping IAPCartTypeAliases.MakePaymentCompletionHandler,
                                                 failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        interface.setSuccessCompletion({ (inDict:[String: AnyObject]) -> () in
            completionHandler(IAPMakePaymentInfo(inDict: inDict))
        })
        interface.setFailurHandler({ (inError:NSError) -> () in
            failureHandler(inError)
        })
        interface.performPostRequest()
    }
    
    func getInterfaceForPlacingOrder() -> IAPHttpConnectionInterface {
        let orderBuilder = IAPOrderBuilder(userID: self.userID)
        let urlString   = orderBuilder.getOrderURL()
        let headerParameterDictionary = self.getParameterDictForCartDownloads(IAPOAuthInfo.oAuthInfo())
        var bodyParameterDictionary = [IAPConstants.IAPOCCHeader.kCartIdKey: self.cartID!]
        
        if self.cvv.length > 0 {
            bodyParameterDictionary.updateValue(self.cvv, forKey: IAPConstants.IAPOCCHeader.kPaymentCVVKey)
        }
        
        let httpConnectionInterface = IAPHttpConnectionInterface(request: urlString, httpHeaders: headerParameterDictionary!, bodyParameters: bodyParameterDictionary)
        return httpConnectionInterface
    }
    
    func placeOrderForUserUsingInterface(_ interface: IAPHttpConnectionInterface,
                                         completionHandler: @escaping IAPCartTypeAliases.PlaceOrderCompletionHandler,
                                         failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        interface.setSuccessCompletion ({ (inDict: [String: AnyObject]) -> () in
            completionHandler(IAPOrderInfo(inDict: inDict))
        })
        
        interface.setFailurHandler({ (inError: NSError) -> () in
            failureHandler(inError)
        })
        
        interface.performPostRequest()
    }
    
    func getInterfaceForSettingDeliveryMode(_ deliveryModeValue: String) -> IAPHttpConnectionInterface {
        let cartBuilder = IAPCartBuilder(cartID: self.cartID, userID: self.userID)
        let urlString = cartBuilder.getUpdateDeliveryModeURL()
        let headerParameterDictionary = self.getParameterDictForCartDownloads(IAPOAuthInfo.oAuthInfo())
        let bodyParameterDictionary = [IAPConstants.IAPOCCHeader.kDeliveryModeKey: deliveryModeValue]
        let httpConnectionInterface = IAPHttpConnectionInterface(request: urlString,
                                                                 httpHeaders: headerParameterDictionary!,
                                                                 bodyParameters: bodyParameterDictionary)
        return httpConnectionInterface
    }
    
    func setDeliveryModeForUserUsingInterface(_ interface: IAPHttpConnectionInterface,
                                    completionHandler: @escaping IAPCartTypeAliases.SetDeliveryModeCompletionHandler,
                                              failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        
        interface.setSuccessCompletion({ (inDict:[String: AnyObject]) -> () in
            completionHandler(true)
        })
        interface.setFailurHandler({ (inError:NSError) -> () in
            failureHandler(inError)
        })
        interface.performPutRequest()
    }
    
    func getInterfaceForRetreivingDeliveryModes() -> IAPHttpConnectionInterface {
        let cartBuilder = IAPCartBuilder(cartID: self.cartID, userID: self.userID)
        let urlString = cartBuilder.getDeliveryModeURL()
        let headerParameterDictionary = self.getParameterDictForCartDownloads(IAPOAuthInfo.oAuthInfo())
        
        let httpConnectionInterface = IAPHttpConnectionInterface(request: urlString,
                                                                 httpHeaders: headerParameterDictionary!,
                                                                 bodyParameters: nil)
        return httpConnectionInterface
    }
    
    func getDeliveryModesUsingInterface(_ interface: IAPHttpConnectionInterface,
                                    completionHandler: @escaping IAPCartTypeAliases.GetDeliveryModeCompletionHandler,
                                        failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        interface.setSuccessCompletion({ (inDict:[String: AnyObject]) -> () in
            completionHandler(IAPDeliveryModeDetails(inDict: inDict))
        })
        interface.setFailurHandler({ (inError:NSError) -> () in
            failureHandler(inError)
        })
        interface.performGetRequest()
    }
    
    func getInterfaceForPaymentReauth() -> IAPHttpConnectionInterface {
        let cartBuilder = IAPCartBuilder(cartID: self.cartID, userID: self.userID)
        let urlString = cartBuilder.getReauthPaymentURL()
        let headerParameterDictionary = self.getParameterDictForCartDownloads(IAPOAuthInfo.oAuthInfo())
        let bodyParameterDictionary = [IAPConstants.IAPOCCHeader.kPaymentIdKey: self.paymentID!]
        let httpConnectionInterface = IAPHttpConnectionInterface(request: urlString,
                                                                 httpHeaders: headerParameterDictionary!,
                                                                 bodyParameters: bodyParameterDictionary)
        return httpConnectionInterface
    }
    
    func setReauthPaymentDetailsForUserUsingInterface(_ interface: IAPHttpConnectionInterface,
                                    completionHandler: @escaping IAPCartTypeAliases.SetPaymentDetailsCompletionHandler,
                                                      failureHandler: @escaping IAPCartTypeAliases.CartFailureHandler) {
        interface.setSuccessCompletion({ (inDict:[String: AnyObject]) -> () in
            completionHandler(true)
        })
        interface.setFailurHandler({ (inError:NSError) -> () in
            failureHandler(inError)
        })
        interface.performPutRequest()
    }
}
