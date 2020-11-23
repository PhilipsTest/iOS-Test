/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS
import PhilipsEcommerceSDK

protocol MECAddressChangeProtocol: NSObjectProtocol {
    func refreshDeliveryDetails()
    func viewControllerDidDismiss()
}

class MECManageAddressViewController: MECBaseViewController {

    @IBOutlet weak var manageAddressGestureView: UIView!
    @IBOutlet weak var manageAddressCollectionView: UICollectionView!
    @IBOutlet weak var manageAddressHeaderView: UIDView!
    @IBOutlet weak var deleteAddressButton: UIDButton!

    var presenter: MECManageAddressPresenter!
    weak var addressChangeDelegate: MECAddressChangeProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackPage(pageName: MECAnalyticPageNames.addressSelectionPage)
    }
}

extension MECManageAddressViewController {

    @IBAction func setShippingAddressClicked(_ sender: Any) {
        guard let shippingAddress = presenter.currentShippingAddress else {
            let okButton = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                self.trackNotification(message: MECEnglishString("mec_no_address_select_message"),
                                       response: MECEnglishString("mec_ok"))
            }
            showAlert(title: MECLocalizedString("mec_address"),
                      message: MECLocalizedString("mec_no_address_select_message"), okButton: okButton, cancelButton: nil)
            trackUserError(errorMessage: MECEnglishString("mec_no_address_select_message"))
            return
        }
        let setAction = UIDAction(title: MECLocalizedString("mec_set_text"), style: .primary) { [weak self] (_) in
            self?.trackNotification(message: MECEnglishString("mec_set_shipping_address_alert_message"),
                                    response: MECEnglishString("mec_set_text"))
            self?.setShippingAddress(shippingAddress: shippingAddress)
        }
        let cancelAction = UIDAction(title: MECLocalizedString("mec_cancel"), style: .secondary) { [weak self] (_) in
            self?.trackNotification(message: MECEnglishString("mec_set_shipping_address_alert_message"),
                                    response: MECEnglishString("mec_cancel"))
        }
        showAlert(title: MECLocalizedString("mec_address"),
                  message: MECLocalizedString("mec_set_shipping_address_alert_message"),
                  okButton: cancelAction,
                  cancelButton: setAction)
    }

    @IBAction func deleteAddressClicked(_ sender: Any) {
        guard let address = presenter.currentShippingAddress else {
            let okButton = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                self.trackNotification(message: MECEnglishString("mec_no_address_select_message"),
                                       response: MECEnglishString("mec_ok"))
            }
            showAlert(title: MECLocalizedString("mec_address"),
                      message: MECLocalizedString("mec_no_address_select_message"),
                      okButton: okButton, cancelButton: nil)
            trackUserError(errorMessage: MECEnglishString("mec_no_address_select_message"))
            return
        }
        let deleteAction = UIDAction(title: MECLocalizedString("mec_delete"),
                                     style: .primary) { [weak self] (_) in
            self?.trackNotification(message: MECEnglishString("mec_delete_item_alert_message"),
                                    response: MECEnglishString("mec_delete"))
            self?.deleteAddress(address: address)
        }
        let cancelAction = UIDAction(title: MECLocalizedString("mec_cancel"), style: .secondary) { [weak self] (_) in
            self?.trackNotification(message: MECEnglishString("mec_delete_item_alert_message"),
                                    response: MECEnglishString("mec_cancel"))
        }

        showAlert(title: MECLocalizedString("mec_address"),
                  message: MECLocalizedString("mec_delete_item_alert_message"),
                  okButton: cancelAction, cancelButton: deleteAction)
    }

    func configureUI() {
        presenter.shuffleSavedAddresses()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        navigationController?.isNavigationBarHidden = true
        configureGestureRecognizer()
        manageAddressHeaderView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentSecondaryNeutralBackground
        updateDeleteButtonState()
    }

    func configureGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureViewTapped))
        tapGestureRecognizer.cancelsTouchesInView = false
        manageAddressGestureView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func gestureViewTapped(_ sender: Any) {
        addressChangeDelegate?.viewControllerDidDismiss()
        dismiss(animated: true, completion: nil)
    }

    func moveToAddAddressScreen() {
        if let addressScreen = MECAddAddressViewController.instantiateFromAppStoryboard(appStoryboard: .addAddress) {
            let presenter = MECAddAddressPresenter(addressDataBus: self.presenter.dataBus)
            addressScreen.addressScreenType = .addAddress
            addressScreen.presenter = presenter
            dismiss(animated: false, completion: nil)
            (presentingViewController as? UINavigationController)?.pushViewController(addressScreen, animated: true)
        }
    }

    func deleteAddress(address: ECSAddress) {
        startActivityProgressIndicator(shouldCoverFull: false, messageText: "")
        presenter.deleteAddress(address: address) { [weak self] (error) in
            DispatchQueue.main.async {
                self?.stopActivityProgressIndicator()
                guard error == nil else {
                    let okButton = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                        self?.trackNotification(message: error?.localizedDescription ?? "", response: MECEnglishString("mec_ok"))
                    }
                    self?.showAlert(title: MECLocalizedString("mec_address"),
                                    message: error?.localizedDescription,
                                    okButton: okButton,
                                    cancelButton: nil)
                    return
                }
                self?.addressChangeDelegate?.refreshDeliveryDetails()
                self?.addressChangeDelegate?.viewControllerDidDismiss()
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }

    func setShippingAddress(shippingAddress: ECSAddress) {
        startActivityProgressIndicator(shouldCoverFull: false, messageText: "")
        presenter.setUserSelectedDeliveryAddress(address: shippingAddress) { [weak self] (error) in
            DispatchQueue.main.async {
                self?.stopActivityProgressIndicator()
                guard error == nil else {
                    let okButton = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                        self?.trackNotification(message: error?.localizedDescription ?? "", response: MECEnglishString("mec_ok"))
                    }
                    self?.showAlert(title: MECLocalizedString("mec_address"),
                                    message: error?.localizedDescription,
                                    okButton: okButton,
                                    cancelButton: nil)
                    return
                }
                self?.addressChangeDelegate?.refreshDeliveryDetails()
                self?.addressChangeDelegate?.viewControllerDidDismiss()
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }

    func updateDeleteButtonState() {
        deleteAddressButton.isEnabled = (presenter.savedAddresses?.count ?? 0) > 1
    }

    func createAddAddressCell(collectionView: UICollectionView, indexPath: IndexPath) -> MECAddAddressCollectionViewCell? {
        let addAddressCell = collectionView.dequeueReusableCell(withReuseIdentifier: MECCellIdentifier.MECAddAddressCollectionViewCell,
                                                                for: indexPath) as? MECAddAddressCollectionViewCell
        addAddressCell?.customizeUI()
        return addAddressCell
    }
}

extension MECManageAddressViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (presenter.savedAddresses?.count ?? 0) + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.row == presenter.savedAddresses?.count else {
            if let selectedAddress = presenter.savedAddresses?[indexPath.row],
                let addressCell = collectionView
                    .dequeueReusableCell(withReuseIdentifier: MECCellIdentifier.MECAddressDetailsCollectionViewCell,
                                                                     for: indexPath) as? MECAddressDetailsCollectionViewCell {
                addressCell.addressFullNameLabel.text = selectedAddress.constructFullName()
                addressCell.addressDetailsLabel.text = selectedAddress.constructShippingAddressDisplayString()
                if selectedAddress.addressID == presenter.currentShippingAddress?.addressID {
                    addressCell.selectCell()
                } else {
                    addressCell.unselectCell()
                }
                return addressCell
            }
            return createAddAddressCell(collectionView: collectionView, indexPath: indexPath) ?? UICollectionViewCell()
        }
        return createAddAddressCell(collectionView: collectionView, indexPath: indexPath) ?? UICollectionViewCell()
    }
}

extension MECManageAddressViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row == presenter.savedAddresses?.count else {
            if let newShippingAddress = presenter.savedAddresses?[indexPath.row] {
                presenter.currentShippingAddress = newShippingAddress
                collectionView.reloadData()
            }
            return
        }
        moveToAddAddressScreen()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
}
