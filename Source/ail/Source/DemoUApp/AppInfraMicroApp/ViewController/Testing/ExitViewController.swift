//
//  ExitViewController.swift
//  AppInfraMicroApp
//
//  Created by leslie on 15/06/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import UIKit

class ExitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dismiss(animated: true, completion: nil)
    }

}
