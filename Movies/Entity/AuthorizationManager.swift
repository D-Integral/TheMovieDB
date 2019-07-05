//
//  AuthorizationManager.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/3/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//

import Foundation

class AuthorizationManager: NSObject {
    static let shared = AuthorizationManager()
    
    let APIKey = "b3d7cbb059e4c69a9900894a64248f18"
    let tokenRequest = "https://api.themoviedb.org/3/authentication/token/new?api_key="
    let authenticateRequest = "https://www.themoviedb.org/authenticate/"
    var authenticateToken: String? = nil
    let sessionIDRequest = "https://api.themoviedb.org/3/authentication/session/new?api_key="
    var sessionID: String? = nil
    
    public func authorize(_ completionHandler: @escaping () -> Void) {
        if nil == self.sessionID {
            self.requestToken(completionHandler)
        }
    }
    
    private func requestToken(_ completionHandler: @escaping () -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let this = self else { return }
            let completionHandler: () -> Void = {
                guard let this = self else { return }
                
                this.authenticate(completionHandler)
            }
            this.tokenRequestDataTask(completionHandler)?.resume()
        }
    }
    
    private func tokenRequestDataTask(_ completionHandler: @escaping () -> Void) -> URLSessionDataTask? {
        if let url = URL(string: tokenRequest + APIKey) {
            return URLSession.shared.dataTask(with:url, completionHandler: {(data, response, error) in
                do {
                    if let theData = data {
                        let json = try JSONSerialization.jsonObject(with: theData, options: []) as? [String: Any]
                        self.authenticateToken = json?["request_token"] as? String
                        completionHandler()
                    }
                } catch {
                    print("Error requesting the token.")
                }
            })
        }
        
        return nil
    }
    
    func authenticate(_ completionHandler: @escaping () -> Void) {
        if let theToken = authenticateToken, let url = URL(string: authenticateRequest + theToken) {
            RoutingManager.shared.pushOAuthSignIn(url: url, completionHandler: completionHandler)
        }
    }
    
    func requestSessionID() {
        DispatchQueue.global().async { [weak self] in
            guard let this = self else { return }
            this.sessionIDRequestDataTask()?.resume()
        }
    }
    
    func sessionIDRequestDataTask() -> URLSessionDataTask? {
        if let url = URL(string: sessionIDRequest + APIKey) {
            do {
                var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
                request.setValue(self.APIKey, forHTTPHeaderField: "api_key")
                let httpBodyDict = ["request_token" : self.authenticateToken ?? ""]
                let httpBody = try JSONSerialization.data(withJSONObject: httpBodyDict, options: .prettyPrinted)
                request.httpBody = httpBody
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = ["content-type": "application/json"]
                
                return URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
                    do {
                        if let theData = data {
                            let json = try JSONSerialization.jsonObject(with: theData, options: []) as? [String: Any]
                            self.sessionID = json?["session_id"] as? String
                            
                        }
                    } catch {
                        print("Error converting the data with the session ID to JSON.")
                    }
                })
            } catch {
                print("Error creating the HTTP body for the session ID request.")
            }
        }
        
        return nil
    }
}
