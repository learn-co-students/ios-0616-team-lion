//
//  PhotoViewController.swift
//  TeamLionGroupProject
//
//  Created by Eldon Chan on 8/9/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoViewController: UIViewController {
    
    var previewView = UIView()
    var capturedImage = UIImageView()
    let captureButton = UIButton()
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.whiteColor()
        layOutPhoto()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if error == nil && captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if captureSession!.canAddOutput(stillImageOutput) {
                captureSession!.addOutput(stillImageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
                previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait
                previewView.layer.addSublayer(previewLayer!)
                
                captureSession!.startRunning()
            }
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer!.frame = previewView.bounds
    }
    
    func didPressTakePhoto(sender: UIButton) {
        
        if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
                if (sampleBuffer != nil) {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                    
                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    self.capturedImage.image = image
                }
            })
        }
    }
    
    func didPressTakeAnother(sender: AnyObject) {
        captureSession!.startRunning()
    }
    
    func layOutPhoto() {
        
        view.addSubview(previewView)
        previewView.snp_makeConstraints { (make) in
            make.centerX.equalTo(view.snp_centerX)
            make.centerY.equalTo(view.snp_centerY)
            make.width.equalTo(view.snp_width)
            make.height.equalTo(view.snp_height)
        }
        
        view.addSubview(capturedImage)
        capturedImage.snp_makeConstraints { (make) in
            make.centerX.equalTo(view.snp_centerX).dividedBy(2.8)
            make.centerY.equalTo(view.snp_centerY).multipliedBy(1.6)
            make.width.equalTo(view.snp_width).dividedBy(5)
            make.height.equalTo(view.snp_width).dividedBy(5)
        }

        view.addSubview(captureButton)
        captureButton.setImage(UIImage(named: "circleButton" ), forState: .Normal)
        captureButton.addTarget(self, action: #selector(PhotoViewController.didPressTakePhoto(_:)), forControlEvents: .TouchUpInside)
        captureButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(view.snp_centerX)
            make.centerY.equalTo(view.snp_centerY).multipliedBy(1.6)
            make.width.equalTo(view.snp_width).dividedBy(3.7)
            make.height.equalTo(view.snp_width).dividedBy(3.7)
        }
        
    }
    
}
