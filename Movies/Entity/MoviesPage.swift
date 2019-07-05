//
//  MoviesPage.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/5/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//

import Foundation

struct MoviesPage: Codable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Movie]
}
