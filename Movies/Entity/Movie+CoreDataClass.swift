//
//  Movie+CoreDataClass.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/3/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Movie)
public class Movie: NSManagedObject, Decodable {

    enum CodingKeys: String, CodingKey {
        case buget = "buget"
        case original_language = "original_language"
        case poster_path = "poster_path"
        case overview = "overview"
        case title = "title"
        case ranking = "ranking"
        case release_date = "release_date"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
        guard let entity = NSEntityDescription.entity(forEntityName: "MyManagedObject", in: context) else { fatalError() }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.buget = try container.decodeIfPresent(Double.self, forKey: .buget) ?? 0
        self.original_language = try container.decodeIfPresent(String.self, forKey: .original_language)
        self.poster_path = try container.decodeIfPresent(String.self, forKey: .poster_path)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.ranking = try container.decodeIfPresent(Int64.self, forKey: .ranking) ?? -1
        self.release_date = try container.decodeIfPresent(String.self, forKey: .release_date)
    }
    
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
