//
//  APIClient.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/3/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//

import Foundation

class APIClient: NSObject {
    static let shared = APIClient()
    
    let APIKey = "b3d7cbb059e4c69a9900894a64248f18"
    let tokenRequest = "https://api.themoviedb.org/3/authentication/token/new?api_key="
    let authorizeRequest = "https://www.themoviedb.org/authenticate/"
    var authorizeToken: String? = nil
    let moviesPath: String = "https://api.github.com/repos/Alamofire/Alamofire/contributors"
    
    func requestToken() {
        DispatchQueue.global().async { [weak self] in
            guard let this = self else { return }
            let completionHandler: () -> Void = {
                guard let this = self else { return }
                
                this.authorize()
            }
            this.tokenRequestDataTask(completionHandler)?.resume()
        }
    }
    
    func tokenRequestDataTask(_ completionHandler: @escaping () -> Void) -> URLSessionDataTask? {
        if let url = URL(string: tokenRequest + APIKey) {
            return URLSession.shared.dataTask(with:url, completionHandler: {(data, response, error) in
                do {
                    if let theData = data {
                        let json = try JSONSerialization.jsonObject(with: theData, options: []) as? [String: Any]
                        self.authorizeToken = json?["request_token"] as? String
                        completionHandler()
                    }
                } catch {
                    print("Error requesting the token.")
                }
            })
        }
        
        return nil
    }
    
    func authorize() {
        DispatchQueue.global().async { [weak self] in
            guard let this = self else { return }
            this.authorizeTask()?.resume()
        }
    }
    
    func authorizeTask() -> URLSessionDataTask? {
        if let theToken = authorizeToken, let url = URL(string: authorizeRequest + theToken) {
            RoutingManager.shared.pushOAuthSignIn(url: url)
        }
        
        return nil
    }
    
    func requestMovies(_ completionHandler: @escaping ([Movie]) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let this = self else { return }
            this.moviesDataTask(completionHandler)?.resume()
        }
    }
    
    func moviesDataTask(_ completionHandler: @escaping ([Movie]) -> Void) -> URLSessionDataTask? {
        if let url = URL(string: moviesPath) {
            return URLSession.shared.dataTask(with:url, completionHandler: {(data, response, error) in
                guard let data = data, error == nil else { return }

                let decoder = JSONDecoder()
                if let contributors = try? decoder.decode([Movie].self, from: data) {
                    completionHandler(contributors)
                }
            })
        }

        return nil
    }
}
