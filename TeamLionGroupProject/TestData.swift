//
//  TestUsers.swift
//  TeamLionGroupProject
//
//  Created by David Park on 8/5/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import Foundation
import UIKit


var imageArray1 = [UIImage]()
var imageArray2 = [UIImage]()
var imageArray3 = [UIImage]()

var postArray1 = [PlacePost]()
var postArray2 = [PlacePost]()
var postArray3 = [PlacePost]()


//TEST USERS


let user1 = PlaceUser.init(withName: "Alex", lastName: "Kalina", profilePicture: UIImage(named: "alex"), postings: postArray1)
let user2 = PlaceUser.init(withName: "Eldon", lastName: "Chan", profilePicture: UIImage(named: "eldon"), postings: postArray2)
let user3 = PlaceUser.init(withName: "David", lastName: "Park", profilePicture: UIImage(named: "david"), postings: postArray3)



//TEST POSTS

let post1 = PlacePost(itemImages: imageArray1, itemTitle: "bike" , itemDescription: "Awesome Bike. It's so awesome", price: 200)
let post2 = PlacePost(itemImages: imageArray2, itemTitle: "phone", itemDescription: "iphone. Used to play flappy bird and send nudes", price: 500)
let post3 = PlacePost(itemImages: imageArray3, itemTitle: "TV", itemDescription: "Great for looking at things and stuffs", price: 50)


func generateTestData() {

	postArray1.append(post1)
	postArray2.append(post2)
	postArray3.append(post3)

	imageArray1.append(UIImage(named: "bike")!)
	imageArray2.append(UIImage(named: "phone")!)
	imageArray3.append(UIImage(named: "tv")!)

}





