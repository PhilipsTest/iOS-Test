/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import AppInfra
import PhilipsUIKitDLS

class IAPBaseViewController: UIViewController, UINavigationControllerDelegate, IAPNoInternetProtocol, IAPAnalyticsTracking {

    @IBOutlet weak var activityIndicatorView: UIDProgressIndicator?
    @IBOutlet weak var progressView: UIView?

    var currentAlertMessage:String = ""

    var cartIconDelegate: IAPCartIconProtocol?
    var iapHandler: IAPInterface?
    var uidAlertController: UIDAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimaryBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backButtonClicked))
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func updateCartIconVisibility(_ shouldHide: Bool) {
        self.cartIconDelegate?.updateCartIconVisibility(shouldHide)
    }

    func notifyCartDelegateOfCartCountChange() {
        self.cartIconDelegate?.didUpdateCartCount()
    }
    
    @objc func backButtonClicked() {
        self.navigationController?.popViewController(animated: true)
        trackAction(parameterData: [IAPAnalyticsConstants.specialEvents: "backButtonPress"], action: IAPAnalyticsConstants.sendData)
    }

    func unwindToRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func applyPlainShadow(_ view: UIView) {
        let layer = view.layer
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5
    }

    //MARK: NavigationController delegates

    override func didMove(toParent parent: UIViewController?) {
    }

    func displayDLSAlert(_ withTitle: String?,
                         withMessage: String?,
                         firstButton: UIDAction?,
                         secondButton: UIDAction?,
                         usingController: IAPBaseViewController?, viewTag: NSInteger) {
        
        uidAlertController = UIDAlertController(title: withTitle, message: withMessage)
        if firstButton != nil && secondButton != nil {
            uidAlertController?.addAction(firstButton!)
            uidAlertController?.addAction(secondButton!)
        } else if firstButton != nil {
            uidAlertController?.addAction(firstButton!)
        }
        self.present(uidAlertController!, animated: true, completion: nil)
        self.currentAlertMessage = withMessage!
    }

    func displayErrorMessage(_ withError: NSError,
                             shouldDisplayNoInternetView:Bool = false,
                             needToPopOnTap:Bool = false, serverType:String = "Server") {
        var titleToDisplay: String?
        let uidAction: UIDAction = UIDAction(title: IAPLocalizedString("iap_ok"),
                                             style: .primary, handler: { (uidAction) in
            self.uidAlertController?.dismiss(animated: true, completion: nil)
        })
        switch withError.code {
        case IAPConstants.IAPOAuthNotFoundError.kOauthNotFoundCode,
             IAPConstants.IAPOutOfStockError.kProductOutOfStock,
             IAPConstants.IAPHTTPErrorResponseCode.kApiErrorResponseCode:
            titleToDisplay = IAPLocalizedString("Error")
            break
        default:
            break
        }

        //map eeror tagging
        self.mapErrorTagging(error: withError, serverName: serverType)

        guard false == needToPopOnTap else {
            displayDLSAlert(titleToDisplay,
                            withMessage: withError.localizedDescription,
                            firstButton: uidAction,
                            secondButton: nil,
                            usingController: self, viewTag: IAPConstants.IAPAlertViewTags.kBuyDirectAlertTag)
            return
        }
        
        guard IAPConstants.IAPNoInternetError.kNoInternetCode != withError.code else {
            displayDLSAlert(IAPLocalizedString("iap_you_are_offline"),
                            withMessage: IAPLocalizedString("iap_no_internet"),
                            firstButton: uidAction,
                            secondButton: nil, usingController: self,
                            viewTag: IAPConstants.IAPAlertViewTags.kErrorAlertViewTag)
            return
        }

        guard IAPConstants.IAPNoInternetError.kRequestTimeOutCode != withError.code &&
            IAPConstants.IAPNoInternetError.kServerNotReachable != withError.code else {
            guard shouldDisplayNoInternetView == true else {
                displayDLSAlert(titleToDisplay, withMessage: withError.localizedDescription,
                                firstButton: uidAction, secondButton: nil, usingController: self, viewTag: IAPConstants.IAPAlertViewTags.kErrorAlertViewTag)
                return
            }
            self.showNoInternetView()
            return
        }

        guard IAPConstants.IAPHTTPError.kServiceUnavailable != withError.code else {
            displayDLSAlert(IAPLocalizedString("iap_server_error"),
                            withMessage: IAPLocalizedString("iap_something_went_wrong"),
                            firstButton: uidAction,
                            secondButton: nil,
                            usingController: self, viewTag: IAPConstants.IAPAlertViewTags.kApologyAlertViewTag)
            return
        }
        displayDLSAlert(titleToDisplay, withMessage: withError.localizedDescription,
                        firstButton: uidAction,
                        secondButton: nil,
                        usingController: self, viewTag: IAPConstants.IAPAlertViewTags.kErrorAlertViewTag)
    }
    // MARK: -
    // MARK: Offline related methods
    // MARK: -
    func showNoInternetView() {
        guard nil != self.view.viewWithTag(IAPConstants.IAPNoInternetViewTags.kNoInternetViewTag) as? IAPNoInternetView else { self.addNoInternetView(); return }
        self.changeDisplayForNoInternet(false)
    }
    
    func changeDisplayForNoInternet(_ shouldHide: Bool) {
        guard let previousNoInternetView = self.view.viewWithTag(IAPConstants.IAPNoInternetViewTags.kNoInternetViewTag) as? IAPNoInternetView else { return }
        previousNoInternetView.noInternetLabel.isHidden = shouldHide
        previousNoInternetView.tryAgainButton.isHidden  = shouldHide
        self.view?.bringSubviewToFront(previousNoInternetView)
    }
    
    func addNoInternetView() {
        guard let noInternetView    = IAPNoInternetView.instanceFromNib() else { return }
        noInternetView.delegate     = self
        noInternetView.tag          = IAPConstants.IAPNoInternetViewTags.kNoInternetViewTag
        noInternetView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(noInternetView)
        self.view.addConstraint(NSLayoutConstraint(item: noInternetView, attribute: .top,
                                                   relatedBy: .equal, toItem: self.view, attribute: .top,
                                                   multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: noInternetView, attribute: .bottom,
                                                   relatedBy: .equal, toItem: self.view, attribute: .bottom,
                                                   multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: noInternetView, attribute: .leading,
                                                   relatedBy: .equal, toItem: self.view, attribute: .leading,
                                                   multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: noInternetView, attribute: .trailing,
                                                   relatedBy: .equal, toItem: self.view, attribute: .trailing,
                                                   multiplier: 1, constant: 0))
        self.view.bringSubviewToFront(noInternetView)
    }
    
    func removeNoInternetView() {
        guard let previousNoInternetView = self.view.viewWithTag(IAPConstants.IAPNoInternetViewTags.kNoInternetViewTag) else { return }
        previousNoInternetView.removeFromSuperview()
    }
    
    func didTapTryAgain() {
        // Subclasses need to override this
        self.changeDisplayForNoInternet(true)
        self.startActivityProgressIndicator()
    }
    
    // MARK: -
    // MARK: Show/Hide Progress Indicator
    func startActivityProgressIndicator () {
        if self.progressView == nil {
            let activityView :UIView? = IAPUtility.getBundle().loadNibNamed(IAPNibName.IAPCustomActivityProgressView,
                                                                            owner: self,
                                                                            options: nil)![0] as? UIView
            self.progressView = activityView
            self.view.addSubview(self.progressView!)
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

    func showProgressIndicatorOnButton(_ progressButton: UIDProgressButton) {
        progressButton.isActivityIndicatorVisible = true
        self.navigationController?.view.isUserInteractionEnabled = false
    }

    func hideProgressIndicatorOnButton(_ progressButton: UIDProgressButton) {
        progressButton.isActivityIndicatorVisible = false
        self.navigationController?.view.isUserInteractionEnabled = true
    }
    
    // MARK: Method for creating Network Error
    func displayNoNetworkError() {
        self.stopActivityProgressIndicator()
        self.changeDisplayForNoInternet(false)
        let error = NSError(domain: NSURLErrorDomain, code: IAPConstants.IAPNoInternetError.kNoInternetCode,
                            userInfo:nil)
        self.displayErrorMessage(error)
    }

    // MARK: -
    // MARK: Methods to be overriden by subclass controllers which require customization in back and cancel navigation
    func handleCancelNavigationForNormalFlow() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func handleBackNavigationForNormalFlow() {
        self.navigationController?.popViewController(animated: true)
    }

    //process error tagging
    func mapErrorTagging(error: NSError, serverName: String) {
        var tagggingMessage = ""
        if error.code == IAPConstants.IAPNoInternetError.kNoInternetCode {
            tagggingMessage = serverName + "_" + "\(error.code)" + "_" + "NoNetwork"
        } else {
            tagggingMessage = serverName + "_" + "\(error.code)" + "_" + error.localizedDescription
        }
        trackAction(parameterData: ["error": tagggingMessage], action: IAPAnalyticsConstants.sendData)
    }
}

// MARK: -
// MARK: Protocol to load the data in Product catalogue, purchase history
// MARK: -

protocol IAPProductAndHistoryProtocol {
    func initialiseAndLoadData(_ needsOAuth: Bool)
    func fetchDataForPage(_ currentPage: Int)
}

extension IAPProductAndHistoryProtocol {
    
    func initialiseAndLoadData(_ needsOAuth: Bool = true) {
        initialiseAndLoadData(needsOAuth)
    }
}

extension IAPProductAndHistoryProtocol where Self : IAPBaseViewController {
    func initialiseAndLoadData(_ needsOAuth: Bool) {
        self.startActivityProgressIndicator()
        
        let configuarationManager = IAPConfigurationManager()
        let interfaceToUse = configuarationManager.getInterfaceForConfiguration()
        configuarationManager.getConfigurationDataWithInterface(interfaceToUse,
                                                                successCompletion: { (IAPConfigurationData) in
            guard needsOAuth else {
               self.fetchDataForPage(IAPConstants.IAPPaginationStructure.kFirstPageIndex)
                return
            }
            guard nil != IAPConfiguration.sharedInstance.oauthInfo else {
                if let accessToken = IAPConfiguration.sharedInstance.getJanrinAccessToken(){
                    let oauthDownloadManager = IAPOAuthDownloadManager(janRainAccessToken: accessToken)
                let httpInterface = oauthDownloadManager?.getInterfaceForOAuth()
                oauthDownloadManager?.getOAuthTokenWithInterface(httpInterface!,
                                                                 successCompletion: { (oauthInfo:IAPOAuthInfo) -> () in
                    self.fetchDataForPage(IAPConstants.IAPPaginationStructure.kFirstPageIndex)
                }) { (inError: NSError) -> () in
                    self.stopActivityProgressIndicator()
                    self.displayErrorMessage(inError, shouldDisplayNoInternetView: true)
                    }
                    return
                }else{
                    return
                }
            }
            self.fetchDataForPage(IAPConstants.IAPPaginationStructure.kFirstPageIndex)
        }) { (inError: NSError) in
            self.stopActivityProgressIndicator()
            self.displayErrorMessage(inError, shouldDisplayNoInternetView: true)
        }
    }
}

// MARK: -
// MARK: Protocol to handle the UI navigation for Buy Direct
// MARK: -
protocol IAPBuyDirectUINavigationProtocol {
    func isBuyDirectPreviousController() -> Bool
    func isFromBuyDirect() -> Bool
    func popToControllerBeforeBuyDirect()
}

extension IAPBuyDirectUINavigationProtocol where Self: IAPBaseViewController {

    func isBuyDirectPreviousController() -> Bool {
        let viewControllers = self.navigationController?.viewControllers
        let currentControllerIndex = viewControllers?.firstIndex(of: self)
        guard nil != currentControllerIndex && currentControllerIndex! > 0 else { return false }
        guard nil != viewControllers?[currentControllerIndex!-1] as? IAPBuyDirectViewController else { return false }
        return true
    }
    
    func isFromBuyDirect() -> Bool {
        var isFromBuyDirect = false
        guard let viewControllerList = self.navigationController?.viewControllers else {
            return isFromBuyDirect
        }
        for viewController in viewControllerList {
            guard nil != viewController as? IAPBuyDirectViewController else { continue }
            isFromBuyDirect = true
            break
        }
        return isFromBuyDirect
    }

    func popToControllerBeforeBuyDirect() {
        trackAction(parameterData: [IAPAnalyticsConstants.specialEvents: "backButtonPress"], action: IAPAnalyticsConstants.sendData)
        let controllers = self.navigationController?.viewControllers
        var indexOfPreviousVC = -1
        
        for viewController in controllers! {
            guard nil != viewController as? IAPBuyDirectViewController else { continue }
            indexOfPreviousVC += 1
            break
        }
        
        guard indexOfPreviousVC > 0 && indexOfPreviousVC < (controllers?.count)! else {
            guard indexOfPreviousVC == 0 else { return }
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        
        let viewControllerToPopToo = controllers![indexOfPreviousVC]
        self.navigationController?.popToViewController(viewControllerToPopToo, animated: true)
    }
}

// MARK: -
// MARK: Protocol to handle the Buy direct backend functionality
// MARK: -

protocol IAPBuyDirectCartProtocol : IAPBuyDirectUINavigationProtocol {
    var cartSyncHelper: IAPCartSyncHelper { get set }
    func handlePossibleBuyDirectCancel()
    func handlePossibleBuyDirectBackNavigation()
    func deleteBuyDirectCartAndPop()
}

extension IAPBuyDirectCartProtocol where Self: IAPBaseViewController {
    
    func handlePossibleBuyDirectCancel() {
        guard true == self.isFromBuyDirect() else {
            self.handleCancelNavigationForNormalFlow()
            return
        }
        
        self.deleteBuyDirectCartAndPop()
    }
    
    func handlePossibleBuyDirectBackNavigation() {
        guard true == self.isBuyDirectPreviousController() else {
            self.handleBackNavigationForNormalFlow()
            return
        }
        trackAction(parameterData: [IAPAnalyticsConstants.specialEvents: "backButtonPress"], action: IAPAnalyticsConstants.sendData)
        self.deleteBuyDirectCartAndPop()
    }
    
    func deleteBuyDirectCartAndPop() {
        self.startActivityProgressIndicator()
        self.cartSyncHelper.deleteCurrentCart(success: { (inSuccess) in
            self.stopActivityProgressIndicator()
            self.popToControllerBeforeBuyDirect()
        }) { (inError) in
            self.stopActivityProgressIndicator()
            self.displayErrorMessage(inError, needToPopOnTap: true)
        }
    }
}

// MARK: -
// MARK: Protocol to share the code for controllers to handle the swipe gesture on navigation controller for popping in Buy Direct functionality
// MARK: -

protocol IAPBuyDirectLeftToRightSwipeProtocol {
    func handleSwipeLeftToRight(_ navigationController: UINavigationController, willShowViewController
        viewController: UIViewController, animated: Bool)
}

extension IAPBuyDirectLeftToRightSwipeProtocol where Self: IAPBuyDirectUINavigationProtocol {
    func handleSwipeLeftToRight(_ navigationController: UINavigationController, willShowViewController
        viewController: UIViewController, animated: Bool) {
        guard let coordinator = navigationController.topViewController?.transitionCoordinator  else { return }
        coordinator.notifyWhenInteractionChanges({ (context) in
            guard context.isCancelled == false else { return }
            guard let directVC = viewController as? IAPBuyDirectViewController else { return }
            directVC.userSwipedToGetBack()
        })
    }
}
