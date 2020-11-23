/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

// swiftlint:disable file_length

import PhilipsEcommerceSDK
import PhilipsUIKitDLS

let headerHeight: CGFloat = 40
let popoverMaxHeight = 200
let cellHeight = 44

class MECShoppingCartViewController: MECBaseViewController {

    var presenter: MECShoppingCartPresenter!
    @IBOutlet weak var shoppingCartTableView: UITableView!
    @IBOutlet weak var noCartView: MECNoCartView!
    @IBOutlet weak var bottomView: MECShoppingCartBottomView!

    var tableDataSource: [MECShoppingCartTableDataProvider] = []
    var hintShown = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = MECLocalizedString("mec_shopping_cart_title")
        presenter = MECShoppingCartPresenter()
        presenter.shoppingCartDelegate = self
        noCartView.configureUI()
        shoppingCartTableView.isHidden = true
        bottomView.updateUIFor(viewType: .shoppingCart)
        guard let cartDataBus = presenter.dataBus else {
            return
        }
        tableDataSource = [MECCartProductDataProvider(cartDataBus: cartDataBus),
                           MECApplyVoucherDataProvider(cartDataBus: cartDataBus),
                           MECAppliedVoucherDataProvider(cartDataBus: cartDataBus),
                           MECSummaryProoductDataProvider(cartDataBus: cartDataBus),
                           MECOrderPromotionDataProvider(cartDataBus: cartDataBus),
                           MECSummaryVoucherDataProvider(cartDataBus: cartDataBus),
                           MECDeliveryCostDataProvider(cartDataBus: cartDataBus)]

        for data in tableDataSource {
            data.registerCell(for: shoppingCartTableView)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackPage(pageName: MECAnalyticPageNames.shoppingCartPage)

        initialize { [weak self] (_, error) in
            guard let weakSelf = self else { return }
            guard error == nil else {
                let okButton = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                    self?.trackNotification(message: error?.localizedDescription ?? "", response: MECEnglishString("mec_ok"))
                }
                self?.showAlert(title: MECLocalizedString("mec_shopping_cart_title"),
                          message: error?.localizedDescription,
                          okButton: okButton,
                          cancelButton: nil)
                self?.refreshUI()
                self?.bottomView.continueShoppingButton.isEnabled = false
                return
            }

            if weakSelf.presenter.numberOfProductInCart() == 0 {
                weakSelf.startActivityProgressIndicator()
            } else {
                weakSelf.startActivityProgressIndicator(shouldCoverFull: false, messageText: "")
            }
            weakSelf.presenter.fetchShoppingCart { (_, error) in
                if error == nil {
                    let param = [MECAnalyticsConstants.specialEvents: MECAnalyticsConstants.scView,
                                 MECAnalyticsConstants.productListKey:
                                    weakSelf.preparePILCartEntryListString(entries: weakSelf.presenter.cartProductList())]
                    weakSelf.trackAction(parameterData: param)
                }
            }
        }

        NotificationCenter.default.addObserver(self, selector: #selector(MECShoppingCartViewController.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MECShoppingCartViewController.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            shoppingCartTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        shoppingCartTableView.contentInset = .zero
    }

    func updateShoppingCartProductCell(productCell: MECShoppingCartProductCell, entry: ECSPILItem?) {
        guard let cartEntry = entry else { return }
        productCell.configureUI()
        productCell.productTitle.text = cartEntry.title
        productCell.productCTN.text = "\(cartEntry.ctn ?? "")"
        productCell.reviewCount.text = "(\(presenter.totalNumberOfReviewsForProduct(ctn: entry?.ctn)))"
        let averageProductRating = presenter.averageRatingForProduct(ctn: entry?.ctn).rounded(digits: 1)
        productCell.ratingBar.ratingText = "\(averageProductRating)"
        productCell.ratingBar.ratingValue = CGFloat(averageProductRating)

        if let discountedPrice = cartEntry.discountPrice, cartEntry.price?.value ?? 0 > discountedPrice.value ?? 0 {
            productCell.productDiscountedPrice.text = cartEntry.discountPrice?.formattedValue
            productCell.productActualPrice.setStrikeThroughAttributedText(cartEntry.price?.formattedValue)
        } else {
            productCell.productDiscountedPrice.text = cartEntry.price?.formattedValue
            productCell.productActualPrice.text = ""
        }
        if let discount = presenter.discountPercentage(for: entry) {
            productCell.discountBaseView.isHidden = false
            productCell.discountLabel.text = discount
        } else {
            productCell.discountBaseView.isHidden = true
        }
        if let imageURLString = cartEntry.image,
            let imageURL = URL(string: imageURLString) {
            productCell.productImageView.setImageWith(imageURL, placeholderImage: nil)
        }
        productCell.productQuantityButton.setTitle("\(entry?.quantity ?? 0)", for: .normal)
        productCell.lowStockWarningLabel.attributedText = presenter.getStockStatusMessage(entry: cartEntry)
        MECUtility.shouldShowSRP(for: cartEntry) { (shouldShow) in
            productCell.suggestedRetailerPriceLabel.isHidden = !shouldShow
        }
    }

    @IBAction func checkoutButtonClicked(_ sender: Any) {

        trackAction(parameterData: [MECAnalyticsConstants.specialEvents: MECAnalyticsConstants.scCheckout,
                                    MECAnalyticsConstants.productListKey:
                                        preparePILCartEntryListString(entries: presenter.cartProductList())])

        guard MECConfiguration.shared.maximumCartCount > 0, presenter.totalCartQuantity() > MECConfiguration.shared.maximumCartCount else {
            startActivityProgressIndicator(shouldCoverFull: false)
            presenter.fetchSavedAddresses { [weak self] (addresses, error) in
                DispatchQueue.main.async {
                    self?.stopActivityProgressIndicator()
                    guard error == nil else {
                        let okButton = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                            self?.trackNotification(message: error?.localizedDescription ?? "", response: MECEnglishString("mec_ok"))
                        }
                        self?.showAlert(title: MECLocalizedString("mec_shopping_cart_title"),
                                        message: error?.localizedDescription, okButton: okButton, cancelButton: nil)
                        return
                    }
                    if let addresses = addresses, addresses.count > 0 {
                        self?.loadDeliveryDetailsScreenWith(savedAddresses: addresses)
                    } else {
                        self?.loadAddressScreen()
                    }
                }
            }
            return
        }
        let okAction = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
            self.trackNotification(message: String(format: MECEnglishString("mec_cart_count_exceed_message"),
                                                   MECConfiguration.shared.maximumCartCount),
                                   response: MECEnglishString("mec_ok"))
        }
        showAlert(title: MECLocalizedString("mec_shopping_cart_title"),
                  message: String(format: MECLocalizedString("mec_cart_count_exceed_message"),
                                             MECConfiguration.shared.maximumCartCount),
                  okButton: okAction, cancelButton: nil)
    }

    func refreshUI() {
        if presenter.numberOfProductInCart() > 0 {
            shoppingCartTableView.reloadData()
            if let cell = shoppingCartTableView.cellForRow(at:
                IndexPath(row: 0, section: 0)) as? MECShoppingCartProductCell, hintShown == false {
                hintShown = true
                cell.animateSwipeHint()
            }
            shoppingCartTableView.isHidden = false
            bottomView.updateUIFor(totalProductsCount: presenter.numberOfProductInCart(),
                                   tax: presenter.totalTax(),
                                   totalPrice: presenter.totalPrice())
            bottomView.continueCheckoutButton.isEnabled = presenter.shouldEnableCheckout()
        } else {
            shoppingCartTableView.isHidden = true
            bottomView.updateViewForEmptyCart()
        }
        noCartView.isHidden = !shoppingCartTableView.isHidden
        stopActivityProgressIndicator()
    }

    @IBAction func continueButtonClicked(_ sender: Any) {
        trackAction(parameterData: [MECAnalyticsConstants.specialEvents: MECAnalyticsConstants.continueShoppingSelected,
                                    MECAnalyticsConstants.productListKey:
                                        preparePILCartEntryListString(entries: presenter.cartProductList())])

        navigationController?.moveToProductCatalogueScreen()
    }

    func loadAddressScreen() {
        if let addressScreen = MECAddAddressViewController.instantiateFromAppStoryboard(appStoryboard: .addAddress) {
            presenter.dataBus?.paymentsInfo = MECPaymentsInfo()
            let addressPresenter = MECAddAddressPresenter(addressDataBus: self.presenter.dataBus)
            addressScreen.addressScreenType = .addFirstAddress
            addressScreen.presenter = addressPresenter
            navigationController?.pushViewController(addressScreen, animated: true)
        }
    }

    func loadDeliveryDetailsScreenWith(savedAddresses: [ECSAddress]?) {
        if let deliveryDetails = MECDeliveryDetailsViewController.instantiateFromAppStoryboard(appStoryboard: .deliveryDetails) {
            let presenter = MECDeliveryDetailsPresenter(deliveryDetailsDataBus: self.presenter.dataBus)
            self.presenter.dataBus?.savedAddresses = savedAddresses
            deliveryDetails.presenter = presenter
            navigationController?.pushViewController(deliveryDetails, animated: true)
        }
    }
}

extension MECShoppingCartViewController: MECShoppingCartDelegate {

    func shoppingCartLoaded() {
        if let voucherID = MECConfiguration.shared.voucherCode, voucherID.count > 0,
            presenter.shouldShowApplyVoucher(), !presenter.isVoucherAlreadyApplied(voucherId: voucherID) {
            presenter.applyVoucherToCart(voucherId: voucherID) { [weak self](_, error) in
                self?.refreshUI()
                if error != nil {
                    let okAction = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                        self?.trackNotification(message: (error?.localizedDescription ?? ""), response: MECEnglishString("mec_ok"))
                    }
                    self?.showAlert(title: MECLocalizedString("mec_shopping_cart_title"),
                                    message: error?.localizedDescription, okButton: okAction, cancelButton: nil)
                }
            }
        } else {
            refreshUI()
        }
    }

    func showError(error: Error?) {
        if presenter.isCartLoaded() && presenter.numberOfProductInCart() == 0 {
            bottomView.updateViewForEmptyCart()
        }
        let okButton = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
            self.trackNotification(message: error?.localizedDescription ?? "", response: MECEnglishString("mec_ok"))
        }
        showAlert(title: MECLocalizedString("mec_shopping_cart_title"),
                  message: error?.localizedDescription,
                  okButton: okButton, cancelButton: nil)
        stopActivityProgressIndicator()
        shoppingCartTableView.reloadData()
    }
}

extension MECShoppingCartViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return tableDataSource.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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

        if let tableCell = dataSource.tableView(tableView, cellForRowAt: indexPath) as? MECShoppingCartProductCell {
            tableCell.delegate = self
            updateShoppingCartProductCell(productCell: tableCell,
                                          entry: presenter.cartProductEntryAtIndex(productIndex: indexPath.row))
            return tableCell
        } else if let tableCell = dataSource.tableView(tableView, cellForRowAt: indexPath) as? MECApplyVoucherCell {
            tableCell.voucherTextField.delegate = self
            tableCell.applyVoucherDelegate = self
            return tableCell
        } else if let tableCell = dataSource.tableView(tableView, cellForRowAt: indexPath) as? MECAppliedVoucherCell {
            tableCell.delegate = self
            return tableCell
        } else {
            return dataSource.tableView(tableView, cellForRowAt: indexPath)
        }
    }

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return getDeleteButton(for: indexPath)
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return getDeleteButton(for: indexPath)
    }

    private func getDeleteButton(for indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.section == 0 else { return UISwipeActionsConfiguration(actions: []) }
        let deleteAction = UIContextualAction(style: .destructive, title: nil,
                                              handler: { (_, _, _: (Bool) -> Void) in
                                                self.deleteClicked(at: indexPath)
        })
        deleteAction.image = UIImage.imageWithMECIconFontType(.delete, iconSize: UIDSize24, iconColor: .white)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    private func deleteClicked(at indexPath: IndexPath) {
        if let cell = shoppingCartTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? MECApplyVoucherCell {
            cell.voucherTextField.resignFirstResponder()
        }
        let deleteAction = UIDAction(title: MECLocalizedString("mec_delete"), style: .primary) { (_) in
            self.trackNotification(message: MECEnglishString("mec_delete_product_confirmation_title"),
                              response: MECEnglishString("mec_delete"))
            self.startActivityProgressIndicator(shouldCoverFull: false, messageText: "")
            self.presenter.deleteProductAtIndex(productIndex: indexPath.row)
        }
        let cancelAction = UIDAction(title: MECLocalizedString("mec_cancel"), style: .secondary) { (_) in
            self.trackNotification(message: MECEnglishString("mec_delete_product_confirmation_title"),
                              response: MECEnglishString("mec_cancel"))
            self.shoppingCartTableView.reloadSections(IndexSet(0...0), with: .automatic)
        }
        self.showAlert(title: MECLocalizedString("mec_shopping_cart_title"),
                       message: MECLocalizedString("mec_delete_product_confirmation_title"),
                       okButton: cancelAction, cancelButton: deleteAction)
    }
}

extension MECShoppingCartViewController: MECShoppingCartProductDelegate {

    func didClickOnChangeQuantity(productCell: MECShoppingCartProductCell) {
        let cellIndex = shoppingCartTableView.indexPath(for: productCell)?.row ?? 0
        guard let productEntry = presenter.cartProductEntryAtIndex(productIndex: cellIndex) else { return }
        if let quantity = productEntry.availability?.quantity, quantity > 1 {
            let permittedQuantity = min(quantity, MECConstants.MECMaximumCartUpdateQuantity)
            var quantityArray: [String] = []
            for index in 0..<permittedQuantity {
                quantityArray.append("\(index + 1)")
            }

            let popoverVC = MECPopoverViewController.instantiateFromAppStoryboard(appStoryboard: .popoverList)
            popoverVC?.popoverItems = quantityArray

            let popoverHeight = (quantityArray.count * cellHeight) < popoverMaxHeight ?
                (quantityArray.count * cellHeight) : popoverMaxHeight
            popoverVC?.displayPopoverMenu(productCell.productQuantityLabel,
                                          presentationController: popoverVC ?? UIViewController(),
                                          presentingController: self,
                                          preferredContentSize: CGSize(width: 80, height: popoverHeight),
                                          completionHandler: { [weak self] (itemIndex: Int) -> Void in

                                    guard itemIndex < quantityArray.count else { return }
                                    productCell.productQuantityButton.setTitle(quantityArray[itemIndex], for: .normal)
                                    self?.dismiss(animated: true, completion: {
                                        let newQuantity = itemIndex + 1
                                        guard newQuantity != productEntry.quantity else { return }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            self?.startActivityProgressIndicator(shouldCoverFull: false, messageText: "")
                                            self?.presenter.updateShoppingCart(quantity: newQuantity, entry: productEntry)
                                        }
                                    })
            })
        }
    }
}

extension MECShoppingCartViewController: MECApplyVoucherDelegate {
    func didClickOnApplyVoucher(voucherCell: MECApplyVoucherCell, voucherId: String) {
        shoppingCartTableView.beginUpdates()
        voucherCell.showVoucherError(errorMessage: nil)
        shoppingCartTableView.endUpdates()

        startActivityProgressIndicator(shouldCoverFull: false, messageText: "")
        presenter.applyVoucherToCart(voucherId: voucherId) { [weak self](_, error) in
            self?.stopActivityProgressIndicator()
            guard let voucherError = error else {
                self?.shoppingCartTableView.reloadData()
                return
            }
            self?.shoppingCartTableView.beginUpdates()
            voucherCell.showVoucherError(errorMessage: voucherError.localizedDescription)
            self?.shoppingCartTableView.endUpdates()
        }
    }
}

extension MECShoppingCartViewController: MECAppliedVoucherDelegate {
    func didClickOnDeleteVoucher(cell: MECAppliedVoucherCell) {
        guard let indexPath = shoppingCartTableView.indexPath(for: cell) else { return }

        let deleteAction = UIDAction(title: MECLocalizedString("mec_delete"), style: .primary) { (_) in
            self.trackNotification(message: MECEnglishString("mec_delete_voucher_confirmation_title"),
                                   response: MECEnglishString("mec_delete"))
            self.startActivityProgressIndicator(shouldCoverFull: false, messageText: "")
            self.presenter.deleteVoucher(at: indexPath.row) {[weak self] (_, _) in
                self?.stopActivityProgressIndicator()
            }
        }

        let cancelAction = UIDAction(title: MECLocalizedString("mec_cancel"), style: .secondary) { (_) in
            self.trackNotification(message: MECEnglishString("mec_delete_voucher_confirmation_title"),
                              response: MECEnglishString("mec_cancel"))
        }
        showAlert(title: MECLocalizedString("mec_shopping_cart_title"),
                  message: MECLocalizedString("mec_delete_voucher_confirmation_title"),
                  okButton: cancelAction,
                  cancelButton: deleteAction)
    }
}

extension MECShoppingCartViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let voucherTextField = textField as? UIDTextField, voucherTextField.text?.count == 0 {
            shoppingCartTableView.beginUpdates()
            voucherTextField.setValidationView(false)
            voucherTextField.validationMessage = ""
            shoppingCartTableView.endUpdates()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
// swiftlint:enable file_length
