/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

protocol MECSortCellDelegate: NSObjectProtocol {
    func didSelectSort(tableCell: MECProductSortCell)
}

class MECProductSortCell: UITableViewCell {

    @IBOutlet weak var sortRadioButton: UIDRadioButton!
    @IBOutlet weak var sortLabel: UIDLabel!
    weak var sortSelectionDelegate: MECSortCellDelegate?

    override func prepareForReuse() {
        super.prepareForReuse()
        sortRadioButton.delegate = nil
    }
}

extension MECProductSortCell: UIDRadioButtonDelegate {

    func radioButtonPressed(_ radioButton: UIDRadioButton) {
        sortSelectionDelegate?.didSelectSort(tableCell: self)
    }
}
