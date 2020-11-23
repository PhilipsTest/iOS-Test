/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS
import PhilipsEcommerceSDK
import SafariServices

class MECOrderSummaryViewController: MECBaseViewController {

    @IBOutlet weak var orderSummaryTableView: UITableView!
    @IBOutlet weak var bottomView: MECShoppingCartBottomView!
    @IBOutlet weak var privacyLinkLabel: UIDHyperLinkLabel!

    var presenter: MECOrderSummaryPresenter!

    var tableDataSource: [MECShoppingCartTableDataProvider] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = MECLocalizedString("mec_checkout")
        bottomView.updateUIFor(viewType: .orderSummary)

        guard let cartDataBus = presenter.dataBus else {
            return
        }
        tableDataSource = [MECCheckoutStepProvider(with: cartDataBus),
                           MECCheckoutShippingDataProvider(with: cartDataBus),
                           MECCheckoutPaymentDataProvider(with: cartDataBus),
                           MECCheckoutVoucherDataProvider(with: cartDataBus),
                           MECCheckoutProductDataProvider(with: cartDataBus),
                           MECOrderPromotionDataProvider(cartDataBus: cartDataBus),
                           MECDeliveryCostDataProvider(cartDataBus: cartDataBus),
                           MECSummaryVoucherDataProvider(cartDataBus: cartDataBus)]

        for data in tableDataSource {
            data.registerCell(for: orderSummaryTableView)
        }
        bottomView.updateUIFor(totalProductsCount: presenter.numberOfProductInCart(),
                               tax: presenter.totalTax(), totalPrice: presenter.totalPrice())
        constructPrivacyLabel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackPage(pageName: MECAnalyticPageNames.orderSummaryPage)
    }

    func constructPrivacyLabel() {
        presenter.shouldShowPrivacy { [weak self] (shouldShow) in
            guard shouldShow == true else {
                self?.privacyLinkLabel.isHidden = true
                return
            }
            self?.privacyLinkLabel.isHidden = false
            // swiftlint:disable line_length
            let privacyMessage = "\(MECLocalizedString("mec_read_privacy")) \(MECLocalizedString("mec_privacy")) \(MECLocalizedString("mec_questions")) \(MECLocalizedString("mec_faq")) \(MECLocalizedString("mec_page")) \(MECLocalizedString("mec_accept_terms")) \(MECLocalizedString("mec_terms_conditions"))"
            // swiftlint:enable line_length
            self?.privacyLinkLabel.text = privacyMessage
            self?.addPrivacyLinkModel()
            self?.addFAQLinkModel()
            self?.addTemsConditionLinkModel()
        }
    }

    func addPrivacyLinkModel() {
        let range = privacyLinkLabel.text?.nsRange(of: MECLocalizedString("mec_privacy"))
        let linkMode = UIDHyperLinkModel()
        linkMode.highlightRange = range
        privacyLinkLabel.addLink(linkMode) { (_) in
            self.presenter.getPrivacyURL { [weak self] (url) in
                self?.loadURL(url: url)
            }
        }
    }

    func addFAQLinkModel() {
        let range = privacyLinkLabel.text?.nsRange(of: MECLocalizedString("mec_faq"))
        let linkMode = UIDHyperLinkModel()
        linkMode.highlightRange = range
        privacyLinkLabel.addLink(linkMode) { (_) in
            self.presenter.getFAQUrl { [weak self] (url) in
                self?.loadURL(url: url)
            }
        }
    }

    func addTemsConditionLinkModel() {
        let range = privacyLinkLabel.text?.nsRange(of: MECLocalizedString("mec_terms_conditions"))
        let linkMode = UIDHyperLinkModel()
        linkMode.highlightRange = range
        privacyLinkLabel.addLink(linkMode) { (_) in
            self.presenter.getTermsURL { [weak self] (url) in
                self?.loadURL(url: url)
            }
        }
    }

    func loadURL(url: String?) {
        if let urlString = url, let urlObject = URL(string: urlString) {
            let safariVC = SFSafariViewController(url: urlObject)
            present(safariVC, animated: true, completion: nil)
        }
    }

    @IBAction func backToShoppingCartButtonClicked(_ sender: Any) {
        navigationController?.moveToShoppingCartScreen()
    }

    @IBAction func orderAndPayButtonClicked(_ sender: Any) {
        if presenter.isFirstTimePayment() {
            submitOrderForFirstTimePayment()
        } else {
            loadCVVScreen()
        }
    }

    func loadCVVScreen() {
        if let cvvPaymentViewController = MECCVVPaymentViewController.instantiateFromAppStoryboard(appStoryboard: .cvvPayment) {
            let cvvPaymentNavigationController = UINavigationController(rootViewController: cvvPaymentViewController)
            cvvPaymentViewController.delegate = self
            let cvvPresenter = MECOrderSummaryPresenter(with: presenter.dataBus)
            cvvPaymentViewController.presenter = cvvPresenter
            cvvPaymentNavigationController.modalPresentationStyle = .overCurrentContext
            present(cvvPaymentNavigationController, animated: true, completion: nil)
        }
    }

    func submitOrderForFirstTimePayment() {
        startActivityProgressIndicator(shouldCoverFull: false, messageText: "")
        presenter.submitOrder(with: "") { [weak self](orderDetail, error) in
            guard let orderError = error else {
                self?.makePayment(for: orderDetail)
                return
            }
            self?.stopActivityProgressIndicator()
            let action = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                self?.trackNotification(message: orderError.localizedDescription, response: MECEnglishString("mec_ok"))
            }
            self?.showAlert(title: MECLocalizedString("mec_checkout"),
                            message: orderError.localizedDescription,
                            okButton: action,
                            cancelButton: nil)
        }
    }

    func makePayment(for order: ECSOrderDetail?) {
        presenter.makePayment(for: order) {[weak self] (paymentProvider, error) in
            guard let orderError = error else {
                self?.showWorldPayScreen(paymentURL: paymentProvider?.paymentProviderURL, orderDetail: order)
                return
            }
            self?.stopActivityProgressIndicator()
            let okAction = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary, handler: {(_) in
                self?.trackNotification(message: orderError.localizedDescription, response: MECEnglishString("mec_ok"))
                self?.navigationController?.popToProductListScreen()
            })
            self?.showAlert(title: MECLocalizedString("mec_checkout"),
                            message: orderError.localizedDescription,
                            okButton: okAction,
                            cancelButton: nil)
        }
    }

    func showWorldPayScreen(paymentURL: String?, orderDetail: ECSOrderDetail?) {
        if let paymentURL = paymentURL {
            let worldPay = MECWorldPayViewController()
            worldPay.worldPayURL = paymentURL
            worldPay.orderDetail = orderDetail
            self.navigationController?.pushViewController(worldPay, animated: true)
        }
    }
}

extension MECOrderSummaryViewController: MECViewControllerDismissDelegate {
    func viewControllerDidDismiss() {
        trackPage(pageName: MECAnalyticPageNames.orderSummaryPage)
    }
}

extension MECOrderSummaryViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableDataSource.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < tableDataSource.count else { return 0 }
        return tableDataSource[section].tableView(tableView, numberOfRowsInSection: section)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section < tableDataSource.count else { return 0 }
        return tableDataSource[section].tableView(tableView, heightForHeaderInSection: section)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section < tableDataSource.count else { return nil }
        return tableDataSource[section].tableView(tableView, viewForHeaderInSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section < tableDataSource.count else { return UITableViewCell() }
        let dataSource = tableDataSource[indexPath.section]
        return dataSource.tableView(tableView, cellForRowAt: indexPath)
    }
}
