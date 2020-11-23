/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

typealias MECPopoverCompletion = ((_ itemIndex: Int) -> Void)

protocol MECPopoverDataProtocol {
    func titleForItem() -> String
}

class MECPopoverViewController: UIViewController {

    var popoverItems: [MECPopoverDataProtocol]?
    var popoverCompletion: MECPopoverCompletion?

    @IBOutlet weak var popoverTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        popoverTableView.estimatedRowHeight = 44
        popoverTableView.rowHeight = UITableView.automaticDimension
    }
}

extension MECPopoverViewController {

    func displayPopoverMenu(_ sender: UIView,
                            presentationController: UIViewController,
                            presentingController: UIViewController,
                            preferredContentSize: CGSize?,
                            completionHandler: @escaping MECPopoverCompletion) {
        popoverCompletion = completionHandler
        presentationController.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover: UIPopoverPresentationController = presentationController.popoverPresentationController!
        if popover == presentationController.popoverPresentationController {
            let viewForSource = sender as UIView
            popover.sourceView = viewForSource
            popover.sourceRect = viewForSource.bounds
            presentationController.preferredContentSize = preferredContentSize ?? CGSize(width: 0, height: 0)
            popover.delegate = self
        }
        presentingController.present(presentationController, animated: true, completion: nil)
    }
}

extension MECPopoverViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popoverItems?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let popoverCell = tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECPopoverCell,
                                                        for: indexPath) as? MECPopoverTableViewCell
        if let popoverItem = popoverItems?[indexPath.row] {
            popoverCell?.setupUI()
            popoverCell?.titleText.text = popoverItem.titleForItem()
        }
        return popoverCell ?? UITableViewCell()
    }
}

extension MECPopoverViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        popoverCompletion?(indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MECPopoverViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}
