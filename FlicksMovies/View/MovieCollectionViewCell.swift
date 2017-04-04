//
//  MovieCollectionViewCell.swift
//  FlicksMovies
//
//  Created by Guoliang Wang on 4/3/17.
//  Copyright © 2017 Guoliang Wang. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {

        self.posterImageView.layer.shadowColor = UIColor.black.cgColor
        self.posterImageView.layer.shadowOffset = CGSize(width: 0.5, height: 1.5)
        self.posterImageView.layer.shadowRadius = 3.0
        self.posterImageView.layer.shadowOpacity = 1
        self.posterImageView.clipsToBounds = false
    }
    
    public func bind(_ movie: Movie) {
        
        if let posterImagePath = movie.posterPath {
            
            let smallImagePath = "\(SMALL_POSTER_IMAGE_BASE_URL)\(posterImagePath)"
            posterImageView.fadeInImageWith(remoteImgUrl: smallImagePath, placeholderImage: nil)
            // TODO: load placeholder image for movie without posters
        }
    }

}
