//
//  PhotoViewController.swift
//  TeamLionGroupProject
//
//  Created by Eldon Chan on 8/9/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    let cameraImageView = UIImageView()
    let photoLibraryButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.amethystColor()
        let devices = AVCaptureDevice.devices()
        
        setUpCameraLayout()
    
    }
    
    func setUpCameraLayout() {
        
        self.view.addSubview(cameraImageView)
        cameraImageView.snp_makeConstraints { (make) in
            make.centerX.equalTo(view.snp_centerX)
            make.centerY.equalTo(view.snp_centerY)
            make.width.equalTo(view.snp_width)
            make.height.equalTo(view.snp_height).dividedBy(2)
        }
        
        self.view.addSubview(photoLibraryButton)
        photoLibraryButton.setTitle("Library", forState: .Normal)
        photoLibraryButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        photoLibraryButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(view.snp_centerX).dividedBy(4.5)
            make.centerY.equalTo(view.snp_centerY).dividedBy(4.5)
            make.width.equalTo(view.snp_width).dividedBy(5)
            make.height.equalTo(view.snp_height).dividedBy(5)
        }
    }
    
    


}
