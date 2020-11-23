/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra
import PhilipsUIKitDLS
import PlatformInterfaces

protocol IAPWorldPayProtocol: class{
    func navigateToParentFlowScreen(_ inSender:AnyObject,statusTag:Int);
}

class IAPPaymentConfirmationViewController: IAPBaseViewController, IAPBuyDirectUINavigationProtocol {
    
    @IBOutlet weak var statusLabel:UIDLabel?
    @IBOutlet weak var orderDescLabel: UIDLabel?
    @IBOutlet weak var orderNoLabel: UIDLabel?
    @IBOutlet weak var mailDescLabel: UIDLabel?
    var orderNo : String!
    var paymentStatusTag : Int?
    weak var delegate: IAPWorldPayProtocol!
    var paymentStatusString:String = IAPLocalizedString("iap_success")!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.updateCartIconVisibility(false)
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.showPaymentStatusMessage()
        trackPage(pageName: IAPConstants.IAPAppTaggingStringConstants.kConfirmationPage)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    fileprivate func showPaymentStatusMessage() {
        
        if let paymentStatusCode:Int = self.paymentStatusTag {
            
            switch paymentStatusCode {
                
            case IAPConstants.IAPPaymentResponseStatus.kPaymentSuccessTag  :
                
                self.navigationItem.title = IAPLocalizedString("iap_confirmation")
                self.statusLabel!.text = IAPLocalizedString("iap_thank_for_order")
                self.orderDescLabel!.text = IAPLocalizedString("iap_your_order_number")
                self.orderNoLabel!.text = self.orderNo
                
                let emailAttribute = [NSAttributedString.Key.font: UIFont(name: "CentraleSansBold", size: 16.0) ?? UIFont.systemFont(ofSize: 16)]
                
                if let userEmail = IAPConfiguration.sharedInstance.getUserDetails([UserDetailConstants.EMAIL])?[UserDetailConstants.EMAIL]
                {
                    let emailattrString = NSAttributedString(string: ("  " + userEmail), attributes: emailAttribute)
                    let confirmationAttribute = [NSAttributedString.Key.font: UIFont(name: "CentraleSansBook", size: 16.0) ?? UIFont.systemFont(ofSize: 16)]
                    let confirmationString = NSAttributedString(string:IAPLocalizedString("iap_confirmation_email_msg")!, attributes: confirmationAttribute)
                    let mailDescString = NSMutableAttributedString()
                    mailDescString.append(confirmationString)
                    mailDescString.append(emailattrString)
                    self.mailDescLabel!.attributedText = mailDescString
                }
                self.paymentStatusString = IAPLocalizedString("iap_success")!
                trackAction(parameterData: ["purchaseID": self.orderNo ?? ""], action: IAPAnalyticsConstants.sendData)
                trackAction(parameterData: [IAPAnalyticsConstants.specialEvents: "purchase"], action: IAPAnalyticsConstants.sendData)
                
            case IAPConstants.IAPPaymentResponseStatus.kPaymentFailureTag  :
                self.statusLabel!.text = IAPLocalizedString("iap_Payment_failure")!
                self.paymentStatusString = IAPLocalizedString("iap_failed")!
                
            case IAPConstants.IAPPaymentResponseStatus.kPaymentPendingTag  :
                self.statusLabel!.text = IAPLocalizedString("iap_payment_is_pending")!
                self.paymentStatusString = IAPLocalizedString("iap_pending")!
                
            case IAPConstants.IAPPaymentResponseStatus.kPaymentCancelTag  :
                self.statusLabel!.text = IAPLocalizedString("iap_Payment_cancel")!
                self.paymentStatusString = IAPLocalizedString("iap_cancel")!
                
            default :
                break
                
            }
        }
        trackAction(parameterData: ["paymentStatus": self.paymentStatusString], action: IAPAnalyticsConstants.sendData)
    }
    
    @IBAction func statusButtonClicked(_ sender:AnyObject) {
        
        guard false == self.isFromBuyDirect() else {
            self.popToControllerBeforeBuyDirect()
            return
        }
        finishIAPFlow(with: sender)
    }
    
    func finishIAPFlow(with sender:AnyObject) {
        guard let orderFlowCompletionDelegate = IAPConfiguration.sharedInstance.orderFlowCompletionDelegate else {
            popToCataloguePage(bypassDelegateCheck: true, sender: sender)
            return
        }
        if let orderPlacedCallback = orderFlowCompletionDelegate.didPlaceOrder {
            orderPlacedCallback()
            popToCataloguePage(bypassDelegateCheck: false, sender: sender)
        } else {
            popToCataloguePage(bypassDelegateCheck: false, sender: sender)
        }
    }
    
    func popToCataloguePage(bypassDelegateCheck:Bool, sender:AnyObject) {
        if bypassDelegateCheck {
            self.delegate.navigateToParentFlowScreen(sender, statusTag: self.paymentStatusTag!)
        } else {
            if let shouldPopToCatalogue = IAPConfiguration.sharedInstance.orderFlowCompletionDelegate?.shouldPopToProductList(), shouldPopToCatalogue == true {
                self.delegate.navigateToParentFlowScreen(sender, statusTag: self.paymentStatusTag!)
            }
        }
    }
}
