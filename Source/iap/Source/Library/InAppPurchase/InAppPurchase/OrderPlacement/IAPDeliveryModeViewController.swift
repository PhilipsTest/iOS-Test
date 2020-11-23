/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class IAPDeliveryModeViewController: IAPBaseViewController, UITableViewDelegate, UITableViewDataSource,
IAPDeliveryModeSelectionProtocol, IAPNavigationControllerBackButtonDelegate {
    @IBOutlet weak var deliveryModeTableView: UITableView!
    var deliveryModes = [IAPDeliveryModeInfo]()
    var deliveryModeIndex: Int! = 0
    var isModeSelected: Bool = false
    var deliveryModeName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = IAPLocalizedString("iap_delivery_method")
        deliveryModeTableView.estimatedRowHeight = 150.0
        deliveryModeTableView.rowHeight = UITableView.automaticDimension
        loadDeliveryModes()
    }

    private func getSelectedDeliveryModeNameIndex() -> Int {
        let selectedDeliveryMode = deliveryModes.filter{($0.deliveryModeName == deliveryModeName )}.first
        if let deliveryMode = selectedDeliveryMode {
            isModeSelected = true
            return deliveryModes.firstIndex(of: deliveryMode) ?? -1
        }
        return -1
    }

    private func loadDeliveryModes() {
        startActivityProgressIndicator()
        IAPDeliveryModeSyncHelper().deliveryMode({[weak self] (inDeliveryDetails: IAPDeliveryModeDetails) in
            self?.stopActivityProgressIndicator()
            guard inDeliveryDetails.deliveryModeDetails.count == 0 else {
                self?.deliveryModes = inDeliveryDetails.deliveryModeDetails
                self?.deliveryModeIndex = self?.getSelectedDeliveryModeNameIndex()
                self?.deliveryModeTableView.reloadData()
                return
            }
        }) { [weak self] (_) in
            self?.stopActivityProgressIndicator()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCartIconVisibility(false)
        isModeSelected = false
    }

    //MARK:
    //MARK: IAPNavigationControllerBackButtonDelegate method
    func viewControllerShouldPopOnBackButton() -> Bool {
        _ = navigationController?.popViewController(animated: true)
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveryModes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: IAPCellIdentifier.deliveryModeCell, for: indexPath) as? IAPDeliveryModeCell {
            cell.delegate = self

            var heightConstraintValue = 0.0
            var bottomConstraintValue = 0.0
            if isModeSelected {
                cell.radioButton.isSelected = (indexPath.row == deliveryModeIndex)
                if cell.radioButton.isSelected {
                    heightConstraintValue = 40.0
                    bottomConstraintValue = 20.0
                }
            }
            cell.confirmBtnHeightConstraint.constant = CGFloat(heightConstraintValue)
            cell.confirmBtnBottomConstraint.constant = CGFloat(bottomConstraintValue)
            cell.deliveryModeNameLabel.text = deliveryModes[indexPath.row].getdeliveryModeName()
            cell.deliveryModePriceLabel.text = deliveryModes[indexPath.row].getdeliveryCost()
            cell.deliveryModeAvailabilityLabel.text = deliveryModes[indexPath.row].getDeliveryModeDescription()
            return cell
        } else {
            return UITableViewCell(frame: .zero)
        }
    }
    //MARK:
    //MARK: IAPDeliveryModeSelectionProtocol Delegate
    func userSelectedRadioButton(_ inSender: IAPDeliveryModeCell) {
        if let indexPath = deliveryModeTableView.indexPath(for: inSender) {
            isModeSelected = true
            let pastIndexPath = IndexPath(item: deliveryModeIndex, section: 0)
            deliveryModeIndex = indexPath.row
            deliveryModeTableView.reloadRows(at: [pastIndexPath, indexPath], with: UITableView.RowAnimation.fade)
        }
    }
    
    func userSelectedConfirmButton(_ inSender: IAPDeliveryModeCell) {
        isModeSelected = false
        guard deliveryModeIndex >= 0 && deliveryModeIndex < deliveryModes.count  else { return }
        let objectSelectedForDelivery = deliveryModes[deliveryModeIndex]
        startActivityProgressIndicator()
        IAPDeliveryModeSyncHelper().updateDeliveryMode(objectSelectedForDelivery.getdeliveryCodeType(),
                                                       success:{ [weak self](inSuccess:Bool) in
            _ = self?.navigationController?.popViewController(animated: true)
        }) {[weak self](inError:NSError) in
            self?.stopActivityProgressIndicator()
            self?.displayErrorMessage(inError)
            _ = self?.navigationController?.popViewController(animated: true)
        }
    }
}
