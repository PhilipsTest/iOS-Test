/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

protocol MECNotifyMeSuccessDelegate: NSObjectProtocol {
    func notifyMeDidSucceed()
}

class MECNotifyMeViewController: MECBaseViewController {

    @IBOutlet weak var notifyMeViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var notifyMeTextField: UIDTextField!
    @IBOutlet weak var notifyMeLabel: UIDLabel!

    weak var delegate: MECNotifyMeSuccessDelegate?
    var presenter: MECNotifyMePresenter!
    var ctn: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MECNotifyMePresenter()
        shouldShowCart(MECConfiguration.shared.isHybrisAvailable == true)
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackPage(pageName: MECAnalyticPageNames.notifyMe)
    }

    deinit {
        deRegisterFromKeyboardNotifications()
    }
}

extension MECNotifyMeViewController {

    @IBAction func notifyMeButtonClicked(_ sender: Any) {
        notifyMeTextField.resignFirstResponder()
        notifyMeTextField.setValidationView(false, animated: false)
        startActivityProgressIndicator(shouldCoverFull: false, messageText: "")
        presenter.registerForStockNotificationFor(ctn: ctn ?? "",
                                          email: notifyMeTextField.text ?? "") { [weak self] (_, error) in
            guard let weakSelf = self else { return }
            weakSelf.stopActivityProgressIndicator()
            guard error == nil else {
                if let errorMessage = error?.localizedDescription {
                    weakSelf.notifyMeTextField.validationMessage = errorMessage
                    weakSelf.notifyMeTextField.setValidationView(true, animated: true)
                }
                return
            }
            weakSelf.notifyMeTextField.setValidationView(false, animated: true)
            weakSelf.dismiss(animated: true) {
                weakSelf.delegate?.notifyMeDidSucceed()
            }
        }
    }

    @IBAction func topViewTapped(_ sender: UITapGestureRecognizer) {
        if notifyMeTextField.isFirstResponder {
            notifyMeTextField.resignFirstResponder()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    func configureUI() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        registerForKeyboardNotifications()

        notifyMeLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSecondaryText

        notifyMeTextField.text = presenter.fetchUserEmail()
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
                self.notifyMeViewBottomConstraint.constant = keyboardRect.size.height - 80
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillBeHidden(_ notification: Notification) {
        UIView.animate(withDuration: 0.2) {
            self.notifyMeViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}

extension MECNotifyMeViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
