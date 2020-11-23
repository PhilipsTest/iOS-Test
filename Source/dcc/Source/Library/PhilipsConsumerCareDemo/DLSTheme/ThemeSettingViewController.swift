/** © Koninklijke Philips N.V., 2016. All rights reserved. */

import UIKit
import PhilipsUIKitDLS
import PhilipsIconFontDLS

// ****************************************************
// MARK: - ThemeSettingViewController
// ****************************************************
class ThemeSettingViewController: UIViewController {
    fileprivate let cellHeight: CGFloat = 48.0
    fileprivate let colorRangeCellsCount: Int = 8
    fileprivate let tonalRangeCellsCount: Int = 4
    fileprivate let closeIconSize: CGFloat = 12.0
    @IBOutlet fileprivate weak var colorRangeCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var tonalRangeCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var navigationCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var accentColorRangeCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var colorRangeSeparator: UIView!
    @IBOutlet fileprivate weak var tonalRangeSeparator: UIView!
    @IBOutlet fileprivate weak var errorMessageCloseButton: UIButton!
    @IBOutlet fileprivate weak var errorMessageView: UIView!
    fileprivate var themeSettings = [UICollectionView: CollectionViewSetting]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorMessageCloseButton.titleLabel?.font = UIFont.iconFont(size: closeIconSize)
        self.errorMessageCloseButton.setTitle(PhilipsDLSIcon.unicode(iconType: .cross), for: .normal)
        
        let separatorColor = UIColor.color(range: .gray, level: .color10)
        self.colorRangeSeparator.backgroundColor = separatorColor
        self.tonalRangeSeparator.backgroundColor = separatorColor
        self.themeSettings[self.colorRangeCollectionView] = self.settingForCollectionView(self.colorRangeCollectionView)
        self.themeSettings[self.tonalRangeCollectionView] = self.settingForCollectionView(self.tonalRangeCollectionView)
        self.themeSettings[self.navigationCollectionView] = self.settingForCollectionView(self.navigationCollectionView)
        self.themeSettings[self.accentColorRangeCollectionView] =
            self.settingForCollectionView(self.accentColorRangeCollectionView)
        self.reloadAllCollectionView()
    }
    
    @IBAction func handleErrorMessageCloseButtonPressed(_ sender: UIButton) {
        self.shouldHideErrorMessageView(true)
    }
    
    @IBAction func handleCancelBarButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handlePreviewBarButtonPressed(_ sender: UIBarButtonItem) {
        let colorRangeSetting = self.themeSettings[self.colorRangeCollectionView]!
        let colorRangeSelectedIndex = colorRangeSetting.selectedIndex
        let tonalRangeSetting = self.themeSettings[self.tonalRangeCollectionView]!
        let tonalRangeSelectedIndex = tonalRangeSetting.selectedIndex
        let navTonalRangeSetting = self.themeSettings[self.navigationCollectionView]!
        let navTonalRanges = navTonalRangeSetting.tonalRanges
        let navTonalRangeSelectedIndex = navTonalRangeSetting.selectedIndex
        let themeConfiguration = UIDThemeConfiguration(colorRange: colorRangeSetting.colorRanges[colorRangeSelectedIndex],
                                                       tonalRange: tonalRangeSetting.tonalRanges[tonalRangeSelectedIndex],
                                                       navigationTonalRange: navTonalRanges[navTonalRangeSelectedIndex])
        UIDThemeManager.sharedInstance.setDefaultTheme(theme: UIDTheme(themeConfiguration: themeConfiguration),
                                                       applyNavigationBarStyling: true)
        UIDThemeManager.sharedInstance.setNavigationBarShadowLevel(.one)
        self.forceRefreshUIApperence()
        self.performSegue(withIdentifier: "ThemePreviewStoryboardSegue", sender: sender)
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.reloadAllCollectionView()
    }
    
    fileprivate func reloadAllCollectionView() {
        self.colorRangeCollectionView.reloadData()
        self.tonalRangeCollectionView.reloadData()
        self.navigationCollectionView.reloadData()
        self.accentColorRangeCollectionView.reloadData()
    }
    
    private func shouldHideErrorMessageView(_ shouldHide: Bool) {
        for view in self.errorMessageView.subviews {
            view.isHidden = shouldHide
        }
    }
    
    private func forceRefreshUIApperence() {
        let windows = UIApplication.shared.windows
        for window in windows {
            for view in window.subviews {
                view.removeFromSuperview()
                window.addSubview(view)
            }
        }
    }
}

// ****************************************************
// MARK: - UICollectionViewDataSource
// ****************************************************
extension ThemeSettingViewController: UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.themeSettings[collectionView]!.numberOfItem
    }
    
    @objc(collectionView:cellForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewSetting = self.themeSettings[collectionView]!
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewSetting.cellIdentifier,
                                                      for: indexPath)
        let collectionViewCell = (cell as? ColorRangeCollectionViewCell)!
        let selectedColorRange = self.selectedColorRangeForCollectionView(collectionView, cellForItemAt: indexPath)
        collectionViewCell.configureCellWithSetting(collectionViewSetting,
                                                    selectedColorRange: selectedColorRange,
                                                    cellForItemAt: indexPath)
        return collectionViewCell
    }
    
    @objc(collectionView:layout:sizeForItemAtIndexPath:)
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation.isLandscape {
            return self.themeSettings[collectionView]!.landscapeSizeForItem
        } else {
            return self.themeSettings[collectionView]!.portraitSizeForItem
        }
    }
    
    @objc(collectionView:layout:insetForSectionAtIndex:)
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    @objc(collectionView:didSelectItemAtIndexPath:)
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.themeSettings[collectionView]!.selectedIndex != indexPath.row {
            self.themeSettings[collectionView]!.selectedIndex = indexPath.row
            self.reloadAllCollectionView()
        }
    }
    
    private func selectedColorRangeForCollectionView(_ collectionView: UICollectionView,
                                                     cellForItemAt indexPath: IndexPath) -> UIDColorRange {
        let collectionViewSetting = self.themeSettings[collectionView]!
        var selectedColorRange = collectionViewSetting.colorRanges[indexPath.row]
        switch collectionView {
        case self.tonalRangeCollectionView,
            self.navigationCollectionView:
            let colorRangeCollectionViewSetting = self.themeSettings[self.colorRangeCollectionView]!
            selectedColorRange = collectionViewSetting.colorRanges[colorRangeCollectionViewSetting.selectedIndex]
        default:
            selectedColorRange = collectionViewSetting.colorRanges[indexPath.row]
        }
        return selectedColorRange
    }
}

// ****************************************************
// MARK: - UICollectionView Setting
// ****************************************************
extension ThemeSettingViewController {
    fileprivate func settingForCollectionView(_ collectionView: UICollectionView) -> CollectionViewSetting {
        var collectionViewSetting = CollectionViewSetting()
        let defaultTheme = UIDThemeManager.sharedInstance.defaultTheme
        switch collectionView {
        case self.colorRangeCollectionView:
            self.settingForColorRangeCollectionView(collectionViewSetting: &collectionViewSetting)
            collectionViewSetting.selectedIndex = collectionViewSetting.colorRanges.firstIndex { $0 == defaultTheme?.colorRange }!
        case self.tonalRangeCollectionView:
            self.settingForTonalRangeCollectionView(collectionViewSetting: &collectionViewSetting)
            collectionViewSetting.selectedIndex = collectionViewSetting.tonalRanges.firstIndex { $0 == defaultTheme?.tonalRange }!
        case self.navigationCollectionView:
            self.settingForNavigationTonalRangeCollectionView(collectionViewSetting: &collectionViewSetting)
            collectionViewSetting.selectedIndex =
                collectionViewSetting.tonalRanges.firstIndex { $0 == defaultTheme?.navigationTonalRange }!
        case self.accentColorRangeCollectionView:
            self.settingForColorRangeCollectionView(collectionViewSetting: &collectionViewSetting)
            collectionViewSetting.selectedIndex = collectionViewSetting.colorRanges.firstIndex { $0 == defaultTheme?.colorRange }!
        default:
            collectionViewSetting = CollectionViewSetting()
        }
        let landscapeDeviceWidth = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        let portraitDeviceWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        let landscapeCellWidth = (landscapeDeviceWidth - cellHeight) / CGFloat(colorRangeCellsCount)
        let portraitCellWidth = (portraitDeviceWidth - cellHeight) / CGFloat(colorRangeCellsCount)
        collectionViewSetting.landscapeSizeForItem = CGSize(width: landscapeCellWidth, height: cellHeight)
        collectionViewSetting.portraitSizeForItem = CGSize(width: portraitCellWidth, height: cellHeight)
        return collectionViewSetting
    }
    
    private func settingForColorRangeCollectionView(collectionViewSetting: inout CollectionViewSetting) {
        collectionViewSetting.numberOfItem = colorRangeCellsCount
        collectionViewSetting.textArray = ["GB", "BL", "AQ", "GR", "OR", "PI", "PU", "GR"]
        collectionViewSetting.checkMarkIconColors = [.color0, .color0, .color0, .color0,
                                                     .color0, .color0, .color0, .color0]
        collectionViewSetting.gradientColorLevels = [[.color50, .color45, .color40, .color35],
                                                     [.color50, .color45, .color40, .color35],
                                                     [.color50, .color45, .color40, .color35],
                                                     [.color50, .color45, .color40, .color35],
                                                     [.color50, .color45, .color40, .color35],
                                                     [.color50, .color45, .color40, .color35],
                                                     [.color50, .color45, .color40, .color35],
                                                     [.color50, .color45, .color40, .color35]]
    }
    
    private func settingForTonalRangeCollectionView(collectionViewSetting: inout CollectionViewSetting) {
        collectionViewSetting.numberOfItem = tonalRangeCellsCount
        collectionViewSetting.textArray = ["VD", "B", "VL", "UL"]
        collectionViewSetting.checkMarkIconColors = [.color0, .color0, .color75, .color75]
        collectionViewSetting.gradientColorLevels = [[.color75, .color70], [.color45, .color40],
                                                     [.color15, .color10], [.color5, .color0]]
    }
    
    private func settingForNavigationTonalRangeCollectionView(collectionViewSetting: inout CollectionViewSetting) {
        collectionViewSetting.numberOfItem = tonalRangeCellsCount
        collectionViewSetting.textArray = ["VD", "B", "VL", "UL"]
        collectionViewSetting.checkMarkIconColors = [.color0, .color0, .color75, .color75]
        collectionViewSetting.gradientColorLevels = [[.color70, .color65], [.color45, .color40],
                                                     [.color10, .color5],  [.color5, .color0]]
    }
}
