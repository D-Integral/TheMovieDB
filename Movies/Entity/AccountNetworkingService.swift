//
//  AccountNetworkingService.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/5/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//

import UIKit

class AccountNetworkingService: NSObject {
    
    static let shared = AccountNetworkingService()
    
    let accountPath: String = "https://api.themoviedb.org/3/account"
    
    func requestAccount(_ completionHandler: @escaping (Account) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let this = self else { return }
            this.accountDataTask(completionHandler)?.resume()
        }
    }
    
    func accountDataTask(_ completionHandler: @escaping (Account) -> Void) -> URLSessionDataTask? {
        let request = accountRequest()
        
        if let theRequest = request {
            
            return URLSession.shared.dataTask(with:theRequest, completionHandler: {(data, response, error) in
                guard let data = data, error == nil else { return }
                
                let decoder = JSONDecoder()
                if let account = try? decoder.decode(Account.self, from: data) {
                    completionHandler(account)
                }
            })
        }
        
        return nil
    }
    
    func accountRequest() -> URLRequest? {
        var urlComponents = URLComponents(string: accountPath)
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: AuthorizationManager.shared.APIKey),
            URLQueryItem(name: "session_id", value: AuthorizationManager.shared.sessionID)
        ]
        
        if let url = urlComponents?.url {
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10.0)
            request.httpBody = NSData(data: "{}".data(using: .utf8)!) as Data
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = ["content-type": "application/json"]
            
            return request
        }
        
        return nil
    }
}
