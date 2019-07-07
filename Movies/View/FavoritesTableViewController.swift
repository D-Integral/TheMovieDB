//
//  FavoritesTableViewController.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/6/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {

    let movieCellReuseId = "movieCell"
    
    public var favoritesArray: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MovieTableViewCell.self as AnyClass, forCellReuseIdentifier: movieCellReuseId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.favoritesArray = DataManager.shared.favoritesArray()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AuthorizationManager.shared.authorize() {
            AccountNetworkingService.shared.requestAccount({ (account) in
                print(account)
                
            })
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DataManager.shared.favorites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: movieCellReuseId, for: indexPath)
        
        if let movieCell = cell as? MovieTableViewCell {
            movieCell.update(withMovie: favoritesArray[indexPath.row],
                             newIndex: indexPath.row)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let movieDetails = storyboard.instantiateViewController(withIdentifier: "MovieDetails") as? DetailsViewController {
            movieDetails.movie = favoritesArray[indexPath.row]
            self.navigationController?.pushViewController(movieDetails, animated:true)
        }
    }
}
