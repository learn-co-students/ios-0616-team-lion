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
    var shared = PlaceUserDataStore.sharedDataStore
    var collectionView: UICollectionView!
    let topFrame = UIImageView()
    var posts = [FIRDataSnapshot]()
    var ref: FIRDatabaseReference!
//	var imageUrlArray = [String]()
	var postArray = [PlacePost]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shared.getUserCredentialsForProfileVC { (result) in
            print("result \(result)")
        }
		
        setUpCollectionCells()

        getAllPosts()
		
    }
    
    override func viewWillAppear(animated: Bool) {
        tabBarController?.tabBar.hidden = false
		
		
		collectionView.reloadData()
    }
    
    

	func getAllPosts() {
		
		print("Before block")
		
		self.ref = FIRDatabase.database().reference()
		self.ref.child("posts").observeEventType(.ChildAdded, withBlock: {(snapshot) -> Void in

			let data = snapshot.value!
//			let imageURL = data["image"] as! String
//			self.imageUrlArray.append(imageURL)
			
			
			var post = PlacePost()
			post.itemDescription = data["description"] as! String
			post.price = data["price"] as! String
			post.itemTitle = data["title"] as! String
			post.userID = data["userID"] as! String
			post.itemImageURL = data["image"] as! String

			self.postArray.append(post)
			
			self.collectionView.reloadData()
			
			print(self.postArray)

			
			
		})
	}
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("basicCell", forIndexPath: indexPath) as! PostViewCell
		
		let post = postArray[indexPath.item]
		cell.priceLabel.text = "$\(post.price)"
		
		let url = NSURL(string: post.itemImageURL)
		cell.postImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "loadingImage"))
		
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        let postDetailVC = PostDetailViewController()
		let post = postArray[indexPath.item]
        postDetailVC.itemTitle = post.itemTitle
        postDetailVC.itemPrice = post.price
        postDetailVC.itemDescription = post.itemDescription
		let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PostViewCell
		postDetailVC.itemImage = cell.postImage.image
        
        self.presentViewController(postDetailVC, animated: true, completion:  nil)
    }
    
    func setUpCollectionCells() {
        
        let screenSize = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        //setup Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
	
	//DONT NEED THIS FUNCTION ANYMORE **** VVVVV
    func generateScene() {
        
        view.backgroundColor = UIColor.flatWhiteColor()
        
        view.addSubview(topFrame)
        topFrame.backgroundColor = UIColor.flatRedColor()
        topFrame.snp_makeConstraints { (make) in
            make.top.equalTo(view.snp_top)
            make.width.equalTo(view.snp_width)
            make.height.equalTo(view.snp_width).dividedBy(5.8)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "Place"
        titleLabel.backgroundColor = UIColor.flatRedColor()
        titleLabel.textColor = UIColor.flatWhiteColor()
        titleLabel.font = UIFont(name: "Noteworthy", size: 28)
        view.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(topFrame.snp_bottom).offset(-5)
            make.centerX.equalTo(topFrame.snp_centerX)
        }
        
        //TEMPORARY
        let tempNewPostButton = DynamicButton()
        tempNewPostButton.setStyle(DynamicButtonStyle.Plus, animated: true)
        tempNewPostButton.strokeColor = UIColor.flatWhiteColor()
        tempNewPostButton.highlightStokeColor = UIColor.flatWatermelonColor()
        tempNewPostButton.addTarget(self, action: #selector(newPostPressed), forControlEvents: .TouchUpInside)
        view.addSubview(tempNewPostButton)
        tempNewPostButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(topFrame.snp_bottom).offset(-5)
            make.right.equalTo(topFrame.snp_right).offset(-20)
        }
    }
    
    func newPostPressed(){
        
        print("new post from VC")
        let newPostVC = NewPostViewController()
        presentViewController(newPostVC, animated: true, completion: nil)
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
    }
    
    
    
}