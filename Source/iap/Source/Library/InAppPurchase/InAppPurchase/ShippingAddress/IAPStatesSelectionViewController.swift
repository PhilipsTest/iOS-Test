/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS

protocol IAPStatesSelectDelegate {
    func didSelectStates(_ stateData: NSDictionary)
}

class IAPStatesSelectionViewController: UITableViewController {
    
    var states:NSArray = []
    var delegate: IAPStatesSelectDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return states.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IAPCellIdentifier.IAPStateSelectionCell, for: indexPath)

        cell.textLabel?.font = UIFont(uidFont:.book, size: UIDFontSizeMedium)
        cell.textLabel?.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        if let dataDictionary = states[indexPath.row] as? NSDictionary {
            cell.textLabel!.text = dataDictionary["name"] as? String
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = self.delegate, let state = states[indexPath.row] as? NSDictionary {
            delegate.didSelectStates(state)
        }
    }
}
