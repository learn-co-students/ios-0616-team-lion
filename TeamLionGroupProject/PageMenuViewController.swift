//
//  PageMenuViewController.swift
//  TeamLionGroupProject
//
//  Created by David Park on 8/23/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import UIKit

class PageMenuViewController: UIViewController {
	
	var pageMenu : CAPSPageMenu?
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		setupNavBar()
		self.edgesForExtendedLayout = UIRectEdge.None
		self.extendedLayoutIncludesOpaqueBars = false
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		setupPages()

	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	func setupNavBar() {
		
		self.title = "place"
		self.navigationController?.navigationBar.barTintColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
		
		self.navigationController?.navigationBar.translucent = false
		self.navigationController?.navigationBar.barTintColor = UIColor.flatRedColor()
		self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
		self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Noteworthy", size: 30)!]
		
		self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(newPostPressed)), animated: true)
		
	}
	
	func setupPages() {
		
		var controllerArray: [UIViewController] = []
		
		let marketplaceVC = MarketplaceCollectionViewController()
		marketplaceVC.title = "Marketplace"
		marketplaceVC.parentNavigationController = self.navigationController
		
		let profileVC = ProfileViewController()
		profileVC.title = "Profile"
		profileVC.parentNavigationController = self.navigationController
		
		let openChatVC = OpenChatViewController()
		openChatVC.title = "Open Chat"
		openChatVC.parentNavigationController = self.navigationController
		
		controllerArray.append(marketplaceVC)
		controllerArray.append(profileVC)
		controllerArray.append(openChatVC)
		
		let parameters: [CAPSPageMenuOption] = [
			.ScrollMenuBackgroundColor(UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)),
			.ViewBackgroundColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)),
			.SelectionIndicatorColor(UIColor.orangeColor()),
			.BottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
			.MenuItemFont(UIFont(name: "HelveticaNeue", size: 13.0)!),
			.MenuHeight(40.0),
			.MenuItemWidth(90.0),
			.CenterMenuItems(true)
		]
		
		pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
		
		self.view.addSubview(pageMenu!.view)

		
	}
	
	func newPostPressed() {
		
		print("new post from VC")
		let newPostVC = NewPostViewController()
		presentViewController(newPostVC, animated: true, completion: nil)
		
	}
}
