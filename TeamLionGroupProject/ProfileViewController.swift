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
import FBSDKLoginKit


class ProfileViewController: UIViewController {
let shared = PlaceUserDataStore.sharedDataStore
    
	var parentNavigationController : UINavigationController?
	
    var name: String?
    var picture: UIImage?
    var refreshControl = UIRefreshControl()
    var loginButton: FBSDKLoginButton = FBSDKLoginButton()
    let topFrame = UIImageView()
	var filteredArray = [PlacePost]()
    
	private let cellIdentifier = "Cell"
	private let headerIdentifier = "header"
	
	var collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.shared.getUserCredentialsForProfileVC { (result) in
            self.name = self.shared.currentUser.name
            self.picture = self.shared.currentUser.picture
        }
		
		for post in shared.postArray {
			if (post.userID == FIRAuth.auth()?.currentUser?.uid) {
				filteredArray.append(post)
			}
		}
		print("FILTERED ARRAY = \(filteredArray)")
		
		setupCollectionView()
        setupScene()
        

	}
    
    override func viewWillAppear(animated: Bool) {
            self.collectionView.reloadData()
        
    }
    
    func backgroundThread(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            if(background != nil){ background!(); }
            
            let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
            dispatch_after(popTime, dispatch_get_main_queue()) {
                if(completion != nil){ completion!(); }
            }
        }
    }
    
    func setupScene() {
        view.addSubview(loginButton)
//        loginButton.delegate = self
        loginButton.frame = CGRectMake(15, 30, 80, 30)
        loginButton.addTarget(self, action: #selector(backToLoginScreen), forControlEvents: .TouchUpInside)
    }

	func setupCollectionView() {
		
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 1
		layout.minimumInteritemSpacing = 1
		let blockDimension = (view.frame.width - 2)/3
		layout.itemSize = CGSize(width: blockDimension, height: blockDimension)
		layout.headerReferenceSize = CGSizeMake(0, CGRectGetHeight(view.frame)/3)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		
		collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
		collectionView.backgroundColor = UIColor.flatWhiteColor()
		collectionView.dataSource = self
		collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
		
		collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
		collectionView.registerClass(ProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.registerClass(PostViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
		
		view.addSubview(collectionView)
		
		collectionView.snp_makeConstraints { (make) in
			make.edges.equalTo(view.snp_edges)
		}
        
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.tintColor = UIColor.flatRedColor()
        refreshControl.addTarget(self, action:#selector(refresh) , forControlEvents: UIControlEvents.ValueChanged)
        collectionView.addSubview(refreshControl)
	}
}



extension ProfileViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.filteredArray.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! PostViewCell
		
		let url = NSURL(string: filteredArray[indexPath.item].itemImageURL!)
		cell.postImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "loadingImage"))
		
		return cell
	}
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
		let postDetailVC = PostDetailViewController()
		let post = filteredArray[indexPath.item]
		postDetailVC.itemTitle = post.itemTitle
		postDetailVC.itemPrice = post.price
		postDetailVC.itemDescription = post.itemDescription
        postDetailVC.email = post.email
        postDetailVC.fullName = post.name
		let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PostViewCell
		postDetailVC.itemImage = cell.postImage.image
		
		self.parentNavigationController?.pushViewController(postDetailVC, animated: true)
    }
	
	func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		
		switch kind {
		case UICollectionElementKindSectionHeader:

			let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerIdentifier, forIndexPath: indexPath) as! ProfileHeaderView
            let name = self.shared.currentUser.name
			headerView.delegate = self
            
            print("login - \(headerView.backToLoginScreen())")
            if (headerView.backToLoginScreen() == (true)){
                try! FIRAuth.auth()!.signOut()
                FBSDKAccessToken.setCurrentAccessToken(nil)
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginView")
                self.presentViewController(loginViewController, animated: true, completion: nil)
            }


			return headerView
		default: assert(false, "Unexpected element type")
		}
	}
}

extension ProfileViewController: ProfileHeaderViewDelegate {
    
    func newPostPressed(){
        
        print("new post from VC")
        let newPostVC = NewPostViewController()
        presentViewController(newPostVC, animated: true, completion: nil)
    }
	
	func friendsButtonPressed() {
        
        print("friends from VC")
	}
    
    func backToLoginScreen(){
        try! FIRAuth.auth()!.signOut()
        FBSDKAccessToken.setCurrentAccessToken(nil)
        dispatch_async(dispatch_get_main_queue()) {
            //self.showViewController(LoginViewController(), sender: nil)
        }
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let loginVC = storyboard.instantiateViewControllerWithIdentifier("LoginView")
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		appDelegate.window?.rootViewController = loginVC

    }
    
    func refresh(sender:AnyObject) {
        print ("Refreshing")
        self.shared.currentUser.postings.removeAll()
        
        self.shared.fetchPosts { (result) in
            self.shared.currentUser.postings.append(result)
            self.collectionView.reloadData()
            print(result)
        }
        
        self.refreshControl.endRefreshing()

    }
}
