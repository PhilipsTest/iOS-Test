/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra
import PhilipsUIKitDLS

class IAPPurchaseHistoryDetailCustomerCareCell: UITableViewCell {
    
    @IBOutlet weak var consumerCareContactDetailsLabel : UIDLabel?
    
    @IBOutlet weak var monSatTimeLabel: UIDLabel?
    @IBOutlet weak var sundayTimeLabel: UIDLabel?
    @IBOutlet weak var separatorView : UIDSeparator?
    @IBOutlet weak var callUsButton : UIDButton?
    
    var consumerCareInfo: IAPPRXConsumerModel!
    var consumerCareInterface : IAPPRXConsumerInterface!
    var phoneNumber: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
    func updateConsumerCareDetail(consumerCareInfo: IAPPRXConsumerModel) {
        phoneNumber = consumerCareInfo.getPhoneNumber()
        monSatTimeLabel?.text = consumerCareInfo.getWeekdayOpeningHours()
        sundayTimeLabel?.text = consumerCareInfo.getWeekendOpeningHours()
        let callButtonTitle = (IAPLocalizedString("iap_call") ?? " ") + " " + (phoneNumber ?? "")
        callUsButton?.isEnabled = phoneNumber != "" ? true : false
        callUsButton?.setTitle(callButtonTitle, for: .normal)
        
        if self.getPhoneNumberURL(inPhoneNumber: phoneNumber) == nil {
            callUsButton?.isEnabled = false
            callUsButton?.setTitle((IAPLocalizedString("iap_call") ?? " "), for: .normal)
        }
    }
    
    @IBAction func callUSButton(_ sender: UIDButton) {
        guard let url = getPhoneNumberURL(inPhoneNumber: phoneNumber) else {
            return
        }
        #if targetEnvironment(simulator)
            // Alert for Simulator 
        #else
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        #endif
    }

    func getPhoneNumberURL(inPhoneNumber: String?) -> URL? {
        guard let formattedPhoneNumber = inPhoneNumber?.replacingOccurrences(of: " ", with: "") else {return nil}
        let telURL = "tel://\(formattedPhoneNumber)"
        guard let url = URL(string: telURL) else {return nil}
        return url
    }
}
