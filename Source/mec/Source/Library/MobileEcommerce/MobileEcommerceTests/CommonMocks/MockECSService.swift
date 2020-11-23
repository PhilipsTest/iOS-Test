/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsEcommerceSDK

class MockECSService: ECSServices {
    var products: ECSPILProducts?
    var productList: [ECSPILProduct]?
    var error: NSError?
    var retailerFetchError: NSError?
    
    var oAuthData: ECSOAuthData?
    var refreshAuthData: ECSOAuthData?
    var oauthError: NSError?
    var shouldSendOauthError = false
    var shouldSendCreateCartOauthError = false
    var shouldSendOauthErrorForSetDeliveryAddressWithBoolReturn = false
    var refreshOauthError: NSError?
    
    var fetchedProduct: ECSPILProduct?
    var retailers: ECSRetailerList?
    var shoppingCart: ECSPILShoppingCart?
    var createShoppingCart: ECSPILShoppingCart?
    var shoppingCartError: NSError?
    var createShoppingCartError: NSError?
    
    var voucherList: [ECSVoucher]?
    var voucherError: NSError?
    
    var savedAddresses: [ECSAddress]?
    var savedAddressesError: NSError?
    var setDeliveryAddressStatus: Bool = false
    var setDeliveryAddressError: NSError?
    var saveAddress: ECSAddress?
    var saveAddressError: NSError?
    var regions: [ECSRegion]?
    var regionError: NSError?
    var userProfile: ECSUserProfile?
    var userProfileError: NSError?
    var deleteAddressError: NSError?
    var deliveryModes: [ECSDeliveryMode]?
    var deliveryModeFetchError: NSError?
    var setDeliveryModeStatus: Bool = false
    var setDeliveryModeError: NSError?
    var savedPayments: [ECSPayment]?
    var setPaymentStatus: Bool = false
    var setPaymentError: NSError?
    var submitOrderDetail: ECSOrderDetail?
    var submitOrderError: NSError?
    var config: ECSConfig?
    var paymentProvider: ECSPaymentProvider?
    var orderHistory: ECSOrderHistory?
    var orderHistoryError: NSError?
    var orderDetails: [String: ECSOrderDetail?]?
    var orderDetailError: [String: NSError]?
    
    var notifyMeSuccess: Bool = false
    var notifyMeError: NSError?
    
    override func configureECSWithConfiguration(completionHandler: @escaping ECSGetConfigCompletion) {
        completionHandler(config, error)
    }
    
    override func fetchECSProducts(category: String? = nil, limit: Int = 20, offset: Int = 0, filterParameter: ECSPILProductFilter? = nil, completionHandler: @escaping ECSPILProductsFetchCompletion) {
        if products != nil {
            completionHandler(products, error)
        } else if error != nil {
            completionHandler(nil, error)
        } else {
            completionHandler(ECSPILProducts(), error)
        }
    }
    
    override func fetchECSProductSummariesFor(ctns: [String], completionHandler: @escaping ECSPILProductSummaryFetchCompletion) {
        if productList != nil {
            completionHandler(productList, nil, nil)
        } else {
            completionHandler(nil, nil, error)
        }
    }
    
    override func fetchECSProductFor(ctn: String, completionHandler: @escaping ECSPILProductFetchCompletion) {
        if fetchedProduct != nil {
            completionHandler(fetchedProduct, error)
        } else if error != nil {
            completionHandler(nil, error)
        } else {
            completionHandler(ECSPILProduct(), error)
        }
    }
    
    override func fetchECSProductDetailsFor(product: ECSPILProduct, completionHandler: @escaping ECSPILProductDetailsFetchCompletion) {
        if error == nil {
            completionHandler(product, nil)
        } else {
            completionHandler(product, error)
        }
    }
    
    override func fetchRetailerDetailsFor(productCtn: String, completionHandler: @escaping ECSRetailerListCompletion) {
        if retailers != nil  {
            completionHandler(retailers, retailerFetchError)
        } else if retailerFetchError != nil {
            completionHandler(nil, retailerFetchError)
        } else {
            completionHandler(ECSRetailerList(), retailerFetchError)
        }
    }
    
    override func hybrisOAuthAuthenticationWith(hybrisOAuthData: ECSOAuthProvider, completionHandler: @escaping ECSHybrisOAuthCompletion) {
        if (oAuthData != nil) {
            completionHandler(oAuthData, nil)
        } else if oauthError != nil {
            completionHandler(nil, oauthError)
        } else {
            completionHandler(ECSOAuthData(), oauthError)
        }
    }
    
    override func hybrisRefreshOAuthWith(hybrisOAuthData: ECSOAuthProvider, completionHandler: @escaping ECSHybrisOAuthCompletion) {
        if refreshAuthData != nil {
            completionHandler(refreshAuthData, nil)
        } else if oauthError != nil {
            completionHandler(nil, refreshOauthError)
        } else {
            completionHandler(ECSOAuthData(), refreshOauthError)
        }
    }
    
    override func fetchECSShoppingCart(completionHandler: @escaping ECSPILShoppingCartCompletion) {
        guard shouldSendOauthError == false else {
            shouldSendOauthError = false
            completionHandler(nil, NSError(domain: "", code: 6025, userInfo: nil))
            return
        }
        
        if shoppingCart != nil {
            completionHandler(shoppingCart, nil)
        } else if shoppingCartError != nil {
            completionHandler(nil, shoppingCartError)
        } else {
            completionHandler(ECSPILShoppingCart(), shoppingCartError)
        }
    }
    
    override func updateECSShoppingCart(cartItem: ECSPILItem, quantity: Int, completionHandler: @escaping ECSPILShoppingCartCompletion) {
        guard shouldSendOauthError == false else {
            shouldSendOauthError = false
            completionHandler(nil, NSError(domain: "", code: 6025, userInfo: nil))
            return
        }
        
        if shoppingCart != nil {
            completionHandler(shoppingCart, nil)
        } else if shoppingCartError != nil {
            completionHandler(nil, shoppingCartError)
        } else {
            completionHandler(ECSPILShoppingCart(), shoppingCartError)
        }
    }
    
    override func createECSShoppingCart(ctn: String, quantity: Int = 1, completionHandler: @escaping ECSPILShoppingCartCompletion) {
        guard shouldSendCreateCartOauthError == false else {
            shouldSendCreateCartOauthError = false
            completionHandler(nil, NSError(domain: "", code: 6025, userInfo: nil))
            return
        }
        if createShoppingCart != nil {
            completionHandler(createShoppingCart, nil)
        } else if createShoppingCartError != nil {
            completionHandler(nil, createShoppingCartError)
        } else {
            completionHandler(ECSPILShoppingCart(), createShoppingCartError)
        }
    }
    
    override func addECSProductToShoppingCart(ctn: String, quantity: Int = 1, completionHandler: @escaping ECSPILShoppingCartCompletion) {
        guard shouldSendOauthError == false else {
            shouldSendOauthError = false
            completionHandler(nil, NSError(domain: "", code: 6025, userInfo: nil))
            return
        }
        if shoppingCart != nil {
            completionHandler(shoppingCart, nil)
        } else if shoppingCartError != nil {
            completionHandler(nil, shoppingCartError)
        } else {
            completionHandler(ECSPILShoppingCart(), shoppingCartError)
        }
    }
    
    override func applyVoucher(voucherID: String, completionHandler: @escaping ECSVoucherListCompletion) {
        guard shouldSendOauthError == false else {
            shouldSendOauthError = false
            completionHandler(nil, NSError(domain: "", code: 5009, userInfo: nil))
            return
        }
        
        if voucherList != nil {
            completionHandler(voucherList, nil)
        } else if voucherError != nil {
            completionHandler(nil, voucherError)
        } else {
            completionHandler([], voucherError)
        }
    }
    
    override func removeVoucher(voucherID: String, completionHandler: @escaping ECSVoucherListCompletion) {
        guard shouldSendOauthError == false else {
            shouldSendOauthError = false
            completionHandler(nil, NSError(domain: "", code: 5009, userInfo: nil))
            return
        }
        
        if voucherList != nil {
            completionHandler(voucherList, nil)
        } else if voucherError != nil {
            completionHandler(nil, voucherError)
        } else {
            completionHandler([], voucherError)
        }
    }
    
    override func createAddress(address: ECSAddress, completionHandler: @escaping ECSAddressCompletion) {
        guard shouldSendOauthError == false else {
            shouldSendOauthError = false
            completionHandler(nil, NSError(domain: "", code: 5009, userInfo: nil))
            return
        }
        
        if saveAddress != nil {
            completionHandler(saveAddress, nil)
        } else if saveAddressError != nil {
            completionHandler(nil, saveAddressError)
        } else {
            completionHandler(ECSAddress(), saveAddressError)
        }
    }
    
    override func createAddressWith(address: ECSAddress, completionHandler: @escaping ECSAddressListCompletion) {
        
        guard shouldSendOauthError == false else {
            shouldSendOauthError = false
            completionHandler(nil, NSError(domain: "", code: 5009, userInfo: nil))
            return
        }
        
        if savedAddresses != nil {
            completionHandler(savedAddresses, nil)
        } else if savedAddressesError != nil {
            completionHandler(nil, savedAddressesError)
        } else {
            completionHandler([ECSAddress()], savedAddressesError)
        }
    }
    
    override func fetchSavedAddresses(completionHandler: @escaping ECSAddressListCompletion) {
        guard shouldSendOauthError == false else {
            shouldSendOauthError = false
            completionHandler(nil, NSError(domain: "", code: 5009, userInfo: nil))
            return
        }
        
        if savedAddresses != nil {
            completionHandler(savedAddresses, nil)
        } else if savedAddressesError != nil {
            completionHandler(nil, savedAddressesError)
        } else {
            completionHandler([ECSAddress()], savedAddressesError)
        }
    }
    
    override func setDeliveryAddress(deliveryAddress: ECSAddress, isDefaultAddress: Bool = true, completionHandler: @escaping ECSCompletion) {
        guard shouldSendOauthErrorForSetDeliveryAddressWithBoolReturn == false else {
            shouldSendOauthErrorForSetDeliveryAddressWithBoolReturn = false
            completionHandler(false, NSError(domain: "", code: 5009, userInfo: nil))
            return
        }
        
        completionHandler(setDeliveryAddressStatus, setDeliveryAddressError)
    }
    
    override func setDeliveryAddress(address: ECSAddress, isDefaultAddress: Bool = true, completionHandler: @escaping ECSAddressListCompletion) {
        guard shouldSendOauthError == false else {
            shouldSendOauthError = false
            completionHandler(nil, NSError(domain: "", code: 5009, userInfo: nil))
            return
        }
        
        if savedAddresses != nil {
            completionHandler(savedAddresses, nil)
        } else if setDeliveryAddressError != nil {
            completionHandler(nil, setDeliveryAddressError)
        } else {
            completionHandler([ECSAddress()], setDeliveryAddressError)
        }
    }
    
    override func updateAddressWith(address: ECSAddress, completionHandler: @escaping ECSAddressListCompletion) {
        guard shouldSendOauthError == false else {
            shouldSendOauthError = false
            completionHandler(nil, NSError(domain: "", code: 5009, userInfo: nil))
            return
        }
        
        if savedAddresses != nil {
            completionHandler(savedAddresses, nil)
        } else if saveAddressError != nil {
            completionHandler(nil, saveAddressError)
        } else {
            completionHandler([ECSAddress()], saveAddressError)
        }
    }
    
    override func deleteAddress(address: ECSAddress, completionHandler: @escaping ECSAddressListCompletion) {
        guard shouldSendOauthError == false else {
            shouldSendOauthError = false
            completionHandler(nil, NSError(domain: "", code: 5009, userInfo: nil))
            return
        }
        
        if savedAddresses != nil {
            completionHandler(savedAddresses, nil)
        } else if deleteAddressError != nil {
            completionHandler(nil, deleteAddressError)
        } else {
            completionHandler([ECSAddress()], deleteAddressError)
        }
    }
    
    override func fetchRegionsFor(countryISO: String, completionHandler: @escaping ECSRegionsCompletion) {
        if regions != nil {
            completionHandler(regions, nil)
        } else if regionError != nil {
            completionHandler(nil, regionError)
        } else {
            completionHandler([ECSRegion()], regionError)
        }
    }
    
    override func fetchUserProfile(completionHandler: @escaping ECSUserDetailsCompletion) {
        guard shouldSendOauthError == false else {
            shouldSendOauthError = false
            completionHandler(nil, NSError(domain: "", code: 5009, userInfo: nil))
            return
        }
        
        if userProfile != nil {
            completionHandler(userProfile, nil)
        } else if userProfileError != nil {
            completionHandler(nil, userProfileError)
        } else {
            completionHandler(ECSUserProfile(), userProfileError)
        }
    }
    
    override func fetchDeliveryModes(completionHandler: @escaping ECSDeliveryModesCompletion) {
        guard shouldSendOauthError == false else {
            shouldSendOauthError = false
            completionHandler(nil, NSError(domain: "", code: 5009, userInfo: nil))
            return
        }
        
        if deliveryModes != nil {
            completionHandler(deliveryModes, nil)
        } else if deliveryModeFetchError != nil {
            completionHandler(nil, deliveryModeFetchError)
        } else {
            completionHandler([ECSDeliveryMode()], deliveryModeFetchError)
        }
    }
    
    override func setDeliveryMode(deliveryMode: ECSDeliveryMode, completionHandler: @escaping ECSCompletion) {
        guard shouldSendOauthError == false else {
            shouldSendOauthError = false
            completionHandler(false, NSError(domain: "", code: 5009, userInfo: nil))
            return
        }
        
        completionHandler(setDeliveryModeStatus, setDeliveryModeError)
    }
    
    override func fetchPaymentDetails(completionHandler: @escaping ECSFetchPaymentCompletion) {
        guard shouldSendOauthError == false else {
            shouldSendOauthError = false
            completionHandler(nil, NSError(domain: "", code: 5009, userInfo: nil))
            return
        }
        
        if savedPayments != nil {
            completionHandler(savedPayments, nil)
        } else if error != nil {
            completionHandler(nil, error)
        } else {
            completionHandler([ECSPayment()], error)
        }
    }
    
    override func setPaymentDetail(paymentDetail: ECSPayment, completionHandler: @escaping ECSCompletion) {
        guard shouldSendOauthError == false else {
            shouldSendOauthError = false
            completionHandler(false, NSError(domain: "", code: 5009, userInfo: nil))
            return
        }
        
        completionHandler(setPaymentStatus, setPaymentError)
    }
    
    override func submitOrder(cvvCode: String? = nil, completionHandler: @escaping ECSubmitOrderCompletion) {
        guard shouldSendOauthError == false else {
            shouldSendOauthError = false
            completionHandler(nil, NSError(domain: "", code: 5009, userInfo: nil))
            return
        }
        
        if submitOrderDetail != nil {
            completionHandler(submitOrderDetail, nil)
        } else if submitOrderError != nil {
            completionHandler(nil, submitOrderError)
        } else {
            completionHandler(ECSOrderDetail(), submitOrderError)
        }
    }
    
    override func makePaymentFor(order: ECSOrderDetail, billingAddress: ECSAddress, completionHandler: @escaping ECSMakePaymentCompletion) {
        guard shouldSendOauthError == false else {
            shouldSendOauthError = false
            completionHandler(nil, NSError(domain: "", code: 5009, userInfo: nil))
            return
        }
        
        completionHandler(paymentProvider, error)
    }
    
    override func fetchOrderHistory(pageSize: Int = 20, currentPage: Int = 0, completionHandler: @escaping ECSFetchOrderHistoryCompletion) {
        guard shouldSendOauthError == false else {
            shouldSendOauthError = false
            completionHandler(nil, NSError(domain: "", code: 5009, userInfo: nil))
            return
        }
        if orderHistory != nil {
            completionHandler(orderHistory, nil)
        } else if orderHistoryError != nil {
            completionHandler(nil, orderHistoryError)
        } else {
            completionHandler(ECSOrderHistory(), orderHistoryError)
        }
    }
    
    override func fetchOrderDetailsFor(order: ECSOrder, completionHandler: @escaping ECSFetchOrderDetailsCompletion) {
        guard shouldSendOauthError == false else {
            shouldSendOauthError = false
            completionHandler(nil, NSError(domain: "", code: 5009, userInfo: nil))
            return
        }
        if let orderDetail = orderDetails?[order.orderID ?? ""] {
            order.orderDetails = orderDetail
            completionHandler(order, nil)
        } else if let orderDetailError = orderDetailError?[order.orderID ?? ""] {
            completionHandler(nil, orderDetailError)
        } else {
            completionHandler(ECSOrder(), NSError())
        }
    }
    
    override func registerForProductAvailability(email: String, ctn: String, completionHandler: @escaping ECSCompletion) {
        completionHandler(notifyMeSuccess, notifyMeError)
    }
}
