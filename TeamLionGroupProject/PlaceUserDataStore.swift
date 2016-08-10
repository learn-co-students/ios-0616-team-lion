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


struct CurrentUser {
    static var name: String?
    static var picture: UIImage?
    static var postings: [PlacePost]?
    
    
    static let childName = "user"
    static let nameKey = "name"
    static let pictureKey = "picture"
    
}

class PlaceUserDataStore {
    var dataSnapshot = [FIRDataSnapshot]()
    var ref: FIRDatabaseReference!
    var refHandle: FIRDatabaseHandle!

    
    
    
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
    

    
    
    func postToDataStore(nameKey: String, pictureKey: String){
        print("post to data store")
        let uid = FIRAuth.auth()?.currentUser!.uid
        print(uid)
        let data = [ uid! : [CurrentUser.nameKey: nameKey,
            CurrentUser.pictureKey: pictureKey]]
        self.ref.child(CurrentUser.childName).setValue(data)
    }
    

    
    func facebookToFirebase(){
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                let name = user.displayName
                let email = user.email
                let photoUrl = user.photoURL
                let uid = user.uid
                
                
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
                        if let profilePicURLString = profilePicURLString{
                        }
                        self.postToDataStore(name!, pictureKey: profilePicURLString!)
                    }
                }
                self.loadDatabase()
                
                // User is signed in.
            } else {
                // No user is signed in.
            }
        }
    }
 
    
}