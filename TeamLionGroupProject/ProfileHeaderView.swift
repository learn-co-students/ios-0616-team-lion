//
//  ProfileHeaderView.swift
//  TeamLionGroupProject
//
//  Created by David Park on 8/8/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import UIKit

class ProfileHeaderView: UICollectionReusableView {
	
	var usernameLabel = UILabel()
	var profilePic = UIImage()
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
		
	}
	
}
