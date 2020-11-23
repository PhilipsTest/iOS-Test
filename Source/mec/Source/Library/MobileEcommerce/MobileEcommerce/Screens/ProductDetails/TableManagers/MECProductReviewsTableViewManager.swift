/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS
import SafariServices

protocol MECProductReviewsTableViewManagerProtocol: NSObjectProtocol {
    func reviewsDownloaded()
    func didClickOnReviewsPrivacy(link: String)
}

class MECProductReviewsTableViewManager: MECProductDetailsBaseTableViewManager, UITableViewDataSource {

    weak var reviewDelegate: MECProductReviewsTableViewManagerProtocol?

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       let reviewCount = presenter.fetchTotalNumberOfReviews()
       guard presenter.shouldLoadMoreReviews() else { return reviewCount }
       return reviewCount + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reviewsCount = presenter.fetchTotalNumberOfReviews()
        guard indexPath.row == reviewsCount else {
            let reviewCell = tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECProductReviewCell) as? MECProductReviewCell
            reviewCell?.customizeCellAppearanceFor(row: indexPath.row)
            if let review = presenter.fetchedProduct?.productReviews?[indexPath.row] {
                reviewCell?.productReviewRatingBar.ratingValue = CGFloat(review.rating)
                reviewCell?.productReviewRatingBar.ratingText = "\(review.rating)"
                reviewCell?.productReviewTitleLabel.text = review.title
                reviewCell?.productReviewTimeLabel.text = presenter?.fetchReviewerDetailsFor(review: review)
                reviewCell?.productReviewDescriptionLabel.text = review.reviewText
                reviewCell?.displayPros(pros: presenter?.fetchProsFor(review: review))
                reviewCell?.displayCons(cons: presenter?.fetchConsFor(review: review))
            }
            return reviewCell ?? UITableViewCell()
            }

            let productReviewsLoadingCell = tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECProductReviewLoadingCell,
                                                                          for: indexPath) as? MECLoadingCell
            productReviewsLoadingCell?.loadingIndicator.startAnimating()
            return productReviewsLoadingCell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let reviewsCount = presenter.fetchTotalNumberOfReviews()
        guard reviewsCount > 0 else { return }
        guard indexPath.row == reviewsCount else { return }
        guard presenter.shouldLoadMoreReviews() else { return }
        presenter.loadAllReviews { [weak self] (_, _) in
            self?.reviewDelegate?.reviewsDownloaded()
        }
    }
}

extension MECProductReviewsTableViewManager: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return presenter.fetchTotalNumberOfReviews() > 0 ? UITableView.automaticDimension : .leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard presenter.fetchTotalNumberOfReviews() > 0 else {
            return nil
        }

        let headerView = MECUtility.getBundle().loadNibNamed(MECNibName.MECReviewsHeaderView,
                                                             owner: MECReviewsHeaderView.self,
                                                             options: nil)?.first as? MECReviewsHeaderView
        headerView?.reviewHeaderDelegate = self
        headerView?.configureLink()
        return headerView
    }
}

extension MECProductReviewsTableViewManager: MECReviewHeaderDelegate {

    func didClickOnPrivacy(link: String) {
        reviewDelegate?.didClickOnReviewsPrivacy(link: link)
    }
}
