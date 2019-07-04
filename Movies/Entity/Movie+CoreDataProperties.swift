//
//  Movie+CoreDataProperties.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/3/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var poster_path: String?
    @NSManaged public var title: String?
    @NSManaged public var overview: String?
    @NSManaged public var release_date: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var buget: Double
    @NSManaged public var ranking: Int64
    @NSManaged public var original_language: String?

}
