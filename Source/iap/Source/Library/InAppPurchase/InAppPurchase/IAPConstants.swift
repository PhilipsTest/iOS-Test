/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import CoreGraphics

struct IAPConstants {
    struct IAPBadgeButtonConstant {
        static let kBadgeTag = 7373
    }
    
    struct IAPLaunchErrorCode {
        static let kRegistrationLaunchErrorCode = 4
        static let kErrorProductCTNCode = 8
    }
    
    struct IAPAlertViewTags {
        static let kDeleteAlertViewTag = 1001
        static let kErrorAlertViewTag = 0
        static let kSuccessAlertViewTag = 1
        static let kCVVAlertTag = 2
        static let kNoRetailerAlertViewTage = 1002
        static let kApologyAlertViewTag = 1003
        static let kConsumerCareTag = 1004
        static let kBuyDirectAlertTag = 1005
    }
    
    struct IAPPaymentResponseStatus {
        static let kPaymentSuccessTag = 0
        static let kPaymentFailureTag = 1
        static let kPaymentPendingTag = 2
        static let kPaymentCancelTag  = 3
    }
    
    struct IAPKeyChainItem {
        static let kKeyChainItemIdentifier = "InAppPurchaseKeyChainItem"
    }
    
    struct IAPAppTaggingStringConstants {
        //Screen names
        static let kShoppingCartPageName = "ShoppingCartPage"
        static let kShoppingCartItemDetailPageName = "ShoppingCartItemDetailPage"
        static let kProductCataloguePage = "ProductCataloguePage"
        static let kProductDetailPage = "ProductDetailPage"
        static let kShippingAddressPageName = "ShippingAddressPage"
        static let kShippingAddressSelectionPageName = "ShippingAddressSelectionPage"
        static let kShippingAddressEditPageName = "ShippingAddressEditPage"
        static let kBillingAddressPageName = "BillingAddressPage"
        static let kOrderSummaryPageName = "OrderSummaryPage"
        static let kCreditCardSelectionPageName = "CreditCardSelectionPage"
        static let kCreditCardInputPage = "CreditCardInputPage"
        static let kConfirmationPage = "PaymentConfirmationPage"
        static let kRetailerPageName = "RetailerWebPage"
        static let kSelectRetailerPageName = "SelectRetailerPage"
        static let kPurchaseHistoryPageName = "PurchaseHistoryPage"
        static let kOrderDetailPageName = "OrderDetailPage"
        static let kTrackOrderPageName = "TrackOrderPage"
        static let kVoucherPageName = "applyVoucher"
    }
    
    struct IAPErrorTaggingConstants {
        static let kTechError = "tech_error"
        static let kServerNotReachable = "ServerNotReachable"
        static let kNoNetwork = "NoNetwork"
        static let kProductNotFound = "ProductNotFound"
        static let kNoRetailersFound = "NoRetailersFound"
        static let kServerError = "ServerError"
    }
    
    struct IAPPaginationStructure {
        static let kFirstPageIndex = 0
    }
    
    struct IAPPurchaseHistoryModelKeys {
        static let kOrders = "orders"
        static let kOrderCode = "code"
        static let kPurchaseStatus = "status"
        static let kPurchaseStatusDisplay = "statusDisplay"
        static let kOrderPlacedDate = "placed"
        static let kOrderTotal = "total"
        static let kOrderFormattedTotal = "formattedValue"
        static let kOrderDateFormat = "EEEE MMM dd, yyyy"
        static let kServerDateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        static let kOrderDateOverviewFormat = "EEEE MMMM dd, yyyy"
        
        static let kPurchaseHistoryOveriViewURL = "orders"
        static let kSortKey     = "byDate"
        static let kOrderDetailProductEntriesKey = "entries"
        static let kOrderProductQuantityKey = "deliveryItemsQuantity"
        static let kOrderTotalPriceKey = "totalPriceWithTax"
        static let kOrderFormattedTotalPriceKey = "formattedValue"
        static let kOrderTotalPriceValueKey = "value"
        static let kOrderDeliveryAddressKey = "deliveryAddress"
        static let kOrderBillingAddressKey = "billingAddress"
        static let kOrderPaymentInfoKey = "paymentInfo"
        static let kOrderCardTypeKey = "cardType"
        static let kOrderCardNumberKey = "cardNumber"
        static let kOrderCardCodeKey = "code"
        static let kDeliveryModeKey = "deliveryMode"
        static let kDeliveryCostKey = "deliveryCost"
        static let kDeliveryCostFormattedKey = "formattedValue"
        static let kOrderProductKey = "product"
        static let kOrderPRoductQuantityKey = "quantity"
        static let kOrderTaxKey = "totalTax"
        static let kFormmatedValueKey = "formattedValue"
        
        // Purchase History detail model keys
        static let kOrderTrackingURLKey = "ordertrackUrl"
        static let kOrderDeliveryStatusKey = "deliveryStatus"
        static let kOrderTrackingId = "trackingID"
        static let consignments = "consignments"
        static let trackingUrls = "trackAndTraceUrls"
        static let trackingIds = "trackAndTraceIDs"
        static let orderEntry = "orderEntry"
    }
    
    struct IAPPurchaseHistoryCompletionHandlers {
        typealias GetPurchaseHistoryFetchHandler = (_ withOrders: [IAPPurcahseHistorySortedCollection], _ paginationModel: IAPPaginationModel?) -> Void
        typealias PurchaseHistoryFailureHandler  = (NSError)->()
    }
    
    struct IAPOrderHistoryUIConstants {
        static let kProductViewDefaultHeight: CGFloat    = 83.0
        static let kProductTitleDefaultHeight: CGFloat   = 21.0
        static let kWidthValueToBeUsed: CGFloat          = 60.0
    }
    
    struct IAPAddressBuilderKeys {
        static let kUserAddress = "addresses"
        static let kFields      = "fields"
        static let kFieldsValue = "FULL"
        static let kCartsKey    = "carts"
        static let kCartsValue  = "current"
        static let kDeliveryKey = "delivery"
        static let kRegionsKey = "regions"
    }
    
    struct IAPAddressCellConstants {
        static let kButtonViewHeightConstant: CGFloat = 105.0
        static let kButtonViewBottomConstant: CGFloat = 8.0
        static let kRowHeightConstant: CGFloat = 167.0
    }
    
    struct IAPNoInternetViewTags {
        static let kNoInternetViewTag = 10000
    }
    
    struct IAPCartBuilderKeys {
        static let kCarts             = "carts"
        static let kEntries           = "entries"
        static let kFields            = "fields"
        static let kSetDeliveyMode    = "deliverymode"
        static let kGetDeliveyMode    = "deliverymodes"
        static let kSetPaymentDetails = "paymentdetails"
        static let kFieldValue        = "FULL"
    }
    
    struct IAPVoucherKeys {
        static let kVoucherCodeKey           = "voucherCode"
        static let kVoucherDiscPercentKey    = "valueFormatted"
        static let kVoucherPriceValueKey     = "value"
        static let kVoucherAppliedValueKey   = "appliedValue"
        static let kVoucherFormattedValueKey = "formattedValue"
        static let kVoucherKey               = "vouchers"
        static let kVoucherNameKey           = "name"
        static let kVoucherSymbol            = "symbol"
        static let kAppliedVouchersKey       = "appliedVouchers"
    }
    
    struct IAPOrderDiscountKeys {
        static let kAppliedOrderPromotionsKey   = "appliedOrderPromotions"
        static let kPromotionKey                = "promotion"
        static let kDescriptionKey              = "description"
        static let kPromotionDiscountKey        = "promotionDiscount"
        static let kFormattedValueKey           = "formattedValue"
    }
    
    struct IAPCartError {
        static let kNoCartError = "No cart created yet."
    }
    
    struct IAPShoppingCartKeys {
        static let kCtnCodeKey       = "code"
        static let kQuantityKey      = "quantity"
        static let kProductKey       = "product"
        static let kEntryNumberKey   = "entryNumber"
        static let kStockKey         = "stock"
        static let kStockLevelKey    = "stockLevel"
        static let kTotalPriceKey    = "totalPrice"
        static let kProductPriceKey  = "basePrice"
        static let kPriceValueKey    = "formattedValue"
        static let kStockLevelStatusKey = "stockLevelStatus"
        static let kInStockKey       = "inStock"
        static let kLowStockKey      = "lowStock"
        static let kOutOfStockKey    = "outOfStock"
    }
    
    struct IAPShoppingCartInfoKeys {
        static let kCartIDKey                = "code"
        static let kTotalItemsKey            = "totalItems"
        static let kTotalPriceKey            = "totalPrice"
        static let kTotalPriceWithTaxKey     = "totalPriceWithTax"
        static let kCurrencyTypeIsoKey       = "currencyIso"
        static let kValueKey                 = "value"
        static let kTotalTaxKey              = "totalTax"
        static let kFormattedValueKey        = "formattedValue"
        static let kDeliveryModeKey          = "deliveryMode"
        static let kDeliveryModeNameKey      = "name"
        static let kShippingCostKey          = "deliveryCost"
        static let kDeliveryOrderGroupsKey   = "deliveryOrderGroups"
        static let kTaxInclusionKey          = "net"
        static let kFreeshippingKey          = "Freeshipping"
        static let kTotalUnitCountKey        = "totalUnitCount"
    }
    
    struct IAPConfigDataKeys {
        
        static let kCatalogId = "catalogId"
        static let kFaqUrl = "faqUrl"
        static let kHelpDeskEmail = "helpDeskEmail"
        static let kHelpDeskPhone = "helpDeskPhone"
        static let kHelpUrl = "helpUrl"
        static let kRootCategory = "rootCategory"
        static let kSiteId = "siteId"
    }
    
    struct IAPDeliveryModeKeys {
        static let kDeliveryModesKey      = "deliveryModes"
        static let kDeliveryCodeKey       = "code"
        static let kDeliveryCostKey       = "deliveryCost"
        static let kFormattedValueKey     = "formattedValue"
        static let kNameKey               = "name"
        static let kDescriptionKey        = "description"
    }
    
    struct IAPHTTPStatusKeys {
        static let kHTTPSuccessCode         = 200
        static let kHTTPCreationSuccessCode = 201
    }
    
    struct IAPHTTPErrorKeys {
        static let kErrorsKey = "errors"
        static let kErrorTypeKey = "type"
        static let kErrorMessageKey = "message"
    }
    
    struct IAPHTTPErrorResponseCode {
        static let kApiErrorResponseCode = 4000
        static let kErrorDictionaryKey  = "Error_Info_Dict"
    }
    
    struct IAPJanrainTokenErrors {
        static let kInvalidAccessToken = "InvalidTokenError"
        static let kInvalidGrantError  = "InvalidGrantError"
        static let kAccessTokenEmpty = 1001
    }
    
    struct IAPErrorComponents {
        static let kErrorTypeKey    = "type"
        static let kErrorMessageKey = "message"
    }
    
    struct IAPMakePaymentKeys {
        static let kWorldPaykey = "paymentProviderUrl"//"worldpayUrl"
    }
    
    struct IAPConfigurationKeys {
        static let kSchemeKey               = "scheme"
        static let kHostPortKey             = "hostport"
        static let kWebRootKey              = "webroot"
        static let kVersionKey              = "version"
        static let kSiteKey                 = "site"
        static let kPropositionId           = "propositionId"
        static let kvoucherCodeEnable       = "voucherCode.enable"
        static let kConfigFileName          = "ProductList"
        static let kIsDataLoadedFromHybris  = "loadDataFromHybris"
        static let kConfigFileForEnUS         = "productListForEnUS"
        static let kConfigFileForEnGB         = "productListForEnGB"
        static let kLocaleForUS               = "en_US"
        static let kLocaleForGB               = "en_GB"
        
        //worldpay status related keys
        static let kWorldpaySuccessURLKey   = "worldpaySuccessURL"
        static let kWorldpayFailureURLKey   = "worldpayFailureURL"
        static let kWorldpayPendingURLKey   = "worldpayPendingURL"
        static let kWorldpayCancelURLKey    = "worldpayCancelURL"
    }
    
    struct IAPOAuthParameterKeys {
        static let kAuthorisationKey      = "Authorization"
        static let kBasicKey              = "Basic "
        static let kLoginStringKeyAcceptance = "inApp_client:acc_inapp_12345"
        static let kLoginStringKeyProduction = "inApp_client:prod_inapp_54321"
        static let kReOAuthGrantType      = "refresh_token"
        static let kOAuthGrantTypeJanrain = "janrain"
        static let kOAuthGrantTypeOIDC    = "oidc"
    }
    
    struct IAPOAuthAccessTokenKeys {
        static let kAccessTokenKey   = "access_token"
        static let kRefreshTokenKey  = "refresh_token"
        static let kTokenTypeKey     = "token_type"
    }
    
    struct IAPOAuthCoderKeys {
        static let kAccessTokenCoderKey   = "AccessToken"
        static let kRefreshTokenCoderKey  = "RefreshToken"
        static let kTokenTypeCoderKey     = "TokenType"
        static let kAuthorizationKey     = "Authorization"
    }
    
    struct IAPOAuthNotFoundError {
        static let kOAuthDomainKey   = "OAUTH_NOT_FOUND"
        static let kOauthNotFoundCode = 1001
        static let kOauthErrorDescriptionKey = "OAUTH_ERROR_DESCRIPTION"
    }

    struct IAPOutOfStockError {
        static let kOutOfStockKey    = "OUT_OF_STOCK"
        static let kProductOutOfStock = 1002
        static let kProductStockDescriptionKey = "PRODUCT_OUT_OF_STOCK"
    }
    
    struct IAPNoInternetError {
        static let kNoInternetCode           = -1009
        static let kRequestTimeOutCode      = 504
        static let kServerNotReachable      = -1003
        static let kResourceNotFoundCode    = 404
    }
    
    struct IAPBuyDirectErrorCodes {
        static let kCartCouldNotBeCreatedCode   = 11111
        static let kProductCouldNotBeAddedCode  = 11112
        static let kNoDefaultAddressCode        = 11113
        static let kDelvieryAddressSetErrorCode = 11114
        static let kNoDeliveryModesCode         = 11115
        static let kDeliveryModeSetErrorCode    = 11116
        static let kNoPaymentDetailsErrorCode   = 11117
        static let kNoDefaultPaymentMethodCode  = 11118
        static let kCouldNotReAuthPaymentCode   = 11119
    }
    
    struct IAPBuyDirectErroKeys {
        static let kDefaultAddressKey           = "defaultAddress"
    }
    
    struct IAPHTTPError {
        static let kServiceUnavailable = 503
    }
    
    struct IAPOCCHeader {
        static let kAuthorizationKey    = "Authorization"
        static let kAddProductKey       = "code"
        static let kQuantityKey         = "qty"
        static let kDeliveryModeKey     = "deliveryModeId"
        static let kPaymentIdKey        = "paymentDetailsId"
        static let kVoucherCodeKey      = "voucherId"
        static let kPaymentCVVKey       = "securityCode"
        
        //address related keys
        static let kFirstNameKey        = "firstName"
        static let kLastNameKey         = "lastName"
        static let kTitleCodeKey        = "titleCode"
        static let kCountryCode         = "country.isocode"
        static let kAddressLine1        = "line1"
        static let kAddressLine2        = "line2"
        static let kPhone1              = "phone1"
        static let kPhone2              = "phone2"
        static let kTownKey             = "town"
        static let kPostalCodeKey       = "postalCode"
        static let kDefaultAddressKey   = "defaultAddress"
        static let kCartIdKey           = "cartId"
        static let kAddressID           = "addressId"
        static let kRegionCode          = "region.isocode"
        static let kHouseNumber         = "houseNumber"
    }
    
    struct IAPOCCResponse {
        static let kCartKey             = "carts"
        static let kErrorKey            = "errors"
        static let kStatusCode          = "statusCode"
        static let kSuccessStatusKey    = "success"
        static let kDefaultAddressKey   = "defaultAddress"
        static let kPaginationKey       = "pagination"
    }
    
    struct IAPPaymentKeys {
        static let kOrdersKey = "orders"
        static let kPayKey  = "pay"
    }
    
    struct IAPOrderInfoKeys {
        static let kOrderIdkey = "code"
        static let kDeliveryAddresskey = "deliveryAddress"
    }
    
    struct IAPOrderSummaryConstants {
        static let kShippingAddressCellNumber = 0
        static let kBillingAddressCellNumber  = 1
        static let kPaymentInfoCellNumber     = 2
        static var kShippingCostCellNumber    = 3
        static var kTotalCostCellNumber       = 4
        static let kExtraShoppingCartCell     = 5
        static let kRowHeightConstant: CGFloat = 157.0
        static let kLineSpacingCosntant: CGFloat = 8.0
    }
    
    struct IAPPaymentSelectionDecoratorConstants {
        static let kHeaderHeightConstant: CGFloat = 48.0
        static let kLineSpacingCosntant: CGFloat = 8.0
    }
    
    struct IAPUserAddressKeys {
        static let kCountryKey                = "country"
        static let kIsoCodeKey                = "isocode"
        static let kFirstNameKey              = "firstName"
        static let kIdKey                     = "id"
        static let kLastNameKey               = "lastName"
        static let kLine1Key                  = "line1"
        static let kLine2Key                  = "line2"
        static let kPostalCodeKey             = "postalCode"
        static let kTownKey                   = "town"
        static let kPhone1Key                 = "phone1"
        static let kPhone2Key                 = "phone2"
        static let kFormattedAddressKey       = "formattedAddress"
        static let kTitleCodeKey              = "titleCode"
        static let kTitleKey                  = "title"
        static let kRegionKey                 = "region"
        static let kNameKey                   = "name"
        static let kAddressKey                = "addresses"
        static let kHouseNumber               = "houseNumber"
        static let kHeaderHeightConstant      = 48.0
        static let kLineSpacingCosntant: CGFloat = 8.0
        static let kAddressLineSpacingCosntant: CGFloat = 2.0
    }
    
    struct IAPPaymentInfoKeys {
        static let kPaymentDetailskey              = "payments"
        static let kAccountHolderNamekey           = "accountHolderName"
        static let kCardNumberKey                  = "cardNumber"
        static let kCardTypeKey                    = "cardType"
        static let kCardTypeCodeKey                = "code"
        static let kExpiryMonthKey                 = "expiryMonth"
        static let kExpiryYearKey                  = "expiryYear"
        static let kPaymentIdKey                   = "id"
        static let kLastSuccessfulOrderDateKey     = "lastSuccessfulOrderDate"
        static let kDefaultPaymentKey              = "defaultPayment"
        static let KBillingAddressKey              = "billingAddress"
    }
    
    struct IAPProductKeys {
        static let kProductKey      = "products"
        static let kSearchKey       = "search"
        static let kQueryKey        = "query"
        static let kCatalogueKey    = "::category:"
        static let kCurrentPage     = "currentPage"
        static let kPageSizeKey     = "pageSize"
    }
    
    struct IAPProductCatalogue {
        static let kProductKey              = "products"
        static let kProductCTNKey           = "code"
        static let kProductNameKey          = "name"
        static let kProductPriceKey         = "price"
        static let kProductDiscountPriceKey = "discountPrice"
        static let kProductFormattedKey     = "formattedValue"
        static let kProductPriceValueKey    = "value"
        static let kProductStockKey         = "stock"
        static let kProductStockStatusKey   = "stockLevelStatus"
    }
    
    struct IAPPaginationKeys {
        static let kCurrentPageKey = "currentPage"
        static let kPageSizeKey    = "pageSize"
        static let kTotalPagesKey  = "totalPages"
        static let kTotalResultKey = "totalResults"
    }
    
    struct IAPPurchaseHistoryCellNumber {
        static let kOrderCellNumber: Int = 0
        static let kTotalCellNumber: Int = 1
        static let kOrderStatusCellNumber: Int = 2
        static let kTrackCellNumber: Int = 3
        static var kShippingAddCellNumber: Int = 4
        static var kBillingAddCellNumber: Int = 5
        static var kPaidByCellNumber: Int = 6
        static var kTotalAccessoryCellNumber: Int = 7
    }
    
    struct IAPPurchaseHistoryOrderDetailsSection {
        static let kPurchaseHistoryConsumerSection: Int = 0
        static let kProductsSection: Int = 1
        static let kYourDetailsSection: Int = 2
        static let kSummarySection: Int = 3
        static let kTotalSection: Int = 4
    }
    
    struct IAPPurchaseHistoryOrderDetailsRow {
        static let kPurchaseHistoryOrderStatusRow: Int = 0
        static let kPurchaseHistoryOrderSummaryRow: Int = 1
    }

    struct IAPPurchaseHistoryOrderAddressRow {
        static let kPurchaseHistoryOrderShippingRow: Int = 0
        static let kPurchaseHistoryOrderBillingRow: Int = 1
        static let kPurchaseHistoryOrderPaymentRow: Int = 2
    }
    
    struct IAPPurchaseHistoryOrderSummaryPriceRow {
        static let kPurchaseHistorySummaryFirstRow: Int = 0
    }
    
    struct IAPRetailerKeys {
        static let kRetailerNameKey = "name"
        static let kRetailerProductAvailability = "availability"
        static let kRetailerBuyURL = "buyURL"
        static let kRetailerLogoURL = "logoURL"
        static let kPhilipsStoreAvailable = "isPhilipsStore"
        static let kRetailerParam = "xactparam"
        //retailer info keys
        static let kWRBResults = "wrbresults"
        static let kOnlineStores = "OnlineStoresForProduct"
        static let kStores = "Stores"
        static let kStore = "Store"
    }
    
    struct IAPRetailerURLKeys {
        static let kScheme = "https"
        static let kHostport = "www.philips.com"
        static let kWebroot = "api/wtb"
        static let kVersion = "v1"
        static let kSector = "B2C"
    }
    
    struct IAPUserBuilderKeys {
        static let kUsers       = "users"
        static let kUserAddress = "addresses"
        static let kUserPaymentDetails = "paymentdetails"
        static let kFieldsKey   = "fields"
        static let kFullKey     = "FULL"
        static let kCurrentPage = "currentPage"
        static let kSortKey     = "sort"
    }
    
    struct IAPOauthURLKeys {
        static let kJanrainTokenStartKey = "/oauth/token?"
        
    }
    
    struct SDURLKeys {
        static let kPrivacy = "privacyPolicy"
        static let kTerms = "termOfUse"
        static let kFAQ = "faq"
    }
    
    struct IAPPRXConsumerURLBuilderKeys {
        static let kSector = "B2C"
        static let kCatalogCode = "CARE"
        static let kScheme = "https"
        static let kHostport = "www.philips.com"
        static let kWebroot = "prx/cdls"
        static let kQuery = "querytype.(fallback)"
    }
    
    struct IAPPRXConsumerKeys {
        static let kData = "data"
        static let kPhone = "phone"
        static let kPhoneNumber = "phoneNumber"
        static let kWeekdayPhoneHours = "openingHoursWeekdays"
        static let kWeekendPhoneHours = "openingHoursSaturday"
        static let kWeekendPhoneHoursSun = "openingHoursSunday"
        static let kImageJP2Format = "image/jp2"
        static let kOctetFormat    = "application/octet-stream"
    }
    
    struct IAPHybrisUnknownErrorKeys {
        static let kIllegalArgumentError = "IllegalArgumentError"
    }
    // TODO : Have to update the icon names once we receive the correct one
    struct IAPFontIconName {
        static let rightArrowIcon         = "Navigation Next"
        //static let rightArrowIcongray     = "RightArrowIconGray"
        //static let rightArrowIconWhite    = "RightArrowIconWhite"
        //static let leftArrowIconWhite     = "LeftArrowIcon"
    }
    
    struct TableviewSectionConstants {
        static let kShoppingCartSection: NSInteger = 0
        static let kAddressCellSection: NSInteger = 1
        static let kDeliveryModeSection: NSInteger = 2
        static let kOrderSummarySection: NSInteger = 3
        static let kShippingCostSection: NSInteger = 4
        static let kVoucherDiscountSection: NSInteger = 5
        static let kOrderDiscountSection: NSInteger = 6
        static let kTotalCellSection: NSInteger = 7
    }
    
    struct ShoppingCartTableSectionConstants {
        static let kShoppingCartSection: NSInteger = 0
        static let kAddressCellSection: NSInteger = 1
        static let kOrderSummarySection: NSInteger = 2
        static let kShippingCostSection: NSInteger = 3
        static let kVoucherDiscountSection: NSInteger = 4
        static let kOrderDiscountSection: NSInteger = 5
        static let kPurchaseHistorySection: NSInteger = 6
        static let kTotalCellSection: NSInteger = 7
    }
    
    struct IAPFormValidation {
        static let kStartValidationIndex = 0
        static let kEndValidationIndex = 23
        static let kShippingAddressEndValidationIndex = 10
        static let kBillingAddressStartValidationIndex = 11
        static let kBillingAddressEndValidationIndex = 21
    }
    
    struct IAPCommonSectionHeaderView {
        static let kShoppingCartSection = 0
        static let kOrderSummarySection = 1
    }
}
