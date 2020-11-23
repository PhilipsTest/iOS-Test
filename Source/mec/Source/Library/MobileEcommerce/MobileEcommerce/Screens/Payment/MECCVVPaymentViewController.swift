/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS
import PhilipsEcommerceSDK

class MECCVVPaymentViewController: MECBaseViewController {

    @IBOutlet weak var mainCVVView: UIDView!
    @IBOutlet weak var enterCVVLabel: UIDLabel!
    @IBOutlet weak var cvvTextField: UIDTextField!
    @IBOutlet weak var cvvDescriptionLabel: UIDLabel!
    @IBOutlet weak var mainViewBottomConstraint: NSLayoutConstraint!

    weak var delegate: MECViewControllerDismissDelegate?
    var presenter: MECOrderSummaryPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackPage(pageName: MECAnalyticPageNames.cvvPage)
    }

    deinit {
        deRegisterFromKeyboardNotifications()
    }
}

extension MECCVVPaymentViewController {

    @IBAction func continueButtonClicked(_ sender: Any) {
        guard let cvv = cvvTextField.text, cvv.count > 0 else {
            cvvTextField.resignFirstResponder()
            let okButton = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                self.trackNotification(message: MECEnglishString("mec_blank_cvv_error"),
                                       response: MECEnglishString("mec_ok"))
            }
            showAlert(title: MECLocalizedString("mec_payment"),
                      message: MECLocalizedString("mec_blank_cvv_error"),
                      okButton: okButton,
                      cancelButton: nil)
            trackUserError(errorMessage: MECEnglishString("mec_blank_cvv_error"))
            return
        }
        makePaymentWith(cvv: cvv)
    }

    @IBAction func topViewTapped(_ sender: Any) {
        if cvvTextField.isFirstResponder {
            cvvTextField.resignFirstResponder()
        } else {
            delegate?.viewControllerDidDismiss()
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func cvvViewTapped(_ sender: Any) {
        cvvTextField.resignFirstResponder()
    }

    func makePaymentWith(cvv: String) {
        startActivityProgressIndicator(shouldCoverFull: false, messageText: "")
        presenter.payForOrderWith(cvv: cvv) { [weak self] (orderDetail, error) in
            DispatchQueue.main.async {
                self?.stopActivityProgressIndicator()
                guard error == nil else {
                    let okButton = UIDAction(title: MECLocalizedString("mec_ok"), style: .primary) { (_) in
                        self?.trackNotification(message: MECEnglishString("mec_payment_failed_message"),
                                                response: MECEnglishString("mec_ok"))
                    }
                    self?.showAlert(title: MECLocalizedString("mec_payment"),
                                    message: MECLocalizedString("mec_payment_failed_message"),
                                    okButton: okButton,
                                    cancelButton: nil)
                    return
                }
                self?.moveToPaymentConfirmationScreenWith(orderDetail: self?.presenter.orderDetail)
            }
        }
    }

    func moveToPaymentConfirmationScreenWith(orderDetail: ECSOrderDetail?) {
        if let paymentConfirmationScreen = MECPaymentConfirmationViewController
            .instantiateFromAppStoryboard(appStoryboard: .paymentConfirmation) {
            paymentConfirmationScreen.paymentStatus = .paymentSuccess
            paymentConfirmationScreen.paymentType = .paymentTypeOld
            paymentConfirmationScreen.orderDetail = orderDetail
            dismiss(animated: false, completion: nil)
            (presentingViewController as? UINavigationController)?.pushViewController(paymentConfirmationScreen, animated: true)
        }
    }

    func configureUI() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        registerForKeyboardNotifications()
        enterCVVLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        // swiftlint:disable line_length
        let cvvDisplayText = "\(MECLocalizedString("mec_cvv_code"))\n\((presenter.dataBus?.paymentsInfo?.selectedPayment?.constructCardDetails()) ?? "")"
        // swiftlint:enable line_length
        enterCVVLabel.text = cvvDisplayText
        cvvDescriptionLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
        cvvDescriptionLabel.text(MECLocalizedString("mec_cvvpopup_info"), lineSpacing: 4)
    }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MECCVVPaymentViewController.keyboardWasShown(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MECCVVPaymentViewController.keyboardWillBeHidden(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func deRegisterFromKeyboardNotifications() {
        let center: NotificationCenter = NotificationCenter.default
        center.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        center.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWasShown(_ notification: Notification) {
        if let info = notification.userInfo,
            let keyboardRect = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            UIView.animate(withDuration: 0.2) {
                self.mainViewBottomConstraint.constant = keyboardRect.size.height - 80
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillBeHidden(_ notification: Notification) {
        UIView.animate(withDuration: 0.2) {
            self.mainViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
