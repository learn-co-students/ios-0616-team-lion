//
//  TabBarController.swift
//  TeamLionGroupProject
//
//  Created by Eldon Chan on 8/8/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
    }
    
    func setupTabs() {
        
        self.tabBar.translucent = true
        self.tabBar.backgroundColor = UIColor.clearColor()
        self.tabBar.tintColor = UIColor.clearColor()
        
        let profile = ProfileViewController()
        profile.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "smileIcon")?.imageWithRenderingMode(.AlwaysOriginal), selectedImage: UIImage(named: "smileIcon")?.imageWithRenderingMode(.AlwaysOriginal))
        profile.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let place = MarketplaceCollectionViewController()
        place.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "shopIcon")?.imageWithRenderingMode(.AlwaysOriginal), selectedImage: UIImage(named: "shopIcon")?.imageWithRenderingMode(.AlwaysOriginal))
        place.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let photo = PhotoViewController()
        photo.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "cameraIcon")?.imageWithRenderingMode(.AlwaysOriginal), selectedImage: UIImage(named: "cameraIcon")?.imageWithRenderingMode(.AlwaysOriginal))
        photo.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let controllers = [place, profile, photo]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
        
    }

}
