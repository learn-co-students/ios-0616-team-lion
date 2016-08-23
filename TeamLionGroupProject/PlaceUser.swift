//
//  Users.swift
//  TeamLionGroupProject
//
//  Created by Eldon Chan on 8/4/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import Foundation
import UIKit

struct CurrentUser {
    var name = String()
    var picture = UIImage()
    var postings = [PlacePost]()
    //var friendsList = [UsersFriend]()
    var email = String()
    var userID = String()
    var friendsPosts = [PlacePost]()
    //  static var friend: Friend
    
    
    static let childName = "user"
    static let nameKey = "name"
    static let pictureKey = "picture"
    static let friendsKey = "friends"
    static let email = "email"
    
}



class PlaceUser: NSObject {
	
	let firstName: String
	let lastName: String
	var profilePicture: UIImage?
	//var profilePictureReferencePath			from Firebase
	//let uid: String							from data
	var postings: [PlacePost]
	
	
	init(withName firstName: String,
	              lastName: String,
	              profilePicture: UIImage?,
	              postings: [PlacePost]) {
		
		
		self.firstName = firstName
		self.lastName = lastName
		self.profilePicture = profilePicture
		self.postings = postings
		
		super.init()
	}
	
	
}

