//
//  CollectionViewCell.swift
//  TeamLionGroupProject
//
//  Created by Eldon Chan on 8/4/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import UIKit
import SnapKit

class PostViewCell: UICollectionViewCell {
    
    var postImage = UIImageView()
    var profileImage = UIImageView()
    var nameLabel = UILabel()
    var priceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.redColor()
        
        //post Image contraints
        contentView.addSubview(postImage)
        postImage.image = UIImage(named: "Post")
        postImage.snp_makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp_centerX)
            make.centerY.equalTo(contentView.snp_centerY)
            make.width.equalTo(contentView.snp_width)
            make.height.equalTo(contentView.snp_height)
        }
        
        //profile picture constraints
        
        contentView.addSubview(profileImage)
        profileImage.image = UIImage(named: "Profile")?.circle
        profileImage.snp_makeConstraints { (make) in
            make.centerX.equalTo(postImage.snp_centerX).dividedBy(4.5)
            make.centerY.equalTo(postImage.snp_centerY).dividedBy(4.5)
            make.width.equalTo(postImage.snp_width).dividedBy(5)
            make.height.equalTo(postImage.snp_height).dividedBy(5)
        }
        
        //name label constraints
        contentView.addSubview(nameLabel)
        nameLabel.text = "Name Label"
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.shadowColor = UIColor.blackColor()
        nameLabel.snp_makeConstraints { (make) in
            make.leading.equalTo(profileImage.snp_trailing).multipliedBy(1.2)
            make.centerY.equalTo(profileImage.snp_centerY)
            make.right.equalTo(postImage.snp_right).offset(-2)
            make.height.equalTo(profileImage.snp_height)
        }
        
        //price label constraints
        contentView.addSubview(priceLabel)
        priceLabel.textColor = UIColor.whiteColor()
        priceLabel.shadowColor = UIColor.blackColor()
        priceLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(postImage.snp_bottom).offset(-2)
            make.right.equalTo(postImage.snp_right).offset(-2)
            make.width.equalTo(postImage.snp_width).dividedBy(4)
            make.height.equalTo(postImage.snp_height).dividedBy(5)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
