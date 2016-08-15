//
//  TestUsers.swift
//  TeamLionGroupProject
//
//  Created by David Park on 8/5/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import Foundation
import UIKit


var imageArray1 = [UIImage(named: "bike")!]
var imageArray2 = [UIImage(named: "phone")!]
var imageArray3 = [UIImage(named: "tv")!]
var imageArray4 = [UIImage(named: "deadmau5")!]
var imageArray5 = [UIImage(named: "gameboy")!]
var imageArray6 = [UIImage(named: "imac")!]
var imageArray7 = [UIImage(named: "ipod")!]
var imageArray8 = [UIImage(named: "kaws")!]
var imageArray9 = [UIImage(named: "pennyboard")!]
var imageArray10 = [UIImage(named: "spacejam")!]
var imageArray11 = [UIImage(named: "umbrella")!]
var imageArray12 = [UIImage(named: "corgi")!]


var postArray1 = [PlacePost]()
var postArray2 = [PlacePost]()
var postArray3 = [PlacePost]()


//TEST USERS


let user1 = PlaceUser.init(withName: "Alex", lastName: "Kalina", profilePicture: UIImage(named: "alex"), postings: postArray1)
let user2 = PlaceUser.init(withName: "Eldon", lastName: "Chan", profilePicture: UIImage(named: "eldon"), postings: postArray2)
let user3 = PlaceUser.init(withName: "David", lastName: "Park", profilePicture: UIImage(named: "david"), postings: postArray3)



//TEST POSTS

var post1 = PlacePost(itemImages: imageArray1, itemTitle: "bike" , itemDescription: "Awesome Bike. It's so awesome. Awesome Bike. It's so awesome. Awesome Bike. It's so awesome. Awesome Bike. It's so awesome. Awesome Bike. It's so awesome. Awesome Bike. It's so awesome. Awesome Bike. It's so awesome. Awesome Bike. It's so awesome.", price: 200)
var post2 = PlacePost(itemImages: imageArray2, itemTitle: "phone", itemDescription: "iphone. Used to play flappy bird and send nudes", price: 500)
var post3 = PlacePost(itemImages: imageArray3, itemTitle: "TV", itemDescription: "Great for looking at things and stuffs", price: 50)
var post4 = PlacePost(itemImages: imageArray4, itemTitle: "Deadmau5 Helmet", itemDescription: "Just a dead mouse with cheese", price: 250)
var post5 = PlacePost(itemImages: imageArray5, itemTitle: "Gameboy", itemDescription: "Best thing ever", price: 50)
var post6 = PlacePost(itemImages: imageArray6, itemTitle: "iMac", itemDescription: "Still works, great for paint", price: 150)
var post7 = PlacePost(itemImages: imageArray7, itemTitle: "iPod Mini", itemDescription: "Plays music and stuff", price: 50)
var post8 = PlacePost(itemImages: imageArray8, itemTitle: "Kaws", itemDescription: "", price: 333)
var post9 = PlacePost(itemImages: imageArray9, itemTitle: "Penny Board", itemDescription: "Skateboard but penny size", price: 30)
var post10 = PlacePost(itemImages: imageArray10, itemTitle: "Space Jam VHS", itemDescription: "BEST MOVIE EVER?", price: 50)
var post11 = PlacePost(itemImages: imageArray11, itemTitle: "Duck Umbrella", itemDescription: "Be a duck", price: 50)
var post12 = PlacePost(itemImages: imageArray12, itemTitle: "Corgi Puppy", itemDescription: "Short dog", price: 1200)


func generateTestData() {

	postArray1.append(post1)
	postArray2.append(post2)
	postArray3.append(post3)

	imageArray1.append(UIImage(named: "bike")!)
	imageArray2.append(UIImage(named: "phone")!)
	imageArray3.append(UIImage(named: "tv")!)
    
    post1.itemImages = imageArray1
    post2.itemImages = imageArray2
    post3.itemImages = imageArray3
    
}





