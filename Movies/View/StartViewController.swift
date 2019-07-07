//
//  LaunchViewController.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/7/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    @IBOutlet weak var square: UIView!
    var horizontalConstraint: NSLayoutConstraint? = nil
    var verticalConstraint: NSLayoutConstraint? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addConstraints()
    }
    
    private func addConstraints() {
        square.translatesAutoresizingMaskIntoConstraints = false
        
        let theHorizontalConstraint = NSLayoutConstraint(item: square!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        horizontalConstraint = theHorizontalConstraint
        
        let theVerticalConstraint = NSLayoutConstraint(item: square!, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        verticalConstraint = theVerticalConstraint
        
        NSLayoutConstraint.activate([theHorizontalConstraint, theVerticalConstraint])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let this = self else { return }
            
            this.horizontalConstraint?.constant -= this.view.bounds.width / 4
        }
    }
    
}
