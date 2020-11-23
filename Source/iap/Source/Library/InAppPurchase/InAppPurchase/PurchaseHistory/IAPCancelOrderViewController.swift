/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS

class IAPCancelOrderViewController: IAPBaseViewController {
    
    var orderNumber:String!
    var consumerModel:IAPPRXConsumerModel!
    
    @IBOutlet weak var headingLabel : UIDLabel!
    @IBOutlet weak var descriptionLabel : UIDLabel!
    @IBOutlet weak var subDescriptionLabel : UIDLabel!
    @IBOutlet weak var callCenterMonSatTimingsLabel : UIDLabel!
    @IBOutlet weak var callCenterSunTimingsLabel : UIDLabel!
    @IBOutlet weak var callButton: UIDButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = IAPLocalizedString("iap_cancel_your_order")
        self.headingLabel.text = IAPLocalizedString("iap_cancel_order_number")! + self.orderNumber
        self.descriptionLabel.text = IAPLocalizedString("iap_cancel_order_dls_msg")!
        self.subDescriptionLabel.text = IAPLocalizedString("iap_shopping_cart_dls")! + orderNumber
        let callButtonTitle = IAPLocalizedString("iap_call")! + " " + consumerModel.getPhoneNumber()
        self.callButton.setTitle(callButtonTitle, for: UIControl.State())
        self.callCenterMonSatTimingsLabel.text = consumerModel.getWeekdayOpeningHours()
            self.callCenterSunTimingsLabel.text =  consumerModel.getWeekendOpeningHours()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.updateCartIconVisibility(false)
    }

    @IBAction func callButtonClicked(_ sender: UIDButton) {
        if let url = getPhoneNumberURL(inPhoneNumber: consumerModel.getPhoneNumber()) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func getPhoneNumberURL(inPhoneNumber: String?) -> URL? {
        guard let formattedPhoneNumber = inPhoneNumber?.replacingOccurrences(of: " ", with: "") else {return nil}
        let telURL = "tel://\(formattedPhoneNumber)"
        guard let url = URL(string: telURL) else {return nil}
        return url
    }
}
