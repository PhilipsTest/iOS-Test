/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

class MECProductReviewCell: UITableViewCell {

    @IBOutlet weak var productReviewsMainView: UIDView!
    @IBOutlet weak var productReviewRatingBar: UIDRatingBar!
    @IBOutlet weak var productReviewTitleLabel: UIDLabel!
    @IBOutlet weak var productReviewTimeLabel: UIDLabel!
    @IBOutlet weak var productReviewDescriptionLabel: UIDLabel!
    @IBOutlet weak var prosIconLabel: UIDLabel!
    @IBOutlet weak var prosValueLabel: UIDLabel!
    @IBOutlet weak var consIconLabel: UIDLabel!
    @IBOutlet weak var consValueLabel: UIDLabel!
    @IBOutlet weak var prosSection: UIStackView!
    @IBOutlet weak var consSection: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        prosSection.isHidden = true
        consSection.isHidden = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        prosSection.isHidden = true
        consSection.isHidden = true
        productReviewTitleLabel.text = ""
        productReviewTimeLabel.text = ""
        productReviewDescriptionLabel.text = ""
        prosValueLabel.text = ""
        consValueLabel.text = ""
    }
}

extension MECProductReviewCell {

    func customizeCellAppearanceFor(row: Int) {
        configureUIApperance()
        productReviewsMainView.backgroundColor = row % 2 == 0 ?
            UIDThemeManager.sharedInstance.defaultTheme?.contentPrimaryBackground :
            UIDThemeManager.sharedInstance.defaultTheme?.contentSecondaryNeutralBackground
    }

    func configureUIApperance() {
        productReviewTitleLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        productReviewTimeLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
        productReviewDescriptionLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText

        prosIconLabel.cornerRadius = prosIconLabel.frame.height * 0.5
        prosIconLabel.layer.masksToBounds = true
        prosIconLabel.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSignalTextSuccess
        prosIconLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimary

        consIconLabel.cornerRadius = consIconLabel.frame.height * 0.5
        consIconLabel.layer.masksToBounds = true
        consIconLabel.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSignalTextError
        consIconLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimary
    }

    func displayPros(pros: String?) {
        if let pros = pros, pros.count > 0 {
            prosIconLabel.text = "\u{FF0B}"
            prosValueLabel.text = pros
            prosSection.isHidden = false
        }
    }

    func displayCons(cons: String?) {
        if let cons = cons, cons.count > 0 {
            consIconLabel.text = "\u{FF0D}"
            consValueLabel.text = cons
            consSection.isHidden = false
        }
    }
}
