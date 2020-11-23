/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

class ECSTestMicroservicesViewController: UIViewController {
    
    @IBOutlet weak var microserviceTableView: UITableView!
    var microServiceEmbedded: ECSTestMicroServiceGroupModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ECSTestMicroservicesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "ECSTestMicroservices", bundle: Bundle(for: type(of: self)))
        let selectedMicroService = microServiceEmbedded?.microServicesDetails?[indexPath.row]
        let microServiceRequestHandler = ECSMicroServicesIndentifier(rawValue: selectedMicroService?.microServiceIdentifier ?? "")?.fetchRequestHandler()
        if let viewController = storyBoard.instantiateViewController(withIdentifier: "ECSTestMicroserviceInputsViewController") as? ECSTestMicroserviceInputsViewController {
            viewController.microServiceInput = selectedMicroService
            viewController.microServiceRequestHandler = microServiceRequestHandler
            viewController.shouldHideClearButton = selectedMicroService?.shouldHideClearButton
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension ECSTestMicroservicesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return microServiceEmbedded?.microServicesDetails?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let microserviceCell = tableView.dequeueReusableCell(withIdentifier: "ECSTestMicroserviceCell") ?? UITableViewCell(style: .default, reuseIdentifier: "ECSTestMicroserviceCell")
        let embeddedMicroServiceName = microServiceEmbedded?.microServicesDetails?[indexPath.row].microServiceIdentifier ?? ""
        microserviceCell.textLabel?.text = embeddedMicroServiceName
        return microserviceCell
    }
}
