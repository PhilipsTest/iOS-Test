/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */
import UIKit
import WebKit

class IAPTrackShipmentViewController: IAPBaseViewController, WKNavigationDelegate {
    
    var trackShipmentWebView: WKWebView!
    var trackShipmentURL : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTrackShipmentWebKitView()
        self.loadWebPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.updateCartIconVisibility(false)
    }
    
    override func didTapTryAgain() {
        super.didTapTryAgain()
        self.loadWebPage()
    }
    
    func addTrackShipmentWebKitView() {
        let webConfiguration = WKWebViewConfiguration()
        trackShipmentWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        trackShipmentWebView.navigationDelegate = self
        trackShipmentWebView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackShipmentWebView)
        guard let trackShipmentWebView = trackShipmentWebView else { return }
        let horizontalConstraint = NSLayoutConstraint(item: trackShipmentWebView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: trackShipmentWebView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: trackShipmentWebView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: trackShipmentWebView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 0)
        
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    func loadWebPage(){
        let url = URL(string: self.trackShipmentURL)
        let urlRequest = URLRequest(url: url!)
        self.trackShipmentWebView.load(urlRequest)
    }
    
    // MARK: -
    // MARK: WKWebView Methods
    // MARK: -
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        super.startActivityProgressIndicator()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        super.stopActivityProgressIndicator()
        super.removeNoInternetView()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        super.stopActivityProgressIndicator()
        let errorMessage = error as NSError
        if errorMessage.code != -999 {
            super.displayErrorMessage(errorMessage, shouldDisplayNoInternetView: true)
        }
    }
}
