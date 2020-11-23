/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

protocol MECDeliveryModeSelectionProtocol: NSObjectProtocol {
    func didSelectDeliveryMode(cell: MECDeliveryModesCell)
}

class MECDeliveryModesCell: UITableViewCell {

    @IBOutlet weak var deliveryModeRadioButton: UIDRadioButton!
    @IBOutlet weak var deliveryModeNameLabel: UIDLabel!
    @IBOutlet weak var deliveryModeDetailsLabel: UIDLabel!
    weak var deliveryModeSelectionDelegate: MECDeliveryModeSelectionProtocol?

    override func prepareForReuse() {
        super.prepareForReuse()
        deliveryModeRadioButton.delegate = nil
        deliveryModeSelectionDelegate = nil
    }
}

extension MECDeliveryModesCell {

    func configureUI() {
        deliveryModeNameLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        deliveryModeDetailsLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
    }
}

extension MECDeliveryModesCell: UIDRadioButtonDelegate {

    func radioButtonPressed(_ radioButton: UIDRadioButton) {
        deliveryModeSelectionDelegate?.didSelectDeliveryMode(cell: self)
    }
}
