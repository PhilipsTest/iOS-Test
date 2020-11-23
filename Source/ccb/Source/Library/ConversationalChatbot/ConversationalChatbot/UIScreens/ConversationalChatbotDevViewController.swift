/* Copyright (c) Koninklijke Philips N.V., 2020
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import UIKit
import markymark

class ConversationalChatbotDevViewController: UIViewController {

    
    
    @IBOutlet var servicesTableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let text = MarkDownTextView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ConversationalChatbotDevViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension ConversationalChatbotDevViewController : UITableViewDelegate {
    
}
