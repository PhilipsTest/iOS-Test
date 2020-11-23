/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

class MECBannerViewContainerCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIDView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        for view in containerView.subviews {
            view.removeFromSuperview()
        }
    }
}
