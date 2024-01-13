//
//  ViewController.swift
//  ApiMaster
//
//  Created by Taron Vekilyan on 12.01.24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private var partners = [PartnerModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllPartners()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: "PartnerTableViewCell", bundle: nil), forCellReuseIdentifier: "PartnerTableViewCell")
    }
    
    @IBAction func addAction(_ sender: Any) {
        let vc = NewPartnerViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addNewApiAction(_ sender: Any) {
        let vc = AddApiViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func getAllPartners() {
        let reqController = RequestController<[PartnerModel]>()
        reqController.fetchData(endpoint: "/api/user") { result in
            switch result {
            case .success(let data):
                if let data {
                    self.partners = data
                    self.tableView.reloadData()
                }
            case .failure(_):
                break
            }
        }
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        partners.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PartnerTableViewCell", for: indexPath) as! PartnerTableViewCell
        cell.setup(with: partners[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PartnerDetailsController(with: partners[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
