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
        
        //name label constraints
//        contentView.addSubview(nameLabel)
//        nameLabel.text = ""
//        nameLabel.textColor = UIColor.whiteColor()
//        nameLabel.shadowColor = UIColor.blackColor()
//        nameLabel.snp_makeConstraints { (make) in
//            make.left.equalTo(postImage.snp_left).offset(4)
//            make.right.equalTo(postImage.snp_right).offset(-4)
//            make.centerY.equalTo(postImage.snp_centerY).dividedBy(4.5)
//            make.height.equalTo(postImage.snp_height).dividedBy(5)
//        }
        
        //price label constraints
        contentView.addSubview(priceLabel)
        priceLabel.textColor = UIColor.flatWhiteColor()
        priceLabel.textAlignment = NSTextAlignment.Right
//        priceLabel.shadowColor = UIColor.blackColor()
        priceLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(postImage.snp_bottom)
            make.right.equalTo(postImage.snp_right).offset(-2)
            make.left.equalTo(postImage.snp_left).offset(-2)
            make.height.equalTo(postImage.snp_height).dividedBy(5)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
