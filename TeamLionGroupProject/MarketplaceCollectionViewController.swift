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

class MarketplaceCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UINavigationBarDelegate {
    var shared = PlaceUserDataStore.sharedDataStore
    var collectionView: UICollectionView!
    let topFrame = UIImageView()
//    var postArray = [post1, post2, post3, post4, post5, post6, post7, post8, post9, post10, post11, post12]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shared.getUserCredentialsForProfileVC { (result) in
            print("result \(result)")
        }
        setUpCollectionCells()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        tabBarController?.tabBar.hidden = false
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shared.currentUser.friendsPosts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("basicCell", forIndexPath: indexPath) as! PostViewCell
        
        //cell.postImage.image = self.shared.currentUser.friendsPosts[indexPath.item].itemImages[0]
        cell.priceLabel.text = "$\(self.shared.currentUser.friendsPosts[indexPath.item].price)"
        cell.nameLabel.text = self.shared.currentUser.friendsPosts[indexPath.item].itemTitle
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        let postDetailVC = PostDetailViewController()
        
        postDetailVC.itemTitle = self.shared.currentUser.friendsPosts[indexPath.item].itemTitle
        postDetailVC.itemPrice = self.shared.currentUser.friendsPosts[indexPath.item].price
        postDetailVC.descriptionField.text = self.shared.currentUser.friendsPosts[indexPath.item].itemDescription
        postDetailVC.itemImage = self.shared.currentUser.friendsPosts[indexPath.item].itemImages[0]

        
        self.presentViewController(postDetailVC, animated: true, completion:  nil)
    }
    
    func setUpCollectionCells() {
        
        let screenSize = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        //setup Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.sectionInset = UIEdgeInsets(top: 65, left: 0, bottom: 50, right: 0)
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