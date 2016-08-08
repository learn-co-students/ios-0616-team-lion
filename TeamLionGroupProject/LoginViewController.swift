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
    var loginButton: FBSDKLoginButton = FBSDKLoginButton()
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
//facebook login button viewcontroller
  
    
	override func viewDidLoad() {
		super.viewDidLoad()
        self.loginButton.hidden = true
        
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
           
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in.
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let profileViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ProfileView")
                
                self.presentViewController(profileViewController, animated: true, completion: nil)
            } else {
                // No user is signed in.
                self.loginButton.center = self.view.center
                self.loginButton.readPermissions = ["public_profile", "email", "user_friends"]
                self.loginButton.delegate = self
                self.view!.addSubview(self.loginButton)
                
                self.loginButton.hidden = false
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
        self.activityIndicator.startAnimating()
        if(error != nil){
            self.loginButton.hidden = false
            self.activityIndicator.stopAnimating()

        }else if(result.isCancelled){
            self.loginButton.hidden = false
            self.activityIndicator.stopAnimating()
        }else{
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                print("user logged in to firebase app")
        }
        
        

        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("user did log out")
    }
}

