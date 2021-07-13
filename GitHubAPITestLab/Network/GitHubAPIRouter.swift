//
//  GitHubAPIRouter.swift
//  GitHubAPITestLab
//
//  Created by HanzoMac on 20/05/21.
//

import Alamofire
import Foundation

enum GitHubAPIRouter {
    
    static let BASE_URL = "https://api.github.com"
    static let CLIENT_ID = "raiman114@gmail.com"
    static let API_KEY = "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"
    static let APPLICATION_JSON = "application/json"
    
    
    case searchReposioty(queryParameter: [String:Any])
    
    var method:HTTPMethod {
        switch self {
        case .searchReposioty:
            return .get
        }
    }
    
    var path:String {
        switch self {
        case .searchReposioty:
            return "/search/repositories"
        }
    }
    
    var parameters: Parameters?{
        switch self {
        case .searchReposioty(let queryParameter):
            return queryParameter
        }
    }
    
    var accept: String {
        switch self {
        case .searchReposioty:
            return "application/json"
        }
    }
    
    var consume: String {
        switch self {
        case .searchReposioty:
            return "application/vnd.github.v3+json"
        }
    }
    
}

extension GitHubAPIRouter:  URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let url = try Self.BASE_URL.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.setValue(accept, forHTTPHeaderField: "Accept")
        request.setValue(consume, forHTTPHeaderField: "Consume")
        
        switch self {
        case .searchReposioty:
            request =  try URLEncoding.default.encode(request, with: parameters)
        }
        return request
    }
}
