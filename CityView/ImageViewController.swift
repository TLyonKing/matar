//
//  ImageViewController.swift
//  CityView
//
//  Created by admin on 6/30/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
//import JOEmojiableBtn
class ImageViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    var long: Double = 0.0
    var lat: Double = 0.0
    let ref = Database.database().reference(withPath: "posts-items")
    @IBOutlet weak var locationtext: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var previewImageView: UIImageView!
    let locationManager = CLLocationManager()
    var image: UIImage?
    var videoURL: URL?
//    var btn:JOEmojiableBtn?
//    var imageReactionName = ["img_1","img_2","img_3","img_4","img_5","img_6"]
    var emotionString:String?
    var mediaType:String = ""
//    let currentLevelKey = "currentLevel"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        previewImageView.image = image
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(ImageViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ImageViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        videoURL = nil
        image = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        print("LOCATION")
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines as! [String]
                self.locationtext.text = lines.joined(separator: "\n")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        if let location = locations.first {
            reverseGeocodeCoordinate(location.coordinate)
            long = location.coordinate.longitude
            lat = location.coordinate.latitude
            locationManager.stopUpdatingLocation()
        }
    }
    
    @IBAction func post(_ sender: Any) {
        
//        if preferences.object(forKey: currentLevelKey) == nil {
//            //  Doesn't exist
//        } else {
//            let currentLevel = preferences.string(forKey: currentLevelKey)
//        }
        let time = getTodayString()
        let latitude :String = String(format:"%f", lat)
        let longitude :String = String(format:"%f", long)
        let text = captionTextView.text
        let uploadImage = image
        self.emotionString = self.mediaType
        
        if emotionString == "photo" {
            let imageName = UUID().uuidString
            let storageRef = Storage.storage().reference().child("place_images").child("\(imageName).jpg")
            let meta = StorageMetadata()
            meta.contentType = "image/jpg"
            if let profileImage = image, let uploadData = UIImageJPEGRepresentation(uploadImage!, 0.1) {
                
                //            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
                
                storageRef.putData(uploadData, metadata: meta, completion: { (metadata, error) in
                    
                    if error != nil {
                        print("The erRRorRRRRR\(error!)")
                        return
                    }
                    //                if (self.emotionString?.isEmpty)!{
                    //                    self.emotionString = "dislike"
                    //                }
                    if let imageUrl = metadata?.downloadURL()?.absoluteString {
                        //                    var user =
                        let postItem = Posts(id: time, text: text!, image: imageUrl, lat: latitude, long: longitude, emotion: self.mediaType)
                        //                    let postItem = Posts(id: time, uid: user.id, text: text!, image: imageUrl, lat: latitude, long: longitude, emotion: self.emotionString!)
                        let postsItemRef = self.ref.child(postItem.id)
                        postsItemRef.setValue(postItem.toAnyObject())
                    }
                    
                })
            }

        }else if emotionString == "video"{
            let filename = UUID().uuidString + ".mov"
//            let meta = StorageMetadata()
//            meta.contentType = "video/mov"
            let uploadTask = Storage.storage().reference().child(filename).putFile(from: videoURL!, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print("Failed upload of video:", error!)
                    return
                }
                
                if let videoUploadUrl = metadata?.downloadURL()?.absoluteString {
//                    if let thumbnailImage = self.thumbnailImageForFileUrl(self.videoURL!) {
//                        
//                        self.uploadToFirebaseStorageUsingImage(thumbnailImage, completion: { (imageUrl) in
//                            let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": thumbnailImage.size.width as AnyObject, "imageHeight": thumbnailImage.size.height as AnyObject, "videoUrl": videoUrl as AnyObject]
//                            self.sendMessageWithProperties(properties)
//                            
//                        })
//                    }
                    let postItem = Posts(id: time, text: text!, image: videoUploadUrl, lat: latitude, long: longitude, emotion: self.mediaType)
                    //                    let postItem = Posts(id: time, uid: user.id, text: text!, image: imageUrl, lat: latitude, long: longitude, emotion: self.emotionString!)
                    let postsItemRef = self.ref.child(postItem.id)
                    postsItemRef.setValue(postItem.toAnyObject())
                    print("videoURL: " + String(videoUploadUrl))
                }
            })

            
        }
        
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        emotionString=""
       self.present(vc, animated: true, completion: nil)
    }
    
    func getTodayString() -> String{
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
        
        return today_string
        
    }
    
    @IBAction func back(_ sender: Any) {
        emotionString=""
        self.dismiss(animated: true, completion: nil)
    }
    
   

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height/2 + 5
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height/2 + 5
            }
        }
    }
    
    @objc func dismissKeyboard(_ sender: Any) {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}


