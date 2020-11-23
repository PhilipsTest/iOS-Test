/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPConfigurationDataTests: XCTestCase {

   func testConfiguationModalInint() {
        
        let configData = Dictionary(dictionaryLiteral: ("catalogId", "US_PubProductCatalog"),
                                    ("faqUrl", "www.USFaqURL.com"),
                                    ("helpDeskEmail", "www.USHelpDeskMail.com"),
                                    ("helpDeskPhone", "www.USHelpDeskPhone.com"),
                                    ("helpUrl", "www.USHelpURL.com"),
                                    ("rootCategory", "Tuscany_Campaign"),
                                    ("siteId", "US_Tuscany"))
        let modelInfo = IAPConfigurationData(inDictionary: configData as NSDictionary)

        XCTAssertNotNil(modelInfo)
        XCTAssertNotNil(modelInfo.catalogId)
        XCTAssertNotNil(modelInfo.faqUrl)
        XCTAssertNotNil(modelInfo.helpDeskEmail)
        XCTAssertNotNil(modelInfo.helpDeskPhone)
        XCTAssertNotNil(modelInfo.helpUrl)
        XCTAssertNotNil(modelInfo.rootCategory)
        XCTAssertNotNil(modelInfo.siteId)

        XCTAssert(0 != modelInfo.catalogId?.length, "catalog length is 0")
        XCTAssert(0 != modelInfo.faqUrl?.length, "faqUrl length is 0")
        XCTAssert(0 != modelInfo.helpDeskEmail?.length, "helpDeskEmail length is not 0")
        XCTAssert(0 != modelInfo.helpDeskPhone?.length, "helpDeskPhone length is not 0")
        XCTAssert(0 != modelInfo.helpUrl?.length, "helpUrl length is not 0")
        XCTAssert(0 != modelInfo.rootCategory?.length, "rootCategory length is not 0")
        XCTAssert(0 != modelInfo.siteId?.length, "siteId length is not 0")
        
        let configDataWithNilSiteID = Dictionary(dictionaryLiteral: ("catalogId", "US_PubProductCatalog"),
                                                 ("faqUrl", "www.USFaqURL.com"),
                                                 ("helpDeskEmail", "www.USHelpDeskMail.com"),
                                                 ("helpDeskPhone", "www.USHelpDeskPhone.com"),
                                                 ("helpUrl", "www.USHelpURL.com"),
                                                 ("rootCategory", "Tuscany_Campaign"))
        let modelInfoWithNilSiteID = IAPConfigurationData(inDictionary: configDataWithNilSiteID as NSDictionary)
        XCTAssertNil(modelInfoWithNilSiteID.siteId,"Site ID isn't nil")
    }

}
