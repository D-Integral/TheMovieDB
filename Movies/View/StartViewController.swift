//
//  LaunchViewController.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/7/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var square: UIView!
    
    var horizontalConstraint: NSLayoutConstraint? = nil
    var verticalConstraint: NSLayoutConstraint? = nil
    
    var widthConstraint: NSLayoutConstraint? = nil
    var heightConstraint: NSLayoutConstraint? = nil
    
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
        
        let theWidthConstraint = NSLayoutConstraint(item: square!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        widthConstraint = theWidthConstraint
        
        let theHeightConstraint = NSLayoutConstraint(item: square!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        heightConstraint = theHeightConstraint
        
        NSLayoutConstraint.activate([theHorizontalConstraint, theVerticalConstraint, theWidthConstraint, theHeightConstraint])
        
        addMoveToTheLeft()
    }
    
    func addMoveToTheLeft() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let this = self else { return }
            
            UIView.animate(withDuration: 0.2, animations: {
                if let theOldHorizontalConstraint = this.horizontalConstraint {
                    NSLayoutConstraint.deactivate([theOldHorizontalConstraint])
                }
                
                let theNewHorizontalConstraint = NSLayoutConstraint(item: this.square!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: this.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: -(this.view.bounds.width / 4))
                this.horizontalConstraint = theNewHorizontalConstraint
                NSLayoutConstraint.activate([theNewHorizontalConstraint])
                this.view.layoutIfNeeded()
            })
            
            this.addMoveToTheRight()
        }
    }
    
    func addMoveToTheRight() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let this = self else { return }
            
            UIView.animate(withDuration: 0.2, animations: {
                if let theOldHorizontalConstraint = this.horizontalConstraint {
                    NSLayoutConstraint.deactivate([theOldHorizontalConstraint])
                }
                
                let theNewHorizontalConstraint = NSLayoutConstraint(item: this.square!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: this.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: (this.view.bounds.width / 4))
                this.horizontalConstraint = theNewHorizontalConstraint
                NSLayoutConstraint.activate([theNewHorizontalConstraint])
                this.view.layoutIfNeeded()
            })
            
            this.addMoveToTheCenter()
        }
    }
    
    func addMoveToTheCenter() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let this = self else { return }
            
            UIView.animate(withDuration: 0.2, animations: {
                if let theOldHorizontalConstraint = this.horizontalConstraint {
                    NSLayoutConstraint.deactivate([theOldHorizontalConstraint])
                }
                
                let theNewHorizontalConstraint = NSLayoutConstraint(item: this.square!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: this.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
                this.horizontalConstraint = theNewHorizontalConstraint
                NSLayoutConstraint.activate([theNewHorizontalConstraint])
                this.view.layoutIfNeeded()
            })
            
            this.addSplitGroupAnimation1()
        }
    }
    
    func addSplitGroupAnimation1() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let this = self else { return }
            
            UIView.animate(withDuration: 0.2, animations: {
                this.square.layer.cornerRadius = this.square.bounds.width / 2;
                this.square.layer.masksToBounds = true;
                this.view.layoutIfNeeded()
            })
            
            this.addColorChange()
        }
    }
    
    func addColorChange() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let this = self else { return }
            
            UIView.animate(withDuration: 0.2, animations: {
                this.square.backgroundColor = UIColor.blue
                this.view.layoutIfNeeded()
            })
            
            this.addSplitGroupAnimation1()
        }
    }
    
}
