/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
@testable import MobileEcommerceDev
import PhilipsEcommerceSDK
import PhilipsUIKitDLS

class MECOrderDetailPaymentDataProviderTests: XCTestCase {
    var sut: MECOrderDetailPaymentDataProvider!
    
    override func setUp() {
        super.setUp()
        sut = MECOrderDetailPaymentDataProvider(with: ECSOrderDetail())
    }

    func testRegister() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        XCTAssertNotNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECCheckoutPaymentCell))
        XCTAssertNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECProductGridCell))
    }
    
    func testnumberOfRowsInSectionPaymentInfoNil() {
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 0)
    }
    
    func testnumberOfRowsInSectionPaymentInfoNotNil() {
        let orderDetail = ECSOrderDetail()
        orderDetail.paymentInfo = ECSPayment()
        sut = MECOrderDetailPaymentDataProvider(with: orderDetail)
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 1)
    }
    
    func testheightForHeaderInSectionPaymentInfoNil() {
        XCTAssertEqual(sut.tableView(UITableView(), heightForHeaderInSection: 0), 0)
    }
    
    func testheightForHeaderInSectionPaymentInfoNotNil() {
        let orderDetail = ECSOrderDetail()
        orderDetail.paymentInfo = ECSPayment()
        sut = MECOrderDetailPaymentDataProvider(with: orderDetail)
        XCTAssertEqual(sut.tableView(UITableView(), heightForHeaderInSection: 0), 40.0)
    }
    
    func testviewForHeaderInSection() {
        let view  = sut.tableView(UITableView(), viewForHeaderInSection: 0) as? UIDHeaderView
        XCTAssertNotNil(view)
        XCTAssertEqual(view?.headerLabel.text, MECLocalizedString("mec_payment_method"))
    }
    
    func testcellForRowAtPaymentInfoNil() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        XCTAssertNil(sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECCheckoutPaymentCell)
    }
    
    func testcellForRowAtPaymentInfoSavedPayment() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)

        let orderDetail = ECSOrderDetail()
        orderDetail.paymentInfo = getPaymentInfo()
        orderDetail.paymentInfo?.billingAddress = getBillingAddress()
        
        sut = MECOrderDetailPaymentDataProvider(with: orderDetail)
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECCheckoutPaymentCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.cardExpiryLabel.text, "Valid until 12/2021")
        XCTAssertEqual(cell?.cardNumberLabel.text, "Prasad ****1111")
        XCTAssertEqual(cell?.cardHolderNameLabel.text, "Prasad Devadiga")
        XCTAssertEqual(cell?.cardAddressLabel.text, "123, line1, \nnew town, \nTest region 12345, Test country")
    }
    
    func getPaymentInfo() -> ECSPayment {
        let payment = ECSPayment()
        payment.card = ECSCardType()
        payment.card?.type = "VISA"
        payment.card?.name = "Prasad"
        payment.expiryYear = "2021"
        payment.expiryMonth = "12"
        payment.cardNumber = "*********1111"
        return payment
    }
    
    func getBillingAddress() -> ECSAddress {
        let address = ECSAddress()
        address.addressID = "123445"
        address.firstName = "Prasad"
        address.lastName = "Devadiga"
        address.phone = "1234"
        address.phone1 = "1234"
        address.phone2 = "1234"
        address.postalCode = "12345"
        address.town = "new town"
        address.houseNumber = "123"
        address.line1 = "line1"
        address.region = ECSRegion()
        address.region?.name = "Test region"
        address.country = ECSCountry()
        address.country?.name = "Test country"
        
        return address
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
