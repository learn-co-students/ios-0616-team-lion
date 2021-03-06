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
import FirebaseAuth
class NewPostViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, sendPhoto {

	let datastore = PlaceUserDataStore.sharedDataStore
    var itemNameField = ChisatoTextField()
	var itemDescriptionTextField = ChisatoTextField()
	var itemDescriptionField = UITextView()
	var itemPriceField = ChisatoTextField()
    
	var uploadImageButton = UIButton()
    var takePictureButton = UIButton()
	var profilePic = UIImageView()
	var postItemButton = UIButton()
	var newPostTextLabel = UILabel()
	let cancelButton = DynamicButton()
    
    let roundSquare = UIImageView()
    
    let topFrame = UIImageView()
    let pictureFrame = UIImageView()
    var picture = UIImageView(image: UIImage(named: "NoImage"))
    let picFrame = ChisatoTextField()
    
    var hasPicture = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		

		print("New Post VC View Did Load")

        itemDescriptionTextField.delegate = self
        itemDescriptionField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

		generateScene()
        
        picture.hidden = true
	}
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        print("NewPost Pic:\(picture)")
        
        if hasPicture == true {
            picture.hidden = false
            pictureFrame.image = picture.image

        }
        
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
		
        if itemNameField.text == "" {
            
            let alertController = UIAlertController(title: "Missing Field", message: "Please enter a name!", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        }
        
        if itemPriceField.text == "" {
            
            let alertController = UIAlertController(title: "Missing Field", message: "Please enter a price!", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        }
        
        if itemDescriptionField.text == "" {
            
            let alertController = UIAlertController(title: "Missing Field", message: "Please enter a description!", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        }
        
        else {
            
            let alertController = UIAlertController(title: "Confirm", message: "Confirm your post?", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                // ...
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//				let post = PlacePost(itemImages: self.picture.image!, itemImageURL:"", itemTitle: self.itemNameField.text!, itemDescription: self.itemDescriptionField.text, price: self.itemPriceField.text!, user: self.datastore.aUser, userID: "")
				
                let pic = self.picture.image!
                guard let userID = FIRAuth.auth()?.currentUser?.uid else{return}
                guard let email = FIRAuth.auth()?.currentUser?.email else{return}
                guard let name = FIRAuth.auth()?.currentUser?.displayName else{return}
                print("USERID         \(userID)")
				print("THE USER ID IS \(userID)")
				print("Picture is \(pic)")
				print("ITEM NAME is \(self.itemNameField.text)")
				print("description is \(self.itemDescriptionField.text)")
				print("price is \(self.itemPriceField.text)")
                self.datastore.postPictureToDatabase(pic, title: self.itemNameField.text!, description: self.itemDescriptionField.text, price: self.itemPriceField.text!, userID: userID, name: name, email: email)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
			
			
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        }
        
    
	}
    
    func takePictureButtonPressed(){
        
        hasPicture = true
        
        let photoVC = PhotoViewController()
        
        photoVC.delegate = self
        
        presentViewController(photoVC, animated: true, completion: nil)
       
        
    }
    
    func cancelButtonTapped() {
            
        self.dismissViewControllerAnimated(true, completion: nil)
            
    }
    
    func generateScene() {
        
        let font = "HelveticaNeue"
        view.backgroundColor = UIColor.flatWhiteColor()
        
        view.addSubview(topFrame)
        topFrame.backgroundColor = UIColor.flatRedColor()
        topFrame.snp_makeConstraints { (make) in
            make.top.equalTo(view.snp_top)
            make.width.equalTo(view.snp_width)
            make.height.equalTo(view.snp_width).dividedBy(7)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "New Post"
        titleLabel.backgroundColor = UIColor.flatRedColor()
        titleLabel.textColor = UIColor.flatWhiteColor()
        titleLabel.font = UIFont(name: "Noteworthy", size: 22)
        view.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(topFrame.snp_bottom).offset(-5)
            make.centerX.equalTo(topFrame.snp_centerX)
        }
        
        view.addSubview(picFrame)
        picFrame.userInteractionEnabled = false
        picFrame.text = " "
        picFrame.placeholderColor = UIColor.flatRedColor()
        picFrame.placeholder = "Picture"
        picFrame.borderColor = UIColor.flatRedColor()
        picFrame.activeColor = UIColor.flatRedColor()
        picFrame.snp_makeConstraints { (make) in
            make.top.equalTo(topFrame.snp_bottom).offset(10)
            make.centerX.equalTo(view.snp_centerX)
            make.width.equalTo(view.snp_width).dividedBy(2.2)
            make.height.equalTo(view.snp_width).dividedBy(2.1)
        }
        view.addSubview(pictureFrame)
        pictureFrame.userInteractionEnabled = false
        pictureFrame.snp_makeConstraints { (make) in
            make.bottom.equalTo(picFrame.snp_bottom).offset(-2)
            make.right.equalTo(picFrame.snp_right).offset(-2)
            make.top.equalTo(picFrame.snp_top).offset(18)
            make.left.equalTo(picFrame.snp_left).offset(2)
        }
        
        view.addSubview(takePictureButton)
        takePictureButton.setImage(UIImage(named:"cameraIcon"), forState: .Normal)
        takePictureButton.setTitle("TAP", forState: .Normal)
        takePictureButton.titleLabel?.font = UIFont(name: font, size: 12)
        takePictureButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        takePictureButton.titleEdgeInsets = UIEdgeInsets(top: 40, left: -60, bottom: 0, right: 0)
        takePictureButton.setTitleColor(UIColor.flatBlackColor(), forState: .Normal)
        takePictureButton.addTarget(self, action: #selector(takePictureButtonPressed), forControlEvents: .TouchUpInside)
        takePictureButton.snp_makeConstraints { (make) in
            make.centerY.equalTo(pictureFrame.snp_centerY)
            make.centerX.equalTo(pictureFrame.snp_centerX).offset(15)
            make.width.equalTo(pictureFrame.snp_width)
            make.height.equalTo(pictureFrame.snp_height)
        }
        
        view.addSubview(cancelButton)
        cancelButton.setStyle(DynamicButtonStyle.Rewind, animated: true)
        cancelButton.strokeColor = UIColor.flatWhiteColor()
        cancelButton.highlightStokeColor = UIColor.flatWatermelonColor()
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), forControlEvents: .TouchUpInside)
        cancelButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(topFrame.snp_centerX).offset(-160)
            make.centerY.equalTo(topFrame.snp_centerY).offset(10)
            make.width.equalTo(topFrame.snp_width).dividedBy(12)
            make.height.equalTo(topFrame.snp_width).dividedBy(12)
            
        }
        
        view.addSubview(itemNameField)
        itemNameField.placeholder = "Item Name"
        itemNameField.borderColor = UIColor.flatRedColor()
        itemNameField.activeColor = UIColor.flatRedColor()
        itemNameField.textColor = UIColor.flatBlackColor()
        itemNameField.snp_makeConstraints { (make) in
            make.top.equalTo(picFrame.snp_bottom).offset(4)
            make.left.equalTo(view.snp_left).offset(20)
            make.width.equalTo(view.snp_width).dividedBy(1.5)
            make.height.equalTo(view.snp_width).dividedBy(7)
        }
        
        
        view.addSubview(itemPriceField)
        itemPriceField.placeholder = "Price"
        itemPriceField.borderColor = UIColor.flatRedColor()
        itemPriceField.activeColor = UIColor.flatRedColor()
        itemPriceField.textColor = UIColor.flatBlackColor()
        itemPriceField.keyboardType = UIKeyboardType.NumberPad
        itemPriceField.snp_makeConstraints { (make) in
            make.left.equalTo(itemNameField.snp_right).offset(2)
            make.right.equalTo(view.snp_right).offset(-20)
            make.top.equalTo(itemNameField.snp_top)
            make.height.equalTo(itemNameField.snp_height)
        }
        
        view.addSubview(itemDescriptionTextField)
        itemDescriptionTextField.text = " "
        itemDescriptionTextField.placeholderColor = UIColor.flatRedColor()
        itemDescriptionTextField.placeholder = "Description"
        itemDescriptionTextField.borderColor = UIColor.flatRedColor()
        itemDescriptionTextField.activeColor = UIColor.flatRedColor()
        itemDescriptionTextField.snp_makeConstraints { (make) in
            make.top.equalTo(itemNameField.snp_bottom).offset(6)
            make.left.equalTo(itemNameField.snp_left)
            make.right.equalTo(itemPriceField.snp_right)
            make.height.equalTo(itemNameField.snp_height).multipliedBy(5)
        }
        
        view.addSubview(itemDescriptionField)
        itemDescriptionField.backgroundColor = UIColor.flatWhiteColor()
        itemDescriptionField.font = UIFont(name: "HelveticaNeue", size: 12)
        itemDescriptionField.snp_makeConstraints { (make) in
            make.top.equalTo(itemDescriptionTextField.snp_top).offset(20)
            make.left.equalTo(itemDescriptionTextField.snp_left).offset(5)
            make.right.equalTo(itemDescriptionTextField.snp_right).offset(-5)
            make.bottom.equalTo(itemDescriptionTextField.snp_bottom).offset(-10)
        }
        
        view.addSubview(postItemButton)
        postItemButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(view.snp_bottom).offset(-20)
            make.centerX.equalTo(view.snp_centerX)
            make.height.equalTo(view.snp_height).dividedBy(10)
            make.width.equalTo(view.snp_width).dividedBy(2.5)
        }
        postItemButton.backgroundColor = UIColor.flatRedColor()
        postItemButton.layer.masksToBounds = true
        postItemButton.layer.cornerRadius = view.frame.height/20
        postItemButton.layer.borderWidth = 1
        postItemButton.layer.borderColor = UIColor.whiteColor().CGColor
        postItemButton.titleLabel?.textColor = UIColor.redColor()
        postItemButton.setTitle("SELL IT!", forState: .Normal)
        postItemButton.titleLabel!.font = UIFont(name: "HelveticaNeue", size: postItemButton.titleLabel!.font.pointSize)
        postItemButton.addTarget(self, action: #selector(sellItButtonPressed), forControlEvents: .TouchUpInside)
    }
    
    func sendBackPhoto(photo: UIImageView) {
        self.picture = photo
    }
}
