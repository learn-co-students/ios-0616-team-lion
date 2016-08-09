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
    var picture: NSURL?
    
    
	private let cellIdentifier = "Cell"
	private let headerIdentifier = "header"
	
	var collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupCollectionView()
       
		
	}
	
	func setupCollectionView() {
		
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 1
		layout.minimumInteritemSpacing = 1
		let blockDimension = (view.frame.width - 2)/3
		layout.itemSize = CGSize(width: blockDimension, height: blockDimension)
		layout.headerReferenceSize = CGSizeMake(0, CGRectGetHeight(view.frame)/3)
		
		collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
		collectionView.backgroundColor = UIColor.darkGrayColor()
		collectionView.dataSource = self
		collectionView.delegate = self
		
		collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
		collectionView.registerClass(ProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
		
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
		return 20
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
		cell.backgroundColor = UIColor.peterRiverColor()
		
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		
		switch kind {
		case UICollectionElementKindSectionHeader:
			let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerIdentifier, forIndexPath: indexPath) as! ProfileHeaderView

				headerView.setUpForUser(self.name!, picture: picture!)
				headerView.delegate = self

			return headerView
		default: assert(false, "Unexpected element type")
		}
	}
}

extension ProfileViewController: ProfileHeaderViewDelegate {
	
	func friendsButtonPressed() {
		
	}
}
