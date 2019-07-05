//
//  DiscardableCacheItem.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/5/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//

import Foundation

class DiscardableCacheItem: NSObject, NSDiscardableContent {
    
    private(set) public var data: NSData?
    var accessCount: UInt = 0
    
    public init(data aData: NSData) {
        data = aData
    }
    
    public func beginContentAccess() -> Bool {
        if data == nil {
            return false
        }
        
        accessCount += 1
        return true
    }
    
    public func endContentAccess() {
        if accessCount > 0 {
            accessCount -= 1
        }
    }
    
    public func discardContentIfPossible() {
        if accessCount == 0 {
            data = nil
        }
    }
    
    public func isContentDiscarded() -> Bool {
        return data == nil
    }
    
}
