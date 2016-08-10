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
    
    var previewView = UIView()
    var capturedImage = UIImageView()
    let captureButton = UIButton()
    let galleryButton = UIButton()
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    let topFrame = UIImageView()
    let bottomFrame = UIImageView()
    
    var imagePicker = UIImagePickerController()
    
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
                captureSession!.sessionPreset = AVCaptureSessionPresetHigh
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
                    self.capturedImage.image = self.processImage(image)
                }
            })
        }
    }
    
    func processImage(image:UIImage) -> UIImage{
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        
        let width:CGFloat = image.size.width
        let height:CGFloat = image.size.height
        
        let aspectRatio = screenWidth/width;
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(screenWidth, screenWidth), false, 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        
        CGContextTranslateCTM(ctx, 0, (screenWidth-(aspectRatio*height))*0.5)
        
        image.drawInRect(CGRect(origin: CGPoint(x: 0, y: 100), size: CGSize(width:screenWidth, height:height*aspectRatio)))
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        capturedImage.image = img
        
        return capturedImage.image!
    }
    
    func didPressTakeAnother(sender: AnyObject) {
        captureSession!.startRunning()
    }
    
    func photoGallery(sender: UIButton) {
        
        print("Gallery Button Tapped")
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
    }
    
    func layOutPhoto() {
        
        view.addSubview(previewView)
        previewView.snp_makeConstraints { (make) in
            make.centerX.equalTo(view.snp_centerX)
            make.centerY.equalTo(view.snp_centerY)
            make.width.equalTo(view.snp_width)
            make.height.equalTo(view.snp_height)
        }
        
        view.addSubview(topFrame)
        topFrame.backgroundColor = UIColor.whiteColor()
        topFrame.snp_makeConstraints { (make) in
            make.top.equalTo(view.snp_top)
            make.width.equalTo(view.snp_width)
            make.height.equalTo(view.snp_width).dividedBy(8)
        }
        
        view.addSubview(bottomFrame)
        bottomFrame.backgroundColor = UIColor.whiteColor()
        bottomFrame.snp_makeConstraints { (make) in
            make.bottom.equalTo(view.snp_bottom)
            make.width.equalTo(view.snp_width)
            make.height.equalTo(view.snp_width).dividedBy(1.5)
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
        
        bottomFrame.addSubview(capturedImage)
        capturedImage.snp_makeConstraints { (make) in
            make.centerX.equalTo(bottomFrame.snp_centerX).dividedBy(3.5)
            make.centerY.equalTo(bottomFrame.snp_centerY).dividedBy(1.2)
            make.width.equalTo(view.snp_width).dividedBy(5)
            make.height.equalTo(view.snp_width).dividedBy(5)
        }
        
        
        view.addSubview(galleryButton)
        galleryButton.setImage(UIImage(named: "gallery" ), forState: .Normal)
        galleryButton.addTarget(self, action: #selector(PhotoViewController.photoGallery(_:)), forControlEvents: .TouchUpInside)
        galleryButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(bottomFrame.snp_centerX).multipliedBy(1.7)
            make.centerY.equalTo(bottomFrame.snp_centerY)
            make.width.equalTo(view.snp_width).dividedBy(3.7)
            make.height.equalTo(view.snp_width).dividedBy(3.7)
        }
        
    }
    
}
