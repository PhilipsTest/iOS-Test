/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

enum ECSConstant: String {
    case authorization      = "Authorization"
    case lang               = "lang"
    case currentPage        = "currentPage"
    case pageSize           = "pageSize"
    case fields             = "fields"
    case full               = "FULL"
    case product            = "product"
    case paymentDetailsId   = "paymentDetailsId"
    case deliveryModeId     = "deliveryModeId"
    case securityCode       = "securityCode"
    case cartId             = "cartId"
    case janrain            = "janrain"
    case pimOIDC            = "oidc"
    case grantType          = "grant_type"
    case refreshTokenType   = "refresh_token"
    case clientID           = "client_id"
    case onsiteClient       = "onesite_client"
    case clientSecret       = "client_secret"
    case tokenType          = "token_type"
    case accessToken        = "access_token"
    case query              = "query"
    case sector             = "sector"
    case b2c                = "B2C"
    case catalog            = "catalog"
    case consumer           = "CONSUMER"
    case ctnList            = "ctns"
    case ctn                = "ctn"
    case code               = "code"
    case quantity           = "qty"
    case addressId          = "addressId"
    case defaultAddress     = "defaultAddress"
    case voucherId          = "voucherId"
    case baseURL            = "iap.baseurl"
    case ecsTLA             = "ecs"
    // MARK: - PIL Microservices
    case mecGroupName       = "MEC"
    case propositionIDKey   = "propositionId"
    case apiKeyConfigKey    = "PIL_ECommerce_API_KEY"
    case apiKey             = "Api-Key"
    case apiVersion         = "Api-Version"
    case apiVersionValue    = "1"
    case limit              = "limit"
    case offset             = "offset"
    case errorTypePrefix    = "ECSPIL_"
    case locale             = "locale"
    case category           = "category"
    case pilKey             = "PIL"
    case current            = "current"
    case email              = "email"
    case productId          = "productId"
}

enum ECSPermittedAssetType: String {
    case RTP //= "RTP"
    case APP //= "APP"
    case DPP //= "DPP"
    case MI1 //= "MI1"
    case PID //= "PID"
}

// MARK: - PIL Microservices

enum ECSServiceId: String {
    case productDetails             = "ecs.productDetails"
    case productRetailers           = "ecs.wtbURL"
    case productList                = "ecs.productSearch"
    case createCart                 = "ecs.createCart"
    case fetchCart                  = "ecs.getCart"
    case addToCart                  = "ecs.addToCart"
    case updateCart                 = "ecs.updateCart"
    case notifyMe                   = "ecs.notifyMe"
}

enum ServiceDiscoveryReplacementConstants: String {
    case siteID             = "siteId"
    case language           = "language"
    case country            = "country"
    case quantity           = "quantity"
    case entryNumber        = "entryNumber"
    case cartId             = "cartId"
}
