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
    let searchController = UISearchController(searchResultsController: nil)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()

        tableView.register(MovieTableViewCell.self as AnyClass, forCellReuseIdentifier: movieCellReuseId)
        
        RoutingManager.shared.navigationController = self.navigationController
        
        PopularMoviesNetworkingService.shared.requestPopularMovies { [weak self] (moviesPage) in
            guard let this = self else { return }
            
            DataManager.shared.popularMovies.append(contentsOf: moviesPage.results)
            
            DispatchQueue.main.async {
                this.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        AuthorizationManager.shared.authorize() {
//            AccountNetworkingService.shared.requestAccount({ (account) in
//                print(account)
//
//            })
//        }
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func isSearchBarEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var lastSearch: String? = nil
    
    func filterContentForSearchText(_ searchText: String) {
        lastSearch = searchText
        SearchNetworkingService.shared.requestSearch(searchText) { [weak self] (found) in
            guard let this = self else { return }
            
            DataManager.shared.filteredMovies = found.results
            SearchNetworkingService.shared.currentPage = 1
            
            DispatchQueue.main.async {
                this.tableView.reloadData()
            }
        }
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !isSearchBarEmpty()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return DataManager.shared.filteredMovies.count
        }
        
        return DataManager.shared.popularMovies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: movieCellReuseId, for: indexPath)
        
        var movie: Movie? = nil
        
        if isFiltering() {
            movie = DataManager.shared.filteredMovies[indexPath.row]
        } else {
            movie = DataManager.shared.popularMovies[indexPath.row]
        }

        if let movieCell = cell as? MovieTableViewCell, let theMovie = movie {
            movieCell.update(withMovie: theMovie,
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
            
            if isFiltering() {
                movieDetails.movie = DataManager.shared.filteredMovies[indexPath.row]
            } else {
                movieDetails.movie = DataManager.shared.popularMovies[indexPath.row]
            }
            
            self.navigationController?.pushViewController(movieDetails, animated:true)
        }
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
            
            if isFiltering() {
                
            } else {
                requestAdditionalPopularMovies()
            }
            
            self.readyToLoadMore = false
        }
    }
    
    func requestAdditionalPopularMovies() {
        PopularMoviesNetworkingService.shared.popularMoviesCurrentPage += 1
        PopularMoviesNetworkingService.shared.requestPopularMovies { [weak self] (moviesPage) in
            guard let this = self else { return }
            
            DataManager.shared.popularMovies.append(contentsOf: moviesPage.results)
            
            DispatchQueue.main.async {
                this.tableView.reloadData()
            }
        }
    }
    
    func requestAdditionalFilteredResults() {
        if let searchText = lastSearch {
            SearchNetworkingService.shared.currentPage += 1
            
            SearchNetworkingService.shared.requestSearch(searchText) { [weak self] (moviesPage) in
                guard let this = self else { return }
                
                DataManager.shared.filteredMovies.append(contentsOf: moviesPage.results)
                
                DispatchQueue.main.async {
                    this.tableView.reloadData()
                }
            }
        }
    }
}

extension AllMoviesTableViewTableViewController: UISearchResultsUpdating {
    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        if let theInput = searchController.searchBar.text {
            filterContentForSearchText(theInput)
        }
    }
}
