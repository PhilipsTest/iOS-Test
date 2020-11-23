/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

typealias MECLaunchFailureCompletionHandler = (NSError) -> Void

class MECLauncher: NSObject, MECAnalyticsTracking {

    func launchView(_ landingView: MECLandingView,
                    failure:@escaping (NSError) -> Void) -> UIViewController? {

        guard let isInternetReachable = MECConfiguration.shared.sharedAppInfra?.restClient.isInternetReachable(),
            isInternetReachable else {
                trackInformationalError(errorMessage: MECEnglishString("mec_no_internet"))
                failure(NSError(domain: MECErrorDomain.MECNoNetworkDomain,
                                code: MECErrorCode.MECNoInternetCode,
                                userInfo: [NSLocalizedDescriptionKey: MECLocalizedString("mec_no_internet")]))
            return nil
        }

        let productCTNs = MECConfiguration.shared.flowConfiguration?.productCTNs

        //Resetting the eCommerce SDK for each entry point
        MECConfiguration.shared.resetSavedUserData()

        switch landingView {
        case .mecProductListView:
            return launchProductList(failure: failure)
        case .mecCategorizedProductListView:
            return launchCategorizedProductList(ctnList: productCTNs, failure: failure)
        case .mecProductDetailsView:
            return launchProductDetailViewFor(productCTN: productCTNs?.first, failure: failure)
        case .mecShoppingCartView:
            return launchShoppingCartView(failure: failure)
        case .mecOrderHistoryView:
            return launchOrderHistoryView(failure: failure)
        }
    }

    fileprivate func launchProductList(failure: MECLaunchFailureCompletionHandler) -> MECProductCatalogueViewController? {
        var catalogueVC: MECProductCatalogueViewController?
        catalogueVC = createMECProductListScreen()
        return catalogueVC
    }

// swiftlint:disable line_length
    fileprivate func launchCategorizedProductList(ctnList: [String]?,
                                                  failure: @escaping MECLaunchFailureCompletionHandler) -> MECProductCatalogueViewController? {
// swiftlint:enable line_length
        var categorizedCatalogueVC: MECProductCatalogueViewController?

        guard let ctnList = ctnList, ctnList.count > 0 else {
            let message = MECLocalizedString("mec_invalid_product_ctn")
            let error = NSError(domain: message,
                                code: MECErrorCode.MECErrorProductCTNCode,
                                userInfo: [NSLocalizedDescriptionKey: message])
            failure(error)
            return categorizedCatalogueVC
        }
        categorizedCatalogueVC = createMECProductListScreen()
        categorizedCatalogueVC?.setProductCTNList(productCTNs: ctnList)
        return categorizedCatalogueVC
    }

    fileprivate func launchProductDetailViewFor(productCTN: String?,
                                                failure: @escaping MECLaunchFailureCompletionHandler) -> MECProductDetailsViewController? {
        var productDetailsController: MECProductDetailsViewController?
        guard let productCTN = productCTN, productCTN.count > 0 else {
            let message = MECLocalizedString("mec_invalid_product_ctn")
            let error =  NSError(domain: message,
                                 code: MECErrorCode.MECErrorProductCTNCode,
                                 userInfo: [NSLocalizedDescriptionKey: message])
            failure(error)
            return productDetailsController
        }

        productDetailsController = MECProductDetailsViewController.instantiateFromAppStoryboard(appStoryboard: .productDetails)
        productDetailsController?.productCTN = productCTN
        return productDetailsController
    }

    fileprivate func launchShoppingCartView(failure: MECLaunchFailureCompletionHandler) -> MECShoppingCartViewController? {
        guard let error = MECErrorUtility.checkHybrisEntryValidation() else {
            return MECShoppingCartViewController.instantiateFromAppStoryboard(appStoryboard: .shoppingCart)
        }
        failure(error)
        return nil
    }

    fileprivate func launchOrderHistoryView(failure: MECLaunchFailureCompletionHandler) -> MECOrderHistoryViewController? {
        guard let error = MECErrorUtility.checkHybrisEntryValidation() else {
            return MECOrderHistoryViewController.instantiateFromAppStoryboard(appStoryboard: .orderHistory)
        }
        failure(error)
        return nil
    }

    fileprivate func createMECProductListScreen() -> MECProductCatalogueViewController? {
        let productCatalogueController = MECProductCatalogueViewController.instantiateFromAppStoryboard(appStoryboard: .productCatalogue)
        return productCatalogueController
    }
}
