/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

protocol IAPUpdateQuantityTableDelegate {
    func controllerDidSelectQuantity(_ quantity: NSInteger,
                                     selectedProductIndexPath: IndexPath,
                                     tableViewController: UITableViewController)
}

class IAPQuantityTableViewController: UITableViewController {
    var delegate: IAPUpdateQuantityTableDelegate?
    internal var totalQuantity: Int = 0
    internal var selectedProductIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: IAPCellIdentifier.tableCell)
    }
    
    internal func setProductTotalQuantity(_ quantity: Int) {
        self.totalQuantity = quantity
        self.tableView.reloadData()
    }
    
    var popOverViewHeight: CGFloat {
        get {
            if totalQuantity >= 10 {
                return 250
            } else {
                return (CGFloat)(totalQuantity * 40)
            }
        }
    }
    
    // MARK: UITableViewDatasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(totalQuantity)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: IAPCellIdentifier.tableCell) {
            cell.textLabel?.text = String(format: "%d", indexPath.row + 1)
            return cell
        } else {
            return UITableViewCell(frame: .zero)
        }
    }
    
    // MARK: UITableViewDelegate methods
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            //Quantity selected
            delegate.controllerDidSelectQuantity(indexPath.row + 1,
                                                 selectedProductIndexPath: self.selectedProductIndexPath,
                                                 tableViewController: self)
        }
    }
}
