//
//  Repository.swift
//  GitHubAPITestLab
//
//  Created by HanzoMac on 20/05/21.
//

import Foundation

struct Repository: Codable {
    let id: Int
    let name: String
    let description: String
}

struct Items: Codable  {
    let totalCount:Int
    let items:[Repository]?
    
    enum CodingKeys: String, CodingKey{
        case totalCount = "total_count"
        case items = "items"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalCount = try values.decode(Int.self, forKey: .totalCount)
        items = try values.decode([Repository].self, forKey: .items)
    }
}
