//
//  PPRUserProduct.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import PhilipsPRXClient
import PlatformInterfaces
import AppInfra

public typealias PPRSuccess = (_ data: PRXResponseData?) -> Void
public typealias PPRFailure = (_ error: NSError?) -> Void
typealias Valid = () -> Void


let MIN_RETRY_COUNT = 0
let MAX_RETRY_COUNT = 1
var registerRetryCount = MIN_RETRY_COUNT
var getListRetryCount = MIN_RETRY_COUNT

/// This class provides interfaces for registering a product and getting list of all registered products for a valid signed in user.
/// - Since: 1.0.0
@objc open class PPRUserWithProducts: NSObject {
    
    fileprivate var micrositeID: String?  {
        let appInfra = PPRInterfaceInput.sharedInstance.appDependency.appInfra
        guard appInfra?.appIdentity.getMicrositeId() != nil else {
            return nil
        }
        return appInfra?.appIdentity.getMicrositeId()
    }
    
    fileprivate var janrainAccessToken: String? {
        do {
            let accessToken = try self.user.userDetails([UserDetailConstants.ACCESS_TOKEN])[UserDetailConstants.ACCESS_TOKEN]
            return accessToken as? String
        }
        catch{
            return nil
        }
    }
    
    fileprivate var janrainUUID: String? {
        do {
            let uuid = try self.user.userDetails([UserDetailConstants.UUID])[UserDetailConstants.UUID]
            return uuid as? String
        }
        catch{
            return nil
        }
    }
    
    fileprivate var receiveMarketingEmail: Bool? {
        let userDetails =  try? self.user?.userDetails([UserDetailConstants.RECEIVE_MARKETING_EMAIL])
        let user = userDetails as? Dictionary<String, Bool>
        return user?[UserDetailConstants.RECEIVE_MARKETING_EMAIL]
    }
    
    lazy var productStore: PPRRegisteredProductListStore = {
        return PPRRegisteredProductListStore()
    }()
    
    fileprivate lazy var errorHelper: PPRErrorHelper = {
        return PPRErrorHelper()
    }()
    
    var user: UserDataInterface!
    lazy var requestManager: PRXRequestManagerWrapper = {
        return PRXRequestManagerWrapper()
    }()
    
    lazy var refreshAccessToken: AccessTokenRefresh = {
        return AccessTokenRefresh()
    }()
    
    weak var delegate: PPRRegisterProductDelegate?
    
    /// Register any product. A valid user must be logged in before calling this API.
    ///
    /// - Parameter product: Object of PPRProduct. This class contains details of the product to be registered.
    /// - Since: 1.0.0
    @objc open func registerProduct(_ product: PPRProduct)
    {
        let regProduct = self.registeredProductFrom(product: product)
        self.register(product: regProduct, success: { (data) in
            registerRetryCount = MIN_RETRY_COUNT
            let updatedProduct = regProduct.updateRegisteredProductWith(response: data)
            self.delegate?.productRegistrationDidSucced(userProduct: self, product: updatedProduct)
        }) { (error) in
            if self.isAccessTokenInvalid(error: error! as NSError) {
                if registerRetryCount < MAX_RETRY_COUNT {
                    registerRetryCount = MAX_RETRY_COUNT
                    self.refreshAccessToken.refresh(user: self.user, success: { (isRefreshed) in
                        if isRefreshed == true {
                            self.registerProduct(product)
                        } else {
                            regProduct.error = error
                            self.delegate?.productRegistrationDidFail(userProduct: self, product: regProduct)
                        }
                    })
                } else {
                    regProduct.error = error
                    self.delegate?.productRegistrationDidFail(userProduct: self, product: regProduct)
                }
            } else {
                regProduct.error = error
                self.delegate?.productRegistrationDidFail(userProduct: self, product: regProduct)
            }
        }
    }
    
    /// Get the list of all the registered products for a valid user.
    ///
    /// - Parameter success: It's a completion block.
    /// - Since: 1.0.0
    @objc open func getRegisteredProducts(_ success: @escaping PPRSuccess, failure: @escaping PPRFailure)
    {
        if (self.user.loggedInState().rawValue <= UserLoggedInState.pendingTnC.rawValue) {
            self.errorHelper.handleError(statusCode: PPRError.USER_NOT_LOGGED_IN.rawValue, failure: failure)
            return
        }
        let prxProductListRequest: PRXProductListDataRequest = PRXProductListDataRequest(user: self.user)
        self.requestManager.requestType = REQUEST_TYPE.REGISTERED_PRODUCT_LIST
        self.requestManager.execute(prxProductListRequest, success: { (data) in
            getListRetryCount = MIN_RETRY_COUNT
            let prxResponse = data as! PRXProductListResponse
            let productListResponse = PPRProductListResponse.productListResponseFrom(prxResponse: prxResponse, userUUID: self.janrainUUID)
            success(productListResponse)
        }) { (error) in
            //TODO: handle failure case. right now it is not handled in api signature
            if self.isAccessTokenInvalid(error: error!) {
                if getListRetryCount < MAX_RETRY_COUNT {
                    getListRetryCount = MAX_RETRY_COUNT
                    self.refreshAccessToken.refresh(user: self.user, success: { (isRefreshed) in
                        if isRefreshed == true {
                            self.getRegisteredProducts(success, failure: failure)
                        } else {
                           self.errorHelper.handleError(statusCode: PPRError.ACCESS_TOKEN_INVALID.rawValue, failure: failure)
                        }
                    })
                } else {
                    failure(error)
                }
            } else {
                failure(error)
            }
        }
    }
    
    func executeRegisterProductRequest(request: PRXRegisterProductRequest,
                                       success: @escaping PPRSuccess,
                                       failure: @escaping PPRFailure)
    {
        self.requestManager.requestType = REQUEST_TYPE.REGISTER_PRODUCT
        self.requestManager.execute(request, success: success, failure: failure)
    }
    
    func validateProductAndUserInfo(product: PPRRegisteredProduct,
                                    valid: @escaping Valid,
                                    error: @escaping PPRFailure)
    {
        if self.user.loggedInState().rawValue <= UserLoggedInState.pendingTnC.rawValue {
            self.errorHelper.handleError(statusCode: PPRError.USER_NOT_LOGGED_IN.rawValue, failure: error)
        } else if (product.isCTNNotNil == false) {
            self.errorHelper.handleError(statusCode: PPRError.CTN_NOT_ENTERED.rawValue, failure: error)
        } else if (product.isValidDate == false) {
            self.errorHelper.handleError(statusCode: PPRError.INVALID_PURCHASE_DATE.rawValue, failure:error)
        } else {
            self.productAlredyRegistred(product: product, notRegisterd: valid, error: error)
        }
    }
    
    func productAlredyRegistred(product: PPRRegisteredProduct,
                                notRegisterd: @escaping Valid,
                                error: @escaping PPRFailure)
    {
        self.getRegisteredProducts({ (data) in
            let response = data as! PPRProductListResponse
            if let productList = response.data {
                let productStore = self.productStore
                let result = productStore.isProductAlreadyRegistered(product: product, list: productList)
                if  result.isReigistered && productList[result.index].state == .REGISTERED {
                    self.errorHelper.handleError(statusCode: PPRError.PRODUCT_ALREADY_REGISTERD.rawValue, failure: error)
                } else {
                    notRegisterd()
                }
            } else {
                notRegisterd()
            }
        }, failure: error)
    }
    
    func validateRequiredFieldsWithMetadata(data: PRXProductMetaDataInfoData,
                                            product: PPRRegisteredProduct,
                                            valid: Valid,
                                            error: PPRFailure)
    {
        if ((self.validateSerialNumber(data: data, product: product) == false) && (self.validatePurchaseDate(metadata: data, product: product)) == false) {
            self.errorHelper.handleError(statusCode: PPRError.INVALID_SERIAL_NUMBER_AND_PURCHASE_DATE.rawValue, failure: error)
        } else if ((self.validateSerialNumber(data: data, product: product) != false) && (self.validatePurchaseDate(metadata: data, product: product)) == false) {
            self.errorHelper.handleError(statusCode: PPRError.REQUIRED_PURCHASE_DATE.rawValue, failure: error)
        } else if ((self.validateSerialNumber(data: data, product: product) == false) && (self.validatePurchaseDate(metadata: data, product: product)) != false) {
            self.errorHelper.handleError(statusCode: PPRError.INVALID_SERIAL_NUMBER.rawValue, failure: error)
        } else {
            valid()
        }
    }
    
    func validateSerialNumber(data: PRXProductMetaDataInfoData, product: PPRRegisteredProduct)-> Bool {
        guard data.isRequiresSerialNumber == true  else {
            return true
        }
        guard let serialNumber = product.serialNumber ,  serialNumber.trimmWhiteSpaces.length > 0 else {
            return false
        }
        guard let serailNumberFormat = data.serialNumberFormat else {
            return true
        }
        return serialNumber.isMatchWith(pattern: serailNumberFormat)
    }
    
    func validatePurchaseDate(metadata: PRXProductMetaDataInfoData, product: PPRRegisteredProduct)-> Bool {
        guard metadata.isRequiresDateOfPurchase == true else {
            return true
        }
        return (product.purchaseDate != nil)
    }
    
    
    fileprivate func isAccessTokenInvalid(error: NSError) -> Bool {
        guard (error.code == PPRError.ACCESS_TOKEN_INVALID.rawValue || error.code == PPRError.PARAMETER_INVALID.rawValue) else {
            return false
        }
        return true
    }
    
    fileprivate func register(product: PPRRegisteredProduct, success: @escaping PPRSuccess, failure: @escaping PPRFailure) {
        self.validateProductAndUserInfo(product: product, valid: {
            let prData : PRXRegisterProductRequest = PRXRegisterProductRequest(product: product, accessToken: self.janrainAccessToken, micrositeID: self.micrositeID, receiveMarketingEmail: self.receiveMarketingEmail)
            product.getProductMetaData(success: {
                (data) -> Void in
                let response: PRXProductMetaDataResponse = data as! PRXProductMetaDataResponse
                let data: PRXProductMetaDataInfoData = response.data!
                self.validateRequiredFieldsWithMetadata(data: data, product: product, valid: {
                    self.executeRegisterProductRequest(request: prData, success: success, failure: failure)
                }, error: failure)
            }, failure: failure)
        }, error: failure)
    }
    
    func registeredProductFrom(product: PPRProduct) -> PPRRegisteredProduct {
        let regProduct = PPRRegisteredProduct(ctn: product.ctn,
                                              sector: product.sector,
                                              catalog: product.catalog)
        regProduct.purchaseDate = product.purchaseDate
        regProduct.serialNumber = product.serialNumber
        regProduct.sendEmail = product.sendEmail
        regProduct.requestManager = product.requestManager
        regProduct.userUuid = self.janrainUUID
        regProduct.registrationDate = product.registrationDate
        
        return regProduct
    }
}
