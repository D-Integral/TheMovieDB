//
//  ViewController.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/2/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    let allMoviesTableViewController = AllMoviesTableViewTableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        RoutingManager.shared.navigationController = self.navigationController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AuthorizationManager.shared.authorize() {
            DispatchQueue.main.async {
                self.navigationController?.present(self.allMoviesTableViewController, animated: false, completion: nil)
            }
        }
    }
}
