/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import PhilipsEcommerceSDK
@testable import MobileEcommerceDev

class MECPaymentMethodTests: XCTestCase {
    
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
    
    func testFetchPaymentSuccess() {
        let firstPayment = ECSPayment()
        firstPayment.paymentId = "FirstTestID"
        
        let secondPayment = ECSPayment()
        secondPayment.paymentId = "SecondTestID"
        
        mockECSService?.savedPayments = [firstPayment, secondPayment]
        deliveryDetailsPresenter.fetchSavedPayments { (payments, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(self.deliveryDetailsPresenter.dataBus?.paymentsInfo)
            XCTAssertNotNil(self.deliveryDetailsPresenter.dataBus?.paymentsInfo?.fetchedPaymentMethods)
            XCTAssertEqual(self.deliveryDetailsPresenter.dataBus?.paymentsInfo?.fetchedPaymentMethods?.count, 2)
            XCTAssertEqual(self.deliveryDetailsPresenter.dataBus?.paymentsInfo?.isPaymentsDownloaded, true)
        }
    }
    
    func testFetchPaymentOAuthFailure() {
        let firstPayment = ECSPayment()
        firstPayment.paymentId = "FirstTestID"
        
        let secondPayment = ECSPayment()
        secondPayment.paymentId = "SecondTestID"
        
        mockECSService?.savedPayments = [firstPayment, secondPayment]
        mockECSService?.shouldSendOauthError = true
        
        deliveryDetailsPresenter.fetchSavedPayments { (payments, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(self.deliveryDetailsPresenter.dataBus?.paymentsInfo)
            XCTAssertNotNil(self.deliveryDetailsPresenter.dataBus?.paymentsInfo?.fetchedPaymentMethods)
            XCTAssertEqual(self.deliveryDetailsPresenter.dataBus?.paymentsInfo?.fetchedPaymentMethods?.count, 2)
            XCTAssertEqual(self.deliveryDetailsPresenter.dataBus?.paymentsInfo?.isPaymentsDownloaded, true)
        }
    }
    
    func testFetchPaymentFailure() {
        let error = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey: "fetch saved payment failed"])
        mockECSService?.error = error
        deliveryDetailsPresenter.fetchSavedPayments { (payments, error) in
            XCTAssertNotNil(error)
            XCTAssertNotNil(self.deliveryDetailsPresenter.dataBus?.paymentsInfo)
            XCTAssertNotNil(self.deliveryDetailsPresenter.dataBus?.paymentsInfo?.fetchedPaymentMethods)
            XCTAssertEqual(self.deliveryDetailsPresenter.dataBus?.paymentsInfo?.fetchedPaymentMethods?.count, 0)
            XCTAssertEqual(self.deliveryDetailsPresenter.dataBus?.paymentsInfo?.isPaymentsDownloaded, true)
            
            XCTAssertEqual(self.mockTagging?.inParamDict?["Country"] as? String, "US")
            XCTAssertEqual(self.mockTagging?.inParamDict?["technicalError"] as? String, "MEC:fetchPaymentDetails:Hybris:fetch saved payment failed:123")
        }
    }
    
    func testDataBusPaymentInfoDefaultValue() {
        XCTAssertNotNil(deliveryDetailsPresenter.dataBus?.paymentsInfo)
        XCTAssertNotNil(deliveryDetailsPresenter.dataBus?.paymentsInfo?.fetchedPaymentMethods)
        XCTAssertEqual(deliveryDetailsPresenter.dataBus?.paymentsInfo?.fetchedPaymentMethods?.count, 0)
        XCTAssertNil(deliveryDetailsPresenter.dataBus?.paymentsInfo?.selectedPayment)
        XCTAssertEqual(deliveryDetailsPresenter.dataBus?.paymentsInfo?.isPaymentsDownloaded, false)
        
        deliveryDetailsPresenter.dataBus = nil
        XCTAssertNil(deliveryDetailsPresenter.dataBus?.paymentsInfo)
    }
    
    func testFetchPaymentFailureDoesnotOverrideOldValues() {
        let firstPayment = ECSPayment()
        firstPayment.paymentId = "FirstTestID"
        
        let secondPayment = ECSPayment()
        secondPayment.paymentId = "SecondTestID"
        
        let paymentInfo = MECPaymentsInfo()
        paymentInfo.fetchedPaymentMethods = [firstPayment, secondPayment]
        deliveryDetailsPresenter.dataBus?.paymentsInfo = paymentInfo
        
        let error = NSError(domain: "", code: 123, userInfo: nil)
        mockECSService?.error = error
        deliveryDetailsPresenter.fetchSavedPayments { (payments, error) in
            XCTAssertNotNil(error)
            XCTAssertNotNil(self.deliveryDetailsPresenter.dataBus?.paymentsInfo)
            XCTAssertNotNil(self.deliveryDetailsPresenter.dataBus?.paymentsInfo?.fetchedPaymentMethods)
            XCTAssertEqual(self.deliveryDetailsPresenter.dataBus?.paymentsInfo?.fetchedPaymentMethods?.count, 2)
            XCTAssertEqual(self.deliveryDetailsPresenter.dataBus?.paymentsInfo?.isPaymentsDownloaded, true)
        }
    }
    
    func testFetchNumberOfPayments() {
        let firstPayment = ECSPayment()
        firstPayment.paymentId = "FirstTestID"
        
        let secondPayment = ECSPayment()
        secondPayment.paymentId = "SecondTestID"
        
        let firstNewPayment = ECSPayment()
        firstNewPayment.paymentId = MECConstants.MECNewCardIdentifier
        
        let secondNewPayment = ECSPayment()
        secondNewPayment.paymentId = MECConstants.MECNewCardIdentifier
        
        let paymentInfo = MECPaymentsInfo()
        paymentInfo.fetchedPaymentMethods = [firstPayment, secondPayment]
        deliveryDetailsPresenter.dataBus?.paymentsInfo = paymentInfo
        
        XCTAssertEqual(deliveryDetailsPresenter.fetchNumberOfPayments(), 3)
        
        paymentInfo.fetchedPaymentMethods = []
        XCTAssertEqual(deliveryDetailsPresenter.fetchNumberOfPayments(), 1)
        
        paymentInfo.fetchedPaymentMethods = nil
        XCTAssertEqual(deliveryDetailsPresenter.fetchNumberOfPayments(), 1)
        
        paymentInfo.fetchedPaymentMethods = [firstPayment, secondPayment, firstNewPayment, secondNewPayment]
        XCTAssertEqual(deliveryDetailsPresenter.fetchNumberOfPayments(), 4)
    }
    
    func testConstructCardDetails() {
        let payment = ECSPayment()
        let card = ECSCardType()
        card.name = "CardName"
        card.type = "CardType"
        payment.card = card
        payment.cardNumber = "1234567890"
        
        XCTAssertEqual(payment.constructCardDetails(), "CardName 34567890")
        
        deliveryDetailsPresenter.dataBus?.paymentsInfo?.selectedPayment = payment
        XCTAssertEqual(deliveryDetailsPresenter.dataBus?.paymentsInfo?.selectedPayment?.constructCardDetails(), "CardName 34567890")
        
        deliveryDetailsPresenter.dataBus?.paymentsInfo?.selectedPayment = nil
        XCTAssertNil(deliveryDetailsPresenter.dataBus?.paymentsInfo?.selectedPayment?.constructCardDetails())
        
        payment.card = nil
        deliveryDetailsPresenter.dataBus?.paymentsInfo?.selectedPayment = payment
        XCTAssertEqual(deliveryDetailsPresenter.dataBus?.paymentsInfo?.selectedPayment?.constructCardDetails(), "34567890")
        
        payment.cardNumber = nil
        XCTAssertEqual(deliveryDetailsPresenter.dataBus?.paymentsInfo?.selectedPayment?.constructCardDetails(), "")
        
        card.name = ""
        payment.card = card
        payment.cardNumber = "1234567890"
        XCTAssertEqual(deliveryDetailsPresenter.dataBus?.paymentsInfo?.selectedPayment?.constructCardDetails(), "34567890")
        
        payment.cardNumber = ""
        XCTAssertEqual(deliveryDetailsPresenter.dataBus?.paymentsInfo?.selectedPayment?.constructCardDetails(), "")
        
        card.name = nil
        card.type = "CardType"
        payment.cardNumber = "1234567890"
        XCTAssertEqual(deliveryDetailsPresenter.dataBus?.paymentsInfo?.selectedPayment?.constructCardDetails(), "CardType 34567890")
        
        card.name = nil
        card.type = "CardType"
        payment.cardNumber = "123"
        XCTAssertEqual(deliveryDetailsPresenter.dataBus?.paymentsInfo?.selectedPayment?.constructCardDetails(), "CardType 123")
        
        payment.paymentId = MECConstants.MECNewCardIdentifier
        card.name = nil
        XCTAssertEqual(deliveryDetailsPresenter.dataBus?.paymentsInfo?.selectedPayment?.constructCardDetails(), "")
        
        card.name = ""
        XCTAssertEqual(deliveryDetailsPresenter.dataBus?.paymentsInfo?.selectedPayment?.constructCardDetails(), "")
        
        card.name = "NewCard"
        XCTAssertEqual(deliveryDetailsPresenter.dataBus?.paymentsInfo?.selectedPayment?.constructCardDetails(), "NewCard")
        
        card.name = nil
        card.type = "NewCardType"
        XCTAssertEqual(deliveryDetailsPresenter.dataBus?.paymentsInfo?.selectedPayment?.constructCardDetails(), "")
    }
    
    func testFetchCardNumber() {
        let payment = ECSPayment()
        payment.cardNumber = "1234567890"
        
        XCTAssertEqual(payment.fetchCardNumber(), "34567890")
        
        payment.cardNumber = "1"
        XCTAssertEqual(payment.fetchCardNumber(), "1")
        
        payment.cardNumber = ""
        XCTAssertEqual(payment.fetchCardNumber(), "")
        
        payment.cardNumber = nil
        XCTAssertEqual(payment.fetchCardNumber(), "")
    }
    
    func testConstructPaymentValidityDetails() {
        let validText = "Valid until"
        let payment = ECSPayment()
        payment.expiryMonth = "12"
        payment.expiryYear = "2020"
        
        XCTAssertEqual(payment.constructPaymentValidityDetails(), "\(validText) 12/2020")
        
        payment.expiryMonth = ""
        payment.expiryYear = ""
        XCTAssertEqual(payment.constructPaymentValidityDetails(), "")
        
        payment.expiryMonth = nil
        payment.expiryYear = nil
        XCTAssertEqual(payment.constructPaymentValidityDetails(), "")
        
        payment.expiryYear = "2020"
        XCTAssertEqual(payment.constructPaymentValidityDetails(), "\(validText) 2020")
        
        payment.expiryMonth = "12"
        payment.expiryYear = nil
        XCTAssertEqual(payment.constructPaymentValidityDetails(), "\(validText) 12")
    }
    
    func testIsNewPayment() {
        let payment = ECSPayment()
        payment.paymentId = MECConstants.MECNewCardIdentifier
        
        XCTAssertEqual(payment.isNewPayment(), true)
        
        payment.paymentId = ""
        XCTAssertEqual(payment.isNewPayment(), false)
        
        payment.paymentId = nil
        XCTAssertEqual(payment.isNewPayment(), false)
        
        payment.paymentId = "Old"
        XCTAssertEqual(payment.isNewPayment(), false)
        
        payment.paymentId = "mec_New_Card"
        XCTAssertEqual(payment.isNewPayment(), false)
    }
    
    func testFetchAccountHolderName() {
        let payment = ECSPayment()
        let address = ECSAddress()
        payment.billingAddress = address
        
        address.firstName = "Test First Name"
        address.lastName = "Test Last Name"
        payment.accountHolderName = "Test Holder"
        
        XCTAssertEqual(payment.fetchAccountHolderName(), "Test Holder")
        
        payment.accountHolderName = ""
        XCTAssertEqual(payment.fetchAccountHolderName(), "")
        
        payment.accountHolderName = nil
        XCTAssertEqual(payment.fetchAccountHolderName(), "Test First Name Test Last Name")
        
        address.firstName = nil
        XCTAssertEqual(payment.fetchAccountHolderName(), "Test Last Name")
        
        address.firstName = "Test First Name"
        address.lastName = nil
        XCTAssertEqual(payment.fetchAccountHolderName(), "Test First Name")
        
        address.firstName = ""
        address.lastName = ""
        XCTAssertEqual(payment.fetchAccountHolderName(), "")
        
        payment.accountHolderName = "Test Holder"
        address.firstName = nil
        address.lastName = nil
        XCTAssertEqual(payment.fetchAccountHolderName(), "Test Holder")
        
        payment.billingAddress = nil
        XCTAssertEqual(payment.fetchAccountHolderName(), "Test Holder")
        
        payment.accountHolderName = nil
        XCTAssertNil(payment.fetchAccountHolderName())
    }
}
