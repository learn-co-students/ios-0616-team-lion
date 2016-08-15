//
//  ViewController.swift
//  TeamLionGroupProject
//
//  Created by David Park on 8/4/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
   
  
    let shared = PlaceUserDataStore.sharedDataStore
    var loginButton: FBSDKLoginButton = FBSDKLoginButton()
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
      
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
        self.loginButton.hidden = true
      
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if var user = user {
                // User is signed in.
                print("\n\n\nuser\(user)\n\n\n")

                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let profileViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ProfileView") as! ProfileViewController
                profileViewController.name = user.displayName
                profileViewController.picture = user.photoURL
              
                self.presentViewController(profileViewController, animated: true, completion: nil)
            } else {
                // No user is signed in.
                self.loginButton.center = self.view.center
                self.loginButton.readPermissions = ["public_profile", "email", "user_friends", "read_custom_friendlists"]
                self.loginButton.delegate = self
                self.view!.addSubview(self.loginButton)
                self.loginButton.hidden = false
                
                let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters:["fields": "friends"]);
                fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                    
                    if error == nil {
                        print("\n\n\nfriends\n\n\n")
                        print("Friends are : \(result)")
                        
                    } else {
                        
                        print("Error Getting Friends \(error)");
                        
                    }
                }

                
                
                
            }
        }
        // Optional: Place the button in the center of your view.


		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("user logged in")
        self.loginButton.hidden = true
        if(error != nil){
            self.loginButton.hidden = false

        }else if(result.isCancelled){
            self.loginButton.hidden = false
        }else{
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                print("\n\n\n\n\nuser logged in to firebase app\n\n\n\n")
                print("\n\n\n\(credential.description)\n\n\n")
                self.shared.facebookToFirebase()

        }
        
        

        }
    }
   
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("user did log out")
    }
}

