/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PlatformInterfaces
import AppInfra
import PhilipsUIKitDLS

class ChapterDetailsViewController: UIDTableViewController {
    var chapterDetailsArray = [CoCoDemoDetails]()
    var titleForView = String()
    var presenter : BasePresenter?
    var appinfra:AIAppInfra!
    var progressIndicator: UIDProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UIDTableViewCell.self, forCellReuseIdentifier: Constants.CHAPTER_TABLE_CELL_IDENTIFIER)
        self.title = titleForView
        presenter = ChapterListPresenter(_viewController: self)
        appinfra = AppInfraSharedInstance.sharedInstance.appInfraHandler
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createActivityIndicator()
    }
    private func createActivityIndicator(){
        self.progressIndicator = UIDProgressIndicator()
        self.progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.progressIndicator.hidesWhenStopped = true
        self.progressIndicator.progressIndicatorStyle = .indeterminate
        self.progressIndicator.circularProgressIndicatorSize = .medium
        self.progressIndicator.isHidden = true
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self.progressIndicator)
            self.progressIndicator.constrainCenterToParent()
        }
    }
    private func hideIndicator() {
        DispatchQueue.main.async {
            self.progressIndicator?.stopAnimating()
        }
    }
    private func showIndicator() {
        DispatchQueue.main.async {
            self.progressIndicator?.startAnimating()
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return chapterDetailsArray.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Constants.COMMON_COMPONENT_TEXT
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CHAPTER_TABLE_CELL_IDENTIFIER, for: indexPath)
        cell.textLabel?.text = chapterDetailsArray[indexPath.row].cocoDemoName
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Launch Corresponding CoCo's Demo Apps
        tableView.deselectRow(at: indexPath, animated: true)
        let eventID = chapterDetailsArray[indexPath.row].cocoDemoEventId
        guard let inEventID = eventID else { return }
        _ = self.presenter?.onEvent(inEventID)
    }

    func showAlert(message: String?, completion: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: Utilites.aFLocalizedString("RA_Warning"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Utilites.aFLocalizedString("RA_OK"), style: UIAlertAction.Style.default, handler: completion))
        present(alert, animated: true, completion: nil)
    }
}
