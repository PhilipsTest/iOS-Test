/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import Quick
import Nimble
import PhilipsUIKitDLS
@testable import InAppPurchaseDev

class IAPShippingAddressControllerSpec: QuickSpec {
    class IAPTestAddressUtility: IAPShippingAddressUtility {
        override func getRegionsForCountryCode(_ countryCode: String,
                                               completionHandler:@escaping GetRegionsCompletionHandler) {
            let statesArray = self.readLocalJSONFile("Regions")!
            completionHandler(statesArray)
        }

        fileprivate func readLocalJSONFile(_ fileName: String) -> NSArray? {
            if let path = IAPUtility.getBundle().path(forResource: fileName, ofType: "json") {
                if let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                    do {
                        if let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: jsonData,
                                    options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            if let regions: NSArray = jsonResult["regions"] as? NSArray {
                                return regions
                            }
                        }
                    } catch {}
                }
            }
            return []
        }
    }

    func viewDidAppearSpec() {
        let shippingAddressController = IAPShippingAddressEditViewController.instantiateFromAppStoryboard(appStoryboard: .shippingAddress)
        describe("viewDidAppear") {
            beforeEach {
                // Arrange:
                shippingAddressController.loadView()
                shippingAddressController.isEditMode = true
                shippingAddressController.savedAddress = self.getAddressToDisplay()
                shippingAddressController.shippingAddressHelper = IAPTestAddressUtility()
                let navigationController = UINavigationController()
                navigationController.pushViewController(shippingAddressController, animated: false)

                // Act:
                shippingAddressController.beginAppearanceTransition(true, animated: false) // Triggers viewWillAppear
                shippingAddressController.endAppearanceTransition() // Triggers viewDidAppear

                shippingAddressController.isEditMode = false
                shippingAddressController.beginAppearanceTransition(true, animated: false) // Triggers viewWillAppear
                shippingAddressController.endAppearanceTransition() // Triggers viewDidAppear
                shippingAddressController.viewDidDisappear(false)
            }

            it("should prepopulate UI textfields") { }
        }
    }

    func viewWillAppearSpec() {
        let shippingAddressController = IAPShippingAddressEditViewController.instantiateFromAppStoryboard(appStoryboard: .shippingAddress)
        describe("viewWillAppear") {
            beforeEach {
                shippingAddressController.loadView()
                shippingAddressController.isEditMode = false
                shippingAddressController.isBillingAddressModeOnly = true
                shippingAddressController.savedAddress = self.getAddressToDisplay()
                shippingAddressController.shippingAddressHelper = IAPTestAddressUtility()
                let navigationController = UINavigationController()
                navigationController.pushViewController(shippingAddressController, animated: false)
                // Act:
                shippingAddressController.beginAppearanceTransition(true, animated: false) // Triggers viewWillAppear
                shippingAddressController.endAppearanceTransition() // Triggers viewDidAppear
            }

            it("checking ui for viewWillAppear") {
                expect(shippingAddressController.shippingAddressView.isHidden) == true
                expect(shippingAddressController.billingAddressView.isHidden) == false
            }
        }
    }

    func saveNewAddressSpec() {
        let navigationController = UINavigationController()
        let shippingAddressController = IAPShippingAddressEditViewController.instantiateFromAppStoryboard(appStoryboard: .shippingAddress)
        describe("saveNewAddress") {
            beforeEach {
                // Arrange:
                shippingAddressController.loadView()
                shippingAddressController.shippingAddressListView.updateSelectedSalution(salutation: .mr)
                shippingAddressController.isEditMode = true
                shippingAddressController.savedAddress = self.getAddressToDisplay()
                shippingAddressController.shippingAddressHelper = IAPTestAddressUtility()
                navigationController.pushViewController(shippingAddressController, animated: false)

                // Act:
                shippingAddressController.beginAppearanceTransition(true, animated: false) // Triggers viewWillAppear
                shippingAddressController.endAppearanceTransition() // Triggers viewDidAppear
            }

            it("save address") {
                let cartHelper = IAPTestCartSyncHelper()
                let addressSync = IAPTestAddressSyncHelper()

                shippingAddressController.cartSyncHelper = cartHelper
                shippingAddressController.addressSyncHelper = addressSync

                shippingAddressController.saveNewAddress(UIDButton(frame: CGRect.zero))

                shippingAddressController.selectedState = ["isocode": "US", "name": "America"]
                shippingAddressController.savedAddress = nil
                shippingAddressController.saveNewAddress(UIDButton(frame: CGRect.zero))

                shippingAddressController.isEditMode = false
                shippingAddressController.savedAddress = self.getAddressToDisplay()
                shippingAddressController.saveNewAddress(UIDButton(frame: CGRect.zero))

                expect(addressSync.didInvokeUpdateDeliveryAddress).to(beTrue())
                expect(addressSync.didInvokeAddDeliveryAddress).to(beTrue())
            }
        }
    }

    override func spec() {
        viewWillAppearSpec()
        saveNewAddressSpec()

        let shippingAddressController = IAPShippingAddressEditViewController.instantiateFromAppStoryboard(appStoryboard: .shippingAddress)
        describe("disable or enable field entries") {
            beforeEach {
                shippingAddressController.loadView()
                shippingAddressController.disableOrEnableFieldEntries(false)
            }
            it("reset fields") { }
        }

        describe("get billing address") {
            beforeEach {
                shippingAddressController.checkBoxView.isChecked = false
            }

            it("get billing address for saving") {
                shippingAddressController.billingAddressListView.updateSelectedSalution(salutation: .mr)
                let billingAddress = shippingAddressController.getBillingAddressForSaving()
                expect(billingAddress) != nil
            }
        }

        describe("Test checkbox value changed functionality") {
            beforeEach {
                shippingAddressController.savedAddress = self.getAddressToDisplay()
            }
            it("checkbox value changed and billing address only") {
                //just testing one field for sample tests
                shippingAddressController.checkBoxView.isChecked = false
                shippingAddressController.isBillingAddressModeOnly = true
                shippingAddressController.checkBoxValueChanged(shippingAddressController.checkBoxView)
                shippingAddressController.checkBoxView.isChecked = true
                shippingAddressController.checkBoxValueChanged(shippingAddressController.checkBoxView)
            }
            it("checkbox value changed and shipping address only") {
                //just testing one field for sample tests
                shippingAddressController.checkBoxView.isChecked = true
                shippingAddressController.isBillingAddressModeOnly = false
                shippingAddressController.checkBoxValueChanged(shippingAddressController.checkBoxView)
                expect(shippingAddressController.billingAddressView.isHidden) == true
                shippingAddressController.checkBoxView.isChecked = false
                shippingAddressController.checkBoxValueChanged(shippingAddressController.checkBoxView)
                expect(shippingAddressController.billingAddressView.isHidden) == false
            }
        }
    }
    func getAddressToDisplay() -> IAPUserAddress {
        let dict = self.deserializeData("IAPOCCGetAddress")!
        let addresses = IAPUserAddressInfo(inDict: dict)
        return addresses.address.first!
    }
}
