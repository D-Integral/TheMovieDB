//
//  Cache.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/5/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//

import Foundation

class Cache: NSObject {
    static let shared = Cache()
    
    let cache = NSCache<NSString, DiscardableCacheItem>()
    
    func setData(_ data: Data, forKey key: String) {
        let cacheItem = DiscardableCacheItem(data: data as NSData)
        cache.setObject(cacheItem, forKey: key as NSString)
    }
    
    func dataForKey(_ key: String) -> Data? {
        let cacheItem = cache.object(forKey: key as NSString)
        return cacheItem?.data as Data?
    }
}
