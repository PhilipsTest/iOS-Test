/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsEcommerceSDK
import PhilipsUIKitDLS

class ECSTestMicroservicesResultViewController: UIViewController {
    
    @IBOutlet weak var microserviceResultTableView: UITableView!
    var responseData: String?
    var errorData: String?
}

extension ECSTestMicroservicesResultViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Microservice Result" : "Microservice error"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let resultCell = tableView.dequeueReusableCell(withIdentifier: "ECSTestResultCell") as? ECSTestResultTableViewCell
        switch indexPath.section {
        case 0:
            resultCell?.microserviceResultTextView.text = responseData ?? ""
        case 1:
            resultCell?.microserviceResultTextView.text = errorData ?? ""
        default: break
        }
        resultCell?.microserviceResultTextView?.scrollRangeToVisible(NSMakeRange(0, 0))
        return resultCell ?? UITableViewCell()
    }
}
