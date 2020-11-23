/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS
import PhilipsIconFontDLS

protocol MECBillingAddressEditProtocol: NSObjectProtocol {
    func didClickEditBillingAddress(collectionView: UICollectionViewCell)
}

class MECPaymentDetailsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var editButton: UIDButton!
    @IBOutlet weak var cardNameLabel: UIDLabel!
    @IBOutlet weak var cardValidityLabel: UIDLabel!
    @IBOutlet weak var cardHolderNameLabel: UIDLabel!
    @IBOutlet weak var cardAddressLabel: UIDLabel!
    @IBOutlet weak var cardDisclaimerLabel: UIDLabel!
    @IBOutlet weak var paymentDetailsMainView: UIDView!

    weak var billingAddressEditDelegate: MECBillingAddressEditProtocol?

    override func prepareForReuse() {
        super.prepareForReuse()
        billingAddressEditDelegate = nil
        unselectCell()
    }
}

extension MECPaymentDetailsCollectionViewCell {

    @IBAction func editButtonClicked(_ sender: Any) {
        billingAddressEditDelegate?.didClickEditBillingAddress(collectionView: self)
    }

    func configureUI() {
        contentView.layer.cornerRadius = 4
        contentView.layer.borderWidth = 1
        configureEditButton()
    }

    func configureEditButton() {
        editButton.titleLabel?.font = UIFont.iconFont(size: UIDSize16)
        editButton.setTitle(PhilipsDLSIcon.unicode(iconType: .edit), for: .normal)
        editButton.setTitleColor(UIDThemeManager.sharedInstance.defaultTheme?.buttonQuietEmphasisText, for: .normal)
        clipsToBounds = false
        contentView.clipsToBounds = false
    }

    func selectCell() {
        paymentDetailsMainView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.textBoxDefaultValidatedBackground
        contentView.layer.borderColor = UIDThemeManager.sharedInstance.defaultTheme?.textBoxDefaultValidatedBorder?.cgColor
        cardNameLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.textBoxDefaultValidatedText
        cardValidityLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.textBoxDefaultValidatedText
        cardHolderNameLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.textBoxDefaultValidatedText
        cardAddressLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.textBoxDefaultValidatedText
        cardDisclaimerLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.textBoxDefaultValidatedText
    }

    func unselectCell() {
        paymentDetailsMainView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimary
        contentView.layer.borderColor = UIDThemeManager.sharedInstance.defaultTheme?.separatorContentBackground?.cgColor
        cardNameLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        cardValidityLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
        cardHolderNameLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        cardAddressLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
        cardDisclaimerLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
    }
}
