/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import UIKit
import PhilipsEcommerceSDK

class ECSPILFetchAllProductsRequestHandler: NSObject, ECSTestRequestHandlerProtocol {
    var inputViewController: ECSTestMicroserviceInputsViewController?
    
    func getStocksFromString(stockString: String) -> Set<ECSPILStockLevel>? {
        let stockStringList = stockString.split(separator: ",")
        var stockList: Set<ECSPILStockLevel>?
        for stock in stockStringList {
            if let stockValue = ECSPILStockLevel(rawValue: String(stock)) {
                stockList?.insert(stockValue)
            }
        }
        return stockList
    }
    
    func numberOfPickerValues(picker: UIPickerView) -> Int {
        if picker.tag == ECSMicroServiceInputIndentifier.stockLevel.rawValue {
            return ECSPILStockLevel.allCases.count
        } else if picker.tag == ECSMicroServiceInputIndentifier.sortType.rawValue {
            return ECSPILSortType.allCases.count
        }
        return 0
    }
    
    func titleForPicker(picker: UIPickerView, row: Int) -> String {
        if picker.tag == ECSMicroServiceInputIndentifier.stockLevel.rawValue {
            return ECSPILStockLevel.allCases[row].rawValue
        } else if picker.tag == ECSMicroServiceInputIndentifier.sortType.rawValue {
            let stockLevel = ECSPILSortType.allCases[row]
            return stockLevel.rawValue
        }
        return ""
    }
    
    func didSelectRow(picker: UIPickerView, row: Int) {
        if picker.tag == ECSMicroServiceInputIndentifier.stockLevel.rawValue {
            let textField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.stockLevel.rawValue) as? UITextField
            let stockLevelValue = ECSPILStockLevel.allCases[row].rawValue
            if !(textField?.text?.contains(stockLevelValue) ?? true) {
                textField?.text = (textField?.text?.count ?? 0) > 0 ? textField?.text?.appending("," + stockLevelValue): textField?.text?.appending(stockLevelValue)
            }
        } else if picker.tag == ECSMicroServiceInputIndentifier.sortType.rawValue {
            let textField = inputViewController?.microserviceInputTableView.viewWithTag(ECSMicroServiceInputIndentifier.sortType.rawValue) as? UITextField
            textField?.text = ECSPILSortType.allCases[row].rawValue
        }
    }
    
    func shouldShowDefaultValue(textField: UITextField?) -> Bool {
        return (textField?.tag == ECSMicroServiceInputIndentifier.currentPage.rawValue ||
            textField?.tag == ECSMicroServiceInputIndentifier.pageSize.rawValue)
    }
    
    func populateDefaultValue(textField: UITextField?) {
        if textField?.tag == ECSMicroServiceInputIndentifier.currentPage.rawValue {
            textField?.text = "0"
        } else if textField?.tag == ECSMicroServiceInputIndentifier.pageSize.rawValue {
            textField?.text = "20"
        }
    }
    
    func textFieldString(tag: Int) -> String? {
        let text = (inputViewController?.microserviceInputTableView.viewWithTag(tag) as? UITextField)?.text
        return (text?.isEmpty ?? true) ? nil : text
    }
    
    func executeRequest() {
        let offset = Int(textFieldString(tag: ECSMicroServiceInputIndentifier.currentPage.rawValue) ?? "") ?? 0
        let limit = Int(textFieldString(tag: ECSMicroServiceInputIndentifier.pageSize.rawValue) ?? "") ?? 0
        let category = textFieldString(tag: ECSMicroServiceInputIndentifier.category.rawValue)

        
        let selectedSort = ECSPILSortType(rawValue: textFieldString(tag:ECSMicroServiceInputIndentifier.sortType.rawValue) ?? "")
        let selectedStock = getStocksFromString(stockString: textFieldString(tag:ECSMicroServiceInputIndentifier.stockLevel.rawValue) ?? "")
        
        var filter: ECSPILProductFilter?
        if selectedSort != nil || selectedStock != nil {
            filter = ECSPILProductFilter()
            filter?.sortType = selectedSort
            filter?.stockLevels = selectedStock
        }
        
        var responseData, errorData: String?
        
        ECSTestDemoConfiguration.sharedInstance.ecsServices?.fetchECSProducts(category: category,
                                                                              limit: limit,
                                                                              offset: offset,
                                                                              filterParameter: filter,
                                                                              completionHandler: { (products, error) in
            if let productList = products?.products {
                ECSTestMasterData.sharedInstance.pilProductList = productList
                
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                if let data = try? encoder.encode(products) {
                    responseData = String(data: data, encoding: .utf8)
                }
            }
            errorData = error?.fetchResponseErrorMessage()
            self.inputViewController?.pushResultView(responseData: responseData, responseError: errorData)
        })
    }
    
    func clearMicroserviceData() {
        ECSTestMasterData.sharedInstance.pilProductList = nil
    }
}
