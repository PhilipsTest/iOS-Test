//
//  PPRUserProductMock.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import PhilipsRegistration
@testable import PhilipsProductRegistrationDev

class PPRUserProductMock: PPRUserWithProducts {
    var registerRequestMock: PRXRequestManagerMock!
    var getProductListRequsetMock: PRXRequestManagerMock!
    fileprivate lazy var micrositeID: String = {
        return "77000"
    }()
    
    override func getRegisteredProducts(_ success: @escaping PPRSuccess, failure: @escaping PPRFailure) {
        let prxProductListRequest: PRXProductListDataRequest = PRXProductListDataRequest(user: self.user)
        self.getProductListRequsetMock.execute(prxProductListRequest, completion: { (response) in
            let prxResponse = response as! PPRProductListResponse
            success(prxResponse)
        }) { (error) in
            failure(error as NSError?)
        }
    }
    
    override func registerProduct(_ product: PPRProduct) {
        do{
            var userDetails =  try self.user?.userDetails([UserDetailConstants.RECEIVE_MARKETING_EMAIL, UserDetailConstants.ACCESS_TOKEN]) as? Dictionary<String, String>
            let token = userDetails?[UserDetailConstants.ACCESS_TOKEN]
            let prData : PRXRegisterProductRequest = PRXRegisterProductRequest(product: product, accessToken: token, micrositeID: self.micrositeID, receiveMarketingEmail:Bool((userDetails?[UserDetailConstants.RECEIVE_MARKETING_EMAIL])!))
            
            let regProduct = self.registeredProductFrom(product: product)
            self.validateProductAndUserInfo(product: regProduct, valid: {
                product.getProductMetaData(success: { (data) in
                    let response: PRXProductMetaDataResponse = data as! PRXProductMetaDataResponse
                    let data: PRXProductMetaDataInfoData = response.data!
                    self.validateRequiredFieldsWithMetadata(data: data, product: regProduct, valid: {
                        self.registerRequestMock.execute(prData, completion: { (data) in
                            self.delegate?.productRegistrationDidSucced(userProduct: self, product: regProduct)
                        }, failure: { (error) in
                            let aProduct = regProduct
                            aProduct.error = error as NSError?
                            self.delegate?.productRegistrationDidFail(userProduct: self, product: aProduct)
                        })
                    }, error: { (error) in
                        let aProduct = regProduct
                        aProduct.error = error
                        self.delegate?.productRegistrationDidFail(userProduct: self, product: aProduct)
                    })
                }, failure: { (error) in
                    let aProduct = regProduct
                    aProduct.error = error
                    self.delegate?.productRegistrationDidFail(userProduct: self, product: aProduct)
                })
            }, error: { (error) in
                let aProduct = regProduct
                aProduct.error = error
                self.delegate?.productRegistrationDidFail(userProduct: self, product: aProduct)
            })
        }catch{
            let regProduct = self.registeredProductFrom(product: product)
            let aProduct = regProduct
            aProduct.error = error as NSError
            self.delegate?.productRegistrationDidFail(userProduct: self, product: regProduct)
        }
    }
    
}

