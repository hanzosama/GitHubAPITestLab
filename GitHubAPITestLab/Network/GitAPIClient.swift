//
//  File.swift
//  GitHubAPITestLab
//
//  Created by HanzoMac on 20/05/21.
//

import Foundation
import Alamofire

class GitAPIClient {
    
    private let sessionManager:SessionManager
    ///Variables for authentication part
    //private  typealias RefreshTokenComplation = (_ succeeded: Bool, _ tokenCredential: String? ) -> Void
    private let lock = NSLock()
    private var requestToRetry:[RequestRetryCompletion] = []
    private var refreshTokenCredencial:Bool = false
    
    
    init(sessionManager:SessionManager) {
        self.sessionManager  = sessionManager
        self.sessionManager.adapter = self
        self.sessionManager.retrier = self
    }
    
    func searchRepositoy( query:String, completion: @escaping ([Repository]) -> Void ){
        var queryParamters :[String:Any] = [
            "sort": "stars",
            "order": "desc",
            "page": 1
        ]
        queryParamters["q"] = query
        sessionManager.request(GitHubAPIRouter.searchReposioty(queryParameter: queryParamters)).validate().responseJSON { (response) in
            switch response.result
            {
            case .success:
                guard let data = response.data, let items = try? JSONDecoder().decode(Items.self, from: data) else {
                    completion([])
                    return
                }
                
                if let respositories = items.items
                {
                    completion(respositories)
                }
            case .failure(let error):
                print(error)
                completion([])
            }
        }
    }
    
}


extension GitAPIClient: RequestAdapter {
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        if refreshTokenCredencial{
            let credentialData = "\(GitHubAPIRouter.CLIENT_ID):\(GitHubAPIRouter.API_KEY)".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
            if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(GitHubAPIRouter.BASE_URL) {
                urlRequest.setValue("Basic " + base64Credentials, forHTTPHeaderField: "Authorization")
            }
            refreshTokenCredencial   = false
        }
        return urlRequest
    }
}

///This is based on https://github.com/Alamofire/Alamofire/blob/4.7.0/Documentation/AdvancedUsage.md
extension GitAPIClient: RequestRetrier {
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        //To protect the thread
        //lock.lock()
        //defer {lock .unlock()}
        //
        if let response = request.task?.response as? HTTPURLResponse, (response.statusCode == 401 || response.statusCode == 403) {
            requestToRetry.append(completion)
            refreshTokenCredencial = true
            self.requestToRetry.forEach { $0(true,0.0)}
            self.requestToRetry.removeAll()
        }else {
            completion(false,0.0)
        }
    }
    
    
}
