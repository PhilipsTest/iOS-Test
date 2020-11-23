/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS
import PhilipsEcommerceSDK

protocol MECProductCellUpdater {
    func updateProductCell(productCell: MECProductCell, with product: MECProduct?)
}

extension MECProductCellUpdater {
    func updateProductCell(productCell: MECProductCell, with product: MECProduct?) {
        productCell.configureUI()
        productCell.productCTN.text = product?.fetchProductCTN()
        productCell.productTitle.text = product?.product?.productPRXSummary?.productTitle
        if let discountedPrice = product?.product?.attributes?.discountPrice,
           product?.product?.attributes?.price?.value ?? 0 > discountedPrice.value ?? 0 {
            productCell.productDiscountedPrice.text = product?.product?.attributes?.discountPrice?.formattedValue
            productCell.productActualPrice.setStrikeThroughAttributedText(product?.product?.attributes?.price?.formattedValue)
        } else {
            productCell.productDiscountedPrice.text = product?.product?.attributes?.price?.formattedValue
        }
        let averageProductRating = product?.averageRating?.floatValue.rounded(digits: 1) ?? 0
        productCell.ratingBar.ratingText = "\(averageProductRating)"
        productCell.ratingBar.ratingValue = CGFloat(averageProductRating)
        productCell.reviewCount.text = "(\(product?.totalNumberOfReviews?.intValue ?? 0) \(MECLocalizedString("mec_reviews")))"
        if let imageURL = product?.product?.productPRXSummary?.imageURL,
            let url = URL(string: imageURL) {
            productCell.productImageView.setImageWith(url, placeholderImage: nil)
        }

        MECUtility.shouldShowSRP(for: product) { (shouldShow) in
            productCell.suggestedRetailPriceLabel.isHidden = !shouldShow
        }
    }
}
