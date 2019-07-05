//
//  MovieTableViewCell.swift
//  Movies
//
//  Created by Dmytro Skorokhod on 7/4/19.
//  Copyright © 2019 Dmytro Skorokhod. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    var movie: Movie? = nil
    let basePosterURL = "https://image.tmdb.org/t/p/w185/"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        let posterUrl = getPosterUrl()
        
        if let thePosterURL = posterUrl, let _ = movie {
            ImageManager.shared.cancel(forURL: thePosterURL)
            movie = nil
        }
        
        imageView?.image = nil
    }
    
    func update(withMovie newMovie: Movie?, newIndex: Int) {
        guard let theNewMovie = newMovie else { return }
        
        movie = theNewMovie
        
        textLabel?.text = theNewMovie.title
        detailTextLabel?.text = theNewMovie.overview
        
        let posterUrl = getPosterUrl()
        
        if let thePosterURL = posterUrl {
            ImageManager.shared.requestImage(URL: thePosterURL) { [weak self]
                data, receivedImageURL in
                guard let this = self else { return }
                let thisCellPosterUrl = this.getPosterUrl()
                if thisCellPosterUrl == receivedImageURL {
                    DispatchQueue.main.async {
                        this.imageView?.image = UIImage(data: data as Data)
                        this.layoutSubviews()
                    }
                }
            }
        }
    }
    
    func getPosterUrl() -> URL? {
        if let posterPath = movie?.poster_path {
            return URL(string: basePosterURL + posterPath)
        }
        
        return nil
    }
}
