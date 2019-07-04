//
//  APIClient.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/4/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//

import UIKit

class APIClient: NSObject {
    static let shared = APIClient()
    
    let moviesPath: String = "https://api.themoviedb.org/3/movie/popular?page=1&language=en-US&api_key=b3d7cbb059e4c69a9900894a64248f18"
    
    func requestPopularMovies(_ completionHandler: @escaping ([Movie]) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let this = self else { return }
            this.popularMoviesDataTask(completionHandler)?.resume()
        }
    }
    
    func popularMoviesDataTask(_ completionHandler: @escaping ([Movie]) -> Void) -> URLSessionDataTask? {
        let request = popularMoviesRequest()
        
        if let theRequest = request {
            
            return URLSession.shared.dataTask(with:theRequest, completionHandler: {(data, response, error) in
                guard let data = data, error == nil else { return }
                
                let decoder = JSONDecoder()
                if let movies = try? decoder.decode([Movie].self, from: data) {
                    completionHandler(movies)
                }
            })
        }
        
        return nil
    }
    
    func popularMoviesRequest() -> URLRequest? {
        var urlComponents = URLComponents(string: moviesPath)
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: AuthorizationManager.shared.APIKey),
            URLQueryItem(name: "language", value: "En-US"),
            URLQueryItem(name: "page", value: "\(1)")
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
