/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import PhilipsEcommerceSDK
@testable import MobileEcommerceDev

class MECManageAddressTests: XCTestCase {
    
    var manageAddressPresenter: MECManageAddressPresenter!
    var mockECSService: MockECSService?
    var mockTagging: MECMockTagger?
    
    override func setUp() {
        super.setUp()
        let appInfra = MockAppInfra()
        MECConfiguration.shared.sharedAppInfra = appInfra
        let mockDataBus = MECDataBus()
        manageAddressPresenter = MECManageAddressPresenter(deliveryDetailsDataBus: mockDataBus)
        mockECSService = MockECSService(propositionId: "TEST", appInfra: appInfra)
        MECConfiguration.shared.ecommerceService = mockECSService
        MECConfiguration.shared.isHybrisAvailable = true
        mockTagging = MECMockTagger()
        MECConfiguration.shared.mecTagging = mockTagging
    }

    override func tearDown() {
        super.tearDown()
        manageAddressPresenter = nil
        mockECSService = nil
        MECConfiguration.shared.ecommerceService = nil
        MECConfiguration.shared.isHybrisAvailable = false
        MECConfiguration.shared.sharedAppInfra = nil
    }
    
    func testDeleteAddressSuccess() {
        let address1 = ECSAddress()
        address1.addressID = "address1Id"
        address1.firstName = "address1FirstName"
        
        let address2 = ECSAddress()
        address2.addressID = "address2Id"
        address2.firstName = "address2FirstName"
        
        let shoppingCart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        shoppingCart.data = data
        shoppingCart.data?.cartID = "CartID"
        
        mockECSService?.savedAddresses = [address1]
        mockECSService?.shoppingCart = shoppingCart
        manageAddressPresenter.dataBus?.savedAddresses = [address1, address2]
        
        manageAddressPresenter.deleteAddress(address: address2) { [weak self] (error) in
            XCTAssertNil(error)
            XCTAssertEqual(self?.manageAddressPresenter.dataBus?.savedAddresses?.count, 1)
            XCTAssertEqual(self?.manageAddressPresenter.dataBus?.savedAddresses?.contains(address2), false)
            XCTAssertNotNil(self?.manageAddressPresenter.dataBus?.shoppingCart)
        }
    }
    
    func testDeleteAddressOAuthFailure() {
        let address1 = ECSAddress()
        address1.addressID = "address1Id"
        address1.firstName = "address1FirstName"
        
        let address2 = ECSAddress()
        address2.addressID = "address2Id"
        address2.firstName = "address2FirstName"
        
        let shoppingCart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        shoppingCart.data = data
        shoppingCart.data?.cartID = "CartID"
        
        mockECSService?.savedAddresses = [address1]
        mockECSService?.shoppingCart = shoppingCart
        manageAddressPresenter.dataBus?.savedAddresses = [address1, address2]
        mockECSService?.shouldSendOauthError = true
        
        manageAddressPresenter.deleteAddress(address: address2) { [weak self] (error) in
            XCTAssertNil(error)
            XCTAssertEqual(self?.manageAddressPresenter.dataBus?.savedAddresses?.count, 1)
            XCTAssertEqual(self?.manageAddressPresenter.dataBus?.savedAddresses?.contains(address2), false)
            XCTAssertNotNil(self?.manageAddressPresenter.dataBus?.shoppingCart)
        }
    }
    
    func testDeleteAddressFailure() {
        let address1 = ECSAddress()
        address1.addressID = "address1Id"
        address1.firstName = "address1FirstName"
        
        let address2 = ECSAddress()
        address2.addressID = "address2Id"
        address2.firstName = "address2FirstName"
        
        let shoppingCart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        shoppingCart.data = data
        shoppingCart.data?.cartID = "CartID"
        
        manageAddressPresenter.dataBus?.shoppingCart = shoppingCart
        manageAddressPresenter.dataBus?.savedAddresses = [address1, address2]
        mockECSService?.deleteAddressError = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey: "delete address failed"])
        
        manageAddressPresenter.deleteAddress(address: address2) { [weak self] (error) in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 123)
            XCTAssertEqual(self?.manageAddressPresenter.dataBus?.savedAddresses?.count, 2)
            XCTAssertEqual(self?.manageAddressPresenter.dataBus?.savedAddresses?.contains(address2), true)
            XCTAssertNotNil(self?.manageAddressPresenter.dataBus?.shoppingCart)
            XCTAssertEqual(self?.manageAddressPresenter.dataBus?.shoppingCart?.data?.cartID, "CartID")
            
            XCTAssertEqual(self?.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self?.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:deleteAddress:Hybris:delete address failed:123")
        }
    }
    
    func testDeleteAddressFetchShoppingCartFailure() {
        let address1 = ECSAddress()
        address1.addressID = "address1Id"
        address1.firstName = "address1FirstName"

        let address2 = ECSAddress()
        address2.addressID = "address2Id"
        address2.firstName = "address2FirstName"

        let shoppingCart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        shoppingCart.data = data
        shoppingCart.data?.cartID = "CartID"

        manageAddressPresenter.dataBus?.shoppingCart = shoppingCart
        manageAddressPresenter.dataBus?.savedAddresses = [address1, address2]
        mockECSService?.savedAddresses = [address1]
        mockECSService?.shoppingCartError = NSError(domain: "", code: 123, userInfo: nil)

        manageAddressPresenter.deleteAddress(address: address2) { [weak self] (error) in
            XCTAssertNil(error)
            XCTAssertEqual(self?.manageAddressPresenter.dataBus?.savedAddresses?.count, 1)
            XCTAssertEqual(self?.manageAddressPresenter.dataBus?.savedAddresses?.contains(address2), false)
            XCTAssertNotNil(self?.manageAddressPresenter.dataBus?.shoppingCart)
            XCTAssertEqual(self?.manageAddressPresenter.dataBus?.shoppingCart?.data?.cartID, "CartID")
        }
    }
    
    func testShuffleSavedAddresses() {
        let address1 = ECSAddress()
        address1.addressID = "address1Id"
        address1.firstName = "address1FirstName"

        let address2 = ECSAddress()
        address2.addressID = "address2Id"
        address2.firstName = "address2FirstName"
        
        let address3 = ECSAddress()
        address3.addressID = "address3Id"
        address3.firstName = "address3FirstName"
        
        let address4 = ECSAddress()
        address4.addressID = "address4Id"
        address4.firstName = "address4FirstName"
        
        let address5 = ECSAddress()
        address5.addressID = "address5Id"
        address5.firstName = "address5FirstName"
        
        manageAddressPresenter.savedAddresses = [address1, address2, address3, address4]
        manageAddressPresenter.currentShippingAddress = address2
        manageAddressPresenter.shuffleSavedAddresses()
        
        XCTAssertEqual(manageAddressPresenter.savedAddresses?[0], address2)
        XCTAssertEqual(manageAddressPresenter.savedAddresses?[1], address1)
        XCTAssertEqual(manageAddressPresenter.savedAddresses?[2], address3)
        XCTAssertEqual(manageAddressPresenter.savedAddresses?[3], address4)
        XCTAssertEqual(manageAddressPresenter.savedAddresses?.first?.addressID, "address2Id")
        XCTAssertEqual(manageAddressPresenter.savedAddresses?.count, 4)
        
        manageAddressPresenter.savedAddresses = [address1, address2, address3, address4, address5]
        manageAddressPresenter.currentShippingAddress = address5
        manageAddressPresenter.shuffleSavedAddresses()
        
        XCTAssertEqual(manageAddressPresenter.savedAddresses?[0], address5)
        XCTAssertEqual(manageAddressPresenter.savedAddresses?[1], address1)
        XCTAssertEqual(manageAddressPresenter.savedAddresses?[2], address2)
        XCTAssertEqual(manageAddressPresenter.savedAddresses?[3], address3)
        XCTAssertEqual(manageAddressPresenter.savedAddresses?[4], address4)
        XCTAssertEqual(manageAddressPresenter.savedAddresses?.first?.addressID, "address5Id")
        XCTAssertEqual(manageAddressPresenter.savedAddresses?.count, 5)
        
        manageAddressPresenter.savedAddresses = [address1, address2, address3, address4, address5]
        manageAddressPresenter.currentShippingAddress = address1
        manageAddressPresenter.shuffleSavedAddresses()
        
        XCTAssertEqual(manageAddressPresenter.savedAddresses?[0], address1)
        XCTAssertEqual(manageAddressPresenter.savedAddresses?[1], address2)
        XCTAssertEqual(manageAddressPresenter.savedAddresses?[2], address3)
        XCTAssertEqual(manageAddressPresenter.savedAddresses?[3], address4)
        XCTAssertEqual(manageAddressPresenter.savedAddresses?[4], address5)
        XCTAssertEqual(manageAddressPresenter.savedAddresses?.first?.addressID, "address1Id")
        XCTAssertEqual(manageAddressPresenter.savedAddresses?.count, 5)
        
        manageAddressPresenter.savedAddresses = [address1, address2, address3, address4]
        manageAddressPresenter.currentShippingAddress = address5
        manageAddressPresenter.shuffleSavedAddresses()
        
        XCTAssertEqual(manageAddressPresenter.savedAddresses?.first, address1)
        XCTAssertEqual(manageAddressPresenter.savedAddresses?.first?.addressID, "address1Id")
        XCTAssertEqual(manageAddressPresenter.savedAddresses?.count, 4)
        
        manageAddressPresenter.savedAddresses = [address1, address2, address3, address4]
        manageAddressPresenter.currentShippingAddress = nil
        manageAddressPresenter.shuffleSavedAddresses()
        
        XCTAssertEqual(manageAddressPresenter.savedAddresses?.first, address1)
        XCTAssertEqual(manageAddressPresenter.savedAddresses?.first?.addressID, "address1Id")
        XCTAssertEqual(manageAddressPresenter.savedAddresses?.count, 4)
        
        manageAddressPresenter.savedAddresses = []
        manageAddressPresenter.currentShippingAddress = address5
        manageAddressPresenter.shuffleSavedAddresses()
        
        XCTAssertNil(manageAddressPresenter.savedAddresses?.first)
        XCTAssertNil(manageAddressPresenter.savedAddresses?.first?.addressID)
        
        manageAddressPresenter.savedAddresses = nil
        manageAddressPresenter.shuffleSavedAddresses()
        
        XCTAssertNil(manageAddressPresenter.savedAddresses)
        XCTAssertNil(manageAddressPresenter.savedAddresses?.first?.addressID)
        
        manageAddressPresenter.savedAddresses = nil
        manageAddressPresenter.currentShippingAddress = nil
        manageAddressPresenter.shuffleSavedAddresses()
        
        XCTAssertNil(manageAddressPresenter.savedAddresses)
        XCTAssertNil(manageAddressPresenter.savedAddresses?.first?.addressID)
    }
    
    func testSetUserSelectedDeliveryAddressSuccess() {
        let address1 = ECSAddress()
        address1.addressID = "address1Id"
        address1.firstName = "address1FirstName"
        
        let address2 = ECSAddress()
        address2.addressID = "address2Id"
        address2.firstName = "address2FirstName"
        
        let shoppingCart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        shoppingCart.data = data
        shoppingCart.data?.cartID = "CartID"
        
        let oldShoppingCart = ECSPILShoppingCart()
        let oldData = ECSPILDataClass()
        oldShoppingCart.data = oldData
        oldShoppingCart.data?.cartID = "OldCartID"
        
        mockECSService?.savedAddresses = [address1, address2]
        mockECSService?.shoppingCart = shoppingCart
        
        manageAddressPresenter.dataBus?.savedAddresses = [address1]
        manageAddressPresenter.dataBus?.shoppingCart = oldShoppingCart
        
        manageAddressPresenter.setUserSelectedDeliveryAddress(address: address1) { [weak self] (error) in
            XCTAssertNil(error)
            XCTAssertEqual(self?.manageAddressPresenter.dataBus?.savedAddresses?.count, 2)
            XCTAssertEqual(self?.manageAddressPresenter.dataBus?.savedAddresses?.contains(address2), true)
            XCTAssertNotNil(self?.manageAddressPresenter.dataBus?.shoppingCart)
            XCTAssertEqual(self?.manageAddressPresenter.dataBus?.shoppingCart?.data?.cartID, "CartID")
        }
    }
    
    func testSetUserSelectedDeliveryAddressFailure() {
        let address1 = ECSAddress()
        address1.addressID = "address1Id"
        address1.firstName = "address1FirstName"
        
        mockECSService?.setDeliveryAddressError = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey: "set address failed"])
        
        manageAddressPresenter.setUserSelectedDeliveryAddress(address: address1) { [weak self] (error) in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 123)
            XCTAssertNil(self?.manageAddressPresenter.dataBus?.shoppingCart)
            XCTAssertNil(self?.manageAddressPresenter.dataBus?.savedAddresses)
            XCTAssertEqual(self?.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self?.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:setDeliveryAddress:Hybris:set address failed:123")
        }
    }
    
    func testSetUserSelectedDeliveryAddressOAuthFailure() {
        let address1 = ECSAddress()
        address1.addressID = "address1Id"
        address1.firstName = "address1FirstName"
        
        let address2 = ECSAddress()
        address2.addressID = "address2Id"
        address2.firstName = "address2FirstName"
        
        let shoppingCart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        shoppingCart.data = data
        shoppingCart.data?.cartID = "CartID"
        
        let oldShoppingCart = ECSPILShoppingCart()
        let oldData = ECSPILDataClass()
        oldShoppingCart.data = oldData
        oldShoppingCart.data?.cartID = "OldCartID"
        
        mockECSService?.savedAddresses = [address1, address2]
        mockECSService?.shoppingCart = shoppingCart
        mockECSService?.shouldSendOauthError = true
        
        manageAddressPresenter.dataBus?.savedAddresses = [address1]
        manageAddressPresenter.dataBus?.shoppingCart = oldShoppingCart
        
        manageAddressPresenter.setUserSelectedDeliveryAddress(address: address1) { [weak self] (error) in
            XCTAssertNil(error)
            XCTAssertEqual(self?.manageAddressPresenter.dataBus?.savedAddresses?.count, 2)
            XCTAssertEqual(self?.manageAddressPresenter.dataBus?.savedAddresses?.contains(address2), true)
            XCTAssertNotNil(self?.manageAddressPresenter.dataBus?.shoppingCart)
            XCTAssertEqual(self?.manageAddressPresenter.dataBus?.shoppingCart?.data?.cartID, "CartID")
        }
    }
    
    func testSetUserSelectedDeliveryAddressDoesnotOverrideOldValues() {
        let address1 = ECSAddress()
        address1.addressID = "address1Id"
        address1.firstName = "address1FirstName"
        
        let address2 = ECSAddress()
        address2.addressID = "address2Id"
        address2.firstName = "address2FirstName"
        
        let shoppingCart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        shoppingCart.data = data
        shoppingCart.data?.cartID = "CartID"
        
        let oldShoppingCart = ECSPILShoppingCart()
        let oldData = ECSPILDataClass()
        oldShoppingCart.data = oldData
        oldShoppingCart.data?.cartID = "OldCartID"
        
        mockECSService?.shoppingCart = shoppingCart
        
        manageAddressPresenter.dataBus?.savedAddresses = [address1]
        manageAddressPresenter.dataBus?.shoppingCart = oldShoppingCart
        mockECSService?.setDeliveryAddressError = NSError(domain: "", code: 123, userInfo: nil)
        
        manageAddressPresenter.setUserSelectedDeliveryAddress(address: address1) { [weak self] (error) in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, 123)
            XCTAssertNotNil(self?.manageAddressPresenter.dataBus?.savedAddresses)
            XCTAssertEqual(self?.manageAddressPresenter.dataBus?.savedAddresses?.count, 1)
            XCTAssertEqual(self?.manageAddressPresenter.dataBus?.savedAddresses?.contains(address2), false)
            XCTAssertNotNil(self?.manageAddressPresenter.dataBus?.shoppingCart)
            XCTAssertEqual(self?.manageAddressPresenter.dataBus?.shoppingCart?.data?.cartID, "OldCartID")
        }
    }
    
    func testSetUserSelectedDeliveryAddressFetchCartFailure() {
        let address1 = ECSAddress()
        address1.addressID = "address1Id"
        address1.firstName = "address1FirstName"
        
        let address2 = ECSAddress()
        address2.addressID = "address2Id"
        address2.firstName = "address2FirstName"
        
        let shoppingCart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        shoppingCart.data = data
        shoppingCart.data?.cartID = "CartID"
        
        let oldShoppingCart = ECSPILShoppingCart()
        let oldData = ECSPILDataClass()
        oldShoppingCart.data = oldData
        oldShoppingCart.data?.cartID = "OldCartID"
        
        mockECSService?.savedAddresses = [address1, address2]
        mockECSService?.shoppingCartError = NSError(domain: "", code: 123, userInfo: nil)
        
        manageAddressPresenter.dataBus?.savedAddresses = [address1]
        manageAddressPresenter.dataBus?.shoppingCart = oldShoppingCart
        
        manageAddressPresenter.setUserSelectedDeliveryAddress(address: address1) { [weak self] (error) in
            XCTAssertNil(error)
            XCTAssertNotNil(self?.manageAddressPresenter.dataBus?.savedAddresses)
            XCTAssertEqual(self?.manageAddressPresenter.dataBus?.savedAddresses?.count, 2)
            XCTAssertEqual(self?.manageAddressPresenter.dataBus?.savedAddresses?.contains(address2), true)
            XCTAssertNotNil(self?.manageAddressPresenter.dataBus?.shoppingCart)
            XCTAssertEqual(self?.manageAddressPresenter.dataBus?.shoppingCart?.data?.cartID, "OldCartID")
        }
    }
}
