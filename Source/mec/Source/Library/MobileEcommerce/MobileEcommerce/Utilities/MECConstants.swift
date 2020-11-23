/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

let noCartErrorCode = 6023

struct MECErrorCode {
    static let MECRegistrationLaunchErrorCode   = 4
    static let MECErrorProductCTNCode           = 8
    static let MECErrorLandingViewCode          = 9
    static let MECAuthentication                = 10
    static let MECNoInternetCode                = -1009
    static let MECHybrisDisabled                = 5055
}

struct MECErrorDomain {
    static let MECAuthentication                        = "Authentication"
    static let MECNoNetworkDomain                       = "NoNetwork"
    static let MECHybrisDisabled                        = "HybrisDisabled"
}

struct MECConstants {
    static let MECDefaultLanguage                       = "en"
    static let MECLanguageFileType                      = "lproj"
    static let MECTLA                                   = "MEC"
    static let MECComponentId                           = "mec"
    static let MECProductReviewsDownloadLimit: UInt     = 20
    static let MECNoImageIconName                       = "no_image_icon"
    static let MECAccessToken                           = "access_token"
    static let MECPropositionId                         = "propositionId"
    static let MECAddressSalutationKey                  = "salutation"
    static let MECAddressFirstNameKey                   = "firstName"
    static let MECAddressLastNameKey                    = "lastName"
    static let MECAddressPhoneKey                       = "phone"
    static let MECAddressHouseNumberKey                 = "houseNumber"
    static let MECAddressLineOneKey                     = "address1"
    static let MECAddressLineTwoKey                     = "address2"
    static let MECAddressTownKey                        = "town"
    static let MECAddressPostalCodeKey                  = "postalCode"
    static let MECAddressStateKey                       = "state"
    static let MECAddressCountryKey                     = "country"
    static let MECAddressConfigFileName                 = "MECAddressFieldsConfiguration"
    static let MECPlistType                             = "plist"
    static let MECAddressValidationBlankType            = "BlankField"
    static let MECAddressValidationPhoneType            = "ValidPhoneNumber"
    static let MECNewCardIdentifier                     = "MEC_New_Card"
    // swiftlint:disable identifier_name
    static let MECMECPaymentsDownloadedCollectionViewTag = 000
    static let MECMECPaymentsNotDownloadedCollectionViewTag = 111
    // swiftlint:enable identifier_name
    static let MECUSEROAUTHDATASAVEKEY                  = "mec_auth_data"
    static let MECUSEROAUTHEMAILDATASAVEKEY             = "mec_email_id"
    static let MECPILInStockKey                         = "IN_STOCK"
    static let MECPILLowStockKey                        = "LOW_STOCK"
    static let MECPILOutOfStock                         = "OUT_OF_STOCK"
    static let MECProductDownloadLimit: Int             = 50
    static let MECMaximumCartUpdateQuantity: Int        = 20
}

struct MECNibName {
    static let MECCustomActivityProgressView            = "MECCustomActivityProgressView"
    static let MECPriceView                             = "MECPriceView"
    static let MECLoadingCell                           = "MECLoadingCell"
    static let MECReviewsHeaderView                     = "MECReviewsHeaderView"
    static let MECProductSpecsHeaderView                = "MECProductSpecsHeaderView"
    static let MECProductGridCell                       = "MECProductGridCell"
    static let MECBannerContainerView                   = "MECBannerContainerView"
    static let MECBannerViewContainerCell               = "MECBannerViewContainerCell"
    static let MECShoppingCartProductCell               = "MECShoppingCartProductCell"
    static let MECApplyVoucherCell                      = "MECApplyVoucherCell"
    static let MECAppliedVoucherCell                    = "MECAppliedVoucherCell"
    static let MECAddressFieldView                      = "MECAddressFieldView"
    static let MECDeliveryDetailsStepView               = "MECDeliveryDetailsStepView"
    static let MECSummaryCell                           = "MECSummaryCell"
    static let MECCheckoutShippingCell                  = "MECCheckoutShippingCell"
    static let MECCheckoutDeliveryModeCell              = "MECCheckoutDeliveryModeCell"
    static let MECCheckoutPaymentCell                   = "MECCheckoutPaymentCell"
    static let MECCheckoutVoucherCell                   = "MECCheckoutVoucherCell"
    static let MECCheckoutProductCell                   = "MECCheckoutProductCell"
    static let MECStepDetail                            = "MECStepDetail"
    static let MECOrderHistoryProductDetailView         = "MECOrderHistoryProductDetailView"
    static let MECNoOrderDetailView                     = "MECNoOrderDetailView"
    static let MECOrderDetailContactCell                = "MECOrderDetailContactCell"
    static let MECOrderDetailProductCell                = "MECOrderDetailProductCell"
    static let MECStockFilterCell                       = "MECStockFilterCell"
    static let MECProductSortCell                       = "MECProductSortCell"
}

struct MECCellIdentifier {
    static let MECProductReviewLoadingCell              = "MECProductReviewLoadingCell"
    static let MECProductReviewCell                     = "MECProductReviewCell"
    static let MECProductSpecsCell                      = "MECProductSpecsCell"
    static let MECProductFeaturesCell                   = "MECProductFeaturesCell"
    static let MECProductGridCell                       = "MECProductGridCell"
    static let MECProductListCell                       = "MECProductListCell"
    static let MECBannerContainerView                   = "MECBannerContainerView"
    static let MECBannerViewContainerCell               = "MECBannerViewContainerCell"
    static let MECProductRetailersCell                  = "MECProductRetailersCell"
    static let MECShoppingCartProductCell               = "MECShoppingCartProductCell"
    static let MECApplyVoucherCell                      = "MECApplyVoucherCell"
    static let MECAppliedVoucherCell                    = "MECAppliedVoucherCell"
    static let MECPopoverCell                           = "MECPopoverCell"
    static let MECDeliveryStepCell                      = "MECDeliveryStepCell"
    static let MECManageAddressCell                     = "MECManageAddressCell"
    static let MECAddressDisplayCell                    = "MECAddressDisplayCell"
    static let MECSummaryCell                           = "MECSummaryCell"
    static let MECAddressDetailsCollectionViewCell      = "MECAddressDetailsCollectionViewCell"
    static let MECAddAddressCollectionViewCell          = "MECAddAddressCollectionViewCell"
    static let MECDeliveryModesCell                     = "MECDeliveryModesCell"
    static let MECPaymentsListCell                      = "MECPaymentsListCell"
    static let MECLoadingCollectionViewCell             = "MECLoadingCollectionViewCell"
    static let MECPaymentDetailsCollectionViewCell      = "MECPaymentDetailsCollectionViewCell"
    static let MECPaymentAddAddressCollectionViewCell   = "MECPaymentAddAddressCollectionViewCell"
    static let MECCheckoutShippingCell                  = "MECCheckoutShippingCell"
    static let MECCheckoutDeliveryModeCell              = "MECCheckoutDeliveryModeCell"
    static let MECCheckoutPaymentCell                   = "MECCheckoutPaymentCell"
    static let MECCheckoutVoucherCell                   = "MECCheckoutVoucherCell"
    static let MECCheckoutProductCell                   = "MECCheckoutProductCell"
    static let MECStepDetail                            = "MECStepDetail"
    static let MECOrderHistoryProductDetailCell         = "MECOrderHistoryProductDetailCell"
    static let MECOrderDetailContactCell                = "MECOrderDetailContactCell"
    static let MECOrderDetailProductCell                = "MECOrderDetailProductCell"
    static let MECStockFilterCell                       = "MECStockFilterCell"
    static let MECProductSortCell                       = "MECProductSortCell"
}

struct MECBazaarVoiceConstants {
    static let MECProsKey                               = "Pros"
    static let MECProKey                                = "Pro"
    static let MECConsKey                               = "Cons"
    static let MECConKey                                = "Con"
    static let MECHowLongHaveYouBeenUsingThisProductKey = "HowLongHaveYouBeenUsingThisProduct"
    static let MECLocaleKey                             = "Locale"
    static let MECValueKey                              = "Value"
    static let MECClientIDKey                           = "clientId"
    static let MECApiKeyConversationsKey                = "apiKeyConversations"
    static let MECFilteredStatsKey                      = "FilteredStats"
    static let MECReviews                               = "Reviews"
    static let MECBazaarVoiceTermsLink                  = "http://www.bazaarvoice.com/trustmark/"
}

struct MECServiceKeys {
    static let MECPrivacy                               = "privacyPolicy"
    static let MECTerms                                 = "termOfUse"
    static let MECFAQ                                   = "faq"
    static let MECSRP                                   = "srp"
}

struct MECDeliveryDetailsSections {
    static let MECDeliveryStepsSection          = 0
    static let MECShippingAddressSection        = 1
    static let MECDeliveryModesSection          = 2
    static let MECPaymentDetailsSection         = 3
}

struct MECImageDownloadSpecialFormats {
    static let MECJP2Format                     = "image/jp2"
    static let MECOctetFormat                   = "application/octet-stream"
}
