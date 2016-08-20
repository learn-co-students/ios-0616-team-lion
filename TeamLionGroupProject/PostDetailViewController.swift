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

class PostDetailViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollView = UIScrollView()
    var profilePic = UIImageView()
    var fullNameLabel = UILabel()
    var priceLabel = UILabel()
    var descriptionField = UITextView()
    var titleLabel = UILabel()
    var buyButton = UIButton()
    var topFrame = UIImageView()
    var cancelButton = DynamicButton()
    var itemImageView = UIImageView()
    let roundSquare = UIImageView()
    let chatButton = UIButton()
    let dividerImage = UIImageView()
    var chatButtonImage = UIImageView()
    
    var fullName: String?
    var itemTitle: String?
    var itemDescription: String?
    var itemPrice: Int!
    var itemImage: UIImage?
    
    var totalHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.flatWhiteColor()
        generateScene()
        print(fullName)
        print(fullNameLabel.text)
    }
    
    
    func cancelButtonTapped() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func buyButtonTapped() {
        //send to venmo payment link and mark post as sold if paid
    }
    
    func chatButtonPressed(){
        let chatVC = OpenChatViewController()
        presentViewController(chatVC, animated: true, completion: nil)
    }
    
    func generateScene() {
        
        view.backgroundColor = UIColor.flatRedColor()
        
        view.addSubview(topFrame)
        topFrame.backgroundColor = UIColor.flatRedColor()
        topFrame.snp_makeConstraints { (make) in
            make.top.equalTo(view.snp_top)
            make.width.equalTo(view.snp_width)
            make.height.equalTo(view.snp_width).dividedBy(7)
        }
        
        view.addSubview(cancelButton)
        cancelButton.setStyle(DynamicButtonStyle.Rewind, animated: true)
        cancelButton.strokeColor = UIColor.flatWhiteColor()
        cancelButton.highlightStokeColor = UIColor.redColor()
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), forControlEvents: .TouchUpInside)
        cancelButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(topFrame.snp_centerX).offset(-160)
            make.centerY.equalTo(topFrame.snp_centerY).offset(10)
            make.width.equalTo(topFrame.snp_width).dividedBy(12)
            make.height.equalTo(topFrame.snp_width).dividedBy(12)
            
        }
        
        view.addSubview(chatButton)
        chatButtonImage.image = UIImage(named: "chatUnselected")
        chatButtonImage.image = (chatButtonImage.image?.imageWithRenderingMode(.AlwaysTemplate))!
        chatButtonImage.tintColor = UIColor.flatWhiteColor()
        chatButton.setImage(chatButtonImage.image, forState: .Normal)
        chatButton.addTarget(self, action: #selector(chatButtonPressed), forControlEvents: .TouchUpInside)
        chatButton.tintColor = UIColor.flatWhiteColor()
        chatButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(topFrame.snp_centerX).offset(160)
            make.centerY.equalTo(topFrame.snp_centerY).offset(10)
            make.width.equalTo(topFrame.snp_width).dividedBy(12)
            make.height.equalTo(topFrame.snp_width).dividedBy(12)
            
        }
        
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
            make.top.equalTo(topFrame.snp_bottom).offset(10)
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
        descriptionField.snp_makeConstraints { (make) in
            make.centerX.equalTo(itemImageView.snp_centerX)
            make.top.equalTo(dividerImage.snp_bottom)
            make.left.equalTo(itemImageView.snp_left).offset(5)
            make.right.equalTo(itemImageView.snp_right).offset(-5)
        }
        
        scrollView.addSubview(profilePic)
        profilePic.backgroundColor = UIColor.flatWhiteColor()
        profilePic.image?.circle
        profilePic.layer.cornerRadius = view.frame.height/12
        profilePic.layer.masksToBounds = true
        profilePic.layer.borderWidth = 2
        profilePic.layer.borderColor = UIColor.flatRedColor().CGColor
        profilePic.clipsToBounds = true
        profilePic.snp_makeConstraints { (make) in
            make.top.equalTo(descriptionField.snp_bottom).offset(20)
            make.centerX.equalTo(view.snp_centerX)
            make.width.equalTo(view.snp_height).dividedBy(6)
            make.height.equalTo(view.snp_height).dividedBy(6)
        }
        
        scrollView.addSubview(fullNameLabel)
        fullNameLabel.text = "Sold by: \(fullName)"
        fullNameLabel.textAlignment = NSTextAlignment.Center
        fullNameLabel.textColor = UIColor.flatBlackColor()
        fullNameLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(profilePic.snp_centerX)
            make.top.equalTo(profilePic.snp_bottom).offset(5)
            make.height.equalTo(priceLabel.snp_height)
        }

        
        calculateScrollViewHeight()
    
        scrollView.contentSize = CGSize(width: 300, height: totalHeight)
        

    }
    
    func calculateScrollViewHeight() {
     
        let preTotalHeight = 600 + CGFloat((descriptionField.text?.characters.count)!)/1.25
        
        if preTotalHeight > 800 {
            totalHeight = 800
        }
            
        else if preTotalHeight < 675 {
            totalHeight = 675
        }
            
        else {
            totalHeight = preTotalHeight
        }
    }
    

}
