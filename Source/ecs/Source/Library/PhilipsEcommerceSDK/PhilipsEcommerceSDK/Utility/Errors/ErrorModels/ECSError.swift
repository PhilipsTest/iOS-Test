/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

enum ECSHybrisErrorType: Int, CaseIterable {

    // swiftlint:disable identifier_name

    // MARK: - Hybris error

    case ECSinvalid_grant                 = 5000  // If the token is invalid
    case ECSinvalid_client                = 5001  // If the client ID in ouath is wrong
    case ECSunsupported_grant_type        = 5002  // If the grant type in ouath is wrong
    case ECSNoSuchElementError            = 5003  // Hybris error for product list pagination
    case ECSCartError                     = 5004  // If the cart is not created
    case ECSInsufficientStockError        = 5005  // If the product added has insufficient stock
    case ECSUnknownIdentifierError        = 5006  // If the requested resource(product/address) is not available
    case ECSCommerceCartModificationError = 5007  // If negative quantity is being added to cart
    case ECSCartEntryError                = 5008  // If Cart doesnot contain the product for which the quantity is changed
    case ECSInvalidTokenError             = 5009  // If Hybris token is invalid/expired
    case ECSUnsupportedVoucherError       = 5010  // If the applied voucher operation is invalid
    case ECSVoucherOperationError         = 5011  // This error appeared while applying voucher
    case ECSValidationError               = 5012  // Randomly tax calculation error is coming
    case ECSUnsupportedDeliveryModeError  = 5013  // If the Delivery Mode is not valid
    case ECSregionisocode                 = 5014
    case ECScountryisocode                = 5015
    case ECSpostalCode                    = 5016
    case ECSfirstName                     = 5017
    case ECSlastName                      = 5018
    case ECSphone1                        = 5019
    case ECSphone2                        = 5020
    case ECSaddressId                     = 5021
    case ECSsessionCart                   = 5022
    case ECSpostUrl                       = 5023
    case ECSIllegalArgumentError          = 5024  // If some query paramter is wrong like negative page size in Order History
    case ECSInvalidPaymentInfoError       = 5025
    case ECSPaymentAuthorizationError     = 5026
    case ECStitleCode                     = 5027

    // MARK: - User error
    case ECSBaseURLNotFound               = 5050
    case ECSAppInfraNotFound              = 5051
    case ECSLocaleNotFound                = 5052
    case ECSPropositionIdNotFound         = 5053
    case ECSSiteIdNotFound                = 5054
    case ECSHybrisNotAvailable            = 5055
    case ECSCtnNotProvided                = 5056
    case ECSOAuthNotCalled                = 5057
    case ECSOAuthDetailError              = 5058
    case ECScountryCodeNotGiven           = 5059
    case ECSorderIdNil                    = 5060
    case ECSsomethingWentWrong            = 5999

    // MARK: - PIL Microservices
    case ECSPIL_MISSING_PARAMETER_siteId            = 6000
    case ECSPIL_INVALID_PARAMETER_VALUE_siteId      = 6001
    case ECSPIL_MISSING_PARAMETER_country           = 6002
    case ECSPIL_MISSING_PARAMETER_language          = 6003
    case ECSPIL_INVALID_PARAMETER_VALUE_locale      = 6004
    case ECSPIL_NOT_FOUND_productId                 = 6005
    case ECSPIL_MISSING_API_VERSION                 = 6006
    case ECSPIL_INVALID_API_VERSION                 = 6007
    case ECSPIL_MISSING_API_KEY                     = 6008
    case ECSPIL_INVALID_API_KEY                     = 6009
    case ECSPIL_INVALID_PRODUCT_SEARCH_LIMIT        = 6010
    case ECSPIL_NOT_ACCEPTABLE                      = 6011
    case ECSPIL_INTEGRATION_TIMEOUT                 = 6012
    case ECSPIL_BAD_REQUEST                         = 6013
    case ECSPIL_UNSUPPORTED_MEDIA_TYPE              = 6014
    case ECSPIL_NOT_ACCEPTABLE_contentType          = 6015
    case ECSPIL_INVALID_QUANTITY                    = 6016
    case ECSPIL_INVALID_PARAMETER_VALUE_quantity    = 6017
    case ECSPIL_NEGATIVE_QUANTITY                   = 6018
    case ECSPIL_MISSING_PARAMETER_productId         = 6019
    case ECSPIL_INVALID_PARAMETER_VALUE_productId   = 6020
    case ECSPIL_STOCK_EXCEPTION                     = 6021
    case ECSPIL_INVALID_PARAMETER_VALUE_itemId      = 6022
    case ECSPIL_NOT_FOUND_cartId                    = 6023
    case ECSPIL_BAD_REQUEST_cartId                  = 6024
    case ECSPIL_INVALID_AUTHORIZATION_accessToken   = 6025
    case ECSPIL_INVALID_PARAMETER_VALUE_Email       = 6026
    case ECSPIL_INVALID_PARAMETER_VALUE_offset      = 6027
    case ECSPIL_INVALID_PARAMETER_VALUE_limit       = 6028

    // swiftlint:enable identifier_name

    static func errorType(_ errorType: String?) -> ECSHybrisErrorType? {
        guard let error = errorType else {
            return .ECSsomethingWentWrong
        }
        let ecsError = self.allCases.first { "\($0)" == error }
        return ecsError ?? .ECSsomethingWentWrong
    }

    var error: NSError {
        return NSError(domain: String(describing: self),
                       code: self.rawValue,
                       userInfo: [NSLocalizedDescriptionKey: ECSUtility().ECSLocalizedString(String(describing: self))])
    }
}
