//
//  MarketplaceCollectionViewController.swift
//  TeamLionGroupProject
//
//  Created by Eldon Chan on 8/4/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import UIKit

class MarketplaceCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UINavigationBarDelegate {
    var shared = PlaceUserDataStore.sharedDataStore
    var collectionView: UICollectionView!
    var postArray = [post1, post2, post3, post4, post5, post6, post7, post8, post9, post10, post11, post12]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setUpCollectionCells()
        setUpNavigationBar()

    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.postArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("basicCell", forIndexPath: indexPath) as! PostViewCell
        
        cell.postImage.image = self.postArray[indexPath.item].itemImages[0]
        cell.priceLabel.text = "$\(self.postArray[indexPath.item].price)"
        cell.nameLabel.text = self.postArray[indexPath.item].itemTitle

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        let postDetailVC = PostDetailViewController()
        
        postDetailVC.itemTitle = postArray[indexPath.item].itemTitle
        postDetailVC.itemPrice = postArray[indexPath.item].price
        postDetailVC.descriptionField.text = postArray[indexPath.item].itemDescription
        postDetailVC.itemImage = postArray[indexPath.item].itemImages[0]
        
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
        collectionView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView)
        
        
        collectionView?.registerClass(PostViewCell.self, forCellWithReuseIdentifier: "basicCell")
        
    }
    
    func setUpNavigationBar() {
        
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, view.frame.size.width, 64))
        
        view.addSubview(navigationBar)
        navigationBar.backgroundColor = UIColor.whiteColor()
        navigationBar.delegate = self
        
        let navItem = UINavigationItem()
        let newPost = UIBarButtonItem(image: UIImage(named: "NewPost"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MarketplaceCollectionViewController.newPostButtonTapped(_:)))
        navItem.title = "Place"
        navItem.rightBarButtonItem = newPost
        
        navigationBar.items = [navItem]
        
    }
    
    func newPostButtonTapped(sender: UIBarButtonItem) {

        self.presentViewController(NewPostViewController(), animated: true, completion: nil)

    }
    
    
}