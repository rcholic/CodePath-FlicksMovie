//
//  CustomTabBarViewController.swift
//  FlicksMovies
//
//  Created by Guoliang Wang on 3/31/17.
//  Copyright © 2017 Guoliang Wang. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = NAVIGATIONBAR_COLOR
        tabBar.frame = CGRect(x: 0, y: SCREEN_HEIGHT - TABBAR_HEIGHT, width: SCREEN_WIDTH, height: TABBAR_HEIGHT)
        addAllChildViewControllers()
    }
    
    private func addAllChildViewControllers() {
        let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let nowPlayingVC = mainStoryBoard.instantiateViewController(withIdentifier: "NowPlaying") as! NowPlayingViewController
        
        addChildViewController(nowPlayingVC, title: "Now Playing", imageName: "now_playing_normal", selectedImageName: "now_playing_highlighted")
        
        let topRatedVC = mainStoryBoard.instantiateViewController(withIdentifier: "TopRated") as! TopRatedViewController
        addChildViewController(topRatedVC, title: "Top Rated", imageName: "top_rated_normal", selectedImageName: "top_rated_highlighted")
    }
    
    private func addChildViewController(_ childController: UIViewController, title: String, imageName: String, selectedImageName: String) {
        
        childController.title = title
        childController.tabBarItem.title = title
        childController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4)
        childController.tabBarItem.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 11)], for: .normal)
        childController.tabBarItem.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 14)], for: .selected)
        childController.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        childController.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        childController.tabBarItem.setTitleTextAttributes(
            [NSForegroundColorAttributeName: HIGHLIGHTED_FONT_COLOR], for: UIControlState.selected)
        
//        childController.navigationController?.navigationBar.isHidden = true // hide navigation bar
        addChildViewController(childController)
    }

}
