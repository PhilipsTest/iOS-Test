/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

protocol IAPDeliveryModeSelectionProtocol: class {
    func userSelectedRadioButton(_ inSender:IAPDeliveryModeCell)
    func userSelectedConfirmButton(_ inSender:IAPDeliveryModeCell)
}

class IAPDeliveryModeCell: UITableViewCell, UIDRadioButtonDelegate {
    
    @IBOutlet weak var radioButton: UIDRadioButton!
    @IBOutlet weak var deliveryModeNameLabel: UIDLabel!
    @IBOutlet weak var deliveryModePriceLabel: UIDLabel!
    @IBOutlet weak var deliveryModeAvailabilityLabel: UIDLabel!
    @IBOutlet weak var confirmButton: UIDButton!
    @IBOutlet weak var confirmBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmBtnBottomConstraint: NSLayoutConstraint!
    
    weak var delegate : IAPDeliveryModeSelectionProtocol?
    var modeSelected:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        radioButton.delegate = self
        confirmButton.setTitle(IAPLocalizedString("iap_confirm"), for: .normal)
        deliveryModeNameLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        deliveryModeAvailabilityLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
        deliveryModePriceLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        radioButton.isSelected = false
    }
    
    func radioButtonPressed(_ radioButton: UIDRadioButton) {
        modeSelected = true
        delegate?.userSelectedRadioButton(self)
    }
    
    @IBAction func confirmButtonTapped(_ sender: IAPDeliveryModeCell) {
        modeSelected = false
        delegate?.userSelectedConfirmButton(sender)
    }
    
}
