//
//  SearchNetworkingService.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/7/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//

import UIKit

class SearchNetworkingService: NSObject {
    
    static let shared = SearchNetworkingService()
    
    var currentPage = 1
    
    let searchPath: String = "https://api.themoviedb.org/3/search/movie"
    
    func requestSearch(_ searchString: String, _ completionHandler: @escaping (MoviesPage) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let this = self else { return }
            this.searchDataTask(searchString, completionHandler)?.resume()
        }
    }
    
    func searchDataTask(_ searchString: String, _ completionHandler: @escaping (MoviesPage) -> Void) -> URLSessionDataTask? {
        let request = searchRequest(searchString)
        
        if let theRequest = request {
            
            return URLSession.shared.dataTask(with:theRequest, completionHandler: {(data, response, error) in
                guard let data = data, error == nil else { return }
                
                let decoder = JSONDecoder()
                if let moviesPage = try? decoder.decode(MoviesPage.self, from: data) {
                    completionHandler(moviesPage)
                }
            })
        }
        
        return nil
    }
    
    func searchRequest(_ searchString: String) -> URLRequest? {
        var urlComponents = URLComponents(string: searchPath)
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: AuthorizationManager.shared.APIKey),
            URLQueryItem(name: "language", value: "En-US"),
            URLQueryItem(name: "query", value: "\(searchString)"),
            URLQueryItem(name: "page", value: "\(currentPage)")
        ]
        
        if let url = urlComponents?.url {
            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            request.httpBody = NSData(data: "{}".data(using: .utf8)!) as Data
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = ["content-type": "application/json"]
            
            return request
        }
        
        return nil
    }
}
