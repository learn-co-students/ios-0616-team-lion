//
//  ProfileViewController.swift
//  TeamLionGroupProject
//
//  Created by Eldon Chan on 8/4/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FirebaseAuth
class ProfileViewController: UIViewController {
//var storyboard: UIStoryboard?
//let profileViewController = storyboard.instantiateViewControllerWithIdentifier(identifier: "profileView")
    var profilePicture: UIImageView!
    var homeLabel: UILabel = UILabel()
    let logoutButton = UIButton(type: UIButtonType.System) as UIButton
    let userNameLabel: UILabel = UILabel()

    override func viewDidLoad() {
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                let name = user.displayName
                let email = user.email
                let photoUrl = user.photoURL
                let uid = user.uid
                
                self.userNameLabel.text = name
                let data = NSData(contentsOfURL: photoUrl!)
                self.profilePicture.image = UIImage(data: data!)
                // User is signed in.
            } else {
                // No user is signed in.
            }
        }
        
        
        
        
        
        profilePicture = UIImageView(frame:CGRectMake(100, 50, 200, 200))
        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2
        self.profilePicture.clipsToBounds = true
        view.addSubview(profilePicture)
        
        
        userNameLabel.frame = CGRectMake(100, 280, 200, 21)
        //dynamicLabel.backgroundColor = UIColor.orangeColor()
        userNameLabel.textColor = UIColor.blackColor()
        userNameLabel.textAlignment = NSTextAlignment.Center
        userNameLabel.text = "User Name"
        self.view.addSubview(userNameLabel)

        
        
        
        homeLabel.frame = CGRectMake(100, 30, 200, 21)
        //dynamicLabel.backgroundColor = UIColor.orangeColor()
        homeLabel.textColor = UIColor.blackColor()
        homeLabel.textAlignment = NSTextAlignment.Center
        homeLabel.text = "Home"
        self.view.addSubview(homeLabel)
        
        
        
        //dunamicButton.backgroundColor = UIColor.grayColor()
        logoutButton.setTitle("Log out", forState: UIControlState.Normal)
        logoutButton.frame = CGRectMake(150, 300, 100, 50)
        logoutButton.addTarget(self, action: #selector(ProfileViewController.buttonTouched(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(logoutButton)

    }
    
    func buttonTouched(sender:UIButton!){
        try! FIRAuth.auth()!.signOut()
        FBSDKAccessToken.setCurrentAccessToken(nil)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginView")
        
        self.presentViewController(loginViewController, animated: true, completion: nil)
        print("It Works!!!")
    }
    //facebook picture
    // the home screen homeviewcontroller

}
