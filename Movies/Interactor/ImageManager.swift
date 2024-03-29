//
//  ImageManager.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/5/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//

import Foundation

class ImageManager: NSObject {
    static let shared = ImageManager()
    
    private var items = [String: DispatchWorkItem]()
    
    func cancel(forURL URL: URL) {
        let item = items[URL.absoluteString]
        
        if let isCancelled = item?.isCancelled, isCancelled == false {
            item?.cancel()
        }
        
        items[URL.absoluteString] = nil
    }
    
    func requestImage(URL: URL, completionHandler: @escaping (Data, URL) -> Void) {
        let dispatchWorkItem = DispatchWorkItem { [weak self] in
            guard let this = self else { return }
            
            if let cached = this.cached(forURL: URL) {
                completionHandler(cached, URL)
            } else if let data = try? Data(contentsOf: URL) {
                Cache.shared.setData(data, forKey: URL.absoluteString)
                
                completionHandler(data, URL)
            }
        }
        
        execute(dispatchWorkItem, URL: URL)
    }
    
    // MARK: Private methods
    
    private func cached(forURL URL: URL) -> Data? {
        if let cachedData = Cache.shared.dataForKey(URL.absoluteString) {
            return cachedData
        }
        
        return nil
    }
    
    private func execute(_ item: DispatchWorkItem, URL: URL) {
        items[URL.absoluteString] = item
        DispatchQueue.global(qos: .userInitiated).async(execute: item)
    }
}
