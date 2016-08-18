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
    var buyButton = DynamicButton()
    var topFrame = UIImageView()
    var cancelButton = DynamicButton()
    var itemImageView = UIImageView()
    let roundSquare = UIImageView()
    
    let fullnameFrame = ChisatoTextField()
    let titleFrame = ChisatoTextField()
    let descriptionFrame = ChisatoTextField()
    
    var fullName: String!
    var itemTitle: String?
    var itemDescription: String!
    var itemPrice: Int!
    var itemImage: UIImage!
    
    var totalHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.flatWhiteColor()
        generateScene()
    }
    
    
    func cancelButtonTapped() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func buyButtonTapped() {
        //send to venmo payment link and mark post as sold if paid
    }
    
    func generateScene() {
        
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
        
        view.addSubview(roundSquare)
        roundSquare.image = UIImage(named: "roundSquare")
        roundSquare.snp_makeConstraints { (make) in
            make.bottom.equalTo(view.snp_bottom).offset(-20)
            make.centerX.equalTo(view.snp_centerX)
            make.width.equalTo(view.snp_width).dividedBy(6)
            make.height.equalTo(view.snp_width).dividedBy(6)
        }
        
        view.addSubview(buyButton)
        buyButton.setStyle(DynamicButtonStyle.CheckMark, animated: true)
        buyButton.strokeColor = UIColor.flatRedColor()
        buyButton.highlightStokeColor = UIColor.flatMintColor()
        buyButton.addTarget(self, action: #selector(buyButtonTapped), forControlEvents: .TouchUpInside)
        buyButton.snp_makeConstraints { (make) in
            make.centerY.equalTo(roundSquare.snp_centerY)
            make.centerX.equalTo(roundSquare.snp_centerX)
            make.width.equalTo(roundSquare.snp_width).dividedBy(1.5)
            make.height.equalTo(roundSquare.snp_width).dividedBy(1.5)
            
        }
        
        
        view.addSubview(scrollView)
        scrollView.scrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.userInteractionEnabled = true
        scrollView.snp_makeConstraints { (make) in
            make.top.equalTo(topFrame.snp_bottom).offset(10)
            make.left.equalTo(view.snp_left).offset(10)
            make.right.equalTo(view.snp_right).offset(-10)
            make.bottom.equalTo(view.snp_bottom).offset(-100)
        }
        
        
        scrollView.addSubview(profilePic)
        profilePic.backgroundColor = UIColor.flatRedColor()
        profilePic.image?.circle
        profilePic.snp_makeConstraints { (make) in
            make.top.equalTo(scrollView.snp_top).offset(20)
            make.left.equalTo(view.snp_left).offset(20)
            make.width.equalTo(view.snp_width).dividedBy(4)
            make.height.equalTo(view.snp_width).dividedBy(4)
        }
        
        scrollView.addSubview(fullnameFrame)
        fullnameFrame.text = " "
        fullnameFrame.placeholderColor = UIColor.flatRedColor()
        fullnameFrame.placeholder = "Name"
        fullnameFrame.borderColor = UIColor.flatRedColor()
        fullnameFrame.activeColor = UIColor.flatRedColor()
        fullnameFrame.userInteractionEnabled = false
        fullnameFrame.snp_makeConstraints { (make) in
            make.top.equalTo(profilePic.snp_top)
            make.left.equalTo(profilePic.snp_right).offset(5)
            make.right.equalTo(view.snp_right).offset(-20)
            make.height.equalTo(profilePic.snp_height).dividedBy(2.2)
        }

        
        scrollView.addSubview(fullNameLabel)
        fullNameLabel.text = fullName
        fullNameLabel.textColor = UIColor.flatRedColor()
        fullNameLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(fullnameFrame.snp_centerX)
            make.centerY.equalTo(fullnameFrame.snp_centerY).offset(10)
            make.width.equalTo(fullnameFrame.snp_width).offset(-5)
            make.height.equalTo(fullnameFrame.snp_height)
        }
        
        scrollView.addSubview(titleFrame)
        titleFrame.text = " "
        titleFrame.placeholderColor = UIColor.flatRedColor()
        titleFrame.placeholder = "Item Name"
        titleFrame.borderColor = UIColor.flatRedColor()
        titleFrame.activeColor = UIColor.flatRedColor()
        titleFrame.userInteractionEnabled = false
        titleFrame.snp_makeConstraints { (make) in
            make.bottom.equalTo(profilePic.snp_bottom)
            make.left.equalTo(fullnameFrame.snp_left)
            make.width.equalTo(fullnameFrame.snp_width)
            make.height.equalTo(fullnameFrame.snp_height)
        }
        
        scrollView.addSubview(titleLabel)
        titleLabel.text = itemTitle
        titleLabel.textColor = UIColor.flatRedColor()
        titleLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(titleFrame.snp_centerX)
            make.centerY.equalTo(titleFrame.snp_centerY).offset(10)
            make.width.equalTo(titleFrame.snp_width).offset(-5)
            make.height.equalTo(titleFrame.snp_height)
        }
        
        scrollView.addSubview(itemImageView)
        itemImageView.image = itemImage
        itemImageView.backgroundColor = UIColor.flatRedColor()
        itemImageView.snp_makeConstraints { (make) in
            make.top.equalTo(profilePic.snp_bottom).offset(10)
            make.left.equalTo(profilePic.snp_left)
            make.right.equalTo(fullnameFrame.snp_right)
            make.height.equalTo(itemImageView.snp_width)
        }
        
        scrollView.addSubview(priceLabel)
        priceLabel.textColor = UIColor.whiteColor()
        priceLabel.text = "$\(itemPrice)"
        priceLabel.textAlignment = NSTextAlignment.Right
        priceLabel.snp_makeConstraints { (make) in
            make.right.equalTo(itemImageView.snp_right).offset(-5)
            make.top.equalTo(itemImageView.snp_top).offset(5)
            make.height.equalTo(titleLabel.snp_height)
            make.width.equalTo(itemImageView.snp_width).dividedBy(5)
        }
        
        scrollView.addSubview(descriptionField)
        descriptionField.userInteractionEnabled = false
        descriptionField.scrollEnabled = false
        descriptionField.backgroundColor = UIColor.flatWhiteColor()
        descriptionField.textContainerInset = UIEdgeInsets(top: 5, left: 30, bottom: 0, right: 30)
        descriptionField.snp_makeConstraints { (make) in
            make.centerX.equalTo(itemImageView.snp_centerX)
            make.top.equalTo(itemImageView.snp_bottom).offset(30)
            make.left.equalTo(itemImageView.snp_left)
            make.right.equalTo(itemImageView.snp_right)
        }
        
        scrollView.addSubview(descriptionFrame)
        descriptionFrame.userInteractionEnabled = false
        descriptionFrame.text = descriptionField.text
        descriptionFrame.textColor = UIColor.clearColor()
        descriptionFrame.placeholderColor = UIColor.flatRedColor()
        descriptionFrame.placeholder = "Description"
        descriptionFrame.borderColor = UIColor.flatRedColor()
        descriptionFrame.activeColor = UIColor.flatRedColor()
        descriptionFrame.snp_makeConstraints { (make) in
            make.left.equalTo(itemImageView.snp_left)
            make.right.equalTo(itemImageView.snp_right)
            make.top.equalTo(itemImageView.snp_bottom).offset(5)
            make.bottom.equalTo(descriptionField.snp_bottom).offset(20)
            
        }
        
        calculateScrollViewHeight()
    
        scrollView.contentSize = CGSize(width: 300, height: totalHeight)
        

    }
    
    func calculateScrollViewHeight() {
     
        let preTotalHeight = 520 + CGFloat((descriptionFrame.text?.characters.count)!)/1.25
        
        if preTotalHeight > 600 {
            totalHeight = 600
        }
            
        else if preTotalHeight < 525 {
            totalHeight = 525
        }
            
        else {
            totalHeight = preTotalHeight
        }
    }
    

}
