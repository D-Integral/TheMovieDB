//
//  DataManager.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/6/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//

import Foundation

class DataManager: NSObject {
    
    static let shared = DataManager()
    
    public var popularMovies: [Movie] = []
    public var favorites: Set<Movie> = []
    
    func favoritesArray() -> [Movie] {
        return Array(favorites)
    }
}
