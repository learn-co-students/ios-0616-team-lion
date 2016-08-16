//
//  NewPostViewController.swift
//  TeamLionGroupProject
//
//  Created by Eldon Chan on 8/4/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import UIKit
import SnapKit
import DynamicButton
import CCTextFieldEffects

class NewPostViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
	let datastore = PlaceUserDataStore.sharedDataStore
    var itemNameField = ChisatoTextField()
	var itemDescriptionTextField = ChisatoTextField()
	var itemDescriptionField = UITextView()
	var itemPriceField = ChisatoTextField()
    
	var uploadImageButton = UIButton()
    var takePictureButton = UIButton()
	var profilePic = UIImageView()
	var postItemButton = DynamicButton()
	var newPostTextLabel = UILabel()
	let cancelButton = DynamicButton()
    
    let roundSquare = UIImageView()
    
    let topFrame = UIImageView()
    let pictureFrame = UIImageView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		print("New Post VC View Did Load")
        self.datastore.fetchPosts()
        print("@@@@from the view\(CurrentUser.postings)")
        itemDescriptionTextField.delegate = self
        itemDescriptionField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

		generateScene()
	}
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

	
	
	func uploadImagesButtonPressed() {
		print("Upload pressed")
	}
	
	func sellItButtonPressed() {
		print("Sell It pressed")
		//alert "Are you sure you want to post (item Name) for (price)?
        let alertController = UIAlertController(title: "Confirm", message: "Confirm your post?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            let post = PlacePost(itemImages: [UIImage(named: "pictureFrame")!], itemTitle: self.itemNameField.text!, itemDescription: self.itemDescriptionField.text, price: Int(self.itemPriceField.text!)!)
            let pic = UIImage(named: "pictureFrame")
            self.datastore.postPictureToDatabase(pic!, title: self.itemNameField.text!, desciption: self.itemDescriptionField.text, price: self.itemPriceField.text!)
           let array =  self.datastore.fetchPosts()
            print("array from the view \(array)")
            //CurrentUser.postings.append(post)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true) {
            // ...
        }
        
    
	}
    
    func takePictureButtonPressed(){
        print("Take Picture pressed")
        
        presentViewController(PhotoViewController(), animated: true, completion: nil)
        
    }
    
    func cancelButtonTapped() {
            
        self.dismissViewControllerAnimated(true, completion: nil)
            
    }
    
    func generateScene() {
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(topFrame)
        topFrame.backgroundColor = UIColor.whiteColor()
        topFrame.snp_makeConstraints { (make) in
            make.top.equalTo(view.snp_top)
            make.width.equalTo(view.snp_width)
            make.height.equalTo(view.snp_width).dividedBy(7)
        }
        
        view.addSubview(profilePic)
        profilePic.image = UIImage(named: "david")!.circle
        profilePic.snp_makeConstraints { (make) in
            make.top.equalTo(topFrame.snp_bottom).offset(40)
            make.left.equalTo(view.snp_left).offset(20)
            make.width.equalTo(view.snp_width).dividedBy(4)
            make.height.equalTo(view.snp_width).dividedBy(4)
        }
        
        view.addSubview(pictureFrame)
        pictureFrame.image = UIImage(named: "pictureFrame")
        pictureFrame.snp_makeConstraints { (make) in
            make.bottom.equalTo(profilePic.snp_bottom).offset(10)
            make.right.equalTo(view.snp_right).offset(-20)
            make.width.equalTo(profilePic.snp_width).multipliedBy(2.25)
            make.height.equalTo(profilePic.snp_width).multipliedBy(1.50)
        }
        
        view.addSubview(takePictureButton)
        takePictureButton.setTitle("Take Picture", forState: .Normal)
        takePictureButton.setTitleColor(UIColor.peterRiverColor(), forState: .Normal)
        takePictureButton.addTarget(self, action: #selector(takePictureButtonPressed), forControlEvents: .TouchUpInside)
        takePictureButton.snp_makeConstraints { (make) in
            make.centerY.equalTo(pictureFrame.snp_centerY)
            make.centerX.equalTo(pictureFrame.snp_centerX)
        }
        
        view.addSubview(cancelButton)
        cancelButton.setStyle(DynamicButtonStyle.Rewind, animated: true)
        cancelButton.strokeColor = UIColor.peterRiverColor()
        cancelButton.highlightStokeColor = UIColor.redColor()
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), forControlEvents: .TouchUpInside)
        cancelButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(topFrame.snp_centerX).offset(-160)
            make.centerY.equalTo(topFrame.snp_centerY).offset(10)
            make.width.equalTo(topFrame.snp_width).dividedBy(12)
            make.height.equalTo(topFrame.snp_width).dividedBy(12)
            
        }
        
        view.addSubview(itemNameField)
        itemNameField.placeholder = "Item Name"
        itemNameField.borderColor = UIColor.redColor()
        itemNameField.activeColor = UIColor.peterRiverColor()
        itemNameField.textColor = UIColor.blackColor()
        itemNameField.snp_makeConstraints { (make) in
            make.top.equalTo(profilePic.snp_bottom).offset(4)
            make.left.equalTo(view.snp_left).offset(20)
            make.width.equalTo(view.snp_width).dividedBy(1.5)
            make.height.equalTo(view.snp_width).dividedBy(7)
        }
        
        
        view.addSubview(itemPriceField)
        itemPriceField.placeholder = "Price"
        itemPriceField.borderColor = UIColor.redColor()
        itemPriceField.activeColor = UIColor.peterRiverColor()
        itemPriceField.textColor = UIColor.blackColor()
        itemPriceField.keyboardType = UIKeyboardType.NumberPad
        itemPriceField.snp_makeConstraints { (make) in
            make.left.equalTo(itemNameField.snp_right).offset(2)
            make.right.equalTo(view.snp_right).offset(-20)
            make.top.equalTo(itemNameField.snp_top)
            make.height.equalTo(itemNameField.snp_height)
        }
        
        view.addSubview(itemDescriptionTextField)
        itemDescriptionTextField.text = " "
        itemDescriptionTextField.placeholderColor = UIColor.peterRiverColor()
        itemDescriptionTextField.placeholder = "Description"
        itemDescriptionTextField.borderColor = UIColor.peterRiverColor()
        itemDescriptionTextField.activeColor = UIColor.peterRiverColor()
        itemDescriptionTextField.snp_makeConstraints { (make) in
            make.top.equalTo(itemNameField.snp_bottom).offset(6)
            make.left.equalTo(itemNameField.snp_left)
            make.right.equalTo(itemPriceField.snp_right)
            make.height.equalTo(itemNameField.snp_height).multipliedBy(5)
        }
        
        view.addSubview(itemDescriptionField)
        itemDescriptionField.font = UIFont(name: "Helvetica", size: 20)
        itemDescriptionField.snp_makeConstraints { (make) in
            make.top.equalTo(itemDescriptionTextField.snp_top).offset(20)
            make.left.equalTo(itemDescriptionTextField.snp_left).offset(5)
            make.right.equalTo(itemDescriptionTextField.snp_right).offset(-5)
            make.bottom.equalTo(itemDescriptionTextField.snp_bottom).offset(-10)
        }
        
        view.addSubview(roundSquare)
        roundSquare.image = UIImage(named: "roundSquare")
        roundSquare.snp_makeConstraints { (make) in
            make.top.equalTo(itemDescriptionTextField.snp_bottom).offset(25)
            make.centerX.equalTo(itemDescriptionTextField.snp_centerX)
            make.width.equalTo(view.snp_width).dividedBy(4)
            make.height.equalTo(view.snp_width).dividedBy(4)
        }
        
        view.addSubview(postItemButton)
        postItemButton.setStyle(DynamicButtonStyle.CheckMark, animated: true)
        postItemButton.strokeColor = UIColor.peterRiverColor()
        postItemButton.highlightStokeColor = UIColor.greenSeaColor()
        postItemButton.lineWidth = 4
        postItemButton.addTarget(self, action: #selector(sellItButtonPressed), forControlEvents: .TouchUpInside)
        postItemButton.snp_makeConstraints { (make) in
            make.centerY.equalTo(roundSquare.snp_centerY)
            make.centerX.equalTo(roundSquare.snp_centerX)
            make.width.equalTo(roundSquare.snp_width).dividedBy(1.5)
            make.height.equalTo(roundSquare.snp_width).dividedBy(1.5)
        }
        

    }
}
