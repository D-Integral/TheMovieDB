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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        RoutingManager.shared.navigationController = self.navigationController
        
        APIClient.shared.requestToken()
    }
}
