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



class PlaceUserDataStore {
    var dataSnapshot = [FIRDataSnapshot]()
    var postsDataSnapshot = [FIRDataSnapshot]()
    var ref: FIRDatabaseReference!
    var refHandle: FIRDatabaseHandle!
    let randomNumber = arc4random_uniform(5000000)
    var currentUser = CurrentUser()
    var dictionaryOfPosts = [String: String]()
    static let sharedDataStore = PlaceUserDataStore()
    private init(){}
    var postRef = FIRDatabaseReference()
    deinit{
        self.ref.removeObserverWithHandle(self.refHandle)
    }
   
    func loadDatabase(){
            let uid = FIRAuth.auth()?.currentUser?.uid
            self.ref = FIRDatabase.database().reference()
            refHandle = self.ref.child(uid!).observeEventType(.ChildAdded, withBlock: {snapshot in
            self.dataSnapshot.append(snapshot)
            guard let snapshotData = snapshot.value!["user"] as? [String: String] else{  print("error getting snapshot"); return }
                print("SNAPSHOT\(snapshotData)")

        })
    }
    
    
    func fetchPosts(completion: (result: PlacePost) -> Void){
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).child("posts").observeEventType(.ChildAdded, withBlock: {(snapshot) in
        self.postsDataSnapshot.append(snapshot)
            guard let snapshotData = snapshot.value as? [String: String] else{  print("error getting snapshot"); return }

            var post = PlacePost( itemImages: [], itemTitle: "", itemDescription: "", price: 0)
            
            if let snapshotdataDescription = snapshotData["description"]{
                post.itemDescription = snapshotdataDescription
            } else{  print("description error"); return }
            
            
            let str = snapshotData["image"]
            //print(str)
            if str == str {
                //print("str:\(str)")
            guard let url = NSURL(string: str!) else {print("no image"); return}
                guard let data = NSData(contentsOfURL: url)else{return} //make sure your image in this url does exist, otherwise unwrap in a if let check
            post.itemImages.append(UIImage(data: data)!)

            }
            post.itemTitle = snapshotData["title"]!
            post.price = Int(snapshotData["price"]!)!
            //self.currentUser.postings.append(post)
            completion(result: post)
            print("222POST\(post)")
        }, withCancelBlock: nil)


    }

    
    func postToDataStore(nameKey: String, pictureKey: String, friendName: String, friendPic: String){
        print("post to data store")
        if let user = FIRAuth.auth()?.currentUser {
            let uid = user.uid
            let data = [CurrentUser.nameKey: nameKey,
                CurrentUser.pictureKey: pictureKey]
            //self.ref.child(uid).setValue(data)
            self.ref.child("users/\(uid)").updateChildValues(data as [NSObject : AnyObject])
            //self.ref.child(uid).updateChildValues(data as [NSObject : AnyObject])
            self.ref.child("users/\(uid)/friends").updateChildValues([friendName : friendPic])
        }
        
    }
    
    func postPictureToDatabase(pictue: UIImage, title: String, desciption: String, price: String) {
        var piccopy = UIImage()
        piccopy = pictue
        let postImageData: NSData = UIImagePNGRepresentation(piccopy)!
        
        let storage = FIRStorage.storage()
        let storageRef = storage.referenceForURL("gs://teamliongroupproject.appspot.com/")
        
        let postImageRef = storageRef.child("users/userID/posts/\(self.postRef).png")
        let uploadTask = postImageRef.putData(postImageData, metadata: nil) { metadata, error in
            if (error != nil) {
                print("did NOT upload picture to firebase")
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata?.downloadURL()
                
                let postPicURLString = downloadURL?.absoluteString
                let picID = String(self.randomNumber)
                if let user = FIRAuth.auth()?.currentUser {
                    let uid = user.uid
                    let userRef = self.ref.child("users/\(uid)/posts")
                    self.postRef = userRef.childByAutoId()
                    print(self.postRef)
//                    let postID = String(self.randomNumber)
                    self.postRef.updateChildValues(["title": title])
                    self.postRef.updateChildValues(["price": price])
                    self.postRef.updateChildValues(["description": desciption])
                    self.postRef.updateChildValues(["image": postPicURLString!])
                    
                    //self.ref.child("\(uid)/posts").updateChildValues([title : [postPicURLString!, desciption, price]])

                }

            }
        }
        self.loadDatabase()
        // User is signed in.
    }


    func facebookToFirebase(completion: (result: (String, UIImage)) -> Void){
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                let name = user.displayName
                let email = user.email
                let photoUrl = user.photoURL
                let uid = user.uid
       self.getFriendsInfo()

                
                let data = NSData(contentsOfURL: photoUrl!)
                self.currentUser.name = name
                self.currentUser.picture = UIImage(data:data!,scale:1.0)

                let storage = FIRStorage.storage()
                let storageRef = storage.referenceForURL("gs://teamliongroupproject.appspot.com/")
                let id = user.uid
                
                let imageRef = storageRef.child("users/\(id)/profile/profilePic\(id).png")
                let uploadTask = imageRef.putData(data!, metadata: nil) { metadata, error in
                    if (error != nil) {
                        print("did NOT upload picture to firebase")
                    } else {
                        // Metadata contains file metadata such as size, content-type, and download URL.
                        let downloadURL = metadata?.downloadURL()
                        let profilePicURLString = downloadURL?.absoluteString
                        for friend in self.currentUser.friendsList{
                        let frname = friend.name
                        let frpic = friend.profilePicture
                           // print("to the database: \(frname)\(frpic)")
                        self.postToDataStore(name!, pictureKey: profilePicURLString!, friendName: frname, friendPic: frpic!)
                        }

                    }
                }
                self.loadDatabase()
                // User is signed in.
            } else {
                // No user is signed in.
            }
 completion(result: (self.currentUser.name!, self.currentUser.picture!))
        }
    }
 
    
    
    func getFriendsInfo(){
        var name = String()
        var profilePicURL = String()
        let fbRequestFriends = FBSDKGraphRequest(graphPath:"/me/taggable_friends", parameters:["taggable_friends": "taggable_friends"]);
        fbRequestFriends.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            if error == nil {
                let json = JSON(result)
print("JSON FROM FRIEND FUNC\(json)")
                self.fetchUser({ (result) in
                    print("whatever\(result)")
                })
                guard let arrayOfUsers = json["data"].array else { return }
                for dictionary in arrayOfUsers {
                    let friendsName = String(dictionary["name"])
                    let friendPicture = String(dictionary["picture"]["data"]["url"])
                    let friend = UsersFriend(withName: friendsName, profilePicture: friendPicture)
                    self.currentUser.friendsList.append(friend)
                }
            } else {
                print("Error Getting Friends \(error)");
            }
        }
    }

    

    
    
    
    
    
    
    func fetchUser(completion: (result: String) -> Void){
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").observeEventType(.ChildAdded, withBlock: {(snapshot) in
            self.postsDataSnapshot.append(snapshot)
            let blah  = JSON(snapshot.value!)

            let friendsPost = blah["posts"]
            guard let dict = blah["posts"].dictionary else {print("nope"); return}
            print("database     \(blah)")
            print("dictionay   \(dict)")
            
            var storePostsToArray = [String]()

            completion(result: uid!)
            print("222 \(uid)")
            }, withCancelBlock: nil)
        
    }
    
    
    
    
    func testing(){
    
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            
            self.facebookToFirebase({ (result) in

            })
            self.currentUser.postings.removeAll()
            
            self.fetchPosts { (result) in
                self.currentUser.postings.append(result)
            }
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBar = mainStoryboard.instantiateViewControllerWithIdentifier("tabBar") as! TabBarController
            //self.presentViewController(tabBar, animated:true, completion: nil)
        }
    }
    
    
    
    
    
    
}