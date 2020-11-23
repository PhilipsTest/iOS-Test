/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPPurchaseHistoryCollection {
    var collection: [IAPPurchaseHistoryModel] = [IAPPurchaseHistoryModel]()
    init? (inDictionary: [String: AnyObject]) {
        guard let orders = inDictionary[IAPConstants.IAPPurchaseHistoryModelKeys.kOrders] as? [[String: AnyObject]] else { return nil }
        
        for orderDict in orders {
            guard let orderCreated = IAPPurchaseHistoryModel(inDictionary:orderDict) else { continue }
            self.collection.append(orderCreated)
        }
    }
}


extension IAPPurchaseHistoryCollection {
    
    func categoriseWithDisplayDate () -> [IAPPurcahseHistorySortedCollection] {
        var array: [IAPPurcahseHistorySortedCollection] = [IAPPurcahseHistorySortedCollection]()
        for el in self.collection {
            let index = array.firstIndex { $0.orderDisplayDate == el.orderDisplayDate }
            
            if index == nil {
                let objectToBeAdded = IAPPurcahseHistorySortedCollection()
                objectToBeAdded.collection = [IAPPurchaseHistoryModel]()
                objectToBeAdded.orderDisplayDate = el.orderDisplayDate
                objectToBeAdded.collection.append(el)
                array.append(objectToBeAdded)
            } else {
                let object = array[index!]
                object.collection.append(el)
            }
        }
        
        array = array.sorted(by: { (inCurrentElement, inNextElement) -> Bool in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = IAPConstants.IAPPurchaseHistoryModelKeys.kOrderDateFormat
            let dateOfCurrentElement = dateFormatter.date(from: inCurrentElement.orderDisplayDate)!
            let dateOfNextElement = dateFormatter.date(from: inNextElement.orderDisplayDate)!
            return ComparisonResult.orderedDescending == dateOfCurrentElement.compare(dateOfNextElement)
        })
        
        for item in array {
            item.collection = item.collection.sorted(by: {(inCurrentElement, inNextElement) -> Bool in
                return ComparisonResult.orderedDescending == inCurrentElement.getOrderPlacedDateValue().compare(inNextElement.getOrderPlacedDateValue() as Date)
            })
        }
        
        return array
    }
}

class IAPPurcahseHistorySortedCollection {
    var orderDisplayDate:String!
    var collection:[IAPPurchaseHistoryModel] = [IAPPurchaseHistoryModel]()
}

