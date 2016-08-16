//
//  PhotoViewController.swift
//  TeamLionGroupProject
//
//  Created by Eldon Chan on 8/9/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import UIKit
import AVFoundation
import DynamicButton
import SnapKit

protocol sendPhoto: class
{
    func sendBackPhoto(photo: UIImage)
}

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var previewView = UIView()
    var capturedImage = UIImageView()
    let captureButton = DynamicButton()
    let saveButton = DynamicButton()
    let retakeButton = DynamicButton()
    let cancelButton = DynamicButton()
    let circle = UIImageView()
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    let topFrame = UIImageView()
    let bottomFrame = UIImageView()
    
    var imagePicker = UIImagePickerController()
    
    weak var delegate: sendPhoto?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.whiteColor()
        saveButton.hidden = true
        retakeButton.hidden = true
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
    
    func didPressTakePhoto() {
        
        print ("Taking Picture")
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
        
        
        UIView.transitionWithView(view, duration: 0.3, options: .TransitionCrossDissolve, animations: {() -> Void in
            self.captureButton.hidden = true
            self.saveButton.hidden = false
            self.retakeButton.hidden = false
            self.capturedImage.hidden = false
            }, completion: { _ in })
        
        
        
    }
    
    func processImage(image:UIImage) -> UIImage{
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        
        let width:CGFloat = image.size.width
        let height:CGFloat = image.size.height
        
        let aspectRatio = screenWidth/width;
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(screenWidth, screenWidth), false, 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        
        CGContextTranslateCTM(ctx, 0, (screenWidth-(aspectRatio*height))*0.5)
        
        image.drawInRect(CGRect(origin: CGPoint(x: 0, y: 92.5), size: CGSize(width:screenWidth, height:height*aspectRatio)))
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        capturedImage.image = img
        
        return capturedImage.image!
    }
    
    func didPressTakeAnother(sender: AnyObject) {
        captureSession!.startRunning()
    }
    
    func photoGallery() {
        
        print("Gallery Button Tapped")
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
    }
    
    func saveButtonTapped() {
     
        //save self.capturedImage as PlacePost.itemImages
        self.delegate?.sendBackPhoto(capturedImage.image!)
        print("Photo VC PIC:\(capturedImage.image)")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func retakeButtonTapped() {
        
        UIView.transitionWithView(view, duration: 0.3, options: .TransitionCrossDissolve, animations: {() -> Void in
            self.capturedImage.hidden = true
            self.captureButton.hidden = false
            self.saveButton.hidden = true
            self.retakeButton.hidden = true
            }, completion: { _ in })
        
        capturedImage.image = nil
        
    }
    
    func cancelButtonTapped() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
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
            make.height.equalTo(view.snp_width).dividedBy(7)
        }
        
        view.addSubview(bottomFrame)
        bottomFrame.backgroundColor = UIColor.whiteColor()
        bottomFrame.snp_makeConstraints { (make) in
            make.bottom.equalTo(view.snp_bottom)
            make.width.equalTo(view.snp_width)
            make.height.equalTo(view.snp_width).dividedBy(1.575)
        }

        
        bottomFrame.addSubview(capturedImage)
        capturedImage.snp_makeConstraints { (make) in
            make.width.equalTo(previewView.snp_width)
            make.top.equalTo(topFrame.snp_bottom)
            make.bottom.equalTo(bottomFrame.snp_top)
        }
        
        view.addSubview(circle)
        circle.image = UIImage(named: "circle")
        circle.snp_makeConstraints { (make) in
            make.centerX.equalTo(bottomFrame.snp_centerX)
            make.centerY.equalTo(bottomFrame.snp_centerY).offset(-10)
            make.width.equalTo(bottomFrame.snp_width).dividedBy(3)
            make.height.equalTo(bottomFrame.snp_width).dividedBy(3)
        }
        
        view.addSubview(captureButton)
        captureButton.setStyle(DynamicButtonStyle.None, animated: true)
        captureButton.addTarget(self, action: #selector(didPressTakePhoto), forControlEvents: .TouchUpInside)
        captureButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(bottomFrame.snp_centerX)
            make.centerY.equalTo(bottomFrame.snp_centerY).offset(-10)
            make.width.equalTo(bottomFrame.snp_width).dividedBy(5)
            make.height.equalTo(bottomFrame.snp_width).dividedBy(5)
        }
        
        view.addSubview(saveButton)
        saveButton.setStyle(DynamicButtonStyle.CheckMark, animated: true)
        saveButton.strokeColor = UIColor.peterRiverColor()
        saveButton.highlightStokeColor = UIColor.greenSeaColor()
        saveButton.lineWidth = 4
        saveButton.addTarget(self, action: #selector(saveButtonTapped), forControlEvents: .TouchUpInside)
        saveButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(bottomFrame.snp_centerX)
            make.centerY.equalTo(bottomFrame.snp_centerY).offset(-10)
            make.width.equalTo(bottomFrame.snp_width).dividedBy(5)
            make.height.equalTo(bottomFrame.snp_width).dividedBy(5)
        }
        
        view.addSubview(retakeButton)
        retakeButton.setStyle(DynamicButtonStyle.Reload, animated: true)
        retakeButton.strokeColor = UIColor.peterRiverColor()
        retakeButton.highlightStokeColor = UIColor.redColor()
        retakeButton.lineWidth = 2
        retakeButton.addTarget(self, action: #selector(retakeButtonTapped), forControlEvents: .TouchUpInside)
        retakeButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(bottomFrame.snp_centerX).offset(-150)
            make.centerY.equalTo(bottomFrame.snp_centerY).offset(-80)
            make.width.equalTo(bottomFrame.snp_width).dividedBy(10)
            make.height.equalTo(bottomFrame.snp_width).dividedBy(10)
        }
        
        view.addSubview(cancelButton)
        cancelButton.setStyle(DynamicButtonStyle.Rewind, animated: true)
        cancelButton.strokeColor = UIColor.peterRiverColor()
        cancelButton.highlightStokeColor = UIColor.redColor()
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), forControlEvents: .TouchUpInside)
        cancelButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(topFrame.snp_centerX).offset(-160)
            make.centerY.equalTo(topFrame.snp_centerY).offset(10)
            make.width.equalTo(topFrame.snp_width).dividedBy(12)
            make.height.equalTo(topFrame.snp_width).dividedBy(12)
        }
        
    }
    
}

