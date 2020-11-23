/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra
import PhilipsUIKitDLS

class IAPUtility {
    class func getCartInterfaceBuilder() -> IAPOCCCartInterfaceBuilder {
        let occInterfaceBuilder     = IAPOCCCartInterfaceBuilder(inUserID: "current")!
        return occInterfaceBuilder
    }
    
    class func getAddressInterfaceBuilder() -> IAPOCCAddressInterfaceBuilder {
        let occInterfaceBuilder     = IAPOCCAddressInterfaceBuilder(inUserID: "current")!
        return occInterfaceBuilder
    }

    class func getPaymentInterfaceBuilder() -> IAPOCCPaymentInterfaceBuilder {
        let occInterfaceBuilder     = IAPOCCPaymentInterfaceBuilder(inUserID: "current")!
        return occInterfaceBuilder
    }

    class func getBundle() -> Bundle {
        return Bundle(for: self)
    }

    @objc class func getResourceBundle() -> Bundle {
        let mainBundle = IAPUtility.getBundle()
        let resourceURL = mainBundle.url(forResource: "InAppPurchaseResources", withExtension: "bundle")
        let bundle = Bundle(url: resourceURL!)
        return bundle!
    }

    class func popToShoppingCartController(_ navigationController: UINavigationController) {
        for viewController in (navigationController.viewControllers) {
            if viewController.isKind(of: IAPShoppingCartViewController.self) {
                navigationController.popToViewController(viewController, animated: true)
                break
            }
        }
    }

    class func popToOrderSummaryViewController(_ navigationController: UINavigationController) {
        for viewController in (navigationController.viewControllers) {
            if viewController.isKind(of: IAPOrderSummaryViewController.self) {
                navigationController.popToViewController(viewController, animated: true)
                break
            }
        }
    }

    class func getShoppingCartController(_ withCartDelegate: IAPCartIconProtocol?,
                                         withInterfaceDelegate: IAPInterface?) -> IAPShoppingCartViewController? {
        let shoppingCtlr = IAPShoppingCartViewController.instantiateFromAppStoryboard(appStoryboard: .shoppingCart)
        shoppingCtlr.cartIconDelegate = withCartDelegate
        shoppingCtlr.iapHandler = withInterfaceDelegate
        return shoppingCtlr
    }

    class func getProductCatalogueController(_ withCartDelegate: IAPCartIconProtocol?,
                                             withInterfaceDelegate: IAPInterface?) -> IAPProductCatalogueController? {
        let productCatalogueController = IAPProductCatalogueController.instantiateFromAppStoryboard(appStoryboard: .productCatalogue)
        productCatalogueController.cartIconDelegate = withCartDelegate
        productCatalogueController.iapHandler = withInterfaceDelegate
        return productCatalogueController
    }
    
    class func getStrikeThroughAttributedText(_ inputString: String!) -> NSMutableAttributedString {
        let attributeString =  NSMutableAttributedString(string: inputString)
        attributeString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    class func getTotalCell(_ tableView: UITableView, withTotal: String, withItems: Int = 1) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IAPCellIdentifier.totalCell) as? IAPCartTotalCell else {
            return UITableViewCell(frame: .zero)
        }
        cell.totalLabel.text = IAPLocalizedString("iap_total")! + " (" + "\(withItems) " + IAPLocalizedString("iap_items")! + ")"
        cell.totalPriceLabel.text = withTotal
        return cell
    }
    
    class func getUserNotLoggedInError() -> NSError {
        let message = IAPLocalizedString("iap_user_not_registered")!
        let error =  NSError(domain: message, code: IAPConstants.IAPLaunchErrorCode.kRegistrationLaunchErrorCode,
                             userInfo: [NSLocalizedDescriptionKey: message])
        return error
    }
    
    class func getServiceDiscoveryError() -> NSError {
        let message = IAPLocalizedString("iap_server_error")! + ". " + IAPLocalizedString("iap_try_again")!
        let error =  NSError(domain: message,
                             code: IAPConstants.IAPNoInternetError.kServerNotReachable,
                             userInfo:[NSLocalizedDescriptionKey:message])
        return error
    }
    
    class func getComponentInfo() -> [String: AnyObject] {
        let bundle: Bundle = IAPUtility.getBundle()
        let componentInfoDict: Dictionary = bundle.infoDictionary!
        return componentInfoDict as [String: AnyObject]
    }
    
    class func configureTaggingAndLogging(_ appInfraInstance: AIAppInfra) {
        let componentInfoDict: Dictionary = IAPUtility.getComponentInfo()
        let bundleVersion = componentInfoDict["CFBundleShortVersionString"] as? String ?? ""
        IAPConfiguration.sharedInstance.setIAPAppTagging(appInfraInstance.tagging.createInstance(
            forComponent: "iap", componentVersion: bundleVersion))
        IAPConfiguration.sharedInstance.setIAPAppLogging(appInfraInstance.logging.createInstance(
            forComponent: "iap", componentVersion: bundleVersion))
    }
    
    // TODO: For DLS, we need to uncomment the commented lines 
    class func getButtonWithFontIcon(button: UIButton?, fontName: String, fontColor: UIColor) -> UIButton {
        var buttonToReturn: UIButton
        if button == nil {
            buttonToReturn = UIButton(type: .custom)
            buttonToReturn.frame = CGRect(x: 0, y: 0, width: UIDIconSize, height: UIDIconSize)
        } else {
            buttonToReturn = button!
        }
        buttonToReturn.backgroundColor = UIColor.clear
        let image = UIImage.getImage(withName: fontName)
        buttonToReturn.setImage(image!, for: .normal)
        buttonToReturn.imageView?.contentMode = .scaleAspectFit
        return buttonToReturn
    }
    
    class func commonViewForHeaderInSection(_ screenName: Int, sectionValue: Int,
                                            productCount: Int = 1,
                                            headerView: IAPPurchaseHistoryOverviewSectionHeader) -> UIView? {
        headerView.sectionHeaderView.backgroundColor? = (UIDThemeManager.sharedInstance.defaultTheme?.contentTertiaryBackground)!
        switch sectionValue {
        case IAPConstants.TableviewSectionConstants.kShoppingCartSection:
            headerView.dateLabel.text = (productCount == 1) ? IAPLocalizedString("iap_number_of_product",String(productCount))! :
                (String(productCount) + " " + IAPLocalizedString("iap_product_catalog")!)
        case IAPConstants.TableviewSectionConstants.kAddressCellSection:
            headerView.dateLabel.text = (screenName == IAPConstants.IAPCommonSectionHeaderView.kShoppingCartSection) ?
                IAPLocalizedString("iap_extra_option")! : IAPLocalizedString("iap_options")!
        case IAPConstants.TableviewSectionConstants.kDeliveryModeSection:
            headerView.dateLabel.text = IAPLocalizedString("iap_cart_summary")!
        case IAPConstants.TableviewSectionConstants.kOrderSummarySection:
            headerView.dateLabel.text = IAPLocalizedString("iap_order_summary")!
        default:
            headerView.dateLabel.text = " "
        }
        return headerView
    }
    
    class func setIAPPreference(_ success:@escaping (Bool) -> Void,
                                failureHandler: @escaping (NSError) -> Void) {
        let appInfraInstance = IAPConfiguration.sharedInstance.sharedAppInfra
        appInfraInstance?.serviceDiscovery.getServicesWithCountryPreference(["iap.baseurl"], withCompletionHandler: { (returnedValue, inError) in
            guard inError == nil else {
                failureHandler(IAPUtility.getServiceDiscoveryError())
                return
            }
            if let serviceDiscoveryValue = returnedValue?["iap.baseurl"] {
                IAPConfiguration.sharedInstance.locale = serviceDiscoveryValue.locale
                IAPConfiguration.sharedInstance.baseURL = IAPConfiguration.sharedInstance.supportsHybris ? serviceDiscoveryValue.url : nil
                //PROD-"https://www.pil.occ.shop.philips.com"
                //STAG-"https://acc.pil.occ.shop.philips.com"
                if IAPConfiguration.sharedInstance.baseURL != nil {
                    IAPConfiguration.sharedInstance.isHybrisEnabled = true
                    success(true)
                } else {
                    IAPConfiguration.sharedInstance.isHybrisEnabled = false
                    success(false)
                }
            }
        }, replacement:nil)
    }
    
    class func isStockAvailable(stockLevelStatus: String?, stockAmount: Int) -> Bool {
        if let stockLevelStatus = stockLevelStatus,
            ((stockLevelStatus.caseInsensitiveCompare(IAPConstants.IAPShoppingCartKeys.kInStockKey) == ComparisonResult.orderedSame ||
            stockLevelStatus.caseInsensitiveCompare(IAPConstants.IAPShoppingCartKeys.kLowStockKey) == ComparisonResult.orderedSame) && stockAmount > 0 ) {
            return true
        } 
       return false
    }
    
    class func isLoginRequired(for launchInput: IAPLaunchInput) -> Bool {
        let landingView = launchInput.getLandingView()
        return landingView != .iapCategorizedCatalogueView
            && landingView != .iapProductDetailView
            && landingView != .iapProductCatalogueView
    }
    
    class func tagExitLink(exitURL: URL) {
        if let taggingURL = fetchTaggingURLFor(actualURL: exitURL) {
            IAPConfiguration.sharedInstance.sharedAppInfra.tagging.trackAction(withInfo: IAPAnalyticsConstants.sendData,
                                                                               params: [IAPAnalyticsConstants.exitLinkNameKey: taggingURL.absoluteString])
        }
    }
    
    class func prepareProductString(products: [IAPProductModel]) -> String {
        
        guard products.count > 0 else { return ""}
        let category = IAPConfiguration.sharedInstance.configuration?.rootCategory ?? IAPAnalyticsConstants.retailer
        var productListString = ""
        
        for product in products {
            let productCTN = product.getProductCTN()
            let price = product.getDiscountPrice().length > 0 ? product.getDiscountPrice() : "0.0"
            let quantity = product.getStockAmount()
            productListString.append("\(category);\(productCTN);\(quantity);\(price.replacingOccurrences(of: ",", with: ".")),")
        }
        if productListString.count > 0 {
            productListString.removeLast()
        }

        return productListString
    }
    
    class func fetchTaggingURLFor(actualURL: URL) -> URL? {
        
        var taggingURL: URL?
        if let appName = IAPConfiguration.sharedInstance.sharedAppInfra.appIdentity.getAppName(),
            let locale = IAPConfiguration.sharedInstance.sharedAppInfra.internationalization.getUILocaleString() {
            let exitLinkQueryItem = URLQueryItem(name: "origin", value: "15_global_\(locale)_\(appName)-app_\(appName)-app")
            var retailerURLComponents = URLComponents(url: actualURL, resolvingAgainstBaseURL: false)
            if let retailerQueryComponents = retailerURLComponents?.queryItems, retailerQueryComponents.count > 0 {
                retailerURLComponents?.queryItems?.append(exitLinkQueryItem)
            } else {
                retailerURLComponents?.queryItems = [exitLinkQueryItem]
            }
            taggingURL = retailerURLComponents?.url
        }
        
        return taggingURL
    }
}

extension String {
    /// Extracts the last 2 characters in string.
    var iapCountryCode: String {
        let last2EndCharIndex = self.index(self.endIndex, offsetBy: -2)
        let subString = self[last2EndCharIndex..<self.endIndex]
        return String(subString).replaceCharacter("-", withCharacter: "")   // stripping of extra "-"
    }
}

extension UIImage {

    class func getImage(withName: String) -> UIImage? {
        return UIImage(named: withName, in: IAPUtility.getBundle(), compatibleWith: nil)
    }
}
