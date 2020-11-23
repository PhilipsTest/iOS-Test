/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsUIKitDLS

struct IAPShoppingCartCells {
    static var kShippingCostCellNumber = 0
    static var kTaxCellNumber = 1
    static var kTotalCostCellNumber = 2
    static var kAccessoryCartCell = 3
}

class IAPShoppingCartDecorator: NSObject, UITableViewDataSource, UITableViewDelegate,
IAPUpdateQuantityTableDelegate, IAPDeleteProductDelegate, UIGestureRecognizerDelegate {
    weak var delegate: IAPShoppingDecoratorProtocol?
    fileprivate var shoppingTableView: UITableView!
    fileprivate var voucherCodeEnabled: Bool?
    var shoppingCartInfo: IAPCartInfo!
    var productList = [IAPProductModel]()
    let popoverController = IAPCustomPopoverController()
    convenience init(withTableView: UITableView) {
        self.init()
        voucherCodeEnabled = (IAPOAuthConfigurationData.getInAppConfigValueForKey(IAPConstants.IAPConfigurationKeys.kvoucherCodeEnable)) as? Bool ?? false
        self.shoppingTableView = withTableView
        self.shoppingTableView.dataSource = self
        self.shoppingTableView.delegate = self
        self.shoppingTableView.estimatedRowHeight = IAPConstants.IAPAddressCellConstants.kRowHeightConstant
        self.shoppingTableView.rowHeight = UITableView.automaticDimension
        self.shoppingTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }

    // MARK: UITableViewDatasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case IAPConstants.ShoppingCartTableSectionConstants.kShoppingCartSection:
            return productList.count
        case IAPConstants.ShoppingCartTableSectionConstants.kAddressCellSection:
            if (shoppingCartInfo.deliveryModeName == nil && true == voucherCodeEnabled) ||
                (shoppingCartInfo.deliveryModeName != nil && false == voucherCodeEnabled) {
                return 1
            } else if self.shoppingCartInfo.deliveryModeName != nil && true == voucherCodeEnabled {
                return 2
            } else {
                return 0
            }
        case IAPConstants.ShoppingCartTableSectionConstants.kOrderSummarySection:
            return productList.count
        case IAPConstants.ShoppingCartTableSectionConstants.kShippingCostSection:
            let shippingRowCount = shoppingCartInfo.deliveryModeName == nil ? 0 : 1
            return shippingRowCount
        case IAPConstants.ShoppingCartTableSectionConstants.kVoucherDiscountSection:
            if let voucherList = shoppingCartInfo.voucherDiscounts?.voucherList, voucherList.count > 0 {
                return voucherList.count
            }
            return 0
        case IAPConstants.ShoppingCartTableSectionConstants.kOrderDiscountSection:
            if let orderDiscountList = shoppingCartInfo.orderDiscounts?.orderDiscountList, orderDiscountList.count > 0 {
                return orderDiscountList.count
            }
            return 0
        default:
            return 1
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if self.productList.count > 0 {
            return 7
        }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > IAPConstants.ShoppingCartTableSectionConstants.kOrderSummarySection {
            return nil
        }
        
        if self.tableView(tableView, numberOfRowsInSection: section) < 1 {
            return nil
        }
        
        guard let headerViewList = IAPUtility.getBundle().loadNibNamed(IAPNibName.IAPPurchaseHistoryOverviewSectionHeader,
                                                                       owner: self,
                                                                       options: nil),
            let headerView = headerViewList[0] as? IAPPurchaseHistoryOverviewSectionHeader else {
                return nil
        }
        return IAPUtility.commonViewForHeaderInSection(IAPConstants.IAPCommonSectionHeaderView.kShoppingCartSection,
                                                       sectionValue: section,
                                                       productCount: self.productList.count,
                                                       headerView: headerView) as? IAPPurchaseHistoryOverviewSectionHeader
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > IAPConstants.ShoppingCartTableSectionConstants.kOrderSummarySection {
            return 0
        }
        
        if self.tableView(tableView, numberOfRowsInSection: section) < 1 {
            return 0
        }
        
        return 48.0
    }

    func createProductCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let lastRowIndex = self.shoppingTableView.numberOfRows(inSection: 0) - 1
        let pathToLastRow = IndexPath(row: lastRowIndex, section: 0)
        if let cell = tableView.dequeueReusableCell(withIdentifier: IAPCellIdentifier.productCell, for: indexPath) as? IAPCartProductCell {
            let productModel = self.productList[indexPath.row]
            cell.configureUIWithModel(productModel)
            let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                           action: #selector(IAPShoppingCartDecorator.quantityViewClicked(_:)))
            gestureRecognizer.delegate = self
            cell.quantityView.isUserInteractionEnabled = true
            cell.quantityView.addGestureRecognizer(gestureRecognizer)
            let stockQuantity = productModel.getStockAmount()
            let productQuantity = productModel.getQuantity()
            if(!IAPUtility.isStockAvailable(stockLevelStatus: productModel.getProductStockLevelStatus(),
                                            stockAmount: stockQuantity)) {
                self.handleOutOfStockQuantity(cell, quantityAdded: productQuantity, stockAvailable: stockQuantity)
            } else {
                cell.outOfStockLbl.text = ""
                cell.outOfStockLblHeight.constant = 0.0
            }
            cell.delegate = self
            if indexPath == pathToLastRow {
                cell.separatorHeight.constant = 1
            }
            return cell
        } else {
            return UITableViewCell(frame: .zero)
        }
    }
    
    func createShippingCostAndVoucherCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && voucherCodeEnabled == true {
            if let cell = self.shoppingTableView.dequeueReusableCell(
                withIdentifier: IAPCellIdentifier.voucherCell)! as? IAPCartVoucherCell {
                cell.voucherLbl.text = IAPLocalizedString("iap_promotional_gift") ?? ""
                return cell
            } else {
                return UITableViewCell(frame: .zero)
            }
        } else {
            if let cell = self.shoppingTableView.dequeueReusableCell(
                withIdentifier: IAPCellIdentifier.shippingCostCell)! as? IAPCartShippingCostCell {
                if self.shoppingCartInfo.deliveryModeName != nil {
                    cell.shippingCostLbl.text = IAPLocalizedString("iap_delevery_via",self.shoppingCartInfo.deliveryModeName)!
                    cell.shippingPriceLbl.text = self.shoppingCartInfo.freeDelivery
                    cell.deliveryModeLbl.text = self.shoppingCartInfo.deliveryModeDescription
                    cell.deliveryModeLbl.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
                    cell.shippingPriceLbl.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
                }
                return cell
            } else {
                return UITableViewCell(frame: .zero)
            }
        }
    }
    
    func createSummaryCustomCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        self.shoppingTableView.register(UINib(nibName: IAPNibName.IPAPurchaseHistoryOrderSummaryCustomCell,
                                              bundle: IAPUtility.getBundle()),
                                        forCellReuseIdentifier: IAPCellIdentifier.summaryCustomCell)

        if let cell = tableView.dequeueReusableCell(withIdentifier: IAPCellIdentifier.summaryCustomCell,
                                                    for: indexPath) as? IPAPurchaseHistoryOrderSummaryCustomCell {
            let productModel = self.productList[indexPath.row]
            cell.totalItemsAndItemNameLabel?.text = "\(productModel.getQuantity())" + "x " + "\(productModel.getProductTitle())"
            cell.totalPriceLabel?.text = productModel.getTotalPrice()
            if indexPath != IndexPath(row: 0, section: 2) {
                cell.topConstraint.constant = 8
            }
            cell.isUserInteractionEnabled = false
            return cell
        } else {
            return UITableViewCell(frame: .zero)
        }
    }

    func createPurchaseHistoryOrder(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        self.shoppingTableView.register(UINib(nibName: IAPNibName.IAPPurchaseHistoryOrderDetailsPriceSummaryCell,
                                              bundle: IAPUtility.getBundle()),
                                        forCellReuseIdentifier: IAPCellIdentifier.purchaseHistoryPriceCell)
        if let cell = tableView.dequeueReusableCell(withIdentifier: IAPCellIdentifier.purchaseHistoryPriceCell,
                                                    for: indexPath) as? IAPPurchaseHistoryOrderDetailsPriceSummaryCell {
            cell.updateUIForShoppingCart(cartInfo: shoppingCartInfo)
            return cell
        } else {
            return UITableViewCell(frame: .zero)
        }
    }
    
    func createShippingCostDisplayCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        self.shoppingTableView.register(UINib(nibName: IAPNibName.IAPOrderDetailsViewCell,
                                              bundle: IAPUtility.getBundle()),
                                        forCellReuseIdentifier: IAPCellIdentifier.orderDetailsCell)
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: IAPCellIdentifier.orderDetailsCell,
                                                    for: indexPath) as? IAPOrderDetailsViewCell {
            if shoppingCartInfo.deliveryModeName != nil {
                cell.orderDetailsNameLabel?.text = IAPLocalizedString("iap_including_vat")
                cell.orderDetailsValueLabel?.text = shoppingCartInfo.shippingCost
            } else {
                cell.orderDetailsNameLabel?.isHidden = true
                cell.orderDetailsValueLabel?.isHidden = true
            }
            return cell
        } else {
            return UITableViewCell(frame: .zero)
        }
    }
    
    func createOrderPromotionDiscountCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        self.shoppingTableView.register(UINib(nibName: IAPNibName.IAPOrderDetailsViewCell,
                                              bundle: IAPUtility.getBundle()),
                                        forCellReuseIdentifier: IAPCellIdentifier.orderDetailsCell)
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: IAPCellIdentifier.orderDetailsCell,
                                                    for: indexPath) as? IAPOrderDetailsViewCell {
        
        if let orderPromotions = shoppingCartInfo.orderDiscounts?.orderDiscountList, orderPromotions.count > 0  {
                let orderPromotionDetails = orderPromotions[indexPath.row]
                cell.orderDetailsNameLabel.text = orderPromotionDetails.orderDiscountDescription
                cell.orderDetailsValueLabel.text = "- \(orderPromotionDetails.orderDiscountValue ?? "0.00")"
                return cell
            }
        }
        return UITableViewCell(frame: .zero)
    }
    
    func createVoucherDiscountCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        self.shoppingTableView.register(UINib(nibName: IAPNibName.IAPOrderDetailsViewCell,
                                              bundle: IAPUtility.getBundle()),
                                        forCellReuseIdentifier: IAPCellIdentifier.orderDetailsCell)
        if let cell = tableView.dequeueReusableCell(withIdentifier: IAPCellIdentifier.orderDetailsCell,
                                                    for: indexPath) as? IAPOrderDetailsViewCell {
            
            if let vouchers = shoppingCartInfo.voucherDiscounts?.voucherList, vouchers.count > 0  {
                let voucherDetails = vouchers[indexPath.row]
                cell.orderDetailsNameLabel.text = voucherDetails.voucherName
                cell.orderDetailsValueLabel.text = "- \(voucherDetails.discountAmount ?? "0.00")"
                return cell
            }
        }
        return UITableViewCell(frame: .zero)
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return createProductCell(tableView: tableView, indexPath: indexPath)
        case 1:
            return createShippingCostAndVoucherCell(tableView: tableView, indexPath: indexPath)
        case 2:
            return createSummaryCustomCell(tableView: tableView, indexPath: indexPath)
        case 3:
            return createShippingCostDisplayCell(tableView: tableView, indexPath: indexPath)
        case 4:
            return createVoucherDiscountCell(tableView: tableView, indexPath: indexPath)
        case 5:
            return createOrderPromotionDiscountCell(tableView: tableView, indexPath: indexPath)
        case 6:
            let purchaseHistoryOrderCell = createPurchaseHistoryOrder(tableView: tableView, indexPath: indexPath) as? IAPPurchaseHistoryOrderDetailsPriceSummaryCell
            purchaseHistoryOrderCell?.deliveryParcelTextLabel?.isHidden = true
            purchaseHistoryOrderCell?.deliveryParcelValueLabel?.isHidden = true
            return purchaseHistoryOrderCell ?? UITableViewCell(frame: .zero)
        default:
            guard let totalCell = IAPUtility.getTotalCell(self.shoppingTableView,
                                                    withTotal: self.shoppingCartInfo.totalPriceWithTax,
                                                    withItems: self.shoppingCartInfo.totalItems) as? IAPCartTotalCell else {
                                                        return UITableViewCell(frame: .zero)
            }
            totalCell.inclusiveVATLabel.text = IAPLocalizedString("iap_including_vat")
            totalCell.vatPriceLabel.text = self.shoppingCartInfo.vatTotal
            return totalCell
        }
    }

    // MARK: UITableViewDelegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == IAPConstants.ShoppingCartTableSectionConstants.kAddressCellSection {
            if indexPath.row == 0 && voucherCodeEnabled == true{
                self.delegate?.displayVoucherView()
                return
            } else {
                self.delegate?.displayDeliveryModeView()
                return
            }
        } else if indexPath.section == IAPConstants.ShoppingCartTableSectionConstants.kShoppingCartSection {
            let productModel = self.productList[indexPath.row]
            self.delegate?.pushDetailView(productModel)
        }
    }

    @objc func quantityViewClicked(_ sender: UIGestureRecognizer!) {
        if let delegateController = self.delegate as? UIViewController, let view = sender.view,
            let cell = sender.view?.superview?.superview?.superview as? UITableViewCell {
            let indexPath = self.shoppingTableView.indexPath(for: cell)
            let productModel = self.productList[indexPath!.row]
            let productQuantity = productModel.getStockAmount()

            //Table view is to be presentingViewController
            if productQuantity > 0 {
                let presentingViewController = IAPQuantityTableViewController()
                presentingViewController.setProductTotalQuantity(productQuantity)
                presentingViewController.selectedProductIndexPath = indexPath
                presentingViewController.delegate = self
                let popOverViewHeight = presentingViewController.popOverViewHeight
                self.popoverController.popOverMenuOnItem(view.subviews.first!,
                                                         presentationController: presentingViewController,
                                                         presentingController: delegateController,
                                                         preferredContentSize: CGSize(width: 80,
                                                                                      height: popOverViewHeight))
            }
        }
    }

    //MARK: IAPUpdateQuantityTableDelegate
    func controllerDidSelectQuantity(_ quantity: NSInteger, selectedProductIndexPath: IndexPath,
                                     tableViewController: UITableViewController) {
        let presentedViewController: UIViewController = tableViewController.presentationController!.presentingViewController
        presentedViewController.dismiss(animated: false) {
            self.delegate?.updateQuantity(self.productList[selectedProductIndexPath.row],
                                          withCartInfo: self.shoppingCartInfo, quantityValue: quantity)
        }
    }

    //MARK: IAPDeleteProductDelegate
    func deleteSelectedProduct(cell: IAPCartProductCell) {
        let alertController = UIDAlertController(title: IAPLocalizedString("iap_delete_item_alert_title"),
                                                 icon: nil,
                                                 message: IAPLocalizedString("iap_product_remove_description")!)
        let uidCancelAction = UIDAction(title: IAPLocalizedString("iap_cancel"),
                                        style: .secondary) { (action: UIDAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(uidCancelAction)

        let OKAction = UIDAction(title: IAPLocalizedString("iap_remove_product")!,
                                 style: .primary) { (action: UIDAction!) in
            alertController.dismiss(animated: true, completion: nil)
            if let indexPath = self.shoppingTableView.indexPath(for: cell) {
             let productModel = self.productList[indexPath.row]
             self.delegate?.updateQuantity(productModel, withCartInfo: self.shoppingCartInfo, quantityValue: 0)
             return
             }
        }
        alertController.addAction(OKAction)
        var topController = UIApplication.shared.keyWindow!.rootViewController! as UIViewController
        while ((topController.presentedViewController) != nil) {
            topController = topController.presentedViewController!
        }
        topController.present(alertController, animated: true, completion: nil)
    }

    //MARK: Private methods
    func handleOutOfStockQuantity(_ productCell: IAPCartProductCell, quantityAdded: Int, stockAvailable: Int) {
        productCell.outOfStockLblHeight.constant = 20.0
        productCell.outOfStockLbl?.textColor = UIColor.color(range: .signalRed, level: .color60)
        productCell.outOfStockLbl.text = IAPLocalizedString("iap_out_of_stock")
        self.delegate?.adjsutView(false)
    }
}
