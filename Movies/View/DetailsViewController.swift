//
//  DetailsViewController.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/6/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var movie: Movie? = nil
    @IBOutlet weak var switcher: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let theMovie = movie, DataManager.shared.favorites.contains(theMovie), switcher.isOn == false {
            switcher.isOn = true
        } else if switcher.isOn == true {
            switcher.isOn = false
        }
    }
    
    @IBAction func switchValueChanged(_ sender: Any) {
        if let theMovie = movie {
            if self.switcher.isOn {
                DataManager.shared.addMovie(movie: theMovie)
            } else {
                DataManager.shared.removeMovie(movie: theMovie)
            }
        }
    }

}
