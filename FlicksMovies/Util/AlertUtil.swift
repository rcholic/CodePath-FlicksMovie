//
//  AlertUtil.swift
//  FlicksMovies
//
//  Created by Guoliang Wang on 4/1/17.
//  Copyright © 2017 Guoliang Wang. All rights reserved.
//

import Foundation
import UIKit

struct AlertUtil {
    
    public static let shared = AlertUtil()
    
    private let warningView = WarningView(info: "", frame: CGRect(x: 0, y: NAVBAR_HEIGHT, width: SCREEN_WIDTH, height: NAVBAR_HEIGHT))
    
    func show(message: String, viewcontroller: UIViewController, autoClose: Bool, delay time: TimeInterval) {

        warningView.infoText = message
        
        warningView.isHidden = false
        if let keywindow = UIApplication.shared.keyWindow {

            keywindow.addSubview(warningView)
            keywindow.bringSubview(toFront: warningView)

//            keywindow.rootViewController?.view.addSubview(warningView)
//            keywindow.rootViewController?.view.bringSubview(toFront: warningView)
        } else {
            viewcontroller.view.addSubview(warningView)
            viewcontroller.view.bringSubview(toFront: warningView)
        }
        
        if autoClose {
            UIView.animate(withDuration: 0.5, delay:
                time, options: UIViewAnimationOptions.transitionFlipFromTop, animations: {
                    self.warningView.alpha = 0.0
            }) { (done) in
                self.warningView.removeFromSuperview()
            }
        }
    }
    
    func hide() {
        warningView.removeFromSuperview()
    }
}
