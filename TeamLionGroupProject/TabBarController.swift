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
        
        let item1 = ProfileViewController()
        item1.tabBarItem = UITabBarItem(title: "Profile", image: nil, selectedImage: nil)
        
        let item2 = MarketplaceCollectionViewController()
        item2.tabBarItem = UITabBarItem(title: "Place", image: nil, selectedImage: nil)
        
        let controllers = [item2, item1]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
        
    }

}
