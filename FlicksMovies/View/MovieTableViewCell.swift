//
//  MovieTableViewCell.swift
//  FlicksMovies
//
//  Created by Guoliang Wang on 4/1/17.
//  Copyright © 2017 Guoliang Wang. All rights reserved.
//

import UIKit
import AFNetworking

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        self.contentView.backgroundColor = CELL_SEPARATOR_COLOR
    }
    
    override func layoutSubviews() {
//        self.descLabel.sizeToFit()
        self.titleLabel.sizeToFit()
        self.posterImageView.layer.shadowColor = UIColor.black.cgColor
        self.posterImageView.layer.shadowOffset = CGSize(width: 0.5, height: 1.5)
        self.posterImageView.layer.shadowRadius = 3.0
        self.posterImageView.layer.shadowOpacity = 1
        self.posterImageView.clipsToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func bind(_ movie: Movie) {
        
        if let posterImagePath = movie.posterPath {
            
            let smallImagePath = "\(SMALL_POSTER_IMAGE_BASE_URL)\(posterImagePath)"
            
            if let url = URL(string: smallImagePath) {
                let imageRequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 300) // keep 5 minutes
                
                posterImageView.setImageWith(imageRequest, placeholderImage: nil, success: { (imageRequest: URLRequest, imageResponse: HTTPURLResponse?, image: UIImage) in
                    
                    OperationQueue.main.addOperation({ 
                        if let _ = imageResponse {
                            self.posterImageView.alpha = 0.0
                            self.posterImageView.image = image
                            UIView.animate(withDuration: 0.3, animations: {
                                self.posterImageView.alpha = 1.0
                            })
                        } else {
                            self.posterImageView.image = image
                        }
                    })
                    
                }, failure: { (imageRequest, imageResponse, error) in
                    // TODO: on error, just load placeholder image
                })
                
            }
            // TODO: load placeholder image for movie without posters
        }
        
        if let title = movie.title {
            self.titleLabel.text = title
        }
        
        if let overview = movie.overview {
            self.descLabel.text = overview
        }
    }

}
