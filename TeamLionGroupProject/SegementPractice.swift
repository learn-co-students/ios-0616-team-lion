//
//  SegementPractice.swift
//  TeamLionGroupProject
//
//  Created by David Park on 8/9/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import UIKit

class SegementPractice: UIViewController {
	
	override func loadView() {
		super.loadView()
		self.view.backgroundColor = UIColor.purpleColor()
		print("view did load")
		
		//Initialize
		let items = ["Purple", "Green", "Blue"]
		let customSC = UISegmentedControl(items: items)
		customSC.selectedSegmentIndex = 0
		
		//Set up Frame and Segmented Control
		let frame = UIScreen.mainScreen().bounds
		customSC.frame = CGRectMake(frame.minX + 10, frame.minY + 50, frame.width - 20, frame.height*0.1)
		
		//Style the Segmented Control
		customSC.layer.cornerRadius = 5
		customSC.backgroundColor = UIColor.blackColor()
		customSC.tintColor = UIColor.whiteColor()
	
		//Add target action method
		customSC.addTarget(self, action: #selector(changeView), forControlEvents: .ValueChanged)
		
		//Add SegmentedControl to view
		view.addSubview(customSC)
	}
	
	func changeView(sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 1:
			view.backgroundColor = UIColor.greenColor()
		case 2:
			view.backgroundColor = UIColor.blueColor()
		default:
			view.backgroundColor = UIColor.purpleColor()
		}
	}
	
	override func viewDidLoad() {
		 super.viewDidLoad()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

}



