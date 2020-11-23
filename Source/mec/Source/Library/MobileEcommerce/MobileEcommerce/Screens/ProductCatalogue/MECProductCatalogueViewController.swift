/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsEcommerceSDK
import PhilipsUIKitDLS
import SafariServices

class MECProductCatalogueViewController: MECBaseViewController {

    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var topbarView: MECTopBarView!
    @IBOutlet weak var searchBar: UIDSearchBar!
    @IBOutlet weak var loadingViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loadingView: UIDView!
    @IBOutlet weak var noProductLabel: UIDLabel!
    @IBOutlet weak var privacyView: UIView!
    @IBOutlet weak var privacyLabel: UIDHyperLinkLabel!
    @IBOutlet weak var loadingViewBottomSafeAreaConstraint: NSLayoutConstraint!
    @IBOutlet weak var loadingViewBottomPrivacyConstraint: NSLayoutConstraint!
    @IBOutlet weak var loadingProgressIndicator: UIDProgressIndicator!
    @IBOutlet weak var zeroSearchResultView: MECZeroSearchResultView!
    @IBOutlet weak var zeroFilterResultView: UIDView!
    @IBOutlet weak var clearFilterLabel: UIDHyperLinkLabel!

    var bannerView: UIView?
    var privacyURL: String?

    var presenter: MECProductCataloguePresenter!
    var ctnList: [String] = []
    var selectedViewType: MECViewType = .gridView

    fileprivate lazy var listLayout = MECListViewLayout()
    fileprivate lazy var gridLayout = MECGridViewLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MECProductCataloguePresenter()
        updateLoadingViewVisibility(isHidden: true)
        configurePrivacyView()
        configureClearFilterLinkLabel()
        bannerView = MECConfiguration.shared.bannerConfigDelegate?.viewForBannerInProductListScreen()
        searchBar.searchBarStyle = .minimal
        topbarView.delegate = self
        productCollectionView.backgroundColor =  UIDThemeManager.sharedInstance.defaultTheme?.separatorContentBackground
        loadingView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.separatorContentBackground
        presenter.productCatalogueDelegate = self
        title = MECLocalizedString("mec_product_title")
        noProductLabel.text = MECLocalizedString("mec_no_product_available")

        initialize { [weak self] (_, error) in
            guard error == nil || error?.code == 5055 else {
                let okButton = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                    self?.trackNotification(message: error?.localizedDescription ?? "", response: MECEnglishString("mec_ok"))
                }
                self?.showAlert(title: MECLocalizedString("mec_product_title"),
                          message: error?.localizedDescription,
                          okButton: okButton,
                          cancelButton: nil)
                self?.shouldShowCart(MECConfiguration.shared.isHybrisAvailable == true)
                self?.updateNoProductMessageVisibility()
                return
            }
            guard let weakSelf = self else { return }
            weakSelf.topbarView.shouldHideFilterOption(shouldHide: !(MECConfiguration.shared.isHybrisAvailable ?? false))
            weakSelf.startActivityProgressIndicator()
            weakSelf.presenter.loadProductList(withCTNs: weakSelf.ctnList, filter: weakSelf.presenter.appliedFilter)
            weakSelf.shouldShowCart(MECConfiguration.shared.isHybrisAvailable == true)
        }
        topbarView.updateUI()
        productCollectionView.register(UINib.init(nibName: MECNibName.MECProductGridCell,
                                                  bundle: MECUtility.getBundle()),
                                       forCellWithReuseIdentifier: MECCellIdentifier.MECProductGridCell)
        productCollectionView.register(UINib.init(nibName: MECNibName.MECBannerViewContainerCell,
                                                  bundle: MECUtility.getBundle()),
                                       forCellWithReuseIdentifier: MECCellIdentifier.MECBannerViewContainerCell)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackPage(pageName: MECAnalyticPageNames.productCatalogue)
    }

    func setProductCTNList(productCTNs: [String]) {
        ctnList = productCTNs.removeDuplicates().formatCTNList()
    }

    func updateLoadingViewVisibility(isHidden: Bool) {
        loadingViewHeightConstraint.constant = isHidden ? 0 : 50
        loadingProgressIndicator.startAnimating()
    }

    func updateNoProductMessageVisibility() {
        if presenter.numberOfProducts() == 0 && (searchBar.text?.isEmpty ?? false) && !searchBar.isFirstResponder {
            productCollectionView.isHidden = true
            topbarView.isHidden = true
            zeroFilterResultView.isHidden = !presenter.appliedFilter.isFilterApplied
            noProductLabel.isHidden = presenter.appliedFilter.isFilterApplied
            privacyView?.isHidden = true
        } else {
            if privacyURL != nil {
                privacyView?.isHidden = false
            }
            productCollectionView.isHidden = false
            topbarView.isHidden = false
            noProductLabel.isHidden = true
            zeroFilterResultView.isHidden = true
        }
    }

    func configureClearFilterLinkLabel() {
        let clearFilterText = "\(MECLocalizedString("mec_clear_filter"))"
        self.clearFilterLabel.text = clearFilterText
        let model = UIDHyperLinkModel()
        model.visitedLinkColor = UIDThemeManager.sharedInstance.defaultTheme?.hyperlinkDefaultText
        model.normalLinkColor = UIDThemeManager.sharedInstance.defaultTheme?.hyperlinkDefaultText
        let textRange = clearFilterText.nsRange(of: MECLocalizedString("mec_clear_filter"))
        model.highlightRange = textRange
        self.clearFilterLabel.addLink(model) { (_) in
            if self.privacyURL != nil {
                self.privacyView?.isHidden = false
            }
            self.startActivityProgressIndicator()
            self.zeroFilterResultView.isHidden = true
            self.topbarView.filterOptionSelected(selected: false)
            self.presenter.appliedFilter = ECSPILProductFilter()
            self.presenter.loadProductList(withCTNs: self.ctnList, filter: self.presenter.appliedFilter)
        }
    }

    func configurePrivacyView() {
        presenter.fetchPrivacyURL { (url, _) in
            guard let inURL = url else {
                self.privacyLabel.text = ""
                self.loadingViewBottomSafeAreaConstraint.isActive = true
                self.loadingViewBottomPrivacyConstraint.isActive = false
                self.privacyView?.removeFromSuperview()
                return
            }

            self.privacyURL = inURL
            self.loadingViewBottomSafeAreaConstraint.isActive = false
            self.loadingViewBottomPrivacyConstraint.isActive = true
            // swiftlint:disable line_length
            let privacyText = "\(MECLocalizedString("mec_read")) \(MECLocalizedString("mec_privacy")) \(MECLocalizedString("mec_more_info"))"
            // swiftlint:enable line_length

            self.privacyLabel.text = privacyText
            let model = UIDHyperLinkModel()
            let textRange = privacyText.nsRange(of: MECLocalizedString("mec_privacy"))
            model.highlightRange = textRange
            self.privacyLabel.addLink(model) { (_) in
                if let url = URL(string: inURL) {
                    self.trackExitLink(exitURL: url)
                    let safari = SFSafariViewController(url: url)
                    safari.view.accessibilityIdentifier = "mec_catalogue_privacy_web_view"
                    safari.preferredBarTintColor = UINavigationBar.appearance().barTintColor
                    safari.preferredControlTintColor = UINavigationBar.appearance().tintColor
                    self.present(safari, animated: true, completion: nil)
                }
            }
        }
    }
}

extension MECProductCatalogueViewController: MECProductCatalogueDelegate {
    func emptyRequestThresholdReached() {
        let cancelAction = UIDAction(title: MECLocalizedString("mec_cancel"), style: .secondary, handler: {(_) in
            self.stopActivityProgressIndicator()
            self.updateNoProductMessageVisibility()
            self.privacyView?.isHidden = true
        })

        let okAction = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
            if self.presenter.shouldLoadMoreProducts() {
                self.presenter.loadMoreProducts()
            }
        }

        self.showAlert(title: MECLocalizedString("mec_threshold_title"),
                       message: MECLocalizedString("mec_threshold_message"),
                       okButton: okAction,
                       cancelButton: cancelAction)
    }

    func showError(error: Error?) {
        stopActivityProgressIndicator()
        updateNoProductMessageVisibility()
        privacyView?.isHidden = true
        updateLoadingViewVisibility(isHidden: true)
    }

    func productSearchCompleted() {
        if presenter.numberOfProducts() > 0 {
            productCollectionView.isHidden = false
            productCollectionView.contentOffset = .zero
            zeroSearchResultView.isHidden = true
            productCollectionView.reloadData()
            if privacyURL != nil {
                privacyView?.isHidden = false
            }
        } else {
            productCollectionView.isHidden = true
            zeroSearchResultView.isHidden = false
            zeroSearchResultView.showNoSearchResult(searchTerm: searchBar.text ?? "")
            privacyView?.isHidden = true
        }
    }

    func productListLoaded() {
        stopActivityProgressIndicator()
        productCollectionView.reloadData()
        updateLoadingViewVisibility(isHidden: true)
        updateNoProductMessageVisibility()
        if presenter.numberOfProducts() == 0 {
            privacyView?.isHidden = true
        }
    }
}

extension MECProductCatalogueViewController: UICollectionViewDataSource, MECProductCellUpdater {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return (searchBar.text?.isEmpty == false || bannerView == nil) ? 0 : 1
        } else {
            return presenter.numberOfProducts()
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MECCellIdentifier.MECBannerViewContainerCell,
                                                                for: indexPath) as? MECBannerViewContainerCell else {
                                                                    return UICollectionViewCell()
            }
            if let actualBannerView = bannerView {
                actualBannerView.translatesAutoresizingMaskIntoConstraints = false
                cell.containerView.addSubview(actualBannerView)
                actualBannerView.constrainToSuperviewAccordingToLanguage()
            }
            return cell
        } else {
            let productCell: MECProductCell!

            if selectedViewType == .listView {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MECCellIdentifier.MECProductListCell,
                                                                    for: indexPath) as? MECProductListCell else {
                                                                        return UICollectionViewCell() }
                productCell = cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MECCellIdentifier.MECProductGridCell,
                                                                    for: indexPath) as? MECProductGridCell else {
                                                                        return UICollectionViewCell() }
                productCell = cell
            }

            if let product = presenter.productAtIndex(index: indexPath.row) {
                updateProductCell(productCell: productCell, with: product)
            }
            return productCell
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if presenter.numberOfProducts() > 0 &&
            (indexPath.row == (presenter.numberOfProducts() - 1 ) &&
                presenter.shouldLoadMoreProducts()) {
            presenter.loadMoreProducts()
            updateLoadingViewVisibility(isHidden: false)
        }
    }
}

extension MECProductCatalogueViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        updateLoadingViewVisibility(isHidden: true)              // hiding bottom loading view if it is showing
        topbarView.filterOptionEnabled(enabled: false)
        return true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        presenter.cancelProductSearch()
        topbarView.filterOptionEnabled(enabled: true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchProduct(searchText: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchProduct(searchText: searchBar.text ?? "")
    }
}

extension MECProductCatalogueViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section > 0 else { return }

        if let productDetailController = MECProductDetailsViewController.instantiateFromAppStoryboard(appStoryboard: .productDetails) {
            productDetailController.product = presenter.productAtIndex(index: indexPath.row)
            self.navigationController?.pushViewController(productDetailController, animated: true)
        }
    }
}

extension MECProductCatalogueViewController: MECTopBarDelegate {

    func getTopProductCTNsForTagging() -> String {
        var productList: [MECProduct] = []
        for productIndex in 0..<10 {
            if let product = presenter.productAtIndex(index: productIndex) {
                productList.append(product)
            }
        }
        return prepareProductString(productList: productList)
    }

    func didSelectFilter() {
        if let productFilterViewController = MECProductFilterViewController.instantiateFromAppStoryboard(appStoryboard: .productFilter) {
            productFilterViewController.modalPresentationStyle = .overCurrentContext
            productFilterViewController.appliedFilter = presenter.appliedFilter
            productFilterViewController.filterDelegate = self
            present(productFilterViewController, animated: true, completion: nil)
        }
    }

    func didSelectViewType(viewType: MECViewType) {
        if selectedViewType != viewType {
            let newLayout = viewType == .listView ? listLayout : gridLayout
            selectedViewType = viewType

            let layout = selectedViewType == .listView ? MECAnalyticsConstants.listView : MECAnalyticsConstants.gridView
            trackAction(parameterData: [MECAnalyticsConstants.productListLayout: layout,
                                        MECAnalyticsConstants.productListKey: getTopProductCTNsForTagging()])

            productCollectionView.collectionViewLayout.invalidateLayout()
            productCollectionView.setCollectionViewLayout(newLayout, animated: false)
            productCollectionView.reloadData()
            productCollectionView.contentOffset = .zero
        }
    }
}

extension MECProductCatalogueViewController: MECProductFilterDelegate {
    func didSelectApplyFilter(filter: ECSPILProductFilter) {
        startActivityProgressIndicator()
        topbarView.filterOptionSelected(selected: filter.isFilterApplied)
        presenter.loadProductList(withCTNs: ctnList, filter: filter)
        productCollectionView.contentOffset = .zero
    }

    func filterScreenDismissed() {
        trackPage(pageName: MECAnalyticPageNames.productCatalogue)
    }
}
