//
//  PostDetailViewController.swift
//  TeamLionGroupProject
//
//  Created by Eldon Chan on 8/11/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import UIKit
import SnapKit
import DynamicButton
import CCTextFieldEffects
import ChameleonFramework
import MessageUI

class PostDetailViewController: UIViewController, UIScrollViewDelegate, MFMailComposeViewControllerDelegate {
    
    var scrollView = UIScrollView()
    var profilePic = UIImageView()
    var fullNameLabel = UILabel()
    var priceLabel = UILabel()
    var descriptionField = UITextView()
    var titleLabel = UILabel()
    var buyButton = UIButton()
    var topFrame = UIImageView()
    var itemImageView = UIImageView()
    let roundSquare = UIImageView()
    let chatButton = UIButton()
    let dividerImage = UIImageView()
    var chatButtonImage = UIImageView()
    
    var fullName = String()
    var itemTitle: String?
    var itemDescription: String?
    var itemPrice = String()
    var itemImage: UIImage?
    var email = String()
    
    var totalHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.flatWhiteColor()
        generateScene()
        print(fullName)
        print(fullNameLabel.text)
    }
    
    override func viewWillAppear(animated: Bool) {
        print(email)
    }
    
    func buyButtonTapped() {
        //send to venmo payment link and mark post as sold if paid
        
        var itemDescriptionWithPlus = ""
        for var characters in (itemDescription?.characters)! {
            if characters == " " {
                characters = "+"
            }
            itemDescriptionWithPlus.append(characters)
        }
        
        //delete cassido later to replace with \(email)
        let url = NSURL(string: "https://venmo.com/\(email)?txn=pay&amount=\(itemPrice)&note=Purchasing+from+PLACE:+\(itemDescriptionWithPlus)")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func chatButtonPressed(){
        let chatVC = OpenChatViewController()
        presentViewController(chatVC, animated: true, completion: nil)
    }
    
    func generateScene() {
        
        view.backgroundColor = UIColor.flatRedColor()
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "contact seller", style: UIBarButtonItemStyle.Done, target: self, action: #selector(contactButtonPressed))
		let textAttribute = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 20)!]
		self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(textAttribute, forState: .Normal)
		
        view.addSubview(buyButton)
        buyButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(view.snp_bottom).offset(-20)
            make.centerX.equalTo(view.snp_centerX)
            make.height.equalTo(view.snp_height).dividedBy(10)
            make.width.equalTo(view.snp_width).dividedBy(2.5)
        }
        buyButton.backgroundColor = UIColor.flatRedColor()
        buyButton.layer.masksToBounds = true
        buyButton.layer.cornerRadius = view.frame.height/20
        buyButton.layer.borderWidth = 1
        buyButton.layer.borderColor = UIColor.whiteColor().CGColor
        buyButton.titleLabel?.textColor = UIColor.redColor()
        buyButton.setTitle("BUY", forState: .Normal)
        buyButton.titleLabel!.font = UIFont(name: "HelveticaNeue", size: buyButton.titleLabel!.font.pointSize)
        buyButton.addTarget(self, action: #selector(buyButtonTapped), forControlEvents: .TouchUpInside)
        
        
        view.addSubview(scrollView)
        scrollView.scrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.userInteractionEnabled = true
        scrollView.backgroundColor = UIColor.flatWhiteColor()
        scrollView.snp_makeConstraints { (make) in
            make.top.equalTo(view.snp_top)
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
            make.bottom.equalTo(view.snp_bottom).offset(-100)
        }
        
        
        scrollView.addSubview(itemImageView)
        itemImageView.image = itemImage
        itemImageView.backgroundColor = UIColor.flatRedColor()
        itemImageView.snp_makeConstraints { (make) in
            make.top.equalTo(scrollView.snp_top)
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
            make.height.equalTo(itemImageView.snp_width)
        }
        
        scrollView.addSubview(titleLabel)
        titleLabel.text = itemTitle
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = UIColor.flatBlackColorDark()
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        titleLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(view.snp_centerX)
            make.top.equalTo(itemImageView.snp_bottom).offset(15)
            make.width.equalTo(itemImageView.snp_width).offset(-10)
        }
        
        scrollView.addSubview(priceLabel)
        priceLabel.textColor = UIColor.flatBlackColor()
        priceLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        priceLabel.text = "$\(itemPrice)"
        priceLabel.textAlignment = NSTextAlignment.Center
        priceLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(titleLabel.snp_centerX)
            make.top.equalTo(titleLabel.snp_bottom).offset(2)
            make.height.equalTo(titleLabel.snp_height)
        }
        
        scrollView.addSubview(dividerImage)
        dividerImage.image = UIImage(named: "divider")
        dividerImage.snp_makeConstraints { (make) in
            make.top.equalTo(priceLabel.snp_bottom).offset(2)
            make.height.equalTo(itemImageView.snp_height).dividedBy(10)
            make.left.equalTo(itemImageView.snp_left)
            make.right.equalTo(itemImageView.snp_right)
        }
        
        scrollView.addSubview(descriptionField)
        descriptionField.userInteractionEnabled = false
        descriptionField.scrollEnabled = false
        descriptionField.backgroundColor = UIColor.flatWhiteColor()
        descriptionField.textContainerInset = UIEdgeInsets(top: 5, left: 30, bottom: 0, right: 30)
        descriptionField.text = itemDescription
        descriptionField.snp_makeConstraints { (make) in
            make.centerX.equalTo(itemImageView.snp_centerX)
            make.top.equalTo(dividerImage.snp_bottom)
            make.left.equalTo(itemImageView.snp_left).offset(5)
            make.right.equalTo(itemImageView.snp_right).offset(-5)
        }
        
//        scrollView.addSubview(profilePic)
//        profilePic.backgroundColor = UIColor.flatWhiteColor()
//        profilePic.image?.circle
//        profilePic.layer.cornerRadius = view.frame.height/12
//        profilePic.layer.masksToBounds = true
//        profilePic.layer.borderWidth = 2
//        profilePic.layer.borderColor = UIColor.flatRedColor().CGColor
//        profilePic.clipsToBounds = true
//        profilePic.snp_makeConstraints { (make) in
//            make.top.equalTo(descriptionField.snp_bottom).offset(20)
//            make.centerX.equalTo(view.snp_centerX)
//            make.width.equalTo(view.snp_height).dividedBy(6)
//            make.height.equalTo(view.snp_height).dividedBy(6)
//        }
        
        scrollView.addSubview(fullNameLabel)
        fullNameLabel.text = "Sold by: \(fullName)"
        fullNameLabel.textAlignment = NSTextAlignment.Center
        fullNameLabel.textColor = UIColor.flatBlackColor()
        fullNameLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(descriptionField.snp_centerX)
            make.top.equalTo(descriptionField.snp_bottom).offset(25)
            make.height.equalTo(priceLabel.snp_height)
        }

        
        calculateScrollViewHeight()
    
        scrollView.contentSize = CGSize(width: 300, height: totalHeight)
        

    }
    
    func calculateScrollViewHeight() {
     
        let preTotalHeight = 550 + CGFloat((descriptionField.text?.characters.count)!)/1.25
        
        if preTotalHeight > 850 {
            totalHeight = 850
        }
            
        else if preTotalHeight < 650 {
            totalHeight = 650
        }
            
        else {
            totalHeight = preTotalHeight
        }
    }
	
	func contactButtonPressed() {
		
		let emailTitle = "Email Title"
		let messageBody = "I want to buy your thing please"
		let recipient = ["\(email)"]
		let mailVC = MFMailComposeViewController()
		
		mailVC.mailComposeDelegate = self
		mailVC.setSubject(emailTitle)
		mailVC.setMessageBody(messageBody, isHTML: false)
		mailVC.setToRecipients(recipient)
		
		self.presentViewController(mailVC, animated: true, completion: nil)
		
	}
	
	func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
		
		switch (result) {
		case MFMailComposeResultCancelled:
			print("Mail cancelled")
			break;
		case MFMailComposeResultSaved:
			print("Mail saved");
			break;
		case MFMailComposeResultSent:
			print("Mail sent");
			break;
		case MFMailComposeResultFailed:
			print("Mail sent failure: \(error?.localizedDescription)");
			break;
		default:
			break;
		}
		
		// Close the Mail Interface
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	

}
