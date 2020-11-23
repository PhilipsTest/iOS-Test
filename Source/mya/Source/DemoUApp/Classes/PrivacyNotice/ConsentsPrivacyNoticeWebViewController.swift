//
//  ConsentsPrivacyNoticeWebViewController.swift
//  ConsentWidgets
//
//  Copyright © Koninklijke Philips N.V., 2017
//  All rights are reserved. Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder.
//

import UIKit
import WebKit
import AppInfra
import PhilipsUIKitDLS

class ConsentsPrivacyNoticeWebViewController: UIViewController {
    private var privacyWebView: WKWebView!
    private var webViewURL: String!
    private let keyToObserve: String = "estimatedProgress"
    var appInfraInstance: AIAppInfra?
    
    @IBOutlet weak var loadingIndicator: UIDProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureUI()
        self.startFetchingPrivacyURLAndLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureUI() {
        self.navigationItem.title = "csw_privacy_notice".localized
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "csw_ok".localized, style: .plain, target: self, action: #selector(ConsentsPrivacyNoticeWebViewController.okTapped))
        self.addWebView()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.loadingIndicator?.progressIndicatorStyle = .indeterminate
        self.loadingIndicator?.circularProgressIndicatorSize = .medium
        self.loadingIndicator?.startAnimating()
    }
    
    private func addWebView() {
        let webConfiguration = WKWebViewConfiguration()
        privacyWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        privacyWebView?.navigationDelegate = self
        privacyWebView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(privacyWebView)
        guard let privacyWebView = privacyWebView else { return }
        let horizontalConstraint = NSLayoutConstraint(item: privacyWebView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: privacyWebView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: privacyWebView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: privacyWebView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 0)
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        self.view.bringSubviewToFront(self.loadingIndicator)
    }
    
    private func startFetchingPrivacyURLAndLoad() {
        guard let appInfraObjectToUse = self.appInfraInstance else {
            self.dismissCurrentPage()
            return
        }
        
        appInfraObjectToUse.serviceDiscovery?.getServicesWithCountryPreference(["app.privacynotice"], withCompletionHandler: { [weak self] (services, error) in
            guard error == nil else {
                self?.dismissCurrentPage()
                return
            }
            
            guard let aService = services?["app.privacynotice"] else {
                self?.dismissCurrentPage()
                return
            }
            
            guard let valueToUse = aService.url else {
                self?.dismissCurrentPage()
                return
            }
            
            self?.webViewURL = valueToUse
            self?.startLoadingURL()
        }, replacement: nil)
    }
    
    private func startLoadingURL() {
        if let urlString = self.webViewURL, let urlToUse = URL(string: urlString) {
            self.privacyWebView.load(URLRequest(url: urlToUse))
        }
    }
    
   @objc func okTapped () {
        self.dismissCurrentPage()
    }
    
    private func dismissCurrentPage() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    fileprivate func removeLoadingIndicator() {
        DispatchQueue.main.async {
            self.loadingIndicator?.stopAnimating()
        }
    }
    
    fileprivate func showAlert(withTitle: String, withMessage: String, withButtonTitle: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: withTitle, message: withMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: withButtonTitle, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}

extension ConsentsPrivacyNoticeWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.removeLoadingIndicator()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.showAlert(withTitle: "csw_problem_occurred_error_title".localized , withMessage: error.localizedDescription, withButtonTitle: "csw_ok".localized)
        self.removeLoadingIndicator()
    }
}

