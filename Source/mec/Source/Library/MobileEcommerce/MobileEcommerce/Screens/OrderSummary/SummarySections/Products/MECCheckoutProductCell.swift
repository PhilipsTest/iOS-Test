/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

class MECCheckoutProductCell: UITableViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UIDLabel!
    @IBOutlet weak var productPriceLabel: UIDLabel!
    @IBOutlet weak var productQuantityLabel: UIDLabel!

    func configureUI() {}
}
