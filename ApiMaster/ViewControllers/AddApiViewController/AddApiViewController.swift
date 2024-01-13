//
//  AddApiViewController.swift
//  ApiMaster
//
//  Created by Taron Vekilyan on 12.01.24.
//

import UIKit

class AddApiViewController: UIViewController {

    @IBOutlet var urlTF: UITextField!
    @IBOutlet var methodTF: UITextField!
    @IBOutlet var hostTF: UITextField!
    
    @IBOutlet var pickerRootView: UIView!
    @IBOutlet var pickerView: UIPickerView!
    private let methods = ApiMethod.allCases
    private var choosedMethod: ApiMethod?
    
    init() {
        super.init(nibName: "AddApiViewController", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPicker()
    }
    
    private func setupPicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @IBAction func btnAction(_ sender: Any) {
        guard let choosedMethod else { return }
        
        guard let url = urlTF.text, !url.isEmpty else {
            return
        }
        
        guard let host = hostTF.text, !host.isEmpty else {
            return
        }
        
        let apiModel = ApiRequestModel(method: choosedMethod.rawValue, url: url, host: host)
        
        let reqController = RequestController<EmptyResponse>()
        reqController.sendData(endpoint: "/api/apis", parameters: apiModel.dictionary) { result in
            switch result {
            case .success(_):
                self.navigationController?.popViewController(animated: true)
            case .failure(_):
                break
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        pickerRootView.isHidden = true
    }
    
    @IBAction func doneAction(_ sender: Any) {
        pickerRootView.isHidden = true
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        choosedMethod = methods[selectedRow]
        methodTF.text = choosedMethod!.rawValue
    }
    
    @IBAction func chooseBtnAction(_ sender: Any) {
        pickerRootView.isHidden = false
        pickerView.reloadAllComponents()
        if let choosedMethod, let index = methods.firstIndex(of: choosedMethod) {
            pickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }
}

extension AddApiViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        methods.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        methods[row].rawValue
    }
}
