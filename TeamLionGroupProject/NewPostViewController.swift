//
//  NewPostViewController.swift
//  TeamLionGroupProject
//
//  Created by Eldon Chan on 8/4/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import UIKit
import SnapKit

class NewPostViewController: UIViewController, UINavigationBarDelegate {
	
	var itemNameLabel: UILabel = UILabel()
	var itemNameField: UITextField = UITextField()
	var itemDescriptionLabel: UILabel = UILabel()
	var itemDescriptionField: UITextView = UITextView()
	var itemPriceLabel: UILabel = UILabel()
	var itemPriceField: UITextField = UITextField()
    
	var uploadImageButton: UIButton = UIButton()
    var takePictureButton: UIButton = UIButton()
	var profilePic = UIImageView()
	var postItemButton: UIButton = UIButton()
	var newPostTextLabel: UILabel = UILabel()
	var cancelButton = UIButton()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		print("New Post VC View Did Load")
		
        view.backgroundColor = UIColor.whiteColor()
		generateScene()
	}
	
	func generateScene() {
		let labelFont = "HelveticaNeue"
		
		view.addSubview(itemNameLabel)
		itemNameLabel.snp_makeConstraints { (make) in
			make.width.equalTo(view.snp_width).dividedBy(2)
			make.centerX.equalTo(view.snp_centerX).multipliedBy(0.7)
			make.centerY.equalTo(view.snp_centerY).dividedBy(2)
			make.height.equalTo(view.snp_height).dividedBy(20)
		}
		itemNameLabel.text = "What are you selling?"
		itemNameLabel.textAlignment = .Center
		//itemNameLabel.backgroundColor = UIColor.alizarinColor()
		itemNameLabel.font = UIFont(name: labelFont, size: 20)
		
		view.addSubview(itemNameField)
		itemNameField.snp_makeConstraints { (make) in
			make.width.equalTo(itemNameLabel.snp_width)
			make.top.equalTo(itemNameLabel.snp_bottom).offset(1)
			make.centerX.equalTo(itemNameLabel.snp_centerX)
			make.height.equalTo(view.snp_height).dividedBy(20)
		}
		itemNameField.placeholder = "Item Name"
		itemNameField.backgroundColor = UIColor.cloudsColor()
		itemNameField.font = UIFont(name: labelFont, size: 20)
		
		view.addSubview(itemPriceLabel)
		itemPriceLabel.snp_makeConstraints { (make) in
			make.width.equalTo(itemNameLabel.snp_width).dividedBy(2)
			make.centerY.equalTo(itemNameLabel.snp_centerY)
			make.left.equalTo(itemNameLabel.snp_right).offset(10)
			make.height.equalTo(view.snp_height).dividedBy(20)
		}
		//itemPriceLabel.backgroundColor = UIColor.peterRiverColor()
		itemPriceLabel.text = "Price"
		itemPriceLabel.font = UIFont(name: labelFont, size: 20)
		
		view.addSubview(itemPriceField)
		itemPriceField.snp_makeConstraints { (make) in
			make.width.equalTo(itemPriceLabel.snp_width)
			make.centerX.equalTo(itemPriceLabel.snp_centerX)
			make.centerY.equalTo(itemNameField.snp_centerY)
			make.height.equalTo(view.snp_height).dividedBy(20)
		}
		itemPriceField.backgroundColor = UIColor.cloudsColor()
		itemPriceField.placeholder = "price"
		itemPriceField.font = UIFont(name: labelFont, size: 20)
		
		view.addSubview(itemDescriptionLabel)
		itemDescriptionLabel.snp_makeConstraints { (make) in
			make.left.equalTo(itemNameLabel.snp_left)
			make.right.equalTo(itemPriceLabel.snp_right)
			make.height.equalTo(view.snp_height).dividedBy(20)
			make.top.equalTo(itemNameField.snp_bottom).offset(10)
		}
		//itemDescriptionLabel.backgroundColor = UIColor.carrotColor()
		itemDescriptionLabel.text = "Item Description"
		itemDescriptionLabel.font = UIFont(name: labelFont, size: 20)
		
		view.addSubview(itemDescriptionField)
		itemDescriptionField.snp_makeConstraints { (make) in
			make.top.equalTo(itemDescriptionLabel.snp_bottom).offset(1)
			make.width.equalTo(itemDescriptionLabel.snp_width)
			make.height.equalTo(view.snp_height).dividedBy(4)
			make.centerX.equalTo(itemDescriptionLabel.snp_centerX)
		}
		itemDescriptionField.backgroundColor = UIColor.peterRiverColor()
		itemDescriptionField.text  = "Buy my really cool thing"
		itemDescriptionField.font = UIFont(name: labelFont, size: 20)
		
		view.addSubview(uploadImageButton)
		uploadImageButton.snp_makeConstraints { (make) in
			make.top.equalTo(itemDescriptionField.snp_bottom).offset(10)
			make.width.equalTo(itemDescriptionField.snp_width).dividedBy(2)
			make.height.equalTo(itemDescriptionField.snp_height).dividedBy(2)
			make.centerX.equalTo(itemDescriptionField.snp_centerX).offset(-80)
		}
		uploadImageButton.backgroundColor = UIColor.magentaColor()
		uploadImageButton.layer.cornerRadius = view.frame.height/16
		uploadImageButton.setTitle("Upload Images", forState: .Normal)
		uploadImageButton.addTarget(self, action: #selector(uploadImagesButtonPressed), forControlEvents: .TouchUpInside)
        
        view.addSubview(takePictureButton)
        takePictureButton.snp_makeConstraints { (make) in
            make.top.equalTo(itemDescriptionField.snp_bottom).offset(10)
            make.width.equalTo(itemDescriptionField.snp_width).dividedBy(2)
            make.height.equalTo(itemDescriptionField.snp_height).dividedBy(2)
            make.centerX.equalTo(itemDescriptionField.snp_centerX).offset(80)
        }
        takePictureButton.backgroundColor = UIColor.alizarinColor()
        takePictureButton.layer.cornerRadius = view.frame.height/16
        takePictureButton.setTitle("Take Picture", forState: .Normal)
        takePictureButton.addTarget(self, action: #selector(takePictureButtonPressed), forControlEvents: .TouchUpInside)
		
		
		view.addSubview(postItemButton)
		postItemButton.snp_makeConstraints { (make) in
			make.left.equalTo(itemDescriptionField.snp_left)
			make.right.equalTo(itemDescriptionField.snp_right)
			make.top.equalTo(uploadImageButton.snp_bottom).offset(10)
			make.bottom.equalTo(view.snp_bottom).offset(-40)
		}
		postItemButton.backgroundColor = UIColor.darkGrayColor()
		postItemButton.setTitle("Sell It 🙌", forState: .Normal)
		postItemButton.layer.cornerRadius = 20
		postItemButton.titleLabel!.font = UIFont(name: labelFont, size: 40)
		
		view.addSubview(profilePic)
		profilePic.snp_makeConstraints { (make) in
			make.left.equalTo(view.snp_left).offset(20)
			make.bottom.equalTo(itemNameLabel.snp_top).offset(-10)
			make.width.equalTo(view.snp_width).dividedBy(4)
			make.height.equalTo(view.snp_width).dividedBy(4)
		}
		profilePic.image = UIImage(named: "david")!.circle
		
		view.addSubview(newPostTextLabel)
		newPostTextLabel.snp_makeConstraints { (make) in
			make.left.equalTo(profilePic.snp_right).offset(10)
			make.centerY.equalTo(profilePic.snp_centerY)
			make.height.equalTo(profilePic.snp_height)
			make.right.equalTo(itemPriceLabel.snp_right)
		}
		//newPostTextLabel.backgroundColor = UIColor.lightGrayColor()
		newPostTextLabel.text = "New Post"
		newPostTextLabel.textAlignment = .Center
		newPostTextLabel.font = UIFont(name: labelFont, size: 40)
        
        view.addSubview(cancelButton)
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        cancelButton.addTarget(self, action: #selector(NewPostViewController.cancelButtonTapped(_:)), forControlEvents: .TouchUpInside)
        cancelButton.snp_makeConstraints { (make) in
            make.right.equalTo(view.snp_right).offset(-30)
            make.top.equalTo(view.topAnchor).offset(30)
        }
		
	}
	
	func uploadImagesButtonPressed() {
		print("Upload pressed")
	}
	
	func sellItButtonPressed() {
		print("Sell It pressed")
		//alert "Are you sure you want to post (item Name) for (price)?
	}
    
    func takePictureButtonPressed(){
        print("Take Picture pressed")
        
        presentViewController(PhotoViewController(), animated: true, completion: nil)
        
    }
    
    func cancelButtonTapped(sender: UIBarButtonItem) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
	

}
