/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import AppInfra
import WebKit

class TermsAndPrivacyViewController: UIViewController, WKNavigationDelegate {

    var termsAndConditionWebView: WKWebView!
    let activityView = UIActivityIndicatorView(style: .whiteLarge)

    var urlString = String()
    var serviceID = String()
    var titleString: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: Constants.OK_TEXT, style: .plain, target: self, action: #selector(dismissButtonPressed))
        
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        self.addTermsAndConditionWebView()

        if let status = (UserDefaults.standard.value(forKey: Constants.TYPE_OF_CONDITION_IDENTIFIER) as? String) {
            switch status {
            case Constants.PRIVACY_POLICY_LAUNCH:
                serviceID  = Constants.APP_ID_PRIVACY
                if let titleToDisplay = titleString {
                    navigationItem.title = titleToDisplay
                } else {
                    navigationItem.title = Constants.PRIVACY_POLICY_TEXT
                }
                break

            case Constants.TERMS_AND_CONDITION_LAUNCH:
                serviceID  =  Constants.APP_ID_TERMS_AND_CONDITION
                navigationItem.title = Constants.TERMS_AND_CONDITION_TEXT
                break
            case Constants.PERSONAL_CONSENT_LAUNCH:
                serviceID  =  Constants.APP_ID_PERSONAL_CONSENT
                navigationItem.title = Constants.PERSONAL_CONSENT_TEXT
                break
            default:
                urlString  = ""
            }
        }
        
        loadTermsAndPrivacyURL(serviceID: serviceID)

    }
    
    func addTermsAndConditionWebView() {
        let webConfiguration = WKWebViewConfiguration()
        termsAndConditionWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        termsAndConditionWebView.navigationDelegate = self
        termsAndConditionWebView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(termsAndConditionWebView)
        guard let termsAndConditionWebView = termsAndConditionWebView else { return }
        let horizontalConstraint = NSLayoutConstraint(item: termsAndConditionWebView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: termsAndConditionWebView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: termsAndConditionWebView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: termsAndConditionWebView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 0)
        
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    func loadTermsAndPrivacyURL(serviceID : String){
        
        // Getting URL from service discovery based on the country selection
    AppInfraSharedInstance.sharedInstance.appInfraHandler?.serviceDiscovery.getServicesWithCountryPreference([serviceID], withCompletionHandler: { [weak self](dictionary, error) in
            if let serviceURL:AISDService = dictionary?[serviceID]{
                if let urlValue = serviceURL.url {
                    self?.urlString = urlValue
                    self?.termsAndConditionWebView.load(NSURLRequest(url: NSURL(string: (self?.urlString)!)! as URL) as URLRequest)
                }else if serviceID == Constants.APP_ID_PERSONAL_CONSENT {
                    self?.urlString = "https://www.philips.com/a-w/privacy-notice.html";
                } else {
                    AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: "ErrorWhileGettingURLfromServiceDiscovery", message: "\(String(describing: error))")
                }
            }else{
                AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: "ErrorWhileGettingURLfromServiceDiscovery", message: "\(String(describing: error))")

            }
        }, replacement: nil)
    }
    
    @objc func dismissButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityView.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityView.stopAnimating()
    }
    
}
