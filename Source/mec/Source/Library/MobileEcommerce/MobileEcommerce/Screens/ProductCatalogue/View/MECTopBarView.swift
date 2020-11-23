/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsIconFontDLS
import PhilipsUIKitDLS

let listButtonTag = 100
let gridButtonTag = 101

enum MECViewType {
    case listView
    case gridView
}

protocol MECTopBarDelegate: NSObjectProtocol {
    func didSelectViewType(viewType: MECViewType)
    func didSelectFilter()
}

class MECTopBarView: UIView {

    @IBOutlet weak var listViewButton: UIDButton!
    @IBOutlet weak var gridViewButton: UIDButton!

    @IBOutlet weak var containerView: UIDView!
    @IBOutlet weak var filterButton: UIDButton!

    weak var delegate: MECTopBarDelegate?

    private func configureButton(button: UIDButton, title: String, font: UIFont?) {
        button.buttonStyle = .iconOnly
        button.philipsType = .quiet
        button.titleLabel?.font = font
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText, for: .normal)
        button.contentEdgeInsets = .zero
    }

    private func getSelectedImage() -> UIImage? {
        let selectedView = UIDView(frame: CGRect(x: 0, y: 0, width: listViewButton.bounds.width, height: listViewButton.bounds.height))
        selectedView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.toggleButtonInputQuietOnBackground
        selectedView.borderColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryDisabledText
        selectedView.borderWidth = 1
        return selectedView.drawImage()
    }

    func updateUI() {
        containerView.backgroundColorType = .secondary
        configureButton(button: listViewButton, title: PhilipsDLSIcon.unicode(iconType: .listView), font: UIFont.iconFont(size: UIDSize24))
        configureButton(button: gridViewButton, title: MECIconFont.unicode(iconType: .grid), font: UIFont.mecIconFont(size: UIDSize24))
        configureButton(button: filterButton, title: MECIconFont.unicode(iconType: .filter), font: UIFont.mecIconFont(size: UIDSize24))
        viewTypeButtonTapped(sender: listViewButton)
    }

    func filterOptionEnabled(enabled: Bool) {
        filterButton.isEnabled = enabled
    }

    func filterOptionSelected(selected: Bool) {
        let filterIcon = selected ? MECIconFont.unicode(iconType: .filterSelected) : MECIconFont.unicode(iconType: .filter)
        configureButton(button: filterButton, title: filterIcon, font: UIFont.mecIconFont(size: UIDSize24))
    }

    func shouldHideFilterOption(shouldHide: Bool) {
        filterButton.isHidden = shouldHide
    }

    @IBAction func filterButtonClicked(sender: UIDButton) {
        delegate?.didSelectFilter()
    }

    @IBAction func viewTypeButtonTapped(sender: UIDButton) {
        let viewType: MECViewType = (sender.tag == gridButtonTag) ? .gridView : .listView
        if !sender.isSelected {
            listViewButton.isSelected = false
            gridViewButton.isSelected = false

            listViewButton.setBackgroundImage(nil, for: .normal)
            gridViewButton.setBackgroundImage(nil, for: .normal)

            sender.isSelected = true
            sender.setBackgroundImage(getSelectedImage(), for: .normal)

            delegate?.didSelectViewType(viewType: viewType)
        }
    }
}
