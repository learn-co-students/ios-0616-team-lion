//
//  TabBarController.swift
//  TeamLionGroupProject
//
//  Created by Eldon Chan on 8/8/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import UIKit
//import ChameleonFramework

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
    }
    
    func setupTabs() {
        
        self.tabBar.translucent = true
        self.tabBar.backgroundColor = UIColor.clearColor()
        self.tabBar.tintColor = UIColor.clearColor()
		
		let openChat = OpenChatViewController()
		openChat.tabBarItem = UITabBarItem(title:nil, image: UIImage(named: "chatUnselected")?.imageWithRenderingMode(.AlwaysOriginal), selectedImage: UIImage(named: "chatSelected")?.imageWithRenderingMode(.AlwaysOriginal))
		openChat.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
		
        let profile = ProfileViewController()
        //let profile = LoginViewController()
        profile.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "profileUnselected")?.imageWithRenderingMode(.AlwaysOriginal), selectedImage: UIImage(named: "profileSelected")?.imageWithRenderingMode(.AlwaysOriginal))
        profile.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let place = MarketplaceCollectionViewController()
        place.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "placeUnselected")?.imageWithRenderingMode(.AlwaysOriginal), selectedImage: UIImage(named: "placeSelected")?.imageWithRenderingMode(.AlwaysOriginal))
        place.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let controllers = [place, profile, openChat]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
		self.selectedIndex = 0
        
    }

}
