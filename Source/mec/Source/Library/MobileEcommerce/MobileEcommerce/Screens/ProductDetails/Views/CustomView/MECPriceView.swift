/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

class MECPriceView: UIView {

    @IBOutlet weak var priceMainStackView: UIStackView!
    @IBOutlet weak var circularView: UIDView!
    @IBOutlet weak var accessoryLabel: UIDLabel!
    @IBOutlet weak var detailsView: UIDView!
    @IBOutlet weak var primaryLabel: UIDLabel!
    @IBOutlet weak var secondaryLabel: UIDLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        MECUtility.getBundle().loadNibNamed(MECNibName.MECPriceView, owner: self, options: nil)
        self.addSubview(priceMainStackView)
        configureCommonUIAppearance()
    }
}

extension MECPriceView {

    fileprivate func configureCommonUIAppearance() {
        priceMainStackView.translatesAutoresizingMaskIntoConstraints = false
        priceMainStackView.constrainToSuperviewAccordingToLanguage()

        self.backgroundColor = .clear
        detailsView.layer.cornerRadius = detailsView.frame.height * 0.5
        detailsView.layer.masksToBounds = true

        circularView.layer.cornerRadius = circularView.frame.width * 0.5
        circularView.layer.masksToBounds = true

        priceMainStackView.bringSubviewToFront(circularView)

        if let theme = UIDThemeManager.sharedInstance.defaultTheme {
            self.apply(dropShadow: UIDDropShadow(level: .level2, theme: theme))
        }
    }

    fileprivate func configurePriceView() {
        configureUIAccordingToTheme()
    }

    fileprivate func configureDiscountView() {
        let orangeThemeConfiguration = UIDThemeConfiguration(colorRange: .orange, tonalRange: .veryLight)
        let orangeTheme = UIDTheme(themeConfiguration: orangeThemeConfiguration)
        configureUIAccordingToTheme(theme: orangeTheme)
    }

    fileprivate func configureUIAccordingToTheme(theme: UIDTheme? = UIDThemeManager.sharedInstance.defaultTheme) {
        circularView.backgroundColor = theme?.tokenDefaultCircleBackground
        accessoryLabel.textColor = theme?.tokenDefaultCircleText

        primaryLabel.textColor = theme?.tokenDefaultText
        secondaryLabel.textColor = theme?.contentItemTertiaryText

        detailsView.backgroundColor = theme?.contentPrimaryBackground
    }

    fileprivate func displayCurrency(currency: String?) {
        if let currency = currency, currency.count > 0 {
            accessoryLabel.text = currency
        }
    }

    func displayDiscounted(price: String?) {
        configurePriceView()
        if let discountedPrice = price, discountedPrice.count > 0 {
            primaryLabel.text = discountedPrice
            accessoryLabel.font = UIFont.mecIconFont(size: 18)
            displayCurrency(currency: MECIconFont.unicode(iconType: .currency))
            self.isHidden = false
        }
    }

    func displayActual(price: String?) {
        configurePriceView()
        if let actualPrice = price, actualPrice.count > 0 {
            secondaryLabel.setStrikeThroughAttributedText(actualPrice)
            accessoryLabel.font = UIFont.mecIconFont(size: 18)
            displayCurrency(currency: MECIconFont.unicode(iconType: .currency))
            self.isHidden = false
        }
    }

    func displayDiscountPercentage(discountPercentValue: String?) {
        configureDiscountView()
        if let discountPercentValue = discountPercentValue, discountPercentValue.count > 0 {
            primaryLabel.text = discountPercentValue
            displayCurrency(currency: "%")
            self.isHidden = false
        }
    }
}
