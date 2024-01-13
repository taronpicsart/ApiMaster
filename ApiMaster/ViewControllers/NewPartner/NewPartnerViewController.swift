//
//  NewPartnerViewController.swift
//  ApiMaster
//
//  Created by Taron Vekilyan on 12.01.24.
//

import UIKit

class NewPartnerViewController: UIViewController {

    @IBOutlet var nameTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    
    init() {
        super.init(nibName: "NewPartnerViewController", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func btnAction(_ sender: Any) {
        guard let name = nameTF.text, !name.isEmpty else {
            return
        }
        
        guard let email = emailTF.text, !email.isEmpty else {
            return
        }
        
        let partnerModel = PartnerRequestModel(name: name, email: email)
        
        let reqController = RequestController<EmptyResponse>()
        reqController.sendData(endpoint: "/api/user", parameters: partnerModel.dictionary) { result in
            switch result {
            case .success(_):
                self.navigationController?.popViewController(animated: true)
            case .failure(_):
                break
            }
        }
    }
}

struct EmptyResponse: Codable { }
