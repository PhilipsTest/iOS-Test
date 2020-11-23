/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */
import Foundation

struct IAPCartTypeAliases {
    // cart related
    typealias CreateCartCompletionHandler       = (_ withObject: IAPCartInfo?) -> Void
    typealias GetCartsCompletionHandler         = (_ withObjects: [IAPCartInfo]) -> Void
    typealias CartDetailsCompletionHandler      = (_ inSuccess: Bool,_ withObject: IAPCartInfo?) -> Void
    typealias DeleteCartCompletionHandler       = (_ inSuccess: Bool) -> Void
    
    //voucher related
    typealias GetVoucherListCompletionHandler       = (_ withVoucher: IAPVoucherList) -> Void

    
    // product related
    typealias AddProductCompletionHandler       = (_ inSuccess:Bool) -> Void
    typealias ProductCatalogueCompletioHandler  = (_ withProducts:[IAPProductModel],
        _ paginationDict:[String: AnyObject]?) -> Void
    typealias ProductSearchCompletionHandler    = (_ withProduct:IAPProductModel?) -> Void
    
    // address related
    typealias GetAddressCompletionHandler       = (_ withAddress: IAPUserAddressInfo) -> Void
    typealias SetAddressCompletionHandler       = (_ withAddress: IAPUserAddress) -> Void
    typealias UpdateAddressCompletionHandler    = (_ inSuccess: Bool) ->()
    typealias DefaultAddressCompletionHandler   = (_ defaultAddress: IAPUserAddress?) -> Void
    typealias GetRegionCompletionHandler        = (_ regions: [String: AnyObject]) -> Void
    typealias CartFailureHandler                = (NSError) -> Void
    
    //Payment related
    typealias GetPaymentCompletionHandler   = (_ withPayments: IAPPaymentDetailsInfo) -> Void
    typealias MakePaymentCompletionHandler  = (_ withPayments: IAPMakePaymentInfo) -> Void
    typealias PlaceOrderCompletionHandler   = (_ withOrder: IAPOrderInfo) -> Void
    
    typealias SetPaymentDetailsCompletionHandler = (_ inSuccess: Bool) -> Void
    
    //delivery mode
    typealias SetDeliveryModeCompletionHandler    = (_ inSuccess: Bool) -> Void
    typealias GetDeliveryModeCompletionHandler    = (_ withDeliveryMode: IAPDeliveryModeDetails) -> Void
    
    //Purchase History
    typealias GetPurchaseHistoryCompletionHandler = (_ withOrders: IAPPurchaseHistoryCollection?,
        _ paginationDict: [String: AnyObject]?) -> Void
    typealias GetPurchaseHistoryOrderDetailsCompletionHandler = (_ withOrderDetail:IAPPurchaseHistoryModel) -> Void
    
    //default success and failure handler
    typealias DefaultSuccessHandler = (Bool) -> Void
    typealias DefaultFailureHandler = (NSError) -> Void
}

class IAPOCCBaseInterface {
    
    var userID: String!
    var cartID: String!

    // MARK:
    func getParameterDictForCartDownloads(_ oauthModel: IAPOAuthInfo) -> [String: String]? {
        var dictionaryToBeReturned = [String: String]()
        if let type = oauthModel.tokenType, let token = oauthModel.accessToken {
            dictionaryToBeReturned = [IAPConstants.IAPOCCHeader.kAuthorizationKey: String(format: "%@ %@",
                                                                                          arguments: [type,token])]
        }
        return dictionaryToBeReturned
    }
}
