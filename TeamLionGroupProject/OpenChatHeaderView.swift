//
//  OpenChatHeaderView.swift
//  TeamLionGroupProject
//
//  Created by David Park on 8/19/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import Foundation
import UIKit

protocol OpenChatHeaderViewDelegate: class {
	
}


class OpenChatHeaderView: UICollectionReusableView {
	
	weak var delegate: OpenChatHeaderViewDelegate?
	
	var headerLabel = UILabel()
	let backButton = UIButton()
	
	var header = "OpenMarket"
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		setupScene()
	}
	
	func setupScene() {
		
		self.addSubview(headerLabel)
		headerLabel.snp_makeConstraints { (make) in
			make.center.equalTo(self.snp_center)
		}
		
		self.addSubview(backButton)
		backButton.snp_makeConstraints { (make) in
			make.left.equalTo(self.snp_left).offset(10)
			make.top.equalTo(self.snp_top).offset(10)
			make.bottom.equalTo(self.snp_bottom).offset(10)
			make.width.equalTo(self.snp_width).dividedBy(5)
		}
		backButton.backgroundColor = UIColor.belizeHoleColor()
		backButton.addTarget(self, action: #selector(backButtonTapped), forControlEvents: .TouchUpInside)
		
		
	}
	
	func backButtonTapped() {
		
	}
	
	
	
}
