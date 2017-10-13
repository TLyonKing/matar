//
//  ConfirmPhotoViewController.swift
//  CityView
//
//  Created by admin on 7/9/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import JLStickerTextView
import AVKit
import AVFoundation
import Photos
class ConfirmPhotoViewController: UIViewController {
    
    var videoURL: URL?
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    
    var backgroundImage: UIImage?
    var drawingImageView: UIImageView?
    
    var lastPoint = CGPoint.zero
    var swiped = false
    var isDrawing = false
    
    var red:CGFloat = 0.0
    var green:CGFloat = 0.0
    var blue:CGFloat = 0.0
    var brushSize:CGFloat = 5.0
    var opacityValue:CGFloat = 1.0
    
    var drawViewEnable = false
    var textStickerEnable = false
    
    var mediaType:String = ""
    
    @IBOutlet weak var stickerImageView: JLStickerImageView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var textColorPickerView: UIView!
    @IBOutlet weak var shadowBtn: UIButton!
    @IBOutlet weak var colorTextView: UIView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var addTextBtn: UIButton!
    @IBOutlet weak var fowardBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var drawBtn: UIButton!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var resetDrawingBtn: UIButton!
    
    override var prefersStatusBarHidden: Bool{
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        drawingImageView = UIImageView(frame: (self.view.frame))
        drawingImageView?.contentMode = UIViewContentMode.scaleAspectFit
        drawingImageView?.isHidden = true
        view.insertSubview(drawingImageView!, belowSubview: stickerImageView)
        if videoURL != nil{
            player = AVPlayer(url: videoURL!)
            playerController = AVPlayerViewController()
            
            guard player != nil && playerController != nil else {
                return
            }
            playerController!.showsPlaybackControls = false
            
            playerController!.player = player!
            self.addChildViewController(playerController!)
//            view.addSubview(playerController!.view)
//            view.sendSubview(toBack: playerController!.view)
            self.view.insertSubview(playerController!.view, belowSubview: photoImageView)
            playerController!.view.frame = view.frame
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
        }else{
            photoImageView.image = backgroundImage
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        drawViewEnable = false
        colorTextView.isHidden = true
        hideToolBtn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.player != nil {
            DispatchQueue.main.async() {
                self.player!.pause()
//                self.playerController!.view.removeFromSuperview()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if drawViewEnable == false{
            return
        }
        else{
           
            swiped = false
            if let touch = touches.first {
                lastPoint = touch.location(in: self.drawingImageView)
            }
           
        }
         
    }
    
    func drawLines(fromPoint:CGPoint,toPoint:CGPoint) {
        UIGraphicsBeginImageContext((self.view.frame.size))
        drawingImageView?.image?.draw(in: CGRect(x: 0, y: 0, width: (self.view.frame.width), height: (self.view.frame.height)))
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushSize)
        context?.setStrokeColor(UIColor(red: red, green: green, blue: blue, alpha: opacityValue).cgColor)
        
        context?.strokePath()
        
        drawingImageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if drawViewEnable == false{
            return
        }else{
            swiped = true
            
            if let touch = touches.first {
                let currentPoint = touch.location(in: self.drawingImageView)
                drawLines(fromPoint: lastPoint, toPoint: currentPoint)
                
                lastPoint = currentPoint
            }
        }
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if drawViewEnable == false{
            return
        }else{
        
            if !swiped {
                drawLines(fromPoint: lastPoint, toPoint: lastPoint)
            }
        }
    }
    
       
    @IBAction func addText(_ sender: Any) {
        stickerImageView.addLabel()
        
        //Modify the Label
        stickerImageView.textColor = UIColor.white
        stickerImageView.textAlpha = 1
        stickerImageView.currentlyEditingLabel.closeView!.image = UIImage(named: "cancel")
        stickerImageView.currentlyEditingLabel.rotateView?.image = UIImage(named: "rotate")
        stickerImageView.currentlyEditingLabel.border?.strokeColor = UIColor.white.cgColor
        stickerImageView.currentlyEditingLabel.delegate = self
        showTextTool()
        
    }
    
    @IBAction func foward(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ImageVC") as! ImageViewController
        if self.mediaType == "photo"{
            vc.image = savePhoto()
        }else if self.mediaType == "video"{
            vc.videoURL = videoURL
//            do {
//                let asset = AVURLAsset(url: exportVideo() , options: nil)
//                let imgGenerator = AVAssetImageGenerator(asset: asset)
//                imgGenerator.appliesPreferredTrackTransform = true
//                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
//                let thumbnail = UIImage(cgImage: cgImage)
//                vc.image = thumbnail
//                // thumbnail here
//                
//            } catch let error {
//                print("*** Error generating thumbnail: \(error.localizedDescription)")
//            }
            vc.image = videoPreviewUIImage(moviePath: exportVideo())
//            let imageView = UIImageView(image: uiImage)
            print("video url 1: " + String(describing: self.videoURL))
            print("video url 2: " + String(describing: exportVideo()))
        }
        vc.mediaType = self.mediaType
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func draw(_ sender: Any) {
        drawingImageView?.isHidden = false
        showToolBtn()
        if (stickerImageView.currentlyEditingLabel != nil){
            stickerImageView.currentlyEditingLabel.hideEditingHandlers()
        }
        stickerImageView.isUserInteractionEnabled = false
        drawViewEnable = true
    }
    
    @IBAction func resetDraw(_ sender: Any) {
        self.drawingImageView?.image = nil
    }
    
    @IBAction func colorPicker(_ sender: Any) {
        if (sender as AnyObject).tag == 0 {
            (red,green,blue) = (0,1,0)
            //green
            
        } else if (sender as AnyObject).tag == 1 {
            (red,green,blue) = (1,1,0)
            //yellow
        } else if (sender as AnyObject).tag == 2 {
            (red,green,blue) = (0,0,1)
            //blue
        }
        
    }
    
    @IBAction func donePressed(_ sender: Any) {
        hideToolBtn()
        stickerImageView.isUserInteractionEnabled = true
        drawViewEnable = false
    }
    
    func savePhoto() -> UIImage {
//        let size = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        let size = CGSize(width: (self.backgroundImage?.size.width)!, height: (self.backgroundImage?.size.height)!)
        UIGraphicsBeginImageContext(size)
        
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        if (stickerImageView.currentlyEditingLabel != nil){
            stickerImageView.currentlyEditingLabel.hideEditingHandlers()
        }
//        let image = stickerImageView.renderTextOnView(stickerImageView)
        photoImageView.image?.draw(in: areaSize)
        drawingImageView?.image?.draw(in: areaSize)
        stickerImageView.renderTextOnView(stickerImageView)?.draw(in: areaSize)
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil)
        return newImage
    }
    
    @IBAction func toggleShadow(_ sender: Any) {
        stickerImageView.textShadowOffset = CGSize(width: CGFloat(1.0), height: 5)
//        stickerImageView.textShadowColor = UIColor(red: 250.0, green: 20.0, blue: 147.0, alpha: 1.0)
        stickerImageView.textShadowColor = UIColor.magenta
        print("shadow")
    }
    
    @IBAction func colorPickertext(_ sender: Any) {
        if (sender as AnyObject).tag == 0 {
            (red,green,blue) = (1,1,0)
            //yellow
            
        } else if (sender as AnyObject).tag == 1 {
            (red,green,blue) = (0,1,0)
            //green
        } else if (sender as AnyObject).tag == 2 {
            (red,green,blue) = (0,0,1)
            //blue
        }
        stickerImageView.textColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)

    }
    
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: kCMTimeZero)
            self.player!.play()
        }
    }
    
//    @IBAction func saveVideo(_ sender: Any) {
//        exportVideo()
//    }
}


extension ConfirmPhotoViewController: JLStickerLabelViewDelegate{
    func labelViewDidSelected(_ label: JLStickerLabelView) {
        showTextTool()
    }
    func labelViewDidShowEditingHandles(_ label: JLStickerLabelView) {
        
    }
    func labelViewDidHideEditingHandles(_ label: JLStickerLabelView) {
        hideTextTool()
    }

}
