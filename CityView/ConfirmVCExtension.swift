//
//  ConfirmVCExtension.swift
//  CityView
//
//  Created by admin on 7/11/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Photos
extension ConfirmPhotoViewController{
    
    func hideToolBtn(){
        doneBtn.isHidden = true
        colorView.isHidden = true
        resetDrawingBtn.isHidden = true
        colorTextView.isHidden = true
        shadowBtn.isHidden = true
        textColorPickerView.isHidden = true
        cancelBtn.isHidden = false
        fowardBtn.isHidden = false
        addTextBtn.isHidden = false
        drawBtn.isHidden = false
    }
    
    func showToolBtn(){
        doneBtn.isHidden = false
        colorView.isHidden = false
        resetDrawingBtn.isHidden = false
        cancelBtn.isHidden = true
        fowardBtn.isHidden = true
        addTextBtn.isHidden = true
        drawBtn.isHidden = true
    }
    
    func showTextTool(){
        colorTextView.isHidden = false
        shadowBtn.isHidden = false
        textColorPickerView.isHidden = false
        addTextBtn.isHidden = true
        cancelBtn.isHidden = true
        drawBtn.isHidden = true
    }
    
    func hideTextTool(){
        colorTextView.isHidden = true
        shadowBtn.isHidden = true
        textColorPickerView.isHidden = true
        addTextBtn.isHidden = false
        cancelBtn.isHidden = false
        drawBtn.isHidden = false
    }
    
    func exportVideo() -> URL{
        let composition = AVMutableComposition()
        let vidAsset = AVURLAsset(url: videoURL!, options: nil)
        let degrees = 90.0
        // get video track
        let vtrack =  vidAsset.tracks(withMediaType: AVMediaType.video)
        let videoTrack:AVAssetTrack = vtrack[0]
//        let vid_duration = videoTrack.timeRange.duration
        let vid_timerange = CMTimeRangeMake(kCMTimeZero, vidAsset.duration)
        // get audio track
        let atrack =  vidAsset.tracks(withMediaType: AVMediaType.audio)
        let audioTrack:AVAssetTrack = atrack[0]
//        let audio_duration = audioTrack.timeRange.duration
        let audio_timerange = CMTimeRangeMake(kCMTimeZero, vidAsset.duration)
        
        
//        var layerInstruction: AVMutableVideoCompositionLayerInstruction?
        var t1: CGAffineTransform?
        var t2: CGAffineTransform?
        
        //        compositionvideoTrack.insertTimeRange(vid_timerange, ofTrack: videoTrack, atTime: kCMTimeZero)
        do {
            var error: NSError?
            let compositionvideoTrack:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID())!
            try! compositionvideoTrack.insertTimeRange(vid_timerange, of: videoTrack, at: kCMTimeZero)
            compositionvideoTrack.preferredTransform = videoTrack.preferredTransform
            
            let compositionAudioTrack:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!
            try! compositionAudioTrack.insertTimeRange(audio_timerange, of: audioTrack, at: kCMTimeZero)
            
            compositionvideoTrack.preferredTransform = audioTrack.preferredTransform
        }
        catch  {
            print(error)
            
        }
        
        let size = videoTrack.naturalSize
        let width = Float((size.width))
        let height = Float((size.height))
        let toDiagonal = Float(sqrt(width * width + height * height))
        let toDiagonalAngle = Float(radiansToDegrees(acosf(width/toDiagonal)))
        let toDiagonalAngle2 = Float(90 - radiansToDegrees(acosf(width/toDiagonal)))
        
        var toDiagonalAngleComple: Float
        var toDiagonalAngleComple2: Float
        var finalHeight: Float = 0
        var finalWidth: Float = 0
        
        if degrees >= 0 && degrees <= 90 {
            
            toDiagonalAngleComple = toDiagonalAngle + Float(degrees)
            toDiagonalAngleComple2 = toDiagonalAngle2 + Float(degrees)
            
            let sinfValue = sinf(degreesToRadians(toDiagonalAngleComple))
            let sinfValue2 = sinf(degreesToRadians(toDiagonalAngleComple2))
            
            finalHeight = abs(toDiagonal * sinfValue)
            finalWidth = abs(toDiagonal * sinfValue2)
            
            let side1 = height * sinf(degreesToRadians(Float(degrees)))
            let side2 = 0.0
            
            t1 = CGAffineTransform(translationX: CGFloat(side1), y: CGFloat(side2))
            
        } else if degrees > 90 && degrees <= 180 {
            
            let degrees2 = Float(degrees - 90)
            
            toDiagonalAngleComple = toDiagonalAngle + degrees2
            toDiagonalAngleComple2 = toDiagonalAngle2 + degrees2
            
            let sinfValue = sinf(degreesToRadians(toDiagonalAngleComple2))
            let sinfValue2 = sinf(degreesToRadians(toDiagonalAngleComple))
            
            finalHeight = abs(toDiagonal * sinfValue)
            finalWidth = abs(toDiagonal * sinfValue2)
            
            let side1 = width * sinf(degreesToRadians(degrees2)) + height * cosf(degreesToRadians(degrees2))
            let side2 = height * sinf(degreesToRadians(degrees2))
            
            t1 = CGAffineTransform(translationX: CGFloat(side1), y: CGFloat(side2))
            
        } else if degrees >= -90 && degrees < 0 {
            
            let degrees2 = Float(degrees - 90)
            let degrees2abs = Float(abs(degrees))
            
            toDiagonalAngleComple = toDiagonalAngle + degrees2
            toDiagonalAngleComple2 = toDiagonalAngle2 + degrees2
            
            let sinfValue = sinf(degreesToRadians(toDiagonalAngleComple2))
            let sinfValue2 = sinf(degreesToRadians(toDiagonalAngleComple))
            
            finalHeight = abs(toDiagonal * sinfValue)
            finalWidth = abs(toDiagonal * sinfValue2)
            
            let side1 = 0
            let side2 = width * sinf(degreesToRadians(degrees2abs))
            
            t1 = CGAffineTransform(translationX: CGFloat(side1), y: CGFloat(side2))
            
        } else if degrees >= -180 && degrees < -90 {
            
            let degreesabs = Float(abs(degrees))
            let degreesPlus = degreesabs - 90
            
            toDiagonalAngleComple = toDiagonalAngle + Float(degrees)
            toDiagonalAngleComple2 = toDiagonalAngle2 + Float(degrees)
            
            let sinfValue = sinf(degreesToRadians(toDiagonalAngleComple))
            let sinfValue2 = sinf(degreesToRadians(toDiagonalAngleComple2))
            
            finalHeight = abs(toDiagonal * sinfValue)
            finalWidth = abs(toDiagonal * sinfValue2)
            
            let side1 = width * sinf(degreesToRadians(degreesPlus))
            let side2 = height * sinf(degreesToRadians(degreesPlus)) + width * cosf(degreesToRadians(degreesPlus))
            
            t1 = CGAffineTransform(translationX: CGFloat(side1), y: CGFloat(side2))
        }
        
        t2 = t1!.rotated(by: CGFloat(degreesToRadians(Float(degrees))))
        
        
        //        let imglogo = UIImage(named: "image.png")
        let imglayer = CALayer()
        imglayer.contents = drawingImageView?.image?.cgImage
        imglayer.frame = CGRect(x: 0, y: 0, width: Int(CGFloat(finalWidth)), height: Int(CGFloat( finalHeight)))
        
        let textlayer = CALayer()
        textlayer.contents = stickerImageView.renderTextOnView(stickerImageView)?.cgImage
        textlayer.frame = CGRect(x: 0, y: Int(stickerImageView.bounds.midY) - 60, width: Int(CGFloat(finalWidth)), height: Int(CGFloat( finalHeight)) - 500)
//        print("y coor \(Int(stickerImageView.bounds.midY))")
//        print("y2 coor \(Int(stickerImageView.bounds.maxY))")
//        print("y3 coor \(Int(stickerImageView.bounds.minY))")
        let videolayer = CALayer()
        videolayer.frame = CGRect(x: 0, y: 0, width: CGFloat(finalWidth), height: CGFloat( finalHeight))
        
        let parentlayer = CALayer()
        parentlayer.frame = CGRect(x: 0, y: 0, width: CGFloat(finalWidth), height: CGFloat( finalHeight))
        parentlayer.addSublayer(videolayer)
        parentlayer.addSublayer(imglayer)
        parentlayer.addSublayer(textlayer)
        
        
        
        let layercomposition = AVMutableVideoComposition()
        layercomposition.frameDuration = CMTimeMake(1, 30)
        layercomposition.renderSize = CGSize(width: CGFloat(finalWidth),height: CGFloat( finalHeight))
        //        layercomposition.renderSize = CGSize(width: size.width,height: size.height)
        layercomposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videolayer, in: parentlayer)
        // instruction for watermark
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, composition.duration)
        let videotrack = composition.tracks(withMediaType: AVMediaType.video)[0] as AVAssetTrack
        let layerinstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videotrack)
        layerinstruction.setTransform(t2!, at: kCMTimeZero)
        instruction.layerInstructions = NSArray(object: layerinstruction) as! [AVVideoCompositionLayerInstruction]
        layercomposition.instructions = NSArray(object: instruction) as! [AVVideoCompositionInstructionProtocol]
        
        //  create new file to receive data
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir: AnyObject = dirPaths[0] as NSString
        let movieFilePath = docsDir.appendingPathComponent("tempMovie.mov") as String
        let movieDestinationUrl = NSURL(fileURLWithPath: movieFilePath)
        _ = try? FileManager().removeItem(at: movieDestinationUrl as URL)
        
        let assetExport = AVAssetExportSession(asset: composition, presetName:AVAssetExportPresetHighestQuality)
        assetExport?.videoComposition = layercomposition
        assetExport?.outputFileType = AVFileType.mov
        assetExport?.outputURL = movieDestinationUrl as URL
        assetExport?.exportAsynchronously(completionHandler: {
            switch assetExport!.status{
            case .failed:
                
                print("failed \(String(describing: assetExport?.error))")
            case .cancelled:
                
                print("cancelled \(String(describing: assetExport?.error))")
            default:
                print("Movie complete")
                
                
                 //play video
                OperationQueue.main.addOperation({ () -> Void in
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: movieDestinationUrl as URL)
                    }) { saved, error in
                        if saved {
                            let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                    
                })
                
                
            }
        })
        return movieDestinationUrl as URL
    }
    
    func degreesToRadians(_ input: Float) -> Float {
        let float: Float = 180
        return Float(input) * .pi / float
    }
    
    func radiansToDegrees(_ input: Float) -> Float {
        return Float(input) * 180 / .pi
    }
    
    func videoPreviewUIImage(moviePath: URL) -> UIImage? {
        let asset = AVURLAsset(url: moviePath)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let timestamp = CMTime(seconds: 2, preferredTimescale: 60)
        if let imageRef = try? generator.copyCGImage(at: timestamp, actualTime: nil) {
            return UIImage(cgImage: imageRef)
        } else {
            return nil
        }
    }
   
    

}
