//
//  PartnerDetailsController.swift
//  ApiMaster
//
//  Created by Taron Vekilyan on 12.01.24.
//

import UIKit

class PartnerDetailsController: UIViewController {
    private let partner: PartnerModel
    private var apiConfigs = [ApiConfigModel]()
 
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var nameValueLabel: UILabel!
    @IBOutlet private var emailValueLabel: UILabel!
    @IBOutlet private var apiKeyValueLabel: UILabel!
    
    init(with partner: PartnerModel) {
        self.partner = partner
        super.init(nibName: "PartnerDetailsController", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPartner()
        registerCells()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllConfigs()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: "ApiConfigTableViewCell", bundle: nil), forCellReuseIdentifier: "ApiConfigTableViewCell")
    }
    
    private func setupPartner() {
        nameValueLabel.text = partner.name
        emailValueLabel.text = partner.email
        apiKeyValueLabel.text = partner.apiKey
    }

    @IBAction func addNewAction(_ sender: Any) {
        let vc = AddConfigViewController(partner: partner)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func getAllConfigs() {
        let reqController = RequestController<[ApiConfigModel]>()
        reqController.fetchData(endpoint: "/api/api-config/" + partner.id) { result in
            switch result {
            case .success(let data):
                if let data {
                    self.apiConfigs = data
                    self.tableView.reloadData()
                }
            case .failure(_):
                break
            }
        }
    }
}

extension PartnerDetailsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        apiConfigs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApiConfigTableViewCell", for: indexPath) as! ApiConfigTableViewCell
        cell.setup(with: apiConfigs[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        210
    }
}
