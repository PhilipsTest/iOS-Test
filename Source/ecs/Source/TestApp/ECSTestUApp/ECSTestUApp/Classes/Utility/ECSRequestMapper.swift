/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class ECSRequestMapper: NSObject {
    
    static let sharedInstance: ECSRequestMapper = ECSRequestMapper()
    var requestMap: [ECSMicroServicesIndentifier: ECSTestRequestHandlerProtocol] = [ECSMicroServicesIndentifier: ECSTestRequestHandlerProtocol]()
    
    override init() {
        super.init()
        let oAuthRequestHandler = ECSOAuthRequestHandler()
        let configureRequestHandler = ECSConfigureRequestHandler()
        let voucherRequestHandler = ECSApplyAndRemoveVoucherRequestHandler()
        let createAddressRequestHandler = ECSCreateAddressRequestHandler()
        let updateAddressRequestHandler = ECSUpdateAddressRequestHandler()
        let deleteAddressRequestHandler = ECSDeleteAddressRequestHandler()
        let setDeliveryAddressRequestHandler = ECSSetDeliveryAddressRequestHandler()
        
        requestMap[.configureECSWithConfiguration] = configureRequestHandler
        requestMap[.hybrisOAuthAuthentication] = oAuthRequestHandler
        requestMap[.hybrisRefreshOAuth] = oAuthRequestHandler
        requestMap[.refreshJanrain] = ECSRefreshJanrainRequestHandler()
        requestMap[.fetchRetailerDetailsForCTN] = ECSTestFetchRetailerDetailsForCTNRequestHandler()
        requestMap[.fetchAppliedVouchers] = ECSFetchAppliedVouchersRequestHandler()
        requestMap[.applyVoucher] = voucherRequestHandler
        requestMap[.removeVoucher] = voucherRequestHandler
        requestMap[.fetchDeliveryModes] = ECSFetchDeliveryModesRequestHandler()
        requestMap[.setDeliveryMode] = ECSSetDeliveryModeRequestHandler()
        requestMap[.fetchRegionsForCountryISO] = ECSFetchRegionsForCountryISORequestHandler()
        requestMap[.fetchSavedAddresses] = ECSFetchSavedAddressesRequestHandler()
        requestMap[.createAddressWithSingleAddressReturn] = createAddressRequestHandler
        requestMap[.createAddressWithAddressListReturn] = createAddressRequestHandler
        requestMap[.updateAddressWithSuccessReturn] = updateAddressRequestHandler
        requestMap[.updateAddressWithAddressListReturn] = updateAddressRequestHandler
        requestMap[.deleteAddressWithSuccessReturn] = deleteAddressRequestHandler
        requestMap[.deleteAddressWithAddressListReturn] = deleteAddressRequestHandler
        requestMap[.setDeliveryAddressWithAddressListReturn] = setDeliveryAddressRequestHandler
        requestMap[.setDeliveryAddressWithSuccessReturn] = setDeliveryAddressRequestHandler
        requestMap[.fetchPaymentDetails] = ECSFetchPaymentDetailsRequestHandler()
        requestMap[.setPaymentDetail] = ECSSetPaymentDetailRequestHandler()
        requestMap[.submitOrder] = ECSSubmitOrderRequestHandler()
        requestMap[.makePaymentForOrder] = ECSMakePaymentForOrderRequestHandler()
        requestMap[.fetchOrderHistory] = ECSFetchOrderHistoryRequestHandler()
        requestMap[.fetchOrderDetailsForOrder] = ECSFetchOrderDetailsForOrderRequestHandler()
        requestMap[.fetchOrderDetailsForOrderDetail] = ECSFetchOrderDetailsForOrderDetailRequestHandler()
        requestMap[.fetchOrderDetailsForOrderID] = ECSFetchOrderDetailsForOrderIDRequestHandler()
        requestMap[.fetchUserProfile] = ECSFetchUserProfileRequestHandler()
        
        // MARK: - PIL Microservices
        
        requestMap[.fetchPILProducts] = ECSPILFetchAllProductsRequestHandler()
        requestMap[.fetchPILProductForCTN] = ECSPILFetchProductForCTNRequestHandler()
        requestMap[.fetchPILProductSummariesForCTNs] = ECSPILFetchProductSummariesForCTNsRequestHandler()
        requestMap[.fetchPILProductDetailsForProduct] = ECSPILFetchProductDetailsRequestHandler()
        requestMap[.createPILShoppingCart] = ECSPILCreateShoppingCartRequestHandler()
        requestMap[.fetchPILShoppingCart] = ECSPILFetchShoppingCartRequestHandler()
        requestMap[.addPILProductToCart] = ECSPILAddProductToShoppingCartRequestHandler()
        requestMap[.updatePILShoppingCart] = ECSPILUpdateShoppingCartRequestHandler()
        requestMap[.registerForProductAvailability] = ECSNotifyProductAvailibilityRequestHandler()
    }
}

enum ECSMicroServicesIndentifier: String {
    
    case configureECSWithConfiguration = "configureECSWithConfiguration"
    case hybrisOAuthAuthentication = "hybrisOAuthAuthentication"
    case hybrisRefreshOAuth = "hybrisRefreshOAuth"
    case refreshJanrain = "refreshJanrain"
    case fetchProductSummariesForCTNs = "fetchProductSummariesForCTNs"
    case fetchRetailerDetailsForCTN = "fetchRetailerDetailsForCTN"
    case fetchAppliedVouchers = "fetchAppliedVouchers"
    case applyVoucher = "applyVoucher"
    case removeVoucher = "removeVoucher"
    case fetchDeliveryModes = "fetchDeliveryModes"
    case setDeliveryMode = "setDeliveryMode"
    case fetchRegionsForCountryISO = "fetchRegionsForCountryISO"
    case fetchSavedAddresses = "fetchSavedAddresses"
    case createAddressWithSingleAddressReturn = "createAddressWithSingleAddressReturn"
    case createAddressWithAddressListReturn = "createAddressWithAddressListReturn"
    case updateAddressWithSuccessReturn = "updateAddressWithSuccessReturn"
    case updateAddressWithAddressListReturn = "updateAddressWithAddressListReturn"
    case setDeliveryAddressWithSuccessReturn = "setDeliveryAddressWithSuccessReturn"
    case setDeliveryAddressWithAddressListReturn = "setDeliveryAddressWithAddressListReturn"
    case deleteAddressWithSuccessReturn = "deleteAddressWithSuccessReturn"
    case deleteAddressWithAddressListReturn = "deleteAddressWithAddressListReturn"
    case fetchUserProfile = "fetchUserProfile"
    case fetchPaymentDetails = "fetchPaymentDetails"
    case setPaymentDetail = "setPaymentDetail"
    case submitOrder = "submitOrder"
    case makePaymentForOrder = "makePaymentForOrder"
    case fetchOrderHistory = "fetchOrderHistory"
    case fetchOrderDetailsForOrder = "fetchOrderDetailsForOrder"
    case fetchOrderDetailsForOrderDetail = "fetchOrderDetailsForOrderDetail"
    case fetchOrderDetailsForOrderID = "fetchOrderDetailsForOrderID"
    
    // MARK: - PIL Microservices Variables
    case fetchPILProducts = "fetchPILProducts"
    case fetchPILProductForCTN = "fetchPILProductForCTN"
    case fetchPILProductSummariesForCTNs = "fetchPILProductSummariesForCTNs"
    case fetchPILProductDetailsForProduct = "fetchPILProductDetailsForProduct"
    case createPILShoppingCart = "createPILShoppingCart"
    case fetchPILShoppingCart = "fetchPILShoppingCart"
    case addPILProductToCart = "addPILProductToCart"
    case updatePILShoppingCart = "updatePILShoppingCart"
    case registerForProductAvailability = "registerForProductAvailability"
    
    
    func fetchRequestHandler() -> ECSTestRequestHandlerProtocol? {
        return ECSRequestMapper.sharedInstance.requestMap[self]
    }
}

enum ECSMicroServiceInputIndentifier: Int {
    
    case accessToken = 900
    case clientID = 901
    case clientSecret = 902
    case refreshToken = 903
    case pageSize = 904
    case currentPage = 905
    case productCTN = 906
    case productCTNs = 907
    case selectProductCTN = 908
    case productQuantity = 909
    case entryNumber = 910
    case voucherID = 911
    case selectDeliveryMode = 912
    case countryISO = 913
    case defaultAddress = 915
    case town = 916
    case firstName = 918
    case houseNumber = 920
    case lastName = 921
    case line1 = 922
    case line2 = 923
    case phone = 924
    case phone1 = 925
    case phone2 = 926
    case postalCode = 927
    case titleCode = 929
    case country = 930
    case selectAddress = 931
    case selectPayment = 932
    case cvvCode = 933
    case selectOrder = 934
    case orderID = 935
    case grantType = 936
    
    case sortType = 937
    case stockLevel = 938
    case category = 939
    case email = 940
}
