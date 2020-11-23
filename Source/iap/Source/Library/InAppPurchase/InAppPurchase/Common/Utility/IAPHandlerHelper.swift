/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra

class IAPProductInfoHelper {
    fileprivate(set) var productModels: [IAPProductModel]!
    fileprivate var paginationModel: IAPPaginationModel!
    fileprivate let requestDispathQueue = DispatchQueue(label: "IAPProductDetailQueue", attributes: [])
    
    init () {
        productModels = [IAPProductModel]()
    }
    
    // MARK: -
    // MARK: Methods for downloading information of particular products
    // MARK: -
    fileprivate func fetchInformation(_ forProducts: [String],
                                      completion: @escaping (_ withProducts: [IAPProductModel], _ failedProducts: [NSError])->()) {
        var collectionToBeReturned = [IAPProductModel]()
        var failedCTNs = [NSError]()
        
        self.requestDispathQueue.async { () -> Void in
            let downloadGroup = DispatchGroup()
            for ctn in forProducts {
                downloadGroup.enter()
                
                let cartInterfaceBuilder = IAPUtility.getCartInterfaceBuilder()
                let occInterface  = cartInterfaceBuilder.withProductCode(ctn).buildInterface()
                let httpInterface = occInterface.getInterfaceForFetchInformationForProduct(IAPOAuthConfigurationData.isDataLoadedFromHybris())
                occInterface.fetchInformationForProduct(httpInterface, completionHandler : { (withProduct) in
                    guard let productReturned = withProduct else { downloadGroup.leave(); return }
                    collectionToBeReturned.append(productReturned)
                    downloadGroup.leave()
                }, failureHandler: { (inError:NSError) in
                    failedCTNs.append(inError)
                    downloadGroup.leave()
                })
            }
            downloadGroup.notify(queue: DispatchQueue.main) {
                completion(collectionToBeReturned, failedCTNs)
            }
        }
    }
    
    fileprivate func provideFilteredModels(_ inCTNs: [String])->[IAPProductModel] {
        var filteredProductModels = [IAPProductModel]()
        for ctn in inCTNs {
            let objectsFound = self.productModels.filter({ $0.getProductCTN() == ctn})
            filteredProductModels.append(contentsOf: objectsFound)
        }
        return filteredProductModels
    }
    
    // MARK: -
    // MARK: Methods for downloading information of all products
    // MARK: -
    fileprivate func fetchNumberOfProducts(_ completion: @escaping (_ withProducts:[IAPProductModel])->(),
                                           failure: @escaping (NSError)->()) {
        let cartInterfaceBuilder = IAPUtility.getCartInterfaceBuilder()
        let occInterface  = cartInterfaceBuilder.withCurrentPage(IAPConstants.IAPPaginationStructure.kFirstPageIndex).buildInterface()
        let httpInterface = occInterface.getInterfaceForProductCatalogue(IAPOAuthConfigurationData.isDataLoadedFromHybris())
        weak var weakSelf = self
        occInterface.getProductCatalogue(httpInterface,
                   completionHandler: { (withProducts:[IAPProductModel], paginationDict: [String: AnyObject]?) -> () in
            if let dict = paginationDict {
                weakSelf?.paginationModel = IAPPaginationModel(inDict: dict)
            }
            weakSelf?.fetchAllProducts(completion, failure: failure)
        }) { (inError: NSError) -> () in
            failure(inError)
        }
    }
    
    fileprivate func fetchAllProducts(_ completion: @escaping (_ withProducts: [IAPProductModel])->() , failure: @escaping (NSError)->()) {
        guard IAPConfiguration.sharedInstance.isInternetReachable() else {
            failure(self.provideNoInternetError())
            return
        }
        weak var weakSelf = self
        let cartInterfaceBuilder = IAPUtility.getCartInterfaceBuilder()
        let occInterface  = cartInterfaceBuilder.withCurrentPage(IAPConstants.IAPPaginationStructure.kFirstPageIndex).buildInterface()
        let httpInterface = occInterface.getInterfaceForFetchAllProducts(IAPOAuthConfigurationData.isDataLoadedFromHybris())
        occInterface.fetchAllProducts(httpInterface,
                                      completionHandler: { (withProducts:[IAPProductModel],
                                        paginationDict: [String: AnyObject]?) -> () in
            weakSelf?.productModels = withProducts
            completion(withProducts)
        }) { (inError:NSError) -> () in
            failure(inError)
        }
    }
    
    // MARK: -
    // MARK: Methods for creating no internet error
    // MARK: -
    fileprivate func provideNoInternetError() -> NSError {
        let error = NSError(domain: NSURLErrorDomain, code: -1009,
                            userInfo:[NSLocalizedDescriptionKey:"The Internet connection appears to be offline."])
        return error
    }
}

extension IAPProductInfoHelper {
    func provideAllProductModels(_ completion: @escaping (_ withProducts:[IAPProductModel])->(),
                                 failure: @escaping (NSError)->()) {
        guard IAPConfiguration.sharedInstance.isInternetReachable() else {
            failure(self.provideNoInternetError());
            return
        }
        self.fetchNumberOfProducts(completion, failure: failure)
    }
    
    func fetchDetailsOfProducts(_ ctnList: [String],
                                completion: @escaping (_ withProducts:[IAPProductModel], _ failedProducts:[NSError])->(),
                                failure: @escaping (NSError)->()) {
        guard IAPConfiguration.sharedInstance.isInternetReachable() else {
            failure(self.provideNoInternetError());
            return
        }
        guard self.productModels.count == 0 else { completion(self.provideFilteredModels(ctnList), [NSError]()); return }
        guard IAPOAuthConfigurationData.isDataLoadedFromHybris() == true else {
            self.fetchInformation(ctnList, completion: completion)
            return
        }
        fetchInformation(ctnList, completion: completion)
    }
}
