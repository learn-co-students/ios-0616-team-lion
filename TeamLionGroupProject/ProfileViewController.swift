//
//  ProfileViewController.swift
//  TeamLionGroupProject
//
//  Created by Eldon Chan on 8/4/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
	
	private let cellIdentifier = "Cell"
	private let headerIdentifier = "header"
	
//	required init?(coder aDecoder: NSCoder) {
//		fatalError("init(coder:) has not been implemented")
//	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.emeraldColor()
		
	}
	
	func setupCollectionView() {
		
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 1
		layout.minimumInteritemSpacing = 1
	}

}



extension ProfileViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 3
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
		cell.backgroundColor = UIColor.belizeHoleColor()
		
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		
		switch kind {
		case UICollectionElementKindSectionHeader:
			let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerIdentifier, forIndexPath: indexPath) as! ProfileHeaderView
			
			//headerView.delegate = self
			
			headerView.username = "username"
			
			return headerView
		default: assert(false, "Unexpected element type")
		}
	}
	
	
}
