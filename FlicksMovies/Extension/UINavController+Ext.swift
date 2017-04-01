//
//  UINavController+Ext.swift
//  FlicksMovies
//
//  Created by Guoliang Wang on 4/1/17.
//  Copyright © 2017 Guoliang Wang. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    // MARK: hide the tabbar when pushing in viewcontroller
    func pushViewControllerWithTabbarHidden(_ viewController: UIViewController, animated: Bool) {
        
        viewController.hidesBottomBarWhenPushed = true
        pushViewController(viewController, animated: animated)
    }
}
