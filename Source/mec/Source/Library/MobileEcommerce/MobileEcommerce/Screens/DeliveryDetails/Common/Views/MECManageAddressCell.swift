/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS
import PhilipsIconFontDLS

protocol MECManageAddressProtocol: NSObjectProtocol {
     func didSelectManageAddress()
}

class MECManageAddressCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    weak var manageAddressDelegate: MECManageAddressProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        manageAddressDelegate = nil
    }

    @IBAction func manageAddressButtonClicked(_ sender: Any) {
        manageAddressDelegate?.didSelectManageAddress()
    }
}
