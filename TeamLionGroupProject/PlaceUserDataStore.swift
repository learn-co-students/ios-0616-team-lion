//
//  PlaceUserDataStore.swift
//  TeamLionGroupProject
//
//  Created by Flatiron School on 8/9/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import Firebase
import FirebaseDatabase
import FBSDKLoginKit


struct CurrentUser {
    static var name: String?
    static var picture: UIImage?
    static var postings: [PlacePost]? 
   // static var friendsList: [Friend]?
    
    
  //  static var friend: Friend
    
    
    static let childName = "user"
    static let nameKey = "name"
    static let pictureKey = "picture"
    static let friendsKey = "friends"

    
}

struct Fr {
    static var pic: String?
    static var namz: String?
}

class PlaceUserDataStore {
    var dataSnapshot = [FIRDataSnapshot]()
    var ref: FIRDatabaseReference!
    var refHandle: FIRDatabaseHandle!
    var frr: UsersFriend?
    
    
    
    static let sharedDataStore = PlaceUserDataStore()
    private init(){}
    
    deinit{
        self.ref.removeObserverWithHandle(self.refHandle)
    }
   
    func loadDatabase(){
    
            self.ref = FIRDatabase.database().reference()
            refHandle = self.ref.child("user").observeEventType(.ChildAdded, withBlock: {snapshot in
            self.dataSnapshot.append(snapshot)
//                var userSnapshot = self.dataSnapshot[0]
//                var user = userSnapshot.value as! [String : String]
        })
    }
    


    
    func postToDataStore(nameKey: String, pictureKey: String, friendName: String, friendPic: String){
        print("post to data store")
        if let user = FIRAuth.auth()?.currentUser {
            let uid = user.uid
            let data = [ uid : [CurrentUser.nameKey: nameKey,
                CurrentUser.pictureKey: pictureKey,
                CurrentUser.friendsKey : [friendName: friendPic]]]
            self.ref.child(CurrentUser.childName).setValue(data)
            
        }
        
    }
    
    
    func facebookToFirebase(){
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                let name = user.displayName
                let email = user.email
                let photoUrl = user.photoURL
                let uid = user.uid
       self.getFriendsInfo()

                
                let data = NSData(contentsOfURL: photoUrl!)
                let currentUser = PlaceUser.init(withName: name!, lastName: "", profilePicture: UIImage(data: data!), postings: [])
                
                let storage = FIRStorage.storage()
                let storageRef = storage.referenceForURL("gs://teamliongroupproject.appspot.com/")
                let id = user.uid
                let imageRef = storageRef.child("users/userID/profile/\(id).png")
                let uploadTask = imageRef.putData(data!, metadata: nil) { metadata, error in
                    if (error != nil) {
                        print("did NOT upload picture to firebase")
                    } else {
                        // Metadata contains file metadata such as size, content-type, and download URL.
                        let downloadURL = metadata?.downloadURL()
                        let profilePicURLString = downloadURL?.absoluteString
                        let frname = self.frr?.name
                        let frpic = self.frr?.profilePicture
                        if let profilePicURLString = profilePicURLString{
                        }
                        self.postToDataStore(name!, pictureKey: profilePicURLString!, friendName: frname!, friendPic: frpic!)
                    }
                }
                self.loadDatabase()
                
                // User is signed in.
            } else {
                // No user is signed in.
            }
            
        }
    }
 
    
    
    func getFriendsInfo(){
        var name = String()
        var profilePicURL = String()
        let fbRequestFriends = FBSDKGraphRequest(graphPath:"/me/taggable_friends", parameters:["taggable_friends": "taggable_friends"]);
        fbRequestFriends.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            if error == nil {
                let a = result as? NSDictionary
                guard let b = a else {fatalError()}
                let c = b["data"]

                let d = c as? NSArray
                guard let e = d else {fatalError()}
                let f = e[0]

                let g = f as? NSDictionary
                guard let h = g else {fatalError()}
                let i = h["name"]
                
                //get friends name
                if let j = i{
                    name = j as! String}
                
                let k = f as? NSDictionary
                guard let l = k else {fatalError()}
                let m = l["picture"]
                
                let o = m as? NSDictionary
                guard let p = o else {fatalError()}
                let r = p["data"]
                
                let s = r as? NSDictionary
                guard let t = s else {fatalError()}
                let q = t["url"]
                
                //get friends profile pic
                if let u = q{
                    profilePicURL = u as! String}
            } else {
                print("Error Getting Friends \(error)");
            }
//            let friend = Friend(friendsName: name, friendsProfilePic: profilePicURL)
//            CurrentUser.friendsList?.append(friend)
           self.frr = UsersFriend.init(withName: name, profilePicture: profilePicURL)
        }

    }
    
}