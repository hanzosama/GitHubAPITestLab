//
//  GitHubAPIManager.swift
//  GitHubAPITestLab
//
//  Created by HanzoMac on 20/05/21.
//
import Foundation
import Alamofire

class GitHubApiManager {
        
    let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.waitsForConnectivity = true
        return SessionManager(configuration: configuration)
    }()
    
    init() {
    }
    
}
