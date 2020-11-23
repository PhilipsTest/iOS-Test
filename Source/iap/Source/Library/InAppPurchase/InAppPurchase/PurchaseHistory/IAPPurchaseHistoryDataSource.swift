/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPPurchaseHistoryDataSource {
    var paginationModel: IAPPaginationModel!
    fileprivate let requestDispathQueue = DispatchQueue(label: "IAPPurchaseHistoryOrderDetailQueue", attributes: [])
    fileprivate func getDetailsOfOrders(_ inCollection: [IAPPurchaseHistoryModel],
                                        completion: @escaping ( [IAPPurchaseHistoryModel]) -> Void) {
        var collectionToBeReturned = [IAPPurchaseHistoryModel]()
        self.requestDispathQueue.async { () -> Void in
            let downloadGroup = DispatchGroup()
            
            for orderModel in inCollection {
                downloadGroup.enter()
                
                let addressInterfaceBuilder = IAPUtility.getAddressInterfaceBuilder()
                let occInterface = addressInterfaceBuilder.withPurchaseHistory(orderModel).buildPurchaseHistoryInterface()
                let httpInterface = occInterface.getInterfaceForPurchaseHistoryOrderDetails()
                occInterface.getPurchaseHistoryOrderDetails(httpInterface, completionHandler: { (withDetails) in
                    collectionToBeReturned.append(withDetails)
                    downloadGroup.leave()
                    }, failureHandler: { (inError: NSError) in
                        downloadGroup.leave()
                })
            }
            
            downloadGroup.notify(queue: DispatchQueue.main) {
                completion(collectionToBeReturned)
            }
        }
    }

    func getPurchaseHistoryForPage(
        _ currentPage: Int, withPreviousObjects: [IAPPurcahseHistorySortedCollection],
        completion: @escaping IAPConstants.IAPPurchaseHistoryCompletionHandlers.GetPurchaseHistoryFetchHandler,
        failureHandler: @escaping IAPConstants.IAPPurchaseHistoryCompletionHandlers.PurchaseHistoryFailureHandler) {
        
        let addressInterfaceBuilder = IAPUtility.getAddressInterfaceBuilder()
        let passedObjects   = [IAPPurcahseHistorySortedCollection]() + withPreviousObjects
        let occInterface    = addressInterfaceBuilder.withPurchaseHistoryCurrentPage(currentPage).buildPurchaseHistoryInterface()
        let httpInterface = occInterface.getInterfaceForPurchaseHistoryOverview()
        
        // Fetch overview of purchase history
        occInterface.getPurchaseHistoryOverview(httpInterface, completionHandler : { (withOrders, paginationDict) in
            if let dict = paginationDict {
                self.paginationModel = IAPPaginationModel(inDict: dict)
            }
            
            guard withOrders?.collection != nil else {
                completion([IAPPurcahseHistorySortedCollection](), nil); return }
            
            // Fetch the details of each prder
            self.getDetailsOfOrders((withOrders?.collection)!, completion: { (inCollection: [IAPPurchaseHistoryModel]) in
                let arrayOfProductsToDownload = self.filterProductsToBeDownloaded(inCollection)
                IAPPRXDataDownloader().getProductInformationFromPRX(arrayOfProductsToDownload,
                                                                    completion: { (withProducts:[IAPProductModel]) in
                    self.updateModelCollection(inCollection, withProducts: withProducts)
                    DispatchQueue.main.async(execute: {
                        let currentFetchedObjects = self.mergeModelCollections((withOrders?.categoriseWithDisplayDate())!, oldCollection: passedObjects)
                        completion(currentFetchedObjects, self.paginationModel)
                    })
                })
            } )
        }) { (inError: NSError) in
            failureHandler(inError)
        }
    }
    
    fileprivate func mergeModelCollections(_
        collectionToBeMerged: [IAPPurcahseHistorySortedCollection] = [IAPPurcahseHistorySortedCollection](),
        oldCollection: [IAPPurcahseHistorySortedCollection] = [IAPPurcahseHistorySortedCollection]() ) -> [IAPPurcahseHistorySortedCollection] {
        guard oldCollection.count > 0 else { return collectionToBeMerged }
        guard collectionToBeMerged.count > 0 else { return oldCollection }
        
        var objectsToBeReturned = [IAPPurcahseHistorySortedCollection]() + oldCollection
        let lastObject = objectsToBeReturned.last
        let firstObject = collectionToBeMerged.first
        guard lastObject?.orderDisplayDate == firstObject?.orderDisplayDate else { objectsToBeReturned.append(contentsOf: collectionToBeMerged)
            return objectsToBeReturned
        }
        
        lastObject!.collection.append(contentsOf: firstObject!.collection)
        var contentsToBeAdded = collectionToBeMerged
        contentsToBeAdded.removeFirst()
        objectsToBeReturned.append(contentsOf: contentsToBeAdded)
        return objectsToBeReturned
    }
    
    fileprivate func filterProductsToBeDownloaded(_ inCollection: [IAPPurchaseHistoryModel]) -> [IAPProductModel] {
        var arrayOfProducts = [IAPProductModel]()
        for orderModel in inCollection {
            for product in orderModel.products {
                let objectAlreadyAdded = arrayOfProducts.filter{($0.getProductCTN() == product.getProductCTN())}
                guard objectAlreadyAdded.count == 0 else { continue }
                arrayOfProducts.append(product)
            }
        }
        return arrayOfProducts
    }
    
    @discardableResult
    fileprivate func updateModelCollection(_ inCollection: [IAPPurchaseHistoryModel],
                                           withProducts:[IAPProductModel]) -> [IAPPurchaseHistoryModel] {
        var arrayOfCollections = [IAPPurchaseHistoryModel]()
        for orderModel in inCollection {
            var productsToBeUsed = [IAPProductModel]()
            for product in orderModel.products {
                let objectToBeUsed = withProducts.filter{($0.getProductCTN() == product.getProductCTN())}.first
                guard objectToBeUsed != nil else { continue }
                
                product.setProductTitle(objectToBeUsed!.getProductTitle())
                product.setProductDescription(objectToBeUsed!.getProductDescription())
                product.setThumbnailImageURL(objectToBeUsed!.getProductThumbnailImageURL())
                product.setProductSubCategory(objectToBeUsed!.getSubCategory())
                productsToBeUsed.append(product)
            }
            
            orderModel.products = productsToBeUsed
            guard productsToBeUsed.count > 0 else { continue }
            arrayOfCollections.append(orderModel)
        }
        return arrayOfCollections
    }
}
