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
        DispatchQueue.main.async  { [weak self] in
            guard let this = self else { return }
            
            let safari = SFSafariViewController(url: url)
            safari.delegate = self
            this.navigationController?.present(safari, animated: true, completion: nil)
            this.safariDidFinishCompletion = completionHandler
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        AuthorizationManager.shared.requestSessionID()
        
        if let theCompletion = safariDidFinishCompletion {
            theCompletion()
        }
    }
}
