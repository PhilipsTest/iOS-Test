/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

class MECProductSpecsTableViewManager: MECProductDetailsBaseTableViewManager, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.fetchNumberOfChapters()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.fetchNumberOfItemsFor(chapterIndex: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let specCell = tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECProductSpecsCell) as? MECProductSpecsCell
        specCell?.customizeCellAppearance()
        specCell?.specItemNameLabel.text = presenter.fetchItemNameFor(chapterIndex: indexPath.section, itemIndex: indexPath.row)
        specCell?.specItemValueLabel.text(presenter.fetchItemValuesFor(chapterIndex: indexPath.section,
                                                                       itemIndex: indexPath.row),
                                          lineSpacing: UIDSize8/2)
        return specCell ?? UITableViewCell()
    }
}

extension MECProductSpecsTableViewManager: UITableViewDelegate {

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
        let specHeaderView = MECUtility.getBundle().loadNibNamed(MECNibName.MECProductSpecsHeaderView,
                                                                 owner: MECProductSpecsHeaderView.self,
                                                                 options: nil)?.first as? MECProductSpecsHeaderView
        specHeaderView?.configureUIAppearance()
        specHeaderView?.productSpecHeaderLabel.text = presenter.fetchChapterNameFor(chapterIndex: section)
        return specHeaderView
    }
}
