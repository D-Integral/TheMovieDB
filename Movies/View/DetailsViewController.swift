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
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var originalLanguageLabel: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var isFavoriteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addConstraints()
        
        if let theMovie = movie {
            if DataManager.shared.favorites.contains(theMovie) {
                switcher.isOn = true
            } else {
                switcher.isOn = false
            }
            
            titleLabel.text = theMovie.title
            overviewLabel.text = theMovie.overview
            releaseDateLabel.text = theMovie.release_date
            originalLanguageLabel.text = theMovie.original_language
            requestImage()
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
    
    let basePosterURL = "https://image.tmdb.org/t/p/w185/"
    
    func getPosterUrl() -> URL? {
        if let posterPath = movie?.poster_path {
            return URL(string: basePosterURL + posterPath)
        }
        
        return nil
    }
    
    func requestImage() {
        let posterUrl = getPosterUrl()
        
        if let thePosterURL = posterUrl {
            ImageManager.shared.requestImage(URL: thePosterURL) { [weak self]
                data, receivedImageURL in
                guard let this = self else { return }
                let thisControllerPosterUrl = this.getPosterUrl()
                if thisControllerPosterUrl == receivedImageURL {
                    DispatchQueue.main.async {
                        this.poster?.image = UIImage(data: data as Data)
                    }
                }
            }
        }
    }
    
    private func addConstraints() {
        addPosterConstraints()
        addTitleLabelConstraints()
        addOverviewLabelConstraints()
        addReleaseDateLabelConstraints()
        addOriginalLanguageLabelConstraints()
        addSwitcherConstraints()
        addIsFavoriteLabelConstraints()
    }
    
    private func addPosterConstraints() {
        poster.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: poster!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: poster!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.topMargin, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([horizontalConstraint, topConstraint])
    }
    
    private func addTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: titleLabel!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: titleLabel!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: poster, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: titleLabel!, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leftMargin, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: titleLabel!, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.rightMargin, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([horizontalConstraint, topConstraint, leftConstraint, rightConstraint])
    }
    
    private func addOverviewLabelConstraints() {
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: overviewLabel!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: overviewLabel!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: titleLabel, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: overviewLabel!, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leftMargin, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: overviewLabel!, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.rightMargin, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([horizontalConstraint, topConstraint, leftConstraint, rightConstraint])
    }
    
    private func addReleaseDateLabelConstraints() {
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: releaseDateLabel!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: releaseDateLabel!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: overviewLabel, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: releaseDateLabel!, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leftMargin, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: releaseDateLabel!, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.rightMargin, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([horizontalConstraint, topConstraint, leftConstraint, rightConstraint])
    }
    
    private func addOriginalLanguageLabelConstraints() {
        originalLanguageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: originalLanguageLabel!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: originalLanguageLabel!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: releaseDateLabel, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: originalLanguageLabel!, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leftMargin, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: originalLanguageLabel!, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.rightMargin, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([horizontalConstraint, topConstraint, leftConstraint, rightConstraint])
    }

    private func addSwitcherConstraints() {
        switcher.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: switcher!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: switcher!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: originalLanguageLabel, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([horizontalConstraint, topConstraint])
    }
    
    private func addIsFavoriteLabelConstraints() {
        isFavoriteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: isFavoriteLabel!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: isFavoriteLabel!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: switcher, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([horizontalConstraint, topConstraint])
    }
    
}
