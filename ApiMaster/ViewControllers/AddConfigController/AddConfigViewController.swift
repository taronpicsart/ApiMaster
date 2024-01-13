//
//  AddConfigViewController.swift
//  ApiMaster
//
//  Created by Taron Vekilyan on 12.01.24.
//

import UIKit

class AddConfigViewController: UIViewController {

    @IBOutlet var apiTF: UITextField!
    @IBOutlet var freeTF: UITextField!
    @IBOutlet var codtTF: UITextField!
    @IBOutlet var ttlTF: UITextField!
    @IBOutlet var limitTF: UITextField!
    @IBOutlet var pickerRootView: UIView!
    @IBOutlet var pickerView: UIPickerView!
    
    var choosedApi: ApiModel?
    var allApis = [ApiModel]()
    private let partner: PartnerModel
    
    init(partner: PartnerModel) {
        self.partner = partner
        super.init(nibName: "AddConfigViewController", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPicker()
        getAllApis()
    }

    @IBAction func cancelAction(_ sender: Any) {
        pickerRootView.isHidden = true
    }
    
    @IBAction func doneAction(_ sender: Any) {
        pickerRootView.isHidden = true
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        choosedApi = allApis[selectedRow]
        apiTF.text = choosedApi!.name
    }
    
    @IBAction func chooseBtnAction(_ sender: Any) {
        pickerRootView.isHidden = false
        pickerView.reloadAllComponents()
        if let choosedApi, let index = allApis.firstIndex(where: { $0.id == choosedApi.id }) {
            pickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    @IBAction func addBtnAction(_ sender: Any) {
        guard let choosedApi else {
            return
        }
        
        guard let freetext = freeTF.text, let free = Int(freetext) else {
            return
        }
        
        guard let costtext = codtTF.text, let cost = Int(costtext) else {
            return
        }
        
        guard let ttltext = ttlTF.text, let ttl = Int(ttltext) else {
            return
        }
        
        guard let limittext = limitTF.text, let limit = Int(limittext) else {
            return
        }
        
        let model = ApiConfigRequestModel(apiId: choosedApi.id, partnerId: partner.id, rateLimiter: RateLimiterConfig(ttl: ttl, limit: limit), costLimiter: CostLimiterConfig(freeCount: free, cost: cost))
        
        let reqController = RequestController<[ApiModel]>()
        reqController.sendData(endpoint: "/api/api-config", parameters: model.dictionary) { result in
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension AddConfigViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        allApis.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        allApis[row].name
    }
}

extension AddConfigViewController {
    func getAllApis() {
        let reqController = RequestController<[ApiModel]>()
        reqController.fetchData(endpoint: "/api/apis") { result in
            switch result {
            case .success(let data):
                if let data {
                    self.allApis = data
                }
            case .failure(_):
                break
            }
        }
    }
}
