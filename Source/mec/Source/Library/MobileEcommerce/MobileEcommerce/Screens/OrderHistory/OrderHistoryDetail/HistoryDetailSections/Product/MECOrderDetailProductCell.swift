/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS

protocol MECOrderDetailProductDelegate: NSObjectProtocol {
    func didClickOnTrackOrderButton(cell: MECOrderDetailProductCell)
}

class MECOrderDetailProductCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UIDLabel!
    @IBOutlet weak var productPriceLabel: UIDLabel!
    @IBOutlet weak var productQuantityLabel: UIDLabel!
    @IBOutlet weak var trackOrderButton: UIDButton!

    weak var delegate: MECOrderDetailProductDelegate?

    func configureUI() {
        trackOrderButton.setTitle(MECLocalizedString("mec_track_order"), for: .normal)
    }

    @IBAction func trackOrderButtonoClicked(_ sender: Any) {
        delegate?.didClickOnTrackOrderButton(cell: self)
    }
}
