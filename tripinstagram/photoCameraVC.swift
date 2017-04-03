//
//  SimpleCameraController.swift
//  SimpleCamera
//
//  Created by Simon Ng on 16/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

class photoCameraVC: UIViewController, UINavigationBarDelegate {

    @IBOutlet var cameraButton:UIButton!
    
    let captureSession = AVCaptureSession()
    var backFacingCamera: AVCaptureDevice?
    var frontFacingCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice?
    
    // var stillImageOutput: AVCaptureStillImageOutput?
    var stillImageOutput: AVCaptureStillImageOutput?
    var stillImage: UIImage?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var toggleCameraGestureRecognizer = UISwipeGestureRecognizer()
    var zoomInGestureRecognizer = UISwipeGestureRecognizer()
    var zoomOutGestureRecognizer = UISwipeGestureRecognizer()
    
    // size of screen
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the front/back facing camera for taking photos
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as! [AVCaptureDevice]
        for device in devices {
            if device.position == AVCaptureDevicePosition.back {
                backFacingCamera = device
            } else if device.position == AVCaptureDevicePosition.front {
                frontFacingCamera = device
            }
        }
        currentDevice = backFacingCamera

        // configure the session with the output for capturing still images
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]

        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice)
            captureSession.addInput(captureDeviceInput)
            captureSession.addOutput(stillImageOutput)
        } catch {
            print(error)
        }
        
        // preset the session for taking photo to full solution
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        captureSession.startRunning()
        
        // provide camera preview
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(cameraPreviewLayer!)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewLayer?.frame = view.layer.frame
        
        // toggle camera recognizer
        toggleCameraGestureRecognizer.direction = .up
        toggleCameraGestureRecognizer.addTarget(self, action: #selector(toggleCamera))
        view.addGestureRecognizer(toggleCameraGestureRecognizer)
        
        // zoomin/out gesture recognizer
        zoomInGestureRecognizer.direction = .right
        zoomInGestureRecognizer.addTarget(self, action: #selector(zoomIn))
        view.addGestureRecognizer(zoomInGestureRecognizer)
        zoomOutGestureRecognizer.direction = .left
        zoomOutGestureRecognizer.addTarget(self, action: #selector(zoomOut))
        view.addGestureRecognizer(zoomOutGestureRecognizer)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 18.0 / 255.0, green: 86.0 / 255.0, blue: 136.0 / 255.0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.delegate = self
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = camera_str.uppercased()
        
        // Assign the navigation item to the navigation bar
        self.navigationController?.navigationBar.items = [navigationItem]
        
        // allow constraints
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-(\(width / 2 - 20))-[camerabuuton(40)]-(\(width / 2 - 20))-|",
            options: [],
            metrics: nil, views: ["camerabuuton":cameraButton]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[camerabuuton(40)]-10-|",
            options: [],
            metrics: nil, views: ["camerabuuton":cameraButton]))
        
        // bring the camera button to front
        self.view.bringSubview(toFront: cameraButton)

    }

    
    @IBAction func capture(sender: UIButton) {
        
        let videoConnection = stillImageOutput?.connection(withMediaType: AVMediaTypeVideo)
        stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (imageDataSampleBuffer, error) -> Void in
            
            if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer) {
                self.stillImage = UIImage(data: imageData)
                self.performSegue(withIdentifier: "showPhoto", sender: self)
            }
        })
        // self.performSegue(withIdentifier: "showPhoto", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhoto" {
            let photoViewController = segue.destination as! photoVC
            photoViewController.image = stillImage
        }
    }
    
    // toggle camera function
    func toggleCamera() {
        captureSession.beginConfiguration()
        
        // change the device based on the current camera
        let newDevice = (currentDevice?.position == AVCaptureDevicePosition.back) ? frontFacingCamera : backFacingCamera
        
        // remove all inputs from the session
        for input in captureSession.inputs {
            captureSession.removeInput(input as! AVCaptureInput)
        }
        
        // change to the new input
        let cameraInput: AVCaptureDeviceInput
        do {
            cameraInput = try AVCaptureDeviceInput(device: newDevice)
        } catch {
            print(error)
            return
        }
        
        if captureSession.canAddInput(cameraInput) {
            captureSession.addInput(cameraInput)
        }
        
        currentDevice = newDevice
        captureSession.commitConfiguration()
    }
    
    func zoomIn() {
        if let zoomFactor = currentDevice?.videoZoomFactor {
            if zoomFactor < 5.0 {
                let newZoomFactor = min(zoomFactor + 1.0, 5.0)
                do {
                    try currentDevice?.lockForConfiguration()
                    currentDevice?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                    currentDevice?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
        
    }
    
    func zoomOut() {
        if let zoomFactor = currentDevice?.videoZoomFactor {
            if zoomFactor > 1.0 {
                let newZoomFactor = max(zoomFactor - 1.0, 1.0)
                do {
                    try currentDevice?.lockForConfiguration()
                    currentDevice?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                    currentDevice?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }

    // MARK: - Segues
    
    @IBAction func unwindToCameraView(segue: UIStoryboardSegue) {
    
    }

}
