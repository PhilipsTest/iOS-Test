/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPOrderOverviewTests: XCTestCase {
    fileprivate var orders: IAPPurchaseHistoryCollection!
    fileprivate var ordersDataArray = [IAPPurchaseHistoryModel]()

    override func setUp() {
        super.setUp()
        let dictionary   = self.deserializeData("IAPOrderOverView")
        
        orders = IAPPurchaseHistoryCollection(inDictionary: dictionary!)
        ordersDataArray = (orders?.collection)!
    }
    
    func testExample() {
        
        XCTAssert(0 != ordersDataArray.count, "Orders aren't parsed correctly")
        XCTAssertNotNil(ordersDataArray.first?.getOrderID(), "Order ID is nil")
        XCTAssertNotNil(ordersDataArray.first?.getOrderPriceValue(), "Order price value is nil")
        XCTAssertNotNil(ordersDataArray.first?.getOrderPlacedDate(), "Order date is nil")
        XCTAssert(ordersDataArray.first?.getOrderStatus() == "PAYMENT_PROGRESS", "Status does not match")
        XCTAssertNotNil(ordersDataArray.first?.getOrderDisplayStatus(), "Display status is nil")
        
        let purchaseOrder = self.orders.collection.first
        XCTAssert(purchaseOrder?.products.count == 0, "Products is already initialised")

        let dictionary   = self.deserializeData("IAPOrderOverDetails")
        purchaseOrder?.initialiseOrderDetails(dictionary!)
        XCTAssertNotNil((purchaseOrder?.products.count)! >= 1, "Products is still not initialised")
        XCTAssertNotNil(purchaseOrder?.getCardType(), "Card type is nil")
        XCTAssertNotNil(purchaseOrder?.getCardNumber(), "Card number is nil")
        XCTAssertNotNil(purchaseOrder?.getOrderTrackURL(), "Tracking url is nil")
        XCTAssertNotNil(purchaseOrder?.getDeliveryStatus(), "Delivery status is nil")
        XCTAssertNotNil(purchaseOrder?.getDeliveryCost(), "Delivery cost is nil")
        XCTAssert(purchaseOrder?.getItemsCount() == 1, "Items count in not correct")
        
        let innerProduct = purchaseOrder?.products.first
        XCTAssertNotNil(innerProduct, "Nil has been returned")
        XCTAssert(innerProduct?.getProductTitle().length == 0, "Title is not returned properly")
        XCTAssertNotNil(purchaseOrder?.getDeliveryAddress(), "Delivery address is not set")
        XCTAssertNotNil(purchaseOrder?.getBillingAddress(), "Delivery address is not set")
        
        let lastOrder = self.orders.collection.last
        XCTAssert(lastOrder?.getOrderID() != purchaseOrder?.getOrderID(), "Order id's  are matching")
    }
    
    func testCategorisation() {
        let groupedOrders = self.orders.categoriseWithDisplayDate()
        XCTAssertNotNil(groupedOrders, "Orders aren't categorised")
        var indexOfCurrentObject = 0
        
        for orderCollection in groupedOrders {
            XCTAssertNotNil(orderCollection.orderDisplayDate, "Display date isn't initialised")
            
            guard indexOfCurrentObject < groupedOrders.count - 1 else { break }
            let nextCollection = groupedOrders[indexOfCurrentObject+1]
            XCTAssertNotNil(nextCollection.orderDisplayDate, "Display date isn't initialised")
            
            let firstDate = self.getDateForString(orderCollection.orderDisplayDate)
            let secondDate = self.getDateForString(nextCollection.orderDisplayDate)
            
            let result = firstDate.compare(secondDate)
            XCTAssert(result != .orderedAscending)
            indexOfCurrentObject += 1
        }
    }
    
    fileprivate func getDateForString(_ withString:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = IAPConstants.IAPPurchaseHistoryModelKeys.kOrderDateFormat
        
        let dateToReturn = dateFormatter.date(from: withString)
        return dateToReturn!
    }
}
