/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra

let PAYMENT_SUCCESS_NOTIFICATION = "paymentSuccessNotification"

class IAPInterfaceHelper {
    internal weak var delegate: IAPInterface?
    fileprivate var handlerHelper = IAPProductInfoHelper()

    func launchView(_ view: IAPLaunchInput.IAPFlow,
                    withProductCTN: [String],
                    failure:@escaping (NSError) -> Void) -> UIViewController? {
        var viewController: UIViewController?
        switch view {
        case .iapProductCatalogueView:
            guard withProductCTN.count > 0 else {
                let error =  NSError(domain: "Invalid CTN", code: IAPConstants.IAPLaunchErrorCode.kErrorProductCTNCode,
                                     userInfo:[NSLocalizedDescriptionKey:IAPLocalizedString("iap_invalid_product_ctn") ?? ""])
                failure(error)
                return viewController
            }
            viewController = self.launchCategorizedCatalog(withProductCTN)
        case .iapShoppingCartView:
            guard withProductCTN.count > 0 else {
                viewController = self.launchIAPShoppingCart("", failure: failure)
                return viewController
            }
            viewController = self.launchIAPShoppingCart(withProductCTN[0], failure: failure)
        case .iapPurchaseHistoryView:
            viewController = self.launchIAPPurchaseHistoryController() as UIViewController
        case .iapProductDetailView:
            viewController = self.launchIAPProductDetailView(withProductCTN[0], failure: failure)
        case .iapBuyDirectView:
            viewController = self.launchIAPBuyDirectView(withProductCTN[0], failure: failure)
        case .iapCategorizedCatalogueView:
            viewController = self.launchCategorizedCatalog(withProductCTN)
        }
        return viewController
    }

    func initiateAllProductsDownload(_ completion: @escaping (_ withProducts: [String]) -> Void,
                                     failureHandler: @escaping (NSError) -> Void) {
        self.handlerHelper.provideAllProductModels({ (withProducts) in
            var arrayOfProductCTNS = [String]()
            guard withProducts.count > 0 else {
                completion(arrayOfProductCTNS)
                return
            }
            arrayOfProductCTNS = withProducts.map({ $0.getProductCTN() })
            completion(arrayOfProductCTNS)
        }) { (inError: NSError) in
            failureHandler(inError)
        }
    }
    
    func launchCategorizedCatalog(_ ctnList: [String]) -> IAPProductCatalogueController? {
        var catalogueVC: IAPProductCatalogueController?
        catalogueVC = self.launchIAPProductCatalogue(ctnList)
        return catalogueVC
    }
    

    func launchIAPProductCatalogue(_ withProducts: [String] = [String]()) -> IAPProductCatalogueController? {
        let productCatalogueController = IAPProductCatalogueController.instantiateFromAppStoryboard(appStoryboard: .productCatalogue)
        productCatalogueController.setDataArray(withProducts)
        productCatalogueController.iapHandler = self.delegate
        productCatalogueController.cartIconDelegate = self.delegate?.getCartDelegate()
        addPaymentSuccessNotification()
        return productCatalogueController
    }
    
    func launchIAPPurchaseHistoryController() -> IAPPurchaseHistoryViewController {
        let purchaseHistoryController = IAPPurchaseHistoryViewController.instantiateFromAppStoryboard(appStoryboard: .purchaseHistory)
        purchaseHistoryController.cartIconDelegate = self.delegate?.getCartDelegate()
        purchaseHistoryController.iapHandler = self.delegate
        addPaymentSuccessNotification()
        return purchaseHistoryController
    }


    func launchIAPShoppingCart(_ inProductCTN: String, failure: @escaping (NSError) -> Void) -> IAPShoppingCartViewController? {
        let shoppingController = IAPShoppingCartViewController.instantiateFromAppStoryboard(appStoryboard: .shoppingCart)
        shoppingController.productCTN = inProductCTN
        shoppingController.failureHandler = failure
        shoppingController.iapHandler = self.delegate
        shoppingController.cartIconDelegate = self.delegate?.getCartDelegate()
        addPaymentSuccessNotification()
        return shoppingController
    }

    private func addPaymentSuccessNotification() {
        guard let inDelegate = self.delegate else {return}
        NotificationCenter.default.addObserver(inDelegate,
                                               selector: #selector(IAPInterface.goToInitialViewController(_:)),
                                               name: NSNotification.Name(rawValue: PAYMENT_SUCCESS_NOTIFICATION),
                                               object: nil)
    }

    func launchIAPProductDetailView(_ inProductCTN: String,
                                    failure: @escaping (NSError) -> Void) -> IAPShoppingCartDetailsViewController? {
        guard inProductCTN.length == 0 else {
            let detailViewcontroller = IAPShoppingCartDetailsViewController.instantiateFromAppStoryboard(appStoryboard: .shoppingCart)
            detailViewcontroller.productCTN = inProductCTN
            detailViewcontroller.failureHandler = failure
            detailViewcontroller.isFromProductCatalogueView = true
            detailViewcontroller.iapHandler = self.delegate
            detailViewcontroller.cartIconDelegate = self.delegate?.getCartDelegate()
            addPaymentSuccessNotification()
            return detailViewcontroller
        }

        let message = IAPLocalizedString("iap_invalid_product_ctn") ?? ""
        let error =  NSError(domain: message, code: IAPConstants.IAPLaunchErrorCode.kErrorProductCTNCode,
                             userInfo: [NSLocalizedDescriptionKey: message])
        failure(error)
        return nil
    }

    func launchIAPBuyDirectView(_ inProductCTN: String, failure: (NSError) -> Void) -> IAPBuyDirectViewController? {
        guard inProductCTN.length == 0 else {
            let buyDirectViewController = IAPBuyDirectViewController.instantiateFromAppStoryboard(appStoryboard: .buyDirect)
            buyDirectViewController.productCTN = inProductCTN
            buyDirectViewController.cartIconDelegate = self.delegate?.getCartDelegate()
            addPaymentSuccessNotification()
            return buyDirectViewController
        }
        let message = IAPLocalizedString("iap_invalid_product_ctn") ?? ""
        let error =  NSError(domain: message,
                             code: IAPConstants.IAPLaunchErrorCode.kErrorProductCTNCode,
                             userInfo: [NSLocalizedDescriptionKey: message])
        failure(error)
        return nil
    }
}
