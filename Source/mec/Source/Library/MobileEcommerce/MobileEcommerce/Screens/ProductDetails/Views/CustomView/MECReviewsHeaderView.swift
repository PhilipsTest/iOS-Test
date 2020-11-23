/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

protocol MECReviewHeaderDelegate: NSObjectProtocol {
    func didClickOnPrivacy(link: String)
}

class MECReviewsHeaderView: UIView {

    @IBOutlet weak var headerTextLabel: UIDHyperLinkLabel!
    weak var reviewHeaderDelegate: MECReviewHeaderDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        headerTextLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
        backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentTertiaryBackground
    }
}

extension MECReviewsHeaderView {

    // swiftlint:disable line_length

    func configureLink() {
        let hyperLinkText = "\(MECLocalizedString("mec_bazaarVoice_Terms_And_Condition"))\n\(MECLocalizedString("mec_bazaarVoice_Detail_at")) \(MECBazaarVoiceConstants.MECBazaarVoiceTermsLink)"
        headerTextLabel.text = hyperLinkText
        let hyperLinkModel = UIDHyperLinkModel()
        hyperLinkModel.highlightRange = hyperLinkText.nsRange(of: MECBazaarVoiceConstants.MECBazaarVoiceTermsLink)
        headerTextLabel.addLink(hyperLinkModel) { [weak self] (_) in
            self?.reviewHeaderDelegate?.didClickOnPrivacy(link: MECBazaarVoiceConstants.MECBazaarVoiceTermsLink)
        }
    }

    // swiftlint:enable line_length
}
