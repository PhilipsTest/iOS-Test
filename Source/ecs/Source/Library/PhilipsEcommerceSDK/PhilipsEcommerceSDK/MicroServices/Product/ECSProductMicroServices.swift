/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsPRXClient

// MARK: - PIL Microservice methods
class ECSProductMicroServices: NSObject, ECSHybrisMicroService, ECSServiceDiscoveryURLDownloader {

    var hybrisRequest: ECSMicroServiceHybrisRequest?

    // swiftlint:disable function_body_length
    func fetchECSAllProducts(category: String?,
                             limit: Int,
                             offset: Int,
                             filterParameter: ECSPILProductFilter?,
                             completionHandler: @escaping ECSPILProductsFetchCompletion) {
        guard limit <= 50 else {
            completionHandler(nil, (ECSPILHybrisErrors(errorType: .ECSPIL_INVALID_PRODUCT_SEARCH_LIMIT).hybrisPILError))
            return
        }
        commonPILValidation { (error) in
            if error == nil {
                createFetchProductRequest(category: category,
                                          limit: limit,
                                          offset: offset,
                                          filterParameter: filterParameter) { (request, error) in
                    guard error == nil else {
                        completionHandler(nil, error)
                        return
                    }
                    guard let appInfra = ECSConfiguration.shared.appInfra else { return }
                    ECSRestClientCommunicator().performRequestAsynchronously(for: request,
                                                                            with: appInfra,
                                                                            completionHandler: {(data, error) in
                            do {
                                if let productData = data {
                                    if let errorObject = self.getPILHybrisError(for: productData), error != nil {
                                        completionHandler(nil, errorObject.hybrisPILError)
                                        return
                                    }
                                    let jsonDecoder = JSONDecoder()
                                    let hybrisProducts = try jsonDecoder.decode(ECSPILProducts.self, from: productData)
                                    if let fetchedProducts = hybrisProducts.products,
                                        fetchedProducts.count > 0 {
                                        let ctns: [String] = fetchedProducts.map({ $0.ctn ?? "" })
                                        ECSProductDetailsMicroServices().fetchProductSummaryFor(ctns: ctns,
                                                                            completionHandler: { (productSummaries, error) in
                                            guard let summaries = productSummaries else {
                                                completionHandler(nil, error)
                                                return
                                            }
                                            self.setUpECSProductData(for: hybrisProducts,
                                                                     with: summaries.data as? [PRXSummaryData] ?? [])
                                            completionHandler(hybrisProducts, nil)
                                        })
                                    } else {
                                        completionHandler(hybrisProducts, nil)
                                    }
                                } else {
                                    completionHandler(nil, error ?? ECSPILHybrisErrors().hybrisPILError)
                                }
                            } catch {
                                ECSConfiguration.shared.ecsLogger?.log(.verbose, eventId: "ECSParsingError",
                                                                       message: "\(error.fetchCatchErrorMessage())")
                                completionHandler(nil, ECSPILHybrisErrors().hybrisPILError)
                            }
                    })
                }
            } else {
                completionHandler(nil, error)
            }
        }
    }

    func fetchECSProductFor(ctn: String,
                            completionHandler: @escaping ECSPILProductFetchCompletion) {
        var ctnValue = ctn
        guard ctnValue.isValidCTN() else {
            completionHandler(nil, ECSPILHybrisErrors(errorType: .ECSPIL_NOT_FOUND_productId).hybrisPILError)
            return
        }
        commonPILValidation { (error) in
            if error == nil && ECSConfiguration.shared.siteId != nil {
                if let appInfra = ECSConfiguration.shared.appInfra,
                    let siteId = ECSConfiguration.shared.siteId,
                    let language = ECSConfiguration.shared.language,
                    let country = ECSConfiguration.shared.country {
                    let replacementDict = [
                        ECSConstant.ctn.rawValue: fetchFormattedProduct(ctn: ctn),
                        ServiceDiscoveryReplacementConstants.siteID.rawValue: siteId,
                        ServiceDiscoveryReplacementConstants.language.rawValue: language,
                        ServiceDiscoveryReplacementConstants.country.rawValue: country]

                    fetchURLFromServiceDiscoveryFor(serviceID: ECSServiceId.productDetails.rawValue,
                                                    replacementDict: replacementDict) { (url, error) in
                        guard error == nil else {
                            completionHandler(nil, error)
                            return
                        }
                        self.hybrisRequest = ECSMicroServiceHybrisRequest(requestType: ECSConstant.pilKey.rawValue)
                        self.hybrisRequest?.baseURL = url ?? ""
                        self.hybrisRequest?.httpMethod = .GET
                        ECSRestClientCommunicator()
                            .performRequestAsynchronously(for: self.hybrisRequest,
                                                          with: appInfra,
                                                          completionHandler: {(data, error) in
                            do {
                                if let productData = data {
                                    if let errorObject = self.getPILHybrisError(for: productData), error != nil {
                                        completionHandler(nil, errorObject.hybrisPILError)
                                        return
                                    }
                                    let jsonDecoder = JSONDecoder()
                                    let hybrisProduct = try jsonDecoder.decode(ECSPILProduct.self, from: productData)
                                    ECSProductDetailsMicroServices()
                                        .fetchProductSummaryFor(ctns: [ctn],
                                                                completionHandler: { (productSummary, error) in
                                        guard let summary = productSummary else {
                                            completionHandler(nil, error)
                                            return
                                        }
                                        hybrisProduct.productPRXSummary = summary.data.first as? PRXSummaryData
                                        completionHandler(hybrisProduct, nil)
                                    })
                                } else {
                                    completionHandler(nil, error ?? ECSPILHybrisErrors().hybrisPILError)
                                }
                            } catch {
                                ECSConfiguration.shared.ecsLogger?.log(.verbose,
                                                                       eventId: "ECSParsingError",
                                                                       message: "\(error.fetchCatchErrorMessage())")
                                completionHandler(nil, ECSPILHybrisErrors().hybrisPILError)
                            }
                        })
                    }
                }
            } else {
                 fetchPILPRXData(ctn: ctn, completionHandler: completionHandler)
            }
        }
    }
    // swiftlint:enable function_body_length

    func fetchPILPRXData(ctn: String, completionHandler: @escaping ECSPILProductFetchCompletion) {
        ECSProductDetailsMicroServices()
            .fetchProductSummaryFor(ctns: [ctn],
                                    completionHandler: { (productSummary, error) in
                guard let summary = productSummary else {
                    completionHandler(nil, error)
                    return
                }
                let hybrisProduct = ECSPILProduct()
                hybrisProduct.productPRXSummary = summary.data.first as? PRXSummaryData
                completionHandler(hybrisProduct, nil)
            })
    }
}

// MARK: - Helper methods
extension ECSProductMicroServices {

    func replacementDict() -> [String: String]? {
        guard
            let siteID = ECSConfiguration.shared.siteId,
            let locale = ECSConfiguration.shared.language,
            let country = ECSConfiguration.shared.country else { return nil }

        return [ServiceDiscoveryReplacementConstants.siteID.rawValue: siteID,
                ServiceDiscoveryReplacementConstants.language.rawValue: locale,
                ServiceDiscoveryReplacementConstants.country.rawValue: country]
    }

    fileprivate func createFetchProductRequest(
                        category: String?,
                        limit: Int,
                        offset: Int,
                        filterParameter: ECSPILProductFilter?,
                        completionHandler: @escaping (_ request: ECSMicroServiceHybrisRequest?, _ error: Error?) -> Void ) {
        guard let replacementDict = replacementDict() else {
            completionHandler(nil, ECSHybrisError(with: .ECSHybrisNotAvailable).hybrisError)
            return
        }
        fetchURLFromServiceDiscoveryFor(serviceID: ECSServiceId.productList.rawValue,
                                        replacementDict: replacementDict) { (url, error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            self.hybrisRequest = ECSMicroServiceHybrisRequest(requestType: ECSConstant.pilKey.rawValue)
            self.hybrisRequest?.httpMethod = .GET
            self.hybrisRequest?.baseURL = url ?? ""
            var queryParameter = [ECSConstant.category.rawValue: category,
                ECSConstant.limit.rawValue: "\(limit)",
                ECSConstant.offset.rawValue: "\(offset)"].compactMapValues { $0 }

            if let parameter = filterParameter?.getFilterParamerter(), !parameter.isEmpty {
                queryParameter = queryParameter.merging(parameter) { (current, _) in current }
            }
            self.hybrisRequest?.queryParameter = queryParameter
            completionHandler(self.hybrisRequest, nil)
        }
    }

    func setUpECSProductData(for hybrisProducts: ECSPILProducts, with productSummary: [PRXSummaryData]) {
        var productSummaryData = [String: PRXSummaryData]()
        var hybrisProductsWithSummary: [ECSPILProduct] = []
        productSummary.forEach({
            if let ctn = $0.ctn {
                productSummaryData[ctn] = $0
            }
        })
        guard let hybrisProductsList = hybrisProducts.products else { return }
        for hybrisProduct in hybrisProductsList {
            if let productSummary = productSummaryData[hybrisProduct.ctn ?? ""] {
                let hybrisProductWithSummary = hybrisProduct
                hybrisProductWithSummary.productPRXSummary = productSummary
                hybrisProductsWithSummary.append(hybrisProductWithSummary)
            }
        }
        if hybrisProductsWithSummary.count != hybrisProductsList.count {
            // swiftlint:disable line_length
            ECSConfiguration.shared.ecsLogger?.log(.verbose,
                                                   eventId: "ECSSearchAPIProductMismatch",
                                                   message: "\(hybrisProductsWithSummary.count) products are proper among \(hybrisProductsList.count) products in Search API")
            // swiftlint:enable line_length
        }
        hybrisProducts.products = hybrisProductsWithSummary
    }

    func fetchFormattedProduct(ctn: String) -> String {
        return ctn.replacingOccurrences(of: "/", with: "_")
    }
}
