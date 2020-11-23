/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import AppInfra
import SafariServices

class IAPRetailerViewController: IAPBaseViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var retailerTableView: UITableView!
    var retailers = [IAPRetailerModel]()
    var retailerLoadedURL: URL?
    var selectedRetailer: IAPRetailerModel?
    var product: IAPProductModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.retailerTableView.estimatedRowHeight = 160.0
        self.retailerTableView.rowHeight = UITableView.automaticDimension
        title = IAPLocalizedString("iap_select_retailer")
        trackPage(pageName: IAPConstants.IAPAppTaggingStringConstants.kSelectRetailerPageName)
        if retailers.count > 0 {
            var retailerNameList: String = ""
            for retailer in retailers {
                retailerNameList.append(retailer.retailerName)
                retailerNameList.append("|")
            }
            retailerNameList = retailerNameList.removeCharacterAtEndOfString(1) ?? ""
            if let product = product {
                trackAction(parameterData: [IAPAnalyticsConstants.product: IAPUtility.prepareProductString(products: [product]),
                                            IAPAnalyticsConstants.retailerList: retailerNameList], action: IAPAnalyticsConstants.sendData)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        super.updateCartIconVisibility(false)
    }
    
    override func didTapTryAgain() {
        super.didTapTryAgain()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.retailers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.retailerTableView.dequeueReusableCell(
            withIdentifier: IAPCellIdentifier.retailerCell) as? IAPRetailerTableViewCell else {
                return UITableViewCell(frame: .zero)
        }
        
        let image = cell.arrowButton.image(for: .normal)?.imageFlippedForRightToLeftLayoutDirection()
        cell.arrowButton.setImage(image, for: .normal)
        
        let retailer = self.retailers[indexPath.row]
        cell.retailerNameLabel.text = retailer.retailerName
        
        cell.retailerStockLabel.text = retailer.isProductAvailabile ?
            IAPLocalizedString("iap_in_stock") : IAPLocalizedString("iap_out_of_stock")
        cell.retailerStockLabel.textColor = retailer.isProductAvailabile ?
            UIColor.color(range: .signalGreen, level: .color60) : UIColor.color(range: .signalRed, level: .color60)
        
        if let logoURLString = retailer.logoURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let logoURL = URL(string: logoURLString) {
            AFImageDownloader.defaultInstance()
                .sessionManager
                .responseSerializer
                .acceptableContentTypes?.insert(IAPConstants.IAPPRXConsumerKeys.kOctetFormat)
            cell.retailerImageView.setImageWith(logoURL, placeholderImage: nil)
            cell.retailerImageView.contentMode = UIView.ContentMode.scaleAspectFit
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: false)
        guard IAPConfiguration.sharedInstance.isInternetReachable() else {
            super.displayNoNetworkError()
            return
        }
        
        let retailer = self.retailers[indexPath.row]
        if let retailerURL = getRetailerURL(for: retailer) {
            let safariVC = SFSafariViewController(url:retailerURL)
            safariVC.delegate = self
            safariVC.preferredBarTintColor = UINavigationBar.appearance().barTintColor
            safariVC.preferredControlTintColor = UINavigationBar.appearance().tintColor
            selectedRetailer = retailer
            
            if let retailerName = selectedRetailer?.retailerName, let inProduct = product {
                let stockStatus = retailer.isProductAvailabile ? IAPAnalyticsConstants.available: IAPAnalyticsConstants.outOfStock
                trackAction(parameterData: [IAPAnalyticsConstants.product: IAPUtility.prepareProductString(products: [inProduct]),
                                            IAPAnalyticsConstants.stockStatus: stockStatus,
                                            IAPAnalyticsConstants.retailerName: retailerName],
                            action: IAPAnalyticsConstants.sendData)
            }
            
            self.navigationController?.present(safariVC, animated: true, completion:{
            })
        }
    }
    
    func getRetailerURL(for retailer: IAPRetailerModel) -> URL? {
        var queryItems = [URLQueryItem]()
        if let propositionID = IAPOAuthConfigurationData.getInAppConfigValueForKey(IAPConstants.IAPConfigurationKeys.kPropositionId) as? String {
            let wtbSourceQueryItem = URLQueryItem(name: "wtbSource", value: "mobile_\(propositionID)")
            queryItems.append(wtbSourceQueryItem)
        }
        if let retailerParam = retailer.retailerParam {
            let uuidValue = UUID().uuidString
            let uuidQueryItem = URLQueryItem(name: retailerParam, value: uuidValue)
            queryItems.append(uuidQueryItem)
        }
        if let retailerURL = URL(string: retailer.buyURL) {
            var retailerURLComponents = URLComponents(url: retailerURL, resolvingAgainstBaseURL: false)
            if let retailerQueryComponents = retailerURLComponents?.queryItems, retailerQueryComponents.count > 0 {
                retailerURLComponents?.queryItems?.append(contentsOf: queryItems)
            } else {
                retailerURLComponents?.queryItems = queryItems
            }
            return retailerURLComponents?.url
        }
        return URL(string: retailer.buyURL)
    }
}

extension IAPRetailerViewController: SFSafariViewControllerDelegate {
    
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        retailerLoadedURL = URL
    }
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        if didLoadSuccessfully, let loadedURL = retailerLoadedURL {
            IAPUtility.tagExitLink(exitURL: loadedURL)
        }
    }
}
