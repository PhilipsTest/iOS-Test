//
//  MYAItem.swift
//  TestProfileDetails
//
//  Created by Hashim MH on 25/10/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import UIKit

class MYAItem: NSObject {
    public var title:String
    public var value:String?
    public var isVerified:Bool = true
    public var validationMessage:String?

    
    init(title:String) {
        self.title = title
        super.init()
    }
    init(title:String ,value:String) {
        self.title = title
        self.value = value
        super.init()
    }

    class func items(withDictionary dictionary:[String:String])->[MYAItem]{
        var items = [MYAItem]()
        for (title,value) in dictionary {
           let item = MYAItem(title: title)
            item.value = value
            items.append(item)
        }
        return items        
    }
    override var description: String{
        return title
    }
}
