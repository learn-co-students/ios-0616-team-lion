//
//  MarketplaceCollectionViewController.swift
//  TeamLionGroupProject
//
//  Created by Eldon Chan on 8/4/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import UIKit
import SnapKit
import ChameleonFramework
import DynamicButton
import Firebase
import SDWebImage

class MarketplaceCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UINavigationBarDelegate {
	
	var parentNavigationController : UINavigationController?
	
	var shared = PlaceUserDataStore.sharedDataStore
    var collectionView: UICollectionView!
    let topFrame = UIImageView()
    var posts = [FIRDataSnapshot]()
    var ref: FIRDatabaseReference!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shared.getUserCredentialsForProfileVC { (result) in
            print("result \(result)")
        }
		
        setUpCollectionCells()
        getAllPosts()
		

    }
    
    override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		self.edgesForExtendedLayout = UIRectEdge.None
		
		collectionView.reloadData()
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		self.edgesForExtendedLayout = UIRectEdge.None
	}

	func getAllPosts() {
		
		print("Before block")
		
		self.ref = FIRDatabase.database().reference()
		self.shared.postArray.removeAll()
		self.ref.child("posts").observeEventType(.ChildAdded, withBlock: {(snapshot) -> Void in
			print("running block")
			
			let data = snapshot.value!

			var post = PlacePost()
            if let descr = data["description"] as? String {
                post.itemDescription = descr
            }//*** APP IS CRASHING HERE *********
			post.price = data["price"] as! String						//*** VALUES OF NEW POST ARE NIL ***
			post.itemTitle = data["title"] as! String					//*** Firebase Database not updating
			post.userID = data["userID"] as! String
            post.email = data["email"] as! String
            post.itemImageURL = data["image"] as! String
            post.name = data["name"] as! String

			self.shared.postArray.append(post)
			
			self.collectionView.reloadData()
			print(data["description"])
			print(post.itemDescription)
			print(self.shared.postArray)

		})
	}
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shared.postArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("basicCell", forIndexPath: indexPath) as! PostViewCell
		
		let post = shared.postArray[indexPath.item]
		cell.priceLabel.text = "$\(post.price)"
		
		let url = NSURL(string: post.itemImageURL!)
		cell.postImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "loadingImage"))
		
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        let postDetailVC = PostDetailViewController()
		let post = shared.postArray[indexPath.item]
        postDetailVC.itemTitle = post.itemTitle
        postDetailVC.itemPrice = post.price
        postDetailVC.itemDescription = post.itemDescription
        postDetailVC.email = post.email
        postDetailVC.fullName = post.name
		let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PostViewCell
		postDetailVC.itemImage = cell.postImage.image
        
        self.parentNavigationController?.pushViewController(postDetailVC, animated: true)
    }
    
    func setUpCollectionCells() {
        
        let screenSize = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        //setup Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 110, right: 0)
        layout.itemSize = CGSize(width: screenWidth/2.005, height: screenWidth/2.005)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "basicCell")
        collectionView?.registerClass(PostViewCell.self, forCellWithReuseIdentifier: "basicCell")
        collectionView.backgroundColor = UIColor.flatWhiteColor()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        self.view.addSubview(collectionView)
        
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
    }
    
    
    
}