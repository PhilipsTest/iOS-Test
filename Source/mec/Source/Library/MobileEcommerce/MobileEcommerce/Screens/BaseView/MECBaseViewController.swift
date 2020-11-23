/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsEcommerceSDK
import PhilipsUIKitDLS

class MECBaseViewController: UIViewController, MECInitializer, MECAnalyticsTracking {

    @IBOutlet weak var activityIndicatorView: UIDProgressIndicator?
    @IBOutlet weak var progressView: UIView?
    @IBOutlet weak var progressLabel: UIDLabel!

    var alertViewController: UIDAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()
        shouldShowCart(false)
    }

    func initialize(completionHandler:@escaping (_ success: Bool, _ error: Error?) -> Void) {
        startActivityProgressIndicator()
        initializeEcommerceSDK { [weak self] (success, error) in
            self?.stopActivityProgressIndicator()
            completionHandler(success, error)
        }
    }

    func showAlert(title: String, message: String?, okButton: UIDAction, cancelButton: UIDAction?) {
        let alertVC = UIDAlertController(title: title, message: message)
        alertVC.addAction(okButton)
        if let cancel = cancelButton {
            alertVC.addAction(cancel)
        }
        alertViewController = alertVC
        present(alertVC, animated: true, completion: nil)
    }

    // MARK: -
    // MARK: Show/Hide Progress Indicator
    func startActivityProgressIndicator(shouldCoverFull: Bool = true, messageText: String = MECLocalizedString("mec_loading")) {
        if self.progressView == nil {
            if let activityView = MECUtility.getBundle().loadNibNamed(MECNibName.MECCustomActivityProgressView,
                                                                   owner: self,
                                                                   options: nil)?[0] as? UIView {
                self.progressView = activityView
                self.progressLabel.text = messageText
                self.progressView?.backgroundColor = shouldCoverFull ? self.progressView?.backgroundColor : UIColor.clear
                self.view.addSubview(activityView)
                self.view.bringSubviewToFront(activityView)
            }
        }
        self.progressView?.frame = self.view.bounds
        self.progressView?.isHidden = false
        if self.activityIndicatorView?.isAnimating == false {
            self.activityIndicatorView?.startAnimating()
        }
        self.navigationController?.view.isUserInteractionEnabled = false
    }

    func stopActivityProgressIndicator () {
        self.progressView?.isHidden = true
        self.progressView?.removeFromSuperview()
        if self.progressView != nil {
            self.progressView = nil
        }
        self.activityIndicatorView?.stopAnimating()
        self.navigationController?.view.isUserInteractionEnabled = true
    }

    func shouldShowCart(_ shouldShow: Bool) {
        MECConfiguration.shared.cartUpdateDelegate?.shouldShowCart(shouldShow)
    }
}
