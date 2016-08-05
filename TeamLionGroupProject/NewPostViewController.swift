//
//  NewPostViewController.swift
//  TeamLionGroupProject
//
//  Created by Eldon Chan on 8/4/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import UIKit
import SnapKit

class NewPostViewController: UIViewController {
	
	var itemNameLabel: UILabel = UILabel()
	var itemNameField: UITextField = UITextField()
//	var itemDescriptionLabel: UILabel!
//	var itemDescriptionField: UITextField!
	var itemPriceLabel: UILabel = UILabel()
	var itemPriceField: UITextField = UITextField()
//	var uploadImageButton: UIButton!
//	var profilePic: UIImage!
//	var postItemButton: UIButton!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		print("New Post VC View Did Load")
		
		generateScene()
		
	}
	
	func generateScene() {
		
		
		view.addSubview(itemNameLabel)
		itemNameLabel.snp_makeConstraints { (make) in
			make.width.equalTo(view.snp_width).dividedBy(2)
			make.centerX.equalTo(view.snp_centerX)
			make.centerY.equalTo(view.snp_centerY).dividedBy(2)
			
		}
		itemNameLabel.text = "Item Name"
		itemNameLabel.textAlignment = .Center
		itemNameLabel.backgroundColor = UIColor.alizarinColor()
		
		view.addSubview(itemNameField)
		itemNameField.snp_makeConstraints { (make) in
			make.width.equalTo(itemNameLabel.snp_width)
			make.top.equalTo(itemNameLabel.snp_bottom)
			make.centerX.equalTo(itemNameLabel.snp_centerX)
			
		}
		itemNameField.placeholder = "Item Name"
		itemNameField.backgroundColor = UIColor.amethystColor()
		
		view.addSubview(itemPriceLabel)
		itemNameLabel.snp_makeConstraints { (make) in
			
		}
		
		
		
		view.addSubview(itemPriceField)
	
		
	}
	
	

}
