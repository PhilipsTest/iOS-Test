/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsEcommerceSDK
import PhilipsUIKitDLS

class MECStockFilterDataProvider: NSObject, MECProductFilterTableDataProvider {
    var appliedFilter: ECSPILProductFilter
    weak var tableView: UITableView?

    init(appliedFilter: ECSPILProductFilter) {
        self.appliedFilter = appliedFilter
    }

    func registerCell(for tableView: UITableView) {
        self.tableView = tableView
        tableView.register(UINib.init(nibName: MECNibName.MECStockFilterCell,
                                      bundle: MECUtility.getBundle()),
                           forCellReuseIdentifier: MECCellIdentifier.MECStockFilterCell)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ECSPILStockLevel.allCases.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIDHeaderView.createMECHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
        headerView.headerLabel.text = MECLocalizedString("mec_filter_title")
        headerView.headerLabel.accessibilityIdentifier = "mec_filter_title"
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let stockCell = tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECStockFilterCell,
                                                            for: indexPath) as? MECStockFilterCell,
                                                            indexPath.row < ECSPILStockLevel.allCases.count else {
                                                                return UITableViewCell()
        }
        let stock = ECSPILStockLevel.allCases[indexPath.row]
        stockCell.delegate = self
        stockCell.filterSelectionCheckbox.title = MECLocalizedString("mec_\(stock.rawValue.lowercased())")
        stockCell.filterSelectionCheckbox.isChecked = appliedFilter.stockLevels?.contains(stock) ?? false
        stockCell.filterSelectionCheckbox.accessibilityIdentifier = "mec_\(stock.rawValue)"
        return stockCell
    }
}

extension MECStockFilterDataProvider: MECStockFilterCellDelegate {
    func didClickOnStock(tableCell: MECStockFilterCell, selected: Bool) {
        if let indexPath = tableView?.indexPath(for: tableCell) {
            let stockLevel = ECSPILStockLevel.allCases[indexPath.row]

            if selected == false && (appliedFilter.stockLevels?.contains(stockLevel) ?? false) {
                appliedFilter.stockLevels = appliedFilter.stockLevels?.filter { $0 != stockLevel }
            } else if selected == true && !(appliedFilter.stockLevels?.contains(stockLevel) ?? false) {
                appliedFilter.stockLevels?.insert(stockLevel)
            }
        }
    }
}
