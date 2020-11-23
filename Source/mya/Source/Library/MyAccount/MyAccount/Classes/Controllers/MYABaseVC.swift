//
//  MYABaseVC.swift
//  MyAccount
//
//  Created by leslie on 02/11/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import UIKit

class MYABaseVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSingleTapGesture()
    }
    
    private func addSingleTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTapGesture))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func handleSingleTapGesture(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}


