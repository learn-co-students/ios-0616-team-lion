//
//  ProfileHeaderView.swift
//  TeamLionGroupProject
//
//  Created by David Park on 8/8/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import UIKit
import SnapKit
import FBSDKLoginKit

protocol ProfileHeaderViewDelegate: class {
	func friendsButtonPressed()
    func backToLoginScreen()
}


class ProfileHeaderView: UICollectionReusableView, FBSDKLoginButtonDelegate {
	
	weak var delegate: ProfileHeaderViewDelegate?
	let shared = PlaceUserDataStore.sharedDataStore
	var usernameLabel = UILabel()
	var profilePic = UIImageView()
	var followingCountLabel = UILabel()
	var listingsCountLabel = UILabel()
	var friendsButton = UIButton()
	
	var username = "Username"
	var currentListingsCount = 0
	var currentFollowingsCount = 0
	
	let headerFont = "HelveticaNeue"
    var loginButton: FBSDKLoginButton = FBSDKLoginButton()
    

	override func layoutSubviews() {
		super.layoutSubviews()
		
		setupScene()
        
        profilePic.image = self.shared.currentUser.picture
        currentListingsCount = self.shared.currentUser.postings.count

	}
	
	func setupScene() {
        self.addSubview(loginButton)
        loginButton.delegate = self
        loginButton.frame = CGRectMake(15, 30, 80, 30)
        loginButton.addTarget(self, action: #selector(backToLoginScreen), forControlEvents: .TouchUpInside)
     
        
		self.addSubview(usernameLabel)
		usernameLabel.snp_makeConstraints { (make) in
			make.centerX.equalTo(self.snp_centerX)
			make.top.equalTo(self.snp_top).offset(20)
			make.width.equalTo(self.snp_width).dividedBy(2)
			make.height.equalTo(self.snp_height).dividedBy(8)
		}
		//usernameLabel.backgroundColor = UIColor.blackColor()

        //usernameLabel.text = LoginViewController.
		usernameLabel.textAlignment = .Center
		usernameLabel.font = UIFont(name: headerFont, size: usernameLabel.font.pointSize)
		usernameLabel.textColor = UIColor.whiteColor()
		
		self.addSubview(profilePic)
		profilePic.snp_makeConstraints { (make) in
			make.centerX.equalTo(self.snp_centerX)
			make.top.equalTo(usernameLabel.snp_bottom).offset(2)
			make.height.equalTo(self.snp_height).dividedBy(2.5)
			make.width.equalTo(self.snp_height).dividedBy(2.5)
		}
//		profilePic.image = UIImage(named: "imac")?.rounded
		profilePic.layer.cornerRadius = self.frame.height/5
		profilePic.layer.masksToBounds = true
		profilePic.layer.borderWidth = 2
		profilePic.layer.borderColor = UIColor.whiteColor().CGColor
		
		
		self.addSubview(followingCountLabel)
		followingCountLabel.snp_makeConstraints { (make) in
			make.right.equalTo(self.snp_centerX).offset(-3)
			make.top.equalTo(profilePic.snp_bottom).offset(2)
			make.height.equalTo(self.snp_height).dividedBy(10)
			make.width.equalTo(self.snp_width).dividedBy(2)
		}
		//followingCountLabel.backgroundColor = UIColor.alizarinColor()
		followingCountLabel.text = "Following: \(currentFollowingsCount)"
		followingCountLabel.textAlignment = .Right
		followingCountLabel.font = UIFont(name: headerFont, size: followingCountLabel.font.pointSize)
		followingCountLabel.textColor = UIColor.whiteColor()
		
		self.addSubview(listingsCountLabel)
		listingsCountLabel.snp_makeConstraints { (make) in
			make.left.equalTo(self.snp_centerX).offset(3)
			make.top.equalTo(followingCountLabel.snp_top)
			make.height.equalTo(followingCountLabel.snp_height)
			make.width.equalTo(followingCountLabel.snp_width)
		}
		//listingsCountLabel.backgroundColor = UIColor.amethystColor()
		listingsCountLabel.text = "Listings: \(currentListingsCount)"
		listingsCountLabel.font = UIFont(name: headerFont, size: listingsCountLabel.font.pointSize)
		listingsCountLabel.textColor = UIColor.whiteColor()
		
		self.addSubview(friendsButton)
		friendsButton.snp_makeConstraints { (make) in
			make.centerX.equalTo(snp_centerX)
			make.top.equalTo(followingCountLabel.snp_bottom).offset(5)
			make.height.equalTo(self.snp_height).dividedBy(6)
			make.width.equalTo(self.snp_width).dividedBy(2.5)
		}
		friendsButton.backgroundColor = UIColor.blackColor()
		friendsButton.layer.masksToBounds = true
		friendsButton.layer.cornerRadius = self.frame.height/12
		friendsButton.layer.borderWidth = 1
		friendsButton.layer.borderColor = UIColor.whiteColor().CGColor
		friendsButton.titleLabel?.textColor = UIColor.redColor()
		friendsButton.setTitle("Friends", forState: .Normal)
		friendsButton.titleLabel!.font = UIFont(name: headerFont, size: friendsButton.titleLabel!.font.pointSize)
		friendsButton.addTarget(self, action: #selector(friendsButtonPressed), forControlEvents: .TouchUpInside)
	}
	
	func backToLoginScreen() -> Bool{
            if (loginButton.touchInside){
            print("user logged out")
        return true
        }
            print("user logged in")
		return false
	}
    
    func friendsButtonPressed() {
        print("friendsButton pressed")
    }
    
    func setUpForUser(name: String, picture: UIImage) {
        self.usernameLabel.text = name
//        let data = NSData(contentsOfURL: picture)
//        let pic = UIImage(data: data!)
//        self.profilePic.image = pic
        self.profilePic.image = picture
        //print("\n\n\n\n\n\n\n\(pic)")
    }
  
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        self.delegate?.backToLoginScreen()

    }

	
}
