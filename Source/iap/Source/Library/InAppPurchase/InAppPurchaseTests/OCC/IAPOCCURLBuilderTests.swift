/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPOCCURLBuilderTests: XCTestCase {

    override func setUp() {
        super.setUp()
        IAPConfiguration.sharedInstance.baseURL = "https://www.occ.shop.philips.com"
        IAPConfiguration.sharedInstance.siteID = "US_Tuscany"
    }
    
/*
    func testOCCBuilderCreation() {
        let builder = IAPBaseURLBuilder()
        XCTAssertNotNil(builder,"Builder is not initialised")
        XCTAssert(builder.getBaseURL() == self.loadConfigurationInformation()!,"Url constructed is not proper")
    }
    
    func testOCCUserBuilderCreation() {
        let builder = IAPUserBuilder(inUserId: "12345")
        XCTAssertNotNil(builder,"Builder is not initialised")
        XCTAssert(builder.getUserBaseURL() == self.getUserLoadURL(),"User url created is not right")
        XCTAssert(builder.getUserID() == "12345","User id's are not matching")
        XCTAssert(builder.getUserDefaultAddressURL() == self.getUserDefaultURL(), "Default address url is not right")
    }
    
    func testOCCCartBuilderCreation() {
        let builder = IAPCartBuilder(cartID: "12345", userID: "12345")
        XCTAssertNotNil(builder,"Builder is not initialised")
        let value = builder.getCreateCartURL()
        let value1 = self.getCartCreateURL()
        XCTAssert(value == value1,"update url created is not right")
    }
    
    func testOCCAddProductCartCreation() {
        let builder = IAPCartBuilder(cartID: "12345", userID: "12345")
        XCTAssertNotNil(builder,"Builder is not initialised")
                
        let value = builder.getAddProductURL()
        let value1 = self.getAddProductURL()
        XCTAssert(value == value1,"product url created is not right")
    }
    
    func testOCCUpdateCartBuilderCreation() {
        let builder = IAPUpdateCartBuilder(inCartID: "12345", inUserID: "12345", inEntryNumber: 20)
        XCTAssertNotNil(builder,"Builder is not initialised")
        let value = builder.getUpdateCartURL()
        let value1 = self.getUpdateCartURL(20)
        XCTAssert(value == value1,"User url created is not right")
    }
    
    func testOCCDeleteCartURL() {
        let builder = IAPCartBuilder(cartID: "12345", userID: "12345")
        XCTAssertNotNil(builder,"Builder is not initialised")
        
        let value = builder.getCartDeleteURL()
        let value1 = self.getCartCreateURL() + "/" + "12345"
        XCTAssert(value == value1,"User url created is not right")
    }
    
    func testOCCGetCartDetailBuilderCreation() {
        let builder = IAPUpdateCartBuilder(inCartID: "12345", inUserID: "12345", inEntryNumber: 20)
        XCTAssertNotNil(builder,"Builder is not initialised")
        let value = builder.getCartEntryDetailURL()
        let value1 = self.getCartEntryDetailURL()
        XCTAssert(value == value1,"User url created is not right")
    }
    
    func testOCCAddressBuilderCreation() {
        let builder = IAPAddressBuilder(inUserID: "12345", inAddressID:"12345")
        XCTAssertNotNil(builder,"Builder is not initialised")
        XCTAssert(builder.getUserAddressesURL() == self.getAddressURL(),"Address url created is not right")
        XCTAssert(builder.getUpdateAddressURL() == self.getUpdateAddressURL("12345"), "Update Address url created is not right")
        XCTAssert(builder.getDeliveryAddressURL() == self.getDeliveryAddressURL("12345"), "Delivery address url created is not right")
    }
    */
    /*func testOCCProductBuilderCreation() {
        let builder = IAPProductBuilder(inProductCode: "12345")
        XCTAssertNotNil(builder,"Builder is not initialised")
        let urlCreated = builder.getProductSearchURL()
        let localURL = self.getProductSearchURL("12345") //.replaceCharacter("US_Tuscany", withCharacter: "")
        XCTAssert(urlCreated == localURL,"User url created is not right")
        
        let urlForProductCatalogue = builder.getProductCatalogueURL(123)
        let localURLForCatalogue = self.getProductCatalogueURL("123") //.replaceCharacter("US_Tuscany", withCharacter: "")
        XCTAssert(urlForProductCatalogue == localURLForCatalogue,"User url created is not right")
        
        let urlForAllDownload = builder.provideAllProductCatalogueURL(123)
        let localDownloadURL = self.getAllProductCatalogueURL("123") //.replaceCharacter("US_Tuscany", withCharacter: "")
        XCTAssert(urlForAllDownload == localDownloadURL,"User url created is not right")
    }*/
    
    /*func testOCCOrderBuilderCreation() {
        let builder = IAPOrderBuilder(userID: "12345")
        XCTAssertNotNil(builder,"Builder is not initialised")
        XCTAssert(builder.getOrderURL() == self.getOrderURL(),"Order url created is not right")
    }
    
    func testOCCPaymentBuilderCreation() {
        let builder = IAPPaymentBuilder(inOrderId: "12345", userID: "12345")
        XCTAssertNotNil(builder,"builder is not initialised")
        XCTAssert(builder.getMakePaymentURL() == self.getMakePaymentURl("12345"),"Make payment url is not right")
        XCTAssert(builder.getOrderId() == "12345", "OrderId does not match")
    }*/
    
    func testOCCPaymentDetailsCreation() {
        let builder = IAPUserBuilder(inUserId: "12345")
        XCTAssertNotNil(builder, "builder is not initialised")
        XCTAssertNotNil(builder.getUserPaymentDetailsURL() == self.getPaymentDetailsURL(),
                        "Payment details url is not right")
    }
    
    func testVoucherCreation() {
      let builder = IAPVoucherBuilder(cartID: "abs-KXL7-H3EW-C7EE", userID: "12345")
      XCTAssertNotNil(builder, "voucher builder is not initialised")
      XCTAssertNotNil(builder.getVoucherCode(), "voucher code is not nil")
    }
    
    func testOCCPurchaseHistoryURLCreation() {
        let builder = IAPUserBuilder(inUserId: "12345")
        XCTAssertNotNil(builder,"builder is not initialised")
        let url1 = builder.getPurchaseHistoryOverViewURLWithCurrentPage(0, withSortField: IAPConstants.IAPPurchaseHistoryModelKeys.kSortKey)
        let url2 = builder.getPurchaseHistoryOrderDetailURL("98765")
        let localURL1 = self.getOrderOverviewURL("12345", withCurrentPage: 0)
        let localURL2 = self.getDetailURLForOrder("12345", withOrderID: "98765")
        XCTAssert(url1 == localURL1, "Overview Url does not match" )
//        XCTAssert(url2 == localURL2, "Detail Url does not match")
    }
    /*
    func testVoucherURLBuilder() {
        let builder = IAPVoucherBuilder(inCartID: "current", inUserID: "12345", inVoucherCode: "abc")
        XCTAssertNotNil(builder, "Builder is not initialised")
        
        let applyVoucherURLFromBuilder = builder.getApplyVoucherCodeURL()
        let applyVoucherURLLocally = self.getApplyVoucherURL()
        XCTAssert(applyVoucherURLLocally == applyVoucherURLFromBuilder, "URL's returned are not matching")
        
        let releaseVoucherURLFromBuilder = builder.getReleaseVoucherCodeURL()
        let releaseVoucherURLLocally = self.getApplyVoucherURL() + "/" + "abc"
        XCTAssert(releaseVoucherURLLocally == releaseVoucherURLFromBuilder, "URL's returned are not matching")
    }
    */
    fileprivate func getApplyVoucherURL() -> String {
        return self.getCartCreateURL() + "/" + "current" + "/" + "vouchers"
    }
    
    fileprivate func getOrderOverviewURL(_ inUserID: String, withCurrentPage: Int) -> String {
        let value = self.loadConfigurationInformation()! + "/" + "users" + "/"
            + inUserID + "/" + IAPConstants.IAPPurchaseHistoryModelKeys.kOrders + "?currentPage="
            + "\(withCurrentPage)" + "&sort=byDate"
        return value
    }
    
    fileprivate func getDetailURLForOrder(_ withUserID: String, withOrderID: String) -> String {
        let value = self.loadConfigurationInformation()! + "/"
            + "users" + "/" + withUserID + "/"
            + IAPConstants.IAPPurchaseHistoryModelKeys.kOrders + "/"
            + withOrderID + "?"
            + IAPConstants.IAPUserBuilderKeys.kFieldsKey + "=" + IAPConstants.IAPUserBuilderKeys.kFullKey + "&lang=en"
        return value
    }
    
    fileprivate func getMakePaymentURl(_ inOrderId: String) -> String {
        let value = String(format: "%@/orders/%@/pay", arguments: [self.getUserLoadURL(), inOrderId])
        return value
    }
    
    fileprivate func getPaymentDetailsURL() -> String {
        return self.getUserLoadURL() + "/paymentdetails?fields=FULL"
    }
    
    fileprivate func getOrderURL() -> String {
        let value = String(format: "%@/orders", arguments: [self.getUserLoadURL()])
        return value
    }
    
    fileprivate func getDeliveryAddressURL(_ inString: String) -> String {
        return self.getCartCreateURL() + "/" + "current" + "/" + "addresses" + "/" + "delivery"
    }
    
    fileprivate func getUpdateAddressURL(_ inAddressID: String) -> String {
        return self.getBaseAddressURL() + "/" + inAddressID
    }
    
    fileprivate func getProductSearchURL(_ inProductCode: String) -> String {
        return self.loadConfigurationInformation()! + "/" + "products" + "/" + inProductCode
    }
    
    fileprivate func getProductSearchURLWithOutCode() -> String {
        return self.loadConfigurationInformation()! + "/" + "products" + "/" + "search" + "?" + "query" + "="
    }
    
    fileprivate func getProductCatalogueURL(_ withCurrentPage: String) -> String {
        return  self.getProductSearchURLWithOutCode() +
            "::category:Tuscany_Campaign" + "&" + "currentPage" + "=" + "\(withCurrentPage)" + "&lang=en"
    }
    
    fileprivate func getAllProductCatalogueURL(_ withPageSize: String) -> String {
        return  self.getProductSearchURLWithOutCode() + "::category:Tuscany_Campaign" + "&" + "pageSize" + "=" + "\(withPageSize)" + "&lang=en"
    }
    
    fileprivate func getAddressURL() -> String {
        return self.getBaseAddressURL() + "?" + "fields" + "=" + "FULL"
    }
    
    fileprivate func getBaseAddressURL() -> String {
        return self.getUserLoadURL() + "/" + "addresses"
    }

    fileprivate func getCartEntryDetailURL() -> String {
        let value = String(format: "%@/%@?fields=FULL", arguments: [self.getCartCreateURL(), "12345"])
        return value
    }
    
    fileprivate func getUpdateCartURL(_ inEntryNumber: Int) -> String {
        let value = String(format: "%@/%@", arguments: [self.getAddProductURL(), "\(inEntryNumber)"])
        return value
    }
    
    fileprivate func getAddProductURL() -> String {
        let value = String(format: "%@/%@/entries", arguments: [self.getCartCreateURL(), "12345"])
        return value
    }
    
    fileprivate func getCartCreateURL() -> String {
        let value = String(format: "%@/carts", arguments: [self.getUserLoadURL()])
        return value
    }
    
    fileprivate func getUserLoadURL() -> String {
        return String(format: "%@/users/%@", arguments: [self.loadConfigurationInformation()!, "12345"])
    }
    
    fileprivate func getUserDefaultURL() -> String {
        return self.getUserLoadURL()  + "?fields=FULL"
    }
    
    fileprivate func loadConfigurationInformation() -> String? {
        if let jsonDict = self.loadConfigurationJSONData() {
            return String (format: "%@://%@/%@/%@/%@",
                           arguments: [jsonDict["scheme"] as? String ?? "",
                                      "www.occ.shop.philips.com",
                                      jsonDict["webroot"] as? String ?? "",
                                      jsonDict["version"] as? String ?? "",
                                      jsonDict["site"] as? String ?? ""])
        }
        return nil
    }
    
    fileprivate func loadConfigurationJSONData() -> NSDictionary? {
        let bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "IAPTestConfiguration", ofType: "json") {
            if let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                do {
                    let jsonDict = try JSONSerialization.jsonObject(with: jsonData,
                                    options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: String]
                    return jsonDict as NSDictionary?
                } catch let error as NSError {
                    print("Data conversion error::: \(error.localizedDescription)")
                }
            }
        }
        return nil
    }
}
