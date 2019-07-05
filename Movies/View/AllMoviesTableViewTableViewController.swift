//
//  AllMoviesTableViewTableViewController.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/4/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//

import UIKit

class AllMoviesTableViewTableViewController: UITableViewController {
    
    let movieCellReuseId = "movieCell"
    var movies: [Movie] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(MovieTableViewCell.self as AnyClass, forCellReuseIdentifier: movieCellReuseId)
        
        RoutingManager.shared.navigationController = self.navigationController
        
        PopularMoviesNetworkingService.shared.requestPopularMovies { [weak self] (moviesPage) in
            guard let this = self else { return }
            
            this.movies.append(contentsOf: moviesPage.results)
            
            DispatchQueue.main.async {
                this.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AuthorizationManager.shared.authorize() {
//            DispatchQueue.main.async {
//            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: movieCellReuseId, for: indexPath)

        if let movieCell = cell as? MovieTableViewCell {
            movieCell.update(withMovie: movies[indexPath.row],
                             newIndex: indexPath.row)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    // MARK: - Scroll view delegate
    
    var readyToLoadMore = false
    var lastLoadedPage = 1
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let actualPosition = scrollView.contentOffset.y;
        let readyToLoadMorePoint = scrollView.contentSize.height - self.tableView.frame.size.height * 4;
        let loadMorePoint = scrollView.contentSize.height - self.tableView.frame.size.height * 2;
        
        if actualPosition > readyToLoadMorePoint && actualPosition < loadMorePoint && self.readyToLoadMore == false {
            self.readyToLoadMore = true
        }
        
        if (actualPosition > loadMorePoint && self.readyToLoadMore == true) {
            PopularMoviesNetworkingService.shared.popularMoviesCurrentPage += 1
            PopularMoviesNetworkingService.shared.requestPopularMovies { [weak self] (moviesPage) in
                guard let this = self else { return }
                
                this.movies.append(contentsOf: moviesPage.results)
                
                DispatchQueue.main.async {
                    this.tableView.reloadData()
                }
            }
            self.readyToLoadMore = false
        }
    }
}
