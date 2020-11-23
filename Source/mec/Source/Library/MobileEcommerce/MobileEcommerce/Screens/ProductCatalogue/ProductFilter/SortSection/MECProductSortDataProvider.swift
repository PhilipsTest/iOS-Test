/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS
import PhilipsEcommerceSDK

class MECProductSortDataProvider: NSObject, MECProductSortTableDataProvider {

    var appliedFilter: ECSPILProductFilter
    weak var sortTableView: UITableView?

    init(appliedFilter: ECSPILProductFilter) {
        self.appliedFilter = appliedFilter
    }

    func registerCell(for tableView: UITableView) {
        sortTableView = tableView
        tableView.register(UINib.init(nibName: MECNibName.MECProductSortCell,
                                      bundle: MECUtility.getBundle()),
                           forCellReuseIdentifier: MECCellIdentifier.MECProductSortCell)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ECSPILSortType.allCases.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIDHeaderView.createMECHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
        headerView.headerLabel.text = MECLocalizedString("mec_sort_title")
        headerView.headerLabel.accessibilityIdentifier = "mec_sort_title"
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sortCell = tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECProductSortCell,
                                                           for: indexPath) as? MECProductSortCell,
                                                            indexPath.row < ECSPILSortType.allCases.count else {
           return UITableViewCell()
        }
        let sortType = ECSPILSortType.allCases[indexPath.row]
        let selectedSortType = appliedFilter.sortType
        sortCell.sortLabel.text = MECLocalizedString("mec_\(sortType)")
        sortCell.sortLabel.accessibilityIdentifier = "mec_\(sortType)_label"
        sortCell.sortRadioButton.accessibilityIdentifier = "mec_\(sortType)_radio_button"
        sortCell.sortRadioButton.isSelected = sortType == selectedSortType
        sortCell.sortRadioButton.delegate = sortCell
        sortCell.sortSelectionDelegate = self
        return sortCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < ECSPILSortType.allCases.count else {
            return
        }
        didSelectSortOption(index: indexPath.row)
    }
}

extension MECProductSortDataProvider: MECSortCellDelegate {

    func didSelectSort(tableCell: MECProductSortCell) {
        if let selectedIndex = sortTableView?.indexPath(for: tableCell)?.row {
            didSelectSortOption(index: selectedIndex)
        }
    }
}

extension MECProductSortDataProvider {

    func didSelectSortOption(index: Int) {
        guard index < ECSPILSortType.allCases.count else {
            return
        }
        let selectedSortType = appliedFilter.sortType
        let newSelectedSortType = ECSPILSortType.allCases[index]
        if selectedSortType != newSelectedSortType {
            appliedFilter.sortType = newSelectedSortType
            sortTableView?.reloadData()
        }
    }
}
