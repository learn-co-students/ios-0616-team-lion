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
        profile.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "smileIcon")?.imageWithRenderingMode(.AlwaysOriginal), selectedImage: UIImage(named: "smileIcon")?.imageWithRenderingMode(.AlwaysOriginal))
        
        let place = MarketplaceCollectionViewController()
        place.tabBarItem = UITabBarItem(title: "Place", image: UIImage(named: "shopIcon")?.imageWithRenderingMode(.AlwaysOriginal), selectedImage: UIImage(named: "shopIcon")?.imageWithRenderingMode(.AlwaysOriginal))
        
        let controllers = [place, profile]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
        
    }

}
