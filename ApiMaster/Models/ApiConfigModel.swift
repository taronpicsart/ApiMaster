//
//  ApiConfig.swift
//  ApiMaster
//
//  Created by Taron Vekilyan on 12.01.24.
//

import Foundation

struct ApiConfigModel: Codable {
    enum CodingKeys: String, CodingKey {
        case api, rateLimiter, costLimiter
        case id = "_id"
    }
    
    let id: String
    let api: ApiModel
    let rateLimiter: RateLimiterConfig
    let costLimiter: CostLimiterConfig
}

struct RateLimiterConfig: Codable {
    let ttl: Int
    let limit: Int
}

struct CostLimiterConfig: Codable {
    let freeCount: Int
    let cost: Int
}


struct ApiConfigRequestModel: Codable {
    let apiId: String
    let partnerId: String
    let rateLimiter: RateLimiterConfig
    let costLimiter: CostLimiterConfig
}
