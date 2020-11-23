/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import MobileEcommerceDev
import PhilipsEcommerceSDK

class MECDeliveryDetailsPresenterTests: XCTestCase {
    
    var deliveryDetailsPresenter: MECDeliveryDetailsPresenter!
    var mockECSService: MockECSService?
    var mockTagging: MECMockTagger?
    
    override func setUp() {
        super.setUp()
        let appInfra = MockAppInfra()
        MECConfiguration.shared.sharedAppInfra = appInfra
        let mockDataBus = MECDataBus()
        deliveryDetailsPresenter = MECDeliveryDetailsPresenter(deliveryDetailsDataBus: mockDataBus)
        mockECSService = MockECSService(propositionId: "TEST", appInfra: appInfra)
        MECConfiguration.shared.ecommerceService = mockECSService
        MECConfiguration.shared.isHybrisAvailable = true
        mockTagging = MECMockTagger()
        MECConfiguration.shared.mecTagging = mockTagging
    }

    override func tearDown() {
        super.tearDown()
        deliveryDetailsPresenter = nil
        mockECSService = nil
        MECConfiguration.shared.ecommerceService = nil
        MECConfiguration.shared.isHybrisAvailable = false
        MECConfiguration.shared.sharedAppInfra = nil
    }
    
    func testFetchRegionsSuccess() {
        let firstRegion = ECSRegion()
        firstRegion.countryISO = "FirstRegionISO"
        firstRegion.name = "FirstRegion"
        
        let secondRegion = ECSRegion()
        secondRegion.countryISO = "SecondRegionISO"
        secondRegion.name = "SecondRegion"
        
        mockECSService?.regions = [firstRegion, secondRegion]
        deliveryDetailsPresenter.fetchRegions(country: "Test") { [weak self] in
            XCTAssertNotNil(self?.deliveryDetailsPresenter.fetchedRegions)
            XCTAssertEqual(self?.deliveryDetailsPresenter.fetchedRegions?.count, 2)
            XCTAssertEqual(self?.deliveryDetailsPresenter.fetchedRegions?.first?.name, "FirstRegion")
        }
    }
    
    func testFetchRegionsRefreshSuccess() {
        let firstRegion = ECSRegion()
        firstRegion.countryISO = "FirstRegionISO"
        firstRegion.name = "FirstRegion"
        
        let secondRegion = ECSRegion()
        secondRegion.countryISO = "SecondRegionISO"
        secondRegion.name = "SecondRegion"
        
        let originalRegion = ECSRegion()
        originalRegion.countryISO = "OriginalRegionISO"
        originalRegion.name = "OriginalRegion"
        
        deliveryDetailsPresenter.fetchedRegions = [originalRegion, firstRegion, secondRegion]
        
        mockECSService?.regions = [firstRegion, secondRegion]
        deliveryDetailsPresenter.fetchRegions(country: "Test") { [weak self] in
            XCTAssertNotNil(self?.deliveryDetailsPresenter.fetchedRegions)
            XCTAssertEqual(self?.deliveryDetailsPresenter.fetchedRegions?.count, 2)
            XCTAssertEqual(self?.deliveryDetailsPresenter.fetchedRegions?.first?.name, "FirstRegion")
            XCTAssertTrue(self?.deliveryDetailsPresenter.fetchedRegions?.contains(originalRegion) == false)
        }
    }
    
    func testFetchRegionsFail() {
        mockECSService?.regionError = NSError(domain: "", code: 123, userInfo: nil)
        deliveryDetailsPresenter.fetchRegions(country: "Test") { [weak self] in
            XCTAssertNil(self?.deliveryDetailsPresenter.fetchedRegions)
        }
    }
    
    func testFetchRegionsFailRefresh() {
        let firstRegion = ECSRegion()
        firstRegion.countryISO = "FirstRegionISO"
        firstRegion.name = "FirstRegion"
        
        let secondRegion = ECSRegion()
        secondRegion.countryISO = "SecondRegionISO"
        secondRegion.name = "SecondRegion"
        
        let originalRegion = ECSRegion()
        originalRegion.countryISO = "OriginalRegionISO"
        originalRegion.name = "OriginalRegion"
        
        deliveryDetailsPresenter.fetchedRegions = [originalRegion, firstRegion, secondRegion]
        
        mockECSService?.regionError = NSError(domain: "", code: 123, userInfo: nil)
        deliveryDetailsPresenter.fetchRegions(country: "Test") { [weak self] in
            XCTAssertNil(self?.deliveryDetailsPresenter.fetchedRegions)
        }
    }
    
    func testFetchRegionsWithoutCountryISO() {
        let firstRegion = ECSRegion()
        firstRegion.countryISO = "FirstRegionISO"
        firstRegion.name = "FirstRegion"
        
        let secondRegion = ECSRegion()
        secondRegion.countryISO = "SecondRegionISO"
        secondRegion.name = "SecondRegion"
        
        let originalRegion = ECSRegion()
        originalRegion.countryISO = "OriginalRegionISO"
        originalRegion.name = "OriginalRegion"
        
        deliveryDetailsPresenter.fetchedRegions = [firstRegion, secondRegion]
        mockECSService?.regions = [firstRegion, secondRegion, originalRegion]
        
        deliveryDetailsPresenter.fetchRegions(country: nil) { [weak self] in
            XCTAssertNotNil(self?.deliveryDetailsPresenter.fetchedRegions)
            XCTAssertEqual(self?.deliveryDetailsPresenter.fetchedRegions?.count, 2)
            XCTAssertTrue(self?.deliveryDetailsPresenter.fetchedRegions?.contains(originalRegion) == false)
        }
    }
    
    func testFetchDefaultAddressFromProfileSuccess() {
        let profile = ECSUserProfile()
        let defaultAddress = ECSAddress()
        defaultAddress.addressID = "TestAddressID"
        profile.defaultAddress = defaultAddress
        mockECSService?.userProfile = profile
        
        deliveryDetailsPresenter.fetchDefaultAddressFromUserProfile { (address, error) in
            XCTAssertNotNil(address)
            XCTAssertNil(error)
            XCTAssertEqual(address?.addressID, "TestAddressID")
        }
    }
    
    func testFetchDefaultAddressFromProfileWithNilDefaultAddress() {
        let profile = ECSUserProfile()
        mockECSService?.userProfile = profile
        
        deliveryDetailsPresenter.fetchDefaultAddressFromUserProfile { (address, error) in
            XCTAssertNil(address)
            XCTAssertNil(error)
        }
    }
    
    func testFetchDefaultAddressFromProfileFail() {
        mockECSService?.userProfileError = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey: "fetch default address from user profile failed"])
        
        deliveryDetailsPresenter.fetchDefaultAddressFromUserProfile { (address, error) in
            XCTAssertNil(address)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 123)
            XCTAssertEqual(self.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:fetchUserProfile:Hybris:fetch default address from user profile failed:123")
        }
    }
    
    func testSetShippingAddressFromShoppingCartSuccess() {
        let shoppingCart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        shoppingCart.data = data
        let shippingAddress = ECSPILAddress()
        shippingAddress.addressId = "TestAddress"
        shippingAddress.firstName = "CartAddressName"
        shoppingCart.data?.attributes?.deliveryAddress = shippingAddress
        
        let savedAddress = ECSAddress()
        savedAddress.addressID = "TestAddress"
        savedAddress.firstName = "SavedAddressName"
        
        deliveryDetailsPresenter.dataBus?.shoppingCart = shoppingCart
        deliveryDetailsPresenter.dataBus?.savedAddresses = [savedAddress]
        
        deliveryDetailsPresenter.setUpShippingAddress { [weak self] in
            XCTAssertNotNil(self?.deliveryDetailsPresenter.shippingAddress)
            XCTAssertEqual(self?.deliveryDetailsPresenter.shippingAddress?.addressID, "TestAddress")
            XCTAssertEqual(self?.deliveryDetailsPresenter.shippingAddress, savedAddress)
            XCTAssertEqual(self?.deliveryDetailsPresenter.shippingAddress?.firstName, "SavedAddressName")
        }
    }
    
    func testSetShippingAddressFromProfileFetchSuccess() {
        let profile = ECSUserProfile()
        let defaultAddress = ECSAddress()
        defaultAddress.addressID = "TestAddressID"
        defaultAddress.firstName = "DefaultAddressName"
        profile.defaultAddress = defaultAddress
        mockECSService?.userProfile = profile
        
        let savedAddress = ECSAddress()
        savedAddress.addressID = "TestAddressID"
        savedAddress.firstName = "SavedAddressName"
        
        deliveryDetailsPresenter.dataBus?.savedAddresses = [savedAddress]
        
        deliveryDetailsPresenter.setUpShippingAddress { [weak self] in
            XCTAssertNotNil(self?.deliveryDetailsPresenter.shippingAddress)
            XCTAssertEqual(self?.deliveryDetailsPresenter.shippingAddress?.addressID, "TestAddressID")
            XCTAssertEqual(self?.deliveryDetailsPresenter.shippingAddress, savedAddress)
            XCTAssertEqual(self?.deliveryDetailsPresenter.shippingAddress?.firstName, "SavedAddressName")
        }
    }
    
    func testSetShippingAddressFromFirstAddressSuccess() {
        let firstAddress = ECSAddress()
        firstAddress.addressID = "TestFirstAddressID"
        
        let secondAddress = ECSAddress()
        secondAddress.addressID = "TestSecondAddressID"
        
        deliveryDetailsPresenter.dataBus?.savedAddresses = [firstAddress, secondAddress]
        
        deliveryDetailsPresenter.setUpShippingAddress { [weak self] in
            XCTAssertNotNil(self?.deliveryDetailsPresenter.shippingAddress)
            XCTAssertEqual(self?.deliveryDetailsPresenter.shippingAddress?.addressID, "TestFirstAddressID")
        }
    }
    
    func testSetShippingAddressDefault() {
        deliveryDetailsPresenter.setUpShippingAddress { [weak self] in
            XCTAssertNil(self?.deliveryDetailsPresenter.shippingAddress)
        }
    }
    
    func testSetShippingAddressAllFailureDoesnotChangeOldValue() {
        let shoppingCart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        shoppingCart.data = data
        let shippingAddress = ECSAddress()
        shippingAddress.addressID = "TestAddress"
        
        let pilShippingAddress = ECSPILAddress()
        pilShippingAddress.addressId = "TestAddress"
        
        shoppingCart.data?.attributes?.deliveryAddress = pilShippingAddress
        
        deliveryDetailsPresenter.shippingAddress = shippingAddress
        deliveryDetailsPresenter.dataBus?.shoppingCart = shoppingCart
        
        deliveryDetailsPresenter.setUpShippingAddress { [weak self] in
            XCTAssertNil(self?.deliveryDetailsPresenter.shippingAddress)
            XCTAssertNotNil(self?.deliveryDetailsPresenter.dataBus?.shoppingCart)
            XCTAssertEqual(self?.deliveryDetailsPresenter.dataBus?.shoppingCart?.data?.attributes?.deliveryAddress?.addressId, "TestAddress")
        }
    }
    
    func testSetShippingAddressFetchAddressesFailure() {
        let firstAddress = ECSAddress()
        firstAddress.addressID = "TestFirstAddressID"

        let secondAddress = ECSAddress()
        secondAddress.addressID = "TestSecondAddressID"

        deliveryDetailsPresenter.dataBus?.savedAddresses = [firstAddress, secondAddress]
        mockECSService?.savedAddressesError = NSError(domain: "", code: 123, userInfo: nil)

        deliveryDetailsPresenter.setUpShippingAddress { [weak self] in
            XCTAssertNotNil(self?.deliveryDetailsPresenter.shippingAddress)
            XCTAssertEqual(self?.deliveryDetailsPresenter.shippingAddress?.addressID, "TestFirstAddressID")
        }
    }
    
    func testSetShippingAddressWithFirstAddressOAuthFailure() {
        let firstAddress = ECSAddress()
        firstAddress.addressID = "TestFirstAddressID"
        
        let secondAddress = ECSAddress()
        secondAddress.addressID = "TestSecondAddressID"
        
        deliveryDetailsPresenter.dataBus?.savedAddresses = [firstAddress, secondAddress]
        mockECSService?.shouldSendOauthErrorForSetDeliveryAddressWithBoolReturn = true
        
        deliveryDetailsPresenter.setUpShippingAddress { [weak self] in
            XCTAssertNotNil(self?.deliveryDetailsPresenter.shippingAddress)
            XCTAssertEqual(self?.deliveryDetailsPresenter.shippingAddress?.addressID, "TestFirstAddressID")
        }
    }
    
    func testSetShippingAddressFromProfileFetchOAuthFailure() {
        let profile = ECSUserProfile()
        let defaultAddress = ECSAddress()
        defaultAddress.addressID = "TestAddressID"
        defaultAddress.firstName = "DefaultAddressName"
        profile.defaultAddress = defaultAddress
        mockECSService?.userProfile = profile
        
        let savedAddress = ECSAddress()
        savedAddress.addressID = "TestAddressID"
        savedAddress.firstName = "SavedAddressName"
        
        deliveryDetailsPresenter.dataBus?.savedAddresses = [savedAddress]
        mockECSService?.shouldSendOauthError = true
        
        deliveryDetailsPresenter.setUpShippingAddress { [weak self] in
            XCTAssertNotNil(self?.deliveryDetailsPresenter.shippingAddress)
            XCTAssertEqual(self?.deliveryDetailsPresenter.shippingAddress?.addressID, "TestAddressID")
            XCTAssertEqual(self?.deliveryDetailsPresenter.shippingAddress, savedAddress)
            XCTAssertEqual(self?.deliveryDetailsPresenter.shippingAddress?.firstName, "SavedAddressName")
        }
    }
    
    func testSetShippingAddressSetDeliveryAddressFailureAfterProfileAddress() {
        let firstAddress = ECSAddress()
        firstAddress.addressID = "TestFirstAddressID"
        
        let secondAddress = ECSAddress()
        secondAddress.addressID = "TestSecondAddressID"
        
        let userProfile = ECSUserProfile()
        userProfile.defaultAddress = firstAddress
        
        mockECSService?.userProfile = userProfile
        mockECSService?.setDeliveryAddressError = NSError(domain: "", code: 123, userInfo: nil)
        
        deliveryDetailsPresenter.dataBus?.savedAddresses = [firstAddress, secondAddress]
        deliveryDetailsPresenter.setUpShippingAddress { [weak self] in
            XCTAssertNil(self?.deliveryDetailsPresenter.shippingAddress)
        }
    }
    
    func testSetShippingAddressCartFetchFailureAfterProfileAddress() {
        let firstAddress = ECSAddress()
        firstAddress.addressID = "TestFirstAddressID"
        
        let secondAddress = ECSAddress()
        secondAddress.addressID = "TestSecondAddressID"
        
        let userProfile = ECSUserProfile()
        userProfile.defaultAddress = secondAddress
        
        mockECSService?.userProfile = userProfile
        mockECSService?.savedAddresses = [firstAddress, secondAddress]
        mockECSService?.shoppingCartError = NSError(domain: "", code: 123, userInfo: nil)
        
        deliveryDetailsPresenter.dataBus?.savedAddresses = [firstAddress, secondAddress]
        deliveryDetailsPresenter.setUpShippingAddress { [weak self] in
            XCTAssertNotNil(self?.deliveryDetailsPresenter.shippingAddress)
            XCTAssertEqual(self?.deliveryDetailsPresenter.shippingAddress?.addressID, "TestSecondAddressID")
        }
    }
    
    func testSetShippingAddressSetDeliveryAddressFailureAfterFirstSavedAddress() {
        let firstAddress = ECSAddress()
        firstAddress.addressID = "TestFirstAddressID"
        
        let secondAddress = ECSAddress()
        secondAddress.addressID = "TestSecondAddressID"
        
        mockECSService?.setDeliveryAddressError = NSError(domain: "", code: 123, userInfo: nil)
        
        deliveryDetailsPresenter.dataBus?.savedAddresses = [firstAddress, secondAddress]
        deliveryDetailsPresenter.setUpShippingAddress { [weak self] in
            XCTAssertNil(self?.deliveryDetailsPresenter.shippingAddress)
        }
    }
    
    func testSetShippingAddressFetchCartFailureAfterFirstSavedAddress() {
        let firstAddress = ECSAddress()
        firstAddress.addressID = "TestFirstAddressID"
        
        let secondAddress = ECSAddress()
        secondAddress.addressID = "TestSecondAddressID"
        
        mockECSService?.savedAddresses = [firstAddress, secondAddress]
        mockECSService?.shoppingCartError = NSError(domain: "", code: 123, userInfo: nil)
        
        deliveryDetailsPresenter.dataBus?.savedAddresses = [firstAddress, secondAddress]
        deliveryDetailsPresenter.setUpShippingAddress { [weak self] in
            XCTAssertNotNil(self?.deliveryDetailsPresenter.shippingAddress)
            XCTAssertEqual(self?.deliveryDetailsPresenter.shippingAddress?.addressID, "TestFirstAddressID")
        }
    }
    
    func testSetupShippingAddressAfterAddressMismatchForProfileAddressSet() {
        let profile = ECSUserProfile()
        let defaultAddress = ECSAddress()
        defaultAddress.addressID = "TestAddressID"
        
        let firstSavedAddress = ECSAddress()
        firstSavedAddress.addressID = "FirstSavedAddressID"
        
        let secondSavedAddress = ECSAddress()
        secondSavedAddress.addressID = "SecondSavedAddressID"
        
        profile.defaultAddress = defaultAddress
        mockECSService?.userProfile = profile
        
        deliveryDetailsPresenter.dataBus?.savedAddresses = [secondSavedAddress, firstSavedAddress]
        
        deliveryDetailsPresenter.setUpShippingAddress { [weak self] in
            XCTAssertNotNil(self?.deliveryDetailsPresenter.shippingAddress)
            XCTAssertEqual(self?.deliveryDetailsPresenter.shippingAddress, secondSavedAddress)
            XCTAssertEqual(self?.deliveryDetailsPresenter.shippingAddress?.addressID, "SecondSavedAddressID")
        }
    }
    
    func testFetchSavedAddressesFailure() {
        let firstAddress = ECSAddress()
        firstAddress.addressID = "TestFirstAddressID"
        
        let secondAddress = ECSAddress()
        secondAddress.addressID = "TestSecondAddressID"
        
        deliveryDetailsPresenter.dataBus?.savedAddresses = [firstAddress, secondAddress]
        mockECSService?.savedAddressesError = NSError(domain: "", code: 123, userInfo: nil)
        
        deliveryDetailsPresenter.fetchSavedAddresses { [weak self] (addresses, error) in
            XCTAssertNil(addresses)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 123)
            XCTAssertNotNil(self?.deliveryDetailsPresenter.dataBus?.savedAddresses)
            XCTAssertEqual(self?.deliveryDetailsPresenter.dataBus?.savedAddresses?.count, 2)
        }
    }
    
    func testFetchSavedAddressesOAuthFailure() {
        let firstAddress = ECSAddress()
        firstAddress.addressID = "TestFirstAddressID"
        
        let secondAddress = ECSAddress()
        secondAddress.addressID = "TestSecondAddressID"
        
        mockECSService?.savedAddresses = [firstAddress, secondAddress]
        mockECSService?.shouldSendOauthError = true
        
        deliveryDetailsPresenter.fetchSavedAddresses { (addresses, error) in
            XCTAssertNotNil(addresses)
            XCTAssertNil(error)
            XCTAssertEqual(addresses?.count, 2)
        }
    }
}
