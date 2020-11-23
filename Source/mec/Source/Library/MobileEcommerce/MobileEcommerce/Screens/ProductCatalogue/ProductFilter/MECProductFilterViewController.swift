/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS
import PhilipsEcommerceSDK

protocol MECProductFilterDelegate: NSObjectProtocol {
    func didSelectApplyFilter(filter: ECSPILProductFilter)
    func filterScreenDismissed()
}

class MECProductFilterViewController: MECBaseViewController {

    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var gestureView: UIView!
    @IBOutlet weak var bottomView: UIDView!

    @IBOutlet weak var clearButton: UIDButton!
    @IBOutlet weak var applyButton: UIDButton!

    var appliedFilter: ECSPILProductFilter!
    var temporaryAppliedFilter: ECSPILProductFilter!
    var tableDataSource: [MECProductFilterTableDataProvider] = []
    weak var filterDelegate: MECProductFilterDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        configureGestureRecognizer()
        temporaryAppliedFilter = appliedFilter.createCopy()

        tableDataSource = [MECProductSortDataProvider(appliedFilter: temporaryAppliedFilter),
                           MECStockFilterDataProvider(appliedFilter: temporaryAppliedFilter)]
        for data in tableDataSource {
            data.registerCell(for: filterTableView)
        }

        if let theme = UIDThemeManager.sharedInstance.defaultTheme {
            bottomView.apply(dropShadow: UIDDropShadow(level: .level3, theme: theme))
        }
        shouldShowCart(MECConfiguration.shared.isHybrisAvailable == true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackPage(pageName: MECAnalyticPageNames.productFilter)
    }
}

extension MECProductFilterViewController {

    func isNewFilterApplied() -> Bool {
        if temporaryAppliedFilter.sortType != appliedFilter.sortType ||
            (temporaryAppliedFilter.stockLevels ?? []) != (appliedFilter.stockLevels ?? []) {
            return true
        }
        return false
    }

    @IBAction func applyButtonClicked(_ sender: Any) {
        if isNewFilterApplied() == true {
            filterDelegate?.didSelectApplyFilter(filter: temporaryAppliedFilter)
        }
        filterDelegate?.filterScreenDismissed()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func clearButtonClicked(_ sender: Any) {
        temporaryAppliedFilter.clearAllFilter()
        filterTableView.reloadData()
    }

    func configureGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureViewTapped))
        tapGestureRecognizer.cancelsTouchesInView = false
        gestureView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func gestureViewTapped(_ sender: Any) {
        filterDelegate?.filterScreenDismissed()
        dismiss(animated: true, completion: nil)
    }
}

extension MECProductFilterViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableDataSource.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < tableDataSource.count else { return 0 }
        return tableDataSource[section].tableView(tableView, numberOfRowsInSection: section)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section < tableDataSource.count else { return 0 }
        return tableDataSource[section].tableView(tableView, heightForHeaderInSection: section)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section < tableDataSource.count else { return nil }
        return tableDataSource[section].tableView(tableView, viewForHeaderInSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section < tableDataSource.count else { return UITableViewCell() }
        let dataSource = tableDataSource[indexPath.section]
        return dataSource.tableView(tableView, cellForRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section < tableDataSource.count else { return }
        let dataSource = tableDataSource[indexPath.section]
        dataSource.tableView(tableView, didSelectRowAt: indexPath)
    }
}
