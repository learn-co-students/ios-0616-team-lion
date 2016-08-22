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
    
    
    var name: String?
    var picture: NSURL?
    var refreshControl = UIRefreshControl()
    var loginButton: FBSDKLoginButton = FBSDKLoginButton()
    let topFrame = UIImageView()
    
	private let cellIdentifier = "Cell"
	private let headerIdentifier = "header"
	
	var collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
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
        view.addSubview(topFrame)
        topFrame.backgroundColor = UIColor.flatRedColor()
        topFrame.snp_makeConstraints { (make) in
            make.top.equalTo(view.snp_top)
            make.width.equalTo(view.snp_width)
            make.height.equalTo(view.snp_width).dividedBy(5.8)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "Profile"
        titleLabel.backgroundColor = UIColor.flatRedColor()
        titleLabel.textColor = UIColor.flatWhiteColor()
        titleLabel.font = UIFont(name: "Noteworthy", size: 28)
        view.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(topFrame.snp_bottom).offset(-5)
            make.centerX.equalTo(topFrame.snp_centerX)
        }
        
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
        layout.sectionInset = UIEdgeInsets(top: 60, left: 0, bottom: 50, right: 0)
		
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
		return self.shared.currentUser.postings.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! PostViewCell
    
		cell.postImage.image = shared.currentUser.postings[indexPath.item].itemImages[0]
		
		return cell
	}
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        let postDetailVC = PostDetailViewController()
        
        postDetailVC.itemTitle = shared.currentUser.postings[indexPath.item].itemTitle
        postDetailVC.itemPrice = shared.currentUser.postings[indexPath.item].price
        postDetailVC.descriptionField.text = shared.currentUser.postings[indexPath.item].itemDescription
        postDetailVC.itemImage = shared.currentUser.postings[indexPath.item].itemImages[0]
        postDetailVC.fullName = shared.currentUser.name!
        postDetailVC.profilePic.image = shared.currentUser.picture
        
        self.presentViewController(postDetailVC, animated: true, completion:  nil)
    }
	
	func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		
		switch kind {
		case UICollectionElementKindSectionHeader:

			var headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerIdentifier, forIndexPath: indexPath) as! ProfileHeaderView
            if let name  = self.shared.currentUser.name {
            headerView.setUpForUser(name, picture: self.shared.currentUser.picture!)
            }
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
            self.showViewController(LoginViewController(), sender: nil)
			
        }

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
