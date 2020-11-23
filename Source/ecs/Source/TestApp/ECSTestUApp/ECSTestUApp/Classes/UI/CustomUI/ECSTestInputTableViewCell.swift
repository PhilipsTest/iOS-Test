/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

class ECSTestInputTableViewCell: UITableViewCell {

    @IBOutlet weak var inputLabel: UIDLabel!
    @IBOutlet weak var inputTextField: UIDTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
