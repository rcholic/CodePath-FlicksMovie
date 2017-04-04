//
//  UIImageView+Ext.swift
//  FlicksMovies
//
//  Created by Wang, Guoliang (Tony) on 4/4/17.
//  Copyright © 2017 Guoliang Wang. All rights reserved.
//

import UIKit
import AFNetworking

extension UIImageView {
    
    func fadeInImageWith(remoteImgUrl imageUrl: String?, placeholderImage: UIImage?) {
        
        if let imageUrl = imageUrl {
            
            if let url = URL(string: imageUrl) {
                let imageRequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 120) // keep 2 minutes in cache
                
                self.setImageWith(imageRequest, placeholderImage: placeholderImage, success: { (imageRequest: URLRequest, imageResponse: HTTPURLResponse?, image: UIImage) in
                    
                    OperationQueue.main.addOperation({
                        if let _ = imageResponse {
                            self.alpha = 0.0
                            self.image = image
                            UIView.animate(withDuration: 0.3, animations: {
                                self.alpha = 1.0
                            })
                        } else {
                            self.image = image
                        }
                    })
                    
                }, failure: { (imageRequest, imageResponse, error) in
                    self.image = placeholderImage // use the placeholder image upon failure, fail silently here
                })
            }
        }
    }
}
