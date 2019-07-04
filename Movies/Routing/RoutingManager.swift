//
//  RoutingManager.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/4/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//

import UIKit
import SafariServices

class RoutingManager: NSObject {
    static let shared = RoutingManager()
    
    public var navigationController: UINavigationController? = nil
    
    func pushOAuthSignIn(url: URL) {
        navigationController?.present(SFSafariViewController(url: url), animated: true, completion: {
            
        })
    }
}
