/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

class MECLoadingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var loadingIndicator: UIDProgressIndicator!
}

extension MECLoadingCollectionViewCell {

    func customizeUI() {
        contentView.layer.cornerRadius = 4
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIDThemeManager.sharedInstance.defaultTheme?.separatorContentBackground?.cgColor
        loadingIndicator.startAnimating()
    }
}
