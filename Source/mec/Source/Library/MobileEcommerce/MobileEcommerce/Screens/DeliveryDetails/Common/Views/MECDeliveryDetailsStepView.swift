/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

enum MECDeliveryDetailsStepType: String {
    case delivery = "1"
    case checkout = "2"

    func stepName() -> String {
        switch self {
        case .delivery:
            return MECLocalizedString("mec_delivery")
        case .checkout:
            return MECLocalizedString("mec_checkout")
        }
    }
}

class MECDeliveryDetailsStepView: UIView {

    var deliveryStepView: UIView!

    @IBOutlet weak var deliveryStepNumberLabel: UIDLabel!
    @IBOutlet weak var deliveryStepTitleLabel: UIDLabel!
    @IBOutlet weak var checkoutStepNumberLabel: UIDLabel!
    @IBOutlet weak var checkoutStepTitleLabel: UIDLabel!
    @IBOutlet weak var checkoutTrackView: UIDView!

    var currentDeliveryDetailsStep: MECDeliveryDetailsStepType? = .delivery {
        didSet {
            configureStepsAppearance()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
}

extension MECDeliveryDetailsStepView {

    private func setupView() {
        deliveryStepView = loadViewFromNib()
        deliveryStepView.frame = bounds
        addSubview(deliveryStepView)
        customizeUI()
    }

    private func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: MECNibName.MECDeliveryDetailsStepView, bundle: MECUtility.getBundle())
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return UIView(frame: .zero)
        }
        return view
    }

    func customizeUI() {
        deliveryStepNumberLabel.layer.cornerRadius = deliveryStepNumberLabel.frame.width * 0.5
        deliveryStepNumberLabel.layer.masksToBounds = true

        checkoutStepNumberLabel.layer.cornerRadius = checkoutStepNumberLabel.frame.width * 0.5
        checkoutStepNumberLabel.layer.masksToBounds = true

        configureStepsAppearance()
    }

    func configureStepsAppearance() {
        deliveryStepNumberLabel.text = MECDeliveryDetailsStepType.delivery.rawValue
        deliveryStepTitleLabel.text = MECDeliveryDetailsStepType.delivery.stepName()
        checkoutStepNumberLabel.text = MECDeliveryDetailsStepType.checkout.rawValue
        checkoutStepTitleLabel.text = MECDeliveryDetailsStepType.checkout.stepName()

        switch currentDeliveryDetailsStep {
        case .delivery:
            deliveryStepNumberLabel.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.wizardDefaultOnCircleBackground
            deliveryStepNumberLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.wizardDefaultOnCircleText
            deliveryStepTitleLabel.font = UIFont(uidFont: .medium, size: 14)
            deliveryStepTitleLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.wizardDefaultOnTitleText

            checkoutStepNumberLabel.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.wizardDefaultOffCircleBackground
            checkoutStepNumberLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.wizardDefaultOffCircleText
            checkoutStepTitleLabel.font = UIFont(uidFont: .book, size: 14)
            checkoutStepTitleLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.wizardDefaultOffTitleText

            checkoutTrackView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.wizardDefaultOffTrack
        case .checkout:
            deliveryStepNumberLabel.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.wizardDefaultOnCircleBackground
            deliveryStepNumberLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.wizardDefaultOnCircleText
            deliveryStepTitleLabel.font = UIFont(uidFont: .book, size: 14)
            deliveryStepTitleLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.wizardDefaultOnTitleText

            checkoutStepNumberLabel.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.wizardDefaultOnCircleBackground
            checkoutStepNumberLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.wizardDefaultOnCircleText
            checkoutStepTitleLabel.font = UIFont(uidFont: .medium, size: 14)
            checkoutStepTitleLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.wizardDefaultOnTitleText

            checkoutTrackView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.wizardDefaultOnTrack
        default:
            break
        }
    }
}
