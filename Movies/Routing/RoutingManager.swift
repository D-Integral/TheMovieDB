//
//  RoutingManager.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/4/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//

import UIKit
import SafariServices

class RoutingManager: NSObject, SFSafariViewControllerDelegate {
    static let shared = RoutingManager()
    
    public var navigationController: UINavigationController? = nil
    private var safariDidFinishCompletion: (() -> Void)? = nil
    
    func pushOAuthSignIn(url: URL, completionHandler: @escaping () -> Void) {
        let safari = SFSafariViewController(url: url)
        safari.delegate = self
        navigationController?.present(safari, animated: true, completion: nil)
        safariDidFinishCompletion = completionHandler
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        AuthorizationManager.shared.requestSessionID()
        
        if let theCompletion = safariDidFinishCompletion {
            theCompletion()
        }
    }
}
