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


struct CurrentUser {
    static var name: String?
    static var picture: UIImage?
    static var postings: [PlacePost]?
}

class PlaceUserDataStore {
    
    static let sharedDataStore = PlaceUserDataStore()
    private init(){}
    
    
    func test(){
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
                
                let imageRef = storageRef.child("photoURL")
                let uploadTask = imageRef.putData(data!, metadata: nil) { metadata, error in
                    if (error != nil) {
                        print("did NOT upload picture to firebase")
                    } else {
                        // Metadata contains file metadata such as size, content-type, and download URL.
                        let downloadURL = metadata!.downloadURL
                        print("\n\n\n\n\n\(downloadURL)")
                    }
                }
                
                
                // User is signed in.
            } else {
                // No user is signed in.
            }
        }
    }
 
    
}