/*
 * Copyright (c) Koninklijke Philips N.V., 2018
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import SafariServices
import PhilipsUIKitDLS

class PIMGuestUserViewController: UIViewController {
    
    @IBOutlet weak var guestUserProgressIndicator: UIDProgressIndicator!
    
    var sourceID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadGuestUserPage()
    }
    
    func loadGuestUserPage() {
        self.fetchGuestUserURL { (url) in
            if let guestUserURL = URL(string: url) {
                let safariVC = SFSafariViewController(url: guestUserURL)
                safariVC.delegate = self
                safariVC.dismissButtonStyle = .close
                safariVC.modalPresentationStyle = .formSheet
                self.present(safariVC, animated: true, completion: nil)
            }
        }
    }
    
    func fetchGuestUserURL(completion:@escaping (_ url: String) -> Void) {
        self.guestUserProgressIndicator.startAnimating()
        let settingsManager = PIMSettingsManager.sharedInstance
        settingsManager.getPIMSDURL(forKey: PIMConstants.ServiceIDs.GUEST_USER_URL, completionHandler: { (sdURL, inError) in
            self.guestUserProgressIndicator.stopAnimating()
            guard inError == nil else {
                PIMUtilities.showErrorAlertController(error: inError, presentationView: self)
                return
            }
            if let inURL = sdURL {
                completion(inURL + "&" + self.sourceID)
                return
            }
            PIMUtilities.showErrorAlertController(error: PIMErrorBuilder.getNoSDURLError(), presentationView: self)
        }, replacement: nil)
    }
    
}

extension PIMGuestUserViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
}
