//
//  DataManager.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/6/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//

import Foundation
import CoreData

class DataManager: NSObject {
    
    static let shared = DataManager()
    
    public var popularMovies: [Movie] = []
    public var favorites: Set<Movie> = []
    
    internal var context: NSManagedObjectContext? = nil
    
    func favoritesArray() -> [Movie] {
        return Array(favorites)
    }
    
    func addMovie(movie: Movie) {
        if !favorites.contains(movie) {
            favorites.insert(movie)
            save()
        }
    }
    
    func removeMovie(movie: Movie) {
        if favorites.contains(movie) {
            favorites.remove(movie)
            save()
        }
    }
    
    func save() {
        cleanStorage()
        
        let theFavoritesArray = favoritesArray()
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(theFavoritesArray)
            
            if let theContext = context, let entity = NSEntityDescription.entity(forEntityName: "Favorites",
                                                       in: theContext) {
                let favoritesEntity = NSManagedObject(entity: entity, insertInto: context)
                favoritesEntity.setValue(data, forKey: "data")
                context?.insert(favoritesEntity)
                
                do {
                    try context?.save()
                } catch {
                    print("Error saving the Core Data context.")
                }
            }
        } catch {
            print("Error encoding data with favorites")
        }
    }
    
    func restore() {
        
        let decoder = JSONDecoder()
        
        if let theContext = context {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
            
            do {
                let results = try theContext.fetch(request)
                for favoritesEntity in results as! [NSManagedObject] {
                    if let data = favoritesEntity.value(forKey: "data") as? Data, let theFavoritesArray = try? decoder.decode([Movie].self, from: data) {
                        favorites = favorites.union(Set(theFavoritesArray))
                    }
                }
                
            } catch {
                
                print("Error fetching from Core Data.")
            }
        }
    }
    
    func cleanStorage() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        if let theContext = context {
            do {
                try theContext.execute(batchDeleteRequest)
            } catch {
                print("Error cleaning Core Data storage")
            }
        }
    }
    
    func saveContext () {
        if let theContext = context, theContext.hasChanges {
            do {
                try theContext.save()
            } catch {
                print("Error \(error) saving the Core Data context.")
            }
        }
    }
}
