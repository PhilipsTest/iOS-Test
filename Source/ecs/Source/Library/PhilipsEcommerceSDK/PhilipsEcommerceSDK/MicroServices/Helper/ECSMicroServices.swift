/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

enum ECSMicroServiceEndPoint: String {
    case hybrisOAuth            = "/authorizationserver/oauth/token"
    case getCart                = "/pilcommercewebservices/v2/%@/users/%@/carts/%@"
    case productList            = "/pilcommercewebservices/v2/%@/products/search"
    case fetchProduct           = "/pilcommercewebservices/v2/%@/products/%@"
    case configure              = "/pilcommercewebservices/v2/inAppConfig/%@/%@"
    case addToCart              = "/pilcommercewebservices/v2/%@/users/%@/carts/%@/entries"
    case createCart             = "/pilcommercewebservices/v2/%@/users/%@/carts"
    case updateCart             = "/pilcommercewebservices/v2/%@/users/%@/carts/%@/entries/%@"
    case voucher                = "/pilcommercewebservices/v2/%@/users/%@/carts/%@/vouchers"
    case deleteVoucher          = "/pilcommercewebservices/v2/%@/users/%@/carts/%@/vouchers/%@"
    case addresses              = "/pilcommercewebservices/v2/%@/users/%@/addresses"
    case updateAddress          = "/pilcommercewebservices/v2/%@/users/%@/addresses/%@"
    case setDeliveryAddress     = "/pilcommercewebservices/v2/%@/users/%@/carts/%@/addresses/delivery"
    case fetchDeliveryModes     = "/pilcommercewebservices/v2/%@/users/%@/carts/%@/deliverymodes"
    case setDeliveryMode        = "/pilcommercewebservices/v2/%@/users/%@/carts/%@/deliverymode"
    case fetchRegions           = "/pilcommercewebservices/v2/metainfo/regions/%@"
    case fetchPaymentList       = "/pilcommercewebservices/v2/%@/users/%@/paymentdetails"
    case setPaymentDetail       = "/pilcommercewebservices/v2/%@/users/%@/carts/%@/paymentdetails"
    case fetchUserDetails       = "/pilcommercewebservices/v2/%@/users/%@"
    case order                  = "/pilcommercewebservices/v2/%@/users/%@/orders"
    case orderDetails           = "/pilcommercewebservices/v2/%@/users/%@/orders/%@"
    case makePayment            = "/pilcommercewebservices/v2/%@/users/%@/orders/%@/pay"
}

typealias ECSValidationCompletion = (_ error: Error?) -> Void

protocol ECSMicroServices: class {
    func commonValidation(completionHandler: ECSValidationCompletion)
    // MARK: - PIL Microservice methods
    func commonPILValidation(completionHandler: ECSValidationCompletion)
}

extension ECSMicroServices {

    func commonValidation(completionHandler: ECSValidationCompletion) {
        assert(ECSConfiguration.shared.locale != nil, "Please call `configureECSWithConfiguration:` method")
        guard ECSConfiguration.shared.appInfra != nil else {
            completionHandler(ECSHybrisError(with: .ECSAppInfraNotFound).hybrisError)
            return
        }
        guard ECSConfiguration.shared.baseURL != nil else {
            completionHandler(ECSHybrisError(with: .ECSBaseURLNotFound).hybrisError)
            return
        }
        guard ECSConfiguration.shared.locale != nil else {
            completionHandler(ECSHybrisError(with: .ECSLocaleNotFound).hybrisError)
            return
        }
        completionHandler(nil)
    }

    // MARK: - PIL Microservice methods

    func commonPILValidation(completionHandler: ECSValidationCompletion) {
        commonValidation { (error) in
            guard error == nil else {
                completionHandler(error)
                return
            }
            guard ECSConfiguration.shared.language != nil else {
                completionHandler(ECSPILHybrisErrors(errorType: .ECSPIL_MISSING_PARAMETER_language).hybrisPILError)
                return
            }
            guard ECSConfiguration.shared.country != nil else {
                completionHandler(ECSPILHybrisErrors(errorType: .ECSPIL_MISSING_PARAMETER_country).hybrisPILError)
                return
            }
            guard ECSConfiguration.shared.apiKey != nil else {
                completionHandler(ECSPILHybrisErrors(errorType: .ECSPIL_MISSING_API_KEY).hybrisPILError)
                return
            }
            completionHandler(nil)
        }
    }
}
