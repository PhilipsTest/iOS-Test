/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsPRXClient

class IAPShoppingCartDataSource {
    fileprivate var cartSyncHelper: IAPCartSyncHelper = IAPCartSyncHelper()
    var product: IAPProductModel!
    var cartInfo: IAPCartInfo!
    var quantity: Int!
    
    func getCartInformation(_ currentObjects:[IAPProductModel]?,
                            success: @escaping (Bool, IAPCartInfo?, [IAPProductModel])->(),
                            failure: @escaping (NSError)->()) {
        
        self.cartSyncHelper.getCartDetails({ (inSuccess, withObject) -> () in
            guard let cartEntriesList = withObject?.entries else {
                success(inSuccess, nil, [IAPProductModel]())
                return
            }
            
            guard 0 == currentObjects?.count else {
                let currentProductModels = self.updateProductsWithModels(cartEntriesList, withModels:currentObjects!)
                success(inSuccess, withObject, currentProductModels)
                return
            }
            
            IAPPRXDataDownloader().getProductInformationFromPRX(cartEntriesList,
                                                                completion: { (responseList: [IAPProductModel]) -> () in
                                                                    success(inSuccess, withObject, responseList) })
        }) {(inError:NSError) in
            failure(inError)
        }
    }
    
    fileprivate func updateProductsWithModels(_ cartEntriesList: [IAPProductModel],
                                              withModels: [IAPProductModel]) -> [IAPProductModel] {
        let entriesToReturn = cartEntriesList
        for namedFoo in entriesToReturn {
            if let oldModel = withModels.filter({$0.getProductCTN() == namedFoo.getProductCTN()}).first {
                namedFoo.setProductTitle(oldModel.getProductTitle())
                namedFoo.setProductDescription(oldModel.getProductDescription())
                namedFoo.setThumbnailImageURL(oldModel.getProductThumbnailImageURL())
            }
        }
        return entriesToReturn
    }
    
    func updateQuantity(_ success:@escaping (Bool)->(),failure:@escaping (NSError)->()) {
        self.cartSyncHelper.updateCart(inQuantity: quantity,
                                       inProductCode: self.product.getProductCTN(),
                                       inEntryNumber: self.product.getEntryNumber(),
                                       success: { (inSuccess:Bool) -> () in
            success(inSuccess)
        }) { (inError:NSError) -> () in
            failure(inError)
        }
    }
}
