//
//  CookieConsentViewController.swift
//  AppFramework
//
//  Created by Philips on 8/22/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import UIKit
import PhilipsUIKitDLS
import Firebase

class CookieConsentViewController: UIViewController {

    @IBOutlet weak var cookiesTitle: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var allowButton: UIDButton!
    @IBOutlet weak var declineButton: UIDButton!
    var presenter : CookieConsentPresenter?
    @IBOutlet weak var cookieHyperLink: UIDHyperLinkLabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = CookieConsentPresenter(_viewController: self, forState: AppStates.CookieConsent)
        allowButton.setTitle(Constants.Cookie_Accept, for: UIControl.State.normal)
        declineButton.setTitle(Constants.Cookie_Reject, for: UIControl.State.normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configUI()
    }
    
    func configUI(){
        self.navigationItem.title = Constants.Cookie_Consent_Navigation_Title
        self.navigationItem.isAccessibilityElement = true
        self.navigationController?.navigationBar.accessibilityLabel = "csw_justInTimeView_toolbar"
        self.navigationItem.accessibilityLabel = "csw_justInTimeView_toolbar_title"
        cookiesTitle.text = Constants.Cookie_Header_Title
        cookiesTitle.textColor = UIColor.black
        cookiesTitle.font = UIFont(uidFont:.bold, size: UIDFontSizeLarge)
        descriptionText.text = Constants.Cookie_Primary_Description_Paragraph
        cookieHyperLink.text = Constants.Cookie_Consent_HyperLink
        cookieHyperLink.addLink(getHyperLinkModel()) {[weak self] _ in
            self?.showCookieDetailViewController()
        }
    }
    
    func getHyperLinkModel() -> UIDHyperLinkModel{
        let hyperLinkModel = UIDHyperLinkModel()
        hyperLinkModel.isUnderlined = true
        hyperLinkModel.normalLinkColor = UIColor.color(hexString: "#739EC2")
        return hyperLinkModel
    }
    
    func showCookieDetailViewController() {
        let cookieDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "CookieDetailViewController") as? CookieDetailViewController
        let screenToLoadModel = ScreenToLoadModel(viewControllerLoadType: .Push, animates: true, modalTransitionStyle: nil, modalPresentationStyle: nil, segueId: nil)
        Launcher.navigateToViewController(self, toViewController: cookieDetailViewController, loadDetails: screenToLoadModel)
    }
    
    @IBAction func allowNowCookie(_ sender: Any) {
        let cookieConsentInterface = presenter?.getCookieConsent()
        cookieConsentInterface?.postCookieConsent(consentDefinition: CookieConsentProvider.getCookieConsentDefination(), withStatus: true, completion: {[weak self](result, error) in
            if(error == nil){
                AppInfraSharedInstance.sharedInstance.appInfraHandler?.abtest.enableDeveloperMode(true)
                Analytics.setAnalyticsCollectionEnabled(true)
                AppInfraSharedInstance.sharedInstance.appInfraHandler?.abtest.updateCache(success:{
                    AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.debug, eventId: "CookieConsentViewController", message: "Abtest update cache success")
                }, error: {
                    error in
                    AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.debug, eventId: "CookieConsentViewController", message: "Abtest returned error on update cache")
                })
                self?.presenter?.setIsCookieConsentGiven(withValue: true)
            }else{
                Analytics.resetAnalyticsData()
               Analytics.setAnalyticsCollectionEnabled(false)
                self?.presenter?.setIsCookieConsentGiven(withValue: false)
            }
            
        })
        _ = presenter?.onEvent(Constants.Cookie_Consent_Allow_Event_ID)
    }
    
    
    @IBAction func allowLaterCookie(_ sender: Any) {
        let cookieConsentInterface = presenter?.getCookieConsent()
        cookieConsentInterface?.postCookieConsent(consentDefinition: CookieConsentProvider.getCookieConsentDefination(), withStatus: false, completion: {[weak self](result, error) in
            self?.presenter?.setIsCookieConsentGiven(withValue: false)
        })
        _ = presenter?.onEvent(Constants.Cookie_Consent_Disallow_Event_ID)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
