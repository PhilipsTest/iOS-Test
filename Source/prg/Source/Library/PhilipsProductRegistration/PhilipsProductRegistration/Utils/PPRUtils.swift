//
//  PPRUtils.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import UIKit

class PPRUtils: NSObject {
    
    class func objectOrNSNull(object: AnyObject?) -> AnyObject? {
        guard object != nil else {
            return nil
        }
        guard object! is NSNull else {
            return object
        }
        return nil
    }
    
    class func isDictionary(dictionary: AnyObject?)->Bool {
        return  (dictionary != nil && dictionary! is NSDictionary)
    }
    
    class func isArray(array: AnyObject?) ->Bool{
        return (array != nil && array! is NSArray)
    }
    
    class func converProductsToRegisteredProducts(products: [PPRProduct], uuid: String?) -> [PPRRegisteredProduct] {
        var registeredProducts: [PPRRegisteredProduct] = [PPRRegisteredProduct]()
        for product in products {
            let registeredProduct = PPRProduct.registeredProduct(product: product, uuid: uuid)
            registeredProducts.append(registeredProduct)
        }
        return registeredProducts
    }
    
    class func scaleImage(with image: UIImage, scaledToFill size: CGSize) -> UIImage {
        let scale: CGFloat = max(size.width / image.size.width, size.height / image.size.height)
        let width: CGFloat = image.size.width * scale
        let height: CGFloat = image.size.height * scale
        let imageRect = CGRect(x: CGFloat((size.width - width) / 2.0), y: CGFloat((size.height - height) / 2.0), width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image.draw(in: imageRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
