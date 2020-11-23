/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

let mrButtonTag = 111
let msButtonTag = 222

class IAPSalutationViewController: UIViewController {
    
    @IBOutlet weak var mrButton:UIButton?
    @IBOutlet weak var msButton:UIButton?
    var completion : ((Salutation) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        let mrTitle = Salutation.mr.getLocalizedText()?.capitalized
        let msTitle = Salutation.ms.getLocalizedText()?.capitalized
        mrButton?.setTitle(mrTitle, for: .normal)
        msButton?.setTitle(msTitle, for: .normal)
    }

    @IBAction func salutationSelected(_ sender: UIButton) {
        let salutation: Salutation = sender.tag == mrButtonTag ? .mr: .ms
        if let inCompletion = completion {
            inCompletion(salutation)
        }
    }
}
