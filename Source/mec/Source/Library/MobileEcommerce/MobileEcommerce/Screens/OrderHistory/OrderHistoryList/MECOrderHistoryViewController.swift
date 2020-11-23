/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS
import PhilipsIconFontDLS
import PhilipsEcommerceSDK
import AFNetworking

class MECOrderHistoryViewController: MECBaseViewController {

    @IBOutlet weak var orderHistoryTableView: UITableView!
    @IBOutlet weak var noOrderInstructionView: UIDView!
    @IBOutlet weak var noOrderMainView: UIDView!
    @IBOutlet weak var noOrderTitleLabel: UIDLabel!
    @IBOutlet weak var noOrderIconLabel: UIDLabel!
    @IBOutlet weak var noOrderStatusLabel: UIDLabel!
    @IBOutlet weak var noOrderInstructionFirstLabel: UIDLabel!
    @IBOutlet weak var noOrderInstructionSecondLabel: UIDLabel!

    var presenter: MECOrderHistoryPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MECOrderHistoryPresenter()
        customizeUI()
        initialize { [weak self] (_, error) in
            guard let weakSelf = self else { return }
            guard error == nil else {
                DispatchQueue.main.async {
                    let okButton = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                        weakSelf.dismissOrderHistoryView()
                    }
                    weakSelf.showAlert(title: MECLocalizedString("mec_orders"),
                                       message: error?.localizedDescription,
                                       okButton: okButton,
                                       cancelButton: nil)
                }
                return
            }
            DispatchQueue.main.async {
                weakSelf.startActivityProgressIndicator()
            }
            weakSelf.presenter.fetchOrderHistory { (error) in
                DispatchQueue.main.async {
                    weakSelf.stopActivityProgressIndicator()
                    guard error == nil else {
                        let okButton = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                            weakSelf.dismissOrderHistoryView()
                        }
                        weakSelf.showAlert(title: MECLocalizedString("mec_orders"),
                                           message: error?.localizedDescription,
                                           okButton: okButton,
                                           cancelButton: nil)
                        return
                    }
                    weakSelf.presenter.fetchTotalNumberOfOrders() > 0 ?
                        weakSelf.configureViewForOrder() :
                        weakSelf.configureViewForNoOrder()
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackPage(pageName: MECAnalyticPageNames.orderHistory)
    }
}

extension MECOrderHistoryViewController {

    func customizeUI() {
        navigationItem.title = MECLocalizedString("mec_my_orders")
        orderHistoryTableView.estimatedRowHeight = 200
        orderHistoryTableView.rowHeight = UITableView.automaticDimension
        orderHistoryTableView.register(UINib(nibName: MECNibName.MECLoadingCell, bundle: MECUtility.getBundle()),
                                       forCellReuseIdentifier: MECCellIdentifier.MECProductReviewLoadingCell)
    }

    func customizeNoOrderViewUI() {
        view.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentSecondaryNeutralBackground
        noOrderTitleLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
        noOrderIconLabel.font = UIFont.iconFont(size: UIDSize16)
        noOrderIconLabel.text = PhilipsDLSIcon.unicode(iconType: .exclamationCircle)
        noOrderIconLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSignalTextInfo
        noOrderStatusLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSignalTextInfo
        noOrderInstructionFirstLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSecondaryText
        noOrderInstructionSecondLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSecondaryText
        noOrderInstructionFirstLabel.text(MECLocalizedString("mec_empty_purchase_history"), lineSpacing: UIDSize8/2)
        noOrderInstructionSecondLabel.text(MECLocalizedString("mec_other_channel_purchase"), lineSpacing: UIDSize8/2)
    }

    func configureViewForNoOrder() {
        customizeNoOrderViewUI()
        noOrderMainView.isHidden = false
        orderHistoryTableView.isHidden = true
    }

    func configureViewForOrder() {
        noOrderMainView.isHidden = true
        orderHistoryTableView.isHidden = false
        orderHistoryTableView.reloadData()
    }

    func dismissOrderHistoryView() {
        if isModal() {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    func configureOrderHistoryCell(orderHistoryCell: MECOrderHistoryProductDetailCell?, with order: ECSOrder) {
        orderHistoryCell?.orderStatusLabel.text = String(format: MECLocalizedString("mec_order_state"), order.statusDisplay ?? "")
        orderHistoryCell?.orderIDLabel.text = String(format: MECLocalizedString("mec_order_number_msg"), order.orderID ?? "")
        orderHistoryCell?.orderTotalValueLabel.text = order.total?.formattedValue
        if let products = order.orderDetails?.entries, products.count > 0 {
            for productDetail in products {
                if let orderDetailView = createOrderDetailViewFor(productDetail: productDetail) {
                    orderHistoryCell?.orderProductsStackView.addArrangedSubview(orderDetailView)
                }
            }
        } else {
            if let noProductDetailView = createNoProductDetailView() {
                orderHistoryCell?.orderProductsStackView.addArrangedSubview(noProductDetailView)
                orderHistoryCell?.orderAccessoryLabel.isHidden = true
            }
        }
    }

    func createOrderDetailViewFor(productDetail: ECSEntry) -> UIView? {
        let nib = UINib(nibName: MECNibName.MECOrderHistoryProductDetailView, bundle: MECUtility.getBundle())
        if let orderDetailView = nib.instantiate(withOwner: nil, options: nil).first as? MECOrderHistoryProductDetailView {
            orderDetailView.translatesAutoresizingMaskIntoConstraints = false
            orderDetailView.customizeUI()
            if let imageURL = URL(string: presenter.fetchProductImageURLFor(orderEntry: productDetail)) {
                AFImageDownloader.defaultInstance().sessionManager
                    .responseSerializer
                    .acceptableContentTypes?
                    .insert(MECImageDownloadSpecialFormats.MECJP2Format)
                orderDetailView.productImageView.setImageWith(imageURL, placeholderImage: nil)
            }
            orderDetailView.productTitleLabel.text(productDetail.product?.productPRXSummary?.productTitle ?? "", lineSpacing: UIDSize8/2)
            orderDetailView.productQuantityLabel.text = "\(MECLocalizedString("mec_quantity")): \(productDetail.quantity ?? 0)"
            return orderDetailView
        }
        return nil
    }

    func createNoProductDetailView() -> UIView? {
        let nib = UINib(nibName: MECNibName.MECNoOrderDetailView, bundle: MECUtility.getBundle())
        if let noOrderDetailView = nib.instantiate(withOwner: nil, options: nil).first as? MECNoOrderDetailView {
            noOrderDetailView.translatesAutoresizingMaskIntoConstraints = false
            noOrderDetailView.customizeUI()
            return noOrderDetailView
        }
        return nil
    }

    func createOrderLoadingCellFor(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let orderLoadingCell = tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECProductReviewLoadingCell,
                                                             for: indexPath) as? MECLoadingCell
        orderLoadingCell?.loadingIndicator.startAnimating()
        orderLoadingCell?.selectionStyle = .none
        orderLoadingCell?.isUserInteractionEnabled = false
        return orderLoadingCell ?? UITableViewCell()
    }

    @IBAction func continueShoppingButtonClicked(_ sender: UIDButton) {
        navigationController?.popToProductListScreen()
    }
}

extension MECOrderHistoryViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.fetchTotalNumberOfOrders()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let orderCount = presenter.fetchNumberOfOrderFor(section: section)
        guard presenter.shouldLoadMoreOrders() else { return orderCount }
        guard section == presenter.fetchTotalNumberOfOrders() - 1 else { return orderCount }
        return orderCount + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderCount = presenter.fetchNumberOfOrderFor(section: indexPath.section)
        guard indexPath.row == orderCount else {
            let orderHistoryCell = tableView.dequeueReusableCell(withIdentifier:
                MECCellIdentifier.MECOrderHistoryProductDetailCell) as? MECOrderHistoryProductDetailCell
            orderHistoryCell?.customizeUI()
            if let order = presenter.fetchOrderFor(indexPath: indexPath) {
                configureOrderHistoryCell(orderHistoryCell: orderHistoryCell, with: order)
            }
            return orderHistoryCell ?? UITableViewCell()
        }
        return createOrderLoadingCellFor(tableView: tableView, indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let orderCount = presenter.fetchNumberOfOrderFor(section: indexPath.section)
        let count = presenter.fetchTotalNumberOfOrders()
        guard count > 0 else { return }
        guard indexPath.section + 1 == count else { return }
        guard indexPath.row + 1 == orderCount else { return }
        guard presenter.shouldLoadMoreOrders() else { return }
        presenter.fetchOrderHistory { [weak self] (error) in
            if error != nil {
                self?.presenter.paginationHandler.isDataFetching = true
            }
            DispatchQueue.main.async {
                self?.orderHistoryTableView.reloadData()
            }
        }
    }
}

extension MECOrderHistoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let orderDetailVC = MECOrderDetailViewController.instantiateFromAppStoryboard(appStoryboard: .orderDetail),
            let order = presenter.fetchOrderFor(indexPath: indexPath)?.orderDetails,
            let products = order.entries, products.count > 0 {
            orderDetailVC.presenter = MECOrderDetailPresenter(with: order)
            trackAction(parameterData: [MECAnalyticsConstants.specialEvents: MECAnalyticsConstants.orderClick,
                                        MECAnalyticsConstants.productListKey: prepareCartEntryListString(entries: order.entries),
                                        MECAnalyticsConstants.transactionID: order.orderID ?? ""])
            self.navigationController?.pushViewController(orderDetailVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIDHeaderView.createMECHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
        headerView.headerLabel.text = presenter.fetchOrderDisplayDateFor(section: section)
        headerView.headerLabel.accessibilityIdentifier = "mec_order_history_header_label"
        headerView.layer.borderWidth = 1.0
        headerView.layer.borderColor = UIDThemeManager.sharedInstance.defaultTheme?.separatorContentBackground?.cgColor
        return headerView
    }
}
