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
		
		print(FIRAuth.auth()?.currentUser)
		FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth: FIRAuth, user: FIRUser?) in
			print("THIS IS THE USER = \(user)")
			
			//**** THE USER IS NIL EVEN IF AUTHENTICATED NEED A DIFFERENT IF CHECK OR NEED TO FIGURE OUT WHAT
			//**** FB USES AS THEIR "USER"
			
			if user != nil {
				//Facebook user info
				//profileViewController.name = user.displayName
				//profileViewController.picture = user.photoURL
				
				self.moveToMarket()
				
			} else {
				print("Unauthorized")
			}
		})
	}
    
	override func viewDidLoad() {
		super.viewDidLoad()
        self.loginButton.hidden = true

		
		self.loginButton.center = self.view.center
		self.loginButton.readPermissions = ["public_profile", "email", "user_friends", "read_custom_friendlists"]
		self.loginButton.delegate = self
		self.view!.addSubview(self.loginButton)
		self.loginButton.hidden = false
		
		let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters:["fields": "friends"]);
		fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
			
			if error == nil {
//				print("\n\n\nfriends\n\n\n")
//				print("Friends are : \(result)")
				
			} else {
				
				print("Error Getting Friends \(error)");
				
			}
		}
		
		setupScene()

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
				
				self.moveToMarket()
				
			}
		}
	}
	
	
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("user did log out")
    }
	
	func moveToMarket() {
		let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
		let tabBar = mainStoryboard.instantiateViewControllerWithIdentifier("tabBar") as! TabBarController
		self.presentViewController(tabBar, animated:true, completion: nil)
	}
	
	func setupScene() {
		
		let logoFont = "AvenirNext-Regular"
		let subLabelFont = "AvenirNext-Italic"
		let placeLabel = UILabel()
		let placeSublabel = UILabel()
		let backgroundImage = UIImage(named: "LoginBackground")
		let divider = UIImage(named: "LoginScreenLine")
		let backgroundImageView = UIImageView()
		let dividerView = UIImageView()
		
		view.addSubview(backgroundImageView)
		backgroundImageView.image = backgroundImage
		backgroundImageView.snp_makeConstraints { (make) in
			make.edges.equalTo(view.snp_edges)
		}
		
		view.addSubview(placeLabel)
		placeLabel.text = "place"
		placeLabel.font = UIFont(name: logoFont, size: 60)
		placeLabel.textAlignment = .Center
		placeLabel.textColor = UIColor.darkGrayColor()
		placeLabel.snp_makeConstraints { (make) in
			make.centerX.equalTo(view.snp_centerX)
			make.centerY.equalTo(view.snp_centerY).dividedBy(3)
			make.width.equalTo(view.snp_width)
		}
		
		view.addSubview(placeSublabel)
		placeSublabel.text = "a market for friends"
		placeSublabel.font = UIFont(name: subLabelFont, size: 20)
		placeSublabel.textAlignment = .Center
		placeSublabel.textColor = UIColor.wetAsphaltColor()
		placeSublabel.snp_makeConstraints { (make) in
			make.top.equalTo(placeLabel.snp_bottom).offset(2)
			make.centerX.equalTo(placeLabel.snp_centerX)
			make.width.equalTo(placeLabel.snp_width)
		}
		view.addSubview(dividerView)
		dividerView.image = divider
		dividerView.contentMode = UIViewContentMode.ScaleAspectFit
		dividerView.snp_makeConstraints { (make) in
			make.centerX.equalTo(placeLabel.snp_centerX)
			make.width.equalTo(view.snp_width).dividedBy(2)
			make.height.equalTo(view.snp_height).dividedBy(30)
			make.top.equalTo(placeSublabel.snp_bottom)
		}
		
		view.bringSubviewToFront(loginButton)
	}
	
	
}

