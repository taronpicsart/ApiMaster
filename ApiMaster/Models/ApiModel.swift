//
//  ApiModel.swift
//  ApiMaster
//
//  Created by Taron Vekilyan on 12.01.24.
//

import Foundation

struct ApiModel: Codable {
    enum CodingKeys: String, CodingKey {
        case method, url, host
        case id = "_id"
    }
    
    let id: String
    let method: ApiMethod?
    let url: String?
    let host: String?
    
    var name: String {
        if let method, let url {
            return method.rawValue + "| " + url
        }
        return id
    }
}

enum ApiMethod: String, CaseIterable, Codable {
    case get, post, put, delete
}

struct ApiRequestModel: Codable {
    let method: String
    let url: String
    let host: String
}
