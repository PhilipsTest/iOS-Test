/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import PhilipsEcommerceSDK
@testable import MobileEcommerceDev

class MECDeliveryModesTests: XCTestCase {
    
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
    
    func testFetchDeliveryModesSuccess() {
        let firstDeliveryMode = ECSDeliveryMode()
        firstDeliveryMode.deliveryModeId = "FirstDeliveryModeId"
        firstDeliveryMode.deliveryModeName = "FirstDeliveryModeName"
        
        let secondDeliveryMode = ECSDeliveryMode()
        secondDeliveryMode.deliveryModeId = "SecondDeliveryModeId"
        secondDeliveryMode.deliveryModeName = "SecondDeliveryModeName"
        
        mockECSService?.deliveryModes = [firstDeliveryMode, secondDeliveryMode]
        deliveryDetailsPresenter.fetchDeliveryModes { [weak self] (_, _) in
            XCTAssertNotNil(self?.deliveryDetailsPresenter.fetchedDeliveryModes)
            XCTAssertEqual(self?.deliveryDetailsPresenter.fetchedDeliveryModes?.count, 2)
            XCTAssertEqual(self?.deliveryDetailsPresenter.fetchedDeliveryModes?.first?.deliveryModeId, "FirstDeliveryModeId")
        }
    }
    
    func testFetchDeliveryModesFailure() {
        mockECSService?.deliveryModeFetchError = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey: "fetch delivery mode failed"])
        deliveryDetailsPresenter.fetchDeliveryModes { [weak self] (_, _) in
            XCTAssertNil(self?.deliveryDetailsPresenter.fetchedDeliveryModes)
            
            XCTAssertEqual(self?.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self?.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:fetchDeliveryModes:Hybris:fetch delivery mode failed:123")
        }
    }
    
    func testFetchDeliveryModesOAuthFailure() {
        let firstDeliveryMode = ECSDeliveryMode()
        firstDeliveryMode.deliveryModeId = "FirstDeliveryModeId"
        firstDeliveryMode.deliveryModeName = "FirstDeliveryModeName"
        
        let secondDeliveryMode = ECSDeliveryMode()
        secondDeliveryMode.deliveryModeId = "SecondDeliveryModeId"
        secondDeliveryMode.deliveryModeName = "SecondDeliveryModeName"
        
        mockECSService?.deliveryModes = [firstDeliveryMode, secondDeliveryMode]
        mockECSService?.shouldSendOauthError = true
        
        deliveryDetailsPresenter.fetchDeliveryModes { [weak self] (_, _) in
            XCTAssertNotNil(self?.deliveryDetailsPresenter.fetchedDeliveryModes)
            XCTAssertEqual(self?.deliveryDetailsPresenter.fetchedDeliveryModes?.count, 2)
            XCTAssertEqual(self?.deliveryDetailsPresenter.fetchedDeliveryModes?.first?.deliveryModeId, "FirstDeliveryModeId")
        }
    }
    
    func testFetchDeliveryModesFailureDoesnotAffectOldDeliveryModes() {
        let firstDeliveryMode = ECSDeliveryMode()
        firstDeliveryMode.deliveryModeId = "FirstDeliveryModeId"
        firstDeliveryMode.deliveryModeName = "FirstDeliveryModeName"
        
        let secondDeliveryMode = ECSDeliveryMode()
        secondDeliveryMode.deliveryModeId = "SecondDeliveryModeId"
        secondDeliveryMode.deliveryModeName = "SecondDeliveryModeName"
        
        mockECSService?.deliveryModeFetchError = NSError(domain: "", code: 123, userInfo: nil)
        
        deliveryDetailsPresenter.fetchedDeliveryModes = [firstDeliveryMode, secondDeliveryMode]
        deliveryDetailsPresenter.fetchDeliveryModes { [weak self] (_, _) in
            XCTAssertNotNil(self?.deliveryDetailsPresenter.fetchedDeliveryModes)
            XCTAssertEqual(self?.deliveryDetailsPresenter.fetchedDeliveryModes?.count, 2)
            XCTAssertEqual(self?.deliveryDetailsPresenter.fetchedDeliveryModes?.last?.deliveryModeId, "SecondDeliveryModeId")
        }
    }
    
    func testSetDeliveryModeSuccess() {
        let deliveryMode = ECSDeliveryMode()
        deliveryMode.deliveryModeId = "TestDeliveryModeId"
        deliveryMode.deliveryModeName = "TestDeliveryModeName"
        
        let pilDeliveryMode = ECSPILDeliveryMode()
        pilDeliveryMode.deliveryModeId = "TestDeliveryModeId"
        pilDeliveryMode.deliveryModeName = "TestDeliveryModeName"
        
        let shoppingCart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        shoppingCart.data = data
        shoppingCart.data?.cartID = "TestCartID"
        shoppingCart.data?.attributes?.deliveryMode = pilDeliveryMode
        
        mockECSService?.shoppingCart = shoppingCart
        mockECSService?.setDeliveryModeStatus = true
        
        deliveryDetailsPresenter.setDeliveryMode(deliveryMode: deliveryMode) { [weak self] (error) in
            XCTAssertNotNil(self?.deliveryDetailsPresenter.dataBus?.shoppingCart)
            XCTAssertNotNil(self?.deliveryDetailsPresenter.dataBus?.shoppingCart?.data?.attributes?.deliveryMode)
            XCTAssertEqual(self?.deliveryDetailsPresenter.dataBus?.shoppingCart?.data?.cartID, "TestCartID")
            XCTAssertEqual(self?.deliveryDetailsPresenter.dataBus?.shoppingCart?.data?.attributes?.deliveryMode?.deliveryModeId, "TestDeliveryModeId")
        }
    }
    
    func testSetDeliveryModeOAuthFailure() {
        let deliveryMode = ECSDeliveryMode()
        deliveryMode.deliveryModeId = "TestDeliveryModeId"
        deliveryMode.deliveryModeName = "TestDeliveryModeName"
        
        let pilDeliveryMode = ECSPILDeliveryMode()
        pilDeliveryMode.deliveryModeId = "TestDeliveryModeId"
        pilDeliveryMode.deliveryModeName = "TestDeliveryModeName"
        
        let shoppingCart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        shoppingCart.data = data
        shoppingCart.data?.cartID = "TestCartID"
        shoppingCart.data?.attributes?.deliveryMode = pilDeliveryMode
        
        mockECSService?.shoppingCart = shoppingCart
        mockECSService?.setDeliveryModeStatus = true
        mockECSService?.shouldSendOauthError = true
        
        deliveryDetailsPresenter.setDeliveryMode(deliveryMode: deliveryMode) { [weak self] (error) in
            XCTAssertNotNil(self?.deliveryDetailsPresenter.dataBus?.shoppingCart)
            XCTAssertNotNil(self?.deliveryDetailsPresenter.dataBus?.shoppingCart?.data?.attributes?.deliveryMode)
            XCTAssertEqual(self?.deliveryDetailsPresenter.dataBus?.shoppingCart?.data?.cartID, "TestCartID")
            XCTAssertEqual(self?.deliveryDetailsPresenter.dataBus?.shoppingCart?.data?.attributes?.deliveryMode?.deliveryModeId, "TestDeliveryModeId")
        }
    }
    
    func testSetDeliveryModeFailure() {
        let deliveryMode = ECSDeliveryMode()
        deliveryMode.deliveryModeId = "TestDeliveryModeId"
        deliveryMode.deliveryModeName = "TestDeliveryModeName"
        
        let pilDeliveryMode = ECSPILDeliveryMode()
        deliveryMode.deliveryModeId = "TestDeliveryModeId"
        deliveryMode.deliveryModeName = "TestDeliveryModeName"
        
        let shoppingCart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        shoppingCart.data = data
        shoppingCart.data?.cartID = "TestCartID"
        shoppingCart.data?.attributes?.deliveryMode = pilDeliveryMode
        
        mockECSService?.shoppingCart = shoppingCart
        mockECSService?.setDeliveryModeError = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey: "Set delivery mode failed"])
        
        deliveryDetailsPresenter.setDeliveryMode(deliveryMode: deliveryMode) { [weak self] (error) in
            XCTAssertNil(self?.deliveryDetailsPresenter.dataBus?.shoppingCart)
            XCTAssertNil(self?.deliveryDetailsPresenter.dataBus?.shoppingCart?.data?.attributes?.deliveryMode)
            XCTAssertEqual(self?.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self?.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:setDeliveryMode:Hybris:Set delivery mode failed:123")
        }
    }
    
    func testSetDeliveryModeFailureDoesnotAffectCartValues() {
        let deliveryMode = ECSDeliveryMode()
        deliveryMode.deliveryModeId = "TestDeliveryModeId"
        deliveryMode.deliveryModeName = "TestDeliveryModeName"
        
        let shoppingCart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        shoppingCart.data = data
        shoppingCart.data?.cartID = "TestCartID"
        
        deliveryDetailsPresenter.dataBus?.shoppingCart = shoppingCart
        mockECSService?.setDeliveryModeError = NSError(domain: "", code: 123, userInfo: nil)
        
        deliveryDetailsPresenter.setDeliveryMode(deliveryMode: deliveryMode) { [weak self] (error) in
            XCTAssertNotNil(self?.deliveryDetailsPresenter.dataBus?.shoppingCart)
            XCTAssertEqual(self?.deliveryDetailsPresenter.dataBus?.shoppingCart?.data?.cartID, "TestCartID")
            XCTAssertNil(self?.deliveryDetailsPresenter.dataBus?.shoppingCart?.data?.attributes?.deliveryMode)
        }
    }
    
    func testSetDeliveryModeFailureDoesnotAffectCartDeliveryModeValues() {
        let deliveryMode = ECSDeliveryMode()
        deliveryMode.deliveryModeId = "TestDeliveryModeId"
        deliveryMode.deliveryModeName = "TestDeliveryModeName"
        
        let pilDeliveryMode = ECSPILDeliveryMode()
        pilDeliveryMode.deliveryModeId = "TestDeliveryModeId"
        pilDeliveryMode.deliveryModeName = "TestDeliveryModeName"
        
        let oldDeliveryMode = ECSPILDeliveryMode()
        oldDeliveryMode.deliveryModeId = "TestOldDeliveryModeId"
        oldDeliveryMode.deliveryModeName = "TestOldDeliveryModeName"
        
        let oldShoppingCart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        oldShoppingCart.data = data
        oldShoppingCart.data?.cartID = "TestOldCartID"
        oldShoppingCart.data?.attributes?.deliveryMode = oldDeliveryMode
        
        let newShoppingCart = ECSPILShoppingCart()
        let newData = ECSPILDataClass()
        let newAttributes = ECSPILCartAttributes()
        newData.attributes = newAttributes
        newShoppingCart.data = newData
        newShoppingCart.data?.cartID = "TestNewCartID"
        newShoppingCart.data?.attributes?.deliveryMode = pilDeliveryMode
        
        deliveryDetailsPresenter.dataBus?.shoppingCart = oldShoppingCart
        mockECSService?.shoppingCart = newShoppingCart
        mockECSService?.setDeliveryModeError = NSError(domain: "", code: 123, userInfo: nil)
        
        deliveryDetailsPresenter.setDeliveryMode(deliveryMode: deliveryMode) { [weak self] (error) in
            XCTAssertNotNil(self?.deliveryDetailsPresenter.dataBus?.shoppingCart)
            XCTAssertEqual(self?.deliveryDetailsPresenter.dataBus?.shoppingCart?.data?.cartID, "TestOldCartID")
            XCTAssertNotNil(self?.deliveryDetailsPresenter.dataBus?.shoppingCart?.data?.attributes?.deliveryMode)
            XCTAssertEqual(self?.deliveryDetailsPresenter.dataBus?.shoppingCart?.data?.attributes?.deliveryMode?.deliveryModeName, "TestOldDeliveryModeName")
            XCTAssertEqual(self?.deliveryDetailsPresenter.dataBus?.shoppingCart?.data?.attributes?.deliveryMode?.deliveryModeId, "TestOldDeliveryModeId")
        }
    }
    
    func testSetDeliveryModeSuccessAffectCartDeliveryModeValues() {
        let deliveryMode = ECSDeliveryMode()
        deliveryMode.deliveryModeId = "TestDeliveryModeId"
        deliveryMode.deliveryModeName = "TestDeliveryModeName"
        
        let pilDeliveryMode = ECSPILDeliveryMode()
        pilDeliveryMode.deliveryModeId = "TestDeliveryModeId"
        pilDeliveryMode.deliveryModeName = "TestDeliveryModeName"
        
        let oldDeliveryMode = ECSPILDeliveryMode()
        oldDeliveryMode.deliveryModeId = "TestOldDeliveryModeId"
        oldDeliveryMode.deliveryModeName = "TestOldDeliveryModeName"
        
        let oldShoppingCart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        oldShoppingCart.data = data
        oldShoppingCart.data?.cartID = "TestOldCartID"
        oldShoppingCart.data?.attributes?.deliveryMode = oldDeliveryMode
        
        let newShoppingCart = ECSPILShoppingCart()
        let newData = ECSPILDataClass()
        let newAttributes = ECSPILCartAttributes()
        newData.attributes = newAttributes
        newShoppingCart.data = newData
        newShoppingCart.data?.cartID = "TestNewCartID"
        newShoppingCart.data?.attributes?.deliveryMode = pilDeliveryMode
        
        deliveryDetailsPresenter.dataBus?.shoppingCart = oldShoppingCart
        mockECSService?.shoppingCart = newShoppingCart
        
        deliveryDetailsPresenter.setDeliveryMode(deliveryMode: deliveryMode) { [weak self] (error) in
            XCTAssertNotNil(self?.deliveryDetailsPresenter.dataBus?.shoppingCart)
            XCTAssertEqual(self?.deliveryDetailsPresenter.dataBus?.shoppingCart?.data?.cartID, "TestNewCartID")
            XCTAssertNotNil(self?.deliveryDetailsPresenter.dataBus?.shoppingCart?.data?.attributes?.deliveryMode)
            XCTAssertEqual(self?.deliveryDetailsPresenter.dataBus?.shoppingCart?.data?.attributes?.deliveryMode?.deliveryModeName, "TestDeliveryModeName")
            XCTAssertEqual(self?.deliveryDetailsPresenter.dataBus?.shoppingCart?.data?.attributes?.deliveryMode?.deliveryModeId, "TestDeliveryModeId")
        }
    }
    
    func testSetDeliveryModeFetchCartFailureDoesnotAffectOldValues() {
        let deliveryMode = ECSDeliveryMode()
        deliveryMode.deliveryModeId = "TestDeliveryModeId"
        deliveryMode.deliveryModeName = "TestDeliveryModeName"
        
        let newPilDeliveryMode = ECSPILDeliveryMode()
        newPilDeliveryMode.deliveryModeId = "TestDeliveryModeId"
        newPilDeliveryMode.deliveryModeName = "TestDeliveryModeName"
        
        let oldDeliveryMode = ECSPILDeliveryMode()
        oldDeliveryMode.deliveryModeId = "TestOldDeliveryModeId"
        oldDeliveryMode.deliveryModeName = "TestOldDeliveryModeName"
        
        let oldShoppingCart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        oldShoppingCart.data = data
        oldShoppingCart.data?.cartID = "TestOldCartID"
        oldShoppingCart.data?.attributes?.deliveryMode = oldDeliveryMode
        
        let newShoppingCart = ECSPILShoppingCart()
        let newAttributes = ECSPILCartAttributes()
        let newData = ECSPILDataClass()
        newData.attributes = newAttributes
        newShoppingCart.data = newData
        newShoppingCart.data?.cartID = "TestNewCartID"
        newShoppingCart.data?.attributes?.deliveryMode = newPilDeliveryMode
        
        deliveryDetailsPresenter.dataBus?.shoppingCart = oldShoppingCart
        mockECSService?.shoppingCartError = NSError(domain: "", code: 123, userInfo: nil)
        
        deliveryDetailsPresenter.setDeliveryMode(deliveryMode: deliveryMode) { [weak self] (error) in
            XCTAssertNotNil(self?.deliveryDetailsPresenter.dataBus?.shoppingCart)
            XCTAssertEqual(self?.deliveryDetailsPresenter.dataBus?.shoppingCart?.data?.cartID, "TestOldCartID")
            XCTAssertNotNil(self?.deliveryDetailsPresenter.dataBus?.shoppingCart?.data?.attributes?.deliveryMode)
            XCTAssertEqual(self?.deliveryDetailsPresenter.dataBus?.shoppingCart?.data?.attributes?.deliveryMode?.deliveryModeName, "TestOldDeliveryModeName")
            XCTAssertEqual(self?.deliveryDetailsPresenter.dataBus?.shoppingCart?.data?.attributes?.deliveryMode?.deliveryModeId, "TestOldDeliveryModeId")
        }
    }
    
    func testSetDeliveryModeFetchCartFailure() {
        let deliveryMode = ECSDeliveryMode()
        deliveryMode.deliveryModeId = "TestDeliveryModeId"
        deliveryMode.deliveryModeName = "TestDeliveryModeName"
        
        mockECSService?.shoppingCartError = NSError(domain: "", code: 123, userInfo: nil)
        
        deliveryDetailsPresenter.setDeliveryMode(deliveryMode: deliveryMode) { [weak self] (error) in
            XCTAssertNil(self?.deliveryDetailsPresenter.dataBus?.shoppingCart)
            XCTAssertNil(error)
        }
    }
    
    func testFetchNumberOfDeliveryModes() {
        let deliveryMode1 = ECSDeliveryMode()
        deliveryMode1.deliveryModeName = "DeliveryModeName1"
        deliveryMode1.deliveryModeId = "DeliveryModeID1"
        
        let deliveryMode2 = ECSDeliveryMode()
        deliveryMode2.deliveryModeName = "DeliveryModeName2"
        deliveryMode2.deliveryModeId = "DeliveryModeID2"
        
        let deliveryMode3 = ECSDeliveryMode()
        deliveryMode3.deliveryModeName = "DeliveryModeName3"
        deliveryMode3.deliveryModeId = "DeliveryModeID3"
        
        let deliveryMode4 = ECSDeliveryMode()
        deliveryMode4.deliveryModeName = "DeliveryModeName4"
        deliveryMode4.deliveryModeId = "DeliveryModeID4"
        
        deliveryDetailsPresenter.fetchedDeliveryModes = [deliveryMode1, deliveryMode2, deliveryMode3, deliveryMode4]
        
        XCTAssertEqual(deliveryDetailsPresenter.fetchNumberOfDeliveryModes(), 4)
        
        deliveryDetailsPresenter.fetchedDeliveryModes = []
        
        XCTAssertEqual(deliveryDetailsPresenter.fetchNumberOfDeliveryModes(), 0)
        
        deliveryDetailsPresenter.fetchedDeliveryModes = nil
        
        XCTAssertEqual(deliveryDetailsPresenter.fetchNumberOfDeliveryModes(), 0)
    }
    
    func testSetCurrentSelectedDeliveryMode() {
        let deliveryMode1 = ECSDeliveryMode()
        deliveryMode1.deliveryModeName = "DeliveryModeName1"
        deliveryMode1.deliveryModeId = "DeliveryModeID1"
        
        let deliveryMode2 = ECSDeliveryMode()
        deliveryMode2.deliveryModeName = "DeliveryModeName2"
        deliveryMode2.deliveryModeId = "DeliveryModeID2"
        
        let pilDeliveryMode2 = ECSPILDeliveryMode()
        pilDeliveryMode2.deliveryModeName = "DeliveryModeName2"
        pilDeliveryMode2.deliveryModeId = "DeliveryModeID2"
        
        let deliveryMode3 = ECSDeliveryMode()
        deliveryMode3.deliveryModeName = "DeliveryModeName3"
        deliveryMode3.deliveryModeId = "DeliveryModeID3"
        
        let pilDeliveryMode3 = ECSPILDeliveryMode()
        pilDeliveryMode3.deliveryModeName = "DeliveryModeName3"
        pilDeliveryMode3.deliveryModeId = "DeliveryModeID3"
        
        let deliveryMode4 = ECSDeliveryMode()
        deliveryMode4.deliveryModeName = "DeliveryModeName4"
        deliveryMode4.deliveryModeId = "DeliveryModeID4"
        
        let deliveryMode5 = ECSDeliveryMode()
        deliveryMode5.deliveryModeName = "DeliveryModeName3"
        deliveryMode5.deliveryModeId = "DeliveryModeName3"
        
        let shoppingCart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        shoppingCart.data = data
        shoppingCart.data?.cartID = "TestCartID"
        shoppingCart.data?.attributes?.deliveryMode = pilDeliveryMode3
        
        deliveryDetailsPresenter.fetchedDeliveryModes = [deliveryMode1, deliveryMode2, deliveryMode3, deliveryMode4]
        deliveryDetailsPresenter.dataBus?.shoppingCart = shoppingCart
        deliveryDetailsPresenter.setCurrentSelectedDeliveryMode()
        
        XCTAssertEqual(deliveryDetailsPresenter.currentDeliveryMode?.deliveryModeId, pilDeliveryMode3.deliveryModeId)
        XCTAssertEqual(deliveryDetailsPresenter.currentDeliveryMode?.deliveryModeName, "DeliveryModeName3")
        
        deliveryDetailsPresenter.fetchedDeliveryModes = [deliveryMode1, deliveryMode2, deliveryMode4]
        deliveryDetailsPresenter.setCurrentSelectedDeliveryMode()
        XCTAssertNil(deliveryDetailsPresenter.currentDeliveryMode)
        
        deliveryDetailsPresenter.fetchedDeliveryModes = [deliveryMode1, deliveryMode2, deliveryMode4]
        shoppingCart.data?.attributes?.deliveryMode = nil
        deliveryDetailsPresenter.setCurrentSelectedDeliveryMode()
        XCTAssertNil(deliveryDetailsPresenter.currentDeliveryMode)
        
        deliveryDetailsPresenter.fetchedDeliveryModes = []
        shoppingCart.data?.attributes?.deliveryMode = nil
        deliveryDetailsPresenter.setCurrentSelectedDeliveryMode()
        XCTAssertNil(deliveryDetailsPresenter.currentDeliveryMode)
        
        deliveryDetailsPresenter.fetchedDeliveryModes = nil
        shoppingCart.data?.attributes?.deliveryMode = nil
        deliveryDetailsPresenter.setCurrentSelectedDeliveryMode()
        XCTAssertNil(deliveryDetailsPresenter.currentDeliveryMode)
        
        deliveryDetailsPresenter.fetchedDeliveryModes = nil
        shoppingCart.data?.attributes?.deliveryMode = pilDeliveryMode2
        deliveryDetailsPresenter.setCurrentSelectedDeliveryMode()
        XCTAssertNil(deliveryDetailsPresenter.currentDeliveryMode)
        
        deliveryDetailsPresenter.fetchedDeliveryModes = [deliveryMode2, deliveryMode3, deliveryMode5]
        shoppingCart.data?.attributes?.deliveryMode = pilDeliveryMode3
        deliveryDetailsPresenter.setCurrentSelectedDeliveryMode()
        XCTAssertEqual(deliveryDetailsPresenter.currentDeliveryMode?.deliveryModeId, pilDeliveryMode3.deliveryModeId)
        XCTAssertEqual(deliveryDetailsPresenter.currentDeliveryMode?.deliveryModeName, "DeliveryModeName3")
    }
    
    func testConstructDeliveryModeDetails() {
        let deliveryMode = ECSDeliveryMode()
        var deliveryCost: ECSPrice? = ECSPrice()
        deliveryMode.deliveryModeDescription = "TestDeliveryModeDescription"
        deliveryCost?.formattedValue = "TestPrice"
        deliveryMode.deliveryCost = deliveryCost
        
        XCTAssertEqual(deliveryMode.constructDeliveryModeDetails(), "TestPrice | TestDeliveryModeDescription")
        
        deliveryMode.deliveryModeDescription = ""
        XCTAssertEqual(deliveryMode.constructDeliveryModeDetails(), "TestPrice")
        
        deliveryMode.deliveryModeDescription = "TestDeliveryModeDescription"
        deliveryCost?.formattedValue = ""
        XCTAssertEqual(deliveryMode.constructDeliveryModeDetails(), "TestDeliveryModeDescription")
        
        deliveryMode.deliveryModeDescription = ""
        deliveryCost?.formattedValue = ""
        XCTAssertEqual(deliveryMode.constructDeliveryModeDetails(), "")
        
        deliveryMode.deliveryModeDescription = nil
        deliveryCost?.formattedValue = nil
        XCTAssertEqual(deliveryMode.constructDeliveryModeDetails(), "")
        
        deliveryCost = nil
        XCTAssertEqual(deliveryMode.constructDeliveryModeDetails(), "")
        
    }
}
