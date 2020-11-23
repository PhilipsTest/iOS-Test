/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra
import PhilipsUIKitDLS
import PhilipsIconFontDLS

class IAPPurchaseHistoryViewController: IAPBaseViewController, UITableViewDelegate, UITableViewDataSource,
IAPPaginationProtocol, IAPProductAndHistoryProtocol {

    @IBOutlet weak var noItemsOtherSalesLabel: UIDLabel!
    @IBOutlet weak var noItemsEmailLabel: UIDLabel!
    @IBOutlet weak var noItemsLabel: UIDLabel!
    @IBOutlet weak var infoImage: UIDLabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var headerTitleLabel: UIDLabel!
    @IBOutlet weak var noHistoryView: UIDView!
    @IBOutlet weak var continueShoppingButton: UIDButton!
    @IBOutlet weak var callCustomerCareButton: UIDButton!
    @IBOutlet weak var orderTableView: UITableView!

    var paginationModel: IAPPaginationModel!
    fileprivate let purchaseHistoryDataSource = IAPPurchaseHistoryDataSource()
    var filteredOrderCollection = [IAPPurcahseHistorySortedCollection]()
    fileprivate let requestDispathQueue = DispatchQueue(label: "IAPPurchaseHistoryOrderDetailQueue", attributes: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        title = IAPLocalizedString("iap_order_history")
        infoImage.textColor = UIDThemeManager.sharedInstance.defaultTheme?.buttonPrimaryFocusBackground
        infoImage.font = UIFont.iconFont(size: 22.0)
        infoImage.text = PhilipsDLSIcon.unicode(iconType: .infoCircle)
        IAPUtility.setIAPPreference({[weak self] (inSuccess) in
            if (inSuccess) {
                self?.initialiseAndLoadData()
            } else {

                DispatchQueue.main.async {
                    let uidAction: UIDAction = UIDAction(title: IAPLocalizedString("iap_ok"),
                                                         style: .primary, handler: { (uidAction) in
                                                            self?.navigationController?.popViewController(animated: true)
                    })
                    let alert = UIDAlertController(title: IAPLocalizedString("iap_server_error"), message: IAPLocalizedString("iap_no_checkout"))
                    alert.addAction(uidAction)
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }) { (inError) in
            super.displayErrorMessage(inError)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.updateCartIconVisibility(false)
        self.orderTableView.estimatedRowHeight = 300
        self.orderTableView.rowHeight = UITableView.automaticDimension
        
        trackPage(pageName: IAPConstants.IAPAppTaggingStringConstants.kPurchaseHistoryPageName)
    }

    override func didTapTryAgain() {
        super.didTapTryAgain()
        self.initialiseAndLoadData()
    }

    @IBAction func continueShoppingClicked(_ sender: AnyObject) {
        self.navigationController?.popToProductCatalogue(nil, withCartDelegate: self.cartIconDelegate,
                                                         withInterfaceDelegate: self.iapHandler)
    }

    @IBAction func contactConsumerCareClicked(_ sender: AnyObject) {}

    func fetchDataForPage(_ currentPage:Int) {
        guard IAPConfiguration.sharedInstance.isInternetReachable() else {
            super.displayNoNetworkError()
            return
        }
        self.purchaseHistoryDataSource.getPurchaseHistoryForPage(currentPage,
                                                                 withPreviousObjects: self.filteredOrderCollection,
                                                                 completion: { (withOrders, paginationModel) in
                                                                    self.removeNoInternetView()
                                                                    super.stopActivityProgressIndicator()
                                                                    if let model = paginationModel {
                                                                        self.paginationModel = model
                                                                    }
                                                                    self.filteredOrderCollection = withOrders
                                                                    guard self.filteredOrderCollection.count != 0 else {
                                                                        self.updateUIForEmptyOrderHistory()
                                                                        return
                                                                    }
                                                                    self.updateUIForOrderHistory()
        }) { (inError: NSError) in
            self.resetDataFetchingValue(false)
            super.stopActivityProgressIndicator()
            super.displayErrorMessage(inError, shouldDisplayNoInternetView:(0 == self.filteredOrderCollection.count))
        }
    }

    func updateUIForOrderHistory() {
        title = IAPLocalizedString("iap_my_orders")
        self.noHistoryView.isHidden = true
        self.orderTableView.isHidden = false
        self.orderTableView.reloadData()
    }

    func updateUIForEmptyOrderHistory() {
        title = IAPLocalizedString("iap_my_orders")
        self.noItemsLabel.text = IAPLocalizedString("iap_order_not_received_items")
        self.noItemsEmailLabel.text = IAPLocalizedString("iap_empty_purchase_history_dls")
        self.noItemsOtherSalesLabel.text = IAPLocalizedString("iap_other_channel_dls")
        self.noHistoryView.isHidden = false
        self.orderTableView.isHidden = true
        self.headerView?.backgroundColor = (UIDThemeManager.sharedInstance.defaultTheme?.contentSecondaryNeutralBackground)!
        self.headerTitleLabel?.text = IAPLocalizedString("iap_orders")!
        self.buttonView?.backgroundColor = (UIDThemeManager.sharedInstance.defaultTheme?.contentSecondaryNeutralBackground)!
        self.continueShoppingButton.setTitle(IAPLocalizedString("iap_continue_shopping"), for: .normal)
    }

    // MARK: -
    // MARK: UITableView Datasource and Delegate methods
    // MARK: -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.filteredOrderCollection.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48 // Needs to be checked and removed before commiting it into develop branch !!!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let object = self.filteredOrderCollection[section]
        let count = object.collection.count
        guard self.shouldFetchData() else { return count }
        guard section == self.filteredOrderCollection.count - 1 else { return count }
        return count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = self.filteredOrderCollection[indexPath.section]
        guard indexPath.row == object.collection.count else {
            if let orderCell = tableView.dequeueReusableCell(withIdentifier: IAPCellIdentifier.orderCell,
                                                             for: indexPath) as? IAPPurchaseHistoryOrderCell {
                orderCell.updatewithOrder(purchaseHistory: object.collection[indexPath.row])
                orderCell.addProductsDescriptionView(tableView.frame.size.width)
                return orderCell
            } else {
                return UITableViewCell()
            }
        }

        let loadingCell = tableView.dequeueReusableCell(withIdentifier: IAPCellIdentifier.loadingCell, for: indexPath) as? IAPLoadingCell
        loadingCell?.loadingActivityIndicator.startAnimating()
        return loadingCell!
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let object = self.filteredOrderCollection[indexPath.section]
        guard self.filteredOrderCollection.count > 0 else { return }
        guard indexPath.section + 1 == self.filteredOrderCollection.count else { return }
        guard indexPath.row + 1 == object.collection.count else { return }
        guard self.shouldFetchData() else { return }
        self.resetDataFetchingValue(true)
        self.fetchDataForPage(self.paginationModel.getCurrentPage()+1)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let orderDetail = self.filteredOrderCollection[indexPath.section].collection[indexPath.row]
        getConsumerCareInfo(orderDetailInfo: orderDetail)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = IAPUtility.getBundle().loadNibNamed(IAPNibName.IAPPurchaseHistoryOverviewSectionHeader,
                                                             owner: self, options: nil)![0] as? IAPPurchaseHistoryOverviewSectionHeader
        headerView?.dateLabel.text = self.filteredOrderCollection[section].orderDisplayDate
        headerView?.sectionHeaderView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentSecondaryNeutralBackground
        return headerView
    }

    private func getConsumerCareInfo(orderDetailInfo:IAPPurchaseHistoryModel) {
        guard let inProduct = orderDetailInfo.products.first else { return }
        super.startActivityProgressIndicator()
        let ccInterface = IAPPRXConsumerInterface(inLocale: IAPConfiguration.sharedInstance.locale!,
                                                            inCategoryCode:inProduct.getSubCategory())
        ccInterface.getConsumerCareInformation(ccInterface.getInterfaceForConsumerCare(), completionHandler: { (withConsumerCare) in
            super.stopActivityProgressIndicator()
            self.pushToOrderDetailView(consumerCareInfo: withConsumerCare, orderDetailData: orderDetailInfo)
        }) { (inError: NSError) -> () in
            super.stopActivityProgressIndicator()
            super.displayErrorMessage(inError)
        }
    }

    private func pushToOrderDetailView(consumerCareInfo: IAPPRXConsumerModel,
                                       orderDetailData: IAPPurchaseHistoryModel) {
        let purchaseHistoryNewDetailController = IAPPurchaseHistoryNewDetailViewController.instantiateFromAppStoryboard(appStoryboard: .purchaseHistory)
        purchaseHistoryNewDetailController.orderDetail = orderDetailData
        purchaseHistoryNewDetailController.cartIconDelegate = self.cartIconDelegate
        purchaseHistoryNewDetailController.consumerCareInfo = consumerCareInfo
        navigationController?.pushViewController(purchaseHistoryNewDetailController, animated: true)
    }
}
