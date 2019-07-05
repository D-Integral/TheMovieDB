//
//  PopularMoviesNetworkingService.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/4/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//

import UIKit

class PopularMoviesNetworkingService: NSObject {
    
    static let shared = PopularMoviesNetworkingService()
    
    var popularMoviesCurrentPage = 1
    
    let moviesPath: String = "https://api.themoviedb.org/3/movie/popular"
    
    func requestPopularMovies(_ completionHandler: @escaping (MoviesPage) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let this = self else { return }
            this.popularMoviesDataTask(completionHandler)?.resume()
        }
    }
    
    func popularMoviesDataTask(_ completionHandler: @escaping (MoviesPage) -> Void) -> URLSessionDataTask? {
        let request = popularMoviesRequest()
        
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
    
    func popularMoviesRequest() -> URLRequest? {
        var urlComponents = URLComponents(string: moviesPath)
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: AuthorizationManager.shared.APIKey),
            URLQueryItem(name: "language", value: "En-US"),
            URLQueryItem(name: "page", value: "\(popularMoviesCurrentPage)")
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
