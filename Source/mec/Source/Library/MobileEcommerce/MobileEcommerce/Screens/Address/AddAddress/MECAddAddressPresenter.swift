/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsEcommerceSDK

@objcMembers class MECAddAddressPresenter: MECBaseDeliveryDetailsPresenter {

    init(addressDataBus: MECDataBus?, shippingAddress: ECSAddress? = nil) {
        super.init()
        self.dataBus = addressDataBus
        self.shippingAddress = shippingAddress
    }

    fileprivate func trackSaveShippingAddress() {
        trackAction(parameterData: [MECAnalyticsConstants.specialEvents: MECAnalyticsConstants.newShippingAddressAdded,
                                    MECAnalyticsConstants.productListKey:
                                        preparePILCartEntryListString(entries: dataBus?.shoppingCart?.data?.attributes?.items)])
    }
}

extension MECAddAddressPresenter {

    func saveAddress(address: ECSAddress,
                     completionHandler: @escaping (_ addressList: [ECSAddress]?, _ error: Error?) -> Void,
                     saveAddressCompletionHandler: (() -> Void)? = nil) {
        MECConfiguration.shared.ecommerceService?.createAddress(address: address, completionHandler: { [weak self] (newAddress, error) in
            guard let newAddress = newAddress else {
                error?.handleOauthError(completion: { (handled, error) in
                    if handled == true {
                        self?.saveAddress(address: address, completionHandler: completionHandler)
                    } else {
                        self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.createAddress,
                                                  serverName: MECAnalyticServer.hybris, error: error)
                        completionHandler(nil, error)
                    }
                })
                return
            }
            self?.trackSaveShippingAddress()
            saveAddressCompletionHandler?()
            self?.setDeliveryAddress(address: newAddress) { (addresses, error) in
                guard error == nil else {
                    self?.fetchSavedAddresses { (addresses, error) in
                        guard error == nil else {
                            completionHandler(self?.dataBus?.savedAddresses, nil)
                            return
                        }
                        self?.dataBus?.savedAddresses = addresses
                        completionHandler(self?.dataBus?.savedAddresses, nil)
                    }
                    return
                }
                self?.dataBus?.savedAddresses = addresses
                completionHandler(self?.dataBus?.savedAddresses, nil)
            }
        })
    }

    func saveEditedAddress(address: ECSAddress, completionHandler: @escaping (_ addressList: [ECSAddress]?, _ error: Error?) -> Void) {
        MECConfiguration.shared.ecommerceService?.updateAddressWith(address: address, completionHandler: { [weak self] (addresses, error) in
            guard error == nil else {
                error?.handleOauthError(completion: { (handled, error) in
                    if handled == true {
                        self?.saveEditedAddress(address: address, completionHandler: completionHandler)
                    } else {
                        self?.trackTechnicalError(errorCategory: MECAnalyticErrorCategory.updateAddressWith,
                                                  serverName: MECAnalyticServer.hybris, error: error)
                        completionHandler(self?.dataBus?.savedAddresses, error)
                    }
                })
                return
            }
            self?.dataBus?.savedAddresses = addresses
            self?.fetchMECShoppingCart(completionHandler: { (shoppingCart, error) in
                guard error == nil else {
                    completionHandler(self?.dataBus?.savedAddresses, nil)
                    return
                }
                self?.dataBus?.shoppingCart = shoppingCart
                completionHandler(self?.dataBus?.savedAddresses, nil)
            })
        })
    }

    func constructAddressFor(addressView: MECAddressFieldView, currentAddress: ECSAddress? = nil) -> ECSAddress {
        let addressToSave = ECSAddress()
        addressToSave.addressID = currentAddress?.addressID
        addressToSave.firstName = addressView[MECConstants.MECAddressFirstNameKey]?.text
        addressToSave.lastName = addressView[MECConstants.MECAddressLastNameKey]?.text
        addressToSave.houseNumber = addressView[MECConstants.MECAddressHouseNumberKey]?.text
        addressToSave.line1 = addressView[MECConstants.MECAddressLineOneKey]?.text
        if let address2 = addressView[MECConstants.MECAddressLineTwoKey]?.text, address2.count > 0 {
            addressToSave.line2 = address2
        } else {
            addressToSave.line2 = ""
        }
        addressToSave.town = addressView[MECConstants.MECAddressTownKey]?.text
        addressToSave.postalCode = addressView[MECConstants.MECAddressPostalCodeKey]?.text
        let country = ECSCountry()
        country.isocode = addressView[MECConstants.MECAddressCountryKey]?.text
        addressToSave.country = country
        addressToSave.phone1 = addressView[MECConstants.MECAddressPhoneKey]?.text?.replacingOccurrences(of: " ", with: "")
        addressToSave.phone2 = addressToSave.phone1
        addressToSave.titleCode = addressView[MECConstants.MECAddressSalutationKey]?.text
        if let salutationValue = addressView[MECConstants.MECAddressSalutationKey]?.text, salutationValue.count > 0 {
            if let salutation = salutations.first(where: { $0.titleForItem() == salutationValue }) {
                addressToSave.titleCode = salutation.valueForItem()
            }
        }
        if let regionValue = addressView[MECConstants.MECAddressStateKey]?.text, regionValue.count > 0 {
            if let region = fetchedRegions?.first(where: { $0.name == regionValue }) {
                let selectedRegion = ECSRegion()
                selectedRegion.name = region.name
                selectedRegion.isocode = region.isocode
                selectedRegion.isocodeShort = region.isocodeShort
                addressToSave.region = selectedRegion
            }
        }
        return addressToSave
    }

    func parseAddressFieldConfiguration(completionHandler: () -> Void) {
        if let path = Bundle(for: MECUtility.self)
            .path(forResource: MECConstants.MECAddressConfigFileName, ofType: MECConstants.MECPlistType) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let plistDecoder = PropertyListDecoder()
                addressFieldConfigurationData = try plistDecoder.decode(MECAddressFieldsConfigModel.self, from: data)
            } catch {
                trackTechnicalError(errorCategory: MECAnalyticErrorCategory.appError,
                                    serverName: MECAnalyticServer.other, error: error)
            }
        }
        completionHandler()
    }

    func configureRegionField(for country: String?, completionHandler: @escaping () -> Void) {
        DispatchQueue.global().async { [weak self] in
            self?.parseAddressFieldConfiguration {
                if let country = country, self?.addressFieldConfigurationData?.isRegionSupported(for: country) == true {
                    self?.fetchRegions(country: country) {
                        completionHandler()
                        return
                    }
                } else {
                    completionHandler()
                }
            }
        }
    }
}
