//
//  PartnerModel.swift
//  ApiMaster
//
//  Created by Taron Vekilyan on 12.01.24.
//

import Foundation

struct PartnerModel: Codable {
    enum CodingKeys: String, CodingKey {
        case name, email
        case apiKey = "key"
        case id = "_id"
    }
    
    let id: String
    let name: String
    let email: String
    let apiKey: String
}


struct PartnerRequestModel: Codable {
    let name, email: String
}
