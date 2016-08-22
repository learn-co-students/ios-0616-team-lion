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
let shared = PlaceUserDataStore.sharedDataStore
    
    
    var name: String?
    var picture: UIImage?
    var refreshControl = UIRefreshControl()
    
	private let cellIdentifier = "Cell"
	private let headerIdentifier = "header"
	
	var collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.shared.getUserCredentialsForProfileVC { (result) in
            self.name = self.shared.currentUser.name
            self.picture = self.shared.currentUser.picture
        }
		setupCollectionView()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.tintColor = UIColor.flatRedColor()
        refreshControl.addTarget(self, action:#selector(refresh) , forControlEvents: UIControlEvents.ValueChanged)
        collectionView.addSubview(refreshControl)

	}
    
    override func viewWillAppear(animated: Bool) {
        self.shared.currentUser.postings.removeAll()
        
        self.shared.fetchPosts { (result) in
            self.shared.currentUser.postings.append(result)
            self.collectionView.reloadData()
            print(result)
        }
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
        postDetailVC.fullName = shared.currentUser.name
        postDetailVC.profilePic.image = shared.currentUser.picture
        
        self.presentViewController(postDetailVC, animated: true, completion:  nil)
    }
	
	func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		
		switch kind {
		case UICollectionElementKindSectionHeader:

			var headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerIdentifier, forIndexPath: indexPath) as! ProfileHeaderView
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
