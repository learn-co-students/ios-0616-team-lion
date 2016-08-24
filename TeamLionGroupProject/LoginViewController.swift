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
    let datastore = PlaceUserDataStore.sharedDataStore
    let fbButton = UIButton()
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
		
		print(FIRAuth.auth()?.currentUser)
		FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth: FIRAuth, user: FIRUser?) in
			if user != nil {
				
				self.moveToMarket()
				
			} else {
				print("Unauthorized")
			}
		})
	}
    
	override func viewDidLoad() {
		super.viewDidLoad()
        view.addSubview(fbButton)
        fbButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(view.snp_bottom).offset(-20)
            make.centerX.equalTo(view.snp_centerX)
            make.height.equalTo(view.snp_height).dividedBy(10)
            make.width.equalTo(view.snp_width).dividedBy(2.5)
        }
        fbButton.backgroundColor = UIColor.flatRedColor()
        fbButton.layer.masksToBounds = true
        fbButton.layer.cornerRadius = view.frame.height/20
        fbButton.layer.borderWidth = 1
        fbButton.layer.borderColor = UIColor.whiteColor().CGColor
        fbButton.titleLabel?.textColor = UIColor.redColor()
        fbButton.setTitle("Login", forState: .Normal)
        fbButton.titleLabel!.font = UIFont(name: "HelveticaNeue", size: fbButton.titleLabel!.font.pointSize)
        fbButton.addTarget(self, action: #selector(connectWithFacebook), forControlEvents: .TouchUpInside)
        
        
        
        
        
        
        
        
        
        self.loginButton.hidden = true

		
		self.loginButton.center = self.view.center
		self.loginButton.readPermissions = ["public_profile", "email", "user_friends", "read_custom_friendlists"]
		self.loginButton.delegate = self
		self.view!.addSubview(self.loginButton)
		self.loginButton.hidden = false
		
		let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters:["fields": "friends"]);
		fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
			
			if error == nil {
				
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
    
    
    func connectWithFacebook(){
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            FBSDKLoginManager().logOut()
            return
        }
        
        let login:FBSDKLoginManager = FBSDKLoginManager()
        login.logInWithReadPermissions(["email"], handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            if(error != nil){
                FBSDKLoginManager().logOut()
            }else if(result.isCancelled){
                FBSDKLoginManager().logOut()
            }else{
                //Handle login success
            }
        })
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

				self.shared.facebookToFirebase({ (result) in
                    print("FROM LOGIN\(self.datastore.currentUser.name)")
                    print("FROM LOGIN\(self.datastore.currentUser.picture)")
                })
                self.shared.currentUser.postings.removeAll()

                self.datastore.fetchPosts { (result) in
                    self.shared.currentUser.postings.append(result)
                    print("POOOOOOST\(self.shared.currentUser.postings)")
                }
				self.moveToMarket()
				
			}
		}
	}
	
	
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("user did log out")
    }
	
	func moveToMarket() {
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let naviVC = storyboard.instantiateViewControllerWithIdentifier("NavigationVC") as! UINavigationController
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		appDelegate.window?.rootViewController = naviVC

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

