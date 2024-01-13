//
//  ApiConfigTableViewCell.swift
//  ApiMaster
//
//  Created by Taron Vekilyan on 12.01.24.
//

import UIKit

class ApiConfigTableViewCell: UITableViewCell {
    
    @IBOutlet private var urlLabel: UILabel!
    @IBOutlet private var freeValueLabel: UILabel!
    @IBOutlet private var costValueLabel: UILabel!
    @IBOutlet private var ttlValueLabel: UILabel!
    @IBOutlet private var limiterValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setup(with model: ApiConfigModel) {
        urlLabel.text = model.api.name
        freeValueLabel.text = String(model.costLimiter.freeCount)
        costValueLabel.text = String(model.costLimiter.cost)
        ttlValueLabel.text = String(model.rateLimiter.ttl)
        limiterValueLabel.text = String(model.rateLimiter.limit)
    }
    
}
