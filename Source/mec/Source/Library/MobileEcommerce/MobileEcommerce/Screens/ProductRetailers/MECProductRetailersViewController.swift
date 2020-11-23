/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS
import PhilipsEcommerceSDK
import PhilipsIconFontDLS
import SafariServices
import AFNetworking

class MECProductRetailersViewController: MECBaseViewController {

    var fetchedRetailers: [ECSRetailer]?
    var product: MECProduct?
    var retailerLoadedURL: URL?

    @IBOutlet weak var productRetailersTableView: UITableView!
    @IBOutlet weak var gestureView: UIView!
    weak var delegate: MECViewControllerDismissDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        shouldShowCart(MECConfiguration.shared.isHybrisAvailable == true)
        configureGestureRecognizer()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        productRetailersTableView.estimatedRowHeight = 100
        productRetailersTableView.rowHeight = UITableView.automaticDimension
        navigationController?.isNavigationBarHidden = true
        trackRetailerList()
    }

    fileprivate func trackRetailerList() {
        var retailerNameList: String = ""
        if let retailerList = fetchedRetailers {
            for retailer in retailerList {
                retailerNameList.append(retailer.name ?? "")
                retailerNameList.append("|")
            }
            if retailerNameList.count > 0 {
                retailerNameList.removeLast()
            }
            if let product = product {
                var param = [MECAnalyticsConstants.retailerList: retailerNameList,
                             MECAnalyticsConstants.productListKey: prepareProductString(productList: [product])]
                if let blackList = MECConfiguration.shared.blacklistedRetailerNames, !(blackList.isEmpty) {
                    param.updateValue(blackList.joined(separator: "|"), forKey: MECAnalyticsConstants.blackListedRetailerList)
                }
                trackAction(parameterData: param)
            }
        }
    }

    fileprivate func trackSelectedRetailer(retailer: ECSRetailer) {
        let stockStatus = retailer.availability?.caseInsensitiveCompare("YES") == .orderedSame ?
            MECAnalyticsConstants.available :
            MECAnalyticsConstants.outOfStock
        if let product = product {
            trackAction(parameterData: [MECAnalyticsConstants.retailerName: retailer.name ?? "",
                                        MECAnalyticsConstants.stockStatus: stockStatus,
                                        MECAnalyticsConstants.productListKey: prepareProductString(productList: [product])])
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackPage(pageName: MECAnalyticPageNames.retailerList)
    }
}

extension MECProductRetailersViewController {

    func configureGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureViewTapped))
        tapGestureRecognizer.cancelsTouchesInView = false
        gestureView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func gestureViewTapped(_ sender: Any) {
        delegate?.viewControllerDidDismiss()
        dismiss(animated: true, completion: nil)
    }
}

extension MECProductRetailersViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedRetailers?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let retailerCell = tableView.dequeueReusableCell(withIdentifier:
            MECCellIdentifier.MECProductRetailersCell) as? MECProductRetailersCell
        if let retailerDetail = fetchedRetailers?[indexPath.row] {
            retailerCell?.retailerTitleLabel.text = retailerDetail.name
            retailerDetail.availability?.caseInsensitiveCompare("YES") == .orderedSame ?
                retailerCell?.retailerStockLabel.displayInStock() :
                retailerCell?.retailerStockLabel.displayOutOfStock()
            retailerCell?.retailerPriceLabel.displayRetailerProductPrice(price: retailerDetail.philipsOnlinePrice)
            retailerCell?.retailerRightArrow.font = UIFont.iconFont(size: UIDSize16)
            retailerCell?.retailerRightArrow.text = MECUtility.isRightToLeft ? PhilipsDLSIcon.unicode(iconType: .navigationLeft) :
                PhilipsDLSIcon.unicode(iconType: .navigationRight)
            if let logoURLString = retailerDetail.logoURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let logoURL = URL(string: logoURLString) {
                AFImageDownloader.defaultInstance()
                    .sessionManager
                    .responseSerializer
                    .acceptableContentTypes?.insert(MECImageDownloadSpecialFormats.MECOctetFormat)
                retailerCell?.retailerLogoImageView.setImageWith(logoURL)
            } else {
                let noImage = UIImage(named: MECConstants.MECNoImageIconName, in: MECUtility.getBundle(), compatibleWith: nil)
                retailerCell?.retailerLogoImageView.image = noImage
            }
        }
        return retailerCell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MECProductRetailersViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIDHeaderView.createMECHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
        headerView.headerLabel.text = MECLocalizedString("mec_online_retailers")
        headerView.headerLabel.accessibilityIdentifier = "mec_online_retailers_label"
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let retailerDetail = fetchedRetailers?[indexPath.row],
            let retailerURL = getRetailerURL(for: retailerDetail) {
                trackSelectedRetailer(retailer: retailerDetail)
                let retailerSafariVC = SFSafariViewController(url: retailerURL)
                retailerSafariVC.view.accessibilityIdentifier = "mec_retailer_web_view"
                retailerSafariVC.delegate = self
                retailerSafariVC.preferredBarTintColor = UINavigationBar.appearance().barTintColor
                retailerSafariVC.preferredControlTintColor = UINavigationBar.appearance().tintColor
                present(retailerSafariVC, animated: true, completion: nil)
        }
    }

    func getRetailerURL(for retailer: ECSRetailer) -> URL? {

        if let retailerURLString = retailer.buyURL, retailerURLString.count > 0,
            let retailerURL = URL(string: retailerURLString) {

            var queryItems = [URLQueryItem]()
            if let propositionID = MECUtility.fetchConfigValueForKey(MECConstants.MECPropositionId) as? String {
                let wtbSourceQueryItem = URLQueryItem(name: "wtbSource", value: "mobile_\(propositionID)")
                queryItems.append(wtbSourceQueryItem)
            }

            if let retailerParam = retailer.xactparam {
                let uuidValue = UUID().uuidString
                let uuidQueryItem = URLQueryItem(name: retailerParam, value: uuidValue)
                queryItems.append(uuidQueryItem)
            }

            var retailerURLComponents = URLComponents(url: retailerURL, resolvingAgainstBaseURL: false)
            if let retailerQueryComponents = retailerURLComponents?.queryItems, retailerQueryComponents.count > 0 {
                retailerURLComponents?.queryItems?.append(contentsOf: queryItems)
            } else {
                retailerURLComponents?.queryItems = queryItems
            }
            return retailerURLComponents?.url
        }
        return nil
    }

}

extension MECProductRetailersViewController: SFSafariViewControllerDelegate {

    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        retailerLoadedURL = URL
    }

    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        if didLoadSuccessfully, let loadedURL = retailerLoadedURL {
            trackExitLink(exitURL: loadedURL)
        }
    }
}
