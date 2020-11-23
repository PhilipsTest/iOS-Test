/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class MECListViewLayout: UICollectionViewLayout {

    let numberOfColumns = 1
    let cellHeight: CGFloat = 155
    let cellPadding = CGPoint(x: 0, y: 0)
    fileprivate var newLayoutAttributes: [String: [UICollectionViewLayoutAttributes]]!
    fileprivate var contentHeight: CGFloat = 0.0

    fileprivate var contentWidth: CGFloat {
        if let inCollectionView = collectionView {
            let insets = inCollectionView.contentInset
            return inCollectionView.bounds.width  - insets.left - insets.right
        } else {
            return .zero
        }
    }

    override func prepare() {
        super.prepare()
        newLayoutAttributes = [:]
        contentHeight = 0
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffsetList = [CGFloat]()

        for column in 0 ..< numberOfColumns {
            xOffsetList.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffsetList = [CGFloat](repeating: contentHeight, count: numberOfColumns)
        if let inCollectionView = collectionView {
            var layoutAttributesFirstSection = [UICollectionViewLayoutAttributes]()
            for item in 0 ..< inCollectionView.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)
                let frame = CGRect(x: xOffsetList[column], y: yOffsetList[column], width: columnWidth, height: bannerViewHeight)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                layoutAttributesFirstSection.append(attributes)
                yOffsetList[column] = yOffsetList[column] + bannerViewHeight
                column = column == (numberOfColumns - 1) ? 0 : column + 1
            }
            newLayoutAttributes["0"] = layoutAttributesFirstSection

            var layoutAttributes = [UICollectionViewLayoutAttributes]()
            for item in 0 ..< inCollectionView.numberOfItems(inSection: 1) {
                let indexPath = IndexPath(item: item, section: 1)
                let height = cellPadding.y + cellHeight           // Item height
                let frame = CGRect(x: xOffsetList[column], y: yOffsetList[column], width: columnWidth, height: height) // Item frame
                let insetFrame = frame.insetBy(dx: cellPadding.x, dy: cellPadding.y)

                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                layoutAttributes.append(attributes)
                contentHeight = max(contentHeight, frame.maxY)
                yOffsetList[column] = yOffsetList[column] + height
                column = column == (numberOfColumns - 1) ? 0 : column + 1
            }
            newLayoutAttributes["1"] = layoutAttributes
        }
    }

    override open var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttribute = newLayoutAttributes["0"]?.filter { $0.frame.intersects(rect) }
        if let layoutAttribute1 = newLayoutAttributes["1"]?.filter({ $0.frame.intersects(rect) }) {
            for layout in layoutAttribute1 {
                layoutAttribute?.append(layout)
            }
        }
        return layoutAttribute
    }

    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard newLayoutAttributes["\(indexPath.section)"]?.count ?? 0 > 0 else {
            return nil
        }
        return newLayoutAttributes["\(indexPath.section)"]?[indexPath.row]
    }
}
