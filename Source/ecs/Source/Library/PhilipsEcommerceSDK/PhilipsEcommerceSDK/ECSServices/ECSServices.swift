/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra
import PhilipsPRXClient

public typealias ECSCompletion = (_ result: Bool, _ error: Error?) -> Void
public typealias ECSGetConfigCompletion = (_ configuration: ECSConfig?, _ error: Error?) -> Void
public typealias ECSHybrisOAuthCompletion = (_ hybrisOAuthData: ECSOAuthData?, _ error: Error?) -> Void
public typealias ECSVoucherListCompletion = (_ voucherList: [ECSVoucher]?, _ error: Error?) -> Void
public typealias ECSAddressListCompletion = (_ addressList: [ECSAddress]?, _ error: Error?) -> Void
public typealias ECSAddressCompletion = (_ address: ECSAddress?, _ error: Error?) -> Void
public typealias ECSDeliveryModesCompletion = (_ deliveryModes: [ECSDeliveryMode]?, _ error: Error?) -> Void
public typealias ECSRegionsCompletion = (_ regions: [ECSRegion]?, _ error: Error?) -> Void
public typealias ECSFetchPaymentCompletion = (_ paymentList: [ECSPayment]?, _ error: Error?) -> Void
public typealias ECSRetailerListCompletion = (_ retailerList: ECSRetailerList?, _ error: Error?) -> Void
public typealias ECSUserDetailsCompletion = (_ userDetails: ECSUserProfile?, _ error: Error?) -> Void
public typealias ECSubmitOrderCompletion = (_ orderDetails: ECSOrderDetail?, _ error: Error?) -> Void
public typealias ECSFetchOrderHistoryCompletion = (_ orderHistory: ECSOrderHistory?, _ error: Error?) -> Void
public typealias ECSMakePaymentCompletion = (_ paymentProvider: ECSPaymentProvider?, _ error: Error?) -> Void
public typealias ECSFetchOrderDetailsCompletion = (_ orderDetails: ECSOrder?, _ error: Error?) -> Void
public typealias ECSFetchOrderCompletion = (_ orderDetails: ECSOrderDetail?, _ error: Error?) -> Void

// MARK: - PIL Microservices Completion Blocks
public typealias ECSPILProductsFetchCompletion = (_ products: ECSPILProducts?, _ error: Error?) -> Void
public typealias ECSPILProductDetailsFetchCompletion = (_ productDetails: ECSPILProduct, _ error: Error?) -> Void
public typealias ECSPILProductFetchCompletion = (_ productDetails: ECSPILProduct?, _ error: Error?) -> Void
public typealias ECSPILProductSummaryFetchCompletion = (_ products: [ECSPILProduct]?,
    _ invalidCTNs: [String]?,
    _ error: Error?) -> Void
public typealias ECSPILShoppingCartCompletion = (_ shoppingCart: ECSPILShoppingCart?, _ error: Error?) -> Void

// swiftlint:disable type_body_length
// swiftlint:disable file_length
open class ECSServices: NSObject {

    // swiftlint:disable inert_defer

    /**
     This method is used to initialize the ECSService.
     - Parameters:
     - propositionId: It is a unique store identification string, which is specific to business and country
     - appInfra: appInfra object created by proposition
     - Since: 1905.0.0
     */
    //This API should be removed once MEC Consumes the new ECS PIL APIs
    public init(propositionId: String?, appInfra: AIAppInfra) {
        super.init()
        defer {
            self.appInfra      = appInfra
            self.propositionId = propositionId
            ECSConfiguration.shared.configureAPIKey()
        }
    }

    public init(appInfra: AIAppInfra) {
        super.init()
        defer {
            self.appInfra = appInfra
            ECSConfiguration.shared.configurePropositionID()
            ECSConfiguration.shared.configureAPIKey()
        }
    }
    // swiftlint:enable inert_defer

    /// This variable is used to set the proposition id.
    /// - Since: 1905.0.0
    //This API should be removed once MEC Consumes the new ECS PIL APIs
    open var propositionId: String? {
        didSet {
            ECSConfiguration.shared.propositionId = propositionId
        }
    }

    var appInfra: AIAppInfra? {
        didSet {
            ECSConfiguration.shared.appInfra = appInfra
            ECSConfiguration.shared.initialiseECSLogger()
        }
    }

    // MARK: - ECS Configuration Microservices

    /**
    This API is used to configure the ECS
    
    This has to be called after ECS SDK is initialized or whenever proposition id or country is changed.
    This API initializes base URL and locale for the SDK and fetches configuration from Hybris.
    - Parameters:
    - completionHandler: ECSGetConfigCompletion which contains ECSConfig indicating success
    and Error explaining any failures.
    - Since: 1905.0.0
    */
    open func configureECSWithConfiguration(completionHandler: @escaping ECSGetConfigCompletion) {
        let micro = ECSFetchConfigMicroService()
        micro.configureECSWithConfiguration(completionHandler: completionHandler)
    }

    // MARK: - OAuth Microservices

    /**
     This API is used to make the OAuth authentication with Hybris.
     
     User needs to send the object of class  ECSOAuthProvider which contains all the authentication related data as a
     parameter to the method.
     
     - Parameters:
     - hybrisOAuthData: ECSOAuthProvider instance which provides information needed for OAuth
     - completionHandler: ECSHybrisOAuthCompletion which contains ECSOAuthData
     indicating success and Error explaining any failures
     - Since: 1905.0.0
     */
    open func hybrisOAuthAuthenticationWith(hybrisOAuthData: ECSOAuthProvider,
                                            completionHandler: @escaping ECSHybrisOAuthCompletion) {
        let micro = ECSHybrisAuthenticationMicroService()
        micro.authenticateWithHybrisWith(hybrisOAuthData: hybrisOAuthData, completionHandler: completionHandler)
    }

    /**
     This API is used to refresh the OAuth authentication with Hybris.
     
     User needs to send the object of class ECSOAuthProvider which contains all the authentication related data as a
     parameter to the API.
     
     - Parameters:
     - hybrisOAuthData: ECSOAuthProvider instance which provides information needed for OAuth
     - completionHandler: ECSHybrisOAuthCompletion which contains ECSOAuthData
                    indicating success and Error explaining any failures
     
     - Since: 1905.0.0
     */
    open func hybrisRefreshOAuthWith(hybrisOAuthData: ECSOAuthProvider,
                                     completionHandler: @escaping ECSHybrisOAuthCompletion) {
        let micro = ECSHybrisAuthenticationMicroService()
        micro.refreshHybrisLoginWith(hybrisOAuthData: hybrisOAuthData, completionHandler: completionHandler)
    }

    // MARK: - Voucher Microservices
    /**
     This API is used to fetch the list of all the applied vouchers.
     
     User has to be logged in before calling this API.
     - Parameters:
     - completionHandler: ECSVoucherListCompletion includes list of applied vouchers indicating success and Error
     in case of failure
     - Since: 1905.0.0
     */
    open func fetchAppliedVouchers(completionHandler: @escaping ECSVoucherListCompletion) {
        let micro = ECSFetchVoucherListMicroServices()
        micro.fetchVoucherList(completionHandler: completionHandler)
    }

    /**
     This API is used to apply promotional voucher for the shopping cart.
     
     User has to be logged in before calling this API.
     - Parameters:
     - voucherID: promotional voucher code which has to be applied to cart
     - completionHandler: ECSVoucherListCompletion includes list of applied vouchers indicating success and Error
     in case of failure
     - Since: 1905.0.0
     */
    open func applyVoucher(voucherID: String,
                           completionHandler: @escaping ECSVoucherListCompletion) {
        let micro = ECSApplyVoucherMicroServices()
        micro.applyVoucher(voucherID: voucherID,
                           completionHandler: completionHandler)
    }

    /**
     This API is used to remove the applied voucher.
     
     User has to be logged in before calling this API.
     - Parameters:
     - voucherID: promotional voucher code which has to be removed from the cart
     - completionHandler: ECSVoucherListCompletion includes list of applied
                    vouchers indicating success and Error in case of failure
     - Since: 1905.0.0
     */
    open func removeVoucher(voucherID: String,
                            completionHandler: @escaping ECSVoucherListCompletion) {
        let micro = ECSRemoveVoucherMicroServices()
        micro.removeVoucher(voucherId: voucherID,
                            completionHandler: completionHandler)
    }

    // MARK: - Delivery Modes Microservices

    /**
     This API is used to fetch the list of delivery modes.
     
     User has to be logged in before calling this API.
     - Parameters:
     - completionHandler: ECSDeliveryModesCompletion includes list of delivery modes supported for the location indicating
     success and Error in case of failure
     - Since: 1905.0.0
     */
    open func fetchDeliveryModes(completionHandler: @escaping ECSDeliveryModesCompletion) {
        let micro = ECSFetchDeliveryModesMicroService()
        micro.fetchDeliveryModes(completionHandler: completionHandler)
    }

    /**
     This API is used to set delivery mode for cart.
     
     User has to be logged in before calling this API.
     - Parameters:
     - deliveryMode: ECSDeliveryMode object to be set as delivery mode
     - completionHandler: ECSCompletion which contains TRUE if successfully set the delivery mode, otherwise FALSE and
     an Error explaining any failures
     - Since: 1905.0.0
     */
    open func setDeliveryMode(deliveryMode: ECSDeliveryMode,
                              completionHandler: @escaping ECSCompletion) {
        let micro = ECSSetDeliveryModeMicroService()
        micro.setDeliveryMode(deliveryMode: deliveryMode,
                              completionHandler: completionHandler)
    }

    // MARK: - Address Microservices

    /**
     This API is used to fetch the list of regions for specific country.
     
     - Parameters:
     - countryISO: ISO code of the country for which the regions has to be fetched
     - completionHandler: ECSRegionsCompletion includes list of ECSRegion objects
                    indicating success and Error in case of failure
     - Since: 1905.0.0
     */
    open func fetchRegionsFor(countryISO: String, completionHandler: @escaping ECSRegionsCompletion) {
        let micro = ECSFetchRegionMicroServices()
        micro.fetchRegions(for: countryISO,
                           completionHandler: completionHandler)
    }

    /**
     This API is used to fetch the list of all saved addresses for the user.
     
     User has to be logged in before calling this API.
     - Parameters:
     - completionHandler: ECSAddressListCompletion include list of ECSCallback instance representing saved address
     of user indicating success and Error in case of failure
     - Since: 1905.0.0
     */
    open func fetchSavedAddresses(completionHandler: @escaping ECSAddressListCompletion) {
        let micro = ECSFetchAddressMicroServices()
        micro.fetchSavedAddressList(completionHandler: completionHandler)
    }

    /**
     This API is used to create new address for the user.
     
     User has to be logged in before calling this API.
     - Parameters:
     - address: ECSAddress instance contains new address details which has to be created
     - completionHandler: ECSAddressListCompletion include list of ECSCallback instance representing saved address of user
     indicating success and Error in case of failure
     - Since: 1905.0.0
     */
    open func createAddressWith(address: ECSAddress, completionHandler:@escaping ECSAddressListCompletion) {
        let micro = ECSAddNewAddressMicroService()
        micro.createNewAddress(with: address,
                               completionHandler: completionHandler)
    }

    /**
     This API is used to create new address for the user.
     
     User has to be logged in before calling this API.
     - Parameters:
     - address: ECSAddress instance contains new address details which has to be created
     - completionHandler: ECSAddressCompletion includes an instance of ECSAddress which has been created indicating
     success and Error in case of failure
     - Since: 1905.0.0
     */
    open func createAddress(address: ECSAddress, completionHandler:@escaping ECSAddressCompletion) {
        let micro = ECSAddNewAddressMicroService()
        micro.createNewAddress(address: address,
                               completionHandler: completionHandler)
    }

    /**
     This API is used to update the address of the user.
     
     User has to be logged in before calling this API.
     - Parameters:
     - address: an instance of ECSAddress which has to be set as delivery address
     - completionHandler: ECSCompletion which contains TRUE if the address is updated successfully, otherwise FALSE and an
     Error explaining any failures
     - Since: 1905.0.0
     */
    open func updateAddress(address: ECSAddress, completionHandler:@escaping ECSCompletion) {
        let micro = ECSEditAddressMicroService()
        micro.editSavedAddress(address: address,
                               completionHandler: completionHandler)
    }

    /**
     This API is used to update the address of the user and fetch the list of addresses.
     
     User has to be logged in before calling this API.
     - Parameters:
     - address: an instance of ECSAddress which has to be set as delivery address
     - completionHandler: ECSAddressListCompletion include list of ECSCallback instance representing saved address of user
     indicating success and Error in case of failure
     - Since: 1905.0.0
     */
    open func updateAddressWith(address: ECSAddress, completionHandler:@escaping ECSAddressListCompletion) {
        let micro = ECSEditAddressMicroService()
        micro.editSavedAddress(with: address,
                               completionHandler: completionHandler)
    }

    /**
     This API is used to set the delivery address of the user.
     
     User has to be logged in before calling this API.
     - Parameters:
     - address: an instance of ECSAddress which has to be set as delivery address
     - isDefaultAddress: Boolean which tells whether the address has be to made default address
     - completionHandler: ECSAddressListCompletion include list of ECSCallback instance representing saved address of user
     indicating success and Error in case of failure
     - Since: 1905.0.0
     */
    open func setDeliveryAddress(address: ECSAddress,
                                 isDefaultAddress: Bool = true,
                                 completionHandler: @escaping ECSAddressListCompletion) {
        let micro = ECSSetDeliveryAddressMicroService()
        micro.setDeliveryAddress(address: address,
                                 isDefaultAddress: isDefaultAddress,
                                 completionHandler: completionHandler)
    }

    /**
     This API is used to set the delivery address of the user.
     
     User has to be logged in before calling this API.
     - Parameters:
     - deliveryAddress: an instance of ECSAddress which has to be set as delivery address
     - isDefaultAddress: Boolean which tells whether the address has be to made default address
     - completionHandler: ECSCompletion which contains TRUE if successfully set the delivery mode, otherwise FALSE and an
     Error explaining any failures
     - Since: 1905.0.0
     */
    open func setDeliveryAddress(deliveryAddress: ECSAddress,
                                 isDefaultAddress: Bool = true,
                                 completionHandler: @escaping ECSCompletion) {
        let micro = ECSSetDeliveryAddressMicroService()
        micro.setDeliveryAddress(deliveryAddress: deliveryAddress,
                                 isDefaultAddress: isDefaultAddress,
                                 completionHandler: completionHandler)
    }

    /**
     This API is used to delete the address of the user.
     
     User has to be logged in before calling this API.
     - Parameters:
     - savedAddress: an instance of ECSAddress which has to be deleted
     - completionHandler: ECSCompletion which contains TRUE if the address is deleted successfully, otherwise FALSE and
     an Error explaining any failures
     - Since: 1905.0.0
     */
    open func deleteAddress(savedAddress: ECSAddress,
                            completionHandler: @escaping ECSCompletion) {
        let micro = ECSDeleteAddressMicroService()
        micro.deleteAddress(savedAddress: savedAddress,
                            completionHandler: completionHandler)
    }

    /**
     This API is used to delete the address of the user and fetch the list of saved addresses.
     
     User has to be logged in before calling this API.
     - Parameters:
     - address: an instance of ECSAddress which has to be deleted
     - completionHandler: ECSAddressListCompletion include list of ECSCallback instance representing saved address of user
     indicating success and Error in case of failure
     - Since: 1905.0.0
     */
    open func deleteAddress(address: ECSAddress,
                            completionHandler: @escaping ECSAddressListCompletion) {
        let micro = ECSDeleteAddressMicroService()
        micro.deleteAddress(address: address,
                            completionHandler: completionHandler)
    }

    // MARK: - Payment Microservices

    /**
     This API is used to fetch list of existing payment methods.
     
     User has to be logged in before calling this API.
     - Parameter completionHandler: ECSFetchPaymentCompletion includes list of ECSPayment instances which represent saved
     payments indicating success and Error in case of failure
     - Since: 1905.0.0
     */
    open func fetchPaymentDetails(completionHandler: @escaping ECSFetchPaymentCompletion) {
        let micro = ECSFetchPaymentMicroService()
        micro.fetchPaymentDetails(completionHandler: completionHandler)
    }

    /**
     This API is used to set payment details for the purchase.
     
     User has to be logged in before calling this API.
     - Parameters:
     - paymentDetail: ECSPayment instance which has to be set as payment method for the order
     - completionHandler: ECSCompletion which contains TRUE if the payment details is set successfully, otherwise FALSE
     and an Error explaining any failures
     - Since: 1905.0.0
     */
    open func setPaymentDetail(paymentDetail: ECSPayment,
                               completionHandler: @escaping ECSCompletion) {
        let micro = ECSSetPaymentMethodMicroService()
        micro.setPaymentDetail(paymentDetail: paymentDetail,
                               completionHandler: completionHandler)
    }

    /**
     This API is used to make the payment after entering all the payment details.
     
     User has to be logged in before calling this API.
     - Parameters:
     - order: ECSOrderDetail instance which is the placed order for which the payment has to be made
     - billingAddress: ECSAddress instance which contains billing address for the order
     - completionHandler: ECSMakePaymentCompletion includes ECSPaymentProvider instance indicating success and Error in
     case of failure
     - Since: 1905.0.0
     */
    open func makePaymentFor(order: ECSOrderDetail,
                             billingAddress: ECSAddress,
                             completionHandler: @escaping ECSMakePaymentCompletion) {
        let micro = ECSMakePaymentMicroService()
        micro.makePayment(for: order,
                          billingAddress: billingAddress,
                          completionHandler: completionHandler)
    }

    // MARK: - Retailers Microservices

    /**
     This API is used to fetch the list of available retailers for the selected product.
     - Parameters:
     - productCtn: CTN of the product for which the retailer list has to be fetched
     - completionHandler: ECSRetailerListCompletion includes instance of ECSRetailerList which has list of retailers and
     Error in case of any failure
     - Since: 1905.0.0
     */
    open func fetchRetailerDetailsFor(productCtn: String,
                                      completionHandler: @escaping ECSRetailerListCompletion) {
        let micro = ECSFetchRetailersMicroService()
        micro.fetchRetailerDetailsFor(productCtn: productCtn,
                                      completionHandler: completionHandler)
    }

    // MARK: - User Details Microservices

    /**
     This API is used to fetch the user details.
     
     User has to be logged in before calling this API.
     - Parameter completionHandler: ECSUserDetailsCompletion  includes ECSUserProfile instance indicating success and Error
     in case of failure
     - Since: 1905.0.0
     */
    open func fetchUserProfile(completionHandler: @escaping ECSUserDetailsCompletion) {
        let micro = ECSFetchUserDetailsMicroService()
        micro.fetchUserDetails(completionHandler: completionHandler)
    }

    // MARK: - Order Microservices

    /**
     This API is used to place the order.
     If the saved payment is selected then you need to send the CVV of the saved payment.
     
     User has to be logged in before calling this API.
     - Parameters:
     - cvvCode: CVV of the saved card. This is optional should only be sent if the saved payment is selected else this
     should be nil
     - completionHandler: ECSubmitOrderCompletion includes instance of ECSOrderDetail which has complete details of
     placed order indicating success and Error in case of failure
     - Since: 1905.0.0
     */
    open func submitOrder(cvvCode: String? = nil,
                          completionHandler: @escaping ECSubmitOrderCompletion) {
        let micro = ECSSubmitOrderMicroServices()
        micro.submitOrder(cvvCode: cvvCode, completionHandler: completionHandler)
    }

    /**
     This API is used to fetch the order history of the submitted orders.
     
     User has to be logged in before calling this API.
     - Parameters:
     - pageSize: total number of order histories per page
     - currentPage: page number for which the order history has to be fetched
     - completionHandler: ECSFetchOrderHistoryCompletion contains list of ECSOrderHistory indicating success and
     Error explaining any failures.
     - Since: 1905.0.0
     */
    open func fetchOrderHistory(pageSize: Int = 20,
                                currentPage: Int = 0,
                                completionHandler: @escaping ECSFetchOrderHistoryCompletion) {
        let micro = ECSFetchOrderHistoryMicroService()
        micro.fetchOrderHistory(pageSize: pageSize,
                                currentPage: currentPage,
                                completionHandler: completionHandler)
    }

    /**
     This API is used to fetch the details of given orders.
     
     User has to be logged in before calling this API.
     - Parameters:
     - order: ECSOrder instance for which the details has to be fetched
     - completionHandler: ECSFetchOrderCompletion includes an instance of ECSOrderDetail which has complete detail of the
     order indicating success and Error in case of failure
     - Since: 1905.0.0
     */
    open func fetchOrderDetailsFor(order: ECSOrder,
                                   completionHandler: @escaping ECSFetchOrderDetailsCompletion) {
        let micro = ECSFetchOrderHistoryDetailsMicroService()
        micro.fetchOrderDetailFor(order: order,
                                  completionHandler: completionHandler)
    }

    /**
     This API is used to fetch the details of given orders.
     
     User has to be logged in before calling this API.
     - Parameters:
     - orderID: order id of the order for which the details has be fetched
     - completionHandler: ECSFetchOrderCompletion includes an instance of ECSOrderDetail which has complete detail of
     the order indicating success and Error in case of failure
     - Since: 1905.0.0
     */
    open func fetchOrderDetailsFor(orderID: String,
                                   completionHandler: @escaping ECSFetchOrderCompletion) {
        let micro = ECSFetchOrderHistoryDetailsMicroService()
        micro.fetchOrderDetailFor(orderID: orderID,
                                  completionHandler: completionHandler)
    }

    /**
     This API is used to fetch the details of given orders.
     
     User has to be logged in before calling this API.
     - Parameters:
     - orderDetail: ECSOrderDetail instance for which the complete details has to fetched
     - completionHandler: ECSFetchOrderCompletion includes an instance of ECSOrderDetail which has complete detail of the
     order indicating success and Error in case of failure
     - Since: 1905.0.0
     */
    open func fetchOrderDetailsFor(orderDetail: ECSOrderDetail,
                                   completionHandler: @escaping ECSFetchOrderCompletion) {
        let micro = ECSFetchOrderHistoryDetailsMicroService()
        micro.fetchOrderDetailFor(orderDetail: orderDetail,
                                  completionHandler: completionHandler)
    }

    // MARK: - PIL Microservices

    /**
        This API is used to fetch the list of products from Hybris which includes summary data fetched from PRX.
        
        This API can be called even if the user is not logged in.
        
        - Parameters:
        - category: products fetched from category as configured in Hybris and if not configured, it would display products
                    for entire site id.
        - limit: number of products to be fetched for the request
        - offset: starting position of the product list
        - filterParameter: an object of class ECSPILProductFilter, which represent the filters which has to be applied.
        - completionHandler: ECSPILProductsFetchCompletion contains list of ECSPILProducts
                             indicating success and Error explaining any failures
        - Since: 2003.0.0
        */
    open func fetchECSProducts(category: String? = nil,
                               limit: Int = 20,
                               offset: Int = 0,
                               filterParameter: ECSPILProductFilter? = nil,
                               completionHandler: @escaping ECSPILProductsFetchCompletion) {

        let micro = ECSProductMicroServices()
        micro.fetchECSAllProducts(category: category,
                                  limit: limit,
                                  offset: offset,
                                  filterParameter: filterParameter,
                                  completionHandler: completionHandler)
    }

    /**
    This API is used to fetch the product for specific CTN from Hybris which includes summary data fetched from PRX.
    
    This API can be called even if the user is not logged in.
    
    - Parameters:
    - ctn: CTN of the product
    - completionHandler: ECSPILProductFetchCompletion which contains ECSPILProduct
                   indicating success and Exception explaining any failures.
    - Since: 2003.0.0
    */
    open func fetchECSProductFor(ctn: String,
                                 completionHandler: @escaping ECSPILProductFetchCompletion) {
        let micro = ECSProductMicroServices()
        micro.fetchECSProductFor(ctn: ctn, completionHandler: completionHandler)
    }

    /**
    This API is used to fetch list of products specific to list of CTNs from
    Hybris which includes summary data fetched from PRX.
    
    This API can be called even if the user is not logged in.
    
    - Parameters:
    - ctns: array of CTNs
    - completionHandler: ECSPILProductSummaryFetchCompletion contains list of ECSPILProduct indicating success and
    invalid CTN list and Error in case of failure
    - Since: 2003.0.0
    */
    open func fetchECSProductSummariesFor(ctns: [String],
                                          completionHandler: @escaping ECSPILProductSummaryFetchCompletion) {
        let micro = ECSProductDetailsMicroServices()
        micro.fetchProductSummaryFor(ctns: ctns) { (summaryDetails, error) in
            var products = [ECSPILProduct]()
            summaryDetails?.data.forEach({ (details) in
                let product = ECSPILProduct()
                if let details = details as? PRXSummaryData {
                    product.productPRXSummary = details
                    product.ctn = details.ctn
                    products.append(product)
                }
            })
            completionHandler(products.count == 0 ? nil : products, summaryDetails?.invalidCTNs as? [String], error)
        }
    }

    /**
    This API is used to fetch product details containing assets and disclaimer for the specific product from PRX.
    
    - Parameters:
    - product: an instance of ECSPILProduct for which detail needs to be fetched
    - completionHandler: ECSPILProductDetailsFetchCompletion which includes ECSPILProduct containing details indicating
    success and Exception in case of failure
    - Since: 2003.0.0
    */
    open func fetchECSProductDetailsFor(product: ECSPILProduct,
                                        completionHandler: @escaping ECSPILProductDetailsFetchCompletion) {
        let micro = ECSProductDetailsMicroServices()
        micro.fetchECSProductDetailsFor(product: product, completionHandler: completionHandler)
    }

    // MARK: - Shopping Cart Microservices

    /**
     This API is used to create the shopping cart for the user. User needs to be logged in to call this API.
     
     User has to be logged in before calling this API.
     - Parameters:
     - ctn: ctn of the product which needs to be added to the shopping cart.
     - completionHandler: ECSPILShoppingCartCompletion which includes ECSPILShoppingCart indicating success and Exception in
     case of failure
     - Since: 2004.0.0
     */
    open func createECSShoppingCart(ctn: String,
                                    quantity: Int = 1,
                                    completionHandler: @escaping ECSPILShoppingCartCompletion) {
        let micro = ECSCreateShoppingCartMicroServices()
        micro.createECSShoppingCart(ctn: ctn, quantity: quantity, completionHandler: completionHandler)
    }

    /**
    This API is used to get the shopping cart details for the user.
    
    User has to be logged in before calling this API.
    - Parameters:
    - completionHandler: ECSPILShoppingCartCompletion includes ECSPILShoppingCart indicating success and Error in case of
                        failure
    - Since: 2004.0.0
    */
    open func fetchECSShoppingCart(completionHandler: @escaping ECSPILShoppingCartCompletion) {
        let micro = ECSFetchShoppingCartMicroServices()
        micro.fetchECSShoppingCart(completionHandler: completionHandler)
    }

    /**
    This API is used add product to the shopping cart.
    
    User has to be logged in before calling this API.
    - Parameters:
    - ctn: ctn of the product which needs to be added to the shopping cart
    - completionHandler: ECSPILShoppingCartCompletion includes ECSPILShoppingCart indicating success and Error in case of
                        failure
    - Since: 2004.0.0
    */
    open func addECSProductToShoppingCart(ctn: String,
                                          quantity: Int = 1,
                                          completionHandler: @escaping ECSPILShoppingCartCompletion) {
        let micro = ECSAddShoppingCartMicroServices()
        micro.addECSProductToShoppingCart(ctn: ctn, quantity: quantity, completionHandler: completionHandler)
    }

    /**
     This API is used to update the quantity of the product which is present in the shopping cart.
     
     User has to be logged in before calling this API. This API can be used to delete the product by passing quantity as 0
     - Parameters:
     - quantity: new quantity of the product to be updated
     - cartItem: cart item to be updated/deleted in shopping cart
     - completionHandler: ECSPILShoppingCartCompletion includes ECSPILShoppingCart indicating success and Error in case of
                          failure
     - Since: 2004.0.0
     */
    open func updateECSShoppingCart(cartItem: ECSPILItem,
                                    quantity: Int,
                                    completionHandler: @escaping ECSPILShoppingCartCompletion) {
        let micro = ECSUpdateShoppingCartMicroServices()
        micro.updateECSShoppingCart(cartItem: cartItem, quantity: quantity, completionHandler: completionHandler)
    }

    /**
    This API is used get the notification whenever the stock is available for the product
    
    - Parameters:
    - email: email address to send the notification
    - ctn: ctn of the product
    - completionHandler: ECSCompletion which contains TRUE if successfully registered, otherwise FALSE and
                         an Error explaining any failures
    - Since: 2004.0.0
    */
    open func registerForProductAvailability(email: String,
                                             ctn: String,
                                             completionHandler: @escaping ECSCompletion) {
        let micro = ECSNotifyProductAvailibilityMicroservices()
        micro.registerForProductAvailability(email: email, ctn: ctn, completionHandler: completionHandler)
    }
}
// swiftlint:enable type_body_length
// swiftlint:enable file_length
