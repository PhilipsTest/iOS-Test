/** © Koninklijke Philips N.V., 2016. All rights reserved. */

import UIKit
import PhilipsUIKitDLS
// ****************************************************
// MARK: - ColorRangeCollectionViewCell
// ****************************************************
class ColorRangeCollectionViewCell: UICollectionViewCell {
    @IBOutlet fileprivate weak var label: UILabel!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    fileprivate var gradientLayer: CAGradientLayer?
    
    func configureCellWithSetting(_ collectionViewSetting: CollectionViewSetting,
                                  selectedColorRange: UIDColorRange,
                                  cellForItemAt indexPath: IndexPath) {
        self.label.text = collectionViewSetting.textArray[indexPath.row]
        self.colorRangeGradientLayer(colorRange: selectedColorRange,
                                     colorLevels: collectionViewSetting.gradientColorLevels[indexPath.row])
        let bundle = Bundle(for: ColorRangeCollectionViewCell.self)
        self.imageView.image = UIImage(named: "checkbox", in: bundle, compatibleWith: nil)
        let textColor = UIColor.color(range: selectedColorRange,
                                      level: collectionViewSetting.checkMarkIconColors[indexPath.row])
        self.imageView.tintColor = textColor
        self.label.textColor = textColor
        self.imageView.isHidden = indexPath.row == collectionViewSetting.selectedIndex ? false : true
    }
}

// ****************************************************
// MARK: - ColorRangeCollectionViewCell's Extension
// ****************************************************
extension ColorRangeCollectionViewCell {
    func colorRangeGradientLayer(colorRange: UIDColorRange, colorLevels: [UIDColorLevel]) {
        self.gradientLayer?.removeFromSuperlayer()
        self.gradientLayer = CAGradientLayer()
        var gradientColors = [CGColor]()
        for colorLevel in colorLevels {
            gradientColors.append(UIColor.color(range: colorRange, level: colorLevel)!.cgColor)
        }
        self.gradientLayer?.colors = gradientColors
        self.gradientLayer?.frame = self.bounds
        self.layer.insertSublayer(self.gradientLayer!, at: 0)
    }
}

// ****************************************************
// MARK: - CollectionViewSetting
// ****************************************************
struct CollectionViewSetting {
    var numberOfItem: Int = 0
    var portraitSizeForItem: CGSize = CGSize.zero
    var landscapeSizeForItem: CGSize = CGSize.zero
    let cellIdentifier: String = "ColorRangeCollectionViewCell"
    var textArray: [String] = [String]()
    var checkMarkIconColors: [UIDColorLevel] = [UIDColorLevel]()
    var gradientColorLevels: [[UIDColorLevel]] = [[UIDColorLevel]]()
    var selectedIndex: Int = 0
    let colorRanges: [UIDColorRange] = [.groupBlue, .blue, .aqua, .green, .orange, .pink, .purple, .gray]
    let tonalRanges: [UIDTonalRange] = [.veryDark, .bright, .veryLight, .ultraLight]
}
