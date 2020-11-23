//
//  NetworkHelper.swift
//  DemoAppTests
//
//  Created by Adarsh Kumar Rai on 28/02/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation


struct NetworkHelper {
    
    static func deleteProduct(_ uuid: String, token: String) {
        let semaphore = DispatchSemaphore(value: 0)
        let url = URL(string: "https://stg.philips.com/prx/registration/\(uuid)")!
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 180)
        urlRequest.httpMethod = "DELETE"
        urlRequest.allHTTPHeaderFields = ["x-accesstoken" : token]
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Failed to delete item \(uuid): \(error.localizedDescription)")
            } else {
                print("Deleted product: \(uuid)")
            }
            semaphore.signal()
        }.resume()
        semaphore.wait()
    }
    
    
    static func downloadRegisteredProducts(_ token: String) -> Array<Dictionary<String, Any>>? {
        let semaphore = DispatchSemaphore(value: 0)
        let url = URL(string: "https://stg.philips.com/prx/registration.registeredProducts")!
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 180)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = ["x-accesstoken" : token]
        var products: Array<Dictionary<String, Any>>? = nil
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data {
                let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let dict = dict as? Dictionary<String, Any> {
                    products = dict["results"] as? Array<Dictionary<String, Any>>
                }
            }
            semaphore.signal()
        }.resume()
        semaphore.wait()
        return products
    }
}
