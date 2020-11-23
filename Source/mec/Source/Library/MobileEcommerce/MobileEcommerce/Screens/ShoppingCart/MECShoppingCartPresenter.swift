/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsEcommerceSDK
import PhilipsUIKitDLS
import BVSDK

protocol MECShoppingCartDelegate: NSObjectProtocol {
    func shoppingCartLoaded()
    func showError(error: Error?)
}

class MECShoppingCartPresenter: MECBasePresenter {

    weak var shoppingCartDelegate: MECShoppingCartDelegate?
    var cartProductReviews: [BVProductStatistics]?
    var dataBus: MECDataBus?
    var bazaarVoiceHandler: BazaarVoiceHandler?

    override init() {
        super.init()
        dataBus = MECDataBus()
        bazaarVoiceHandler = BazaarVoiceHandler.sharedInstance
    }

    func fetchShoppingCart(completionHandler: @escaping (_ shoppingCart: ECSPILShoppingCart?, _ error: Error?) -> Void ) {
        oauthHybris { [weak self](_, error) in
            if let inError = error {
                self?.shoppingCartDelegate?.showError(error: inError)
                completionHandler(nil, error)
            } else {
                self?.fetchCart(completionHandler: completionHandler)
            }
        }
    }

    func isCartLoaded() -> Bool {
        return dataBus?.shoppingCart != nil
    }

    func numberOfProductInCart() -> Int {
        return dataBus?.shoppingCart?.data?.attributes?.items?.count ?? 0
    }

    func totalTax() -> String {
        return dataBus?.shoppingCart?.data?.attributes?.pricing?.tax?.formattedValue ?? ""
    }

    func totalPrice() -> String {
        return dataBus?.shoppingCart?.data?.attributes?.pricing?.total?.formattedValue ?? ""
    }

    func averageRatingForProduct(ctn: String?) -> Float {
        let review = cartProductReviews?.filter({ $0.productId == ctn }).first?.reviewStatistics?.averageOverallRating ?? 0.0
        return review.floatValue
    }

    func totalNumberOfReviewsForProduct(ctn: String?) -> Int {
        let review = cartProductReviews?.filter({ $0.productId == ctn }).first?.reviewStatistics?.totalReviewCount ?? 0
        return review.intValue
    }

    func totalCartQuantity() -> Int {
        return dataBus?.shoppingCart?.data?.attributes?.units ?? 0
    }

    func discountPercentage(for productEntry: ECSPILItem?) -> String? {
        if let discountedPrice = productEntry?.discountPrice?.value,
            let actualPrice = productEntry?.price?.value, actualPrice > 0 {
                if actualPrice != discountedPrice {
                    let discountAmount = actualPrice - discountedPrice
                    let discountPercentage = (discountAmount/actualPrice) * 100
                    return "-\(String(format: "%.2f", discountPercentage))%"
                }
            }
        return nil
    }

    func cartProductEntryAtIndex(productIndex: Int) -> ECSPILItem? {
        guard (dataBus?.shoppingCart?.data?.attributes?.items?.count ?? 0) > productIndex, productIndex >= 0 else { return nil }
        return dataBus?.shoppingCart?.data?.attributes?.items?[productIndex]
    }

    func deleteProductAtIndex(productIndex: Int) {
        guard (dataBus?.shoppingCart?.data?.attributes?.items?.count ?? 0) > productIndex,
            let entry = dataBus?.shoppingCart?.data?.attributes?.items?[productIndex] else { return }
        updateShoppingCart(quantity: 0, entry: entry)
    }

    func shouldShowApplyVoucher() -> Bool {
        do {
            guard let voucherStatus = try MECConfiguration.shared.sharedAppInfra.appConfig
                .getPropertyForKey("voucherCode.enable", group: MECConstants.MECTLA) as? Int else {
                return false
            }
            return voucherStatus == 1
        } catch {
            trackTechnicalError(errorCategory: MECAnalyticErrorCategory.appError,
                                serverName: MECAnalyticServer.other, error: error)
            return false
        }
    }

    func isVoucherAlreadyApplied(voucherId: String) -> Bool {
        return ((dataBus?.shoppingCart?.data?.attributes?.appliedVouchers?.first(where: { (voucher) -> Bool in
            return voucher.voucherCode == voucherId
        })) != nil)
    }

    func shouldEnableCheckout() -> Bool {
        let list = dataBus?.shoppingCart?.data?.attributes?.items?.filter({
            (($0.quantity ?? 0) > ($0.availability?.quantity ?? 0) ||
                $0.availability?.status == MECConstants.MECPILOutOfStock) })
        return list?.count == 0 ? true : false
    }

    func getStockStatusMessage(entry: ECSPILItem?) -> NSAttributedString? {
        guard let cartEntry = entry else { return nil }
        if !(MECUtility.isPILStockAvailable(stockLevelStatus: cartEntry.availability?.status,
                                            stockAmount: cartEntry.availability?.quantity ?? 0)) {
            guard let textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText,
                let color = UIDThemeManager.sharedInstance.defaultTheme?.ratingBarDefaultOnIcon else { return nil }

            let outOfStockMessage = MECLocalizedString("mec_cart_out_of_stock_message")
            let attributedQuote = NSMutableAttributedString(string: outOfStockMessage,
                                                            attributes: [ .foregroundColor: textColor ])
            attributedQuote.addAttributes([ .foregroundColor: color ],
                                          range: outOfStockMessage.uppercased().nsRange(of:
                                            MECLocalizedString("mec_out_of_stock").uppercased()) ?? NSRange(location: 0, length: 0))
            return attributedQuote
        } else {
            guard let stock = cartEntry.availability?.quantity, let quantity = cartEntry.quantity else { return nil }
            guard quantity > stock || stock < 5 else {
                return nil
            }
            return NSAttributedString(string: "\(MECLocalizedString("mec_only")) \(stock) \(MECLocalizedString("mec_stock_available"))")
        }
    }

    fileprivate func cartProductCTNList() -> [String]? {
        return dataBus?.shoppingCart?.data?.attributes?.items?.map({ ($0.ctn ?? "") })
    }

    func cartProductList() -> [ECSPILItem]? {
        return dataBus?.shoppingCart?.data?.attributes?.items
    }

    fileprivate func fetchReviewForProducts(completion: @escaping (_ success: Bool) -> Void) {
        guard let ctnList = cartProductCTNList() else {
            completion(false)
            return
        }
        bazaarVoiceHandler?.fetchBulkRatingsFor(productCTNs: ctnList) {[weak self] (bulkReviewList) in
            self?.cartProductReviews = bulkReviewList
            completion(true)
        }
    }
}

// MARK: - Hybris API calls
extension MECShoppingCartPresenter {

    func applyVoucherToCart(voucherId: String, completion: @escaping ( _ success: Bool, _ error: Error?) -> Void) {
        MECConfiguration.shared.ecommerceService?.applyVoucher(voucherID: voucherId, completionHandler: { [weak self] (_, error) in
            guard let weakSelf = self else { return }
            guard let voucherError = error else {
                weakSelf.trackApplyVoucher(voucherId: voucherId)
                weakSelf.checkAndRemoveAutoApplyVoucher(voucherId: voucherId)
                weakSelf.fetchCart { (_, _) in }
                return
            }
            voucherError.handleOauthError {(handled, error) in     //Handling token expiry error
                if handled == true {
                    weakSelf.applyVoucherToCart(voucherId: voucherId, completion: completion)
                } else {
                    if error?.code == 5010 {
                        self?.trackUserError(errorMessage: error?.localizedDescription)
                    } else {
                        self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.applyVoucher,
                                                  serverName: MECAnalyticServer.hybris, error: error)
                    }
                    completion(false, error)
                }
            }
        })
    }

    func deleteVoucher(at index: Int, completion: @escaping(_ success: Bool, _ error: Error?) -> Void) {
        if let voucherList = dataBus?.shoppingCart?.data?.attributes?.appliedVouchers, index < voucherList.count,
            let voucherId = voucherList[index].voucherCode?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            MECConfiguration.shared.ecommerceService?.removeVoucher(voucherID: voucherId,
                                                                    completionHandler: {[weak self] (_, error) in
                guard let voucherError = error else {
                    self?.trackVoucherDeleted(voucherId: voucherId)
                    self?.checkAndRemoveAutoApplyVoucher(voucherId: voucherId)
                    self?.fetchCart(completionHandler: { (_, _) in })
                    return
                }
                voucherError.handleOauthError {(handled, error) in     //Handling token expiry error
                    if handled == true {
                        self?.deleteVoucher(at: index, completion: completion)
                    } else {
                        self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.removeVoucher,
                                                  serverName: MECAnalyticServer.hybris, error: error)
                        completion(false, error)
                    }
                }
            })
        } else {
            completion(false, nil)
        }
    }

    func trackVoucherDeleted(voucherId: String) {
        let param = [MECAnalyticsConstants.specialEvents: MECAnalyticsConstants.voucherCodeRevoked,
                     MECAnalyticsConstants.productListKey:
                        preparePILCartEntryListString(entries: dataBus?.shoppingCart?.data?.attributes?.items),
                     MECAnalyticsConstants.voucherCode: voucherId]
        trackAction(parameterData: param)
    }

    func trackProductRemoved(for entry: ECSPILItem, quantity: Int) {
        let param = [MECAnalyticsConstants.specialEvents: MECAnalyticsConstants.scRemove,
                     MECAnalyticsConstants.productListKey: preparePILCartEntryListString(entries: [entry], updatedQuantity: quantity)]
        trackAction(parameterData: param)
    }

    func trackProductAdded(for entry: ECSPILItem, quantity: Int) {
        let param = [MECAnalyticsConstants.specialEvents: MECAnalyticsConstants.scAdd,
                     MECAnalyticsConstants.productListKey: preparePILCartEntryListString(entries: [entry], updatedQuantity: quantity)]
        trackAction(parameterData: param)
    }

    func trackApplyVoucher(voucherId: String) {
        trackAction(parameterData: [MECAnalyticsConstants.specialEvents: MECAnalyticsConstants.voucherCodeApplied,
                                    MECAnalyticsConstants.productListKey:
                                        preparePILCartEntryListString(entries: dataBus?.shoppingCart?.data?.attributes?.items),
                                    MECAnalyticsConstants.voucherCode: voucherId])
    }

    func trackProductUpdate(quantity: Int, entry: ECSPILItem?) {
        guard let cartEntry = entry, let entryQuantity = cartEntry.quantity, quantity != entryQuantity else { return }
        guard quantity < entryQuantity else {
            trackProductRemoved(for: cartEntry, quantity: (quantity - entryQuantity))
            return
        }
        trackProductAdded(for: cartEntry, quantity: (entryQuantity - quantity))
    }

    func updateShoppingCart(quantity: Int, entry: ECSPILItem) {
        let previousQuantity = entry.quantity ?? 0
        MECConfiguration.shared.ecommerceService?.updateECSShoppingCart(cartItem: entry,
                                                                        quantity: quantity,
                                                                        completionHandler: { [weak self] (shoppingCart, error) in
            guard let cartError = error else {
                self?.dataBus?.shoppingCart = shoppingCart
                self?.shoppingCartDelegate?.shoppingCartLoaded()
                if quantity == 0 {
                    self?.trackProductRemoved(for: entry, quantity: entry.quantity ?? 0)
                } else {
                    let updatedEntry = shoppingCart?.data?.attributes?.items?.filter({ (newEntry) -> Bool in
                        return newEntry.ctn == entry.ctn
                    })
                    self?.trackProductUpdate(quantity: previousQuantity, entry: updatedEntry?.first)
                }
                return
            }
            cartError.handleOauthError {(handled, error) in        //Handling token expiry error
                if handled == true {
                    self?.updateShoppingCart(quantity: quantity, entry: entry)
                } else {
                    self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.updateShoppingCart,
                                              serverName: MECAnalyticServer.hybris, error: error)
                    self?.shoppingCartDelegate?.showError(error: cartError)
                }
            }
        })
    }

    fileprivate func fetchCart(completionHandler: @escaping (_ shoppingCart: ECSPILShoppingCart?, _ error: Error?) -> Void ) {
        fetchMECShoppingCart { [weak self] (shoppingCart, error) in
            guard let cartError = error else {
                self?.dataBus?.shoppingCart = shoppingCart
                if (shoppingCart?.data?.attributes?.items?.count ?? 0) > 0 {
                    self?.fetchReviewForProducts(completion: { (_) in
                        completionHandler(shoppingCart, nil)
                        self?.shoppingCartDelegate?.shoppingCartLoaded()
                    })
                } else {
                    completionHandler(shoppingCart, nil)
                    self?.shoppingCartDelegate?.shoppingCartLoaded()
                }
                return
            }
            completionHandler(nil, error)
            self?.shoppingCartDelegate?.showError(error: cartError)
        }
    }

    func checkAndRemoveAutoApplyVoucher(voucherId: String) {
        guard let autoApplyVoucherId = MECConfiguration.shared.voucherCode else { return }
        if voucherId == autoApplyVoucherId {
            MECConfiguration.shared.voucherCode = nil
        }
    }
}

// MARK: - Address Section
extension MECShoppingCartPresenter {

    func fetchSavedAddresses(completionHandler: @escaping (_ addressList: [ECSAddress]?, _ error: Error?) -> Void) {
        MECConfiguration.shared.ecommerceService?.fetchSavedAddresses(completionHandler: {[weak self] (addreses, error) in
            guard let addressError = error else {
                completionHandler(addreses, error)
                return
            }
            addressError.handleOauthError {(handled, error) in         //Handling token expiry error
                if handled == true {
                    self?.fetchSavedAddresses(completionHandler: completionHandler)
                } else {
                    self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.fetchSavedAddresses,
                                              serverName: MECAnalyticServer.hybris, error: error)
                    completionHandler(addreses, error)
                }
            }
        })
    }
}
