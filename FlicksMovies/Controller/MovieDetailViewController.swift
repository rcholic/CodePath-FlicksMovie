//
//  MovieDetailViewController.swift
//  FlicksMovies
//
//  Created by Guoliang Wang on 4/1/17.
//  Copyright © 2017 Guoliang Wang. All rights reserved.
//

import UIKit
import AFNetworking

class MovieDetailViewController: UIViewController {

    let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: SCREEN_HEIGHT - NAVBAR_HEIGHT, width: SCREEN_WIDTH, height: NAVBAR_HEIGHT))
    
    var movie: Movie?
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBottomNavbar()
        setupView()
    }
    
    private func setupView() {
        
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        // CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        scrollView.delegate = self
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 0.8
        overviewLabel.sizeToFit()
        overviewLabel.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        
        guard let curMovie = movie else { return }
        
        if let overview = curMovie.overview {
            overviewLabel.text = overview
        }
        
        if let posterImagePath = curMovie.posterPath {
            
            let smallImagePath = "\(MEDIUM_POSTER_IMAGE_BASE_URL)\(posterImagePath)"
            
            let largeImagePath = "\(LARGE_POSTER_IMAGE_BASE_URL)\(posterImagePath)"
            
            let smallImageRequest = URLRequest(url: URL(string: smallImagePath)!)
            let largeImageRequest = URLRequest(url: URL(string: largeImagePath)!)
            
            self.posterImageView.setImageWith(smallImageRequest,
                    placeholderImage: nil,
                    success: { (smallRequest, smallRespose, smallImage) in
                        self.posterImageView.alpha = 0.0
                        self.posterImageView.image = smallImage
                        
                        UIView.animate(withDuration: 0.3, animations: { 
                            self.posterImageView.alpha = 1.0
                        }, completion: { (done) in
                            self.posterImageView.setImageWith(largeImageRequest, placeholderImage: nil, success: { (largeRequest, largeResponse, largeImage) in
                                
                                self.posterImageView.image = largeImage
                            }, failure: { (bigReq, bigRes, error) in
                                AlertUtil.shared.show(message: "Error In Network Access", viewcontroller: nil, autoClose: true, delay: 5.0)
                            })
                        })
                  }, failure: { (smallReq, smallRes, error) in
                        AlertUtil.shared.show(message: "Error In Network Access", viewcontroller: nil, autoClose: true, delay: 5.0)
            })
        }
    }
    
    @objc private func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupBottomNavbar() {
        
        self.view.addSubview(navBar)
        let backarrowImage = UIImage(named: "ic_arrow_back")
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: backarrowImage!.size.width, height: backarrowImage!.size.height))
        backButton.setBackgroundImage(backarrowImage, for: .normal)
        backButton.addTarget(self, action: #selector(self.dismissView(_:)), for: .touchUpInside)
        backButton.showsTouchWhenHighlighted = true
        
        let backItem = UIBarButtonItem.init(image: backarrowImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.dismissView(_:)))

        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = backItem
        navBar.setItems([navItem], animated: false)
    }
}

extension MovieDetailViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.posterImageView
    }
    

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.8) {
            self.overviewLabel.alpha = 1.0
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.5) {
            self.overviewLabel.alpha = 0.0
        }
    }
}