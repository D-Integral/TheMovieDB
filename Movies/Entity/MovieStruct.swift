//
//  MovieStruct.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/5/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let original_language: String?
    let overview: String?
    let poster_path: String?
    let release_date: String?
    let title: String?
}
