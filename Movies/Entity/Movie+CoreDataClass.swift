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
        case country = "country"
        case imageURL = "imageURL"
        case info = "info"
        case name = "name"
        case ranking = "ranking"
        case year = "year"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
        guard let entity = NSEntityDescription.entity(forEntityName: "MyManagedObject", in: context) else { fatalError() }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.buget = try container.decodeIfPresent(Double.self, forKey: .buget) ?? 0
        self.country = try container.decodeIfPresent(String.self, forKey: .country)
        self.imageURL = try container.decodeIfPresent(URL.self, forKey: .imageURL)
        self.info = try container.decodeIfPresent(String.self, forKey: .info)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.ranking = try container.decodeIfPresent(Int64.self, forKey: .ranking) ?? -1
        self.year = try container.decodeIfPresent(Int64.self, forKey: .year) ?? -1
    }
    
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
