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
        profileImage.image = UIImage(named: "Profile")
        profileImage.image?.circle
        profileImage.snp_makeConstraints { (make) in
            make.centerX.equalTo(postImage.snp_centerX).offset(-110)
            make.centerY.equalTo(postImage.snp_centerY).offset(-110)
            make.width.equalTo(postImage.snp_width).dividedBy(5)
            make.height.equalTo(postImage.snp_height).dividedBy(5)
        }
        
        //name label constraints
        contentView.addSubview(nameLabel)
        nameLabel.text = "Name Label"
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(profileImage.snp_centerY).offset(160)
            make.centerY.equalTo(profileImage.snp_centerY)
            make.width.equalTo(profileImage.snp_width).multipliedBy(4)
            make.height.equalTo(profileImage.snp_height)
        }
        
        //price label constraints
        contentView.addSubview(priceLabel)
        priceLabel.text = "$$$"
        priceLabel.textColor = UIColor.whiteColor()
        priceLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp_centerX).offset(120)
            make.centerY.equalTo(contentView.snp_centerY).offset(120)
            make.width.equalTo(contentView.snp_width).dividedBy(5)
            make.height.equalTo(contentView.snp_height).dividedBy(5)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
