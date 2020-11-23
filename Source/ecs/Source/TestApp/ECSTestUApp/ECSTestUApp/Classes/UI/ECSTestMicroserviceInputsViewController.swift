/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

@objc protocol ECSTestRequestHandlerProtocol: NSObjectProtocol {
    
    weak var inputViewController: ECSTestMicroserviceInputsViewController? { get set }
    func executeRequest()
    
    @objc optional func clearMicroserviceData()
    @objc optional func didSelectRow(picker: UIPickerView, row: Int)
    @objc optional func titleForPicker(picker: UIPickerView, row: Int) -> String
    @objc optional func numberOfPickerValues(picker: UIPickerView) -> Int
    @objc optional func pushResultView(with responseData: String?, responseError: String?)
    @objc optional func shouldShowDefaultValue(textField: UITextField?) -> Bool
    @objc optional func populateDefaultValue(textField: UITextField?)
    @objc optional func inputTextFieldDidEndEditing(_ textField: UITextField)
    @objc optional func removeInputValues()
}

extension Error {
    
    func fetchResponseErrorMessage() -> String {
        if let error = self as NSError? {
            return "Error Code: \(error.code)\n Error domain: \(error.domain) \n Error message: \(error.localizedDescription)"
        }
        return ""
    }
}

class ECSTestMicroserviceInputsViewController: UIViewController {

    @IBOutlet weak var microserviceInputTableView: UITableView!
    @IBOutlet weak var clearDataButton: UIDButton!
    @IBOutlet weak var executeRequestButton: UIDProgressButton!
    
    var microServiceInput: ECSTestMicroServiceDisplayModel?
    var microServiceRequestHandler: ECSTestRequestHandlerProtocol?
    var shouldHideClearButton: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        microServiceRequestHandler?.inputViewController = self
        addSingleTapGesture()
        clearDataButton.isHidden = shouldHideClearButton == true
    }
    
    @IBAction func clearDataButtonClicked(_ sender: UIDButton) {
        microServiceRequestHandler?.clearMicroserviceData?()
    }
    
    @IBAction func executeButtonClicked(_ sender: UIDProgressButton) {
        sender.isActivityIndicatorVisible = true
        navigationController?.view.isUserInteractionEnabled = false
        microServiceRequestHandler?.executeRequest()
    }
    
    deinit {
        microServiceRequestHandler?.removeInputValues?()
        NotificationCenter.default.removeObserver(self)
    }
}

extension ECSTestMicroserviceInputsViewController {
    
    func createPickerView() -> UIDPickerView {
        let microServiceInputPicker = UIDPickerView.makePreparedForAutoLayout()
        microServiceInputPicker.delegate = self
        microServiceInputPicker.dataSource = self
        return microServiceInputPicker
    }
    
    func pushResultView(responseData: String?, responseError: String?) {
        DispatchQueue.main.async {
            self.executeRequestButton.isActivityIndicatorVisible = false
            self.navigationController?.view.isUserInteractionEnabled = true
            let storyBoard = UIStoryboard(name: "ECSTestMicroservices", bundle: Bundle(for: type(of: self)))
            if let viewController = storyBoard.instantiateViewController(withIdentifier: "ECSTestMicroservicesResultViewController") as? ECSTestMicroservicesResultViewController {
                viewController.responseData = responseData
                viewController.errorData = responseError
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func addSingleTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTapGesture))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleSingleTapGesture(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            microserviceInputTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            microserviceInputTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

extension ECSTestMicroserviceInputsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return microServiceInput?.microServiceInputs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inputCell = tableView.dequeueReusableCell(withIdentifier: "ECSTestInputCell") as? ECSTestInputTableViewCell
        let microserviceInputDetail = microServiceInput?.microServiceInputs?[indexPath.row]
        inputCell?.inputLabel.text = microserviceInputDetail?.inputDisplayText
        inputCell?.inputTextField.delegate = self
        inputCell?.inputTextField.inputView = nil
        inputCell?.inputTextField.placeholder = microserviceInputDetail?.inputPlaceHolderText
        inputCell?.inputTextField.tag = microserviceInputDetail?.inputIdentifier ?? 0
        if let showDefaultValue = microServiceRequestHandler?.shouldShowDefaultValue?(textField: inputCell?.inputTextField), showDefaultValue == true {
            microServiceRequestHandler?.populateDefaultValue?(textField: inputCell?.inputTextField)
        }
        
        switch microserviceInputDetail?.inputType {
        case ECSTextFieldType.stringText.rawValue:
            inputCell?.inputTextField.keyboardType = .default
        case ECSTextFieldType.integerText.rawValue:
            inputCell?.inputTextField.keyboardType = .numberPad
        case ECSTextFieldType.picker.rawValue:
            let inputPicker = createPickerView()
            inputPicker.tag = microserviceInputDetail?.inputIdentifier ?? 0
            inputCell?.inputTextField.inputView = inputPicker
        default:
            inputCell?.inputTextField.keyboardType = .default
        }
        return inputCell ?? UITableViewCell()
    }
}

extension ECSTestMicroserviceInputsViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return microServiceRequestHandler?.titleForPicker?(picker: pickerView, row: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        microServiceRequestHandler?.didSelectRow?(picker: pickerView, row: row)
    }
}

extension ECSTestMicroserviceInputsViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return microServiceRequestHandler?.numberOfPickerValues?(picker: pickerView) ?? 0
    }
}

extension ECSTestMicroserviceInputsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        microServiceRequestHandler?.inputTextFieldDidEndEditing?(textField)
    }
}
