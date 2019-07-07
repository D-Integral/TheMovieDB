//
//  SplitManager.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/7/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//

import UIKit

enum SplitGroup {
    case first
    case second
}

class SplitManager: NSObject {
    
    public static let shared = SplitManager()
    
    public var splitGroup: SplitGroup? = nil
    
    public func generateRandomSplitGroup() {
        let randomDouble = Double.random(in: 0...1)
        
        if randomDouble < 0.5 {
            splitGroup = .first
        } else {
            splitGroup = .second
        }
    }
}
