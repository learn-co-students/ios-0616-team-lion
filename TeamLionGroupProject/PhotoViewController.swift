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
        
        let devices = AVCaptureDevice.devices()
    
    }
    
    func setUpCameraLayout() {
        
        cameraImageView.snp_makeConstraints { (make) in
            make.centerX.equalTo(view.snp_centerX)
            make.centerY.equalTo(view.snp_centerY)
            make.width.equalTo(view.snp_width)
            make.height.equalTo(view.snp_height).dividedBy(2)
        }
        
        photoLibraryButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(view.snp_centerX).multipliedBy(1.8)
            make.centerY.equalTo(view.snp_centerY).multipliedBy(1.8)
            make.width.equalTo(view.snp_width).dividedBy(4)
            make.height.equalTo(view.snp_height).dividedBy(5)
        }
    }
    
    


}
