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
    var currentUser = CurrentUser()
    var aUser = CurrentUser()
    var currentPost = PlacePost()
    var dictionaryOfPosts = [String: String]()
    static let sharedDataStore = PlaceUserDataStore()
    var uid = ""
    private init(){}
    var postRef = FIRDatabaseReference()
	var postArray = [PlacePost]()
    deinit{
        self.ref.removeObserverWithHandle(self.refHandle)
    }
   
    func loadDatabase(){
            let uid = FIRAuth.auth()?.currentUser?.uid
            self.ref = FIRDatabase.database().reference()
            refHandle = self.ref.child(uid!).observeEventType(.ChildAdded, withBlock: {snapshot in
            self.dataSnapshot.append(snapshot)
            guard let snapshotData = snapshot.value!["user"] as? [String: String] else{  print("error getting snapshot"); return }

        })
    }
    
    
    func fetchPosts(completion: (result: PlacePost) -> Void){
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).child("posts").observeEventType(.ChildAdded, withBlock: {(snapshot) in
        self.postsDataSnapshot.append(snapshot)
            guard let snapshotData = snapshot.value as? [String: String] else{  print("error getting snapshot"); return }

			var post = PlacePost( itemImages: UIImage(), itemImageURL: "", itemTitle: "", itemDescription: "", price: "0", user: self.aUser, userID: "")
            
            if let snapshotdataDescription = snapshotData["description"]{
                post.itemDescription = snapshotdataDescription
            } else{  print("description error"); return }
            
            
            let str = snapshotData["image"]
            if str == str {
            guard let url = NSURL(string: str!) else {print("no image"); return}
                guard let data = NSData(contentsOfURL: url)else{return} //make sure your image in this url does exist, otherwise unwrap in a if let check
            //post.itemImages.append(UIImage(data: data)!)

            }
            post.itemTitle = snapshotData["title"]!
            post.price = snapshotData["price"]!
            completion(result: post)
        }, withCancelBlock: nil)


    }

    
    func postToDataStore(nameKey: String, pictureKey: String){
        print("post to data store")
        if let user = FIRAuth.auth()?.currentUser {
            let uid = user.uid
            let data = [CurrentUser.nameKey: nameKey,
                CurrentUser.pictureKey: pictureKey]
            self.ref.child("users/\(uid)").updateChildValues(data as [NSObject : AnyObject])
            //self.ref.child("users/\(uid)/friends").updateChildValues([friendName : friendPic])
        }
        
    }
    
    func postPictureToDatabase(pictue: UIImage, title: String, description: String, price: String, userID: String) {
        var piccopy = UIImage()
        piccopy = pictue
        let postImageData: NSData = UIImagePNGRepresentation(piccopy)!
        
        let storage = FIRStorage.storage()
        let storageRef = storage.referenceForURL("gs://teamliongroupproject.appspot.com/")
        self.ref = FIRDatabase.database().reference()
        let userRef = self.ref.child("posts")		//******* THIS IS WHERE **********
        self.postRef = userRef.childByAutoId()
        
		let user = FIRAuth.auth()?.currentUser?.uid
        print("POSTREF = \(self.postRef)")
        let autoID = String(postRef).stringByReplacingOccurrencesOfString("https://teamliongroupproject.firebaseio.com/posts/", withString: "")
        let postImageRef = storageRef.child("users/\(user)/posts/\(autoID).jpeg")

        let uploadTask = postImageRef.putData(postImageData, metadata: nil) { metadata, error in
            if (error != nil) {
                print("did NOT upload picture to firebase")
            } else {
                // Metadata contains file metadata such as size,1 content-type, and download URL.
                let downloadURL = metadata?.downloadURL()
                
                let postPicURLString = downloadURL?.absoluteString
                if let user = FIRAuth.auth()?.currentUser {
                    let uid = user.uid
					print("PRINTING \(self.ref.child("posts"))")
                    		//******* THE APP IS CRASHING ****
					print("USERREF = \(userRef)")				//******* REF IS NIL *************
					
//                    self.postRef.updateChildValues(["title": title])
//                    self.postRef.updateChildValues(["price": price])
//                    self.postRef.updateChildValues(["description": description])
//                    self.postRef.updateChildValues(["image": postPicURLString!])
//                    self.postRef.updateChildValues(["userID": userID])
                    
                    let postData = ["title": title, "price": price, "description": description, "image": postPicURLString!, "userID": userID]
                    self.postRef.setValue(postData)
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

       //self.getFriendsInfo()

                
                let data = NSData(contentsOfURL: photoUrl!)
                self.currentUser.name = name!
                self.currentUser.picture = UIImage(data:data!,scale:1.0)!

                let storage = FIRStorage.storage()
                let storageRef = storage.referenceForURL("gs://teamliongroupproject.appspot.com/")
                let id = user.uid
                
                let imageRef = storageRef.child("users/\(id)/profile/profilePic\(id).png")
                let uploadTask = imageRef.putData(data!, metadata: nil) { metadata, error in
                    if (error != nil) {
                        print("did NOT upload picture to firebase")
                    } else {
                        
                        let downloadURL = metadata?.downloadURL()
                        let profilePicURLString = downloadURL?.absoluteString
                        //for friend in self.currentUser.friendsList{
                        //let frname = friend.name
                        //let frpic = friend.profilePicture
                        self.postToDataStore(name!, pictureKey: profilePicURLString!)
                        //}

                    }
                }
                self.loadDatabase()
                // User is signed in.
            } else {
                // No user is signed in.
            }
 completion(result: (self.currentUser.name, self.currentUser.picture))
        }
    }
  
    
    func getFriendsInfo(){
        var name = String()
        var profilePicURL = String()
        let fbRequestFriends = FBSDKGraphRequest(graphPath:"/me/taggable_friends", parameters:["taggable_friends": "taggable_friends"]);
        fbRequestFriends.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            if error == nil {
                let json = JSON(result)
                guard let arrayOfUsers = json["data"].array else { return }
                //for dictionary in arrayOfUsers {
                    //let friendsName = String(dictionary["name"])
                    //let friendPicture = String(dictionary["picture"]["data"]["url"])
                    //let friend = UsersFriend(withName: friendsName, profilePicture: friendPicture)
                   // self.currentUser.friendsList.append(friend)
                //}
            } else {
                print("Error Getting Friends \(error)");
            }
        }
    }

    

    
    
    
    
    //fetchpost func
    func getAllPostsByUid(completion: (result: PlacePost) -> Void){
        self.ref = FIRDatabase.database().reference()
        
        self.ref.child("users").observeEventType(.Value, withBlock: {(snapshot) in
            let usersDict = snapshot.value as! [String : AnyObject]
            let keys = usersDict.keys
            
            //for each key get info:
            for key in keys{
                //print("is this getting called keys \(key)")

                self.uid = key
                let anotherDict = usersDict[key] as! NSDictionary
                self.aUser.name = String(anotherDict["name"])
                self.aUser.email = String(anotherDict["email"])
                
                //calls only one name if uncomment profile picture
                print("is this getting called? name   \(self.aUser.name)")

                
//                let str = anotherDict["picture"] as? String
//                if let unwrappedString = str {
//                    let stringWithPNG = unwrappedString + ".png"
//                    guard let url = NSURL(string: stringWithPNG) else {print("no image"); return}
//                    guard let data = NSData(contentsOfURL: url)else{return} //make sure your image in this url does exist, otherwise unwrap in a if let check
//                    self.aUser.picture = (UIImage(data: data)!)
//                    
//                    
//                    //not getting called?
//                    print("is this getting called? picture   \(self.aUser.picture)")
//                    
//                }
                
                
                
                
//                print("TESTTESTTESTTESTTESTTESTTEST        \(self.currentUser.name)")
//                print("EMAIL        \(self.currentUser.email)")
//                print("PICTURE        \(self.currentUser.picture)")

//                self.currentUser.email = String(anotherDict["email"])
//                guard let url = NSURL(string: String(anotherDict["picture"])) else {print("no image"); return}
//                guard let data = NSData(contentsOfURL: url)else{return}
//                self.currentUser.picture = UIImage(data: data)!
//                let blah = anotherDict["posts"] as! NSDictionary
//                self.currentPost.itemTitle = String(blah["title"])
//                print("TEST")
//
//                print("POSTPOSTPOST        \(blah)")

                

        FIRDatabase.database().reference().child("users").child(self.uid).child("posts").observeEventType(.ChildAdded, withBlock: {(snapshot) in
            guard let snapshotData = snapshot.value as? [String: String] else{  print("error getting snapshot"); return }
            
            var post = PlacePost( itemImages: UIImage(), itemImageURL: "", itemTitle: "", itemDescription: "", price: "0", user: self.aUser, userID: "")
            print("auser within post \(self.aUser.name)")
            if let snapshotdataDescription = snapshotData["description"]{
                post.itemDescription = snapshotdataDescription
            } else{  print("description error"); return }
            
            
            let str = snapshotData["image"]
            if str == str {
                guard let url = NSURL(string: str!) else {print("no image"); return}
                guard let data = NSData(contentsOfURL: url)else{return} //make sure your image in this url does exist, otherwise unwrap in a if let check
           //     post.itemImages.append(UIImage(data: data)!)
                
            }
            post.itemTitle = snapshotData["title"]!
            post.price = snapshotData["price"]!
            print("FRIENDSPOST \(post)")

            completion(result: post)
            }, withCancelBlock: nil)
            }
        }, withCancelBlock: nil)
        
    }

    
    func getPostsForProfileView(){
        self.ref = FIRDatabase.database().reference()
        self.ref.child("posts").observeEventType(.ChildAdded, withBlock: {(snapshot) -> Void in
            print(snapshot)
            
            
            var post = snapshot.value as! Dictionary<String,String>
            
            if post["userID"] == FIRAuth.auth()?.currentUser?.uid{
                //display posts
            }else{
                //whatever
            }
    })
    }
    
    
    
    func getUserEmail(){
        self.ref = FIRDatabase.database().reference()
        self.ref.child("posts").observeEventType(.ChildAdded, withBlock: {(snapshot) -> Void in
            print("PRINTING SNAPSHOT   \(snapshot)")
            
            
            var post = snapshot.value as! Dictionary<String,String>
            
            if post["userID"] == FIRAuth.auth()?.currentUser?.uid{
                //do nothing
            }else{
                //whatever
            }
        })
    }
    
    
    
    
    func getUserCredentialsForProfileVC(completion: (result: (String, UIImage, String, String)) -> Void){
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                self.currentUser.name = user.displayName!
                self.currentUser.email = user.email!
                
                let data = NSData(contentsOfURL: user.photoURL!)
                self.currentUser.picture = UIImage(data:data!,scale:1.0)!
                self.currentUser.userID = user.uid

                // User is signed in.
            } else {
                // No user is signed in.
            }
            print("name \(self.currentUser.name)")
            print("picture \(self.currentUser.picture)")
            print("email \(self.currentUser.email)")
            print("userID \(self.currentUser.userID)")
            completion(result: (self.currentUser.name, self.currentUser.picture, self.currentUser.email, self.currentUser.userID))
        }
    }

    
}