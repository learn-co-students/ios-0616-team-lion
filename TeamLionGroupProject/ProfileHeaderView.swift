//
//  ProfileHeaderView.swift
//  TeamLionGroupProject
//
//  Created by David Park on 8/8/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import UIKit
import SnapKit

class ProfileHeaderView: UICollectionReusableView {
	
	var usernameLabel = UILabel()
	var profilePic = UIImageView()
	var followingCountLabel = UILabel()
	var listingsCountLabel = UILabel()
	var friendsButton = UIButton()
	
	var username = "Username"
	var currentListingsCount = 3
	var currentFollowingsCount = 7

	override func layoutSubviews() {
		super.layoutSubviews()
		
		setupScene()
	}
	
	func setupScene() {
		
		self.addSubview(usernameLabel)
		usernameLabel.snp_makeConstraints { (make) in
			make.centerX.equalTo(self.snp_centerX)
			
		}
		
		self.addSubview(profilePic)
		profilePic.snp_makeConstraints { (make) in
			make.centerX.equalTo(self.snp_centerX)
			
		}
		
		self.addSubview(followingCountLabel)
		followingCountLabel.snp_makeConstraints { (make) in
			make.right.equalTo(self.snp_centerX)
			
		}
		
		self.addSubview(listingsCountLabel)
		listingsCountLabel.snp_makeConstraints { (make) in
			make.left.equalTo(self.snp_centerX)
			
		}
		
		self.addSubview(friendsButton)
		friendsButton.snp_makeConstraints { (make) in
			make.centerX.equalTo(snp_centerX)
			
		}
	}
	
}
