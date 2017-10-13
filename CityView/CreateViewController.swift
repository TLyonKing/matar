//
//  CreateViewController.swift
//  CityView
//
//  Created by admin on 6/30/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import CameraManager
class CreateViewController: UIViewController {

    var cameraManager = CameraManager()
    var flipCameraButton: UIButton!
    var flashButton: UIButton!
    var closeButton: UIButton!
    var libraryButton: UIButton!
    var segmentedControl = UISegmentedControl();
    var captureButton: UIButton!
    var timer:UILabel!
    var reddotRecord:UIImageView!
    var timerView:UIView!
    var count = 0
    var timerRun: Timer! = nil
    var videoIsRecording:Bool = true
    var mediaType: String = ""
//    var captureButton: SwiftyRecordButton!
    
    @IBOutlet weak var cameraView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        cameraDelegate = self
//        maximumVideoDuration = 10.0
//        shouldUseDeviceOrientation = false
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        cameraManager.cameraOutputQuality = .high
        addCameraToView()
        addButtons()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        cameraManager.resumeCaptureSession()
        timerView.isHidden = true
        count = 10
        videoIsRecording = true
        mediaType = ""
//        self.segmentedControl.selectedSegmentIndex = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraManager.stopCaptureSession()
        if timerRun != nil{
        timerRun.invalidate()
        }
        
    }
    
    fileprivate func addCameraToView()
    {
        _ = cameraManager.addPreviewLayerToView(cameraView, newCameraOutputMode: CameraOutputMode.stillImage)
        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
            
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alertAction) -> Void in  }))
            
            self?.present(alertController, animated: true, completion: nil)
        }
       
    }
    
//    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
//        //		let newVC = PhotoViewController(image: photo)
//        //		self.present(newVC, animated: true, completion: nil)
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let imageVC = sb.instantiateViewController(withIdentifier: "ImageVC") as! ImageViewController
//        imageVC.image = photo
//        self.present(imageVC, animated: true, completion: nil)
//        
//        
//    }
//    
//    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
//        print("Did Begin Recording")
//        captureButton.growButton()
//        UIView.animate(withDuration: 0.25, animations: {
//            self.flashButton.alpha = 0.0
//            self.flipCameraButton.alpha = 0.0
//        })
//    }
//    
//    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
//        print("Did finish Recording")
//        captureButton.shrinkButton()
//        UIView.animate(withDuration: 0.25, animations: {
//            self.flashButton.alpha = 1.0
//            self.flipCameraButton.alpha = 1.0
//        })
//    }
//    
//    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
////        let newVC = VideoViewController(videoURL: url)
////        self.present(newVC, animated: true, completion: nil)
//    }
//    
//    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
//        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
//        focusView.center = point
//        focusView.alpha = 0.0
//        view.addSubview(focusView)
//        
//        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
//            focusView.alpha = 1.0
//            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
//        }, completion: { (success) in
//            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
//                focusView.alpha = 0.0
//                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
//            }, completion: { (success) in
//                focusView.removeFromSuperview()
//            })
//        })
//    }
//    
//    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
//        print(zoom)
//    }
//    
//    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
//        print(camera)
//    }
    
    @objc private func cameraSwitchAction(_ sender: Any) {
//        switchCamera()
        cameraManager.cameraDevice = cameraManager.cameraDevice == CameraDevice.front ? CameraDevice.back : CameraDevice.front
//        switch (cameraManager.cameraDevice) {
//        case .front:
//            sender.setTitle("Front", for: UIControlState())
//        case .back:
//            sender.setTitle("Back", for: UIControlState())
//        }
    }
    
    @objc private func snapCamera(_ sender: UIButton) {
        //        switchCamera()
        if self.segmentedControl.selectedSegmentIndex == 0 {
            mediaType = "photo"
            // capture
            cameraManager.cameraOutputMode = .stillImage
            cameraManager.capturePictureWithCompletion({ (image, error) -> Void in
                if let errorOccured = error {
                    self.cameraManager.showErrorBlock("Error occurred", errorOccured.localizedDescription)
                }
                else {
                    let vc: ConfirmPhotoViewController? = self.storyboard?.instantiateViewController(withIdentifier: "PhotoViewController") as? ConfirmPhotoViewController
                    if let validVC: ConfirmPhotoViewController = vc {
                        if let capturedImage = image {
                            validVC.backgroundImage = capturedImage
                            validVC.mediaType = self.mediaType
                           self.present(validVC, animated: true, completion: nil)
                        }
                    }
                }
            })

        }
        else{
            cameraManager.cameraOutputMode = .videoWithMic
//            sender.isSelected = !sender.isSelected
            videoIsRecording = !videoIsRecording
            if (videoIsRecording == false) {
                mediaType = "video"
                cameraManager.startRecordingVideo()
                timerView.isHidden = false
                timerRun = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(CreateViewController.update), userInfo: nil, repeats: true)
                timerRun.fire()
                print("Start  recording")
            } else {
                cameraStopRecording()
            }
        }

    }
    
    @objc private func toggleFlashAction(_ sender: Any) {
//        flashEnabled = !flashEnabled
//        
//        if flashEnabled == true {
//            flashButton.setImage(#imageLiteral(resourceName: "flash"), for: UIControlState())
//        } else {
//            flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControlState())
//        }
        switch (cameraManager.changeFlashMode()) {
        case .off:
            flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControlState())
        case .on:
            flashButton.setImage(#imageLiteral(resourceName: "flash"), for: UIControlState())
        
        case .auto:
            break
        }
    }
    
//    @objc private func OpenLib(_ sender: Any) {
//        handleSelectProfileImageView()
//    }
    
    @objc private func closeView(_ sender: Any) {
        dismiss(animated: true, completion: nil);
        print("CLOSE CLOSE")
    }
    
    @objc func update() {
        
        if(count > 0){
            let minutes = String(count / 60)
            let seconds = String(count % 60)
            if Int(seconds)! < 10{
                timer.text = "0"+minutes + ":" + "0"+seconds
            }else if Int(seconds)! == 0{
                timer.text = "0"+minutes + ":" + seconds
            }
            else{
                timer.text = "0"+minutes + ":" + seconds
            }
            
            count -= 1
        }else{
            print("Time's up")
            cameraStopRecording()
        }
        
    }
    
    func cameraStopRecording(){
        
        print("Stop  recording")
        cameraManager.stopVideoRecording({ (videoURL, error) -> Void in
            if let errorOccured = error {
                self.cameraManager.showErrorBlock("Error occurred", errorOccured.localizedDescription)
            }
            print("Stop  recording 1")
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let photoVC = sb.instantiateViewController(withIdentifier: "PhotoViewController") as! ConfirmPhotoViewController
            photoVC.videoURL = videoURL
            photoVC.mediaType = self.mediaType
            print("video url", videoURL)
            self.present(photoVC, animated: true, completion: nil)
//            let vc: ConfirmPhotoViewController? = self.storyboard?.instantiateViewController(withIdentifier: "PhotoViewController") as? ConfirmPhotoViewController
//            if let validVC: ConfirmPhotoViewController = vc {
//                if let videoURL = videoURL {
//                    print("Stop  recording 2")
//                    validVC.videoURL = videoURL
//                    validVC.mediaType = self.mediaType
//                    self.present(validVC, animated: true, completion: nil)
//                }
//            }
        })
    

    }

    private func addButtons() {
        captureButton = UIButton(frame: CGRect(x: view.frame.midX - 37.5, y: view.frame.height - 100.0, width: 75.0, height: 75.0))
        captureButton.clipsToBounds = true
        captureButton.layer.cornerRadius = self.captureButton.frame.width / 2.0
        captureButton.layer.borderColor = UIColor.white.cgColor
        captureButton.layer.borderWidth = 3.0
        captureButton.backgroundColor = UIColor.white.withAlphaComponent(0.6);
        captureButton.layer.rasterizationScale = UIScreen.main.scale
        captureButton.layer.shouldRasterize = true
        captureButton.addTarget(self, action: #selector(snapCamera(_:)), for: .touchUpInside)
        self.view.addSubview(captureButton)
        
        
        //flipCameraButton = UIButton(frame: CGRect(x: (((view.frame.width / 2 - 37.5) / 2) - 15.0), y: view.frame.height - 74.0, width: 30.0, height: 23.0))
         flipCameraButton = UIButton(frame: CGRect(x: self.view.frame.size.width - 35, y: 10, width: 30.0, height: 23.0))
        flipCameraButton.setImage(#imageLiteral(resourceName: "flipCamera"), for: UIControlState())
        flipCameraButton.addTarget(self, action: #selector(cameraSwitchAction(_:)), for: .touchUpInside)
        self.view.addSubview(flipCameraButton)
        
        let test = CGFloat((view.frame.width - (view.frame.width / 2 + 37.5)) + ((view.frame.width / 2) - 37.5) - 9.0)
        //flashButton = UIButton(frame: CGRect(x: test, y: view.frame.height - 77.5, width: 18.0, height: 30.0))
        flashButton = UIButton(frame: CGRect(x: self.view.frame.size.width / 2 - 9, y: 10, width: 18.0, height: 30.0))
        flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControlState())
        flashButton.addTarget(self, action: #selector(toggleFlashAction(_:)), for: .touchUpInside)
        self.view.addSubview(flashButton)
        
        timerView = UIView(frame: CGRect(x: self.view.frame.size.width / 2 - 35, y: 60, width: 70, height: 30))
        timerView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        timerView.layer.cornerRadius = 5.0
        self.view.addSubview(timerView)
        
        timer = UILabel(frame: CGRect(x: 15, y: 8, width: 50, height: 15))
        timer.text = "00:10"
        timer.textColor = UIColor.white
        timer.textAlignment = .center
//        timer.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
//        timer.layer.cornerRadius = 5.0
        self.timerView.addSubview(timer)
        
        
        reddotRecord  = UIImageView(frame: CGRect(x: 5, y: 10, width: 10, height: 10))
        reddotRecord.image = UIImage(named: "red-dot-md")
        self.timerView.addSubview(reddotRecord)
            
        
        closeButton = UIButton(frame: CGRect(x: 0, y: 10, width: 25.0, height: 25.0))
        //flashButton = UIButton(frame: CGRect(x: 0, y: 0, width: 18.0, height: 30.0))
        closeButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
        //closeButton.setTitle("CLOSE", for: UIControlState())
        closeButton.addTarget(self, action: #selector(closeView(_:)), for: .touchUpInside)
        self.view.addSubview(closeButton)
        
        segmentedControl = UISegmentedControl(items: ["Picture", "Video"])
        segmentedControl.frame = CGRect(x: 12.0, y: UIScreen.main.bounds.size.height - 70, width: 120.0, height: 32.0)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = UIColor.white
        self.view.addSubview(segmentedControl)
        
        libraryButton = UIButton(frame: CGRect(x: test, y: view.frame.height - 77.5, width: 40.0, height: 40.0))
        libraryButton.setImage(#imageLiteral(resourceName: "libraryButton"), for: UIControlState())
        libraryButton.addTarget(self, action: #selector(handleSelectLibraryImage(_:)), for: .touchUpInside)
        self.view.addSubview(libraryButton)
        self.view.sendSubview(toBack: cameraView)
    }

}
