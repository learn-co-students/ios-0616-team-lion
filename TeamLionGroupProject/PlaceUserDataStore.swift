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
import SwiftyJSON

struct CurrentUser {
    static var name: String?
    static var picture: UIImage?
    static var postings = [PlacePost]()
    static var friendsList = [UsersFriend]()
    
    
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
    //var frr: UsersFriend?

    
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
            //let data = [ uid : [CurrentUser.nameKey: nameKey,
            let data = [CurrentUser.nameKey: nameKey,
                CurrentUser.pictureKey: pictureKey]
            //self.ref.child(uid).setValue(data)
            self.ref.child(uid).updateChildValues(data as [NSObject : AnyObject])
            self.ref.child("\(uid)/friends").updateChildValues([friendName : friendPic])
            
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
                        for friend in CurrentUser.friendsList{
                        let frname = friend.name
                        let frpic = friend.profilePicture
                            print("to the database: \(frname)\(frpic)")
                        self.postToDataStore(name!, pictureKey: profilePicURLString!, friendName: frname, friendPic: frpic!)
                        }

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
            print(result)
            if error == nil {
                let json = JSON(result)

                guard let arrayOfUsers = json["data"].array else { return }
                //user id
                for dictionary in arrayOfUsers {
                    print("@@@@@@@ ID: \(dictionary["id"])")
                }
                
                for dictionary in arrayOfUsers {
                    let friendsName = String(dictionary["name"])
                    let friendPicture = String(dictionary["picture"]["data"]["url"])
                    print("@@@@@@@ picture: \(friendPicture)")
                    let friend = UsersFriend(withName: friendsName, profilePicture: friendPicture)
                    CurrentUser.friendsList.append(friend)
                }

            } else {
                print("Error Getting Friends \(error)");
            }

        }

    }
    
}