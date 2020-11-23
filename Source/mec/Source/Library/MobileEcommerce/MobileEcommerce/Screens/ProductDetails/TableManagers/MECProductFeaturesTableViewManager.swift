/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS
import AFNetworking

class MECProductFeaturesTableViewManager: MECProductDetailsBaseTableViewManager, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.fetchNumberOfBenefitAreas()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.fetchNumberOfFeaturesFor(benefitAreaIndex: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let featureCell = tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECProductFeaturesCell) as? MECProductFeaturesCell
        featureCell?.customizeCellAppearance()
        featureCell?.productFeaturesNameLabel.text = presenter.fetchFeatureNameFor(benefitAreaIndex: indexPath.section,
                                                                                   featureIndex: indexPath.row)
        featureCell?.productFeaturesDescriptionLabel.text = presenter.fetchFeatureDescriptionFor(benefitAreaIndex: indexPath.section,
                                                                                                 featureIndex: indexPath.row)
        if let assetURLString = presenter.fetchFeatureAssetURLFor(benefitAreaIndex: indexPath.section,
                                                                  featureIndex: indexPath.row),
            let url = URL(string: assetURLString) {
            featureCell?.productFeaturesImageView.isHidden = false
            AFImageDownloader.defaultInstance().sessionManager
                .responseSerializer
                .acceptableContentTypes?
                .insert(MECImageDownloadSpecialFormats.MECJP2Format)
            featureCell?.productFeaturesImageView.setImageWith(url, placeholderImage: nil)
        } else {
            featureCell?.productFeaturesImageView.isHidden = true
        }
        return featureCell ?? UITableViewCell()
    }
}

extension MECProductFeaturesTableViewManager: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let featureHeaderView = MECUtility.getBundle().loadNibNamed(MECNibName.MECProductSpecsHeaderView,
                                                                    owner: MECProductSpecsHeaderView.self,
                                                                    options: nil)?.first as? MECProductSpecsHeaderView
        featureHeaderView?.configureUIAppearance()
        featureHeaderView?.productSpecHeaderLabel.text = presenter.fetchBenefitAreaNameFor(benefitAreaIndex: section)
        return featureHeaderView
    }
}
