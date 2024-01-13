//
//  PartnerTableViewCell.swift
//  ApiMaster
//
//  Created by Taron Vekilyan on 12.01.24.
//

import UIKit

class PartnerTableViewCell: UITableViewCell {
    @IBOutlet private var nameValueLabel: UILabel!
    @IBOutlet private var emailValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(with model: PartnerModel) {
        nameValueLabel.text = model.name
        emailValueLabel.text = model.email
    }
}
