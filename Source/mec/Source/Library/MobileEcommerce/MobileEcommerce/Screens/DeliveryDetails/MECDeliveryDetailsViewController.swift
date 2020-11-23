/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

// swiftlint:disable file_length

import PhilipsUIKitDLS
import PhilipsEcommerceSDK

class MECDeliveryDetailsViewController: MECBaseViewController {

    @IBOutlet weak var deliveryDetailsTableView: UITableView!
    @IBOutlet weak var bottomView: UIDView!
    @IBOutlet weak var paymentDetailsCollectionView: UICollectionView!
    var presenter: MECDeliveryDetailsPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = MECLocalizedString("mec_delivery")
        startActivityProgressIndicator()
        deliveryDetailsTableView.rowHeight = UITableView.automaticDimension
        deliveryDetailsTableView.estimatedRowHeight = 60
        if let theme = UIDThemeManager.sharedInstance.defaultTheme {
            let dropShadow = UIDDropShadow(level: .level3, theme: theme)
            bottomView.apply(dropShadow: dropShadow)
        }
        fetchSavedPaymentMethods()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackPage(pageName: MECAnalyticPageNames.deliveryDetailPage)
        startActivityProgressIndicator(shouldCoverFull: false, messageText: "")
        presenter.setUpShippingAddress { [weak self] in
            self?.fetchDeliveryModes()
            DispatchQueue.main.async {
                self?.stopActivityProgressIndicator()
                self?.deliveryDetailsTableView.reloadData()
            }
        }
    }
}

extension MECDeliveryDetailsViewController {

    @IBAction func continueButtonClicked(_ sender: Any) {

        guard presenter.shippingAddress != nil else {
            let errorMessage = MECLocalizedString("mec_no_address_select_message")
            let okButton = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                self.trackNotification(message: MECEnglishString("mec_no_address_select_message"),
                                       response: MECEnglishString("mec_ok"))
            }
            showAlert(title: MECLocalizedString("mec_address"), message: errorMessage, okButton: okButton, cancelButton: nil)
            trackUserError(errorMessage: MECEnglishString("mec_no_address_select_message"))
            return
        }

        guard presenter.dataBus?.shoppingCart?.data?.attributes?.deliveryMode != nil else {
            let errorMessage = MECLocalizedString("mec_no_delivery_mode_error_message")
            let okButton = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                self.trackNotification(message: MECEnglishString("mec_no_delivery_mode_error_message"),
                                       response: MECEnglishString("mec_ok"))
            }
            showAlert(title: MECLocalizedString("mec_address"), message: errorMessage, okButton: okButton, cancelButton: nil)
            trackUserError(errorMessage: MECEnglishString("mec_no_delivery_mode_error_message"))
            return
        }

        guard presenter.dataBus?.shoppingCart?.data?.attributes?.deliveryMode?.isCollectionPoint ?? false == false else {
            let errorMessage = MECLocalizedString("mec_no_delivery_mode_error_message")
            let okButton = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                self.trackNotification(message: MECEnglishString("mec_no_delivery_mode_error_message"),
                                       response: MECEnglishString("mec_ok"))
            }
            showAlert(title: MECLocalizedString("mec_address"), message: errorMessage, okButton: okButton, cancelButton: nil)
            trackUserError(errorMessage: MECEnglishString("mec_no_delivery_mode_error_message"))
            return
        }

        guard presenter.dataBus?.paymentsInfo?.selectedPayment != nil else {
            let errorMessage = MECLocalizedString("mec_no_payment_error_message")
            let okButton = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                self.trackNotification(message: MECEnglishString("mec_no_payment_error_message"),
                                       response: MECEnglishString("mec_ok"))
            }
            showAlert(title: MECLocalizedString("mec_address"), message: errorMessage, okButton: okButton, cancelButton: nil)
            trackUserError(errorMessage: MECEnglishString("mec_no_payment_error_message"))
            return
        }
        navigateToOrderSummaryScreen()
    }

    func fetchSavedPaymentMethods() {
        guard presenter.dataBus?.paymentsInfo?.isPaymentsDownloaded == false else {
            return
        }
        presenter.fetchSavedPayments { [weak self] (_, error) in
            if error != nil {
                let okButton = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                    self?.trackNotification(message: error?.localizedDescription ?? "", response: MECEnglishString("mec_ok"))
                }
                self?.showAlert(title: MECLocalizedString("mec_address"),
                                message: error?.localizedDescription,
                                okButton: okButton,
                                cancelButton: nil)
            }
            self?.deliveryDetailsTableView.reloadSections(IndexSet(integer: MECDeliveryDetailsSections.MECPaymentDetailsSection),
                                                          with: .fade)
        }
    }

    func navigateToOrderSummaryScreen() {
        if let checkoutViewController = MECOrderSummaryViewController.instantiateFromAppStoryboard(appStoryboard: .checkout) {
            checkoutViewController.presenter = MECOrderSummaryPresenter(with: presenter.dataBus)
            navigationController?.pushViewController(checkoutViewController, animated: true)
        }
    }

    func fetchDeliveryModes() {
        let deliveryModesCount = presenter.fetchedDeliveryModes?.count ?? 0
        if presenter.shippingAddress == nil || deliveryModesCount == 0 {
            presenter.fetchDeliveryModes { [weak self] (_, error) in
                DispatchQueue.main.async {
                    if error != nil {
                        let okButton = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                            self?.trackNotification(message: error?.localizedDescription ?? "", response: MECEnglishString("mec_ok"))
                        }
                        self?.showAlert(title: MECLocalizedString("mec_address"),
                                        message: error?.localizedDescription,
                                        okButton: okButton,
                                        cancelButton: nil)
                    }
                    self?.presenter.setCurrentSelectedDeliveryMode()
                    self?.deliveryDetailsTableView.reloadSections(IndexSet(integer: MECDeliveryDetailsSections.MECDeliveryModesSection),
                                                                  with: .fade)
                }
            }
        }
    }

    func setDeliveryMode(deliveryMode: ECSDeliveryMode) {
        startActivityProgressIndicator(shouldCoverFull: false, messageText: "")
        presenter.setDeliveryMode(deliveryMode: deliveryMode) { [weak self] (error) in
            DispatchQueue.main.async {
                self?.stopActivityProgressIndicator()
                if error != nil {
                    let okButton = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                        self?.trackNotification(message: error?.localizedDescription ?? "", response: MECEnglishString("mec_ok"))
                    }
                    self?.showAlert(title: MECLocalizedString("mec_address"),
                                    message: error?.localizedDescription,
                                    okButton: okButton,
                                    cancelButton: nil)
                }
                self?.presenter.setCurrentSelectedDeliveryMode()
                self?.deliveryDetailsTableView.reloadData()
            }
        }
    }

    func launchAddBillingAddressScreen() {
        if let addressScreen = MECAddAddressViewController.instantiateFromAppStoryboard(appStoryboard: .addAddress) {
            let presenter = MECAddAddressPresenter(addressDataBus: self.presenter.dataBus)
            addressScreen.addressScreenType = .addBillingAddress
            addressScreen.presenter = presenter
            navigationController?.pushViewController(addressScreen, animated: true)
        }
    }

    func launchEditBillingAddressScreen(billingAddress: ECSAddress?) {
        if let editAddressScreen = MECAddAddressViewController.instantiateFromAppStoryboard(appStoryboard: .addAddress) {
            editAddressScreen.addressScreenType = .editBillingAddress
            let presenter = MECAddAddressPresenter(addressDataBus: self.presenter.dataBus, shippingAddress: billingAddress)
            editAddressScreen.presenter = presenter
            navigationController?.pushViewController(editAddressScreen, animated: true)
        }
    }

    func createAddPaymentMethodCollectionViewCellFor(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let addAddressCell = collectionView
            .dequeueReusableCell(withReuseIdentifier: MECCellIdentifier.MECPaymentAddAddressCollectionViewCell,
                                                                for: indexPath) as? MECAddAddressCollectionViewCell
        addAddressCell?.customizeUI()
        addAddressCell?.removeDropShadow()
        return addAddressCell ?? UICollectionViewCell()
    }
}

extension MECDeliveryDetailsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case MECDeliveryDetailsSections.MECDeliveryStepsSection:
            return 1
        case MECDeliveryDetailsSections.MECShippingAddressSection:
            guard presenter.shippingAddress == nil else {
                return 2
            }
            return 1
        case MECDeliveryDetailsSections.MECDeliveryModesSection:
            return presenter.fetchedDeliveryModes?.count ?? 0
        case MECDeliveryDetailsSections.MECPaymentDetailsSection:
            return 1
        default:
            return 0
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable function_body_length
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case MECDeliveryDetailsSections.MECDeliveryStepsSection:
            let deliveryStepCell = tableView
                .dequeueReusableCell(withIdentifier: MECCellIdentifier.MECDeliveryStepCell) as? MECDeliveryDetailsStepCell
            deliveryStepCell?.deliveryStepView.currentDeliveryDetailsStep = .delivery
            return deliveryStepCell ?? UITableViewCell()
        case MECDeliveryDetailsSections.MECShippingAddressSection:
            switch indexPath.row {
            case 0:
                if presenter.shippingAddress == nil {
                    let manageAddressCell = tableView
                        .dequeueReusableCell(withIdentifier: MECCellIdentifier.MECManageAddressCell) as? MECManageAddressCell
                    manageAddressCell?.manageAddressDelegate = self
                    return manageAddressCell ?? UITableViewCell()
                }
                let addressDisplayCell = tableView
                    .dequeueReusableCell(withIdentifier: MECCellIdentifier.MECAddressDisplayCell) as? MECAddressDisplayCell
                addressDisplayCell?.addressDisplayActionDelegate = self
                addressDisplayCell?.addressNameLabel.text = presenter.shippingAddress?.constructFullName()
                addressDisplayCell?.fullAddressLabel.text(presenter.shippingAddress?.constructShippingAddressDisplayString() ?? "",
                                                          lineSpacing: UIDSize8/2)
                return addressDisplayCell ?? UITableViewCell()
            case 1:
                let manageAddressCell = tableView
                    .dequeueReusableCell(withIdentifier: MECCellIdentifier.MECManageAddressCell) as? MECManageAddressCell
                manageAddressCell?.manageAddressDelegate = self
                return manageAddressCell ?? UITableViewCell()
            default:
                return UITableViewCell()
            }
        case MECDeliveryDetailsSections.MECDeliveryModesSection:
            if let deliveryModesCell = tableView
                .dequeueReusableCell(withIdentifier: MECCellIdentifier.MECDeliveryModesCell) as? MECDeliveryModesCell,
                let deliveryMode = presenter.fetchedDeliveryModes?[indexPath.row] {
                deliveryModesCell.configureUI()
                deliveryModesCell.deliveryModeNameLabel.text = deliveryMode.deliveryModeName
                deliveryModesCell.deliveryModeDetailsLabel.text = deliveryMode.constructDeliveryModeDetails()
                deliveryModesCell.deliveryModeRadioButton.isSelected = presenter
                    .currentDeliveryMode?.deliveryModeId == deliveryMode.deliveryModeId
                deliveryModesCell.deliveryModeRadioButton.delegate = deliveryModesCell
                deliveryModesCell.deliveryModeSelectionDelegate = self
                return deliveryModesCell
            }
            return UITableViewCell()
        case MECDeliveryDetailsSections.MECPaymentDetailsSection:
            if let paymentDetailsCell = tableView
                .dequeueReusableCell(withIdentifier: MECCellIdentifier.MECPaymentsListCell) as? MECPaymentsListCell {
                paymentDetailsCell.paymentsListCollectionView.tag = presenter.dataBus?.paymentsInfo?.isPaymentsDownloaded == true ?
                    MECConstants.MECMECPaymentsDownloadedCollectionViewTag :
                    MECConstants.MECMECPaymentsNotDownloadedCollectionViewTag
                paymentDetailsCell.paymentsListCollectionView.reloadData()
                return paymentDetailsCell
            }
            return UITableViewCell()
        default:
            break
        }
        return UITableViewCell()
    }
// swiftlint:enable cyclomatic_complexity
// swiftlint:enable cyclomatic_complexity
}

extension MECDeliveryDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case MECDeliveryDetailsSections.MECShippingAddressSection, MECDeliveryDetailsSections.MECPaymentDetailsSection:
            let headerView = UIDHeaderView.createMECHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
            headerView.headerLabel.text = section == MECDeliveryDetailsSections.MECShippingAddressSection ?
                MECLocalizedString("mec_shipping_address") :
                MECLocalizedString("mec_payment_method")
            return headerView
        case MECDeliveryDetailsSections.MECDeliveryModesSection:
            guard presenter.fetchNumberOfDeliveryModes() > 0 else {
                return nil
            }
            let headerView = UIDHeaderView.createMECHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
            headerView.headerLabel.text = MECLocalizedString("mec_delivery_method")
            return headerView
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case MECDeliveryDetailsSections.MECShippingAddressSection, MECDeliveryDetailsSections.MECPaymentDetailsSection:
            return 40
        case MECDeliveryDetailsSections.MECDeliveryModesSection:
            return presenter.fetchNumberOfDeliveryModes() > 0 ? 40 : 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == MECDeliveryDetailsSections.MECDeliveryModesSection else {
            return
        }
        if let deliveryMode = presenter.fetchedDeliveryModes?[indexPath.row],
            deliveryMode != presenter.currentDeliveryMode {
            presenter.currentDeliveryMode = deliveryMode
            deliveryDetailsTableView.reloadData()
            setDeliveryMode(deliveryMode: deliveryMode)
        }
    }
}

extension MECDeliveryDetailsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard collectionView.tag != MECConstants.MECMECPaymentsNotDownloadedCollectionViewTag else {
            return 1
        }
        return presenter.fetchNumberOfPayments()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard collectionView.tag != MECConstants.MECMECPaymentsNotDownloadedCollectionViewTag else {
            if let loadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: MECCellIdentifier.MECLoadingCollectionViewCell,
                                                                    for: indexPath) as? MECLoadingCollectionViewCell {
                loadingCell.customizeUI()
                return loadingCell
            }
            return UICollectionViewCell()
        }
        guard indexPath.row == presenter.dataBus?.paymentsInfo?.fetchedPaymentMethods?.count else {
            if let paymentCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: MECCellIdentifier.MECPaymentDetailsCollectionViewCell,
                                                                    for: indexPath) as? MECPaymentDetailsCollectionViewCell,
                let selectedPayment = presenter.dataBus?.paymentsInfo?.fetchedPaymentMethods?[indexPath.row] {
                paymentCell.configureUI()
                selectedPayment.paymentId == presenter.dataBus?.paymentsInfo?.selectedPayment?.paymentId ?
                    paymentCell.selectCell() :
                    paymentCell.unselectCell()
                paymentCell.cardDisclaimerLabel.text = selectedPayment.isNewPayment() ?
                    "* \(MECLocalizedString("mec_new_payment_disclaimer"))" : ""
                paymentCell.editButton.isHidden = !selectedPayment.isNewPayment()
                paymentCell.billingAddressEditDelegate = selectedPayment.isNewPayment() ? self : nil
                paymentCell.cardAddressLabel.text(selectedPayment.billingAddress?.constructShippingAddressDisplayString() ?? "",
                                                  lineSpacing: UIDSize8/2)
                paymentCell.cardHolderNameLabel.text = selectedPayment.fetchAccountHolderName()
                paymentCell.cardNameLabel.text = selectedPayment.constructCardDetails()
                paymentCell.cardValidityLabel.text = selectedPayment.constructPaymentValidityDetails()
                return paymentCell
            }
            return createAddPaymentMethodCollectionViewCellFor(collectionView: collectionView, indexPath: indexPath)
        }
        return createAddPaymentMethodCollectionViewCellFor(collectionView: collectionView, indexPath: indexPath)
    }
}

extension MECDeliveryDetailsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard collectionView.tag != MECConstants.MECMECPaymentsNotDownloadedCollectionViewTag else {
            return CGSize(width: 160, height: 200)
        }
        return CGSize(width: 180, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView.tag != MECConstants.MECMECPaymentsNotDownloadedCollectionViewTag else {
            return
        }
        guard indexPath.row == presenter.dataBus?.paymentsInfo?.fetchedPaymentMethods?.count else {
            if let selectedPayment = presenter.dataBus?.paymentsInfo?.fetchedPaymentMethods?[indexPath.row] {
                presenter.dataBus?.paymentsInfo?.selectedPayment = selectedPayment
                collectionView.reloadData()
            }
            return
        }
        launchAddBillingAddressScreen()
    }
}

extension MECDeliveryDetailsViewController: MECAddressDisplayActionProtocol {

    func didClickEditShippingAddressButton() {
        if let editAddressScreen = MECAddAddressViewController.instantiateFromAppStoryboard(appStoryboard: .addAddress) {
            editAddressScreen.addressScreenType = .editAddress
            let addressToEdit = self.presenter.dataBus?.savedAddresses?
                .first(where: { $0.addressID == self.presenter.shippingAddress?.addressID })
            let presenter = MECAddAddressPresenter(addressDataBus: self.presenter.dataBus, shippingAddress: addressToEdit)
            editAddressScreen.presenter = presenter
            navigationController?.pushViewController(editAddressScreen, animated: true)
        }
    }
}

extension MECDeliveryDetailsViewController: MECManageAddressProtocol {

    func didSelectManageAddress() {
        if let manageAddressViewController = MECManageAddressViewController.instantiateFromAppStoryboard(appStoryboard: .manageAddress) {
            let manageAddressPresenter = MECManageAddressPresenter(deliveryDetailsDataBus: presenter.dataBus)
            manageAddressPresenter.savedAddresses = presenter.dataBus?.savedAddresses
            manageAddressPresenter.currentShippingAddress = presenter.shippingAddress
            manageAddressViewController.presenter = manageAddressPresenter
            manageAddressViewController.addressChangeDelegate = self
            let manageAddressNavigationController = UINavigationController(rootViewController: manageAddressViewController)
            manageAddressNavigationController.modalPresentationStyle = .overCurrentContext
            present(manageAddressNavigationController, animated: true, completion: nil)
        }
    }
}

extension MECDeliveryDetailsViewController: MECAddressChangeProtocol {
    func viewControllerDidDismiss() {
        trackPage(pageName: MECAnalyticPageNames.deliveryDetailPage)
    }

    func refreshDeliveryDetails() {
        startActivityProgressIndicator(shouldCoverFull: false, messageText: "")
        presenter.setUpShippingAddress { [weak self] in
            DispatchQueue.main.async {
                self?.stopActivityProgressIndicator()
                self?.deliveryDetailsTableView.reloadData()
            }
        }
    }
}

extension MECDeliveryDetailsViewController: MECDeliveryModeSelectionProtocol {

    func didSelectDeliveryMode(cell: MECDeliveryModesCell) {
        if let cellIndexPath = deliveryDetailsTableView.indexPath(for: cell),
            let selectedDeliveryMode = presenter.fetchedDeliveryModes?[cellIndexPath.row],
            selectedDeliveryMode != presenter.currentDeliveryMode {
            presenter.currentDeliveryMode = selectedDeliveryMode
            deliveryDetailsTableView.reloadData()
            setDeliveryMode(deliveryMode: selectedDeliveryMode)
        }
    }
}

extension MECDeliveryDetailsViewController: MECBillingAddressEditProtocol {

    func didClickEditBillingAddress(collectionView: UICollectionViewCell) {
        if let newPayment = presenter.dataBus?.paymentsInfo?.fetchedPaymentMethods?.first(where: { $0.isNewPayment() }) {
            launchEditBillingAddressScreen(billingAddress: newPayment.billingAddress)
        }
    }
}
// swiftlint:enable file_length
