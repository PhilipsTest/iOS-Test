/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS

protocol MECStockFilterCellDelegate: NSObjectProtocol {
    func didClickOnStock(tableCell: MECStockFilterCell, selected: Bool)
}

class MECStockFilterCell: UITableViewCell {

    weak var delegate: MECStockFilterCellDelegate?
    @IBOutlet weak var filterSelectionCheckbox: UIDCheckBox!

    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
    }

    @IBAction func filterSelectionValueChanged(_ sender: Any) {
        delegate?.didClickOnStock(tableCell: self, selected: filterSelectionCheckbox.isChecked)
    }
}
