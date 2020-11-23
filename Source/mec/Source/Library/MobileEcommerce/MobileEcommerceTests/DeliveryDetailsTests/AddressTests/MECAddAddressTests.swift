/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import PhilipsEcommerceSDK
@testable import MobileEcommerceDev

class MECAddAddressTests: XCTestCase {
    
    var addressPresenter: MECAddAddressPresenter!
    var mockECSService: MockECSService?
    var mockTagging: MECMockTagger?
    
    override func setUp() {
        super.setUp()
        let appInfra = MockAppInfra()
        MECConfiguration.shared.sharedAppInfra = appInfra
        let mockDataBus = MECDataBus()
        addressPresenter = MECAddAddressPresenter(addressDataBus: mockDataBus)
        mockECSService = MockECSService(propositionId: "TEST", appInfra: appInfra)
        MECConfiguration.shared.ecommerceService = mockECSService
        MECConfiguration.shared.isHybrisAvailable = true
        mockTagging = MECMockTagger()
        MECConfiguration.shared.mecTagging = mockTagging
    }

    override func tearDown() {
        super.tearDown()
        addressPresenter = nil
        mockECSService = nil
        MECConfiguration.shared.ecommerceService = nil
        MECConfiguration.shared.isHybrisAvailable = false
        MECConfiguration.shared.sharedAppInfra = nil
        MECConfiguration.shared.mecTagging = nil
    }
    
    func testSaveAddressSuccess() {
        let mockAddress = ECSAddress()
        mockAddress.firstName = "TestFirstName"
        mockAddress.lastName = "TestLastName"
        
        mockECSService?.saveAddress = mockAddress
        mockECSService?.savedAddresses = [mockAddress]
        
        addressPresenter.saveAddress(address: mockAddress, completionHandler: { [weak self] (addresses, error) in
            XCTAssertNotNil(addresses)
            XCTAssertNil(error)
            XCTAssertNotNil(self?.addressPresenter.dataBus?.savedAddresses)
            XCTAssertEqual(self?.addressPresenter.dataBus?.savedAddresses?.count, 1)
            XCTAssertEqual(self?.addressPresenter.dataBus?.savedAddresses?.first?.firstName, "TestFirstName")
            XCTAssertNil(self?.addressPresenter.dataBus?.savedAddresses?.first?.phone)
            XCTAssertNil(self?.mockTagging?.inParamDict?[MECAnalyticsConstants.productListKey])
        })
    }
    
    func testSaveAddressSuccessWithDataInDataBus() {
        let mockAddress = ECSAddress()
        mockAddress.firstName = "TestFirstName"
        mockAddress.lastName = "TestLastName"
        
        mockECSService?.saveAddress = mockAddress
        mockECSService?.savedAddresses = [mockAddress]
        
        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        cart.data = data
        
        addressPresenter.dataBus?.shoppingCart = cart
        let entry1 = ECSPILItem()
        entry1.quantity = 2
        entry1.ctn = "FirstCTN"
        entry1.discountPrice = ECSPILPrice()
        entry1.discountPrice?.value = 100.0
        
        let entry2 = ECSPILItem()
        entry2.quantity = 4
        entry2.ctn = "SecondCTN"
        entry2.discountPrice = ECSPILPrice()
        entry2.discountPrice?.value = 200.0
        
        addressPresenter.dataBus?.shoppingCart?.data?.attributes?.items = [entry1, entry2]
        
        addressPresenter.saveAddress(address: mockAddress, completionHandler: { [weak self] (addresses, error) in
            XCTAssertNotNil(addresses)
            XCTAssertNil(error)
            XCTAssertNotNil(self?.addressPresenter.dataBus?.savedAddresses)
            XCTAssertEqual(self?.addressPresenter.dataBus?.savedAddresses?.count, 1)
            XCTAssertEqual(self?.addressPresenter.dataBus?.savedAddresses?.first?.firstName, "TestFirstName")
            XCTAssertNil(self?.addressPresenter.dataBus?.savedAddresses?.first?.phone)
            XCTAssertEqual(self?.mockTagging?.inParamDict?[MECAnalyticsConstants.productListKey] as? String, "Retailer;FirstCTN;2;200.00,Retailer;SecondCTN;4;800.00")
        })
    }
    
    func testSaveAddressFailure() {
        let mockAddress = ECSAddress()
        mockAddress.firstName = "TestFirstName"
        mockAddress.lastName = "TestLastName"
        
        mockECSService?.saveAddressError = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey: "Save address failed"])
        mockECSService?.savedAddresses = [mockAddress]
        
        addressPresenter.saveAddress(address: mockAddress, completionHandler: { [weak self] (addresses, error) in
            XCTAssertNil(addresses)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 123)
            XCTAssertNil(self?.addressPresenter.dataBus?.savedAddresses)
            XCTAssertEqual(self?.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self?.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:createAddress:Hybris:Save address failed:123")
        })
    }
    
    func testSaveAddressOAuthFailure() {
        let mockAddress = ECSAddress()
        mockAddress.firstName = "TestFirstName"
        mockAddress.lastName = "TestLastName"
        
        mockECSService?.saveAddress = mockAddress
        mockECSService?.savedAddresses = [mockAddress]
        
        mockECSService?.shouldSendOauthError = true
        
        addressPresenter.saveAddress(address: mockAddress, completionHandler: { [weak self] (addresses, error) in
            XCTAssertNotNil(addresses)
            XCTAssertNil(error)
            XCTAssertNotNil(self?.addressPresenter.dataBus?.savedAddresses)
            XCTAssertEqual(self?.addressPresenter.dataBus?.savedAddresses?.count, 1)
            XCTAssertEqual(self?.addressPresenter.dataBus?.savedAddresses?.first?.firstName, "TestFirstName")
            XCTAssertNil(self?.addressPresenter.dataBus?.savedAddresses?.first?.phone)
        })
    }
    
    func testSaveAddressFailureDoesnotOverrideOldSavedAddresses() {
        let mockAddress = ECSAddress()
        mockAddress.firstName = "TestFirstName"
        mockAddress.lastName = "TestLastName"
        let mockSavedAddress = ECSAddress()
        mockSavedAddress.firstName = "SavedFirstName"
        
        mockECSService?.saveAddressError = NSError(domain: "", code: 123, userInfo: nil)
        mockECSService?.savedAddresses = [mockAddress, mockSavedAddress]
        
        addressPresenter.dataBus?.savedAddresses = [mockSavedAddress]
        addressPresenter.saveAddress(address: mockAddress, completionHandler: { [weak self] (addresses, error) in
            XCTAssertNil(addresses)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 123)
            XCTAssertNotNil(self?.addressPresenter.dataBus?.savedAddresses)
            XCTAssertEqual(self?.addressPresenter.dataBus?.savedAddresses?.count, 1)
            XCTAssertEqual(self?.addressPresenter.dataBus?.savedAddresses?.first?.firstName, "SavedFirstName")
        })
    }
    
    func testSaveAddressSetDeliveryAddressFailure() {
        let mockAddress = ECSAddress()
        mockAddress.firstName = "TestFirstName"
        mockAddress.lastName = "TestLastName"
        let mockSavedAddress = ECSAddress()
        mockSavedAddress.firstName = "SavedFirstName"
        
        mockECSService?.saveAddress = mockAddress
        mockECSService?.savedAddresses = [mockSavedAddress]
        mockECSService?.setDeliveryAddressError = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey: "Set delivery address failed"])
        
        addressPresenter.dataBus?.savedAddresses = [mockSavedAddress]
        addressPresenter.saveAddress(address: mockAddress, completionHandler: { [weak self] (addresses, error) in
            XCTAssertNotNil(addresses)
            XCTAssertNil(error)
            XCTAssertNotNil(self?.addressPresenter.dataBus?.savedAddresses)
            XCTAssertEqual(self?.addressPresenter.dataBus?.savedAddresses?.count, 1)
            XCTAssertEqual(self?.addressPresenter.dataBus?.savedAddresses?.first?.firstName, "SavedFirstName")
            XCTAssertEqual(self?.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self?.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:setDeliveryAddress:Hybris:Set delivery address failed:123")
        })
    }
    
    func testSaveAddressFetchCartError() {
        let mockAddress = ECSAddress()
        mockAddress.firstName = "TestFirstName"
        mockAddress.lastName = "TestLastName"
        let mockSavedAddress = ECSAddress()
        mockSavedAddress.firstName = "SavedFirstName"
        let mockShoppingCart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        mockShoppingCart.data = data
        mockShoppingCart.data?.attributes = attributes
        mockShoppingCart.data?.cartID = "TestCartId"
        
        mockECSService?.saveAddress = mockAddress
        mockECSService?.savedAddresses = [mockAddress, mockSavedAddress]
        mockECSService?.shoppingCartError = NSError(domain: "", code: 123, userInfo: nil)
        
        addressPresenter.dataBus?.savedAddresses = [mockSavedAddress]
        addressPresenter.dataBus?.shoppingCart = mockShoppingCart
        addressPresenter.saveAddress(address: mockAddress, completionHandler: { [weak self] (addresses, error) in
            XCTAssertNotNil(addresses)
            XCTAssertNil(error)
            XCTAssertNotNil(self?.addressPresenter.dataBus?.savedAddresses)
            XCTAssertEqual(self?.addressPresenter.dataBus?.savedAddresses?.count, 2)
            XCTAssertEqual(self?.addressPresenter.dataBus?.savedAddresses?.last?.firstName, "SavedFirstName")
            XCTAssertEqual(self?.addressPresenter.dataBus?.savedAddresses?.first?.lastName, "TestLastName")
            XCTAssertNotNil(self?.addressPresenter.dataBus?.shoppingCart)
            XCTAssertEqual(self?.addressPresenter.dataBus?.shoppingCart?.data?.cartID, "TestCartId")
            XCTAssertEqual(self?.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:fetchShoppingCart:Hybris:The operation couldn’t be completed. ( error 123.):123")
        })
    }
    
    func testEditAddressSuccess() {
        let mockAddress = ECSAddress()
        mockAddress.firstName = "TestFirstName"
        mockAddress.lastName = "TestLastName"
        
        let mockSecondAddress = ECSAddress()
        mockSecondAddress.firstName = "TestSecondName"
        mockSecondAddress.lastName = "TestSecondLastName"
        
        mockECSService?.savedAddresses = [mockAddress, mockSecondAddress]
        mockECSService?.shoppingCart = ECSPILShoppingCart()
        
        addressPresenter.saveEditedAddress(address: mockAddress) { [weak self] (addresses, error) in
            XCTAssertNotNil(addresses)
            XCTAssertNil(error)
            XCTAssertNotNil(self?.addressPresenter.dataBus?.savedAddresses)
            XCTAssertEqual(self?.addressPresenter.dataBus?.savedAddresses?.count, 2)
            XCTAssertEqual(self?.addressPresenter.dataBus?.savedAddresses?.first?.firstName, "TestFirstName")
            XCTAssertNil(self?.addressPresenter.dataBus?.savedAddresses?.first?.phone)
            XCTAssertEqual(self?.addressPresenter.dataBus?.savedAddresses?.last?.lastName, "TestSecondLastName")
            XCTAssertNotNil(self?.addressPresenter.dataBus?.shoppingCart)
        }
    }
    
    func testEditAddressSaveFail() {
        let mockAddress = ECSAddress()
        mockAddress.firstName = "TestFirstName"
        mockAddress.lastName = "TestLastName"
        
        let mockSecondAddress = ECSAddress()
        mockSecondAddress.firstName = "TestSecondName"
        mockSecondAddress.lastName = "TestSecondLastName"
        
        mockECSService?.saveAddressError = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey:"Save address failed"])
        mockECSService?.shoppingCart = ECSPILShoppingCart()
        addressPresenter.dataBus?.savedAddresses = [mockAddress]
        
        mockECSService?.shouldSendOauthError = true
        
        addressPresenter.saveEditedAddress(address: mockAddress) { [weak self] (addresses, error) in
            XCTAssertNotNil(addresses)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 123)
            XCTAssertNotNil(self?.addressPresenter.dataBus?.savedAddresses)
            XCTAssertEqual(self?.addressPresenter.dataBus?.savedAddresses?.count, 1)
            XCTAssertEqual(self?.addressPresenter.dataBus?.savedAddresses?.first?.firstName, "TestFirstName")
            XCTAssertNil(self?.addressPresenter.dataBus?.shoppingCart)
            XCTAssertEqual(self?.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self?.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:updateAddressWith:Hybris:Save address failed:123")
        }
    }
    
    func testEditAddressSaveOAuthFail() {
        let mockAddress = ECSAddress()
        mockAddress.firstName = "TestFirstName"
        mockAddress.lastName = "TestLastName"
        
        let mockSecondAddress = ECSAddress()
        mockSecondAddress.firstName = "TestSecondName"
        mockSecondAddress.lastName = "TestSecondLastName"
        
        mockECSService?.savedAddresses = [mockAddress, mockSecondAddress]
        mockECSService?.shoppingCart = ECSPILShoppingCart()
        
        addressPresenter.saveEditedAddress(address: mockAddress) { [weak self] (addresses, error) in
            XCTAssertNotNil(addresses)
            XCTAssertNil(error)
            XCTAssertNotNil(self?.addressPresenter.dataBus?.savedAddresses)
            XCTAssertEqual(self?.addressPresenter.dataBus?.savedAddresses?.count, 2)
            XCTAssertEqual(self?.addressPresenter.dataBus?.savedAddresses?.first?.firstName, "TestFirstName")
            XCTAssertNil(self?.addressPresenter.dataBus?.savedAddresses?.first?.phone)
            XCTAssertEqual(self?.addressPresenter.dataBus?.savedAddresses?.last?.lastName, "TestSecondLastName")
            XCTAssertNotNil(self?.addressPresenter.dataBus?.shoppingCart)
        }
    }
    
    func testEditAddressFetchAddressFail() {
        let mockAddress = ECSAddress()
        mockAddress.firstName = "TestFirstName"
        mockAddress.lastName = "TestLastName"
        
        let mockSecondAddress = ECSAddress()
        mockSecondAddress.firstName = "TestSecondName"
        mockSecondAddress.lastName = "TestSecondLastName"
        
        mockECSService?.savedAddresses = [mockAddress, mockSecondAddress]
        mockECSService?.shoppingCartError = NSError(domain: "", code: 123, userInfo: nil)
        addressPresenter.dataBus?.savedAddresses = [mockAddress]
        
        addressPresenter.saveEditedAddress(address: mockAddress) { [weak self] (addresses, error) in
            XCTAssertNotNil(addresses)
            XCTAssertNil(error)
            XCTAssertNotNil(self?.addressPresenter.dataBus?.savedAddresses)
            XCTAssertEqual(self?.addressPresenter.dataBus?.savedAddresses?.count, 2)
            XCTAssertEqual(self?.addressPresenter.dataBus?.savedAddresses?.first?.firstName, "TestFirstName")
            XCTAssertEqual(self?.addressPresenter.dataBus?.savedAddresses?.last?.lastName, "TestSecondLastName")
            XCTAssertNil(self?.addressPresenter.dataBus?.shoppingCart)
        }
    }
    
    func testRegionsAreNotDownloadedForUnsupportedCountries() {
        let mockAddressModel = MECAddressFieldsConfigModel()
        let regionModel = MECAddressFieldConfig()
        regionModel.identifier = MECConstants.MECAddressStateKey
        regionModel.unsupportedLocales = ["US"]
        mockAddressModel.addressFields = [regionModel]
        
        let mockRegion = ECSRegion()
        mockRegion.countryISO = "TestRegionISO"
        
        let mockAddressPresenter = MECMockAddAddressPresenter(addressDataBus: MECDataBus())
        mockAddressPresenter.mockAddressConfigData = mockAddressModel
        MECConfiguration.shared.locale = "en_US"
        mockECSService?.regions = [mockRegion]
        let addressVC = MECAddAddressViewController.instantiateFromAppStoryboard(appStoryboard: .addAddress)
        addressVC?.presenter = mockAddressPresenter
        _ = addressVC?.view
        
        let expirationHandler = self.expectation(description: "testRegionsAreNotDownloadedForUnsupportedCountries")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertNil(mockAddressPresenter.fetchedRegions)
            expirationHandler.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testRegionsAreDownloadedForSupportedCountries() {
        let mockAddressModel = MECAddressFieldsConfigModel()
        let regionModel = MECAddressFieldConfig()
        regionModel.identifier = MECConstants.MECAddressStateKey
        regionModel.unsupportedLocales = ["US"]
        mockAddressModel.addressFields = [regionModel]
        
        let mockRegion = ECSRegion()
        mockRegion.countryISO = "TestRegionISO"
        
        let mockAddressPresenter = MECMockAddAddressPresenter(addressDataBus: MECDataBus())
        mockAddressPresenter.mockAddressConfigData = mockAddressModel
        MECConfiguration.shared.locale = "de_DE"
        mockECSService?.regions = [mockRegion]
        let addressVC = MECAddAddressViewController.instantiateFromAppStoryboard(appStoryboard: .addAddress)
        addressVC?.presenter = mockAddressPresenter
        _ = addressVC?.view
        
        let expirationHandler = self.expectation(description: "testRegionsAreDownloadedForSupportedCountries")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertNotNil(mockAddressPresenter.fetchedRegions)
            XCTAssertEqual(mockAddressPresenter.fetchedRegions?.contains(mockRegion), true)
            expirationHandler.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testEditAddressCreatedHasOldAddressID() {
        let addressVC = MECAddAddressViewController.instantiateFromAppStoryboard(appStoryboard: .addAddress)
        addressVC?.presenter = addressPresenter
        _ = addressVC?.view
        
        let mockAddress = ECSAddress()
        mockAddress.addressID = "SavedAddressID"
        let newAddress = addressPresenter.constructAddressFor(addressView: addressVC?.shippingAddressFields ?? MECAddressFieldView(), currentAddress: mockAddress)
        XCTAssertNotEqual(mockAddress, newAddress)
        XCTAssertEqual(newAddress.addressID, "SavedAddressID")
    }
    
    func testNewAddressCreatedHasNoAddressID() {
        let addressVC = MECAddAddressViewController.instantiateFromAppStoryboard(appStoryboard: .addAddress)
        addressVC?.presenter = addressPresenter
        _ = addressVC?.view
        
        let newAddress = addressPresenter.constructAddressFor(addressView: addressVC?.shippingAddressFields ?? MECAddressFieldView())
        XCTAssertNotNil(newAddress)
        XCTAssertNil(newAddress.addressID)
    }
    
    func testRegionSupportFromAddressConfigModel() {
        let mockAddressModel = MECAddressFieldsConfigModel()
        let regionModel = MECAddressFieldConfig()
        regionModel.identifier = MECConstants.MECAddressStateKey
        regionModel.unsupportedLocales = ["DE", "US"]
        mockAddressModel.addressFields = [regionModel]
        
        XCTAssertFalse(mockAddressModel.isRegionSupported(for: "us"))
        XCTAssertFalse(mockAddressModel.isRegionSupported(for: "US"))
        XCTAssertTrue(mockAddressModel.isRegionSupported(for: "NL"))
        
        regionModel.unsupportedLocales = nil
        XCTAssertFalse(mockAddressModel.isRegionSupported(for: "us"))
    }
    
    func testFetchRegionFromSavedAddress() {
        let address = ECSAddress()
        let country = ECSCountry()
        country.isocode = "US"
        address.country = country
        
        let mockAddressModel = MECAddressFieldsConfigModel()
        let regionModel = MECAddressFieldConfig()
        regionModel.identifier = MECConstants.MECAddressStateKey
        regionModel.unsupportedLocales = ["US"]
        mockAddressModel.addressFields = [regionModel]
        
        let mockRegion = ECSRegion()
        mockRegion.countryISO = "TestRegionISO"
        
        let mockAddressPresenter = MECMockAddAddressPresenter(addressDataBus: MECDataBus())
        mockAddressPresenter.mockAddressConfigData = mockAddressModel
        mockAddressPresenter.shippingAddress = address
        MECConfiguration.shared.locale = "de_DE"
        mockECSService?.regions = [mockRegion]
        let addressVC = MECAddAddressViewController.instantiateFromAppStoryboard(appStoryboard: .addAddress)
        addressVC?.presenter = mockAddressPresenter
        _ = addressVC?.view
        
        let expirationHandler = self.expectation(description: "testFetchRegionFromSavedAddress")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertNil(mockAddressPresenter.fetchedRegions)
            expirationHandler.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
        
    }
    
    func testBlankFieldValidator() {
        let blankFieldValidator = MECBlankFieldValidator()
        blankFieldValidator.validationMessage = "Blank Test Message"
        
        XCTAssertNil(blankFieldValidator.fetchValidatationDetailsFor(textFieldText: nil, locale: ""))
        XCTAssertNotNil(blankFieldValidator.fetchValidatationDetailsFor(textFieldText: "", locale: ""))
        XCTAssertEqual(blankFieldValidator.fetchValidatationDetailsFor(textFieldText: "", locale: ""), "Blank Test Message")
        XCTAssertNil(blankFieldValidator.fetchValidatationDetailsFor(textFieldText: "abcd", locale: ""))
        XCTAssertNil(blankFieldValidator.fetchValidatationDetailsFor(textFieldText: "abcd", locale: "US"))
        XCTAssertNil(blankFieldValidator.fetchValidatationDetailsFor(textFieldText: nil, locale: "US"))
        XCTAssertNotNil(blankFieldValidator.fetchValidatationDetailsFor(textFieldText: "", locale: "US"))
        XCTAssertEqual(blankFieldValidator.fetchValidatationDetailsFor(textFieldText: "", locale: "US"), "Blank Test Message")
    }
    
    func testFieldValidatorFactory() {
        XCTAssertNil(MECAddressValidationFactory.fetchValidatorFor(validationType: ""))
        XCTAssertNotNil(MECAddressValidationFactory.fetchValidatorFor(validationType: MECConstants.MECAddressValidationBlankType))
        XCTAssertEqual(MECAddressValidationFactory.fetchValidatorFor(validationType: MECConstants.MECAddressValidationBlankType)?.isKind(of: MECBlankFieldValidator.classForCoder()), true)
        XCTAssertNotNil(MECAddressValidationFactory.fetchValidatorFor(validationType: MECConstants.MECAddressValidationPhoneType))
        XCTAssertEqual(MECAddressValidationFactory.fetchValidatorFor(validationType: MECConstants.MECAddressValidationPhoneType)?.isKind(of: MECAddressPhoneFieldValidator.classForCoder()), true)
    }
    
    func testAddressSalutationServerValue() {
        XCTAssertEqual(MECAddressSalutation.mr.valueForItem(), "mr.")
        XCTAssertEqual(MECAddressSalutation.ms.valueForItem(), "ms.")
    }
    
    func testAddressRegionDisplayName() {
        let region = ECSRegion()
        region.name = "TestName"
        region.isocode = "TestIsoCode"
        
        XCTAssertNotNil(region.titleForItem())
        XCTAssertEqual(region.titleForItem(), "TestName")
        
        region.name = nil
        XCTAssertNotNil(region.titleForItem())
        XCTAssertEqual(region.titleForItem(), "")
    }
    
    func testAddressRegionDisplayNameFromRegionFirst() {
        let firstRegion = ECSRegion()
        firstRegion.isocode = "FirstIsocode"
        firstRegion.isocodeShort = "FirstIsocodeShort"
        firstRegion.name = "FirstName"
        
        let secondRegion = ECSRegion()
        secondRegion.isocode = "SecondRegionIsocode"
        secondRegion.isocodeShort = "SecondRegionIsocodeShort"
        
        let secondRegionDuplicate = ECSRegion()
        secondRegionDuplicate.isocode = "SecondRegionIsocode"
        secondRegionDuplicate.name = "SecondRegionDuplicateName"
        
        let thirdRegion = ECSRegion()
        thirdRegion.isocode = "ThirdRegionRegionIsocode"
        thirdRegion.isocodeShort = "ThirdRegionRegionIsocodeShort"
        
        let fourthRegion = ECSRegion()
        fourthRegion.isocodeShort = "FourthRegionIsocodeShort"
        
        let fifthRegion = ECSRegion()
        fourthRegion.isocode = "FifthRegionIsocodeShort"
        
        XCTAssertEqual(firstRegion.displayNameFromRegion(fetchedRegions: [secondRegion, firstRegion]), "FirstName")
        XCTAssertNil(thirdRegion.displayNameFromRegion(fetchedRegions: nil))
        XCTAssertEqual(secondRegion.displayNameFromRegion(fetchedRegions: [secondRegionDuplicate, secondRegion, firstRegion, thirdRegion]), "SecondRegionDuplicateName")
        XCTAssertEqual(fourthRegion.displayNameFromRegion(fetchedRegions: [secondRegionDuplicate, secondRegion, firstRegion, thirdRegion]), "FourthRegionIsocodeShort")
        XCTAssertNil(fifthRegion.displayNameFromRegion(fetchedRegions: [secondRegionDuplicate, secondRegion, firstRegion, thirdRegion]))
    }
    
    func testConstructFullName() {
        let address = ECSAddress()
        
        XCTAssertEqual(address.constructFullName(), "")
        address.firstName = "First"
        XCTAssertEqual(address.constructFullName(), "First")
        address.lastName = "Last"
        XCTAssertEqual(address.constructFullName(), "First Last")
        address.firstName = nil
        XCTAssertEqual(address.constructFullName(), "Last")
        address.firstName = ""
        address.lastName = ""
        XCTAssertEqual(address.constructFullName(), "")
        address.firstName = "First Name"
        address.lastName = "Last"
        XCTAssertEqual(address.constructFullName(), "First Name Last")
    }
    
    func testMECCountryCode() {
        var country: String? = "en_US"
        XCTAssertEqual(country?.fetchMECCountryCode(), "US")
        country = "en"
        XCTAssertNil(country?.fetchMECCountryCode())
        country = "en-us"
        XCTAssertEqual(country?.fetchMECCountryCode(), "us")
        country = nil
        XCTAssertNil(country?.fetchMECCountryCode())
        country = "en_US-DE"
        XCTAssertEqual(country?.fetchMECCountryCode(), "DE")
        country = "en_"
        XCTAssertNil(country?.fetchMECCountryCode())
    }
    
    func testMECAddressDisplayString() {
        var address: ECSAddress? = ECSAddress()
        let region = ECSRegion()
        let country = ECSCountry()
        region.countryISO = "regionCountryISO"
        region.isocodeShort = "regionIsocodeShort"
        region.isocode = "regionIsocode"
        region.name = "regionName"
        country.isocode = "countryISO"
        country.name = "countryName"
        XCTAssertEqual(address?.constructShippingAddressDisplayString(), "")
        
        address?.houseNumber = "23"
        address?.line1 = "Line1"
        address?.line2 = "Line2"
        address?.town = "New York"
        address?.region = region
        address?.postalCode = "10024"
        address?.country = country
        XCTAssertEqual(address?.constructShippingAddressDisplayString(), "23, Line1, \nLine2, \nNew York, \nregionName 10024, countryName")
        
        address?.region?.name = nil
        XCTAssertEqual(address?.constructShippingAddressDisplayString(), "23, Line1, \nLine2, \nNew York, \nregionIsocodeShort 10024, countryName")
        
        address?.region?.name = ""
        XCTAssertEqual(address?.constructShippingAddressDisplayString(), "23, Line1, \nLine2, \nNew York, \n10024, countryName")
        
        address?.region?.isocodeShort = nil
        XCTAssertEqual(address?.constructShippingAddressDisplayString(), "23, Line1, \nLine2, \nNew York, \n10024, countryName")
        
        address?.region = nil
        XCTAssertEqual(address?.constructShippingAddressDisplayString(), "23, Line1, \nLine2, \nNew York, \n10024, countryName")
        
        region.countryISO = "regionCountryISO"
        region.isocodeShort = "regionIsocodeShort"
        region.isocode = "regionIsocode"
        region.name = "regionName"
        address?.region = region
        address?.country?.name = nil
        XCTAssertEqual(address?.constructShippingAddressDisplayString(), "23, Line1, \nLine2, \nNew York, \nregionName 10024, countryISO")
        
        address?.country?.name = ""
        XCTAssertEqual(address?.constructShippingAddressDisplayString(), "23, Line1, \nLine2, \nNew York, \nregionName 10024, ")
        
        address?.country?.isocode = nil
        XCTAssertEqual(address?.constructShippingAddressDisplayString(), "23, Line1, \nLine2, \nNew York, \nregionName 10024, ")
        
        address?.country = nil
        XCTAssertEqual(address?.constructShippingAddressDisplayString(), "23, Line1, \nLine2, \nNew York, \nregionName 10024, ")
        
        country.isocode = "countryISO"
        country.name = "countryName"
        address?.country = country
        address?.houseNumber = ""
        XCTAssertEqual(address?.constructShippingAddressDisplayString(), "Line1, \nLine2, \nNew York, \nregionName 10024, countryName")
        
        address?.houseNumber = nil
        XCTAssertEqual(address?.constructShippingAddressDisplayString(), "Line1, \nLine2, \nNew York, \nregionName 10024, countryName")
        
        address?.houseNumber = "23"
        address?.line2 = ""
        XCTAssertEqual(address?.constructShippingAddressDisplayString(), "23, Line1, \nNew York, \nregionName 10024, countryName")
        
        address?.houseNumber = nil
        address?.line1 = "23,Line1"
        address?.line2 = nil
        address?.region = nil        
        XCTAssertEqual(address?.constructShippingAddressDisplayString(), "23,Line1, \nNew York, \n10024, countryName")
        
        address = nil
        XCTAssertNil(address?.constructShippingAddressDisplayString())
    }
}

class MECMockAddAddressPresenter: MECAddAddressPresenter {
    
    var mockAddressConfigData: MECAddressFieldsConfigModel?
    
    override func parseAddressFieldConfiguration(completionHandler: () -> Void) {
        addressFieldConfigurationData = mockAddressConfigData
        completionHandler()
    }
    
}
